# Missing features and known errors

What mpif gets wrong, does not do, or cannot do because something outside it is
broken -- plus the decisions not to do something, which stay, since an unrecorded
decision is indistinguishable from an oversight. Entries are removed once they are
resolved, so the rest of this file is only ever the outstanding list. Nothing in
the source tree refers to it.

How the code is built and why it is right is `CODE.md`; how to build, test and
verify it is `CLAUDE.md`. Findings here are checked against `data/apis.json`, the
generated output, the official ABI header and the MPI-5.0 standard, rather than by
reading the generator alone -- see "Checking a claim" in `CLAUDE.md`.

## Errors

None outstanding. Every entry that was here has been fixed, and the ones worth not
re-investigating are under "Verified as correct" in `CODE.md`. What remains here
is features mpif does not have, blockers outside it, and decisions.

## External blockers

### The ABI header gets the partitioned-communication count wrong, twice — carried as a local patch

`MPI_Psend_init` and `MPI_Precv_init` take an `MPI_Count` count. MPI-5.0's C
binding is

    int MPI_Psend_init(const void *buf, int partitions, MPI_Count count,
                       MPI_Datatype datatype, int dest, int tag, MPI_Comm comm,
                       MPI_Info info, MPI_Request *request)

and both implementations agree with it. MPICH declares and defines exactly that in
`src/binding/abi/c_binding_abi.c`. Open MPI generates it from a type class that
exists to say so:

    @Type.add_type('PARTITIONED_COUNT')
    class TypePartitionedCount(Type):
        def type_text(self, enable_count=False):
            return 'MPI_Count'

-- `MPI_Count` whatever `enable_count` is, where the `DISP` class immediately
below it returns `'MPI_Aint' if enable_count else 'int'`, which is what a type
that really does have two forms looks like.

The header mpif installs is alone in disagreeing. It comes from the MPI Forum's
ABI stubs, <https://github.com/mpi-forum/mpi-abi-stubs>, fetched by
`ci-scripts/install-mpi-header.sh`, and it declares the count `int` and then
declares `MPI_Psend_init_c` and `MPI_Precv_init_c` taking `MPI_Count`, along with
their `PMPI_` counterparts. **Neither name exists in MPI-5.0**: the string appears
nowhere in the standard, in any language, and neither implementation defines one,
because a routine whose only form already takes a count has nothing for a `_c`
form to add. That is also why Appendix A.4 lists one Fortran binding for each and
not two.

The two errors hid each other -- the base form looked small, and a large form was
offered that does not exist -- and between them they made the generated wrapper
unsafe rather than merely limited: it took the count from Fortran as an
`MPI_Count` and passed it to a prototype declaring `int`, so the call site
materialised 32 bits where the callee reads 64. Small counts survived because the
compiler extends the value into the register, which is the compiler being helpful
rather than anything guaranteed.

`fortran/mpi.h.patch` therefore corrects the four base prototypes and deletes the
four phantom declarations, alongside the Fortran handle-conversion declarations
the stubs omit that it already carried. **Drop those hunks once the stubs header
is fixed**; `patch` will report them as already applied. Not reported upstream
yet, and worth reporting.

Nothing in mpif may generate or call the phantom names. `dev/mpiapi.jl` asserts
that neither routine ever takes the `_c` path rather than leaving it to be noticed
that nothing does, since a header declaring the name makes it look as though
something should.

### OpenMPI: 32-bit environments are not supported

Its own release notes say so, in one line: "32-bit environments are no longer
supported", `docs/release-notes/platform.rst`. An older statement two files over
survives from before that decision and is worth not being misled by --
`docs/release-notes/compilers.rst` still says "32-bit platforms are only supported
with a recent compiler that supports C11 atomics", which reads as a supported
platform with a condition on it, where the note in `platform.rst` is the current
answer.

So the 32-bit variants are MPICH-only, and that is a scope limit rather than
something to work around: `docker/mpich-gcc-i386.dockerfile` and
`docker/mpich-gcc-arm32v7.dockerfile` have no Open MPI counterparts and should not
get one. Nothing on this side is implicated -- mpif's own 32-bit defects are fixed
and recorded under "`MPI_Count` is `int64_t` where `MPI_Aint` is a pointer" in
`CODE.md`.

### MPICH: partitioned communication is not implemented

`MPI_Psend_init` aborts inside MPI whatever the bindings do: `MPID_Psend_init` is
an `MPIR_Assert(0)` at `src/mpid/ch3/src/mpid_part.c:12`, so the ch3 device this
build uses implements none of partitioned communication. Nothing on this side can
be judged by running it, which is why `test/partitioned_f08.f90` asserts at
compile time and never executes its calls.

### MPICH: `MPI_Type_create_f90_*` is a no-op in an ABI build — carried as a local patch

`MPI_Type_create_f90_real`, `MPI_Type_create_f90_integer` and
`MPI_Type_create_f90_complex` all reported `MPI_SUCCESS` and handed back a handle
that `MPI_Type_toint` turned into 512 -- `0x200`, which is `MPI_DATATYPE_NULL`.
Anything done with it then failed: `MPI_Type_contiguous` and
`MPI_Type_get_envelope` both reported "Invalid datatype".

Pure C, no Fortran involved; the reproducer is
`bug-mpich-f90-datatypes/mpich-abi-f90-datatype-bug.c`, which round-trips each of
the three and, for contrast, a predefined type and a derived one -- both of which
survive.

**The diagnosis this entry used to carry was wrong, and wrong in a way worth
recording**: it said the handle conversion was at fault, that
`ABI_Datatype_from_mpi` reverse-searches `abi_datatype_builtins[]` and fails to
find a datatype that is predefined internally, and therefore that this and the
attribute blocker below were one defect in the ABI's datatype conversion. None of
that is what happens. The conversion is never reached with an interesting handle,
because the routine that should produce one does nothing.

`src/mpi/datatype/create_f90.c` carries two implementations of all three
routines: the real ones, and stubs that do
`*newtype = MPI_DATATYPE_NULL; return MPI_SUCCESS;`. The stubs are selected by
`#ifndef HAVE_FORTRAN_BINDING`, and an ABI build undefines that macro --
`src/binding/abi/mpi_abi_internal.h`, generated by `maint/gen_abi.py`, ends with

    typedef int MPI_Fint;
    typedef struct MPI_F08_status_dummy MPI_F08_status;
    #undef HAVE_FORTRAN_BINDING

which is right in itself, the standard ABI having no Fortran bindings, and which
every ABI object sees because `abi_cppflags` puts `src/binding/abi` on the include
path. So one build produces both: `create_f90.o` is 9496 bytes and has the
`f90Types` cache, while `lib_libpmpi_abi_la-create_f90.o` is 832 bytes and holds
three functions at 16-byte spacing. `nm -n` on the installed
`libpmpi_abi.dylib` showed the three impls 16 bytes apart, which is what put the
guard in the frame at all.

What the routines need is the Fortran data *model* -- `src/include/mpif90model.h`,
which configure generates from the Fortran compiler's own `precision()` and
`range()` -- and not the Fortran *bindings*. One macro stood for both.

`ci-scripts/mpich-abi-f90-datatypes.patch` therefore adds `MPIR_HAVE_F90_MODEL`,
true when MPICH has Fortran bindings or when this is the standard-ABI build, and
guards on that. `create_f90.c` is hand-written, so the patch survives the
`autogen.sh` that `install-mpich.sh` runs; `mpi_abi_internal.h`, the other
candidate, is generated. Unlike the other two patches this is not an upstream
backport but a local fix for a defect **not reported upstream yet**, which is
worth doing.

Five expected failures went green on it: `trf90`, `trf08`, `createf90`,
`createf08` and `createf90types`. The error path came back too --
`MPI_Type_create_f90_integer(100, &t)` now reports "No integer type with 100
digits of range is available" where it used to report success -- and the
reproducer goes from "BROKEN (6)" to "all ok (0 failures)".

`bug-mpich-f90-datatypes/mpich-abi-f90-datatype-check.c` is the second half of
that evidence, and worth having because the reproducer would be satisfied by a
stub that returned some *wrong* type: it checks the extents against MPICH's own
model map (8, 4 and 16), the combiner, the `(p, r)` the type was created with, the
empty `array_of_datatypes` the standard requires of an unnamed predefined
datatype, and that one handle comes back per request. That last is deliberately
stronger than MPI-5.0, which gives a matching rule rather than a same-handle
rule -- it is MPICH's `f90Types` cache, which the patch restores along with
everything else, so a regression in it should be visible.

Fixing it also made a second defect reachable, the entry below, which is where
`createf90types` went next.

### MPICH: `MPI_Type_get_contents` converts uninitialised memory — carried as a local patch

The ABI wrapper allocates a temporary for the datatypes, calls the
implementation, and then converts the caller's *maximum* rather than the number the
datatype actually has:

    MPI_Datatype *array_of_datatypes = NULL;
    if (max_datatypes > 0)
        array_of_datatypes = MPL_malloc(sizeof(MPI_Datatype) * max_datatypes, MPL_MEM_OTHER);
    int ret = internal_Type_get_contents(...);
    for (int i = 0; i < max_datatypes; i++)
        array_of_datatypes_abi[i] = ABI_Datatype_from_mpi(array_of_datatypes[i]);

`MPL_malloc` does not initialise, so every entry past what the implementation
filled is converted from whatever was on the heap. `ABI_Datatype_from_mpi`
reverse-searches `abi_datatype_builtins[]` for any handle
`MPIR_DATATYPE_IS_PREDEFINED` accepts and `MPIR_Assert(0)` when it finds none, so
garbage that looks builtin aborts -- "Assertion failed in file
src/binding/abi/mpi_abi_util.h at line 140" -- and garbage that does not gets a
pointer derived from it and is handed back without complaint. `ret` is not
consulted before the loop either, so this happens even when the implementation
failed and filled nothing.

The gap is not a caller error. MPI-5.0 requires "an empty array_of_datatypes" for a
datatype from `MPI_TYPE_CREATE_F90_*`, so a caller passing `max_datatypes = 1` and
getting `ndtypes == 0` has done nothing wrong -- and MPICH's own
`test/mpi/f90/f90types/createf90types.c` does exactly that,
`MPI_Type_get_contents(dtype, 2, 0, 1, ints, 0, &outtype)`. That is what started
aborting once the entry above stopped handing `createf90types` a
`MPI_DATATYPE_NULL` to bail out on, on some MPICH Linux variant or other every run
-- see below for why "which one" has no answer.

**Reading uninitialised memory is why this assert has looked intermittent.** It is
the recorded symptom of the `flaky` entries `typecntsf`, `typecntsf90` and
`typecntsf08`, and two consecutive CI runs settled it for `createf90types` by
disagreeing about which variants it fails on:

    30846819244    mpich/gcc/linux/24.04/x86_64, mpich/gcc/linux/24.04/aarch64,
                   mpich/llvm/linux/24.04/aarch64
    30855216157    mpich/llvm/linux/24.04/x86_64 -- and the three above passed

