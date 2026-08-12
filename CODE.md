# The code

What mpif is made of, how the pieces fit, and why the arrangements that look
odd are the ones they are. What it still gets wrong or does not do is
`MISSING.md`; how to build, test and verify it is `CLAUDE.md`; how the settled
questions below were originally found and verified is `HISTORY.md`.

## Layout

    data/apis.json      the MPI Forum's machine-readable API description, 567 entries
    dev/mpiapi.jl       the generator: reads that, writes all of gen/
    gen/                generated and committed; never edit by hand
    src/                the hand-written half -- modules, callbacks, C helpers
    include/            mpif.h and the headers it includes, all hand-written
    test/               mpif's own tests, one executable each
    ci-scripts/         installing the implementations, running MPICH's suite
    fortran/            the ABI stubs header and the patches carried against it

`dev/mpiapi.jl` emits four files; the split is the shape of the binding:

    gen/mpif_functions.c          Fortran-callable C entry points, `mpi_send_`
    gen/mpif_functions.F90        module mpif_functions: interfaces to those
    gen/mpif_f08_functions.F90    module mpif_f08_raw + module mpif_f08_functions
    gen/mpif_f08_wrappers.F90     the mpi_f08 wrapper bodies, external procedures

A call takes one of two routes to C:

- From `mpif.h` or the `mpi` module: direct — the interface in
  `mpif_functions` names the external symbol `mpi_send_`, which
  `gen/mpif_functions.c` defines and which calls C's `MPI_Send`.
- From `mpi_f08`: one step longer — the generic `MPI_Send` resolves to the
  external specific `MPI_Send_f08`, which converts the derived-type handles
  and calls the same `mpi_send_` under the alias `MPIF_Send`.

Every routine exists twice over besides, under its `MPI_` and its `PMPI_`
name.

## Module structure

- `src/mpi.F90` and `src/mpi_f08.F90` are thin: they `use` the modules
  beneath them and add only the generics that must be declared where both
  halves are visible — the `TYPE(C_PTR)` overloads of `MPI_Alloc_mem` and the
  window allocators, whose two specifics come from two different modules.
- `src/mpif_handle_types.F90` sits below *both* `mpi` and `mpif_f08_types`,
  because of a circular-use constraint. MPI-5.0 §19.1.3 requires the `mpi`
  module to "Define the derived type MPI_Status and all named handle types
  that are used in the mpi_f08 module", with `.EQ.`/`.NE.` overloaded, and
  A.5.13 marks `MPI_Status_f2f08`/`MPI_Status_f082f` "not available with
  mpif.h" — required in the `mpi` module, exempt only for the include file.
  One set of types, not two: a `TYPE(MPI_Status)` from `use mpi` is the very
  type `mpi_f08` expects (`test/handle_types_f90.f90` asserts it).
  `mpif_f08_types` cannot host them (it does `use mpi, only:` for its
  PARAMETER handle constants, so `mpi` using it back would be circular); the
  definitions go down to a module whose only dependency is `mpif_constants`.
- The handle *constants* stay where they were: `MPI_COMM_WORLD` is an INTEGER
  parameter in `mpif.h`/`mpi` and a `TYPE(MPI_Comm)` parameter only in
  `mpi_f08`. `mpif.h` gets no derived types at all.
- Open MPI reads §19.1.3 the same way (`ompi/mpi/fortran/use-mpi/mpi-types.F90`);
  MPICH declares two distinct type sets and lacks the two status converters in
  its `mpi` module.

## Namespace

- Only what the MPI standard defines may be spelled `MPI_` or `mpi_`;
  everything mpif invents is `mpif_` or `MPIF_`.
- Two modules are the standard's: `mpi` and `mpi_f08`. The twelve installed
  beneath them are `mpif_constants`, `mpif_handle_types`, `mpif_types`,
  `mpif_functions`, `mpif_cptr`, `mpif_attr_fns`, `mpif_check_fns`,
  `mpif_f08_constants`, `mpif_f08_types`, `mpif_f08_functions`,
  `mpif_f08_attr_fns` and `mpif_f08_raw`. Their `.mod` files follow, which
  avoids real collisions: MPICH installs an `mpi_constants.mod`, Open MPI an
  `mpi_types.mod` and `mpi_f08_types.mod`. `mpif_check_sentinel_fn` is a
  thirteenth and is deliberately *not* installed — it holds one `bind(C)`
  interface that two internal subprograms share, nothing outside mpif calls it,
  and the `.mod` install list in `CMakeLists.txt` is explicit rather than a
  glob for exactly this reason.
- The Fortran entry points C provides — `mpi_send_`, ... — are named after
  the MPI routines they implement; everything else on the C side is `mpif_`.
