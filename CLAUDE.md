# Working on mpif

Instructions for an agent working in this repository.

- `CODE.md` — what the code is and why the odd-looking arrangements are right.
- `MISSING.md` — what mpif gets wrong, does not do, or has decided not to do.
- `HISTORY.md` — condensed record of past failures, withdrawn diagnoses and the
  lessons they left. The other three files describe the current state only.

mpif is a standalone Fortran binding for the MPI standard ABI: it provides
`mpif.h`, the `mpi` module and the `mpi_f08` module on top of an MPI
implementation's C library, with no help from that implementation's own Fortran
bindings, which the installs here prune away.

## This machine

- macOS 26.6 (Darwin 25.6.0), arm64, 12 cores, 36 GiB
- gfortran: `/opt/local/bin/gfortran-mp-15` (MacPorts gcc 15)
- flang: `/opt/local/bin/flang-mp-22` (MacPorts `llvm` toolchain)
- julia 1.12, for `dev/mpiapi.jl` and `dev/check-f08-bindings.jl`
- pdftotext: `/opt/local/bin/pdftotext` (MacPorts poppler)

Two implementations × two toolchains gives four local variants;
`<variant>` is `<mpi>-<toolchain>` entire, e.g. `mpich-gcc`. `build/` is
grouped by *stage*, so each stage can be rebuilt and rerun without disturbing
the others:

    build/mpi/<variant>              the MPI               4
    build/mpi-src/<variant>          its unpacked source   4
    build/mpif/<variant>             mpif itself           4
    build/mpif-build/<variant>       mpif's CMake tree     4
    build/test/<variant>-run-<r>     test/                 8
    build/suite/<variant>-run-<r>    the MPICH suite       8
    build/consume/<variant>          the consume test      4

`<r>` is the *runtime* MPI: one installed mpif serves both implementations, and
both pairings are measured. A sanitizer build appends `-sanitize-address` to
the variant; it gets no `mpi`/`mpi-src` of its own and builds against the
shared, uninstrumented `build/mpi/mpich-llvm`.

- `rm -rf build` starts over. The ignore rule is `/build*/`, anchored, so a
  stray build tree anywhere else shows up in `git status`.
- The MPI and mpif stages leave an `install-complete` marker in their prefix
  and skip when it exists; `MPIF_REBUILD=1` rebuilds anyway. See "Build-stage
  caching" below for the failure mode this admits.
- CI and the Docker images keep their own directory layouts, deliberately —
  see `MISSING.md`.
- `kern.aioprocmax` is 16 here (tens of thousands on Linux), which is why the
  Open MPI aio defect fixed by `ci-scripts/openmpi-fbtl-posix-aio.patch`
  surfaced on macOS and nowhere else.
- CI runs twelve variants natively, plus a 32-bit i386 container and a FreeBSD
  VM. This machine is `<mpi>/<toolchain>/darwin/26/arm64`, which is *not* one
  of CI's rows; do not expect the suite baseline table to match a local run.

**This machine's own name does not resolve to this machine.** `gethostname()`
returns `Mac.pitp.io`, and the DNS this network hands out answers that with an
address on a different subnet than the one `en0` holds. Both halves move, so
check rather than trust:

    python3 -c 'import socket; h=socket.gethostname(); \
        print(h, sorted({a[4][0] for a in socket.getaddrinfo(h,None)}))'
    ifconfig | awk "/inet /{print \$2}" | sort -u

If the first prints an address the second does not list, MPICH's spawn tests
cannot pass without help: the symptom is one 180-second
`MPIDI_Create_inter_root_communicator_connect(316): Connection timed out`
per test, and `MISSING.md` "MPICH: a spawned child connects back to whatever
`gethostname()` resolves to" has the diagnosis.
`scripts/macos-test-mpich-suite.sh` exports
`MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE=lo0` for MPICH, so the scripted run is
covered; a hand-run `runtests` has to set it itself. Open MPI is already
pinned to `lo0`, and mpif's own `test/` never spawns.

## Preferences

- **Commit on `main`.** No feature branches. Do not push unless asked.
- **Write the commit subject in the imperative** — what applying the commit
  *does*. One line, short enough for `git log --oneline`; reasoning goes in
  the body after a blank line.
