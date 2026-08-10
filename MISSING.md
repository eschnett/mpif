# Missing features and known errors

What mpif gets wrong, does not do, or cannot do because something outside it
is broken — plus the decisions not to do something, which stay, since an
unrecorded decision is indistinguishable from an oversight. Entries are
removed once resolved (settled questions move to "Verified as correct" in
`CODE.md`; the stories behind them to `HISTORY.md`); comments in the source
tree and in `ci-scripts/suite/mpich-suite-xfail.txt` name entries here, so
renaming an entry means grepping for its title.

Findings here are checked against `data/apis.json`, the generated output, the
official ABI header and the MPI-5.0 standard — see "Checking a claim" in
`CLAUDE.md`.

## Errors

None outstanding.

## Not defects

Failures investigated and found to be neither mpif's nor an implementation's,
recorded so the same symptom is not diagnosed twice — and so the decision not
to `xfail` them is on the record, since an `xfail` line would make a broken
environment permanent.

### The local build stages skip when already installed, and can therefore be stale

The MPI and mpif build stages skip on an `install-complete` marker;
`MPIF_REBUILD=1` rebuilds. Operational consequences are in `CLAUDE.md`
"Build-stage caching". The decision worth defending:

- **The marker is a plain file, not a checksum of the inputs.** A complete
  checksum is impossible — `ci-scripts/install-mpi-header.sh` clones
  `mpi-forum/mpi-abi-stubs` at whatever HEAD is that day — and a marker that
  looked authoritative without being so is worse than one that plainly says
  "I was here". (The existing `prepared-<version>-<cksum>` stamp in
  `install-mpich.sh` is the cautionary example: a genuine checksum that still
  missed the relink-on-prefix-move case.)
- Mitigation is provenance: each marker records time, commit, dirtiness and
  compilers; an mpif marker names the MPI marker it was built against; every
  consuming stage prints it.
- Only the two *build* stages skip. The test, suite and consume trees are
  deleted and rebuilt every run, deliberately: they are cheap, and they are
  where the two silent-reuse mechanisms live (`runtests` rebuilds only
  missing executables; `ctest` never rebuilds).

### CI and the Docker images keep their own directory layouts

The local scripts use the staged `build/` layout; `.github/workflows/ci.yaml`
and `docker/*.dockerfile` deliberately do not.

- The problem the layout solves (a working tree accumulating dozens of
  artifact directories) does not exist there: CI's trees live in
  `$RUNNER_TEMP`, the images' in `/cactus`, both thrown away.
- CI's prefixes are keyed by implementation alone (`opt/mpi-mpich`) because
  the toolchain is the job, and the cross job restores two implementations
  onto one runner whose paths must not collide (`ci.yaml:71-76`).
- The images put `mpif-<variant>` beside `/cactus/mpif` because the source
  directory is what the staged `COPY`s populate.
- Renaming a CI path has already cost a cache-key bump once (`mpi-` →
  `mpi2-`, `ci.yaml:214-218`); paying that to make unrelated trees rhyme is a
  bad trade. If convergence is ever wanted, the images are the safe half.

### An unpruned Open MPI prefix, and the six handle-conversion I/O tests it fails

Symptom: the six `MPI_File_c2f`/`f2c` round-trip tests (`c2f2ciof*`,
`c2f*multio` across f77/f90/f08) fail on Open MPI — aborts in
`MPI_Group_compare` with `MPI_ERR_GROUP`, or a SIGSEGV under
`MTest_Finalize`.

- Cause: a prefix that got `make install` but not the install script's
  post-steps (repoint wrappers, prune native headers/libraries, install the
  ABI `mpi.h`). The suite compiles C with the implementation's `mpicc` and
  Fortran with mpif's `mpifort`, so mixed tests link half against native
  handles (pointers) and half against ABI handles (small integers).
- Cure: reinstall with `scripts/macos-install-mpi.sh`. Never `make install`
  by hand (`CLAUDE.md`).
- Guards, each confirmed by putting the bug back: the install scripts discard
  a prefix their run did not finish (signals get their own trap handler —
  bash runs a trapped `INT` with status 0, so the handler must not consult
  `$?`); `ci-scripts/check-mpi-install.sh` asserts `MPI_ABI_VERSION` at
  compile time *and* that the wrapper's executable links `libmpi_abi` (the
  two catch different broken states); `test-mpich-suite.sh` and
  `scripts/macos-build-mpif.sh` run that check before anything expensive,
  since a prefix written by hand never goes near the install script's traps.

### FreeBSD is tested in a VM, and its variant is not triaged yet

GitHub has no FreeBSD runner; the `freebsd` job boots a FreeBSD 14.3 VM via
`vmactions/freebsd-vm` and runs the ordinary recipe. One variant,
`mpich/gcc/freebsd/14/amd64`.

- **Compilers are the platform's own mix**: base-system clang for C (FreeBSD
  has no GCC in base), gfortran from the `gcc` metaport for Fortran (no flang
  port exists in binary form). The variant key still says `gcc`, correctly:
  the toolchain component names the Fortran compiler, which is what an
  expected-failures list of Fortran tests is about.
- Platform accommodations, each for a stated reason: `#!/usr/bin/env bash`
  in every `ci-scripts/` script (five are executed by pathname);
  `check-mpi-install.sh` reads `readelf` SONAME output with or without
  brackets (ELF Tool Chain vs binutils); parallel-build width falls back
  `getconf` → `sysctl -n hw.ncpu` → 4; GNU make is symlinked onto PATH as
  `make` (`runtests` shells out to bare `make`); gfortran is found via the
  unversioned symlink, not pinned; a `/etc/hosts` line gives the VM's own
  hostname an address — the image resolves `freebsd` to nothing, and MPICH's
  business card needs it, so every multi-process `MPI_Init` otherwise dies in
  `gethostbyname`. Fixed as provisioning (the workflow creates the VM) rather
  than with the MPICH-only CVAR.
- MPICH only: Open MPI refuses to run as root without `--allow-run-as-root`,
  and the action's `run` block is root. No cross-run either — that claim is
  about mpif's artifact, tested where both implementations exist.
- **Not triaged**: no `triaged` line, so suite differences are reported and
  cannot fail the run; `test/` gates as everywhere. Expect `attrmpi1f08`
  among the differences (its xfail is enumerated per 64-bit architecture and
  FreeBSD says `amd64` where Linux/macOS say `x86_64`).
- Status: no run has reached the suite yet; the `/etc/hosts` fix is untested
  by an actual MPI run. There is still no FreeBSD row to triage.

### Other compilers are compiled and not run, and three cannot be tested at all

The `compile` job builds mpif under compilers the twelve variants do not cover
— gfortran 8, 9 and 12, Intel `ifx`, NVIDIA `nvfortran`, AMD `amdflang` — with
the Forum's ABI stub library standing in for an MPI, and runs nothing.
`ci-scripts/README.md` says how; the decisions are here.

- **Compile-only, deliberately.** What varies between Fortran frontends and is
  cheap to ask is whether the configure stage detects the right features and
  whether the code compiles. Running would mean an MPI built by each compiler
  and a suite triage per variant, which is the cost the twelve variants already
  pay for the two frontends that matter most.