- `MPI_Alloc_mem_cptr` and the three window `_cptr` overloads keep `MPI_`
  because the standard names them ("The base procedure name of this
  overloaded function is MPI_ALLOC_MEM_CPTR"). Their large-count counterparts
  are not in the standard (§19.1.5's implied-specific-name rules cover `_f08`
  and `_f`, not `_c_cptr`), so those are `mpif_win_allocate_c_cptr` and
  friends.
- The procedures behind `operator(==)`/`operator(/=)` on handle types are
  `mpif_comm_equal` and friends, private to `mpif_handle_types`; only the
  generics are public.
- In `mpi_f08` the callable names are generics; the specifics carry
  Table 19.1's `_f08` token (`MPI_Send_f08`, `MPI_Send_c_f08`) — the
  standard's names, not mpif's. See "The mpi_f08 specific procedure names"
  below.
- `PMPI_` is reserved to the implementation wholesale ("programs must not
  declare functions with names beginning with any prefix of the form PMPI_"),
  so mpif spells the P form of a standard name with `PMPI_`
  (`PMPI_Alloc_mem_cptr`). The P form of a name mpif invented takes `p`
  directly after the prefix — `mpif_pwin_allocate_c_cptr`,
  `mpif_psizeof_logical1` — so `mpif_p` greps every invented PMPI name.

## Runtime consistency checks

`mpif_check_version` and `mpif_check_environment` (`src/mpif_check.c`,
declared in `include/mpif_check_fns.h`) exist because the standard-ABI design
moves the choice of MPI library — and of mpif itself — to run time; MPI-5.0
chapter 20 frames the ABI version macros exactly this way.

- `mpif_check_version(major, minor, patch)` takes the caller's compile-time
  `MPIF_VERSION`/`MPIF_SUBVERSION`/`MPIF_PATCH` and aborts unless the loaded
  library has the same major and is at least as new in (minor, patch) — the
  SameMajorVersion rule CMake already applies at configure time, enforced
  again where the resolved shared library can differ from the one CMake saw.
- `mpif_check_environment()` checks what it can and aborts on the first
  inconsistency; the file's header comment enumerates the checks and the
  optional `MPIF_MPI_LIBRARY`/`MPIF_SIZE`/`MPIF_NUM_NODES`/`MPIF_NODE_SIZE`
  environment variables. Setting either node variable also makes rank 0 print
  the layout it gathered, accepted or not — the only case that had no witness
  was the accepted one (`MISSING.md` "The two node-layout tests flake"). Two
  contracts: outside the
  initialized-and-not-finalized window (MPI-5.0 §11.4.1, Table 11.1) only the
  version and library-name checks run, the rest skipped silently; inside it
  the function is *collective over MPI_COMM_WORLD*. Local checks run before
  the first collective so a detectable mismatch aborts rather than hangs, and
  the communication runs on an `MPI_Comm_dup` so a wildcard receive already
  posted cannot swallow the smoke test's token.
- All three bindings share the two external symbols; C callers declare
  `void mpif_check_version(int, int, int)` and
  `void mpif_check_environment(void)` themselves (`test/check_c.c`).
- mpif's version is written down twice — `project(mpif VERSION x.y.z)` and
  the parameters in `include/mpif_constants.h`. Two guards keep them honest:
  `ci-scripts/check-headers.sh` in CI, and `mpif_check_header_version`
  (`src/mpif_check_fns.F90`) at run time, which catches an install mixing
  pieces of two builds.
- `bin/mpif_info` (`src/mpif_info.f90`) is the installed face: under mpiexec
  or as a singleton it prints what was actually loaded — versions, the
  `MPI_Get_library_version` string, the `libmpi_abi` pathname the loader
  resolved (`src/mpif_info_dladdr.c`), process layout, the `MPI_Abi_get_*`
  keys — then runs both checks. Written against mpif's own `mpi_f08`, so a
  working `mpif_info` demonstrates that bindings, library and loaded MPI
  agree.
- `mpif_info` is linked like an ordinary application on purpose (`mpifort`,
  the ABI library alone, default rpath), so what it reports is what an
  application experiences. A dlopen design was rejected: a probe choosing its
  MPI through a private mechanism can report success while the application,
  resolving through the loader, loads something else.
- It is the only installed executable and the only target with an
  `INSTALL_RPATH` (mpif's libdir plus the default MPI's libdir, linked with
  `BUILD_WITH_INSTALL_RPATH` because macOS's `install_name_tool` refuses to
  grow load commands). Everything else links through `bin/mpifort`, which
  passes `-Wl,-rpath,<prefix>/lib`. The `mpif_info` tests run the *installed*
  binary, so the rpath is tested on every run.

## Choosing the MPI at run time

mpif is built against the C MPI ABI, and a build made against one
implementation works, unchanged, with any other that provides the ABI. Three
arrangements make that true:

- **`libmpifort_abi` links no MPI.** Its `MPI_*`/`PMPI_*` references stay
  undefined and resolve at load time from whatever `libmpi_abi` the
  application brought in (ELF default; ld64 needs `-undefined
  dynamic_lookup`). MPI-5.0 §20.2.1 requires implementations "not require
  more than mpi_abi or its versioned variant as the sole direct dependency of
  the application binary". Only the MPI header's include directory is taken,
  as a plain path rather than through `MPI::MPI_C`. Consequence, asserted by
  CI's `compare` job: the installed `include/` and the library's entire symbol
  table are identical whichever MPI the build was configured against.
- **Applications link `-lmpi_abi`, and the loader picks the implementation.**
  `bin/mpifort.in` links `-lmpifort_abi` plus a generic `-lmpi_abi` from
  `$MPIF_MPI_LIBDIR`; `MPIF_MPI_PREFIX` defaults to the baked build-time
  prefix and the environment can override it per link. `-showme:mpiprefix`
  reports it, which is how the test scripts derive mpiexec and mpicc. The
  libdir is not assumed to be `$MPIF_MPI_PREFIX/lib` — CMake takes it from the
  path FindMPI reports for `libmpi_abi` (`MPIF_MPI_LIBDIR` in
  `CMakeLists.txt`), because an MPI packaged for a `lib64` distribution or
  configured with `--libdir` puts it elsewhere; what the wrapper bakes in is
  that directory's name *relative to the prefix*, so the `MPIF_MPI_PREFIX`
  override still reaches it, and `MPIF_MPI_LIBDIR` in the environment names it
  outright when the substituted MPI's layout differs. `mpif_info`'s rpath gets
  the same directory, absolute. The
  executable records only the ABI library's conventional versioned name —
  `libmpi_abi.so.1` on Linux, `libmpi_abi.1.dylib` with compatibility version
  2.0.0 on macOS (the convention is stated in Open MPI's `ompi/VERSION`) —
  plus an rpath to the default prefix. The run-time chooser is the loader's
  search path: `LD_LIBRARY_PATH`/`DYLD_LIBRARY_PATH` puts the other
  implementation in front, same binary, no relink. On ELF the wrapper passes
  `-Wl,--enable-new-dtags` so the baked default is `DT_RUNPATH`, which
  `LD_LIBRARY_PATH` precedes. On macOS the export *style* gates the swap
  too: the implementations export `MPI_*` as weak definitions, and a Mach-O
  client linked against a weak-def export binds only to another weak
  definition (see `MISSING.md` "strong `MPI_*` exports on Darwin", which MPICH
  needed a patch for until recently).
  `ci-scripts/check-mpi-install.sh` asserts the versioned name — and, on
  Darwin, the compatibility version and the weak export — on every installed
  prefix.
- **CI tests the claim from both ends.** The twelve `mpif` and `suite` jobs
  test each mpif against its remembered default. Twelve `cross` jobs, one per
  direction, then run each pairing two ways: `test/` swaps the runtime under
  unchanged binaries via the loader's search path (with
  `MPIF_TEST_MPI_LIBRARY` asserting which implementation
  `MPI_Get_library_version` reports), while the MPICH suite relinks via
  `MPIF_MPI_PREFIX` — its harness runs through the system perl and shells,
  from which macOS SIP strips `DYLD_*`, and it recompiles every test anyway. A
  suite cross-run is gated against the *runtime* MPI's rows of
  `mpich-suite-xfail.txt`.

A consumer that goes through `find_package(mpif)` makes the same choice in its
own configure: `cmake/mpifConfig.cmake.in` locates `libmpi_abi` — an explicit
`MPI_mpi_abi_LIBRARY`, else `MPI_HOME`, else the ordinary search — and appends
it to `mpif::mpifort_abi`, so `target_link_libraries(app PRIVATE
mpif::mpifort_abi)` is the whole of it. Not finding one is *reported*, not
raised: the file sets `mpif_NOT_FOUND_MESSAGE`, sets `mpif_FOUND FALSE` and
returns, which is what lets a project depend on mpif optionally —
`message(FATAL_ERROR)` there would end the configure of a consumer that wrote
`find_package(mpif QUIET)`. A `REQUIRED` consumer is no quieter for it: CMake
raises its own error and quotes the message back. The `return()` comes before
`mpifTargets.cmake`, so a not-found mpif leaves no imported target behind for a
consumer to reach around `mpif_FOUND` and link against.
`ci-scripts/check-package-config.sh` is what keeps all three true —
`test-consume/` says `REQUIRED` and pins the library, so it passes either way.

## Static linking

`-DBUILD_SHARED_LIBS=OFF` builds `libmpifort_abi.a` instead of a shared library.
The MPI stays shared: the archive's `MPI_*`/`PMPI_*` references are deferred to
the consumer's link line, where `bin/mpifort` already supplies `-lmpi_abi`, so
everything above about choosing the implementation at run time still holds. A
fully static executable is not supported — see `MISSING.md`.

Install it into a prefix of its own. `bin/mpifort` links a bare
`-lmpifort_abi`, so an archive and a shared library in one libdir leave the
linker to choose, and it chooses the shared one.

### Separable wrappers

MPI-5.0 §15.2.1 asks (2) that MPI functions a profiler has not replaced "still
be linked into an executable image without causing name clashes" and (4) that
the wrappers of a layered Fortran binding be "separable from the rest of the
library". §15.2.5 says what separable means, and it is a statement about archive
members: they have to be extractable "using a tool such as `ar`" and "without
bringing along any other unnecessary code". A shared library satisfies both by
construction, the executable's definition winning at load time; an archive whose
one member holds every wrapper satisfies neither.

So a static build compiles each `MPI_` entry point on its own.
`MPIF_SPLIT_WRAPPERS`, on when `BUILD_SHARED_LIBS` is off, runs
`ci-scripts/split-wrappers.sh` at configure time over `gen/mpif_functions.c`,
`gen/mpif_f08_wrappers.F90` and `src/mpif_removed.c`. It is an option rather
than a plain `if(NOT BUILD_SHARED_LIBS)` so that both combinations can be built
on purpose — `scripts/macos-build-mpif.sh` passes `MPIF_SPLIT_WRAPPERS` through.

- **The cut is by marker, not by parsing.** `dev/mpiapi.jl` brackets every entry
  point with `MPIF-SPLIT-BEGIN <symbol>` / `MPIF-SPLIT-END`, and
  `src/mpif_removed.c` carries the same by hand. Whatever lies *outside* a
  region is shared prologue — the `#include`s, `gen/mpif_functions.c`'s five
  `#undef`/`#define` pairs, `src/mpif_removed.c`'s macros — and every part gets a
  copy of all of it. That is why the `PMPI_` bodies are marked too: an unmarked
  body would count as prologue, and would be duplicated into every part after it.
- **`MPI_` names only**, and one member per *symbol* rather than per routine.
  A profiling library holds the `MPI_` wrappers and calls `PMPI_` into the base
  library, so only the `MPI_` names have to be extractable and only they can
  clash; and §15.2.1(2) means a profiler that replaces `mpi_send_` but not
  `mpi_send_c_` must still link. The `PMPI_` forms go to one member per input.
  That policy is in the splitter rather than in the generator, so revisiting it
  does not mean regenerating `gen/`.
- **What it costs.** A clean static `mpich-gcc` build here went from 36 s to
  67 s and the archive from 27 members to 1218, of which 1186 are MPI entry
  points. Nothing else pays: a shared build compiles the three files whole,
  exactly as before.
- **The parts are outputs of a configure-time step**, so the splitter stamps its
  output directory and returns without touching anything when neither the input
  nor the splitter has changed. Without that, every `cmake` re-run would rewrite
  ~1200 files and force a full rebuild. `CMAKE_CONFIGURE_DEPENDS` on the same
  four files is what re-runs it.
- **The tests are `test/profile_f90` and `test/profile_f08`**, each replacing
  `MPI_Comm_rank` and `MPI_Barrier` with its own and reaching the real ones
  through `PMPI_`. They run under a static build as under a shared one — 78 tests
  either way. Build a static mpif with `MPIF_SPLIT_WRAPPERS=OFF` and both stop
  linking, on `duplicate symbol '_mpi_comm_rank_'` and `'_mpi_barrier_'` and on
  `'_mpi_barrier_f08_'` and `'_mpi_comm_rank_f08_'` respectively; measured.
  MPICH's suite covers the same ground independently, its `f77/profile`,
  `f90/profile` and `f08/profile` directories replacing `mpi_send` and `mpi_recv`.
  `docker/mpich-gcc-static-arm64v8.dockerfile` runs it against an archive and is
  the only thing that does: its stage reports no differences from
  `mpich/gcc/linux/26.04/aarch64`'s rows of `mpich-suite-xfail.txt`, those three
  among the passes, and a static run here says the same of
  `mpich/gcc/darwin/26/arm64`.
- **What the granularity actually is**, measured on the `mpich-gcc` archive:
  1186 members define exactly one `MPI_` entry point, one defines 273
  (`mpi_*_cdesc`), one defines fourteen (the predefined callbacks) and 29 define
  none. Each replaceable symbol is alone in its member *and* has no `PMPI_`
  symbol beside it — which is the part that matters, since a profiling wrapper
  reaches the real routine through `PMPI_` and would otherwise pull in the very
  `MPI_` definition it is replacing.
- **Two families are deliberately left together**: `gen/mpif_f08_cdesc.c`'s
  `mpi_*_cdesc`, which are names mpif invented and nothing replaces, and
  `src/mpif_attr_fns.F90`'s fourteen predefined callbacks, which A.1.1 makes
  constants rather than entry points. `ci-scripts/check-static-build.sh` excludes
  exactly those two by name; `MISSING.md` has the reasoning.

What a static link puts at risk is the two arrangements that publish *data*
across the language boundary, because an archive yields a member only when
something references a symbol in it. Neither chain is declared anywhere; both
were measured, on `mpich-gcc` with gfortran 15 and ld64, by deleting the member
with `ar d` and relinking:

- **The sentinel cells** (`src/mpif_constants.c`) are referenced from
  `gen/mpif_functions.c`, `gen/mpif_f08_cdesc.c`, `src/mpif_check.c` and
  `src/mpif_removed.c` — through the `static inline` translators of
  `include/mpif_sentinels.h`, which every wrapper that can be handed a sentinel
  inlines. Under `MPIF_SPLIT_WRAPPERS` those wrappers are a member each, so the
  chain is local rather than global: 277 of the archive's members reference
  `mpif_bottom_`, and pulling any one of them pulls the cells. A program that
  calls nothing able to take a sentinel therefore need not pull them, and on
  Mach-O pulls them anyway — ld64 loads a member to define a common symbol the
  link already has. Measured, `mpich-gcc`: a program calling only `MPI_Init` and
  `MPI_Finalize` still gets `__TEXT,__const` cells, and `-why_load` names
  `_mpif_argv_null_` as the cause. Not relied on, because whether GNU ld does the
  same was not measured: `bin/mpif_info` calls `MPI_Gather`, so the wrapper's own
  reference is there on either platform, and that is what
  `ci-scripts/check-static-build.sh` reads.
  **This failure is silent.** A consumer's COMMON block is a *definition*, not a
  reference, so with the member gone the link still succeeds and the program still
  works: the consumer's own tentative definitions win, C and Fortran resolve one
  symbol to one address, and every translation still matches. What disappears is
  both backstops behind the translation — the cells are no longer `const`, so a
  missed translation that writes scribbles instead of faulting, and no longer
  poisoned, so a missed read sends zeros instead of something conspicuous.
  Measured: `MPI_BOTTOM(1)` reads `0xBAADC0DE` through the archive's cell and
  `0x00000000` without it, and `test/check_f08` passes either way.
  `mpif_check_environment` cannot see this and does not claim to — it compares the
  Fortran sentinel's address against the cell, and those are one symbol whichever
  definition won. The section each cell landed in is the only discriminator:
  `__TEXT,__const` merged onto the archive's definition, `__DATA,__common` left to
  the consumer's. That is what `ci-scripts/check-static-build.sh` reads.
- **The `.TRUE.`/`.FALSE.` bit patterns** (`src/mpif_logical.F90`, a `BLOCK DATA`)
  are referenced from `src/mpif_logical.c`, itself reached from
  `gen/mpif_functions.c`, `src/mpif_callbacks.c` and `src/mpif_check.c`.
  **This failure is loud**: nothing outside mpif declares those two COMMON
  blocks, so there is no tentative definition to substitute and the link fails
  with `Undefined symbols: "_mpif_logical_true_", referenced from
  _mpif_bool2logical`. That asymmetry — silent for the sentinels, loud here — is
  exactly the difference between a block the consumer also declares and one it
  does not.

`ci-scripts/check-static-build.sh` is what keeps all of that true, and it is not
a duplicate of the run-time check. It requires the archive to be there with no
shared library beside it, `bin/mpif_info` to name `libmpi_abi` and *not*
`libmpifort_abi` among its dynamic dependencies, every sentinel cell in that
executable to be a defined read-only symbol, both logical symbols to be defined,
and no archive member to define more than one MPI entry point. It reads the cell
names out of `include/mpif_sentinels.h` rather than listing them, the way
`ci-scripts/check-headers.sh` does. For the last of those it unpacks the archive
with `ar x` into a temporary directory and runs one `nm -g -A` over the members:
`nm -A` on the *archive* would do as well but for its member field being spelled
differently by ELF and Mach-O `nm`. The file name `-A` prints is spelled two ways
too — `foo.o: <addr>` from Mach-O's `nm`, `foo.o:<addr>` from GNU binutils, which
glues the address onto the name — and that name is the key the members are
grouped by, so the check strips an address as well as a bare colon, and fails on
a first field it cannot reduce to a `.o` at all. That last part is not
belt-and-braces: a misread key is unique per symbol, which makes every group a
group of one and the check vacuous while it still prints its entry-point count.
`HISTORY.md` records the day it was.

CI's `static` job runs it, then `test/` and `test-consume/` — the two routes a
consumer can reach the archive by, one through `bin/mpifort`'s `-lmpifort_abi`
and one through `find_package(mpif)`'s imported target. One leg, on Linux,
because GNU ld is the linker that reports symbol size and alignment mismatches
at all; `dev/build-macos-all.sh static` covers Mach-O locally over all four
variants, and `docker/mpich-gcc-static-arm64v8.dockerfile` covers aarch64 — the
cells' size and alignment are chosen against the Fortran COMMON blocks merged
onto them, and both quantities differ by target. A static build was measured to
produce no such warning, in a Debian container with GNU ld — the same harness
that found 1516 of them from a uniform cell size.

A static build is 78 tests, the same as a shared one; what used to make it 76 is
in "Separable wrappers" above.

## Sanitizer builds

`-DMPIF_SANITIZE=address` builds mpif with AddressSanitizer; off by default:

    MPIF_SANITIZE=address bash scripts/macos-build-mpif.sh mpich llvm
    MPIF_SANITIZE=address bash scripts/macos-test-mpif.sh  mpich llvm

- Installs to `build/mpif/mpich-llvm-sanitize-address`, beside the ordinary
  build, so a suspected memory error can be run both ways without a rebuild.
  The MPI underneath is the ordinary uninstrumented one — deliberately: mpif's
  job is to be correct across the ABI boundary into a library it did not
  build, and instrumenting the process while leaving the library alone is
  what that boundary looks like from the inside.
- **What it is for:** mpif's C is a conversion layer — it allocates, copies
  strings both directions, and walks handle arrays whose length it works out
  itself. Those are places a test can only ask whether the answer came out
  right, not whether getting it involved an out-of-bounds write.
- **Reach:** a defect in mpif's C reports with the full mixed stack (C frame,
  generated conversion, f08 wrapper, Fortran caller). It is not silent about
  libmpi either, but only where a call goes through an intercepted libc
  routine; an implementation's hand-rolled copy loops are invisible — that is
  the limit `CLAUDE.md`'s guard-page advice is about.
- **Two link shapes, because flang has no `-fsanitize`** (none as of
  LLVM 22). Under gfortran the Fortran is instrumented too and the driver
  brings in the runtime. Under flang only the C is instrumented, and since a
  Fortran source makes flang the link driver, CMakeLists.txt asks the C
  compiler `-print-file-name=libclang_rt.asan…` and appends the answer plus
  an rpath (the runtime name is `asan` for `address`, `ubsan_standalone` for
  `undefined`; the file name differs by platform).
- **On ELF the executable must link the runtime, and lead with it** — ASan
  refuses to start when its runtime is not first in the initial library list,
  and `verify_asan_link_order=0` would buy a build that runs and tracks
  nothing. The wrapper therefore names the runtime **first** in
  `MPIF_FCLIBS` (among the libraries, not the flags: `find_package(MPI)`
  copies wrapper flags into compile options but keeps only `-Wl,` forms from
  the link line, so a flag would reach the compile and vanish from the link).
  `-Wl,--no-as-needed` leads and is never restored: the executable references
  no sanitizer symbol of its own, so GNU ld's `--as-needed` would drop the
  runtime, and FindMPI reorders any closing flag next to its opener.
  `mpif_info`, the one executable the wrapper does not link, lists the
  runtime ahead of `mpifort_abi` by hand. Darwin has no such rule.
- **Nothing fails silently.** A toolchain that cannot do it fails at
  configure time: the probes compile *and link*, and the ones without a
  runtime fail at the link (GCC on macOS — neither MacPorts' nor Homebrew's
  ships libsanitizer). And a build whose flags never arrived passes all
  tests just like a correct one, so `ci-scripts/check-sanitizer-build.sh`
  reads the installed library and requires undefined `__asan_*` references;
  `scripts/macos-build-mpif.sh` runs it after every sanitizer install and CI
  runs it before the tests.
- In CI this is the `sanitize / <toolchain>` job, `ubuntu-24.04`/`mpich`
  only, both toolchains — the two toolchains are the two link shapes, a real
  difference, while the implementations and OSes are not: mpif's C is the
  same object code whichever MPI is loaded next to it. It takes its MPI from
  the `mpi` job's uploaded prefix, and needs nothing else, so it waits on
  stage one alone.
- The MPICH suite is not run under a sanitizer: the expected-failure baseline
  is keyed per variant, and a sanitizer variant would need its own triage
  before it could gate anything.

## The cdesc layer

The `MPIF_HAVE_CFI` branch of `mpi_f08`, where choice buffers are
`TYPE(*), DIMENSION(..)`: an `MPI_Send_f08ts` wrapper forwards its
assumed-rank dummy to a `bind(C)` interface (module `mpif_f08_cdesc`, in
`gen/mpif_f08_functions.F90`) whose C side, in `gen/mpif_f08_cdesc.c`,
receives each buffer as a `CFI_cdesc_t*`. The probe that turns the branch
on, the compiler support that motivates it and the decisions it carries are
under "Assumed-rank choice buffers" in `MISSING.md`; this is how a
descriptor becomes a call.

Each buffer's crossing is classified in `dev/mpiapi.jl` (`cfi_classify`,
held to a frozen per-class tally so a new `apis.json` reclassifies loudly):