Same test, same assert, a different set of variants each time, with nothing
relevant changed between them. So it is not a property of the toolchain or the
architecture, and the first run's pattern was worth no conclusion at all: reading
one run as "gcc on Linux plus llvm on aarch64" is the mistake this defect invites,
and it was made here before the second run refuted it. What was on the heap decides
it. That is also why `createf90types` must not be excused per variant if it ever
needs excusing again.

`ci-scripts/mpich-abi-type-get-contents.patch` initialises a pure-out handle array
to the null handle before the call, so the surplus converts to `ABI_DATATYPE_NULL`,
which every `ABI_*_from_mpi` returns on its first line. Zero-filling would not do:
`MPI_DATATYPE_NULL` is `0x0c000000` and handle kind 0 is `HANDLE_KIND_INVALID`,
which is not `HANDLE_IS_BUILTIN`, so a zeroed entry walks past the assert into
`MPIR_Datatype_get_ptr`. Only `out` is initialised and not `inout`, an inout array
being filled by the wrapper's own `to_mpi` loop first.

It patches the generator, `maint/local_python/binding_c.py`, and not the
`src/binding/abi/c_binding_abi.c` it produces, because `install-mpich.sh` patches
before running `autogen.sh` and autogen regenerates that file -- a patch against it
would be overwritten in silence. Two wrappers change and nothing else,
`MPI_Type_get_contents` and its `_c` form. Not reported upstream yet, and worth
reporting.

`bug-mpich-type-get-contents/mpich-abi-type-get-contents-bug.c` is the reproducer,
and it is built to show the read rather than the abort: it asks for four datatypes
from a contiguous type that has one and prints all four, so it demonstrates the
defect on a platform where the garbage happens not to abort. On macOS before the
patch the three surplus entries came back as `201326592` where the ABI's null is
`512`.

CI run 30861875404 is the confirmation, all thirteen jobs green, and it settled more
than `createf90types`: **every one of the five `flaky` entries passed on all six
MPICH variants**, where the two runs before it had `typecntsf`, `typecntsf90` or
`typecntsf08` failing on four variants between them. That is the same assert going
away for the same reason, and it read at the time as though the five were
candidates for removal rather than flakiness anybody still has to live with.

Two runs later that looked refuted: `nonblocking_inpf` and `nonblocking_inpf90`
failed on `mpich/llvm/linux/24.04/x86_64` in 30863777064, then passed again
everywhere in 30905286536, while the three `typecnts*` passed in all three. The
reading at the time was that the patch had removed most of the nondeterminism and
not all of it -- the same uninitialised read, on one variant, in two of the five.

**That reading was wrong, and the split between the two groups was the clue it
should have been.** `nonblocking_inpf` and `nonblocking_inpf90` do not call
`MPI_Type_get_contents` at all. They call `MPI_IALLTOALLW` with `MPI_IN_PLACE` and
a one-element `stypes(1)`, and the read that made them flaky was mpif's own,
converting one datatype per rank out of a one-element array -- defect 2 of the
entry below. No patch to `MPI_Type_get_contents` could ever have touched them, and
what varied between runs was the stack, not MPICH. So the three `typecnts*` were
the only tests exercising this defect after all, they have been quiet for three
runs and a local one, and nothing is left that says it still fires. See item 4 of
"Worth doing next".

The caution that came with the old reading was still right on its own terms, and
is why the two groups were not deleted together: one green run is not evidence
that a nondeterministic failure has stopped. It just was not the reason these two
kept failing.

### MPICH: the generalized request tests require `extra_state` to alias the caller's variable

`greqf`, `greqf90` and `greqf08` -- MPICH's tests, but run against both
implementations, so they fail on all twelve variants -- each set
`extrastate = 1`, start a generalized
request whose `free_fn` does `extrastate = extrastate - 1`, wait on it, and then
require the *caller's* variable to read 0. The f08 one goes so far as to call
`dummyupdate(extrastate)` first, to stop the compiler remembering what was
stored -- so the dependency is deliberate, not an accident of the test.

The standard does not say that. `extra_state` is `IN` in the
`MPI_GREQUEST_START` parameter table and `INTENT(IN)` in its f08 binding; the
callbacks are "passed the extra_state argument that was associated with the
request by the starting call MPI_GREQUEST_START" (section 13.2), which describes
a value being handed over; and the C prototypes all take `void *extra_state` by
value, so a C callback provably cannot write back to the caller's variable at
all -- only through it. Chapter 19, Support for Fortran, says nothing about
`extra_state` anywhere, so there is no Fortran-specific licence either. The one
phrase that points the other way, "extra_state can be used to maintain
user-defined state for the request", means in C what it says: point it at
something.

What makes the tests pass under MPICH's own binding is how that binding is
built rather than a decision about semantics. `mpi_grequest_start_` in
`src/binding/fortran/mpif_h/fortran_binding.c` passes the Fortran actual
argument's address straight through as the C `extra_state` value and hands the
Fortran procedures to MPI unwrapped, so a callback's `extrastate` dummy lands on
the caller's variable as a side effect.

mpif copies instead, so the three tests fail. They report "Free routine not
called", which is wrong and worth knowing before chasing it: the test sets
`freefncall = 0`, declares `common /fnccalls/ freefncall` in `free_fn`, and then
never increments it, so the counter is always zero and the diagnostic always
takes that branch. The real assertion is the `extrastate .ne. 0` above it, and
`free_fn` does run. Matching the tests would mean holding a pointer into the
caller's frame for the lifetime of the request, which is a dangling pointer as
soon as the request outlives the scope it was started in -- a hazard MPICH's
binding has and mpif would be adopting on purpose. `test/grequest_f08.f90` asserts the opposite
of what MPICH's tests assert, and deliberately.

This is the same shape as the `spawnargvf90` entry below: a suite test that
codifies its own implementation rather than the standard. Nothing to fix on this
side.

### Registered datareps are not implemented, by either implementation

`MPI_Register_datarep` forwards its Fortran callbacks correctly now, and nothing
will ever call them. Both implementations decline the feature before mpif's
trampolines can matter:

- MPICH's ROMIO rejects a non-NULL conversion function outright --
  `src/mpi/romio/mpi-io/io_impl.c` returns `MPI_ERR_CONVERSION` with "Read and
  Write datarep conversions are currently not supported by MPI-IO" if either
  `read_conversion_fn` or `write_conversion_fn` is non-NULL. It will register a
  datarep whose conversions are both `MPI_CONVERSION_FN_NULL` and whose extent
  function is real, but `MPI_File_set_view` then refuses the name: the same file
  accepts only `native`, `external32` and `internal`, anything else being
  `MPI_ERR_UNSUPPORTED_DATAREP`, "Only native data representation currently
  supported". So even a datarep MPICH accepts can never be used, and the extent
  callback never fires either.
- Open MPI is worse than briefer: it accepts the call and does nothing.
  `ompi/mca/io/ompio/io_ompio_component.c`'s `register_datarep` is
  `return OMPI_ERROR;` and nothing else, but that line is dead code --
  `mca_io_base_register_datarep` calls `io_register_datarep` only on components
  whose type version is `2, 0, 0`, and `ompio` registers itself as
  `MCA_IO_BASE_VERSION_3_0_0`. No component is ever consulted, `ret` stays
  `OMPI_SUCCESS`, and `MPI_Register_datarep` is a silent no-op. Registering the
  same datarep twice therefore also succeeds, where MPICH reports
  `MPI_ERR_DUP_DATAREP`. Worth reporting upstream, and not yet.

That is the whole feature, not an edge of it, so there is nothing to work around
and nothing to report: both are honest about it in the error message. What mpif
can be held to is that it no longer refuses the call before MPI sees it, which
is what `test/datarep_f08.f90` asserts on the one combination ROMIO accepts --
and that is all it asserts, since anything past registration diverges between
the two implementations -- and
that the trampolines marshal correctly, which `test/datarep_c.c` asserts by
calling them directly. The second is the substitute for an end-to-end test and
should be replaced by one if an implementation ever grows the feature.

### MPICH: attributes on predefined datatypes abort in ABI builds — carried as a local patch

<https://github.com/pmodels/mpich/issues/7916>

`MPI_Type_set_attr` and `MPI_Type_get_attr` abort inside MPICH for any
predefined datatype when it is built for the standard ABI:
`MPII_Attr_delete_c_proxy` converts the handle back with
`ABI_Handle_from_mpi`, whose datatype case reverse-searches
`abi_datatype_builtins[]` and asserts when the handle is not found. Derived
datatypes and communicator attributes are unaffected. The reproducer sent with
the issue is `bug-mpich-7916/mpich-abi-attr-bug.c`; it is pure C, with no
Fortran involved.

The table is searched and comes up empty because there are two of them.
`src/binding/abi/mpi_abi_util.c`, which defines `abi_datatype_builtins[]`,
`abi_op_builtins[]` and the `ABI_init_builtins()` that fills them, is listed in
`mpi_abi_sources`, and that is compiled into both `libmpi_abi` and
`libpmpi_abi`. Where weak symbols are unavailable those really are two
libraries, so each gets its own copy: `MPI_Init` is in `libmpi_abi` and fills
that one, while `libpmpi_abi`, which holds the implementation and therefore the
attribute proxies, keeps a table of zeros. The forward direction never notices,
because the entry points that convert an incoming handle are in `libmpi_abi` --
which is why setting the attribute works and only the callback aborts.

That makes it a macOS problem in practice. `configure` asks for weak symbols and
gives up on them, since `#pragma weak PFoo = Foo` makes gcc ICE on Mach-O
(`internal compiler error: in assemble_alias`), so `NEEDSPLIB=yes` and the
separate profiling library gets built. A Linux build has weak symbols, one
library and one table, and cannot hit this.

