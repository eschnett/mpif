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

Two implementations times two toolchains gives four local variants. `build/` is
grouped by *stage* rather than by variant, so that each stage can be built, and
re-run, without disturbing the others:

    build/mpi/<variant>              the MPI               4
    build/mpi-src/<variant>          its unpacked source   4
    build/mpif/<variant>             mpif itself           4
    build/mpif-build/<variant>       mpif's CMake tree     4
    build/test/<variant>-run-<r>     test/                 8
    build/suite/<variant>-run-<r>    the MPICH suite       8
    build/consume/<variant>          the consume test      4

`<variant>` is `<mpi>-<toolchain>` entire, so those read `build/mpi/mpich-gcc`
and so on. `<r>` is the *runtime* MPI: there are eight of each test because one
installed mpif serves both implementations, and both pairings are measured rather
than one inferred from the other.

A sanitizer build appends `-sanitize-address` to the variant, so
`build/mpif/mpich-llvm-sanitize-address`. It gets no `mpi` or `mpi-src` of its
own: the MPI underneath is shared and uninstrumented, so that build is made
against `build/mpi/mpich-llvm`.

`rm -rf build` starts over. The ignore rule is `/build*/`, anchored on purpose,
so a stray build tree anywhere else shows up in `git status` rather than hiding.

The MPI and mpif stages leave an `install-complete` marker in their prefix, and a
later run of the same stage does nothing unless `MPIF_REBUILD=1` says otherwise.
That is what makes the sixteen test runs affordable, and it has a cost --- see
"Stale build artifacts were the biggest time sink" below, which is about the one
mistake it lets through.

This is not the layout CI and the Docker images use, and deliberately so; see
"CI and the Docker images keep their own directory layouts" in `MISSING.md`.

`kern.aioprocmax` is 16 here, against tens of thousands on Linux, which is why the
Open MPI defect that `ci-scripts/openmpi-fbtl-posix-aio.patch` fixes showed up on
macOS and nowhere else. CI runs twelve variants natively, plus a 32-bit i386
container and a FreeBSD VM; this
machine is `<mpi>/<toolchain>/darwin/26/arm64`, which is *not* one of CI's rows --
theirs are macos-15 and Ubuntu. Do not expect the suite baseline table to match a
local run.

**This machine's own name does not resolve to this machine.** `gethostname()`
returns `Mac.pitp.io`, and the DNS this network hands out answers that with an
address on a different subnet than the one `en0` holds -- 10.41.6.x against
10.10.60.110 as of August 2026, and both halves move, so check rather than trust
those numbers:

    python3 -c 'import socket; h=socket.gethostname(); \
        print(h, sorted({a[4][0] for a in socket.getaddrinfo(h,None)}))'
    ifconfig | awk "/inet /{print \$2}" | sort -u

If the first prints an address the second does not list, MPICH's spawn tests
cannot pass without help, because ch3:nemesis:tcp puts that address in the
business card a spawned child connects back to. The symptom is
`MPIDI_Create_inter_root_communicator_connect(316): Connection timed out in 180
seconds`, one 180-second timeout per test, and `MISSING.md` "MPICH: a spawned
child connects back to whatever `gethostname()` resolves to" has the diagnosis.
`scripts/macos-test-mpich-suite.sh` now exports
`MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE=lo0` for MPICH, so the scripted run is
already covered; a hand-run `runtests` is not, and has to set it itself. Open MPI
is unaffected -- it was already pinned to `lo0` for an unrelated reason -- and so
is mpif's own `test/`, which deliberately never spawns.

## Preferences

- **Commit on `main`.** No feature branches in this repo. Do not push unless
  asked.