- **Ask the standard.** MPI-5.0 is the authority, not what an implementation
  does and not what seems reasonable. Keep a copy at `doc/mpi50-report.pdf`
  (git-ignored); `pdftotext -layout` makes it greppable.
- **Do not build what nothing needs.** If the only caller of a new name is the
  test written to justify it, that is the answer. `nm` on MPICH's and
  Open MPI's libraries settles most such questions in a minute.
- **Say what was measured and what was inferred.** Both are fine; conflating
  them is not.
- **Record decisions, not just defects.** "Not doing X, because Y" belongs in
  `MISSING.md` with its reason; an unrecorded decision is indistinguishable
  from an oversight.

## Checking a claim

- Signatures are `data/apis.json`'s business: the generator reads it, and
  hand-written bindings are checked against it. The standard is what makes the
  JSON's kinds legible — e.g. `C_BUFFER` is an address in `MPI_Alloc_mem` and
  `C_BUFFER2` a choice buffer in `MPI_Buffer_detach`, and only the standard
  says which.
- Two checks need no build:

      julia dev/check-f08-bindings.jl   # every mpi_f08 declaration against MPI-5.0
      bash ci-scripts/check-headers.sh  # Cray pointers against their common blocks

  The first reads `doc/mpi50-report.pdf` and compares intents, declared types,
  `VALUE`, argument names and argument order against the standard's
  appendices: `gen/mpif_f08_functions.F90` against A.4, the callback abstract
  interfaces of `src/mpif_f08_types.F90` against A.1.3, the predefined
  callbacks of `src/mpif_f08_attr_fns.F90` against A.4, and the PMPI forms of
  the first and third against the same appendices under their twins' names.
  It also compares the 1180 f08 specifics' two declarations — interface and
  body — against each other, and exits nonzero on anything it cannot account
  for. Run it after changing how any f08 argument is declared, generated or
  not. It needs the git-ignored PDF, so it cannot run in CI.

  The second is CI's `checks` job and is the only thing that catches a
  `pointer (P, X)` whose name does not match its `common /P/ P`: both
  spellings are valid Fortran, and the mismatch silently leaves `X` at an
  arbitrary address that MPI then writes through.
- **Never edit `gen/` by hand.** It is generated and committed. Edit
  `dev/mpiapi.jl` and run `julia dev/mpiapi.jl` from the repo root.
- **A generator change that should not alter existing output has to be shown
  not to.** `git diff gen/` misleads when a change adds a near-copy of every
  routine (git aligns the copy against the original and reports thousands of
  phantom deletions). Turn the new axis off instead — e.g. shorten the
  `for pmpi in [false, true]` loop — regenerate, and require `git diff gen/`
  to be empty.

## Building and testing

    bash scripts/macos-build-mpif.sh   <mpich|openmpi> <gcc|llvm>   # build and install mpif
    bash scripts/macos-test-mpif.sh    <mpich|openmpi> <gcc|llvm> [<run-mpi>]
    bash scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm> [<run-mpi>]
    bash scripts/macos-test-consume.sh <mpich|openmpi> <gcc|llvm>

    bash dev/build-macos-all.sh [mpi|mpif|test|suite|consume|sanitize|all ...]

- The first two arguments name the mpif under test; the optional third names
  the MPI the tests *run* against and defaults to the first. A cross run's
  results must match the runtime MPI's native results exactly. `test/`
  cross-runs swap the loader's search path under unchanged binaries; the suite
  relinks, through the `MPIF_MPI_PREFIX` the wrapper reads from the
  environment. See "Choosing the MPI at run time" in `CODE.md`.
- `dev/build-macos-all.sh` drives the matrix a stage at a time; with no
  argument it does all of them in order. Build stages skip when marked
  complete, so `dev/build-macos-all.sh test` will not notice an edit to
  `src/`; `MPIF_REBUILD=1 dev/build-macos-all.sh mpif test` will.
- `test/` is mpif's own and should be entirely green. The MPICH suite is the
  broad one; see "Suite baseline" in `MISSING.md`.