Fixed upstream on `main` by
[2eb9a812](https://github.com/pmodels/mpich/commit/2eb9a812025d5b22703fd35398714ba1c9e4f218)
("abi: double inclusion of mpi_abi_util.c under noweak", 2026-06-13), which
moves the file into a new `mpi_abi_core_sources` that goes into the profiling
library alone. The commit predates the issue by seven weeks and does not
reference it, and the issue is still open; nothing has been released with the
fix, 5.0.1 being the latest tag. It is therefore carried locally as
`ci-scripts/mpich-abi-util-one-copy.patch`, applied by
`ci-scripts/install-mpich.sh`. **Drop the patch once a release picks the fix
up**; `git apply` refuses fuzz, so it will fail loudly rather than land
somewhere unintended, and the prepared-tree stamp covers the patches, so
removing it re-prepares rather than reusing an older tree.

The patch is a local copy rather than the upstream commit downloaded by URL,
which is what this script does for its other fix, because the upstream one does
not apply to 5.0.1: `main` has renamed the convenience-library variables in
`Makefile.am` (`@mpllib@` to `@mpl_lib@` and so on) and dropped
`fortran_binding_abi.c` from `mpi_abi_sources`, and both change the context the
commit's hunks expect. The change itself is unaltered.

Two other routes were considered and rejected. There is no configure switch that
does away with the second library: `NEEDSPLIB` is derived from whether weak
symbols work rather than asked for, weak aliases cannot be made to work on
Mach-O, and dropping `libpmpi_abi` would take the `PMPI_` entry points with it,
which the ABI requires. Calling `ABI_init_builtins()` from
`ABI_Datatype_from_mpi` itself would also work, and would need no `automake`
rerun, but it papers over the duplication rather than removing it and diverges
from what upstream did.

### OpenMPI: an empty info value was rejected — fixed upstream, patch dropped

https://github.com/open-mpi/ompi/issues/14246

`MPI_Info_set(info, "key", "")` returned `MPI_ERR_INFO_VALUE` (33) under Open MPI
and `MPI_SUCCESS` under MPICH. The ABI defines that class as "Value longer than
MPI_MAX_INFO_VAL", and the standard gives the empty value a defined meaning on
two reserved keys -- for both `"mpi_memory_alloc_kinds"` and
`"mpi_assert_memory_alloc_kinds"`, "A value corresponding to the empty string
represents no memory allocation kinds" -- so there was no way to say that through
an info object.

Fixed upstream on `main` by
[5e21b7b2](https://github.com/open-mpi/ompi/commit/5e21b7b21f8b4e52c06b5527eb344958325cbb30)
(pull request 14247), which removes the zero-length test on the value and leaves
the empty *key* rejected. That commit was not on the ABI branch mpif builds from,
so it was carried locally as `ci-scripts/openmpi-info-set-empty-value.patch`,
applied by `ci-scripts/install-openmpi.sh`.

The ABI branch has it as of `6cb5ef1d`, the commit `install-openmpi.sh` now
pins, so the patch is gone and `patches=()` is empty. The evidence is
`ompi/mpi/c/info_set.c.in` at that commit: the value check reads
`if ((NULL == value) || (@MPI_MAX_INFO_VAL@ <= value_length))` with no
`0 == value_length` term, and the file carries the 2026 Squyres copyright line
the upstream commit added. `patch --dry-run` against it reports "Reversed (or
previously applied) patch detected", which is the same finding from the other
direction.

Two notes for the next fix that has to be carried. The patch was a local copy
rather than the upstream `.patch` downloaded by URL, which is what
`install-mpich.sh` does for its own fix, because the upstream one does not apply
to the ABI branch: the branch templates the constant as `@MPI_MAX_INFO_VAL@`
where main writes `MPI_MAX_INFO_VAL`, and the commit's other hunks touch a
changelog and tests the branch does not have in the same state. And an empty
`patches` array is not free in bash 3.2, which is what macOS has: under `set -u`
a bare `"${patches[@]}"` is an unbound variable rather than nothing, so the two
places that expand it -- the stamp's `cksum` and the apply loop -- use
`${patches[@]+"${patches[@]}"}`.

It reaches Fortran through the stripping of leading and trailing blanks that the
standard requires of info keys and values: a value of nothing but spaces becomes
the empty string. `test/info_blanks_f08.f90` avoids asserting on it so that
mpif's own tests do not fail on an implementation that has not taken the fix --
still the right thing now that the ABI branch has, since the assertion would be
about the implementation rather than about mpif.
The reproducer sent with the issue is
`bug-ompi-info-value/ompi-empty-info-value.c`; it is pure C, and exits 0 on
MPICH and 1 on an unpatched Open MPI.

### OpenMPI: `MPI_Info_create_env` changes across `MPI_Init`

The info object it returns before `MPI_Init` differs from the one it returns
after, which is what fails `infocrenvf` and `infocrenvf90` -- those compare two
env infos created at different points and expect them to agree. On this machine:

    key         before MPI_Init      after MPI_Init
    maxprocs    0                    1
    soft        0                    1
    host        Redshift.local       Redshift
    wdir        (not set)            (set)

`MPI_Info_create_env` describes how the process was started, which does not
change when MPI is initialised, so the two should agree. MPICH's do, and it
passes the test.

Not an mpif problem: a pure C program that creates an env info before and after
`MPI_Init` and prints both shows the same divergence, with no Fortran involved.
Not reported upstream yet.

### OpenMPI: object names where the standard asks for an empty string

MPI-5.0 section 7.8 gives `MPI_WIN_GET_NAME` and `MPI_TYPE_GET_NAME` "the name
previously stored on the *object*, or an empty string if no such name exists", and
excepts only predefined datatypes: "Named predefined datatypes have the default
names of the datatype name." Open MPI names two things the standard leaves
nameless, which is six suite tests. `bug-ompi-object-names/ompi-object-names.c`
prints both and exits nonzero on the first; it is pure C, no Fortran involved:

    fresh window              MPICH len= 0 ""          Open MPI len=13 "rdma window 3"
    fresh derived datatype    MPICH len= 0 ""          Open MPI len= 0 ""
    dup of a named datatype   MPICH len= 0 ""          Open MPI len=17 "Dup a vector type"

- **A fresh window has a name.** `MPI_Win_create` and then `MPI_Win_get_name`
  yields `"rdma window 3"`, where nobody has called `MPI_Win_set_name`. The
  standard is explicit, so this is a defect, and it is what `winnamef`,
  `winnamef90` and `winnamef08` report as "Did not get empty name from new
  window". Setting and getting a name works, so only the default is wrong.
- **`MPI_TYPE_DUP` invents one.** Duplicating a datatype named `"a vector type"`
  gives the duplicate the name `"Dup a vector type"` -- not a copy of the name but
  a new one, stored by nobody. `typesnamef`, `typesnamef90` and `typesnamef08`
  require the duplicate's name to be empty and report "(type2) Expected length 0,
  got 17".

  This half is weaker: the standard does not say whether `MPI_TYPE_DUP` carries
  the name over, and "exactly the same properties as oldtype" could be read either
  way. What it does say is "previously stored", and "Dup a vector type" was never
  stored by anyone, so a synthesised name is hard to defend under either reading.
  MPICH leaves it empty and the test codifies that; between the two, mpif can only
  follow whichever implementation it is built against.

Nothing to fix on this side either way. The window half is worth reporting
upstream and is not yet; the dup half is worth asking about, since the standard
could settle it in a sentence.

### OpenMPI on macOS: a nonblocking collective write is lost when the aio queue fills — carried as a local patch

`f08/io/i_fcoll_test` writes a 32³ integer array to a file through a
`MPI_Type_create_darray` view with `MPI_File_iwrite_all`, reads it back with
`MPI_File_iread_all`, and finds every element zero. Open MPI says why on the way
past, once per process:

    mca_fbtl_posix_ipwritev: error in aio_write():  Resource temporarily unavailable
    mca_fbtl_posix_ipreadv: error in aio_read(): errno 35 Resource temporarily unavailable

The first reading of this said that the macOS aio queue is small -- `sysctl
kern.aioprocmax` is 16 here, against a Linux default in the tens of thousands,
which is why it is a macOS entry -- and that Open MPI prints the message and gives
up, so "the data never reaches the file". Both halves are too generous. The queue
is small, but Open MPI derives its limit from the wrong sysctl, cannot retry the
way it thinks it can, discards the failure when it happens, and then leaks the
slots it did get. Four separable defects, and the last two are what turn a lost
write into a dead file handle. Paths below are relative to `mpi/src-openmpi-gcc/ompi`
(Open MPI 6.1.0a1).

**The limit is per process, and Open MPI reads the system-wide one.**
`ompi/mca/fbtl/posix/fbtl_posix.c:107` sets `ompi_fbtl_posix_max_prd_active_reqs`,
the number of `aio_write`s it will keep in flight at once
(`fbtl_posix_ipwritev.c:56`), from `sysconf(_SC_AIO_MAX)`. On macOS that reports
`kern.aiomax`, 90 here, which is the *system-wide* total; what one process may
have outstanding is `kern.aioprocmax`, 16. Measured, by declaring the variable
`extern` in a program of one's own and printing it either side of the file open
that runs the fbtl's `module_init`: 2048 -- the compiled-in default at
`fbtl_posix.c:39` -- and then 90. So the batch is sized 5.6× what the process is
allowed. It is not an MCA parameter: `sysconf` is the only thing that ever assigns
it, so no run-time setting can bring it down.

**Nothing can reap during the retry.** `fbtl_posix_ipwritev.c:113-130` does try:
ten attempts per request with `mca_common_ompio_progress()` between them, which is
the fix for open-mpi/ompi#8368, "Exceeding the max. number of pending aio requests
on MacOS", closed in the 4.1 series. It cannot work here. A slot is released by
`aio_return`, not by the operation finishing -- measurement (2) of
`bug-ompi-aio-eagain/posix-aio-limit.c`: sixteen requests that have all completed
still refuse a seventeenth, and accept it the moment they are reaped -- and the
only caller of `aio_return` is `mca_fbtl_posix_progress`, which
`mca_common_ompio_progress` reaches through `req->req_progress_fn`, assigned at
`fbtl_posix_ipwritev.c:133`, *after* the loop. The ten attempts therefore iterate
over a request that progress cannot see, and unless some unrelated ompio request
happens to be reapable they are ten copies of one failure.

**The failure is then dropped on the floor.** `fbtl_posix_ipwritev.c:128` returns
`OMPI_ERROR`; `common_ompio_file_write.c:456` calls it as a statement and assigns
the result to nothing. Which is also the whole of what `MPI_File_iwrite_all`
does, because in ompio it is not collective at all: no component under
`ompi/mca/fcoll/` sets `fcoll_file_iwrite_all`, so
`mca_common_ompio_file_iwrite_all` takes its own else branch at
`common_ompio_file_write.c:667` -- "WE fake it with individual non-blocking I/O
operations" -- and nothing aggregates, so the io array is exactly as fragmented as
the file view, 512 entries for the probe below. The backtrace has no fcoll frame
in it: `PMPI_File_iwrite_all` → `mca_io_ompio_file_iwrite_all` →
`mca_common_ompio_file_iwrite` → `mca_fbtl_posix_ipwritev`.

**And the sixteen slots it did get are leaked.** The error path frees
`data->prd_aio.aio_reqs` (`fbtl_posix_ipwritev.c:126`) while sixteen `aio_write`s
are outstanding against those very control blocks -- undefined on POSIX's terms,
which require an aiocb to stay valid until its operation completes -- and calls
`aio_return` on none of them. Every slot the process has is retired for the life
of the process, so every later nonblocking file operation fails at once, whatever
its view.

`bug-ompi-aio-eagain/ompi-aio-eagain-probe.c` counts all of that on one process,
four `MPI_File_iwrite_all` calls in order, `mpiexec -n 1`:

      (a) contiguous, control      MPI_Get_count =    64 of    64
      (b) 512 blocks of 16         MPI_Get_count =     0 of  8192   <-- lost
      (c) contiguous, after (b)    MPI_Get_count =     0 of    64   <-- lost
      (d) contiguous, once more    MPI_Get_count =     0 of    64   <-- lost
      file is 1984 bytes, a complete write leaves 65472 (16 blocks of 64 bytes landed)

So "loses all of it" was wrong in detail, and the detail is the diagnosis: exactly
`kern.aioprocmax` blocks reach the file, 16 of 512, and the file is left short.
(c) and (d) are the leak -- single-request contiguous writes, identical to the
control that had just succeeded. And the round trip reads back nothing not because
the read is fragmented too but because the write has already retired every slot: a
read-only run in a fresh process against a good file recovers 256 of 8192 integers,
16 blocks again.

The one thing in the interface that admits any of this is `MPI_Get_count` on the
completed request, 0 where a success reports the lot. `MPI_File_iwrite_all` returns
`MPI_SUCCESS`, `MPI_Test` reports the request complete on the first call, and
`MPI_Wait` returns `MPI_SUCCESS` -- silence would be bad enough, and success is
worse. That the request completes at all is worth its own sentence, since a request
with no progress function ought to hang rather than succeed:
`common_ompio_request.c:209` reads a null `req_progress_fn` as "this is a parent
request", finds `req_num_subreqs == req_subreqs_completed` trivially at 0 == 0, and
completes it with a status nobody has written. `MPI_ERROR` in it is uninitialised
heap, which is why nothing can be read off it either.

The blocking path is unaffected, measured: `MPI_File_write_all` through the same
view transfers all 8192 and says so. `fbtl_posix_pwritev.c` contains no `aio_*`
call at all, using `pwritev` and data sieving instead, so this is the nonblocking
path's alone. `bug-ompi-aio-eagain/ompi-aio-eagain.c` remains the four-process
version, closest to the test: MPICH round-trips the array, rerun today, and
Open MPI does not. The noncontiguous view is the necessary part -- a contiguous one
issues few enough requests to stay under the limit and passes -- which is why the
test's `darray` is in that probe, and why the one-process probe reaches the same
fragmentation with a vector type.

There is no workaround at run time. Measured, each still failing:
`--mca fbtl_posix_priority 0` (priority does not deselect the only component in the
framework), `--mca fcoll individual` and `--mca fcoll_vulcan_async_io 0` (fcoll is
not in this path at all, per the backtrace). `--mca fbtl ^posix` leaves no fbtl and
the job dies. Open MPI 6.1 ships one `io` component, `ompio`, and one `fbtl`,
`posix`, so there is nothing to switch to; ROMIO is gone. Raising `kern.aioprocmax`
past 90, with `kern.aiomax` above the product of that and the ranks per node, ought
to work -- inferred, not measured, since it needs root, and a test suite cannot ask
for it anyway.

So it is patched instead: `ci-scripts/openmpi-fbtl-posix-aio.patch`, applied by
`ci-scripts/install-openmpi.sh`, whose preamble carries the reasoning hunk by hunk.
It reads `kern.aioprocmax` on Darwin rather than `sysconf(_SC_AIO_MAX)` and exposes
the value as an `fbtl_posix_max_aio_reqs` MCA parameter; replaces the retry with
back-pressure, posting what the queue takes and leaving the rest to progress, which
needs `mca_fbtl_posix_progress` to arm the next batch on the width of the active
window rather than on a whole chunk; makes the two ompio callers act on what the
fbtl returns; and reaps what was posted before freeing the aiocbs. Both reproducers
in `bug-ompi-aio-eagain/` pass under it, and both fail again when the change is
reverted and Open MPI rebuilt, which is what makes the attribution rather than the
symptom the thing that was tested. `f08/io` under `openmpi/gcc` goes from three
failures to two and `f90/io` and `f77/io` are unchanged at two; the patch builds
warning-free under both gcc 15 and clang 22, and fixes both local Open MPI
variants.

Two things it deliberately leaves alone, both reachable only from a genuine I/O
error rather than from a full queue: the same discarded return value at
`common_ompio_file_write.c:241` and `common_ompio_file_read.c:265`, in the
*blocking* paths, where the enclosing function's own error handling would have to be
rethought; and the partial-completion re-post inside `mca_fbtl_posix_progress`,
which on a failed `aio_write` returns with the request marked `EINPROGRESS` and
nothing in flight, so the next progress call asks `aio_error` about an operation
that was already reaped. Neither is this defect and neither is fixed.

Reported upstream as open-mpi/ompi#14278, with all three probes inlined, and the
patch is open-mpi/ompi#14279 against `main` -- three commits, each compiling on its
own, the source identical to what was built and tested here. Every file it touches
is byte-identical between `main` and the ABI-branch commit `install-openmpi.sh`
pins, so nothing had to be ported. #8368 is referenced in both as the earlier
attempt at the same thing, its fix being the retry loop that cannot retry. Two
questions are put to the reviewers rather than decided here: whether the
`sysctlbyname` belongs in OPAL, which their `AGENTS.md` says is where OS-specific
`#if` blocks go, and which of the two untouched defects above to fold in. Should
either answer change the shape of the patch, this file and
`ci-scripts/openmpi-fbtl-posix-aio.patch` follow it rather than the other way
round. The patch removed the
`openmpi/*/darwin/*/*` xfail for `i_fcoll_test`. Of the two rows that were
untriaged beside it, one is now accounted for and not by this: under flang the test
prints `No Errors` and then flang's `STOP` adds "IEEE arithmetic exceptions
signaled: INEXACT", which `runtests` counts as unexpected output, so
`*/llvm/darwin/*/*` fails on both implementations for a reason that is not an MPI
defect at all -- measured on `openmpi/llvm` and `mpich/llvm` here, and it is why the
row said "passes under gfortran on the same MPI". What is left untriaged is
`*/*/linux/24.04/*`, where the aio message is conspicuously absent from the output
and this patch is not expected to change anything.

### OpenMPI: left to itself it picks an interface it cannot use

Not an mpif problem, and not really a blocker so much as a trap -- but the trap
sprang twice, in different ways, and the second one had eleven suite tests
attributed to the architecture for months.

Everything here runs on one host, and Open MPI given a free choice of interface
takes a non-loopback one and then fails on it:

- **macOS**: it cannot configure the socket -- `setsockopt(TCP_NODELAY) failed:
  Invalid argument (22)`, followed by its own warning that this "may end up
  hanging". It does, in any test that communicates across a spawned
  intercommunicator, and each one then burns runtests' 180-second timeout rather
  than failing, so the suite looks stuck rather than broken. A pure C
  spawn-and-send reproduces it.
- **Linux on GitHub's x86_64 runners**: it picked the `docker0` bridge those
  images have, at 172.17.0.1, which is not an interface anything here wants.

`--mca btl_tcp_if_include lo0` on macOS and `lo` on Linux settles that half, and is
passed in all three places that run the suite: the CI step,
`scripts/macos-test-mpich-suite.sh` and each `docker/openmpi-*.dockerfile`.

### OpenMPI: a spawned child is not reachable over TCP on the x86_64 runners

This is what fails the eleven Open MPI spawn tests that spent months attributed to
the architecture. Each of them spawns children, prints "No Errors" -- so the test's
own logic passes -- and then the job dies:

    [runner:00000] *** An error occurred in Socket closed
    [runner:00000] *** reported by process [3394764801,0]
    [runner:00000] *** on a NULL communicator
    [runner:00000] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will
    [runner:00000] ***    now abort, and MPI will try to terminate your MPI job)