- **walk** — the buffer owns the scalar (count, datatype) pair that follows
  it: point-to-point, RMA, file I/O, `MPI_Bcast`, the fixed sides of the
  collectives. A sentinel, a scalar (rank 0) or a contiguous descriptor
  passes its base address with count and datatype untouched; anything else
  goes to `mpif_cdesc_create_datatype` (`src/mpif_cdesc.c`), which wraps the
  datatype in one contiguous-or-hvector level per descriptor dimension —
  MPICH's `cdesc_create_datatype` shape, reworked: everything is `MPI_Count`
  and the `PMPI_*_c` constructors; a descriptor element longer than the
  datatype (a `character(len=8)` buffer under `MPI_CHARACTER`) folds the
  factor into a contiguous base type where MPICH only asserts under error
  checking; a level is contiguous only while every level below it is *dense*,
  because `MPI_Type_contiguous` replicates at multiples of the inner type's
  extent and an hvector's extent — `sm*(n-1) + e` — falls short of the span
  `sm*n` it covers, so contiguous above a strided dimension misplaces every
  replica but the first (MPICH compares against the span and gets this wrong;
  `MISSING.md` "MPICH: `cdesc_create_datatype` places a contiguous level by
  extent"); only the outermost type is committed. The call gets count 1 and
  the walked type, freed right after — legal even for a nonblocking call,
  the request holding its own reference. A root-only buffer walks under
  `q_at_root`, so a non-root rank never walks against `MPI_DATATYPE_NULL`.
- **contig** — the reduction family (the §6.9.1 predefined-operator rule),
  the v/w collectives and `MPI_Reduce_scatter` (counts are arrays), the
  raw-byte pack buffers, and the partitioned inits (a walked type cannot
  preserve the partitioning): sentinel or contiguous passes through,
  anything else is `MPI_ERR_BUFFER` — returned through `ierror` without
  invoking the error handler, which is what MPICH's layer does with its own
  walk errors, and loud where MPICH instead corrupts or aborts (its
  `MPIR_Reduce_cdesc` walks a datatype `MPI_SUM` is not defined on).
- **addr** — attach/detach, `MPI_Win_create`, `MPI_Free_mem`,
  `MPI_Get_address`, `MPI_F_sync_reg`, the read/write `_end` halves and the
  single-element RMA routines: the base address, whatever the layout.

The entry points reuse the ordinary wrappers' conversion machinery
verbatim — handle-array VLAs, `q_at_root`, string duplication — with the
buffer names rewritten to the hoisted base addresses (`q_sendbuf`), because
in these entries the buffer's own name is a descriptor pointer; the vw
collectives' `sendbuf != MPI_IN_PLACE` guard is the reference that made
that necessary. Statuses cross as `MPI_Status*` directly, and an in-string's
hidden length becomes an explicit `integer(c_size_t), value` argument,
`bind(C)` passing no hidden ones. Sentinels are translated in exactly one
place per buffer, the hoist that takes the base address:
`void* const q_sendbuf = mpif_c_buffer(sendbuf->base_addr);`. Everything
downstream reads `q_<name>`, so `mpif_cdesc_is_sentinel` still compares against
the three *C* constants and is exactly right — no call site of it changed when
translation arrived, which is what made a change touching 828 hoists a
one-line-per-buffer change. It remains three pointer compares, and remains
belt-and-braces for the *walk*, a one-element sentinel actual being contiguous
anyway.

What the tests pin, and what they cannot: `test/subarray_nonblocking_f08.f90`
(compiled `-O2`, like every test whose assertion is about the caller's
optimiser) fails if the walker ignores strides;
`test/subarray_strided_cfi_f08.f90` fails if a level above a strided one is
placed by the inner extent rather than by the stride — the shape the
nonblocking test cannot see, both of its sections putting the strided level
last; `test/scalar_char_cfi_f08.f90` fails if the element-length factor breaks;
`test/subarrays_constants_f08.F90` re-derives the expected
`MPI_SUBARRAYS_SUPPORTED` from the same probe at test-configure time, so a
build whose constants disagree with its buffers fails whichever way the
disagreement goes. Dropping ASYNCHRONOUS from the generated declarations
fails *no* runtime test here — measured, all 75 pass without it — so the
guard for that class is static: `dev/check-f08-bindings.jl` compares the
attribute against A.4 on the TS branch, all 216 buffers and the 59
asynchronous metadata arguments, and reported 762 divergences when it was
put back.

## Verified as correct

How the parts that look surprising actually work, recorded so that they do
not get re-investigated. Several were defects once; `HISTORY.md` has how they
were found and verified.

- **The mpi_f08 specific procedure names.** The specifics behind the generics
  follow Table 19.1, and which scheme depends on the buffers: a routine with
  a choice buffer is scheme 1B under `MPIF_HAVE_CFI` — `MPI_Send_f08ts`,
  `MPI_Send_c_f08ts` (§19.1.4 puts `_c` before the token, cf.
  `PMPI_Reduce_scatter_block_init_c_f08ts`) — and scheme 1A on the fallback
  branch and for every bufferless routine, `MPI_Send_f08` / `MPI_Send_c_f08`;
  PMPI twins likewise. They are *external* procedures
  (`gen/mpif_f08_wrappers.F90`), declared as interface bodies in
  `mpif_f08_functions`: §19.1.5 wants a profiling routine to "interpose
  itself as the MPI library routine", and a module procedure's symbol is the
  compiler's to mangle. `test/profile_f08.f90` interposes
  `MPI_Comm_rank_f08` and reaches the real one through `PMPI_Comm_rank`; the
  suite's `f08/profile1f90` interposes `mpi_send_f08ts` and passes wherever
  the TS branch is on.
  Consequences:
  - **No plain `_c` specifics in `mpi_f08`** except `MPI_Op_create_c` and
    `MPI_Register_datarep_c` — §19.1.4 makes invoking any other erroneous,
    and only those two need explicit large-count names (the callback
    prototype alone distinguishes them). This matches MPICH.
  - The `#ifdef` guards on conditionally-emitted `_c` specifics cover the
    interface, the public line and the body, and nest with the
    `MPIF_HAVE_CFI` branch where a buffer routine has one
    (`MPI_Win_create_c`).
  - On the fallback branch, `!dir$ ignore_tkr` / `!gcc$ attributes
    no_arg_check` / `!dec$ attributes no_arg_check` sit on the interface
    bodies, not the definitions — flang requires it, and the directives relax
    what a *caller* sees anyway. The three spellings cover flang/Cray/NVIDIA,
    gfortran, and ifort/ifx respectively, each a comment to the others.
  - The declaration written twice is the cost; `dev/check-f08-bindings.jl`
    compares the two sets, argument names and order included, once per
    preprocessor branch.
- **The PMPI profiling interface.** Every MPI procedure has a `PMPI_` form in
  all three interfaces, each calling C's `PMPI_` entry point (MPI-5.0 §15.2.1
  and §19.1.5). The generated half is one more turn of the loop in
  `dev/mpiapi.jl`, beside `for embiggen`, so the two copies cannot drift; the
  hand-written half is the removed MPI-1 routines, the `_cptr` overloads,
  `MPI_Sizeof` and the status converters. Not to re-decide:
  - **A probe always calls `PMPI_`, in the `MPI_` copy of a wrapper as much as
    the `PMPI_` one.** The group size/rank/dimension probes are mpif working out
    how long an array is — calls the program did not make — so a tool counting
    `MPI_Comm_rank` must not be shown them. `MPI_BARRIER` and the neighbourhood
    collectives were reporting mpif's bookkeeping to a profiler as though the
    program had called it. This subsumes the older rule that a P form never
    re-enters `MPI_`, which is the same requirement for one of the two copies,
    and it is why `State` no longer carries a prefix. `src/mpif_cdesc.c` says
    the same for the datatypes it builds. The handle conversions are left alone
    (`MPI_Comm_fromint` is nothing a profiler can usefully replace).

    The invariant to check is that in each wrapper body the only unprefixed
    `MPI_` call is the routine that body implements:

        python3 -c '
        import re
        for p in ("gen/mpif_functions.c",):
            s=open(p).read()
            for sym,b in re.findall(r"// MPIF-SPLIT-BEGIN (\S+)\n(.*?)\n// MPIF-SPLIT-END",s,re.S):
                for c in set(re.findall(r"\b(P?MPI_[A-Za-z0-9_]+)\s*\(",b)):
                    if c.startswith("PMPI_") or re.match(r"MPI_[A-Za-z]+_(fromint|toint)$",c): continue
                    if c.lower() in (sym.rstrip("_").lower(), sym.rstrip("_").lower()+"_c"): continue
                    if c=="MPI_Fint": continue
                    print(sym,c)'

    It found `MPI_Cart_sub`'s probe, which threaded the prefix by a second
    spelling and so survived the first pass at this.
  - **The `MPI_` form calls C's `MPI_`, and that is what makes a C-only
    profiler sufficient.** §15.2.1(3) requires an implementation to "document
    the implementation of different language bindings of the MPI interface if
    they are layered on top of each other, so that the profiler developer knows
    whether to implement the profile interface for each binding, or to economize
    by implementing it only for the lowest level routines". mpif is layered, and
    this is that documentation: `mpi_send_` calls C's `MPI_Send`, so a profiler
    that replaces the C entry point alone already sees every call a Fortran
    program makes, and need not implement any of the Fortran specific names.
    Having the wrappers call `PMPI_` instead would invert that — a C profiler
    would go blind to Fortran programs, and a tool would have to interpose on
    every specific name §19.1.5 defines, several per routine. The `PMPI_`
    Fortran forms are the bypass for whoever wants the other behaviour, which is
    why both exist. `test/profile_f08` and the suite's `f77/profile`,
    `f90/profile` and `f08/profile` directories are what hold this up.
  - **`PMPI_Sizeof` exists here and in neither implementation.** The standard
    makes no exception for it.
  - **No PMPI form of a predefined callback** (`PMPI_COMM_DUP_FN` etc.), and
    none wanted: A.1.1 lists all twelve among the *defined constants*, ABI
    values 0 and 1 — in the ABI they are constants, not entry points, and
    `src/mpif_callbacks.c` turns them into sentinels rather than calling
    them. A tools layer forwards the callback as a `PROCEDURE(...)` dummy and
    `mpif_predefined_callback` matches on address, not entry point. A program
    written wholly in PMPI names writes
    `PMPI_Comm_create_keyval(MPI_COMM_DUP_FN, ...)`, which is what either
    implementation requires too.
  - **The registries are shared**: one keyval registry, one errhandler pool,
    one grequest pool for both copies, so creating through `MPI_` and freeing
    through `PMPI_` works.
  - Coverage is checkable in one line: differencing the built library's
    `mpi_*_` and `pmpi_*_` symbol sets leaves exactly the predefined
    callbacks without twins.
  - Tests: `test/pmpi_f.f`, `test/pmpi_f90.f90`, `test/pmpi_f08.f90` call the
    P forms from each interface; `test/profile_f90.f90` replaces
    `MPI_Comm_rank` and `MPI_Barrier` and asserts its counters in both
    directions (interception happened; PMPI did not come back through the
    interceptor). Both profiling tests run against an archive too — see
    "Separable wrappers" under "Static linking".