- Installing an MPI is `scripts/macos-install-mpi.sh <mpich|openmpi>
  <gcc|llvm>` — it builds from source and is expensive. Run it when
  `find_package(MPI)` reports that `build/mpi/<variant>/include` does not
  exist. **A missing `build/mpi/<variant>` means the last install failed**;
  the scripts discard a prefix their run did not finish, so the cure is to
  run the install again.
- **Never `make install` an MPI into `build/mpi/<variant>` by hand.** The
  install script afterwards repoints the wrapper compilers at the ABI
  library, prunes the implementation's own headers, Fortran modules and
  non-ABI libraries, and installs the official ABI `mpi.h`. Skipping those
  produces a prefix that builds everything and quietly disagrees with mpif
  about what a handle is. `ci-scripts/check-mpi-install.sh` detects it in a
  second, and both `test-mpich-suite.sh` and `scripts/macos-build-mpif.sh`
  run it before anything expensive.
- **Do not edit an install script while it is running** (bash reads scripts
  incrementally by byte offset), and do not stop one with a bare
  `pkill -f <script>`: the orphaned `configure`/`make` keep writing into the
  source tree, and the next run's `rm -rf` then fails on "Directory not
  empty", which looks like a build error and is not. Check `ps` for the
  source directory's path first; if a tree is half-removed, delete
  `build/mpi-src/<variant>` outright.