preceded, when Open MPI is allowed to say so, by a warning that it "failed to TCP
connect to a peer MPI process" at `connect() to 127.0.0.1:1025 failed`. So the
child is not reachable where the parent looks, and the teardown of the spawned
intercommunicator is where that becomes fatal.

Why only the x86_64 runners is not established. The arm64 ones, with the same Open
MPI built from the same pinned commit and the same mpif, do not warn and do not
abort; subtract the eleven and the two x86_64 rows equal their aarch64 twins,
5 / 9 / 20 under gcc and 5 / 9 / 16 under llvm. Nothing Fortran-specific is in
sight, and nothing on this side can be held to it, but it has not been reproduced
in C either, for want of an x86_64 Linux Open MPI to hand.

Two wrong turns are worth recording, because both were confident and both were
CI's to refute.

The first was the interface. With `docker0` in play the warning named 172.17.0.1
and looked like a bridge problem; the loopback flag in the entry above was
expected to cure it. It did not -- the warning came back naming 127.0.0.1.

The second was the warning itself. Silencing it with
`--mca btl_base_warn_peer_error 0` -- Open MPI's own knob, on by default -- was
supposed to leave eleven passing tests passing, on the evidence that their output
was "No Errors" plus that warning and nothing else. It was not nothing else:
`runtests` prints at most ten lines of a test's output and then "... ...", and the
abort above began at line eleven. Silencing the warning only uncovered it, and the
tests failed just the same. **A diagnosis from `runtests`' console report is a
diagnosis of the first ten lines** -- which is now fixed at the source rather than
remembered: `ci-scripts/suite/test-mpich-suite.sh` prints the whole recorded output
of every unexpected failure, from the TAP file, which is not truncated.

So the eleven are expected failures again, in
`ci-scripts/suite/mpich-suite-xfail.txt` under `openmpi/*/*/*/x86_64`, with the
abort as the reason rather than the warning.

The arithmetic that says the diagnosis is right: subtracting the eleven leaves the
two Open MPI x86_64 rows in the baseline below identical to their aarch64 twins,
5 / 9 / 20 under gcc and 5 / 9 / 16 under llvm, which is what "the same
implementation on the same OS" should look like.

### MPICH: suite tests that cannot pass against a conforming binding

Six of the suite's tests ask for something MPI-5.0 does not have, something only
MPICH provides, or something the standard explicitly leaves to the implementation.
None of them can pass here, and none is a defect on this side;
`ci-scripts/suite/mpich-suite-xfail.txt` carries each with a reason pointing at
this entry. The `spawnargvf90` entry below is a seventh of the same species,
separate only because it is a disagreement between two copies of one test rather
than with the standard.

- **`bsendf`, `bsendf90`** attach a `character dummy_buf(400)` and say why in a
  comment: "we test a basic buffered send of 10 INTEGERs and assume a buffer of
  400 CHARACTERs are sufficient to account for MPI_BSEND_OVERHEAD". Against the
  standard ABI it is not. `MPI_BSEND_OVERHEAD` is 512 there -- a bound over all
  implementations, where MPICH's own value is 96 and Open MPI's 128 -- and an ABI
  build of MPICH checks against the ABI's number, so attaching 400 bytes fails
  before anything is sent: "Buffer size of 400 is smaller than
  MPI_BSEND_OVERHEAD (512)". The test would have to ask the constant rather than
  guess it. This one is MPICH-only, and not because MPICH is stricter than the
  ABI asks: Open MPI's `mca_pml_base_bsend_attach` has no size check beyond
  `size <= 0`, which is why `bsendf` has always passed there and why `bsendf90`
  is expected to now that it builds.

  `bsendf90` was previously an mpif defect on top of this -- it failed to build
  at all, on all twelve variants, on the `buffer_addr` declaration recorded under
  "The f08 intents match Appendix A.4". Fixing that is what let it get as far as
  the attach, and its expected failure is now MPICH-only and identical to
  `bsendf`'s.
