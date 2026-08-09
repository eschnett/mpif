# History

Condensed record of past failures, withdrawn diagnoses and the lessons they
left. `CLAUDE.md`, `CODE.md` and `MISSING.md` describe the current state
only; entries land here when the story stops being current and is still
worth a few lines. Newest lessons are not necessarily at the top — entries
are grouped by area.

## Stale build artifacts

Once the biggest time sink in the project; the rules in `CLAUDE.md`
"Build-stage caching" came out of these, one at a time:

- Edited bindings tested against a previously installed mpif passed and
  masked real defects more than once; hence the provenance-carrying
  `install-complete` markers, `MPIF_REBUILD=1`, and test/suite/consume trees
  that are deleted every run.
- `runtests` rebuilds a test only when its executable is missing, and a
  leftover `util/libmtest_f08.a` relinked new tests against a stale mpif.
- `ctest` alone reran binaries built against a previous mpif and reported
  passes; one such run "verified" a fix the binary did not contain.
- Removing `mpif_info`'s install rpath was "verified harmless" by a stale
  test tree; a clean rebuild died in dyld with `Library not loaded:
  @rpath/libmpifort_abi.1.dylib`, which is why the installed binary is what
  the tests run.
- Moving the build prefix left `build/mpi-src` trees whose libtool link
  output recorded the old prefix (libtool relinks nothing on a
  re-`configure`); the find-and-delete recipe in `CLAUDE.md` was needed
  after both such moves.

## Withdrawn diagnoses

- **The alltoallw four** (`alltoallwf08`, `nonblockingf08`,
  `nonblocking_inpf08`, `vw_inplacef08`; failed under gfortran on both
  implementations, passed under flang). Two diagnoses were withdrawn: first
  that they were compiler-made buffer copies dying under nonblocking calls
  (a cost of declining assumed-rank — the kind of conclusion that stops
  anyone looking), then that MPICH's `mpi_abi_util.h:140` was asserting on a
  datatype only it knows about (`ABI_Datatype_from_mpi`). The real defect
  was mpif's: `%MPI_VAL` on an *assumed-size* dummy has no extent the
  compiler knows, and gfortran repacked it into a temporary whose descriptor
  said `ubound = -1`, copying nothing — hence `mpif_f08_raw` passing such
  arrays as `TYPE(MPI_Datatype)`. Lessons: `*/gcc/*` failing on both
  implementations means the bug is on our side of the boundary, and follow
  the right similarity — three of the four being nonblocking was a
  coincidence the lead had to explain away and did not (`vw_inplacef08` is
  not nonblocking at all).