- **Nothing is silently dropped.** Replaying the generator's filters over
  `apis.json` gives 430 kept functions, 589 including `_c` variants, and
  `gen/mpif_f08_functions.F90` contains exactly those. The 102 skipped as
  `not f90_expressible` are the C-only handle converters and the whole
  `MPI_T` interface, which the standard defines for C only.
- **Sentinels are translated, and every crossing is checked.** The ten —
  `MPI_BOTTOM`, `MPI_IN_PLACE`, `MPI_BUFFER_AUTOMATIC`, `MPI_ARGV_NULL`,
  `MPI_ARGVS_NULL`, `MPI_ERRCODES_IGNORE`, `MPI_STATUS_IGNORE`,
  `MPI_STATUSES_IGNORE`, `MPI_UNWEIGHTED`, `MPI_WEIGHTS_EMPTY` — are ordinary
  COMMON blocks, one per sentinel, whose storage `src/mpif_constants.c` defines
  and whose *addresses* identify them. `include/mpif_sentinels.h` declares the
  twelve cells (the ten, plus `mpi_f08`'s own pair of `TYPE(MPI_Status)`
  sentinels) and holds the translators. This is what MPI-5.0 §2.5.4's advice to
  implementors describes: "predefined static variables (e.g., a variable in an
  MPI-declared COMMON block)" whose address is "extracted by some mechanism
  outside the Fortran standard (e.g., ... by implementing the function in C)".
  The ABI values are not addresses of anything — `(void*)0`, `(void*)1`,
  `(void*)2`, `(int*)10`, `(int*)11` and five nulls — so no Fortran entity can
  sit at one and translation is the only route.
  Consequences, none of them optional:
  - **Every argument that can carry a sentinel is wrapped**, and
    `dev/mpiapi.jl` asserts it per parameter over `sentinel_kinds`, with
    `sentinel_expected_sites` freezing the tally the way
    `cfi_expected_class_counts` freezes the CFI classes. This replaces an
    invariant that used to hold for free: while the Fortran sentinels sat *at*
    the C constants' addresses, forwarding one was translating it.
  - **Each cell is exactly the size of the COMMON block merged onto it** —
    three sizes, not one that fits all. GNU ld warns "size of symbol changed"
    once per sentinel in every consumer's link when the two differ, which a
    uniform size produced 1516 times in a compile-only run; macOS's linker is
    silent about it, so this is only visible in a Linux build.
    `mpif_check_environment` requires equality rather than a fit.
  - **The cells are `const`, and poisoned.** A missed translation that writes —
    a status, spawn's `array_of_errcodes`, `MPI_Dist_graph_neighbors`' weights —
    faults in read-only memory instead of corrupting the cell; that is
    measured, not hoped for, and was what the eight status tests did when the
    translation was absent. A missed *read* gets the poison instead, which is
    `0xBAADC0DE` for the buffer cells and a large positive `0x0EADC0DE` for the
    four status cells, chosen so an absurd count kills the caller rather than
    passing for a plausible negative one.
  - **`mpif_check_environment` checks the arrangement itself** — that each
    Fortran sentinel's address is its cell, and that each fits — because
    nothing at compile time can see both halves. It is also the only test that
    §3.6's "the implementation of MPI_BUFFER_AUTOMATIC must allow the intrinsic
    `c_loc` to be applied to it" holds.
  - **The four status cells are all recognised by one translator.** `mpi_f08`'s
    two are separate objects — `TYPE(MPI_Status)`, not INTEGER arrays — and
    reach the same C entry points through `mpif_f08_raw`. §3.2.6 permits the
    values to differ from C's, and having four distinct addresses is an
    improvement: a C layer can tell an `mpi_f08` sentinel from an `mpif.h` one,
    which it could not while all four were null.
  - **One crossing runs C to Fortran**: `MPI_Buffer_detach` and its two
    siblings must return `c_loc(MPI_BUFFER_AUTOMATIC)` (§3.6), so the ABI value
    MPI wrote is mapped back after the call — in C, so that all three
    interfaces agree, though the standard requires it only of `mpi_f08`.
  - Tests: `test/bottom.f90`, `test/statuses_ignore.f90`,
    `test/dist_graph_weights.f90` and `test/buffer_detach.f90` cover the
    families and interfaces; `test/sentinel_addresses_c.c` pins the cells'
    distinctness, size and alignment; `ci-scripts/check-headers.sh` checks
    every COMMON block against its C definition without a build.