- **Both CFI branches per row.** `MPIF_HAVE_CFI` selects between the scheme-1B
  wrappers with `gen/mpif_f08_cdesc.c` and the `ignore_tkr` fallback, so one
  build compiles one of them; `-DMPIF_ENABLE_CFI=OFF` gets the other.
- **Reported, not gating**, until a row has been green — the rule stated for an
  untriaged suite variant, applied to a compiler.
- **gfortran 7 is not a row.** It compiles mpif cleanly, both branches, measured
  in a `gcc:7` container. That is exactly why: the floor is the ABI one in
  "`bind(C)`" below (hidden character lengths were `int` before 8), and a stage
  that compiles without running cannot see it. A green row there would mean
  nothing. 10 and 11 also compile and are left out only for cost.
- **Cray CCE cannot be tested.** It is licensed and distributed only with HPE
  Cray systems; there is no public download and no runner that has it. Nothing
  to work around — a scope limit, like Open MPI's 32-bit one below.
- **PGI is `nvfortran`.** PGI stopped being a separate product in 2020, when it
  became the NVIDIA HPC SDK; the last standalone release is long off NVIDIA's
  download pages. The `nvfortran` row *is* the PGI test, and a separate one
  would be a second name for the same compiler.
- **AOCC is not tested; ROCm's `amdflang` is.** AOCC's tarball is behind a
  licence form on AMD's site, so it cannot be fetched unattended, and both are
  AMD's build of LLVM flang. Should AMD ever publish a direct URL, AOCC is a
  row's worth of work and no more.

Green as of the first run: gfortran 8, 9 and 12, and `amdflang` (ROCm's LLVM
flang), each on both CFI branches. `ifx` 2026.1 compiles the whole library and
`nvfortran` 26.5 does not get past configure; both are below.

### `ifx` aborts on a sentinel passed to a choice buffer

`ifx` 2026.1 compiles and installs the whole library, on both CFI branches, and
then dies building the tests that pass a sentinel:

    inplace_f08.f90(14): error #5623: **Internal compiler error: internal
    abort** Please report this error along with the circumstances in which it
    occurred in a Software Problem Report.

Line 14 is `MPI_Allreduce(MPI_IN_PLACE, sum, ...)`. Six targets abort, and they
are exactly the ones passing a sentinel — a Cray pointee, from
`include/mpif_constants.h` — to an `mpi_f08` choice buffer: `inplace_f08`,
`inplace_cfi_f08`, `alltoallw_inplace_f08`, `alltoallw_inplace_guard`,
`bottom_cfi_f08` (`MPI_BOTTOM`) and `argv_null_f08` (`MPI_ARGV_NULL`). So it is
sentinels in general, not `MPI_IN_PLACE` in particular. **71 of the ~80 test
programs build.**

`-DMPIF_ENABLE_CFI=OFF` aborts identically, so the trigger is the Cray pointee
and not the assumed-rank mechanism: `TYPE(*), DIMENSION(..)` and
`integer :: buf(*)` under `ignore_tkr` fail alike.

A compiler defect with nothing for mpif to spell differently. The sentinel must
be a Cray pointee: in C, `MPI_IN_PLACE` is a distinguished address rather than
an object, so no Fortran entity can be declared *at* it, and a `bind(C)`
variable would have storage of its own at the wrong address. Any of the six
targets is a reproducer for an Intel report. Not gating.

### `ifx` and `nvfortran` link a C `main` against their own — fixed in `test/`

Four targets mix C and Fortran — `interlanguage`, `c2f`, `datarep_c` and
`alltoallw_inplace_guard` — with `main` in C, so CMake links them with the
Fortran driver, and two drivers then contribute a `main` of their own that calls
the Fortran main program:

    ifx:       for_main.o: undefined reference to `MAIN__'
    nvfortran: f90main.o: multiple definition of `main'
               f90main.o: undefined reference to `MAIN_'

nvfortran says both at once, its object defining the symbol rather than only
referring to it, and spells the entry point with one underscore. `-nofor-main`
and `-Mnomain` are the respective flags for exactly this, applied by
`mpif_test_c_main` in `test/CMakeLists.txt`; gfortran and flang need nothing.
The linker language stays Fortran, these programs needing its runtime.

Anything else mixing a C `main` with mpif's Fortran wants the same flag. The
four are listed in one place for that reason: a fifth would otherwise fail on a
compiler nobody runs locally, which is how `alltoallw_inplace_guard` came to be
missed the first time — under ifx it aborts in the compiler before reaching the
link, so only nvfortran showed it.

### `test/check_env_nodesize_fail` has flaked once, under the gcc sanitizer

Seen once, on `sanitize / gcc`: the test passes 2 ranks and
`MPIF_NODE_SIZE=1` and expects `mpif_check_environment` to refuse, and no
diagnostic came. Rerunning the same job on the same commit passed, and the
other 74 tests passed both times, as did `sanitize / llvm` and all twelve build
variants.

Measured: one failure, one pass, same commit. **Inferred**, not established:
`src/mpif_check.c` derives the node size by gathering `MPI_Get_processor_name`
to rank 0 and grouping equal names, so the check only refuses when both ranks
report the *same* name — two differing names give two nodes of one process
each, which is what `MPIF_NODE_SIZE=1` claims. What would make the two ranks
disagree about the name for one run in many is not known, and one observation
is not enough to name it.

`test/` has no expected-failure list and should be entirely green, so this is
recorded rather than accommodated. If it recurs, print the gathered names on
mismatch — the diagnostic names the node it rejected but not the set it saw.

### `nvfortran` does not diagnose an ambiguous generic interface — worked around

`nvfortran` 26.5 compiles a generic over two specifics that differ only in one
argument's kind, where the two kinds are the same. `ifx` diagnoses the same
source correctly ("error #5286: Ambiguous generic interface").

That used to be the shape of the `MPIF_ADDRESS_KIND_DIFFERS_FROM_*` probes, so
`nvfortran` answered *yes* to both — impossible on a 64-bit platform, where
`MPI_ADDRESS_KIND` is 8, equal to `MPI_COUNT_KIND` and unequal to the default
integer kind — and the library would have been built with four extent routines
carrying generics that duplicate specifics already there.

The guards now compare the kind values, which is the standard's own rule for
whether two specifics are distinguishable and needs nothing from the compiler
beyond arithmetic on `kind(loc(dummy))` and `selected_int_kind(18)` — the very
expressions `include/mpif_constants.h` defines the two kinds by. The ambiguity
question is still asked, under
`MPIF_GENERIC_DISTINGUISHES_ADDRESS_FROM_{INTEGER,COUNT}`, and reported rather
than enforced: mpif emits what the standard permits, so the generated code is
right either way, and following the compiler instead would mean emitting an
ambiguous generic on purpose.

The first attempt at that comparison used `merge`, and `nvfortran` rejects an
intrinsic in a kind specification expression —
`NVFORTRAN-S-0087-Non-constant expression where constant expression required`,
though all three of `merge`'s arguments are constants. So both guards came out
"no", which on a 64-bit platform is wrong the other way, and
`check-configure-probes.sh` stopped the build again. The probes now use
subtraction alone, written so the difference is never negative; the optional-kind
probes were changed the same way, having had the same `merge` in them.

With the guards right, `nvfortran` reaches the library; with the two entries
below fixed, it builds and installs it on both branches and gets into `test/`,
where the only failures left were the four C-`main` targets above.

### `nvfortran` cannot resolve a renamed generic that shares a specific's name — worked around

`nvfortran` 26.5 fails `gen/mpif_f08_wrappers.F90` with fourteen of

    NVFORTRAN-S-0155-Could not resolve generic procedure 'pmpi_alloc_mem'

one per name: `MPI_Alloc_mem`, the three `MPI_Win_allocate*`,
`MPI_Win_shared_query`, the `_c` forms of the latter four, and every `PMPI_`
twin. Those seven names are the only ones an f08 wrapper imports that are a
*generic* in the `mpi` module rather than a plain specific — `src/mpif_cptr.F90`
adds a `TYPE(C_PTR)` overload beside the `INTEGER(MPI_ADDRESS_KIND)` one, and
`src/mpi.F90` puts both in an interface block carrying the same name as the
integer specific. The other 1009 wrappers import specifics and compile.

What says the generic is the part it cannot do: `src/mpif_cptr.F90` performs the
same rename-on-`use` and call against the *plain specific* in `mpif_functions`,
and nvfortran compiles it. gfortran, flang and ifx all accept the generic form.

Worked around by taking those seven from `mpif_functions` instead, where the
name is a specific: the wrapper wants the integer form and nothing else, passing
an address-sized temporary and doing the `transfer` itself, so the generic was
indirection it never needed. `dev/mpiapi.jl` keys this on the `C_BUFFER`
parameter kind; the change is fourteen `use` lines in `gen/`.

### `nvfortran` has `real*2` but not `complex*4` — the guard was wrong

`complex*4` was inside `#ifdef MPIF_HAVE_REAL2`, on the assumption that the real
kind implies the complex one. `nvfortran` 26.5 has `real*2` and means it, and
warns on `complex*4`:

    NVFORTRAN-W-0031-Illegal data type length specifier for complex
      (mpif_types.F90: 376, 384)