- **`dgraph_wgtf`, `dgraph_unwgtf` and their f90 and f08 copies** ask
  `MPI_Dist_graph_create` for a bidirectional ring with `reorder = .true.`, and
  then check the neighbours `MPI_Dist_graph_neighbors` returns against the
  caller's rank *in MPI_COMM_WORLD*. That is only valid if the reorder did not
  reorder. MPI-5.0 says the opposite in the description of the routine: "If
  reorder = false, all MPI processes will have the same rank in comm_dist_graph as
  in comm_old. If reorder = true then the MPI library is free to remap to other
  MPI processes (of comm_old) in order to improve communication on the edges of
  the communication graph."

  Open MPI takes the licence, through the `treematch` topology component --
  `ompi/mca/topo/treematch/topo_treematch_dist_graph_create.c`, which walks hwloc's
  view of the machine and permutes ranks for locality, falling back to the
  identity when it cannot. In the arm64 Docker image it permutes, deterministically
  and whether or not the run oversubscribes, and the same four processes in C give:

      reorder=1   world rank 0 -> graph rank 2      srcs 0 3    <-- not neighbours of 0
      reorder=1   world rank 1 -> graph rank 0      srcs 2 1
      reorder=1   world rank 2 -> graph rank 1      srcs 0 3
      reorder=0   world rank 1 -> graph rank 1      srcs 0 2    <-- correct ring
      reorder=0   world rank 2 -> graph rank 2      srcs 3 1
      reorder=0   world rank 3 -> graph rank 3      srcs 0 2

  So the topology itself is right and the test's premise is wrong: with the reorder
  off every neighbour is one step away, and with it on the ranks the test compares
  are from two different communicators. Pure C, no Fortran, nothing for mpif to
  fix. MPICH never remaps -- `topo_base_dist_graph_create.c` records `reorder` and
  leaves the group alone -- which is what the test was written against.

  Whether Open MPI remaps depends on the machine, so this is scoped in
  `ci-scripts/suite/mpich-suite-xfail.txt` to the variants where it has been
  seen rather than to Open MPI at large; CI's Open MPI runners pass these tests
  today, and may stop at any time without anything having changed on this side.

  Three variants now, not one. Both of this machine's Open MPI variants --
  `openmpi/gcc/darwin/26/arm64` and `openmpi/llvm/darwin/26/arm64`, against Open
  MPI `6cb5ef1d` -- fail the same six with the same message,
  `MPI_Dist_graph_create() does not create a bidirectional ring graph!`. That
  makes macOS 26 on arm64 the second environment to remap, the first being the
  Ubuntu 26.04 arm64 Docker image, which is what remapping-depends-on-hwloc's-view
  would predict.

  The entries are `openmpi/*/darwin/26/arm64`: wildcarded over the toolchain,
  pinned to the OS version. Both halves were decided by a run rather than by
  taste. The toolchain is wildcarded because gcc and llvm fail identically, which
  follows from `treematch` being C -- the Fortran compiler has no say in whether
  it permutes. The OS version is pinned because macOS 15 and macOS 26 genuinely
  disagree: CI's macos-15 Open MPI jobs pass these tests, so a `darwin/*/arm64`
  selector would fail that job for "unexpectedly passes". Two macOS versions
  parting company is the same kind of thing the OS version was put in the key for.
- **`allctypesf`, `allctypesf90`, `allctypesf08`** run every predefined datatype
  past `MPI_Type_get_name`, `MPI_LB` and `MPI_UB` among them. Those two were
  removed in MPI-3.0 and appear nowhere in the ABI header -- `grep MPI_LB
  mpi.h` finds nothing -- so mpif does not define them either, and the test
  reports "Datatype MPI_LB not available in Fortran". Under `mpi_f08` it gets as
  far as "For datatype MPI_LB found name MPI_DATATYPE_NULL", which is the
  undeclared name defaulting to zero.
- **`attrmpi1f08`** hands `MPI_COMM_NULL_COPY_FN` to `MPI_Keyval_create`. The
  first is the MPI-2 callback, whose attribute arguments are address-sized; the
  second is the MPI-1 routine, whose callbacks take plain INTEGERs. Mixing them
  cannot typecheck, and does not: "Interface mismatch in dummy procedure
  'copy_fn': Type mismatch in argument 'attribute_val_in'
  (INTEGER(4)/INTEGER(8))". It fails to build.

  On a 32-bit platform it builds and passes, since an address-sized INTEGER *is*
  a plain INTEGER there and the two kinds in that message are one kind. So this
  is the one entry in `ci-scripts/suite/mpich-suite-xfail.txt` enumerated per
  64-bit architecture -- `arm64`, `aarch64`, `x86_64` -- rather than by `*`: the
  selector matches a component exactly or by `*` and has no negation, and the
  arm32v7 run reported the test as an unexpected pass while it was `*`, which is
  the mechanism working.
- **`statusconv`** has a C file declaring
  `void c_f08_status_(MPI_F08_status *f08_status)`. The ABI spells that type
  `MPI_F08_Status`, with a capital S; `MPI_F08_status` is MPICH's own name for
  it. It fails to build, in C, before Fortran is involved.
- **`profile1f90`, the f08 copy only**, does
  `use :: mpi_f08, my_noname => mpi_send_f08ts`. `mpi_send_f08ts` is the scheme-1B
  specific name of Table 19.1, the `TYPE(*), DIMENSION(..)` form, which mpif does
  not use: it is scheme 1A, and 1B arrives with assumed-rank or not at all. So the
  name the test interposes is one mpif does not have, and it fails to build.

  Its f90 copy passes now. It used to fail for want of PMPI and was listed here
  with the f08 one; the two turned out to be different problems, and only this one
  is about a name. mpif offers `MPI_Send_f08` -- see "The mpi_f08 specific
  procedure names" in `CODE.md` -- and will not offer
  `MPI_Send_f08ts` until assumed-rank is taken, those two being one decision.

### MPICH: the f08 copy of `spawnargvf90` contradicts the standard and its own f90 copy

Both copies spawn with `inargv(5) = " Ss"`. The f90 one expects the child to see
`"Ss"`, and passes; the f08 one expects `" Ss"`, and fails with
`Found arg Ss but expected  Ss`. MPI-5.0 is explicit for `argv` -- "In Fortran,
leading and trailing spaces are always stripped, so that a string consisting of
all spaces is considered an empty string" -- and MPICH's own binding strips both
ends, so the f08 file is an inconsistent hand-conversion of the f90 one.

`f08/spawn/spawnargvf90` and `f08/spawn/spawnargvf03` therefore fail, and will
keep failing while mpif follows the standard. Nothing to fix on this side.

## Missing features

### Assumed-rank choice buffers

The bindings declare choice buffers as `integer :: buf(*)` guarded by
`!dir$ ignore_tkr` and `!gcc$ attributes no_arg_check`, with no
`TYPE(*), DIMENSION(..)` and no `ASYNCHRONOUS` anywhere. This is conforming --
it is the standard's `.FALSE.` option, which `MPI_SUBARRAYS_SUPPORTED` and
`MPI_ASYNC_PROTECTS_NONBLOCKING` advertise -- so it belongs here as an
improvement rather than an error.

This is also the one place where the f08 intents diverge from Appendix A.4, and
deliberately: the standard gives an input choice buffer
`TYPE(*), DIMENSION(..), INTENT(IN)` and mpif gives it no intent at all, in 207
arguments across the bindings. Omitting it is what lets a wrapper hand the buffer
on to a dummy that has none, and it forbids nothing a conforming program may do.
`dev/check-f08-bindings.jl` counts these and passes them over; taking the
assumed-rank option would bring the intents with it.

**Not being taken for the time being** -- a decision, so that the question is not
reopened by whoever reads the rest of this section and finds it inviting. The
`.FALSE.` option conforms, both implementations offer the same one to `mpif.h` and
the `mpi` module, and the cost of the other is a second mechanism to carry
alongside this one for compilers without Fortran 2018. Everything below is what
taking it would involve, kept because the shape of the work is worth knowing and
because the reasons could change; nothing below is a plan.

The cost is two suite tests, and the suite says exactly what it is. MPICH's
`f08/subarray` directory walks one array through fifteen cases, and the only two
that fail are `test14` and `test15`:

    test8   Send/Recv  2d array column slice iar_2d(:,2:6:2)        No Errors
    test9   Send/Recv  2d array column slice iar_2d(1:7:3,2:6:2)    No Errors
    test12  Isend/Irecv array slice iar(2:7)                        No Errors
    test14  Isend/Irecv 2d column slice iar_2d(:,2:6:2)             Found 27 errors
    test15  Isend/Irecv 2d column slice iar_2d(1:7:3,2:6:2)         Found 9 errors

The pattern is the mechanism: `test8` and `test9` pass the same noncontiguous
slices to a *blocking* call, where the compiler's copy-in/copy-out is correct;
`test12` passes a *contiguous* slice to a nonblocking one, where no copy is made;
`test14` and `test15` combine noncontiguous with nonblocking, and the copy dies at
the wrapper's return, before `MPI_Wait`. 27 and 9 are the element counts of the two
slices, so nothing arrives at all. Both tests declare the array `ASYNCHRONOUS`,
which is the program's half of the contract, and then neither consults
`MPI_SUBARRAYS_SUPPORTED` before relying on it -- so they cannot pass against a
conforming `.FALSE.` implementation, and they are in
`ci-scripts/suite/mpich-suite-xfail.txt` with that reason rather than as untriaged.

Taking the other option would mean declaring choice buffers
`TYPE(*), DIMENSION(..), ASYNCHRONOUS` in the nonblocking, split-collective and
persistent routines and setting both constants to `.true.`. The gain is that
noncontiguous subarrays become valid buffers in nonblocking calls; today the
compiler passes them by in-and-out-copy through a scratch array, which is fine
for blocking calls and invalid for nonblocking ones, where the copy dies before
the request completes. It would also confine mpif to compilers with Fortran 2018
assumed-rank support, so the two mechanisms would have to coexist, selected by
the same kind of `check_fortran_source_compiles` probe that already picks
`ignore_tkr` over `no_arg_check`.

Both implementations take that option, and both draw the line in the same place
as mpif does -- `.TRUE.` in `mpi_f08` only, `.FALSE.` in the `mpi` module and
`mpif.h`, which the standard allows and which is why
`include/mpif_constants.h`'s `.false.` stays right whatever happens here.

- MPICH sets both `.true.` unconditionally in
  `src/binding/fortran/use_mpi_f08/mpi_f08_compile_constants.f90`, and `.FALSE.`
  in `use_mpi/mpifnoext.h`.
- Open MPI decides at configure time: `config/ompi_setup_mpi_fortran.m4` starts
  both at `.false.` and raises them to `.true.` only if `OMPI_FORTRAN_HAVE_TS`,
  its TS 29113 probe, succeeds. `ompi/include/mpif-config.h.in` hardcodes
  `.false.`.