- `MPI_Wtime`, `MPI_Wtick`, `MPI_Aint_add` and `MPI_Aint_diff` are
  hand-written rather than generated. `MPI_Sizeof` is a hand-written generic
  in `src/mpif_types.F90`. `MPI_Status_f2f08`/`MPI_Status_f082f` live in
  `src/mpif_handle_types.F90`, public from both `mpi` and `mpi_f08` (A.5.13).
- **`mpif_f08_raw` exists so two kinds of argument reach C without a Fortran
  temporary.** It is a second set of interfaces to the same C entry points,
  differing only in how they spell an argument; `dev/mpiapi.jl` decides per
  argument from the declaration, not from a list.
  - A **status** is `TYPE(MPI_Status)` there where the `mpi` module says
    `INTEGER(MPI_STATUS_SIZE)` — eight default integers either way (the ABI
    fixes `MPI_Status` as three named ints plus five; mpif fixes
    `MPI_STATUS_SIZE` at 8 with the indices at 1, 2, 3), so the caller's own
    status goes straight to C.
  - An **assumed-size array of handles** is `TYPE(MPI_Datatype)` there — the
    `alltoallw` family only, the sole routines whose Fortran binding takes
    one. `%MPI_VAL` on an assumed-size dummy has no extent the compiler
    knows, and gfortran repacked it into a zero-length temporary.
  - **Explicit-shape handle arrays keep `%MPI_VAL`** (`MPI_Waitall` and the
    thirteen others): the compiler knows the count and copies correctly. The
    rule is about what the compiler can size, not about handles.