- **`MPI_Type_create_f90_*` returning `MPI_DATATYPE_NULL`** was first
  blamed on the ABI handle conversion failing a reverse search. Wrong: the
  conversion was never reached, because an ABI build selects stub
  implementations under `#ifndef HAVE_FORTRAN_BINDING` — the routines need
  the Fortran data *model*, not the bindings, and one macro stood for both
  (pmodels/mpich#7929).
- **The `typecnts*` / `nonblocking_inp*` flakiness.** Five `flaky` suite
  entries were carried as one nondeterministic MPICH defect. Two CI runs
  disagreeing about *which variants* `createf90types` failed on showed heap
  contents decided it (the `MPI_Type_get_contents` uninitialised read,
  pmodels/mpich#7930) — reading the first run's pattern as "gcc on Linux
  plus llvm on aarch64" was a mistake the defect invites. After the patch,
  `nonblocking_inpf`/`nonblocking_inpf90` kept failing and were read as
  residual nondeterminism; also wrong — they never call
  `MPI_Type_get_contents`. They were the alltoallw in-place over-read,
  mpif's own. Once that was fixed, three consecutive clean CI runs retired
  all five entries. Lesson kept on its own merits: one green run is not
  evidence that a nondeterministic failure has stopped; what settled it was
  a mechanism accounting for every test, backed by runs.
- **The eleven Open MPI x86_64 spawn failures** were twice mis-fixed: first
  as a `docker0` interface problem (the loopback pin did not cure it), then
  as a spurious warning to silence (`--mca btl_base_warn_peer_error 0`
  "left eleven passing tests passing" — but `runtests` prints only ten
  lines of output and the abort began at line eleven). A diagnosis from
  `runtests`' console report is a diagnosis of the first ten lines; fixed at
  the source — `ci-scripts/suite/test-mpich-suite.sh` now prints every
  unexpected failure's whole TAP-recorded output.
- **The root-only conversion guard** compared `q_comm_rank == 0` where the
  significant process is the one the `root` argument names — and on an
  intercommunicator no rank in `comm` identifies the root at all. MPICH's
  suite never caught it because every rooted call in it names root 0, the
  one value where wrong and right agree (checked over all three Fortran
  directories). `test/gather_root_f08.f90` and `test/gather_inter_f08.f90`
  were written to fail under the old guard, and did. The `MPI_Comm_spawn`
  case (null `command` from a non-zero root) was inferred from the same
  generated C rather than measured — `test/` has no spawn plumbing.

## Defects found by widening a check

- Extending `dev/check-f08-bindings.jl` from intents to declared types is
  what turned `buffer_addr` (integer where the standard says
  `TYPE(C_PTR)`/choice buffer) and the ABI header's phantom
  `MPI_Psend_init_c` from things noticed by accident into things the tool
  states. Adding the hand-written files to its scope found
  `MPI_User_function`'s buffers and an argument-name slip in the same pass.
- Why the suite never caught `MPI_User_function`'s wrong buffer declaration:
  its four `MPI_Op_create` tests declare the callback `external` with
  implicit interfaces, so the abstract interface never comes into it. Only a
  callback written as a module procedure — how the standard's own example
  writes one — meets the declaration at all; `test/op_create.f90` is that.
- `mprobef08` failed only in the suite: mpif declared a status argument
  `INTENT(OUT)` where the standard declares none, and at `-O2` the compiler
  deleted the caller's store of `status%MPI_ERROR` before the call. The
  suite compiles `-O2`; `test/` compiles `-O0` and could not see it — the
  origin of the "compile assertion-about-the-caller tests at `-O2`" rule.
- One missing constant among hundreds: `MPI_T_ERR_CVAR_SET_NEVER` was in
  `include/mpif_constants.h` but not in `mpi_f08`'s hand-maintained
  re-export lists; seventeen correctly re-exported neighbours give no signal
  that an eighteenth is missing. Same shape: `MPIF_HAVE_INTEGER16` guarded
  specifics that nothing ever defined, invisible because three sibling
  probes existed and made the pattern look wired up. Both fixed 2026-08-06;
  the drift risks that remain are recorded in `MISSING.md`.
- `mpif.h`'s `MPI_SIZEOF` declared array specifics only, so a scalar actual
  failed generic resolution under the explicit interfaces — the `mpi` module
  masked it by having both. Fixed by emitting scalar twins (`_s` names) from
  the same C macro.

## Removed on evidence

- **The predefined-handle shims** (22 generated `MPIF_*_toint` short-circuits
  plus hand-written copies, under a comment blaming "broken MPI
  implementations [only MPICH]"): a C probe round-tripped all 103 predefined
  handles through the ABI converters, before and after `MPI_Init`, zero
  failures; MPICH short-circuits handles in `0x20..0x2eb` in stock 5.0.1 and
  Open MPI checks `ompi_abi_handle_int_is_predefined` in all 22 converters.
  Removed; `test/` and the suite were unchanged entry for entry. The symptom
  the shims once answered ("forwarding MPI_INTEGER straight to
  MPI_Type_fromint yields an invalid datatype") was recorded without a
  version; if it reappears, the entry in `CODE.md` says where to look.
- **PMPI forms of the predefined callbacks** (`PMPI_COMM_DUP_FN` and kin)
  were built and taken out: 25 procedures, 370 lines, 25 recognition-table
  entries, and their only caller was the test written to justify them.
  What suggested them was MPICH defining `pmpi_comm_dup_fn_` — its generator
  emitting every wrapper twice, not a requirement; it does not define the
  `mpi_f08` ones and Open MPI defines none. A.1.1 settles it: the twelve are
  ABI *constants* (values 0 and 1), not entry points.
- **The f08 specifics as module procedures**: they could carry the right
  names but not what the names are for — a module procedure's symbol is the
  compiler's to mangle, so there was nothing for a profiling layer to
  interpose and `test/profile_f08.f90` could not have been written. Moving
  them to external procedures is also what forced the ignore_tkr directives
  onto the interface bodies (gcc accepted them in the bodies; flang refused
  to build — the sort of thing only building both catches).

## Environment and harness traps, each paid for once

- **An unpruned Open MPI prefix** (six c2f I/O failures): the forensics that
  pinned it were `nm` showing `_ompi_mpi_comm_world` resolving to
  `libopen_mpi` beside `_MPI_File_f2c` resolving to `libmpi_abi` in one
  executable, and a fault address of `0x1f9` = ABI handle 257 + the offset
  of the first field the native `MPI_Comm_rank` dereferences. The likeliest
  cause was a hand-run `make install`; chasing it exposed that the install
  scripts were not atomic (a failure between `make install` and the pruning
  steps left a non-ABI prefix in place), which is why they now discard a
  prefix their run did not finish and why `check-mpi-install.sh` gained
  teeth — its old "compiles a program that uses the ABI" check passed on
  both broken prefixes.
- Two trap subtleties from making the scripts atomic, both measured:
  `trap ... EXIT` does not run when the shell dies of an untrapped signal,
  and bash runs a trapped `INT` handler with `$?` = 0, so signals get their
  own handler that never consults `$?`. Also: a script run as `cmd &`
  inherits SIGINT ignored and cannot trap it, so an interrupt test that
  backgrounds its subject reports the handler broken when it is not.
- **Editing a running install script** restarted a build (bash reads by byte
  offset), and a bare `pkill -f` left orphaned `configure`/`make` writing
  into a tree whose next `rm -rf` failed on "Directory not empty" — the
  origin of the rules in `CLAUDE.md`.
- **This machine's hostname stopped resolving to it** when the local network
  changed in August 2026, failing every MPICH spawn test at 180 s apiece the
  same day, with no change to the repository. A suite run also failed once
  because DHCP moved the hostname *during* the run. The loopback pin in
  `scripts/macos-test-mpich-suite.sh` is the durable answer; the FreeBSD VM
  had the same class of failure (hostname resolving to nothing) fixed the
  other way, as provisioning, because that image is ours to provision.
- **`docker build` vs `docker run` personality**: a `RUN` step under
  `--platform linux/386` reports the host's `x86_64` from `uname -m`, so the
  i686 variant's first CI run compared itself against 64-bit baselines under
  a key that said `x86_64`. `MPIF_SUITE_ARCH` (and the rule "verify a
  container the way the build runs it") came from this.
- **Renaming a CI cache path** made stale caches restore to the old location
  and look like a broken installation; the fix was bumping the key prefix
  (`mpi-` → `mpi2-`).
- **FreeBSD's second run** is what caught gfortran's Fortran-only flags
  reaching the C compiler: it was the first environment compiling C with
  clang and Fortran with gfortran, where gcc's C frontend had only warned
  for twelve CI variants. Verified both ways locally afterwards, no FreeBSD
  needed.
- **The sanitizer job's first CI run** found the ELF link-order requirement
  (ASan runtime must be first in the initial library list) after three local
  macOS runs had all passed — Darwin has no such rule. The gfortran half
  failed at configure (`FindMPI` drops non-`-Wl,` link flags, leaving
  `__asan_*` unresolved in the probe); the flang half built all tests and
  failed every one at startup. Both shapes are now handled in the wrapper
  and asserted by `check-sanitizer-build.sh` — which exists because a build
  whose flags never arrived passes every test exactly like a correct one.
- Before the sanitizer build existed, both memory defects found in mpif's C
  (the `MPI_Info_get_string` overrun and the `array_of_commands` scan) were
  pinned down by hand with an `mmap`ed guard page. The ASan build was
  justified by re-planting a one-byte overrun in `mpif_strdup_f2c_trim`:
  the ordinary build passed all tests; the sanitizer build named the C
  frame, the generated conversion, the f08 wrapper and the Fortran caller's
  line.

## Suite baseline bookkeeping

The table in `MISSING.md` derives from the CI run of `baa7f65`, adjusted:

- Every row is two lower in f90 and one lower in f08 for the PMPI interface
  arriving (`wtimef90` twice, `profile1f90` in f90); measured on
  `mpich/gcc/darwin/26/arm64`, inferred for the rest.
- The six gcc rows' f08 column is four lower for the alltoallw fixes,
  inferred as *equal to the llvm twin* (those four were the only f08
  difference between the toolchains).
- Every Open MPI f90 row is one lower for `bsendf90` building again and
  failing only on MPICH, inferred from `bsendf`.
- The MPICH rows wobbled by one or two between runs while the genuinely
  flaky `typecnts*` entries still existed; they no longer do.
- Every row's f08 column is three lower for the assumed-rank choice buffers
  (`f08/subarray` test14 and test15, and `profile1f90`'s f08 copy); measured
  on all four `darwin/26/arm64` pairings, inferred for the rest — every CI
  toolchain passes the `MPIF_HAVE_CFI` probe, so no CI row is expected to
  stay on the fallback.

Other one-time results recorded when they happened:

- Exporting the predefined attribute callbacks from the modules moved f90
  and f08 and left f77 exactly where it was — confirmation the modules were
  at fault, `mpif.h` having always declared them.
- Passing the f08 status straight to C moved no suite numbers, and was not
  meant to: it removed the temporary, the conversion and 77 `loc()`
  comparisons per build, observably identical behaviour.
- `test/neighbor_alltoallw_f08.f90` tried asserting *which* block a
  neighbour's data lands in and correctly cannot: with most dimensions of
  extent one, several edges join the same pair, and §8.6's matching rule
  constrains type signatures, not which send satisfies which receive. It
  sends each rank's own number instead.
- Counts written into these files rotted repeatedly: "eight modules" (there
  were twelve), "fifty-four entries" (65 at the time), "three upstream
  reports" (six). Hence the rule in `CLAUDE.md`: give the command that
  counts, not the count.

## Two spawn-test hostname entries were one

`MISSING.md` briefly carried the macOS spawn-timeout failure twice — once
dated 2026-08-06 recommending `MPIR_CVAR_CH3_INTERFACE_HOSTNAME` and saying
the fix was deliberately *not* scripted, and once recommending the interface
CVAR that `scripts/macos-test-mpich-suite.sh` had by then started exporting.
The second superseded the first; they were merged 2026-08-09. A decision
reversed in a later entry has to retire the earlier one.