Their implementations are the same shape, and it is the shape mpif would have to
grow, because the interesting work is not the Fortran declaration but what C
does with the descriptor it then receives:

- MPICH has 291 `MPIR_*_cdesc` entry points in
  `use_mpi_f08/wrappers_c/f08_cdesc.c`, about 7,900 lines, over a 107-line
  `cdesc.c`. Each takes a `CFI_cdesc_t *`, and where `!CFI_is_contiguous(buf)`
  it calls `cdesc_create_datatype`, which walks the descriptor's dimensions and
  builds an `MPI_Type_create_hvector` chain per stride, passes count 1, and
  frees the temporary immediately after the call -- safe for a nonblocking call
  because the request holds its own reference.
- Open MPI has 144 `*_ts.c.in` templates and a 138-line
  `use-mpi-f08/base/ts.c`, whose `OMPI_CFI_2_C` does the same job.

Everything either of them calls is public C API, so mpif can do it without help
from the implementation. What mpif would have to change beyond writing that
layer:

- The route to C. An f08 wrapper currently calls the `mpi` module's binding,
  which calls the C symbol: `MPI_Send` -> `MPIF_Send` -> `mpi_send_`. An
  assumed-rank dummy cannot go that way, since the f90 layer's dummy is
  `integer :: buf(*)` and passing to it reintroduces the copy. The 150 routines
  with a choice buffer would need `bind(C)` interfaces straight to new C entry
  points taking `CFI_cdesc_t *`, which pulls in the `bind(C)` entry below for
  those routines.
- The sentinels. `MPI_BOTTOM` and `MPI_IN_PLACE` reach C as plain addresses
  today; behind a descriptor the recognition moves into the cdesc wrapper, as
  MPICH's comparison against `&MPIR_F08_MPI_BOTTOM` shows. "Buffer sentinels
  reach C intact" in `CODE.md` would have to be re-verified on the new path rather
  than inherited.
- `ASYNCHRONOUS` is the cheap half and the data is already in hand: `apis.json`
  marks 142 buffer parameters across 96 routines `asynchronous`, and
  `dev/mpiapi.jl` never reads the field -- the word appears nowhere in `gen/` or
  `include/`.

For scale, `apis.json` has 150 routines with a choice buffer and 222 buffer
parameters between them.

### The mpi module's `_c` names

`gen/mpif_functions.F90` declares `MPI_Send_c`, `MPI_Recv_c` and 157 more beside
their small-count namesakes, so `use mpi` and `mpif.h` can reach the large-count
C entry points. The standard gives no such binding. A.5, which is the appendix
for `mpif.h` and the `mpi` module, contains not one `!(_c)` marker where A.4 has
331, and section 19.1.4 says why: "In older Fortran bindings (mpif.h
(deprecated) and use mpi), no new interfaces and no new specific procedures for
larger types are provided beyond what existed in MPI-3.1; all MPI procedures have
the same types as in the versions prior to MPI-4.0."

Noticed while giving the `mpi_f08` specifics their Table 19.1 names, which is
where the same question had a clear answer: there the plain `_c` names went, the
standard saying invoking them is erroneous. Here it is less clear-cut, and the
argument runs both ways.

For removing them: `MPI_Send_c` is a name the standard defines in C and not in
Fortran, so declaring it in the `mpi` module puts an mpif invention in the `MPI_`
namespace, which the Namespace section of `CODE.md` says nothing may do. Neither
MPICH
nor Open MPI declares one.

For keeping them: without them a program limited to `mpif.h` or the `mpi` module
cannot send more than `huge(0)` elements at all, since those bindings have no
polymorphism to reach the large-count form with -- that is the deficiency the
quoted sentence describes rather than a facility it withholds. And the names cost
little to keep: `mpif.h` has implicit interfaces, so `call MPI_SEND_C(...)` finds
`mpi_send_c_` whether or not anything declares it, and that symbol has to exist
for the f08 layer regardless.

Unresolved, and left alone deliberately rather than swept along with the f08
change: the two are not the same question, and this one is a judgement about
whether mpif should offer a useful non-standard name where the standard offers
nothing. Whoever settles it should decide the `mpif.h` half with it.

### Fortran-set attribute values are not visible to C as a pointer

An attribute set from Fortran and read from C comes back as the value where
MPI-5.0 requires the address of it. Section 19.3.7:

> MPI supports two types of attributes: address-valued (pointer) attributes, and
> integer-valued attributes. C attribute functions put and get address-valued
> attributes. Fortran attribute functions put and get integer-valued attributes.
> When an integer-valued attribute is accessed from C, then `MPI_XXX_get_attr`
> will return the address of (a pointer to) the integer-valued attribute, which
> is a pointer to `MPI_Aint` if the attribute was stored with Fortran
> `MPI_XXX_SET_ATTR`, and a pointer to `int` if it was stored with the deprecated
> Fortran `MPI_ATTR_PUT`.

mpif's wrapper hands MPI the value itself -- `mpi_comm_set_attr_` calls
`MPI_Comm_set_attr(comm, keyval, (void*)*attribute_val)` -- so what MPI stores is
an address-valued attribute whose "address" is the user's number. A conforming C
reader then dereferences it. Of the nine cross-language cases the test suite
enumerates, that is cases 4 and 7 -- Fortran sets, C gets -- and only those:

- Fortran sets and Fortran gets is self-consistent, since `mpif_attr_value`
  returns user-defined attributes verbatim;
- C sets and Fortran gets is right, and for the reason the same section gives:
  "When an address-valued attribute is accessed from Fortran, then
  MPI_XXX_GET_ATTR will convert the address into an integer";
- the deprecated `MPI_ATTR_PUT` form has the same defect one size down, C
  expecting a pointer to `int`.

Four suite tests fail on it, on all twelve variants: `attrlangf90` and
`attrlangf08`, whose whole subject is the nine cases, and `fandcattrf90` and
`fandcattrf08`, whose header says the rule out loud -- "The C attribute copy
function should be passed a pointer to the Fortran attribute value (e.g., it
should dereference it to check its value)". Both crash rather than report,
`attrlangf90` in `cmpif2read_` at the `MPI_Aint` it was given to dereference:

    frame #0: cmpif2read_(..., msg="F2 to c dup") at attrlangc.c:453
    frame #1: f2toctest_ at attrlangf90.f90:747
    stop reason = EXC_BAD_ACCESS (address=0x1b69b4be86b2915)

which is the value the Fortran side stored. That is the whole diagnosis, and it
was confirmed by a probe rather than read off the crash: Fortran sets an
address-sized attribute, C reads it and finds the value; C sets one, Fortran reads
it and finds the address, correctly.

What a fix needs, and why it is a feature rather than a correction:

- **Storage owned by mpif.** The value has to live somewhere with a stable
  address for as long as the attribute exists, and mpif has to hand MPI that
  address instead of the value. One `MPI_Aint` per (object, keyval) pair, not per
  keyval: the same keyval carries a different value on every communicator.
- **A language tag.** `MPI_XXX_GET_ATTR` from Fortran must return the value for a
  Fortran-set attribute and the address for a C-set one, so the wrapper has to
  know which it is looking at. The standard's own advice to implementors says as
  much -- "This requires that attributes be tagged either as 'C' or 'Fortran'" --
  and mpif cannot see the implementation's tag through the ABI, so it needs its
  own record of the pairs it set.
- **A lifetime.** The storage has to be released when the attribute is deleted or
  the object freed, which means noticing `MPI_XXX_DELETE_ATTR`, `MPI_XXX_SET_ATTR`
  overwriting a value, and the object's own free. mpif already keeps a keyval
  registry for the attribute callbacks in `src/mpif_callbacks.c`, so there is
  somewhere for this to go, but the key is wider and the frees are new.
- **The copy callbacks.** `MPI_COMM_DUP` invokes the copy callback for each
  attribute, and a C callback on a Fortran-set attribute is passed the same
  pointer, so a duplicated attribute needs storage of its own. `fandcattrf90`
  tests exactly this.

There is no test in `test/` for it, deliberately: a test asserting what mpif
cannot do yet would be a failing test rather than an assertion, and the four suite
tests above already state the requirement. Write one with the fix.

### `bind(C)`

Nothing is declared `bind(C)`. All 1180 generated entry points -- the 590 MPI
names and their 590 PMPI twins -- rely on the compiler lowercasing names and
appending a single underscore, and on hidden character
lengths being appended at the end of the argument list as `size_t`. That is
correct for gfortran 8 and later and for flang, and an unstated assumption
otherwise -- gfortran before 8 passed hidden lengths as `int`.

### Publishing the Fortran type information to the MPI library

Not needed as things stand, and recorded here only so the question is not
reopened. mpif builds against an implementation that has its own Fortran
bindings -- MPICH is configured `--enable-fortran` -- so the implementation
already knows the Fortran type sizes and boolean representation, and
`test/version_c.c` asserts as much: it aborts if either
`MPI_Abi_get_fortran_booleans` reports `is_set == 0` or
`MPI_Abi_get_fortran_info` returns `MPI_INFO_NULL`. mpif's own boolean values
come from Fortran directly, through the common blocks in
`src/mpif_logical.F90`, so nothing has to be published for those either.

`MPI_Abi_set_fortran_info` and `MPI_Abi_set_fortran_booleans` would only be
needed to make mpif the *sole* provider of that information, so that the
implementation could be built with `--enable-fortran=no`. That is worth
remembering as an option -- it would also sidestep the flang/libtool problems on
macOS -- but it is a change of approach rather than a missing feature, and
MPICH's `MPIR_Abi_set_fortran_info_impl` returns `MPI_ERR_ABI` if the values are
already set, so the two cannot simply be combined.

### Generated callback interfaces and definitions

Two hand-maintained pieces describe callbacks that `apis.json` already
describes, and can therefore drift from it:

- the f08 abstract interfaces (`MPI_User_function`,
  `MPI_Comm_copy_attr_function`, ...) in `src/mpif_f08_types.F90`, all 18 of
  which are in the JSON;
- the predefined callbacks in `src/mpif_attr_fns.F90`, all 14 of which are in
  the JSON as `predefined_function` entries.

An audit of the latter against the JSON found the types all correct and three
divergences, all now corrected. They were what stood between the JSON and these
two pieces being generated, so what is left of that job is the generating:

- `MPI_NULL_DELETE_FN`'s last argument was `ierr` where the JSON says `ierror`,
  and A.5 with it -- `MPI_NULL_DELETE_FN(COMM, KEYVAL, ATTRIBUTE_VAL,
  EXTRA_STATE, IERROR)` against `IERR` for `MPI_NULL_COPY_FN` and `MPI_DUP_FN`
  two lines above. So the standard is inconsistent across its own three MPI-1
  callbacks and the JSON is faithful to it; mpif now is too, all three names
  matching, which for external subprograms is a matter of documentation rather
  than of linkage.