- **The `alltoallw` family works out its own array lengths, and none of the
  three answers is `MPI_Comm_size`.** Per the standard: the *remote* group's
  size for an intercommunicator (§6.8 with §7.6), the outdegree/indegree for
  the neighbour forms (§8.6, dispatched on `MPI_Topo_test`; matches MPICH's
  `mpi_abi_util.h`, `2 * ival` in the `MPI_CART` case), the local size only
  for an intracommunicator. `sendtypes` is not read at all under
  `MPI_IN_PLACE` (§6.8: "is ignored") and is filled with `MPI_DATATYPE_NULL`
  instead. A communicator with no topology leaves both degrees zero and the
  implementation reports `MPI_ERR_TOPOLOGY` itself. `test/` covers all four
  cases with `add_mpi_test`'s `NPROCS`, which exists for them: at one rank a
  group size, a remote group size and a neighbour count all coincide, so
  every wrong length is the right one.
- **Root-only arguments are converted at the root, and the root is not
  rank 0.** `apis.json` marks 19 routines' parameters `root_only` (MPI-5.0
  §6.1: "significant only at root"); converting a meaningless handle or
  string on a non-root is a wild read, so conversion is guarded by
  `q_at_root`. On an intracommunicator that is `q_comm_rank == *root`; on an
  intercommunicator it is `*root == MPI_ROOT` (§6.2.3 — a rank in `comm`
  does not identify the root there; `MPI_ROOT`'s ABI value is -4, colliding
  with no valid rank). The dispatch is `MPI_Comm_test_inter` through
  `state.prefix` so PMPI copies probe with `PMPI_Comm_test_inter`.
  `ensure_at_root!` asserts the argument is named `root` rather than
  hardcoding. Only converted arguments need the guard; `root_only` choice
  buffers and integers pass through untouched. Tests:
  `test/gather_root_f08.f90` (root 1, two ranks) and
  `test/gather_inter_f08.f90` (three ranks, root second in its group) — both
  chosen so the wrong guard cannot pass by accident.
  In `MPI_Comm_spawn_multiple`, `count` is `root_only` too:
  `root_only_count!` emits `const int q_count = q_at_root ? (int)*count : 0;`,
  every VLA is floored, every loop runs to `q_count`, and the handle/info
  arrays are pre-filled over their whole extent. `*count` itself reaches MPI
  unchanged.
