# Working on mpif

Instructions for an agent working in this repository. `CODE.md` describes what the
code is; `MISSING.md` records what it still gets wrong or does not do.

mpif is a standalone Fortran binding for the MPI standard ABI: it provides
`mpif.h`, the `mpi` module and the `mpi_f08` module on top of an MPI
implementation's C library, with no help from that implementation's own Fortran
bindings, which the installs here prune away.

## This machine

    macOS 26.5 (Darwin 25.5.0), arm64, 12 cores, 36 GiB
    gfortran   /opt/local/bin/gfortran-mp-15    MacPorts gcc 15.2
    flang      /opt/local/bin/flang-mp-22       MacPorts, the `llvm` toolchain
    julia      1.12, for dev/mpiapi.jl and dev/check-f08-bindings.jl
    pdftotext  /opt/local/bin/pdftotext, from MacPorts poppler

Two implementations times two toolchains gives four local variants, each with its
own prefix under `mpi/`:

    mpi/mpich-gcc  mpi/mpich-llvm  mpi/openmpi-gcc  mpi/openmpi-llvm   the MPI
    mpi/mpif-<variant>                                                mpif itself
    mpi/src-<variant>                                                 unpacked source
    build-<variant>  build-<variant>-tests                            build trees

`kern.aioprocmax` is 16 here, against tens of thousands on Linux, which is why the
Open MPI defect that `ci-scripts/openmpi-fbtl-posix-aio.patch` fixes showed up on
macOS and nowhere else. CI runs twelve variants; this
machine is `<mpi>/<toolchain>/darwin/26/arm64`, which is *not* one of CI's rows --
theirs are macos-15 and Ubuntu. Do not expect the suite baseline table to match a
local run.

## Preferences

- **Commit on `main`.** No feature branches in this repo. Do not push unless
  asked.
- **Ask the standard.** MPI-5.0 is the authority, not what an implementation
  happens to do and not what seems reasonable. Keep a copy at
  `doc/mpi50-report.pdf` (git-ignored); `pdftotext -layout` makes it greppable.
  Several designs here were built one way, checked against the standard, and
  rebuilt: the PMPI forms of the predefined callbacks were written and then
  removed once A.1.1 turned out to list them among the *defined constants*, with
  an ABI value of 0 or 1 and so no entry point to name-shift.
- **Do not build what nothing needs.** If the only caller of a new name is the
  test written to justify it, that is the answer. Check what MPICH and Open MPI
  actually provide -- `nm` on their libraries settles most of these in a minute.
- **Say what was measured and what was inferred.** Both are fine; conflating
  them is not. `MISSING.md` marks inferred rows in the suite baseline as such.
- **Record decisions, not just defects.** An unrecorded decision is
  indistinguishable from an oversight, so "not doing X, because Y" belongs in
  `MISSING.md` with its reason.

## Checking a claim

Signatures are `data/apis.json`'s business: it is what the generator reads, and
what any hand-written binding should be checked against. The standard is what
makes the JSON legible, since its keys and kinds are otherwise undocumented --
`C_BUFFER` is an address in `MPI_Alloc_mem` and `C_BUFFER2` a choice buffer in
`MPI_Buffer_detach`, and only the standard says which.

Two checks need no build at all:

    julia dev/check-f08-bindings.jl   # every mpi_f08 declaration against MPI-5.0
    bash ci-scripts/check-headers.sh  # the Cray pointers against their common blocks

The first reads `doc/mpi50-report.pdf` and compares intents, declared types,
`VALUE`, argument names and argument order against the appendix that gives them,
and compares the 1180 f08 specifics' two declarations -- interface and body --
against each other. It exits nonzero on anything it cannot account for, and
reports no unexplained divergence today. Run it after changing how any f08
argument is declared, generated or not. It cannot run in CI, needing the
git-ignored PDF, so running it is on whoever changes a declaration.

The second is in CI, as the `checks` job, and is the only thing that would catch a
`pointer (P, X)` whose name does not match its `common /P/ P`: the mismatch makes
a fresh implicitly declared local that nothing assigns, so `X` sits at an
arbitrary address and MPI writes through it, and both spellings are valid Fortran
so nothing warns.

**Never edit `gen/` by hand.** It is generated and committed. To change what is
there, edit `dev/mpiapi.jl` and run `julia dev/mpiapi.jl` from the repo root; the
paths it writes are relative.

**A change to the generator that should not alter existing output has to be shown
not to.** `git diff gen/` is not always the instrument: where a change adds a
near-copy of every routine, git finds it cheaper to align the copy against the
original than to call it an insertion, and reports thousands of deleted lines that
are nothing of the kind. Turn the new axis off instead -- the PMPI pass has a
`for pmpi in [false, true]` to shorten -- regenerate, and require `git diff gen/`
to be empty.