- `MPI_TYPE_NULL_DELETE_FN`'s `ierror` has kind `ERROR_CODE_SHOW_INTENT`, which
  was in none of the generator's kind lists, so generating these would have hit
  `@assert false`. It is now in `int_kinds` beside `ERROR_CODE`, which is all it
  is: the suffix is about A.4 showing an INTENT(OUT) that the abstract interface
  does not, and mpif follows the abstract interface. Whether a callback's
  arguments carry intents at all is a question about callbacks and not about this
  kind -- they do not, in any of the 18.
- `MPI_CONVERSION_FN_NULL`'s `userbuf` and `filebuf` have kind `C_BUFFER3`, which
  `aint_kinds` mapped to `integer(MPI_ADDRESS_KIND)`. That is right where the
  parameter really is an address, as in `MPI_Alloc_mem`, and wrong here: A.5 gives
  a conversion callback `<TYPE> USERBUF(*)`, a choice buffer, and A.1.3 gives
  `TYPE(C_PTR), VALUE`. `C_BUFFER3` and `C_BUFFER4` have moved out of
  `aint_kinds` to join `C_BUFFER2` among the kinds that are a choice buffer in the
  `mpi` module and a `TYPE(C_PTR)` in `mpi_f08`. The earlier worry that "the kind
  alone does not say which" turned out to be unfounded: these two kinds appear on
  callbacks and nowhere else, so they do say. `dev/mpiapi.jl` asserts exactly that
  where it drops callbacks and predefined functions, so the claim is checked on
  every run rather than believed, and `gen/` is byte-identical across the change.

The abstract interfaces themselves are no longer among the divergences, in either
respect. Their intents went first -- there are none, in any of the 18, which is
how MPI-5.0 declares every callback it has -- and the last of their types
followed: `MPI_User_function`'s `invec` and `inoutvec` and the datarep conversion
functions' `userbuf` and `filebuf` are `TYPE(C_PTR), VALUE` as the standard gives
them, where all four used to be `integer(MPI_ADDRESS_KIND)` by reference.

What is left is the risk of drift, and it is smaller than it was: the argument for
generating these two pieces was that nothing checked them, and now
`dev/check-f08-bindings.jl` does -- the abstract interfaces against A.1.3 and the
f08 predefined callbacks against A.4, on the same terms as the generated
wrappers. That is where the argument-name slip above was found. `mpif.h`'s and the
`mpi` module's own predefined callbacks, in `src/mpif_attr_fns.F90`, are the one
set still checked by nothing but the audit recorded here; A.5 gives them, so the
same tool could reach them, and the `ierr`/`ierror` correction above is the kind of
thing it would have said rather than left to an audit. `src/mpif_f08_attr_fns.F90` also copies whatever the
abstract interfaces say, and `test/callback_intents_f08.f90` holds those two
together at compile time, one callback per interface written the way the standard
writes it.

## Worth doing next, roughly in order

1. **Fortran-set attribute values as C sees them**, the one mpif defect the suite
   still reports, above under "Missing features". Four tests, a specification that
   says exactly what is wanted, and a design question -- where the storage lives
   and how its lifetime is tied to the attribute -- that is the whole of the work.
2. **`i_fcoll_test`, the last untriaged entry**, on CI's Linux runners.
   `ci-scripts/suite/mpich-suite-xfail.txt` has the symptom. The two that used to
   be beside it are gone -- the macOS Open MPI case is patched and above, and the
   flang one turned out to be flang's `STOP` printing an IEEE-exception line past
   the test's own `No Errors` -- and this one is neither: the aio message is absent,
   and the test passes on Ubuntu 26.04 while failing on 24.04. Start where the
   spawn eleven were solved: the "## Test output" block in the run's tap file.
3. **Triage `mpich/gcc/linux/26.04/armv7l`**, the one 32-bit variant still
   without a `triaged` line, so it is reported and cannot fail a run. It is
   emulated and local-only, which is why it is behind the i686 one -- that now
   gates, on three consecutive runs agreeing. Do not carry the i686 list over to
   it: they are different 32-bit ABIs, a 64-bit type being eight-byte aligned on
   armhf and four-byte on i386.
4. **Remove the three remaining `flaky` entries**, which is now the simple
   deletion it once looked like -- but for a reason, not for a count. What kept
   them was that `nonblocking_inpf` and `nonblocking_inpf90` had gone on failing
   after `MPI_Type_get_contents` was patched, which read as the same
   uninitialised read still firing. It was not: neither test calls
   `MPI_Type_get_contents`. Both call `MPI_IALLTOALLW` with `MPI_IN_PLACE` and a
   one-element `stypes(1)`, and they were the alltoallw in-place over-read, which
   is fixed and has a guard-page test. That leaves `typecntsf`, `typecntsf90` and
   `typecntsf08` as the only tests that ever exercised the get_contents defect,
   with nothing left that says it still fires. Remove them on the next clean CI
   run; the reasons in `ci-scripts/suite/mpich-suite-xfail.txt` say so.

   The caution that came with the old item was still the right one, and is worth
   keeping in mind for its own sake: one green run is not evidence that a
   nondeterministic failure has stopped. What settles it here is a mechanism, not
   a tally.

Two things are decided and not on this list, so that they are not picked up by
mistake: assumed-rank choice buffers are not being taken for now, and `MPI_Sizeof`
stays as it is, covering rank zero and rank one. Both are recorded where they
belong -- the first in its own section here, the second under "Verified as
correct" in `CODE.md`.

Three things are worth reporting upstream and are not yet. Two are Open MPI: the
`MPI_Info_create_env` divergence across `MPI_Init`, and the name on a fresh window.
The third is MPICH's, and is the one with a fix attached rather than just a
reproducer: `MPI_Type_create_f90_*` compiling to stubs in an ABI build,
`bug-mpich-f90-datatypes/` plus `ci-scripts/mpich-abi-f90-datatypes.patch`.

The lost nonblocking collective write on macOS was the fourth and is now reported:
open-mpi/ompi#14278 for the defect, open-mpi/ompi#14279 for the fix. It is the
first of these to go upstream with the patch rather than the reproducer alone,
which is what the other three are still short of.

## Suite baseline

All twelve variants, from the CI run of `baa7f65`, as failures out of 104 f77,
122 f90 and 136 f08 tests. `ci-scripts/suite/mpich-suite-xfail.txt` is the authority: it names
every one of these with its reason, and the suite run fails on any difference
from it. The table is for telling a change from the background noise at a
glance.

The MPICH rows wobble by one or two between runs, because the `flaky` entries in
the list are genuinely nondeterministic -- in the run these numbers come from,
`typecntsf` failed on `mpich/gcc/linux/aarch64` and passed on
`mpich/gcc/linux/x86_64`, while `typecntsf90` did the opposite. Read the MPICH
rows as approximate to that extent; the list, which excuses them either way, is
what is exact. There are three such entries now rather than five: `nonblocking_inpf`
and `nonblocking_inpf90` were never the nondeterminism they were filed under and
now pass, so two sources of wobble are gone from the f77 and f90 columns.

| variant                          | f77 | f90 | f08 |
|----------------------------------|-----|-----|-----|
| mpich/gcc/darwin/15/arm64        |   3 |   9 |  14 |
| mpich/gcc/linux/24.04/x86_64     |   3 |  10 |  15 |
| mpich/gcc/linux/24.04/aarch64    |   4 |   9 |  15 |
| mpich/llvm/darwin/15/arm64       |   3 |   9 |  14 |
| mpich/llvm/linux/24.04/x86_64    |   4 |  10 |  15 |
| mpich/llvm/linux/24.04/aarch64   |   4 |  10 |  15 |
| openmpi/gcc/darwin/15/arm64      |   5 |   7 |  15 |
| openmpi/gcc/linux/24.04/x86_64   |   8 |  12 |  18 |
| openmpi/gcc/linux/24.04/aarch64  |   5 |   7 |  15 |
| openmpi/llvm/darwin/15/arm64     |   5 |   7 |  15 |
| openmpi/llvm/linux/24.04/x86_64  |   8 |  12 |  18 |
| openmpi/llvm/linux/24.04/aarch64 |   5 |   7 |  15 |

The f08 column's six gcc rows are lower than the run they come from by the four
`*/gcc/*` collective tests -- `alltoallwf08`, `nonblockingf08`, `nonblocking_inpf08`
and `vw_inplacef08` -- which the alltoallw handle-array fixes turned green. They are
inferred, and inferred as *equal to their llvm twin* rather than as four less:
those four were the only f08 difference between the toolchains, so the two rows of
a pair should now coincide, and on four of the six pairs subtracting four gives
exactly that. On the two MPICH pairs it gives one less, which is the flaky wobble
the paragraph above describes rather than a real difference, so the twin is the
number to trust. Measured only on this machine, whose OS version is in no row:
`mpich/gcc/darwin/26/arm64` and `openmpi/gcc/darwin/26/arm64` both report no
differences against the list, at 3/5/11 and 7/9/17, on three MPICH runs and two
Open MPI ones.

Every row is two lower in f90 and one lower in f08 than the run it comes from,
which is the PMPI interface arriving: `wtimef90` in both languages and
`profile1f90` in f90 all pass now, and their entries are gone from the list. The
first two only ever needed the names to exist. The third is the interesting one --
it is MPICH's own profiling test, intercepting `mpi_send_` and `mpi_recv_` and
calling `pmpi_send`/`pmpi_recv`, so it says that the mechanism works and not
merely that the names link. Its f08 copy still fails, and on a different thing
again: it interposes `mpi_send_f08ts`, a scheme-1B name that belongs to
assumed-rank. See "The mpi_f08 specific procedure names".

Measured on `mpich/gcc/darwin/26/arm64`, which reports no differences against the
list after the change, and inferred for the other eleven: nothing about these three
is implementation- or toolchain-specific, all three were expected to fail on `*/*`
before, and CI is what confirms it.

Every Open MPI f90 row is one lower again than the run it comes from: `bsendf90`
used to fail to build everywhere and now builds, and fails only on MPICH -- see
"suite tests that cannot pass against a conforming binding". That is inferred
rather than measured, from `bsendf`, which is the same test with the same
400-byte buffer and has always been expected to fail on MPICH alone; CI is what
confirms it, on all four Open MPI variants at once.

The two Open MPI x86_64 rows are the measured ones again: the eleven spawn tests
there fail, on the abort recorded under "a spawned child is not reachable over TCP
on the x86_64 runners", and subtracting them is what would make those rows equal to
their aarch64 twins. Two attempts to remove them -- the interface, then the warning
-- were both refuted by CI, which is what the rows are for.

The table has no 32-bit row. `mpich/gcc/linux/13/i686` now gates, on three
consecutive runs -- 30861875404, 30863777064 and 30905286536 -- reporting it under
its own key with no differences; `mpich/gcc/linux/26.04/armv7l` is still
untriaged. What one run of that one reported, after the kinds were fixed: the whole
suite ran, and the only differences from the list were the `flaky` entries going
both ways -- `nonblocking_inpf` and `nonblocking_inpf90` passing, `typecntsf`,
`typecntsf90` and `typecntsf08` failing, all of which the list excused either way
-- plus `attrmpi1f08` passing, which is the entry now enumerated per 64-bit
architecture above. The first two are no longer in the list at all, being the
alltoallw in-place over-read rather than the get_contents read they were filed
under, so a rerun of that variant has two fewer excuses and should still show no
differences. So nothing 32-bit-specific is outstanding on that
variant, on one measurement. Do not carry one list to the other, the two being
different 32-bit ABIs.