- **`MPI_Sizeof` stays as it is, covering rank zero and rank one — in
  `mpif.h` too.** A Fortran generic needs a specific per type, kind *and*
  rank; covering every rank means sixteen specifics apiece. Assumed-rank
  would collapse them, but it lives behind `MPIF_HAVE_CFI` and `MPI_Sizeof`
  belongs to `mpif.h` and the `mpi` module, which stay on the directive form
  everywhere — branching a deprecated routine's generic across the axis is
  more mechanism than the routine is worth. MPICH stops in the same place,
  and `MPI_Sizeof` is deprecated with its `mpi_f08` form removed. Details
  that are decisions, not oversights:
  - `mpif.h`'s generics have scalar *and* array specifics per type (the
    scalar external names are suffixed `_s`; `src/mpif_sizeof.c` emits four
    names per type). `test/sizeof_f.f` covers both.
  - `mpif.h` omits the optional kinds (`logical16`, `real2`, ...) that the
    `mpi` module guards with `#ifdef MPIF_HAVE_*`: `mpif.h` is read by
    Fortran `include`, never preprocessed, and must stay includable by
    unpreprocessed fixed-form code.
  - Both have `CHARACTER` specifics; the hidden trailing length argument the
    caller appends is harmless on the C calling conventions mpif supports —
    the same fact the generated string wrappers rely on.
  - Should assumed-rank ever be taken, revisit this with it.
- **A user-defined reduction operator receives its buffers, from all three
  interfaces.** `MPI_User_function`'s `invec`/`inoutvec` are
  `TYPE(C_PTR), VALUE` in `mpi_f08` (MPI-5.0 §6.9.5), in both the small and
  large-count abstract interface; the trampoline in `src/mpif_callbacks.c`
  passes the buffer address, as `mpif.h`'s `<type> INVEC(LEN)` needs.
  `test/op_create.f90` writes the callback as a module procedure, the way the
  standard's example does — the only shape that meets the abstract interface
  at compile time — and then does the reduction.
- `ierror` is `OPTIONAL` throughout the f08 bindings.
- **Predefined handles need no help from mpif.** The wrappers call
  `MPI_Comm_toint` and the rest directly; both implementations short-circuit
  predefined handles in their converters (MPICH: any handle in
  `0x20..0x2eb`; Open MPI:
  `ompi_abi_handle_int_is_predefined` in all 22 converters). Former shims
  claiming "broken MPI implementations [only MPICH]" were removed after a C
  probe round-tripped all 103 predefined handles with zero failures. If a
  version ever reappears where `MPI_Type_fromint(MPI_INTEGER)` yields an
  invalid datatype, this is the entry to reread.
- **No phantom `_c` bindings.** The generated f08 output has exactly the
  `_c` forms Appendix A.4 has; `MPI_Psend_init` and `MPI_Precv_init`
  correctly have none, and `dev/mpiapi.jl` asserts they never gain one (the
  ABI stubs header invents them — see `MISSING.md`).
- **`MPI_Count` is `int64_t` where `MPI_Aint` is a pointer.** The ABI header:
  `MPI_ABI_Aint` is `intptr_t`, `MPI_ABI_Offset`/`MPI_ABI_Count` are
  `int64_t`. So `MPI_OFFSET_KIND` and `MPI_COUNT_KIND` are
  `selected_int_kind(18)` and only `MPI_ADDRESS_KIND` follows the pointer.
  Eight routines' large-count generics are legal on only one width — the
  four window routines whose only widening is `disp_unit`
  (INTEGER→`MPI_Aint`, 64-bit only) and the four extent routines
  (`MPI_Aint`→`MPI_Count`, 32-bit only) — and are emitted under `#ifdef`
  guards on `MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND` /
  `MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND`; CMake defines each by
  compiling the ambiguity itself, so the probe is the very rule the compiler
  applies to the generated code. `test/large_count_f08.f90` and
  `test/rma_disp_f08.f90` assert each guard at compile time on both widths.
- **A function parameter embiggens when `apis.json` says `POLYFUNCTION`.**
  Visible only in `MPI_Register_datarep`, whose two conversion functions are
  `POLYFUNCTION` and whose extent function is `FUNCTION` (matching A.4). The
  generator cross-checks the kind against the prototype's own parameters — a
  callback has a `_c` form exactly when one of its arguments embiggens — and
  stops if the JSON disagrees with itself.
- **The f08 declarations match the appendices**, compared by
  `dev/check-f08-bindings.jl` (see `CLAUDE.md` "Checking a claim"). Facts it
  pinned that are worth not re-deriving:
  - `MPI_Cancel`'s request is `INTENT(IN)` (A.4.1); the wrapper copies into a
    temporary for the C `MPI_Request*`. `test/cancel_intent_f08.f90`.
  - The 18 f08 callback abstract interfaces carry **no intents** — the
    standard's own ABSTRACT INTERFACEs (§7.7.2, A.1.3) give none, and INTENT
    is part of a dummy's characteristics, so a callback written the
    standard's way would otherwise not compile.
    `test/callback_intents_f08.f90` writes one callback per interface the way
    the standard writes it.
  - `MPI_Abi_get/set_fortran_booleans` take a plain `LOGICAL`, not a choice
    buffer (A.4.14/A.5.14). No test — `no_arg_check` disables the checking
    that would tell the declarations apart, so a test would pass either way.
  - `buffer_addr` of the three detach routines is `TYPE(C_PTR), INTENT(OUT)`
    in `mpi_f08` (A.4) and a choice buffer in the `mpi` module (A.5); one C
    entry point takes `void*` and serves both. `test/buffer_detach.f90`.
    In `dev/mpiapi.jl` the four `C_BUFFER*` kinds are one question — address
    or buffer — answered at `aint_kinds`.
  - The 207 remaining differences are all the same one and expected: an
    input choice buffer is `INTENT(IN)` in the standard and has no intent
    here — see "Assumed-rank choice buffers" in `MISSING.md`.
  - `mpi_f08` has six routines A.4 does not list: the five deprecated MPI-1
    attribute routines, and `MPI_F_sync_reg`, which is not in the standard
    at all. And A.4 gives `MPI_TYPE_NULL_DELETE_FN`'s `ierror` `INTENT(OUT)`
    where its own abstract interface gives none — an inconsistency in the
    standard; mpif follows the abstract interface.