- **Write the commit subject in the imperative.** "Keep the Fortran wrapper's
  flags off the C compiler", not "The Fortran wrapper's flags were reaching the C
  compiler": the subject says what applying the commit *does*, which is how git's
  own tooling phrases it -- `git revert` writes "Revert ...", `git merge` writes
  "Merge ...". One line, and short enough that `git log --oneline` does not cut
  it. A change that cannot be summarised in one line is not a reason to write a
  longer subject; it is what the body is for. Add one, after a blank line, and put
  the reasoning there: what changed, why, and what was measured, in the prose these
  three files use. The commits before this rule was written are mostly declarative
  sentences, and they are left as they are.
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
    bash scripts/macos-test-mpif.sh    <mpich|openmpi> <gcc|llvm> [<run-mpi>]
    bash scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm> [<run-mpi>]
    bash scripts/macos-test-consume.sh <mpich|openmpi> <gcc|llvm>

    bash dev/build-macos-all.sh [mpi|mpif|test|suite|consume|sanitize|all ...]

The first two arguments name the mpif under test. The third names the MPI the
tests *run* against and defaults to the first, so a native run is two words and a
cross run is three. A cross run's results must match the runtime MPI's native
results exactly. `test/` cross-runs swap the loader's search path under unchanged
binaries; the suite relinks, through the `MPIF_MPI_PREFIX` the wrapper reads from
the environment. Each of the eight pairings gets its own tree, so none of them
collides with another and any two can run at once. See "Choosing the MPI at run
time" in `CODE.md`.

`dev/build-macos-all.sh` drives the matrix a stage at a time; with no argument it
does all of them in order. Since the build stages skip when they are already
marked complete, `dev/build-macos-all.sh test` costs the eight test runs and
nothing else --- and, for the same reason, will not notice an edit to `src/`.
`MPIF_REBUILD=1 dev/build-macos-all.sh mpif test` is the version that will.

`test/` is mpif's own and should be entirely green; the MPICH suite is the broad
one, and the counts it reports are recorded under "Suite baseline" in
`MISSING.md`. To run
one directory of the suite rather than all of it:

    cd build/suite/<variant>-run-<runtime>/mpich-5.0.1/test/mpi/f90/rma
    MPIF_REAL_MPIEXEC=<mpi-prefix>/bin/mpiexec ../../runtests -tests=testlist \
        -mpiexec=<repo>/ci-scripts/suite/mpiexec-filter.sh -maxnp=4

A hand-run `runtests` gets none of what the wrapper scripts export, and on this
network that matters: add `MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE=lo0` for MPICH, or
`MPIEXEC_ARGS` as `scripts/macos-test-mpich-suite.sh` sets it for Open MPI,
whenever the directory contains spawn tests. See "This machine" above for why.

**Only one suite run per pairing at a time.** `MPICH_TESTS_DIR` defaults to
`build/suite/<variant>-run-<runtime>`, so two runs of the same pairing -- a
scripted one and a hand-run `runtests`, say -- are the same tree, and the second
rebuilds and deletes executables under the first. The scripted run also unpacks
the suite again at the start, which pulls the directory out from under anything
already running in it. Different pairings are different trees and do not collide,
and so are the sanitizer ones, which carry `-sanitize-address` in the variant.

Set `MPIF_KEEP_TESTS=1` to stop `runtests` deleting each executable after it
runs, which is what a debugger needs to turn "test failed" into a backtrace.

Set `MPIF_SANITIZE=address` on the first two scripts to build and test an
AddressSanitizer mpif. It is a fifth variant rather than a mode:
`build/mpif/<variant>-sanitize-address` and the test trees to match, so it does
not disturb the four above. `llvm` only here. See "Verifying a fix" below.

Neither of the first two scripts installs the MPI they build against; that is
`scripts/macos-install-mpi.sh <mpich|openmpi> <gcc|llvm>`, and it builds the
implementation from source, so it costs a good deal more than the others. It is
what to run when `find_package(MPI)` starts reporting that
`build/mpi/<mpi>-<toolchain>/include` does not exist.