`mpich/gcc/linux/13/i686` has still not been measured under its own name. Its first
CI run reported `mpich/gcc/linux/13/x86_64` instead -- `uname -m` in a buildx
`linux/386` build returns the host's architecture, described under "Working on
this" -- so that run compared a 32-bit build against the 64-bit rows and its
numbers are not a baseline for anything. The `attrmpi1f08` it reported as
unexpectedly passing is the same 32-bit pass the arm32v7 run found, showing through
a key that said `x86_64` and so matched the entries scoped to it.

Fifty-eight entries cover them, for forty-nine distinct language-and-test pairs --
three of them `flaky` rather than `xfail`. Six went away with the alltoallw
handle-array fixes: the four `*/gcc/*` collective tests and the two
`nonblocking_inp*` flaky ones, and a seventh with the aio patch, the two macOS
`i_fcoll_test` rows collapsing into one for flang. All but one are accounted for, each
either by an entry here or by a reason that stands on its own; the one is
`i_fcoll_test` on CI's Linux runners. The rows above are
CI's, so they do not count the twelve `dgraph` entries, six for a Docker variant
and six for this machine's two Open MPI variants, which share one selector.

Those two numbers were "fifty-four" and "fifty-two" for a while and were wrong
when written down, the file having gained entries without them being updated: the
real figures at the commit before the 32-bit work were 65 and 63, and they were 65
and 55 before the alltoallw fixes removed six. Count them rather than trusting the
sentence, and prefer a count over a memory of one:

    awk '$1=="xfail"||$1=="flaky"' ci-scripts/suite/mpich-suite-xfail.txt | wc -l

Triage has taken twenty-four untriaged pairs down to two, and resolved them into
four mpif bugs, two MPICH ones, three Open MPI ones, a decision, a test asserting
more than the standard says -- the `dgraph` pair, where Open MPI is within its
rights -- and eleven that were never failures at all, the spawn tests that a
launcher warning was failing for them. One of those attributions has since moved:
the four `*/gcc/*` collective tests were counted against MPICH and are mpif's, so
the mpif column gained a bug and the MPICH column lost one. An entry can be
triaged and still be pointing at the wrong culprit. Every one came from running the test rather
than reading it, or from reading what the run printed: the four attribute tests
crash in a C frame that names the defect, `test14` and `test15` sit in a directory
whose thirteen passing neighbours say what the mechanism is, the two Open MPI name
cases and the aio one reproduce in C in a dozen lines, and the spawn eleven needed
nothing but the "## Test output" block that every CI run had been recording all
along. The earlier version of this section had four rows and
claimed every failure was attributable, both of which were wrong: MPICH looked
far worse than Open MPI only because those rows predated the handle-table patch,
and most of the failures had never been diagnosed.

Three things the twelve-way measurement settled that guesswork had got wrong:

- **The architecture belongs in the key**, though not for the reason it was put
  there. Eleven Open MPI spawn tests failed on `linux/x86_64` and passed on
  `linux/aarch64`, and two MPICH tests differ the other way; keyed on
  `mpi/toolchain/os` alone, each set would read as an unexpected pass on whichever
  runner ran second. The spawn eleven turned out not to be about the ISA at all --
  a warning the x86_64 runners produce and the arm64 ones do not, for reasons not
  established -- so read the component as "a different environment" rather than as
  a claim about the instruction set. The two MPICH tests keep it in the key.
- **`alltoallwf08`, `nonblockingf08`, `nonblocking_inpf08` and `vw_inplacef08`
  are a gcc problem, not an MPICH one.** They failed under gcc on *both*
  implementations and passed under llvm on both, so the selector was `*/gcc/*/*`.
  That much held up and was the thing that eventually solved them: it is mpif's
  own defect, gfortran repacking an assumed-size `%MPI_VAL` into a zero-length
  temporary, and the four now pass everywhere. Two guesses were withdrawn along
  the way -- first that they were about compiler-made buffer copies for
  noncontiguous subarrays, then that MPICH's `mpi_abi_util.h:140` was asserting on
  a datatype only it knows about. See the withdrawn `ABI_Datatype_from_mpi` entry.
  The lesson that survives both is the selector's: *`*/gcc/*` on both
  implementations means the bug is on our side of the boundary*, and it was
  visible from the first measurement.
- **`mpich/gcc/darwin/arm64` transfers between machines.** Its list was measured
  here, on MacPorts gcc 15.2 with twelve cores, and CI's macos-15 runner --
  Homebrew compilers, about three cores -- reports no differences against it.
  That is the evidence that the key needs nothing finer than architecture.

Every variant CI runs is declared `triaged` -- the twelve above and
`mpich/gcc/linux/13/i686`, which is all thirteen jobs -- so any difference there
now fails the run. Fifteen `triaged` lines in all, the other two being the
environments outside CI. The one variant still not gating is
`mpich/gcc/linux/26.04/armv7l`, which CI does not run: `.github/workflows/ci.yaml`
builds only the `linux/386` container, and the arm32v7 image is emulated and
local-only.

The twelve rest on a single measurement each, which is thin for a flaky test, so
expect some churn: a flaky entry surfaces as an unexpected pass, which is the
mechanism working rather than failing. Three entries are already marked as seen
on one variant only and therefore suspect.

`test/`, mpif's own suite, was 32 of 32 and is now 51 of 51, the most recent
additions being the seven alltoallw ones and, before them, the four PMPI ones --
`pmpi_f`, `pmpi_f90`, `pmpi_f08` and `profile_f90` -- and `profile_f08`, which
interposes an f08 specific. Green on all twelve variants in CI up to the PMPI
five; `profile_f08` and the alltoallw seven have been run on
`mpich/gcc/darwin/26/arm64`, `mpich/llvm/darwin/26/arm64` and
`openmpi/gcc/darwin/26/arm64`, the rest being CI's to confirm.

The alltoallw seven are the first tests here that need more than one rank, which
`add_mpi_test`'s `NPROCS` supplies -- and they need it: at one rank a group size,
a remote group size and a neighbour count all coincide, so every wrong length is
the right one. `MPIEXEC_EXECUTABLE` is pinned by
`scripts/macos-test-mpif.sh` rather than left to `find_package(MPI)`, which
detected an unrelated miniforge install here and would have run them against an
MPI that mpif was not built against.

Two of the four had to be written differently than first drafted, and both for
reasons about MPI rather than about PMPI. `pmpi_f90` freed the address rather than
the buffer -- `MPI_FREE_MEM` takes a choice buffer, so an address-kind baseptr has
to go back through `C_F_POINTER` first, as `test/alloc_mem_cptr.f90` already did.
And `pmpi_f08` hung: a blocking send to self is allowed to block until the
matching receive is posted, and on MPICH it does, so the small-count case is a
`PMPI_Sendrecv` and the nonblocking one an `PMPI_Irecv` before its `PMPI_Send`.

Passing the f08 status through to C instead of converting it moved nothing, and
was not meant to: it removes the temporary, the conversion and all 77 `loc()`
comparisons, leaving what the wrappers do observably the same. The numbers being
unchanged is the result to want from it.

`mprobef08` accounts for the last f08 failure removed, one on each variant. It
had two causes, and the second is the interesting one: mpif declared
`TYPE(MPI_Status), INTENT(OUT)` where the standard declares plain
`TYPE(MPI_Status)`, and INTENT(OUT) tells the compiler that the caller's stored
`status%MPI_ERROR` cannot be read, so at -O2 the store is deleted before the call
happens. The suite compiles with -O2 and caught it; `test/` compiles with -O0 and
did not.

Exporting the predefined attribute callbacks from the `mpi` and `mpi_f08`
modules moved f90 and f08 and left f77 exactly where it was, which is the
confirmation that it was the modules at fault: `mpif.h` had always declared them.
Six f90 tests and four f08 tests went green on both implementations --
`attrmpi1f90`, `commattr2f90`, `commattr3f90`, `commattr4f90`, `typeattr3f90`,
`winattr2f90`, and the `f08` counterparts of four of those -- and nothing
regressed.

The toolchains now agree exactly on f77, f90 and f08. They used to differ by four
tests, the same four on both MPI implementations, all failing under gfortran and
passing under flang:

    alltoallwf08   nonblockingf08   nonblocking_inpf08   vw_inplacef08

**Their shape was a lead, and it was the wrong one -- worth recording, because it
was plausible for months and cost the four that long.** All four are nonblocking
or in-place collectives, which is exactly the case "Assumed-rank choice buffers"
above describes: with `MPI_SUBARRAYS_SUPPORTED` false a noncontiguous actual
argument reaches the wrapper as a compiler-made copy, and for a nonblocking call
that copy dies before the request completes. Two compilers need not make the same
copy, so the difference looked like one about what each chose to copy. That reading
made the four a cost of declining assumed-rank rather than a defect to fix, which
is the kind of conclusion that stops anyone looking.

It was none of it right. What the four have in common is not the buffer, it is
`alltoallw`: every one of them calls a member of that family, which is the only
one in the standard whose Fortran binding takes an *assumed-size array of
handles*. The compiler-made copy that mattered was of `sendtypes`, not of a choice
buffer, and gfortran making it while flang does not is the whole of the toolchain
split. The entry for the withdrawn `ABI_Datatype_from_mpi` diagnosis has it in
full. The general lesson is about which similarity to follow: three of the four
being nonblocking is a coincidence of the directory, and the fourth,
`vw_inplacef08`, is not nonblocking at all -- which the lead had to explain away
and did not.

One caution about these numbers: the Open MPI run needs the loopback workaround
that `scripts/macos-test-mpich-suite.sh` applies by default -- without it the
spawn tests hang rather than fail, each burning `runtests`' 180-second timeout,
and the run appears stuck.

Two ways a *local* suite run goes wrong for reasons that are not the code, both
of which have now cost a run:

- **Do not rebuild while a suite run is going.** The three build-and-test scripts
  delete and reinstall what they own, so `scripts/macos-build-mpif.sh` run against
  a variant whose suite is mid-flight removes the `mpifort` that `runtests` is
  calling. Every remaining test then reports `Failed to build ...  /bin/sh:
  .../bin/mpifort: No such file or directory`, which looks like a catastrophic
  regression and is nothing at all.
- **MPICH's spawn tests depend on the machine's hostname staying put.** One run
  here failed them with `spawned process group was unable to connect back to the
  parent on port <... $description#Mac.pitp.io$ ... $ifname#10.10.60.90$>` and
  `Connection timed out in 180 seconds`, while `hostname` afterwards reported
  `Redshift.local`. The name changed under the run -- DHCP, a network move -- so
  the child could not reach the address the parent had published. Rerun before
  believing it; the same suite had reported no differences twice within the hour.