- **`MPI_Copy_function` and `MPI_Delete_function` give `extra_state` default
  `INTEGER`, not `INTEGER(MPI_ADDRESS_KIND)`.** Chapter 16's own binding
  declares every argument `INTEGER` — unlike `MPI_Comm_copy_attr_function`,
  where `extra_state` genuinely is address-sized. The C trampolines
  (`fortran_copy_fn_10`/`fortran_delete_fn_10`) pass a 4-byte `MPI_Fint`.
  `test/keyval_create_f08.f90` writes the callbacks exactly as Chapter 16
  does (the compile half) and runs a real keyval over `MPI_COMM_WORLD` (the
  runtime half). `dev/check-f08-bindings.jl` does not cover these two —
  A.1.3 omits the deprecated interfaces, and its prose defeats the parser —
  so the test is the check.
- **Every generator-emitted VLA is floored at length 1**
  (`vla_size(count) = "$count > 0 ? $count : 1"`, applied unconditionally at
  every declaration site so there is no judgement call to get wrong): a
  zero-length VLA is not C, and `count = 0` is legal in `MPI_Waitall`,
  `MPI_Type_create_struct`, zero-dimensional Cartesian routines and others.
  Loops still run to the true count. The same floor is in
  `src/mpif_removed.c`'s macros.
- **Out-temporaries are initialised**, every kind of them, because every
  conversion back to Fortran runs whatever the call returned:
  - **out-LOGICAL scalars** start from `MPI_Fint c_$parname = 0;`, and
    **out-handle temporaries** from `MPI_$( kind )_NULL`, so a failing call
    never converts an unwritten temporary (for a handle, `MPI_*_toint` is
    entitled to look garbage up in a table and abort).
  - **out-string temporaries** get `c_$parname[0] = '\0';` as well as the
    trailing NUL below, so the `strlen` that sizes the copy-back does not read
    an unwritten array. At every declaration site, including the three whose
    copy-back is guarded: `MPI_SESSION_GET_NTH_PSET`'s guard tests the length
    the caller passed in, not whether the call succeeded.
  - **`MPI_Cart_get`'s `periods`**, the only out-LOGICAL *array* in
    `data/apis.json`, is pre-filled with `false` over `*maxdims` — and is the
    one place where the conversion back is *bounded* rather than walking the
    whole extent. MPI writes only as many entries as the topology has
    dimensions, and MPI-5.0 §8.5 requires the rest be left alone: "If comm is
    associated with a zero-dimensional Cartesian topology, MPI_CARTDIM_GET
    returns ndims = 0 and MPI_CART_GET will keep all output arguments
    unchanged." Only the topology knows that count, so the wrapper reads it
    with `PMPI_Cartdim_get` — PMPI_ so a profiler does not see a call the
    program never made, as in `src/mpif_cdesc.c` — clamps it to `*maxdims`,
    and converts nothing at all when either call failed. `dims` and `coords`
    are INTEGER and reach MPI directly, so their surplus is untouched by
    construction; `periods` is the only one needing the arrangement.
    `test/cart_get_f90.f90` checks both the two- and zero-dimensional cases.
  - **`MPI_Type_get_contents`' pure-out `array_of_datatypes`** is pre-filled
    with `MPI_DATATYPE_NULL` — the same defect this project patched one level
    down in MPICH (see `MISSING.md`), so mpif's copy no longer depends on that
    patch.
  - **`src/mpif_removed.c`'s `MPI_Aint` locals** are `= 0`, the hand-written
    half of the same rule. `MPIF_NEWTYPE_ON_SUCCESS` there reaches the same end
    the other way, guarding its conversion on `*ierror == MPI_SUCCESS`, because
    a handle is the one case where the conversion itself may object.

  Two of those are about the surplus of an array the caller oversized, where
  MPI writes only what the object has and the rest is unwritten *on success*
  too, so the pre-fill is not only about the failure path. They resolve it
  differently, and the difference is the standard's: §8.5 says in as many words
  that `MPI_CART_GET` leaves what it did not write, so `periods` is bounded and
  the caller's surplus survives; nothing says that of
  `MPI_Type_get_contents`' `array_of_datatypes`, so there the whole extent is
  converted and the surplus comes back `MPI_DATATYPE_NULL`. Bounding costs an
  extra MPI call and only the Cartesian routines publish a count to bound by.

  A conforming program can observe the surplus, so `test/cart_get_f90.f90`
  covers it. The failure-path half no test can reach, a caller not being
  allowed to inspect an out argument after a failing call, and with the
  trailing NUL in place not even AddressSanitizer sees the string case;
  `git diff gen/` after regeneration is the verification there.
- **The f08 twins of `MPI_CONVERSION_FN_NULL`/`_C` set
  `ierror = MPI_ERR_INTERN`**, agreeing with their `mpif.h`/`mpi` twins:
  these are pure sentinels MPI never calls (the wrappers substitute the ABI
  sentinel value), and a plausible-looking no-op would hide the day one
  somehow does arrive.
- **`mpif_strdup_f2c`/`_trim` and the generated `argv` row allocation abort
  on OOM** with a diagnostic, rather than returning NULL: every caller is
  generated code with no cleanup path for a mid-conversion failure, so the
  abort in the one place that knows what was being allocated is the more
  honest failure.
- **The datarep box differs from the grequest box in exactly one way: it is
  never freed.** In both, `extra_state` is copied into the box by value
  (MPI-5.0's `INTENT(IN)` and the C prototypes taking `void*` by value).
- **`MPI_Comm_spawn_multiple` frees the per-command `char*` vector**
  (`free(argv_$parname[i])` after the inner loop; the row is NULL where the
  conversion did not run, and `free(NULL)` is defined).
- **Two routines make the caller declare how much room its string has, and
  neither may be passed through.** `MPI_INFO_GET_STRING`'s `buflen` (MPI-5.0
  §10.1.2) and `MPI_SESSION_GET_NTH_PSET`'s `pset_len` (§11.3.2) have the same
  semantics word for word, and `string_length_handshake` in `dev/mpiapi.jl` is
  the list of them — the `MPI_T_` routines share the shape and are not
  `f90_expressible`. Three corrections, none of which the generic integer and
  string paths make:
  - **+1 in, −1 out.** "In C, <len> includes the required space for the null
    terminator"; Fortran counts characters.
  - **Clamp to the caller's CHARACTER length.** Fortran may name a length
    larger than the string it passes with it — MPICH's own suite does, in
    `f90/info/infogetstrf90.f90` — and MPI would write past our buffer.
  - **No copy-back when the length passed in was zero**, that being the
    standard's way of asking for the length alone: the buffer is untouched, so
    copying it out would hand back uninitialised memory and `strlen` would read
    it to decide how much.

  `MPI_Info_get_string` alone also has `flag`, and writes neither `value` nor
  `buflen` when the key does not exist; `pset_len` is written back
  unconditionally, as the standard states it. `test/info_get_string_f08.f90`
  and `test/session_get_nth_pset_f08.f90` are the pair, both with a `canary`
  declared right after the string. What the implementations do *not* do is in
  `MISSING.md`.
- **Every string-output wrapper's buffer is one byte longer than MPI is ever
  told, and that byte is NUL before the call.** The standard has MPI return a
  terminated string; Open MPI's `MPI_SESSION_GET_NTH_PSET` truncates with
  `strncpy` and does not, and the `strlen` that follows is mpif's own code
  reading past its own array. The byte costs nothing and removes the
  dependence.
- **`mpifort -showme:compile` reports gfortran's Fortran-only flag
  (`-fallow-argument-mismatch`), rightly** — relaxed argument matching is the
  whole idiom of the include-file interface. (It used to report
  `-fcray-pointer` beside it, for sentinels that were Cray pointees; that one
  is gone.) But `find_package(MPI)` puts what it finds into
  `MPI::MPI_Fortran`'s `INTERFACE_COMPILE_OPTIONS` unguarded, and CMake applies
  interface options to every language in a consuming target — so a mixed
  C/Fortran target hands it to the C compiler, which clang rejects.
  `test/CMakeLists.txt` rewrites the property as
  `$<$<COMPILE_LANGUAGE:Fortran>:...>` right after `find_package`, and any
  project mixing the two languages in one target wants the same three lines.