- **If either the prefix or the source-tree path is ever moved**, the
  surviving `build/mpi-src` trees still record the old prefix in their link
  output (MPICH's libtool relinks nothing on a re-`configure`). Delete the
  link output and rebuild:

      find <tree> \( -name '*.o' -o -name '*.lo' -o -name '*.a' -o -name '*.la' \
                  -o -name '*.dylib' \) -delete
      find <tree> -type d -name .libs -exec rm -rf {} +

To run one directory of the suite rather than all of it:

    cd build/suite/<variant>-run-<runtime>/mpich-5.0.1/test/mpi/f90/rma
    MPIF_REAL_MPIEXEC=<mpi-prefix>/bin/mpiexec ../../runtests -tests=testlist \
        -mpiexec=<repo>/ci-scripts/suite/mpiexec-filter.sh -maxnp=4

- A hand-run `runtests` gets none of what the wrapper scripts export: add
  `MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE=lo0` for MPICH, or `MPIEXEC_ARGS` as
  `scripts/macos-test-mpich-suite.sh` sets it for Open MPI, whenever the
  directory contains spawn tests. See "This machine" above for why.
- **Only one suite run per pairing at a time**: two runs of the same pairing
  share one tree and destroy each other's executables, and the scripted run
  additionally re-unpacks the suite at the start. Different pairings (and the
  sanitizer variants) are different trees and can run concurrently.
- `MPIF_KEEP_TESTS=1` stops `runtests` deleting each executable after it
  runs — what a debugger needs to turn "test failed" into a backtrace.
- `MPIF_SANITIZE=address` on the build and test scripts builds and tests an
  AddressSanitizer mpif as a fifth variant (`llvm` only; MacPorts GCC ships no
  libsanitizer on macOS, and CMake stops rather than producing an
  uninstrumented build under a sanitizer name). See "Verifying a fix" below
  and "Sanitizer builds" in `CODE.md`.

### Suite gating

- What fails a suite run is a *difference* from
  `ci-scripts/suite/mpich-suite-xfail.txt`, in either direction — a test that
  starts passing is caught as well as one that starts failing, so the list
  cannot rot into a blanket exception. The file names every expected failure
  with its reason; comparison is by name, not by count.
- A variant with no `triaged` line in that file is compared and reported but
  cannot fail the run — how an unmeasured variant stays honest rather than
  papered over.
- The variant key is `<mpi>/<toolchain>/<os>/<os-version>/<arch>`, detected
  rather than passed in (the implementation from its installed binaries, the
  toolchain from mpif's own `mpifort`, the rest from the system). A component
  that cannot be worked out becomes `unknown`, which matches no entry, so the
  run is loudly wrong rather than quietly lenient. The OS version is in the
  key because environments that agree on everything else still disagree
  across versions.

## Verifying a fix

- `test/` is built `-O0`, which hides any defect whose symptom is the
  *caller's* code being optimised differently — e.g. a wrong INTENT letting
  the compiler delete the caller's store. `test/status_error_f08.f90` is
  compiled `-O2` on purpose; do the same for any test whose assertion is
  about what the caller is allowed to assume.
- **Put the bug back**: revert the change, rebuild, and confirm the new test
  fails — ideally with the same message the original failure gave. This has
  caught tests that passed either way and were therefore worthless.
- For a bug in the generator, put it back the same way: edit `dev/mpiapi.jl`
  and rerun it, never `gen/`.
- For memory errors, the sanitizer build is the first thing to reach for when
  the suspect is mpif's own code:

      MPIF_SANITIZE=address bash scripts/macos-build-mpif.sh mpich llvm
      MPIF_SANITIZE=address bash scripts/macos-test-mpif.sh  mpich llvm

  It installs beside the ordinary build — its own build tree and prefix, both
  tagged `-sanitize-address` — so both are available without a rebuild.
  Where the faulting write is *inside libmpi*, ASan sees nothing unless the
  write goes through an intercepted libc routine; a guard page works there —
  `mmap` two pages, `mprotect` the second `PROT_NONE`, place the buffer so
  its last byte ends the first page. For uninitialised memory neither
  instrument helps, and MSan cannot be run here at all — see `MISSING.md`
  "MemorySanitizer cannot be run against an MPI".

## Build-stage caching

The two *build* stages skip when their prefix carries an `install-complete`
marker; the test, suite and consume trees are deleted and rebuilt on every
run. Consequences:

- **Edit a binding, rerun a test stage, and it tests the old mpif and
  passes.** The marker is a plain file, not a checksum — deliberately, since
  a complete checksum is impossible here (see `MISSING.md` "The local build
  stages skip when already installed"). What replaces prevention is
  provenance: each marker records time, commit and dirtiness, each mpif
  marker names the MPI marker it was built against, and every consuming
  stage prints what it found. When in doubt, `MPIF_REBUILD=1`.
- `runtests` rebuilds a test only when its executable is **missing**, so a
  leftover executable is silently relinked or rerun against a new library —
  the `util/` libraries (`libmtest_f08.a` and friends) matter as much as the
  tests. The test scripts delete their trees first, which is why they exist.
- `ctest` on its own does **not** rebuild.
  `ctest --test-dir build/test/<variant>-run-<runtime>` happily reruns a
  binary built against a previous mpif and reports a pass. Use
  `scripts/macos-test-mpif.sh`, which reconfigures and rebuilds first.

Stale build artifacts were once the biggest time sink here; `HISTORY.md` has
the record.

## Containers

**Verify a container's behaviour the way the build will run it.** A `RUN`
step in `docker build --platform linux/386` gets no 32-bit personality —
`uname -m` reports the host's `x86_64` — while `docker run --platform
linux/386` sets one and reports `i686`. `linux32`/`setarch` cannot patch over
it: they fail inside the container, and as a `SHELL` would fail every `RUN`.
Instead `MPIF_SUITE_ARCH` overrides `uname -m` for the variant key's
architecture component, set to `i686` in `docker/mpich-gcc-i386.dockerfile`;
the other four components stay detected. Where a probe cannot be run the way
the build runs it (this machine is arm64, so 32-bit x86 goes through qemu
locally where CI runs it natively), say so, and prefer a mechanism that does
not depend on the difference.

## Writing in CLAUDE.md, CODE.md, MISSING.md and HISTORY.md

- Be brief. Prefer itemized lists; use prose only where a list would obscure
  an argument.
- These files describe the **current state only**. Past failures, withdrawn
  diagnoses and how a fix was verified at the time go to `HISTORY.md`,
  condensed to a few lines each — or are dropped.
- Decisions still get recorded: "not doing X, because Y" stays in
  `MISSING.md`, in a sentence or two.
- Name the file and line where a reader can check; quote the standard where
  it decides something.
- Say what was measured and what was inferred.
- Do not write down counts that rot (numbers of entries, tests, modules)
  unless something checks them; give the command that counts instead.