**Never `make install` an MPI into `build/mpi/<variant>` by hand.** The prefix
is not finished when `make install` is: the install script then repoints the
wrapper
compilers at the ABI library, prunes the implementation's own headers, Fortran
modules and non-ABI libraries away, and puts the official ABI `mpi.h` in place of
the one it shipped. Skip those and the prefix still builds everything, and the
suite's mixed C/Fortran tests quietly disagree with mpif about what a handle is
-- see `MISSING.md` "An unpruned Open MPI prefix". `ci-scripts/check-mpi-install.sh`
now says so in a second, and both `test-mpich-suite.sh` and
`scripts/macos-build-mpif.sh` run it before anything expensive.

**Do not edit one of these scripts while it is running.** An install takes tens of
minutes, which makes it tempting; bash reads a script incrementally and seeks by
byte offset, so an edit that changes the file's length can make the tail of a run
execute nonsense. Editing `install-openmpi.sh` during a build cost a restart here.
Editing one also changes its checksum, and the checksum names the prepared-tree
stamp, so the next run re-clones and re-runs `autogen` -- expected, and the reason
the stamp exists.

Stopping one wants care too. `pkill -f install-openmpi.sh` ends the script and not
the `configure` and `make` it started, and those orphans keep creating files in the
source tree, so the next run's `rm -rf` of that tree fails with "Directory not
empty" and the run aborts on a message that looks like a build error and is not.
Check `ps` for the source directory's path before restarting, and if a tree has
already been half-removed, delete `build/mpi-src/<variant>` outright rather than
reasoning about what is left of it.

An install script that does not finish now takes its prefix with it, for the same
reason: `make install` runs well before the four steps that make the prefix a
standard-ABI one, and an interrupt anywhere in between used to leave something
that looked complete. So **a missing `build/mpi/<variant>` means the last install
failed**, and the cure is to run it again -- there is no half-installed prefix to
recognise any more, which is the point.

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

For memory errors there is now a sanitizer build, and it is the first thing to
reach for when the suspect is mpif's own code:

    MPIF_SANITIZE=address bash scripts/macos-build-mpif.sh mpich llvm
    MPIF_SANITIZE=address bash scripts/macos-test-mpif.sh  mpich llvm

It installs beside the ordinary build rather than over it -- its own build tree
and its own prefix, both tagged `-sanitize-address` -- so both are available
without a rebuild. `llvm` only: MacPorts' GCC ships no libsanitizer on macOS,
and CMake stops rather than producing an uninstrumented build under a sanitizer
name. See "Sanitizer builds" in `CODE.md` for what it reaches and how it is
linked, which differs by toolchain because flang has no `-fsanitize`.

What it does *not* fix is the case that paragraph used to be about. Where the
faulting write is inside libmpi, ASan still sees nothing unless the write goes
through an intercepted libc routine, and it is often a hand-rolled copy loop.
A guard page works there -- `mmap` two pages, `mprotect` the second
`PROT_NONE`, and place the buffer so its last byte ends the first page. That is
how the `MPI_Info_get_string` overrun and the `array_of_commands` scan were both
pinned down, before the sanitizer build existed. And for uninitialised memory
neither instrument helps: MSan is the one that would, and cannot be run here at
all -- `MISSING.md` "MemorySanitizer cannot be run against an MPI" has the three
reasons.

## Stale build artifacts were the biggest time sink

Four separate "regressions" during one session turned out to be stale artifacts,
including a `dyld: Symbol not found: ___mpi_cptr_MOD_mpi_alloc_mem_cptr` that
looked alarming and meant nothing. The rule that removed the whole class was that
every script deleted its build directory and started over. **That is now true of
the test stages only**, and the paragraphs below are why the exception is where
it is.

- `scripts/macos-test-mpif.sh` removes `build/test/<variant>-run-<runtime>`.
- `scripts/macos-test-consume.sh` removes `build/consume/<variant>`.
- `scripts/macos-test-mpich-suite.sh` unpacks the suite again and reconfigures
  it, so `build/suite/<variant>-run-<runtime>/mpich-<version>` is new on every
  run.

The two *build* stages instead skip when their prefix carries an
`install-complete` marker, and `MPIF_REBUILD=1` makes them delete and rebuild
anyway. That was chosen on 2026-08-08 with the cost understood: sixteen test runs
against four MPIs and four mpifs meant re-paying for an MPI install, which is
tens of minutes, over and over.