## Building and testing

    bash scripts/macos-build-mpif.sh   <mpich|openmpi> <gcc|llvm>   # build and install mpif
    bash scripts/macos-test-mpif.sh    <mpich|openmpi> <gcc|llvm>   # test/, rebuilt from scratch
    bash scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm>  # MPICH's Fortran suite

`test/` is mpif's own and should be entirely green; the MPICH suite is the broad
one, and the counts it reports are recorded under "Suite baseline" in
`MISSING.md`. To run
one directory of the suite rather than all of it:

    cd mpi/tests-<variant>-gcc/mpich-5.0.1/test/mpi/f90/rma
    MPIF_REAL_MPIEXEC=<mpi-prefix>/bin/mpiexec ../../runtests -tests=testlist \
        -mpiexec=<repo>/ci-scripts/suite/mpiexec-filter.sh -maxnp=4

Set `MPIF_KEEP_TESTS=1` to stop `runtests` deleting each executable after it
runs, which is what a debugger needs to turn "test failed" into a backtrace.

Neither of the first two scripts installs the MPI they build against; that is
`scripts/macos-install-mpi.sh <mpich|openmpi> <gcc|llvm>`, and it builds the
implementation from source, so it costs a good deal more than the others. It is
what to run when `find_package(MPI)` starts reporting that
`mpi/<mpi>-<toolchain>/include` does not exist.

The suite has failures that are expected, so what fails a run is a difference
from `ci-scripts/suite/mpich-suite-xfail.txt` rather than a failure --- in either
direction, so a test that starts passing is caught as well as one that starts
failing, and the list cannot rot into a blanket exception. The file names every
expected failure with the reason it is there, "untriaged" included, and the
comparison is by name because counts hide a swap. `.github/workflows/ci.yaml`,
every `docker/*.dockerfile` and `scripts/macos-build.sh` all gate on it; none of
them swallows the result any more.

A variant with no `triaged` line in that file is compared and reported but
cannot fail the run, which is how a variant nobody has measured stays honest
rather than being papered over. The variant is detected rather than passed in --
Open MPI by the `ompi_info` it installs and MPICH by `mpiexec.hydra`, the
toolchain from what mpif's own `mpifort` reports, the OS, its version and the
architecture from the system -- and a component it cannot work out becomes
`unknown`, which matches no entry, so the run is loudly wrong rather than quietly
lenient.

The key is `<mpi>/<toolchain>/<os>/<os-version>/<arch>`, and the version is in it
because environments that agree on everything else still disagree: the Docker
images run Ubuntu 26.04 where CI's runners run 24.04 and the two part company over
`MPI_Dist_graph_create` and `i_fcoll_test`, and this repository's own macOS is 26
where the runners are 15. So a local run here and a CI run no longer share a row,
which is the point -- they were never the same environment.

One check needs no build at all:

    julia dev/check-f08-bindings.jl   # every mpi_f08 declaration against MPI-5.0

It reads `doc/mpi50-report.pdf` through `pdftotext -layout` and compares intents,
declared types, `VALUE`, argument names and argument order against the appendix
that gives them -- `gen/mpif_f08_functions.F90` against A.4, the callback abstract
interfaces of `src/mpif_f08_types.F90` against A.1.3, and the predefined callbacks
of `src/mpif_f08_attr_fns.F90` against A.4 -- exiting nonzero on anything it
cannot account for. Five sets rather than three: the PMPI forms of the first and
third are held to the same appendix under their twins' names, with the P stripped,
which is the only thing the appendices can be asked about a name they do not
carry. It reports no unexplained divergence today. Widening what it
compares is what got it there each time: comparing types found the
`MPI_Psend_init` count and the six `buffer_addr` declarations, which intents alone
had passed, and comparing the hand-written declarations at all found
`MPI_Type_delete_attr_function`'s argument name. Run it after changing how any f08
argument is declared, generated or not.

It is Julia because `dev/mpiapi.jl` is, the two being the same job from opposite
ends -- one writes the declarations, the other checks them -- and a dev directory
with one language in it needs no explaining. It was Python first; the port was
checked by running both over the same tree, on a clean tree and with three defects
put back, and taking byte-identical output as the standard to meet.

## Verifying a fix

`test/` is built `-O0`, and that hides a whole class of defect: anything whose
symptom is the *caller's* code being optimised differently. An INTENT the
standard does not give a dummy argument is the example that has already bitten --
INTENT(OUT) on a status let gfortran delete the caller's store to
`status%MPI_ERROR`, which no -O0 test could see. `test/status_error_f08.f90` is
therefore compiled `-O2` on purpose. Consider the same for any test whose
assertion is about what the caller is allowed to assume.

Every fix recorded in `MISSING.md` and `CODE.md` was checked by putting the bug
back: revert the change, rebuild, and confirm the new test fails -- ideally with
the same message the original failure gave. This has caught two tests that passed
either way and were therefore worthless, `test/comm_get_attr_f08.f90` among them,
where a user-defined keyval turned out not to reproduce the bug at all and
`MPI_APPNUM` was needed instead.