falling back to `complex*8`. Only a warning, so `mpif_sizeof_complex4` was
compiled and would have answered 4 for an eight-byte value — the silent kind of
wrong, and mpif's own fault rather than the compiler's. `complex*4` and
`complex*32` now have probes and guards of their own,
`MPIF_HAVE_COMPLEX4`/`MPIF_HAVE_COMPLEX32`; `complex*32` under
`MPIF_HAVE_REAL16` had the same latent flaw. A complex's kind is its real part's,
so the probes read `complex(4 - kind(x))` and `complex(32 - kind(x))`. gfortran
15 and flang 22 answer for the complex kind exactly as they do for the real one,
so nothing changes there.

Not gating until a run is green.

### `nvfortran` accepts kind specifiers it does not implement — probes tightened

`logical*16`, `integer*16` and `real*2` are taken by `nvfortran` 26.5 with a
warning (`NVFORTRAN-W-0031-Illegal data type length specifier`) and the default
kind, so a probe that only asked whether the declaration compiles reported
three kinds it does not have — and the library would then have been built with
`MPIF_HAVE_LOGICAL16` and friends defined, adding specifics for kinds that are
not there. This is on mpif's side, and is fixed: each of the four probes now
uses the answer as a kind value, so a fallback names kind -1, which no compiler
accepts. gfortran 15 and flang 22 answer exactly as they did before.

## External blockers

### The ABI header gets the partitioned-communication count wrong, twice — carried as a local patch

The ABI stubs header (`mpi-forum/mpi-abi-stubs`, fetched by
`ci-scripts/install-mpi-header.sh`) declares `MPI_Psend_init`/`MPI_Precv_init`
with an `int` count and invents `MPI_Psend_init_c`/`MPI_Precv_init_c`.
MPI-5.0 gives the base forms an `MPI_Count` count and no `_c` form (the name
appears nowhere in the standard; neither implementation defines it — a
routine whose only form takes a count has nothing for `_c` to add).

- Unpatched, the generated wrapper passed an `MPI_Count` to a prototype
  declaring `int` — 32 bits materialised where the callee reads 64.
- `fortran/mpi.h.patch` corrects the four base prototypes and deletes the
  four phantom declarations. **Drop those hunks once the stubs header is
  fixed**; `patch` will report them already applied.
- `dev/mpiapi.jl` asserts neither routine ever takes the `_c` path.
- Not reported upstream yet, and worth reporting.

### OpenMPI: 32-bit environments are not supported

Its release notes say so (`docs/release-notes/platform.rst`: "32-bit
environments are no longer supported"; ignore the older conditional statement
in `compilers.rst`). So the 32-bit variants are MPICH-only — a scope limit,
not something to work around; the two 32-bit dockerfiles should not get
Open MPI counterparts.

### MPICH is built from `main`, not from a release

`ci-scripts/install-mpich.sh` clones pmodels/mpich and checks out
`MPICH_COMMIT`, currently `ab53493d` (2026-08-04, 512 commits past v5.0.1).
The *test suite* still comes from the v5.0.1 tarball — `MPICH_VERSION` in the
same file, which `ci-scripts/suite/test-mpich-suite.sh` reads by name — so
moving `MPICH_COMMIT` is a one-variable experiment against one
expected-failure list.

Why: building v5.0.1 here took seven carried fixes, and `main` has since made
every one of them unnecessary, each in a shape of its own — MPICH is carried
unpatched now, which no other stage of this project manages:

| carried for v5.0.1 | on `main` |
|---|---|
| fetched commit `689a0869` | obsolete — rewrites code `main` no longer has |
| fetched commit `bb167f1c`, the `libmpi_abi.so.1` version-info | an ancestor |
| `mpich-abi-util-one-copy.patch` (#7916) | `2eb9a812`, and no separate `libpmpi_abi` is built at all |
| `mpich-abi-f90-datatypes.patch` (#7929) | `66cd5734`, "create_f90 do not depend on fortran" |
| `mpich-abi-type-get-contents.patch` (#7930) | `31d79547`, "fix output datatype conversion in `MPI_Type_get_contents`" |
| `fortran/mpich-disable-file.patch` | `MPI_File_{c2f,f2c}` are no longer generated into the ABI library |
| `mpich-abi-darwin-weak.patch` | a weak-symbols-without-alias branch; measured identical with and without the patch |

Measured on `darwin/26/arm64` before adopting it: all six pairings that touch
MPICH report the suite's expected failures exactly, at the same counts as
v5.0.1 (3/5/8 `mpich/gcc`, 3/5/9 `mpich/llvm`, 7/9/13 and 7/9/14 for the
Open MPI-runtime crosses); `test/` is 75 of 75 on each; `consume` passes on
both toolchains. The three reproducers under `bug-mpich-*/` pass. Nothing was
gained in the suite, because each of those defects was already worked around;
what changed is that the workarounds went away.

- The retired patches are gone rather than kept for the release path: with
  them deleted, `MPICH_COMMIT` is the only supported way to build. Recovering
  the v5.0.1 recipe means `git show` on the commit that removed them.
- `git apply` refuses fuzz, which is how three of the seven retired
  themselves: they stopped applying and said so. The other four had to be
  checked by hand — two fetched commits that are ancestors or obsolete, one
  file upstream no longer generates, and the Darwin export style, which was
  settled by building the same commit both ways and comparing `nm`.
- Following an unreleased tree is the cost. The stamp in `MPI_SRC_DIR` is
  keyed on the commit, so a bump re-prepares the tree rather than reusing a
  stale one, and CI's `mpi-src` cache key hashes `ci-scripts/install-*.sh`.
- Still not fixed on `main`: partitioned communication, and the suite
  disagreements below (`greqf*`, `bsendf*`, `statusconv`, `spawnargvf90`),
  which are about the tests rather than the library.

### MPICH: strong `MPI_*` exports on Darwin broke substituting the library — fixed upstream

The ABI implementations export `MPI_*` as weak definitions, and on Mach-O
that is binding: a client linked against a weak-def export can only be
satisfied by another weak definition, so an executable linked against
Open MPI died in dyld (`Symbol not found: _MPI_Abort ... Expected as weak-def
export`) when MPICH's library was put first. MPICH's weak-symbol machinery had
no branch Mach-O could use, so on Darwin it exported strong, and a local patch
added `#pragma weak` per public definition in the binding generator.

`main` now has a weak-symbols-*without*-alias branch — `#pragma weak X` plus a
wrapper calling `PX` — and `HAVE_PRAGMA_WEAK` is the macro `configure` defines
on this platform, so the exports are already weak and the patch was dropped.
Measured rather than assumed: two prefixes built from the same commit, one with
the patch and one without, export the same 694 `MPI_*` symbols, all 694 weak,
none strong.

- `check-mpi-install.sh` asserts the export style on every Darwin prefix, and
  is now the only thing holding it. It is what a regression would trip.
- `fortran/f2c_abi_mpich.c` still carries its own `#pragma weak` for the
  handle-conversion functions mpif injects; those are mpif's code and nothing
  upstream covers them.
- ELF lookup is indifferent to weak-vs-strong, so only macOS ever saw this.

### MPICH: partitioned communication is not implemented

`MPID_Psend_init` is an `MPIR_Assert(0)` in the ch3 device this build uses
(`src/mpid/ch3/src/mpid_part.c:12`). Nothing on this side can be judged by
running it, which is why `test/partitioned_f08.f90` asserts at compile time
and never executes its calls.

### MPICH: `MPI_Type_create_f90_*` was a no-op in an ABI build — fixed upstream

<https://github.com/pmodels/mpich/issues/7929>

The three routines returned `MPI_SUCCESS` and `MPI_DATATYPE_NULL`:
`create_f90.c` selected stub implementations under
`#ifndef HAVE_FORTRAN_BINDING`, and the ABI build undefines that macro — but
the routines need the Fortran data *model* (`mpif90model.h`), not the
bindings; one macro stood for both.

Fixed on `main` by `66cd5734`, "create_f90 do not depend on fortran", which
removes the dependency rather than splitting the macro; the local patch that
split it is gone. Reproducer and checker in `bug-mpich-f90-datatypes/`, both
passing on the pinned commit.

### MPICH: `MPI_Type_get_contents` converted uninitialised memory — fixed upstream

<https://github.com/pmodels/mpich/issues/7930>

The ABI wrapper converted the caller's `max_datatypes` entries back, not the
number the datatype has, from an uninitialised `MPL_malloc` buffer — and a
datatype from `MPI_TYPE_CREATE_F90_*` is *required* to report an empty
`array_of_datatypes`, so a correct caller hit it. Garbage that looked builtin
aborted in `ABI_Datatype_from_mpi` (`MPIR_Assert`); garbage that did not was
handed back. Heap contents decided which, so the failures looked
nondeterministic (see `HISTORY.md`).

Fixed on `main` by `31d79547`: the temporary is `MPL_calloc`'d and the
conversion skips the zero entries. Note the shape — the surplus is left
**exactly as the caller passed it**, not set to the null handle, which is all
the standard asks for. `bug-mpich-type-get-contents/` seeds a sentinel and
checks for that; it used to demand the null handle, and so called a fixed
MPICH broken. mpif's own generated bindings still null their pure-out handle
arrays themselves (`dev/mpiapi.jl`) rather than depend on any of this.

### MPICH: the generalized request tests require `extra_state` to alias the caller's variable

<https://github.com/pmodels/mpich/issues/7922>

`greqf`/`greqf90`/`greqf08` (run against both implementations, so they fail
on all twelve variants) require a `free_fn` writing through `extra_state` to
change the *caller's* variable. The standard says otherwise: `extra_state` is
`IN`/`INTENT(IN)`, the C prototypes take it by value, and chapter 19 gives no
Fortran-specific licence. MPICH's own binding passes the actual argument's
address through, so the tests pass there as a side effect of how it is built.

- Matching them would mean holding a pointer into the caller's frame for the
  request's lifetime — dangling as soon as the request outlives the scope.
  mpif copies; `test/grequest_f08.f90` asserts the opposite of MPICH's tests,
  deliberately.
- Before chasing the tests' "Free routine not called": the message is wrong —
  the test never increments its counter, so that branch is always taken; the
  real assertion is `extrastate .ne. 0` above it, and `free_fn` does run.

### Registered datareps are not implemented, by either implementation

`MPI_Register_datarep` forwards its Fortran callbacks correctly now, and
nothing will ever call them:

- MPICH's ROMIO rejects non-NULL conversion functions
  (`MPI_ERR_CONVERSION`), and `MPI_File_set_view` accepts only `native`,
  `external32` and `internal` anyway, so even an accepted datarep can never
  be used.
- Open MPI accepts the call and does nothing: `ompio` registers as component
  version 3.0.0 and only 2.0.0 components are consulted for
  `register_datarep`, so `MPI_Register_datarep` is a silent no-op (and
  duplicate registration wrongly succeeds). Worth reporting upstream, not
  yet; needs a reproducer first.

What mpif can be held to: it no longer refuses the call before MPI sees it
(`test/datarep_f08.f90`, on the one combination ROMIO accepts), and the
trampolines marshal correctly (`test/datarep_c.c` calls them directly — the
substitute for an end-to-end test until an implementation grows the feature).

### MPICH: attributes on predefined datatypes aborted in ABI builds — fixed upstream

<https://github.com/pmodels/mpich/issues/7916>

Where weak symbols were unavailable (macOS: `#pragma weak` ICEs gcc on
Mach-O), MPICH built a separate profiling library, and
`mpi_abi_util.c` — which holds the `abi_datatype_builtins[]` table and its
initialiser — was compiled into both libraries. `MPI_Init` filled
`libmpi_abi`'s copy; the attribute proxies lived in `libpmpi_abi`, whose copy
stayed zeros, so `MPI_Type_set/get_attr` on a predefined datatype asserted.
Linux builds had weak symbols, one library, one table, and could not hit it.

Fixed on `main` by
[2eb9a812](https://github.com/pmodels/mpich/commit/2eb9a812025d5b22703fd35398714ba1c9e4f218),
and then made unreachable: `main` grew a weak-symbols-without-alias branch
(`HAVE_PRAGMA_WEAK` is now the macro `configure` defines here), so no second
library is built anywhere and there is no second table to leave uninitialised.
`lib/libpmpi.*` is out of `ci-scripts/mpich-prune.txt` for that reason —
`prune-install.sh` warns about a pattern that matches nothing, and a permanent
warning on every install is worth less than the pattern. Reproducer:
`bug-mpich-7916/mpich-abi-attr-bug.c`, pure C, passing on the pinned commit.

### OpenMPI: an empty info value was rejected — fixed upstream, patch dropped

<https://github.com/open-mpi/ompi/issues/14246>

`MPI_Info_set(info, "key", "")` returned `MPI_ERR_INFO_VALUE`; the standard
gives the empty value a defined meaning on two reserved keys. Fixed upstream
(commit `5e21b7b2`, PR 14247), now an ancestor of the pinned commit, so the
local patch is gone. Reproducer: `bug-ompi-info-value/`.

- It reaches Fortran through blank-stripping: a value of all spaces becomes
  the empty string. `test/info_blanks_f08.f90` deliberately does not assert
  on it, the assertion being about the implementation rather than mpif.
- Note for the next carried patch: under macOS bash 3.2 with `set -u`, an
  empty `patches` array must be expanded as `${patches[@]+"${patches[@]}"}`.

### OpenMPI: `MPI_Info_create_env` changes across `MPI_Init`

<https://github.com/open-mpi/ompi/issues/14297>

The env info differs before and after `MPI_Init` (`maxprocs` and `soft` 0
before, 1 after; `host` differs; `wdir` unset before), failing `infocrenvf`
and `infocrenvf90`. MPI-5.0 (ch. 10) requires multiple calls with the same
input arguments to agree, and the Fortran binding has no arguments. The
sparse pre-init object could be defended as "incompletely populated" —
but §11.2.1 defines `maxprocs` as the value *requested*, and no launch
requested zero processes, so the placeholder contradicts the key's
definition; the permitted fix is to omit the key. Matters beyond the suite:
asking how the process was launched without the World Model is the
procedure's stated purpose. Pure C, no reproducer kept —
`bug-ompi-info-create-env/` should get one.

### OpenMPI: object names where the standard asks for an empty string

<https://github.com/open-mpi/ompi/issues/14298> (the window half)

MPI-5.0 §7.8: get_name returns "the name previously stored on the object, or
an empty string if no such name exists". Reproducer:
`bug-ompi-object-names/ompi-object-names.c`, pure C.

- **A fresh window has a name** (`"rdma window 3"`): each osc component
  overwrites the correctly-empty `w_name` with its own composed string after
  construction (`rdma`, `ucx`, `portals4`, `ubcl`; `sm` does not) — so the
  answer depends on component selection, an inconsistency inside Open MPI.
  Fails `winnamef*`. Any patch should note the only internal consumer of
  `w_name` is the debug dump in `ompi/win/win.c`.
- **`MPI_TYPE_DUP` invents a name** (`"Dup a vector type"`), which nobody
  stored. Weaker: the standard does not say whether dup carries the name
  over, but a synthesised name is hard to defend under either reading.
  Fails `typesnamef*`. A question for the standard rather than a defect to
  file; not recorded as having been asked.

### OpenMPI on macOS: a nonblocking collective write is lost when the aio queue fills — carried as a local patch

Symptom: `f08/io/i_fcoll_test` reads back zeros;
`mca_fbtl_posix_ipwritev: error in aio_write(): Resource temporarily
unavailable`. Four separable defects in the posix fbtl (Open MPI 6.1.0a1):

1. The in-flight limit comes from `sysconf(_SC_AIO_MAX)` (system-wide
   `kern.aiomax`, 90) where the per-process limit is `kern.aioprocmax` (16).
2. The EAGAIN retry loop cannot work: slots are freed by `aio_return`, whose
   only caller is the progress function, assigned *after* the loop.
3. The failure is discarded — the ipwritev return value is assigned to
   nothing, and `MPI_File_iwrite_all` is not collective in ompio (no fcoll
   component implements it), so nothing aggregates the fragmented view.
   `MPI_Wait` then reports `MPI_SUCCESS` on a request nobody progressed.
4. The error path frees the aiocbs with operations outstanding and reaps
   none, retiring every slot the process has — all later nonblocking file
   I/O fails too.

- Reported as open-mpi/ompi#14278, patch open-mpi/ompi#14279;
  carried as `ci-scripts/openmpi-fbtl-posix-aio.patch` (reads
  `kern.aioprocmax` on Darwin, exposes it as an MCA parameter, replaces the
  retry with back-pressure, acts on the fbtl's return, reaps before
  freeing). Both reproducers in `bug-ompi-aio-eagain/` pass with it and fail
  with it reverted. If upstream reshapes the fix, this entry and the patch
  follow it.
- There is no run-time workaround: measured, `fbtl_posix_priority`, `fcoll`
  settings do nothing (fcoll is not in the path), `--mca fbtl ^posix` leaves
  no fbtl, ROMIO is gone.
- The blocking path (`pwritev`, no aio) is unaffected, measured.
- Left alone, both reachable only from genuine I/O errors: the discarded
  return values in the blocking paths, and the partial-completion re-post in
  the progress function.
- Related but distinct: `i_fcoll_test` under flang fails on both
  implementations because flang's `STOP` prints an IEEE-exceptions line after
  "No Errors", which `runtests` counts as unexpected output — not an MPI
  defect. Still untriaged: `*/*/linux/24.04/*`, where the aio message is
  absent and this patch changes nothing (see "Worth doing next").

### OpenMPI: left to itself it picks an interface it cannot use

Everything here runs on one host, and Open MPI given a free choice takes a
non-loopback interface and fails on it: on macOS
`setsockopt(TCP_NODELAY) failed: Invalid argument`, then hangs (180 s per
spawn test); on GitHub's x86_64 runners it picked the `docker0` bridge.
`--mca btl_tcp_if_include lo0` (macOS) / `lo` (Linux) settles it, passed in
all three places that run the suite: the CI step,
`scripts/macos-test-mpich-suite.sh`, and each `docker/openmpi-*.dockerfile`.

### OpenMPI: a spawned child is not reachable over TCP on the x86_64 runners

Eleven Open MPI spawn tests print "No Errors" and then abort in teardown —
"failed to TCP connect to a peer MPI process" at `127.0.0.1:1025`, then
`An error occurred in Socket closed`. Why only the x86_64 runners is not
established (the aarch64 runners, same Open MPI, same mpif, do not abort);
not reproduced in C for want of an x86_64 Linux Open MPI to hand. Carried as
expected failures under `openmpi/*/*/*/x86_64` with the abort as the reason.
The arithmetic that supports the diagnosis: subtracting the eleven makes the
x86_64 baseline rows equal their aarch64 twins.

### MPICH: a spawned child connects back to whatever `gethostname()` resolves to

Fails every MPICH spawn test in the suite, 180 seconds each, on a machine
whose own name resolves somewhere else — this machine, since the local
network changed in August 2026 (`CLAUDE.md` "This machine").

- Mechanism: ch3:nemesis:tcp builds its business card from, in order,
  `MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE`, `MPIR_CVAR_CH3_INTERFACE_HOSTNAME`,
  `MPIR_pmi_hostname()`, then an interface scan. With neither CVAR set the
  hostname wins, the parent advertises an address that is not its own, and
  the child times out connecting back.
- Diagnosis on sight: compare the `ifname#` field in the error against
  `ifconfig`; if the machine has no such address, this is it. The DNS
  round-robins, so do not expect the same address twice.
- Measured with a ten-line C spawn program, no Fortran — which is what rules
  mpif out. `NEMESIS_TCP_NETWORK_IFACE=lo0` passes in 0.08 s;
  `CH3_INTERFACE_HOSTNAME=127.0.0.1` also works (MPICH errors if both are
  set; the interface form leaves the address choice to MPICH).
- Fix: `scripts/macos-test-mpich-suite.sh` exports
  `MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE=lo0` for MPICH — the suite is one
  machine talking to itself, so loopback is all it needs, and pinning it
  makes the run independent of the network.
- Deliberately **not** `xfail`ed and CI untouched: the tests pass with the
  interface pinned, and CI runners' names resolve to themselves.

### MPICH: suite tests that cannot pass against a conforming binding

Each carried in `ci-scripts/suite/mpich-suite-xfail.txt` with a reason
pointing here.

- **`bsendf`, `bsendf90`** attach a 400-byte buffer for a 10-integer send.
  The ABI's `MPI_BSEND_OVERHEAD` is 512 (a bound over all implementations;
  MPICH's own is 96), and an ABI MPICH checks against it: "Buffer size of
  400 is smaller than MPI_BSEND_OVERHEAD (512)". MPICH-only — Open MPI's
  attach has no size check beyond `size <= 0`.
- **`dgraph_wgtf`, `dgraph_unwgtf` + f90/f08 copies** create a ring with
  `reorder = .true.` and then check neighbours against ranks in
  MPI_COMM_WORLD — valid only if the reorder did not reorder, and MPI-5.0
  explicitly frees the library to remap. Open MPI's `treematch` component
  remaps (deterministically, machine-dependent); MPICH never does, which is
  what the test was written against. Scoped in the xfail file to the
  variants where remapping has been seen (`openmpi/*/darwin/26/arm64` and
  the Ubuntu 26.04 arm64 image; toolchain wildcarded because `treematch` is
  C, OS version pinned because macOS 15 does not remap) — CI's Open MPI
  runners pass these today and may stop at any time without anything having
  changed on this side.
- **`allctypesf` + f90/f08** run `MPI_LB`/`MPI_UB` past `MPI_Type_get_name`;
  both were removed in MPI-3.0 and are not in the ABI header, so mpif does
  not define them either.
- **`attrmpi1f08`** hands the MPI-2 callback `MPI_COMM_NULL_COPY_FN`
  (address-sized attributes) to the MPI-1 routine `MPI_Keyval_create` (plain
  INTEGER attributes); it cannot typecheck and fails to build. On a 32-bit
  platform the kinds coincide and it *passes*, so its xfail is enumerated per
  64-bit architecture (`arm64`, `aarch64`, `x86_64`) rather than `*`.
- **`statusconv`** declares MPICH's own spelling `MPI_F08_status` where the
  ABI says `MPI_F08_Status`; fails to build, in C.
- **`f08/profile1f90`** interposes `mpi_send_f08ts`, the scheme-1B specific
  name — which mpif now has wherever `MPIF_HAVE_CFI` is on, so the test
  passes there and is no longer in the xfail file. A variant whose probe
  falls back to `ignore_tkr` is scheme 1A again and would need a
  per-variant xfail re-added; no such variant exists in CI or locally.

### MPICH: the f08 copy of `spawnargvf90` contradicts the standard and its own f90 copy

Both copies spawn with `inargv(5) = " Ss"`. MPI-5.0 is explicit for `argv` —
"leading and trailing spaces are always stripped" — and the f90 copy expects
`"Ss"` and passes; the f08 copy expects `" Ss"` and fails. An inconsistent
hand-conversion; `f08/spawn/spawnargvf90` and `spawnargvf03` keep failing
while mpif follows the standard. Same species as pmodels/mpich#7922; no
decision recorded on filing it.

## Missing features

### What the runtime consistency checks deliberately do not do

(`src/mpif_check.c`; semantics in `CODE.md` "Runtime consistency checks".)

- **No `mpif_get_version` query.** The point of knowing the loaded version is
  comparing it against the compiled-against one, and a query hands that
  comparison to every caller to reimplement; `mpif_check_version` keeps the
  SameMajorVersion rule in the library. A library too old to have the symbol
  fails at resolution — crude, but a startup failure rather than silent skew.
- **No `mpif_pcheck_*` P forms.** §15.2 requires P entry points of *MPI*
  procedures; these are mpif's own, and there is nothing under them to
  profile. (Contrast `mpif_psizeof_*`, which exist because `MPI_SIZEOF` is
  the standard's.)
- **`mpif_check_environment` reads `MPI_Abi_get_fortran_booleans` and never
  writes.** Registered values disagreeing with mpif's compiler abort — the
  skew the check exists for. Nothing registered passes silently: §20.4.1
  makes the first setter permanent, so writing from a checker that may run
  at any time would be a behavioural change disguised as a check. Whether
  mpif should register its booleans at initialization is a real question,
  for somewhere that runs exactly once.
- Measurement note: `check_env_mpiexec_fail` runs the binary launcher-less
  with `SLURM_NTASKS=4`, relying on neither implementation's singleton init
  reacting to that variable alone — measured on all four local variants;
  CI re-measures on every run. If an implementation grows such a detector,
  this is the test that starts failing.

### What the cross-tests deliberately do not do

(See "Choosing the MPI at run time" in `CODE.md`.)

- **The suite's cross-runs relink rather than swap libraries under fixed
  binaries**: macOS SIP strips `DYLD_*` across every exec of a protected
  binary, and `runtests` is `/usr/bin/perl` — the variable would vanish
  silently. The suite recompiles every test per run anyway. `test/` is where
  the same-binary swap is tested, under `ctest`, whose process chain has no
  SIP-protected link; `MPIF_TEST_MPI_LIBRARY` fails loudly if the swap
  silently stops happening.
- **`find_package(MPI)`'s one link check stays.** It links one trivial
  program against the generic ABI library, runs nothing, and bakes nothing
  in; removing it would mean replacing FindMPI for no gain.
- **Byte identity of the two libraries is reported, not required.** CI's
  cross job requires identical `include/` and identical exported/undefined
  symbol lists; the bytes differ on every platform for meaningless reasons
  (debug-info build paths, linker ids, timestamps).

### Assumed-rank choice buffers

**Taken on 2026-08-09, for `mpi_f08` and where the toolchain can do it** —
reversing the decision this section carried before that date. Where CMake's
`MPIF_HAVE_CFI` probe passes, `mpi_f08`'s choice buffers are
`TYPE(*), DIMENSION(..)` with INTENT and ASYNCHRONOUS exactly as A.4 gives
them, under Table 19.1's scheme-1B `_f08ts` names, routed through `bind(C)`
interfaces to the cdesc entry points of `gen/mpif_f08_cdesc.c`, and
`MPI_SUBARRAYS_SUPPORTED` and `MPI_ASYNC_PROTECTS_NONBLOCKING` are `.TRUE.`
there. `mpif.h` and the `mpi` module keep `integer buf(*)` under the
directives and `.FALSE.`, the line MPICH draws too. See "The cdesc layer" in
`CODE.md` for how a descriptor becomes a call.

The probe (`cmake/cfi-probe/`) compiles, links and runs a two-language
program and checks the descriptors' contents, never compile acceptance
alone: nvfortran accepts the gfortran directive without honoring it
(open-mpi/ompi#11582), and MPICH's compile-only TS check false-passed and
then died at link (pmodels/mpich#6505). Where the C compiler does not ship
`ISO_Fortran_binding.h` — Homebrew's clang and flang are separate kegs, and
FreeBSD compiles C with clang and Fortran with gfortran —
`cmake/cfi-include-dir.cmake` finds the Fortran compiler's copy and copies
that one header into a directory of its own (never `-I` where it lives:
gfortran's sits beside gcc's `stddef.h`, which clang rejects); the probe and
the cdesc sources use the same answer. A toolchain that fails the probe — or
`-DMPIF_ENABLE_CFI=OFF`, which is how the branch stays testable — keeps
the old form, which stands in the `#else` branches of `gen/`: regenerating
with `emit_cfi = false` in `dev/mpiapi.jl` reproduces the pre-axis files
byte for byte, and any generator change owes that branch the same check.

Why the reasons changed. The cost recorded here was "a second mechanism …
for compilers without Fortran 2018", and by 2026 that names two shrinking
lineages. Measured on this machine (gfortran 15, flang 22): `bind(C)`
assumed-rank, `ISO_Fortran_binding.h` descriptors, no-copy noncontiguous
sections, scalar and character actuals, ASYNCHRONOUS — all work. Documented:
ifort since 16.0, ifx (full F2018) since 2023.0, Cray CCE since 8.7. The
holdouts are nvfortran (CFI capped at rank 7, `SELECT RANK` never planned,
the vendor's full F2018 being its LLVM-flang successor) and classic-flang
AOCC ≤ 5.2 (no assumed-rank at all; AOCC 6 is announced as LLVM-flang
based) — and both lineages implement `!dir$ ignore_tkr` natively, so the
fallback covers exactly them. LLVM flang's own assumed-rank completed after
the 19 branch (llvm-project#95990, filed because MPICH's mpi_f08 would not
build); flang 20.1 is the first release with it. Two corrections recorded
on the way: *released* Open MPI (≤ 5.0.x) hard-codes
`MPI_SUBARRAYS_SUPPORTED = .false.` with every compiler — its
`OMPI_FORTRAN_HAVE_TS` probe and "ts" bindings exist only on `main` — and
Intel implements neither `!dir$ ignore_tkr` (Cray/SGI lineage, not DEC)
nor `!gcc$`, which is why the fallback emits
`!dec$ attributes no_arg_check` as a third spelling.

What remains are decisions, not oversights:

- **The reduction family requires contiguous buffers**, refusing a
  noncontiguous section with `MPI_ERR_BUFFER`. MPI-5.0 §6.9.1: "Predefined
  operators work only with the MPI types listed in Section 6.9.2 and
  Section 6.9.4" — a datatype walked from the descriptor's strides may not
  meet `MPI_SUM`, and under a user-defined op the walked type would reach
  the user's function in place of the one they wrote it against. MPICH's
  cdesc layer walks anyway and its own library then aborts —
  "MPI_Op operation not defined for this datatype", measured here when the
  first version of this path copied MPICH's shape. Packing instead would
  need completion hooks for the nonblocking and persistent forms. The RMA
  accumulates stay walkable: §12.3.4 admits derived types whose basic
  components are one predefined type. `test/reduction_noncontig_cfi_f08.f90`
  pins the refusal; `test/inplace_cfi_f08.f90` the sentinel beside it.
- **The v/w collectives, `MPI_Reduce_scatter`, the raw-byte pack buffers
  and the partitioned init routines also require contiguity** — no scalar
  (count, datatype) pair to walk with, or a partitioning a walked type
  could not preserve. The same loud refusal, where MPICH passes the base
  address silently and sends the wrong bytes.
- **A cdesc-layer error returns through `ierror` without invoking the
  communicator's error handler** — MPICH's layer does the same. Under
  `MPI_ERRORS_ARE_FATAL` a program sees a return code here where the
  standard would have it abort.
- `mpif_cdesc_is_sentinel` is belt and braces: a sentinel actual is a
  one-element array, always contiguous, so it cannot reach the walker
  anyway. A drill removing it fails no test, and it stays because it
  documents intent and guards a compiler that reports a one-element
  section noncontiguous.

### The mpi module's `_c` names

`gen/mpif_functions.F90` declares `MPI_Send_c` and its kin beside the
small-count names, so `use mpi` and `mpif.h` can reach the large-count entry
points. The standard gives no such binding (A.5 has no `!(_c)` markers;
§19.1.4 says the older bindings gained nothing beyond MPI-3.1).

- For removing: it puts an mpif invention in the `MPI_` namespace, against
  the Namespace rule in `CODE.md`; neither implementation declares one.
- For keeping: without them the older bindings cannot send more than
  `huge(0)` elements at all, and the underlying symbols must exist for the
  f08 layer regardless.
- **Unresolved, deliberately** — a judgement about offering a useful
  non-standard name. Whoever settles it should decide the `mpif.h` half with
  it, and `MPI_CONVERSION_FN_NULL_C` too: `src/mpif_attr_fns.F90` defines it
  and `include/mpif_attr_fns.h` declares it for the older bindings, where
  A.1.1 marks it `(n/a)` outside C and `mpi_f08` — the same question, no
  code change either way.

### Fortran-set attribute values are not visible to C as a pointer

The one mpif defect the suite still reports (four tests on all twelve
variants: `attrlangf90/f08`, `fandcattrf90/f08`). MPI-5.0 §19.3.7: when an
integer-valued attribute is accessed from C, get_attr must return "the
address of (a pointer to) the integer-valued attribute". mpif's wrapper
hands MPI the value itself (`MPI_Comm_set_attr(comm, keyval,
(void*)*attribute_val)`), so a conforming C reader dereferences a number.
Only the Fortran-sets/C-gets cases are wrong; the other directions are
correct.

What a fix needs — a feature, not a correction:

- storage owned by mpif with a stable address, one `MPI_Aint` per
  (object, keyval) pair;
- a language tag per stored attribute (the standard's advice to implementors
  says so), since mpif cannot see the implementation's tag through the ABI;
- a lifetime: release on delete, on overwrite, and on the object's free —
  the keyval registry in `src/mpif_callbacks.c` is where it would go, but
  the key is wider and the frees are new;
- copy-callback handling: a duplicated attribute needs storage of its own
  (`fandcattrf90` tests exactly this).

No test in `test/`, deliberately: it would be a failing test rather than an
assertion, and the four suite tests state the requirement. Write one with
the fix.

### `bind(C)`

Only the cdesc interfaces (module `mpif_f08_cdesc`, `MPIF_HAVE_CFI` branch)
are declared `bind(C)`; there the descriptors require it and the strings'
lengths are explicit `integer(c_size_t), value` arguments. Every other
generated entry point relies on the compiler lowercasing names and appending
one underscore, and on hidden character lengths being appended as `size_t`.
Correct for gfortran ≥ 8 and flang; an unstated assumption otherwise
(gfortran < 8 passed hidden lengths as `int`).

### Publishing the Fortran type information to the MPI library

Not needed as things stand: mpif builds against implementations that have
their own Fortran bindings, so the library already knows the type sizes and
boolean representation — `test/version_c.c` asserts it. The set-side calls
(`MPI_Abi_set_fortran_info`/`_booleans`) would only be needed to make mpif
the *sole* provider, so the implementation could be built without Fortran —
worth remembering as an option (it would sidestep the flang/libtool problems
on macOS), but a change of approach, and the first setter is permanent, so
the two modes cannot simply be combined.

### Hand-maintained pieces that could drift

- The f08 callback abstract interfaces (`src/mpif_f08_types.F90`) and the
  predefined callbacks (`src/mpif_attr_fns.F90`,
  `src/mpif_f08_attr_fns.F90`) describe things `apis.json` also describes,
  and are not generated. The known divergences are fixed and the generator's
  kind tables now accommodate them, so generating them is what remains of
  the job. Drift risk is smaller than it was:
  `dev/check-f08-bindings.jl` holds the f08 sets to A.1.3/A.4; the
  `mpif.h`/`mpi`-module predefined callbacks are the one set checked by
  nothing but a past audit (A.5 gives them, so the same tool could reach
  them).
- `src/mpif_f08_constants.F90` re-exports constants from the `mpi` module by
  hand, one `use` and one `public` line per name, and nothing diffs those
  lists against `include/mpif_constants.h` — one missing pair among hundreds
  is invisible (it has happened; `test/version_f08.f90` pins the instance).

### MemorySanitizer cannot be run against an MPI

MSan is the instrument that would answer "was this byte ever written", and
it cannot be used here; any one reason is enough:

- It requires the whole process instrumented, i.e. rebuilding libmpi — the
  very library mpif must not assume anything about. ASan's boundary is
  workable (an address is meaningful whoever allocated it); MSan's is not.
- No toolchain here can instrument both languages: flang has no `-fsanitize`
  at all, and MSan is Clang-only.
- It is unavailable on arm64 Darwin regardless.

What is left is reading the code and, for a specific buffer, an `mmap`ed
guard page. Recorded so "add an MSan build" is not proposed again as though
it were an oversight.

## Worth doing next, roughly in order

1. **Fortran-set attribute values as C sees them** — the one mpif defect the
   suite still reports; see "Missing features" above.
2. **`i_fcoll_test` on CI's Linux runners, the last untriaged entry** in
   `ci-scripts/suite/mpich-suite-xfail.txt`. Not the macOS aio defect (the
   message is absent) and not the flang `STOP` output; passes on Ubuntu
   26.04, fails on 24.04. Start from the "## Test output" block in the run's
   TAP file.
3. **Triage `mpich/gcc/freebsd/14/amd64`** from the first green `freebsd`
   job: read the differences, give each a reason, add the `xfail` lines and
   then the `triaged` line. Expect `attrmpi1f08` (the `amd64` spelling);
   treat anything else as a real question about a platform nothing here had
   run on.
4. **Triage `mpich/gcc/linux/26.04/armv7l`**, the one 32-bit variant without
   a `triaged` line (emulated, local-only; CI does not run it). Do not carry
   the i686 list over: different 32-bit ABIs, different alignment.

Upstream reporting status — the sections above are the authority; this is a
summary:

- Not yet reported: the ABI stubs header's partitioned count (goes to
  `mpi-forum/mpi-abi-stubs`; correction already in `fortran/mpi.h.patch`);
  Open MPI's `MPI_Register_datarep` no-op (needs a reproducer first).
- Filed and open: open-mpi/ompi#14278/#14279 (aio, with patch),
  open-mpi/ompi#14297 (info_create_env), open-mpi/ompi#14298 (window name),
  pmodels/mpich#7922 (grequest tests). Where a patch was held back, the
  local one is provisional: an upstream fix of a different shape supersedes
  it — which is what happened to pmodels/mpich#7929 (f90 datatypes) and
  #7930 (get_contents), both fixed on `main` in a shape of upstream's own
  and both still open as issues.
- Undecided: filing the `spawnargvf90` f08-copy inconsistency.

## Suite baseline

`ci-scripts/suite/mpich-suite-xfail.txt` is the authority: it names every
expected failure with its reason, and a suite run fails on any difference
from it, in either direction. Count entries rather than trusting a number:

    awk '$1=="xfail"||$1=="flaky"' ci-scripts/suite/mpich-suite-xfail.txt | wc -l

The table below is CI's twelve native variants, as failures out of 104 f77,
122 f90 and 136 f08 tests, for telling a change from the background noise at
a glance. It derives from the run of `baa7f65` adjusted for fixes landed
since (derivations in `HISTORY.md`); some rows are inferred from their twin
rather than re-measured, and CI is what confirms them.

| variant                          | f77 | f90 | f08 |
|----------------------------------|-----|-----|-----|
| mpich/gcc/darwin/15/arm64        |   3 |   9 |  11 |
| mpich/gcc/linux/24.04/x86_64     |   3 |  10 |  12 |
| mpich/gcc/linux/24.04/aarch64    |   4 |   9 |  12 |
| mpich/llvm/darwin/15/arm64       |   3 |   9 |  11 |
| mpich/llvm/linux/24.04/x86_64    |   4 |  10 |  12 |
| mpich/llvm/linux/24.04/aarch64   |   4 |  10 |  12 |
| openmpi/gcc/darwin/15/arm64      |   5 |   7 |  12 |
| openmpi/gcc/linux/24.04/x86_64   |   8 |  12 |  15 |
| openmpi/gcc/linux/24.04/aarch64  |   5 |   7 |  12 |
| openmpi/llvm/darwin/15/arm64     |   5 |   7 |  12 |
| openmpi/llvm/linux/24.04/x86_64  |   8 |  12 |  15 |
| openmpi/llvm/linux/24.04/aarch64 |   5 |   7 |  12 |

- This machine's rows are not in the table (`darwin/26`): measured locally
  after the assumed-rank change, `mpich/gcc/darwin/26/arm64` reports no
  differences at 3/5/8, `mpich/llvm` at 3/5/9, `openmpi/gcc` at 7/9/13 and
  `openmpi/llvm` at 7/9/14.
- The two Open MPI x86_64 rows are higher by exactly the eleven spawn tests
  ("a spawned child is not reachable over TCP" above).
- Thirteen of CI's fourteen variants are `triaged` (the twelve above plus
  `mpich/gcc/linux/13/i686`, which gates on three consecutive agreeing
  runs), so any difference there fails the run. Not gating:
  `mpich/gcc/freebsd/14/amd64` (unmeasured) and
  `mpich/gcc/linux/26.04/armv7l` (emulated, local-only). The other
  `triaged` lines are environments outside CI.
- Most rows rest on a single measurement, so expect some churn: a flaky
  entry surfaces as an unexpected pass, which is the mechanism working.
- `test/`, mpif's own suite, is 75 of 75 (`ctest`'s count; `add_mpi_test`
  registers 67 — the runtime-check and `mpif_info` groups use bare
  `add_test` for cases that are about the launch environment rather than a
  binding). Green on all four local variants, each against both runtime
  MPIs, and the AddressSanitizer variants likewise.

Two ways a *local* suite run goes wrong for reasons that are not the code:

- **Do not rebuild while a suite run is going**: `scripts/macos-build-mpif.sh`
  removes the `mpifort` the running suite is using, and every remaining test
  reports `Failed to build ... mpifort: No such file or directory` — looks
  catastrophic, means nothing.
- **MPICH's spawn tests depend on the machine's hostname staying put.** If
  the name changes under the run (DHCP, a network move), the child cannot
  reach the address the parent published. Rerun before believing it.
