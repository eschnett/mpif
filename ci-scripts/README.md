# `ci-scripts/`

What CI and the Docker images run, and what the local scripts in `scripts/` call
into so that all three build mpif the same way. Nothing here is specific to a
runner: every script takes its prefixes as arguments or reads them from the
environment, so the same recipe works on a GitHub runner, inside a Docker build
and on a laptop.

## Two parts, and why

    ci-scripts/            building and installing an MPI
    ci-scripts/suite/      running MPICH's Fortran test suite against it

(Some of the files here belong to neither: `install-mpi-stubs.sh`,
`compile-only.sh` and `check-configure-probes.sh` build no MPI and run no suite,
and neither do `check-sanitizer-build.sh`, `check-static-build.sh`,
`check-package-config.sh` and `check-pkg-config.sh`, which ask whether a build
came out the way it was asked for. All of them are in the cache key, which costs an MPI rebuild when one
of them changes and is the safe direction; see "Compiling under another
compiler" below.)

The division is not tidiness. Both are expensive -- building an MPI from source
takes minutes per variant, and building MPICH's suite takes minutes more -- and
both are cached, in CI by a key and in Docker by layers. Everything the MPI build
reads has to be in that cache key, and nothing else may be, or an unrelated edit
throws the build away.

The three files under `suite/` are read only after an MPI exists and cannot change
it: the runner, the list of expected failures and the `mpiexec` filter. Keeping
them in a directory of their own is what lets both caches say "the MPI build
depends on `ci-scripts/` and not on `ci-scripts/suite/`":

- `.github/workflows/ci.yaml` hashes this directory and `fortran/**` into the key
  for the MPI installation cache, excluding `suite/` and this README:

      hashFiles('ci-scripts/**', '!ci-scripts/suite/**', '!ci-scripts/README.md', 'fortran/**')

  Not `ci-scripts/*`, which looks like it stops at this directory's own files and
  does not: that pattern matches the *directory* `suite`, and `@actions/glob`
  expands a matched directory to all of its descendants, so the suite's files stay
  in the key and every edit to the expected-failures list rebuilds MPI on twelve
  variants. It took a CI run to notice, and the way to tell is in the log: the
  cache step prints the key, so if a suite-only commit changes that hash, the
  pattern is wrong again.
- each `docker/*.dockerfile` copies `ci-scripts/*.sh ci-scripts/*.txt
  ci-scripts/*.patch` before the MPI build, and `ci-scripts/suite` only at the end,
  after the MPI and mpif are both built.

Both are patterns rather than lists of filenames, and deliberately. A key that
names its inputs rots silently: a new install input left out of it would be served
an MPI built without it. A pattern covers a new file automatically, and in Docker
a file that is somehow missing fails the build rather than the run.

This is worth keeping right, and it has been wrong twice. First both the key and
the `COPY` took all of `ci-scripts/**`, so editing one reason in
`mpich-suite-xfail.txt` rebuilt MPI on all twelve CI variants and rebuilt every
Docker image from the MPI up. Then the key was narrowed to `ci-scripts/*`, which
fixed nothing for the reason above, while the Docker half really was fixed -- the
same intention expressed twice, right in one place and wrong in the other, and only
a CI run told them apart.

One input is deliberately *not* in the key: which compiler version CI installs.
That lives in `.github/actions/setup-toolchain/action.yml`, outside this
directory, so bumping `llvm.sh 21` serves a cached MPI built with the old one.
Closing the hole would mean hashing the action too, and paying twelve MPI
rebuilds for a comment edit there; bump the key prefix by hand when a compiler
moves. The action being outside this directory is otherwise exactly what is
wanted -- editing it must not throw the caches away, which is the `suite/`
argument from the other side.

So: a new file that the MPI build reads belongs here, and a new file that only the
suite needs belongs in `suite/`. Putting a suite file here costs a rebuild;
putting an install file in `suite/` is the one that is dangerous, since CI would
then cache an MPI that does not reflect it.

## The files

Building and installing an MPI:

| file | what it does |
|------|--------------|
| `install-mpich.sh` | clone `main` at the pinned commit, configure, build and install MPICH for the standard ABI. It carries no patches at the moment -- MISSING.md "MPICH is built from `main`" says what it used to carry and where each went |
| `install-openmpi.sh` | the same for Open MPI |
| `install-mpi-header.sh` | install the MPI Forum's official ABI `mpi.h` over the implementation's own |
| `prune-install.sh` | delete everything the standard ABI does not define, from a list |
| `mpich-prune.txt`, `openmpi-prune.txt` | those lists |
| `openmpi-*.patch` | fixes carried against the pinned upstream trees; each says in its preamble what it is and why, and MISSING.md has the stories. `git apply` refuses fuzz, so one stops applying the day upstream moves the code under it -- which is how the MPICH ones were retired |
| `check-mpi-install.sh` | assert that what was installed is the standard ABI and nothing else |
| `check-headers.sh` | check that every sentinel COMMON block in `mpif_constants.h` and `mpif_f08_types.F90` has its storage in `mpif_constants.c`, and that the set is MPI-5.0 §2.5.4's ten; run by the `checks` job in CI, and needs no MPI or compiler |
| `flang-darwin-shim.sh` | works around flang's `-Wl,` handling on macOS, for MPICH's libtool |

Both install scripts take the prefix to install into, and both understand
`MPI_PREPARE_ONLY=1`, which stops after preparing the source tree -- that is what
lets CI cache the downloaded and `autogen`'ed tree separately from the build.

Compiling under another compiler, with no MPI at all:

| file | what it does |
|------|--------------|
| `install-mpi-stubs.sh` | build the MPI Forum's ABI stub library into a prefix, with `fortran/f2c_abi_stubs.c` added. Every entry point aborts; what it provides is the official ABI `mpi.h` and a library named `libmpi_abi`, which is all mpif's configure stage insists on |
| `compile-only.sh` | configure, build and install mpif against that prefix, and build `test/` without running it -- once with the CFI probe deciding and once with `-DMPIF_ENABLE_CFI=OFF`, since the two are different generated code |
| `check-configure-probes.sh` | print every configure probe, and fail on the address-kind pair when it disagrees with the pointer width |

This is what the `compile` job runs, one row per compiler. It costs a runner and
no MPI build, which is the whole point: adding a compiler is cheap, and nothing
about the answer depends on a libc, so the old-gfortran rows are plain
containers. It answers only "does configure detect this compiler correctly and
does the code compile" -- the `mpif`, `suite` and `cross` stages are what
answer anything about behaviour.

Asking whether a build came out as asked, with no MPI built and no MPI program
run:

| file | what it does |
|------|--------------|
| `check-sanitizer-build.sh` | read the installed library for undefined `__asan_*`/`__ubsan_*` references. A sanitizer build whose flags never reached the compiler passes every test, which is what a correct one does on clean code, so no test can tell them apart |
| `check-static-build.sh` | assert that a `-DBUILD_SHARED_LIBS=OFF` prefix holds an archive and no shared library, that `bin/mpif_info` names `libmpi_abi` and not `libmpif` among its dynamic dependencies, that every sentinel cell in it is read-only, and that no archive member defines more than one MPI entry point. The read-only one is what nothing else catches: if `mpif_constants.c`'s member never comes out of the archive the program still works, and silently loses the read-only fault and the poison behind every sentinel translation. The one-entry-point-per-member one is MPI-5.0 §15.2.1(4). See "Static linking" in CODE.md |
| `check-package-config.sh` | configure three throwaway projects against an installed prefix: `find_package(mpif QUIET)` with no `libmpi_abi` to be found must leave the consumer configuring with `mpif_FOUND` false and a reason set, the same absence under `REQUIRED` must fail and say what to set, and `MPI_HOME` pointing at an MPI must find it and define `mpif::mpif`. `test-consume/` says `REQUIRED` and pins `MPI_mpi_abi_LIBRARY`, so it passes whether the config file reports a failure or raises one, and never reaches the `find_library` fallback. See "Choosing the MPI at run time" in CODE.md |
| `check-pkg-config.sh` | the same question for `lib/pkgconfig/mpif.pc`, the third consumption route, which nothing else here reads: that it installs and parses, that `--modversion` agrees with `bin/mpifort`, that `--cflags` names a directory holding `mpif.h` and `mpi_f08.mod` and carries no Fortran-only flag, that `--libs` carries both libraries, both `-L`, both rpaths and the platform link flag, that `--define-variable=mpi_prefix` redirects the MPI, and that what the file reports and what the wrapper reports are the same tokens -- the two are generated from separate templates. Alone in this table it also *runs* something: it compiles and links `test-consume/consume_f08.f90` with plain `$FC` and these flags alone and runs it with `LD_LIBRARY_PATH` and `DYLD_LIBRARY_PATH` cleared, because `--libs` is worthless if the executable it produces cannot start. Skips its query legs, with a reason printed, when no `pkg-config` is on `PATH`. See "Choosing the MPI at run time" in CODE.md |

The first two are called by `scripts/macos-build-mpif.sh` as well as by CI, so a
local build of either kind is held to the same thing; the last two are called by
`scripts/macos-test-consume.sh` and by CI's `static` job, beside the
`test-consume/` build they complement.

One script is not a check but a build step:

| file | what it does |
|------|--------------|
| `split-wrappers.sh` | cut a marked source file into one translation unit per `MPI_` entry point, so that a profiling wrapper can replace one without colliding with the archive member the link needs for the rest. Run by CMake at configure time when `MPIF_SPLIT_WRAPPERS` is on, which is whenever `BUILD_SHARED_LIBS` is off; see "Separable wrappers" in CODE.md |

Running the suite, in `suite/`:

| file | what it does |
|------|--------------|
| `test-mpich-suite.sh` | download, build and run MPICH's Fortran suite against an installed mpif, then compare the result with the list below |
| `mpich-suite-xfail.txt` | every expected failure, per variant, with the reason it is expected. A variant is `<mpi>/<toolchain>/<os>/<os-version>/<arch>`, detected by the runner above; the version is in the key because the images and CI's runners are different releases and disagree |
| `mpiexec-filter.sh` | drop the launcher banner Open MPI prints on every run, which the suite would otherwise read as test output |

`test-mpich-suite.sh` takes the MPI prefix and the mpif prefix. It reads
`MPICH_VERSION` out of `install-mpich.sh` one directory up -- the last release,
not the `MPICH_COMMIT` the library is built from. The tests are deliberately
held still while the library moves, so that bumping the commit is one variable
against one expected-failure list; see MISSING.md "MPICH is built from `main`".

It compiles each language's tests with `make -k -j` before running any of them,
rather than leaving that to `runtests`, which builds one test at a time. Most of
a suite run is that compiling, not MPI. To re-measure that share, run with
`MPIF_SUITE_PREBUILD=0` -- which restores the on-demand behaviour, and is also
what puts each test's compiler output beside that test in the log -- and sum the
per-test `time=` fields of a `tap-*.txt` against the wall time its
`runtests-*.log` reports: with the build on demand the difference is the
compiler. The switch has to be off for that, because with the prebuild the
compiling has already happened and the same subtraction measures only what is
left.

Measured with that switch, `mpich/gcc/darwin/26/arm64`, twelve cores: 660 s
becomes 419 s, the three sweeps going 146/179/186 s to 52/58/64 s, with the same
tests passing and failing either way. So the parallel build is about 3.5x on this
machine and the remaining 174 s is the tests actually running. Expect less on the
three-core macOS runners and more under qemu, where the containers build.

A test that does not compile is reported by `runtests` either way -- it finds no
executable and builds it itself -- so the expected-failures comparison sees no
difference. Verified by breaking one test on purpose: the prebuild fails it,
keeps going for the rest of the directory, and `runtests` still records
`not ok 4 - ./sendf08 2` with the compiler output and the offending line beneath
it.

What does change is where those errors appear. Some expected failures *are*
build failures -- `attrmpi1f08` on every 64-bit architecture is one, and the
FreeBSD job shows it for real -- so the prebuild now prints their compiler
diagnostics in a batch of its own, ahead of the tests, as well as against the
failing test in the TAP where they were before. A log that opens with
`error: Semantic errors in attrmpi1f08.f90` is the expected state, not a
regression; the verdict is still the comparison line at the end.

## Where else these are used

- `.github/workflows/ci.yaml` -- twelve variants natively, and the authority on
  what mpif supports, plus two the matrix cannot express. One is built in a
  container: the 32-bit i386 one, which a matrix entry cannot express because the
  suite's variant key ends in `uname -m` and a `-m32` build on an x86_64 runner
  still says `x86_64`. The other is FreeBSD, which has no runner at all, so the
  `freebsd` job boots a VM on an Ubuntu one and runs these same scripts inside
  it; MISSING.md "FreeBSD is tested in a VM" says what that job does differently
  and why, and it is the reason the scripts here say `#!/usr/bin/env bash` rather
  than `#!/bin/bash`. The `compile` rows compile mpif under other compilers and
  run nothing, reported and not gating until each has been green.

  Those twelve variants are four stages deep, one job per variant per stage:
  `mpi` installs an MPI, `mpif` builds mpif and runs `test/`, and `suite` and
  `cross` then run concurrently -- so nothing waits on a suite run it has no use
  for. `cross` is one leg per *direction*, mpif built against one implementation
  and run against the other, gated against the runtime MPI's rows of the
  expected-failures list. `compare` asserts that the two mpif installations of a
  pairing are the same installation; `sanitize` needs stage one alone. The
  variant lists are written out once per stage, and the `checks` job asserts they
  agree -- they decide which rows of the expected-failures list gate.

  What crosses a job boundary is the installed prefix, as an artifact, through
  `.github/actions/upload-prefix` and `restore-prefix`. Those two also hold the
  assertions the split makes necessary: that `$RUNNER_TEMP` is the same directory
  in the consumer, since every path baked into a prefix names it, and that an
  mpif prefix's Fortran compiler is the consumer's, since module files are
  compiler-version-specific and producer and consumer are no longer one job.
- `docker/*.dockerfile` -- Linux variants, not a cross product. arm64v8 carries
  the full four (MPICH and Open MPI, gcc and flang); amd64 carries Open MPI with
  gcc alone; nothing records why the other three are missing there, so do not
  read the gap as a decision. Two are the 32-bit ABIs: the i386 that CI runs in
  a container, and the arm32v7 that CI has no runner for and that qemu makes too
  slow to run per push. Both 32-bit ones are MPICH-only, Open MPI having dropped
  32-bit environments. The last is `mpich-gcc-static-arm64v8`, which is
  `mpich-gcc-arm64v8` with `-DBUILD_SHARED_LIBS=OFF` and nothing else changed, so
  that a difference between the two is a difference static linking made. It is
  the only place the MPICH suite runs against an archive, which is what exercises
  the separable members of `split-wrappers.sh` at the granularity the suite's
  three `profile` tests need.
- `scripts/macos-*.sh` -- the same recipes locally; see "Working on this" in
  MISSING.md.