**What it costs is exactly the failure this section is named after.** Edit a
binding, rerun a test stage, and it will test the old mpif and pass. The marker
is a plain file, not a checksum of the inputs, so nothing notices. That is
deliberate rather than lazy: a checksum cannot be made complete here, because
`ci-scripts/install-mpi-header.sh` clones `mpi-forum/mpi-abi-stubs` at whatever
HEAD is that day, and a marker that looked authoritative without being so would
be worse than one that plainly says "I was here".

What replaces prevention is provenance. Each marker records the time, the commit
and whether the tree was dirty, and each mpif marker names the MPI marker it was
built against; every stage that consumes one prints it. So a run against a stale
build says so on screen instead of being indistinguishable from a fresh one. When
in doubt, `MPIF_REBUILD=1`.

What survives is the MPI source tree under `build/mpi-src/<variant>`, whose reuse
the install script's stamp guards, and the MPICH tarball. The tarball costs a
download and no correctness. **The source tree is not that**, and this paragraph
said it was until 2026-08-07: the MPI is configured and built *in place* there,
so the tree holds hundreds of megabytes of build output as well as the download,
and that output records the prefix it was built for. MPICH's libtool settles it
-- `hardcode_action=immediate` with `relink_command=""` in each `.la`, and
`--disable-dependency-tracking` besides -- so re-running `./configure` with a
different `--prefix` relinks nothing, and the installed library keeps the old
directory in its install name. The stamp does not notice, because it is keyed on
the install script's checksum and says only that the tree was downloaded,
patched and `autogen`'d.

That is only a hazard when the prefix moves, which is why it went unnoticed for
so long: the stamp's own reasons for a miss all delete the tree. It surfaced when
`mpi/src-<variant>` was moved to `build/<variant>/mpi-src`, where `otool -D` on
the tree's `libmpi_abi.1.dylib` still named `mpi/mpich-gcc/lib`. The layout moved
again a day later, to `build/mpi-src/<variant>` with the prefix at
`build/mpi/<variant>`, and the same clean was needed a second time -- so this is a
property of the trees rather than a one-off, and any future move of either path
has to do it again.

`make distclean` is the obvious cure and does not work: MPICH's `src/mpl` is
configured as a subproject whose generated Makefile has no `clean` target, so
both `distclean` and `clean` stop at `No rule to make target 'clean'`. What
worked was deleting the link output outright,

    find <tree> \( -name '*.o' -o -name '*.lo' -o -name '*.a' -o -name '*.la' \
                -o -name '*.dylib' \) -delete
    find <tree> -type d -name .libs -exec rm -rf {} +

which leaves the download, the patches and the `autogen` output -- everything the
stamp actually certifies -- and forces the next `./configure` and `make` to link
against the new prefix. Everything else that names a path in there is configure
output, and a fresh `./configure` rewrites all of it; `grep -rIl "$PWD/mpi/"`
finding nothing but `Makefile`, `config.status`, `.pc` files and generated
headers is what that looks like. If a library ever advertises a directory that
does not exist, this is where to look.

The cost is a few minutes per run, which buys back far more than it spends:

- `runtests` rebuilds a test only when its executable is **missing**, so an
  executable left from an older mpif is relinked, or simply rerun, against the
  new library. Selective cleaning is what this section used to prescribe, and it
  is easy to get subtly wrong -- deleting libtool's `.o` files while leaving the
  `.lo` stamps that stand for them breaks `util/libmtest_f77.la` with
  `ar: .libs/mtest_f77.o: No such file or directory`, and every test in the suite
  then "fails to build". The `util/` libraries matter as much as the tests:
  `libmtest_f08.a` holds `MTest_Init` and is compiled against mpif's modules.
- `ctest` on its own does **not** rebuild.
  `ctest --test-dir build/test/<variant>-run-<runtime>` will happily rerun a binary
  built against a previous mpif and report a pass.
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