For a bug that lives in the generator, put it back the same way: edit
`dev/mpiapi.jl` and rerun it, never `gen/`.

For memory errors, note that ASan is close to useless here: the faulting write is
usually inside libmpi, which is not instrumented, and is often a hand-rolled copy
loop rather than an intercepted libc call. A guard page works instead -- `mmap`
two pages, `mprotect` the second `PROT_NONE`, and place the buffer so its last
byte ends the first page. That is how the `MPI_Info_get_string` overrun and the
`array_of_commands` scan were both pinned down.

## Stale build artifacts were the biggest time sink

Four separate "regressions" during one session turned out to be stale artifacts,
including a `dyld: Symbol not found: ___mpi_cptr_MOD_mpi_alloc_mem_cptr` that
looked alarming and meant nothing. The rule that removes the whole class: **the
three build-and-test scripts delete their build directory and start over every
time.**
There is nothing to clean by hand, and no state to reason about.

- `scripts/macos-build-mpif.sh` removes `build-<variant>` and the mpif
  installation.
- `scripts/macos-test-mpif.sh` removes `build-<variant>-tests`.
- `scripts/macos-test-mpich-suite.sh` unpacks the suite again and reconfigures
  it, so `mpi/tests-<variant>/mpich-<version>` is new on every run.

What survives is downloaded source only -- the MPI source tree under
`mpi/src-<variant>`, whose reuse the install script's stamp guards, and the
MPICH tarball. Both cost a download and no correctness.

The cost is a few minutes per run, which buys back far more than it spends:

- `runtests` rebuilds a test only when its executable is **missing**, so an
  executable left from an older mpif is relinked, or simply rerun, against the
  new library. Selective cleaning is what this section used to prescribe, and it
  is easy to get subtly wrong -- deleting libtool's `.o` files while leaving the
  `.lo` stamps that stand for them breaks `util/libmtest_f77.la` with
  `ar: .libs/mtest_f77.o: No such file or directory`, and every test in the suite
  then "fails to build". The `util/` libraries matter as much as the tests:
  `libmtest_f08.a` holds `MTest_Init` and is compiled against mpif's modules.
- `ctest` on its own does **not** rebuild. `ctest --test-dir build-<variant>-tests`
  will happily rerun a binary built against a previous mpif and report a pass.
  Use `scripts/macos-test-mpif.sh`, which reconfigures and rebuilds first.

## `docker run` is not the same environment as a buildx `RUN`

Worth its own heading because it cost a whole CI run and was checked beforehand, by
the wrong instrument. `docker run --platform linux/386` sets the 32-bit personality,
so `uname -m` inside reports `i686`. A `RUN` step in a `docker build --platform
linux/386` does **not**: the image is 32-bit, its compiler is 32-bit, and `uname -m`
still returns the host's `x86_64`, because a `linux/386` image executes natively on
an x86_64 kernel and buildx sets no personality.

That is invisible unless something reads `uname`, and
`ci-scripts/suite/test-mpich-suite.sh` does -- it is the last component of the
variant key. So `docker/mpich-gcc-i386.dockerfile` reported a 32-bit run as
`mpich/gcc/linux/13/x86_64`, compared it against the 64-bit rows, and the probe that
was supposed to catch exactly this had used `docker run` and seen `i686`.

The fix is `MPIF_SUITE_ARCH`, which `test-mpich-suite.sh` now prefers over
`uname -m` for that one component, set to `i686` in the dockerfile. The other four
components are still detected, so an OS upgrade there is still noticed.

Setting the personality was tried first and does not work: `linux32` and
`setarch i386` both fail inside the container --
`linux32: failed to set personality to linux32: Success` -- and since they exit
nonzero on failure, using one as the `SHELL` fails every `RUN`. Which is a second
instance of the same lesson, because that was found by running it rather than by
assuming it: the plan for this change said `SHELL ["/usr/bin/linux32", ...]` and the
build refused it immediately.

The general lesson is what this section is for: **verify a container's behaviour the
way the build will run it.** Where a probe cannot be run that way -- and here it
cannot, this machine being arm64, so `linux/386` and `linux/arm/v7` both go through
qemu locally where CI's amd64 runners run one natively -- say so, and prefer a
mechanism that does not depend on the difference. `MPIF_SUITE_ARCH` does not; the
personality does.

## Writing in these three files

They are prose, not bullet-point notes, and the convention is worth keeping: say
what happens, then why, then what the evidence is. Name the file and line where a
reader can check. Quote the standard where it decides something. When a diagnosis
turns out to be wrong, say that it was and what refuted it -- several entries earn
their length that way, and a withdrawn guess is more useful than a silent
correction.
