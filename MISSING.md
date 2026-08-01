# Missing features and known errors

A review of `dev/mpiapi.jl`, the generator that produces `gen/mpif_functions.c`,
`gen/mpi_functions.F90` and `gen/mpi_f08_functions.F90` from the MPI standard's
`apis.json`.

Findings were checked against `data/apis.json`, the generated output, the
official ABI header and the MPI 5.0 standard, rather than by reading the
generator alone. Line numbers refer to the state of the code when the review was
written.

Signatures are the JSON's business: it is what the generator reads, and what any
hand-written binding should be checked against. The standard is what makes the
JSON legible, since its keys and kinds are otherwise undocumented -- `C_BUFFER3`
means an address in `MPI_Alloc_mem` and a choice buffer in a datarep conversion
callback, and only the standard says which. Keep a copy at
`doc/mpi50-report.pdf` (git-ignored); `pdftotext -layout` makes it greppable.

## Errors

### 1. Callbacks: predefined ones now work, user-defined ones do not

Originally `dev/mpiapi.jl` emitted `abort();` as the C-side conversion for
`FUNCTION` and `POLYFUNCTION` parameters, so thirteen generated wrappers killed
the process:

    mpi_op_create_               mpi_op_create_c_           mpi_comm_create_keyval_
    mpi_type_create_keyval_      mpi_win_create_keyval_     mpi_keyval_create_
    mpi_grequest_start_          mpi_register_datarep_      mpi_register_datarep_c_
    mpi_comm_create_errhandler_  mpi_file_create_errhandler_
    mpi_win_create_errhandler_   mpi_session_create_errhandler_

Partly fixed. The ABI spells the predefined callbacks as sentinel addresses --
`MPI_COMM_NULL_COPY_FN` is `((MPI_Comm_copy_attr_function*)0x0)`,
`MPI_COMM_DUP_FN` is `0x1` -- rather than as callable functions, so no
trampoline is needed for them: `src/mpif_callbacks.c` recognises the address of
the Fortran procedure and hands MPI the sentinel. That covers
`MPI_Comm_create_keyval` and the rest of the attribute machinery with the
predefined callbacks, which is the common case; see error 4.

User-defined **attribute** callbacks now work too, through trampolines. MPI is
handed a C function which converts arguments and calls the Fortran procedure:
handles become default `INTEGER`s, which serves `mpif.h`, `use mpi` and
`mpi_f08` alike because the f08 handle types are `bind(C)` derived types holding
a single integer; `extra_state` and attribute values become
`INTEGER(KIND=MPI_ADDRESS_KIND)`, or plain `INTEGER` for the MPI-1 forms; `flag`
goes through `mpif_logical2bool`; and Fortran's `ierror` becomes the C return
value.

The trampoline finds the procedure again through the keyval, which is the one
piece of identifying information every attribute callback receives. Registry
entries are deliberately never removed: `MPI_Comm_free_keyval` only *marks* a
keyval for deletion, and delete callbacks still fire afterwards for attributes
that already exist. A keyval number MPI reuses overwrites its entry, so the
table grows only to the number of keyvals live at once, capped at 256. Access is
lock-free, publishing the keyval with release ordering once the procedures are
in place.

The remaining callback types receive nothing a trampoline could use to find the
Fortran procedure, so they still report `MPI_ERR_OTHER` with a diagnostic:

User-defined **reduction operators** work too, by a different route.
`MPI_User_function` is told only the buffers, the length and the datatype --
nothing that says which operator is being applied -- so there is nothing to look
up when it fires. `src/mpif_callbacks.c` therefore pre-generates a pool of 128
trampoline pairs, each knowing its own slot at compile time, and `MPI_Op_create`
takes a free one.

A slot is never given back. `MPI_Op_free` only marks the op for deallocation --
section 2.5.1 of the standard has it that "the object itself still persists
until any pending operations are complete" -- so a nonblocking reduction started
before the free may call the trampoline afterwards, and reusing the slot would
send that call to a different operator's Fortran procedure. Nothing tells us
when MPI has finished with the op, so the slot is retired instead, and a program
may create at most 128 user-defined operators over its lifetime rather than at
any one time. The buffers pass straight through as choice buffers, the
datatype is converted to an `INTEGER` handle, and the length is an `INTEGER` or
`INTEGER(KIND=MPI_COUNT_KIND)` for the large-count form. Exhausting the pool
reports `MPI_ERR_OTHER` with a diagnostic.

**Error handlers** work by the same route as operators, for the same reason: a
handler is told which object raised the error and which error code, but not
which handler is running. All four of `MPI_Comm_create_errhandler`,
`MPI_Win_create_errhandler`, `MPI_File_create_errhandler` and
`MPI_Session_create_errhandler` draw from one pool of 64 slots, each slot with a
trampoline per object kind. The handle is converted to an `INTEGER` and the error
code is copied back, since the C prototype passes it by pointer and a handler may
change it. Slots are never released -- `MPI_Errhandler_free` only marks a handler
for deallocation and it stays in use by everything it is attached to, and an
error handler is more likely than most callbacks to fire long after the program
has stopped thinking about it.

Still reporting `MPI_ERR_OTHER`:

- `MPI_Grequest_start` and `MPI_Register_datarep` -- both pass `extra_state`, so
  a box holding the Fortran procedures plus the user's own extra state can be
  passed in its place. A generalized request's `free_fn` is called exactly once,
  which is where its box is freed; datareps are never deregistered, so theirs
  lives for the duration.

### 1a. Duplicated handle conversions

`src/mpif_callbacks.c` has its own `comm_toint` and friends, mirroring the
`MPIF_*_toint` helpers the generator emits into `gen/mpif_functions.c` to work
around implementations that mishandle predefined handles. The generator should
emit an `#include` of a shared header instead of 22 static functions, after
which the copies in `src/mpif_callbacks.c` can go.

The large-count variant of this is also wrong by the generator's own admission:
it carries a `# TODO: Check properly whether the function parameter needs
embiggening`, with a hardcoded exception list containing only
`MPI_Datarep_extent_function`.

### 2. Fortran `.TRUE.` was hardcoded as 1 — fixed

`fortran_true = 1` / `fortran_false = 0` were baked into the generator. Inputs
used `!= 0`, which is safe, but outputs wrote a literal `1`, so every `LOGICAL`
out argument -- `flag` in `MPI_Test` and `MPI_Iprobe`, `MPI_Comm_test_inter`,
`MPI_Finalized`, `commute`, ... -- was wrong on a compiler whose `.TRUE.` is not
1. Intel Fortran uses -1.

Fixed: the conversions now go through `mpif_bool2logical` and
`mpif_logical2bool` in `src/mpif_logical.c`, which read the values from two
common blocks that `src/mpif_logical.F90` initialises with
`transfer(.true., 0)` and `transfer(.false., 0)`. This is the same arrangement
as `MPI_BOTTOM` and the other sentinels, with the direction reversed: there C
defines the common block and Fortran reads it, here Fortran defines it and C
reads it.

Taking the values from Fortran rather than from
`MPI_Abi_get_fortran_booleans` is deliberate. The library reports whatever
Fortran layer published its values, which need not have been built with the same
compiler as mpif, and reports nothing at all when the implementation has no
Fortran bindings of its own. The compiler that builds mpif is the one whose
representation the user's `LOGICAL` arguments actually arrive in.

Now that these values are available in C, mpif could also publish them with
`MPI_Abi_set_fortran_booleans`; see "Missing features".

### 3. `MPI_Pcontrol` was missing entirely — fixed

The generator skipped any function with a `VARARGS` parameter.
`MPI_Pcontrol(level, ...)` is the only one, and its Fortran binding takes just
`level`, so the function is perfectly expressible. It had no binding at all.

Fixed: the varargs parameter is dropped instead of the whole function, and
`PROFILE_LEVEL` was added to `int_kinds` so that `level` is recognised.

**`gen/` must be regenerated for this to take effect** (`julia dev/mpiapi.jl`).

### 4. The predefined attribute callbacks were declared but never defined — fixed

`include/mpif_functions.h` declares `external :: MPI_COMM_NULL_COPY_FN`,
`MPI_COMM_DUP_FN`, `MPI_CONVERSION_FN_NULL` and eleven more, but the generator
skips every entry with a `predefined_function` attribute and nothing implemented
them, so `mpif.h` users got a link error -- `_mpi_null_copy_fn_ referenced
from _MAIN__`. Because mpif prunes the implementation's Fortran library, its
symbols were not available as a fallback either.

Fixed: `src/mpif_attr_fns.F90` defines all fourteen as external subroutines
(they cannot live in a module, since `mpif.h` declares them `EXTERNAL` and needs
plain global symbols), and `src/mpif_callbacks.c` maps their addresses to the
ABI's sentinels. Their bodies implement what the standard prescribes -- the copy
functions report `.FALSE.` except the `DUP` variants, the delete functions do
nothing -- but are never reached in normal use, since MPI is handed a sentinel
rather than a procedure.

Still missing: the `mpi` and `mpi_f08` modules do not export these names, only
`mpif.h` does. The f08 forms would additionally need separate procedures, since
their arguments are `TYPE(MPI_Comm)` rather than `INTEGER`.

### 5. `MPI_SUBARRAYS_SUPPORTED` and `MPI_ASYNC_PROTECTS_NONBLOCKING` were undefined — fixed

Both are required constants in all three interfaces, and neither existed.

Fixed: both are `.false.` in `include/mpif_constants.h`, which serves `mpif.h`
and the `mpi` module, and are re-exported by `src/mpi_f08_constants.F90` for
`mpi_f08`. They are hand-written rather than generated, along with the rest of
the constants.

`.false.` is not a wart but the standard's own second option, quoted here
because it also settles what the buffer declarations are allowed to be:

> Set the MPI_SUBARRAYS_SUPPORTED constant to .FALSE. and declare choice
> buffers with a compiler-dependent mechanism that overrides type checking if
> the underlying Fortran compiler does not support the Fortran 2018 assumed-type
> and assumed-rank notation. In this case, the use of noncontiguous sub-arrays
> as buffers in nonblocking calls may be invalid.

For `mpif.h` the standard goes further and *requires* `.false.`: "In the case of
implicit interfaces for choice buffer or nonblocking routines, the constants
must be set to .FALSE." -- and mpif.h's interfaces are implicit, being `external`
declarations.

### 6. Attribute values were declared as plain INTEGER — fixed

For the `ATTRIBUTE_VAL` and `EXTRA_STATE` kinds the generator emitted
`MPI_Aint*` on the C side but `integer` on the Fortran side, so
`MPI_Comm_get_attr`, `MPI_Win_get_attr`, `MPI_Type_get_attr` and the
`*_set_attr` and keyval routines had C writing eight bytes into a four-byte
variable. The standard calls for `INTEGER(KIND=MPI_ADDRESS_KIND)`.

Fixed in the generator, and in the hand-written f08 abstract interfaces in
`src/mpi_f08_types.F90`, where `extra_state` was already address-sized but
`attribute_val` was not. `EXTRA_STATE2` moved to the deprecated MPI-1 branch
alongside `ATTRIBUTE_VAL_10`, which is plain `INTEGER` on both sides and was
already self-consistent.

Nothing in `test/` touches attributes, which is why this went unnoticed;
`f77/attr` and `f08/attr` in MPICH's suite are what would have caught it.

### 7. Attribute values were returned as addresses — fixed

Two problems in the attribute getters, both found by MPICH's `f77/attr` tests.

`mpi_attr_get_` handed MPI the *value* of an uninitialised `void *` where a
`void **` was wanted, so MPI wrote through whatever that happened to be: a null
pointer in `attrmpi1f`, a garbage address and SIGBUS in `baseattrf`. One missing
`&` in the deprecated-attribute branch; the MPI-2 branch already had it.

Beyond that, the C and Fortran bindings disagree about predefined attributes: C
returns the address of a copy of the value, Fortran returns the value. So
`MPI_TAG_UB` and friends came back as addresses -- `Got invalid value 53848696
for HOST`. `src/mpif_attrs.c` now converts, keyed on the keyval, which the ABI
numbers distinctly across object types (501-507 for communicators, 601-605 for
windows) so one table serves all four getters. `MPI_WIN_SIZE` is a pointer to an
address-sized value rather than to an `int`, and `MPI_WIN_BASE` is the address
itself rather than a pointer to it. Table 12.1 of the standard gives the C types
-- `void *` for `MPI_WIN_BASE`, `MPI_Aint *` for `MPI_WIN_SIZE`, `int *` for
`MPI_WIN_DISP_UNIT`, `MPI_WIN_CREATE_FLAVOR` and `MPI_WIN_MODEL` -- and the
prose the rule: "In C, pointers are returned, and in Fortran, the values are
returned, for the respective attributes."

### 8. `loc()` is used to detect `MPI_STATUS_IGNORE`

77 occurrences in the f08 layer. `loc()` is a widely implemented extension but
not standard Fortran, and comparing addresses silently fails if the argument
arrives as a copy.

## External blockers

### MPICH: attributes on predefined datatypes abort in ABI builds

<https://github.com/pmodels/mpich/issues/7916>

`MPI_Type_set_attr` and `MPI_Type_get_attr` abort inside MPICH for any
predefined datatype when it is built for the standard ABI:
`MPII_Attr_delete_c_proxy` converts the handle back with
`ABI_Handle_from_mpi`, whose datatype case reverse-searches
`abi_datatype_builtins[]` and asserts when the handle is not found. Derived
datatypes and communicator attributes are unaffected.

Nothing to fix on this side, and nothing to work around: mpif has no way to set
a datatype attribute other than through MPI. `f77/attr/typeattrf` and its f08
counterpart in MPICH's own test suite fail until this is fixed upstream. The
reproducer sent with the issue is `bug-mpich-7916/mpich-abi-attr-bug.c`; it is pure C, with
no Fortran involved.

### OpenMPI: some built-in types are not mapped correctly

https://github.com/open-mpi/ompi/issues/14243

The Fortran types `MPI_2INTEGER`, `MPI_2REAL`, and
`MPI_2DOUBLE_PRECISION` are not mapped correctly from their ABI handle
to their internal OpenMPI handle.

## Missing features

### Assumed-rank choice buffers

The bindings declare choice buffers as `integer :: buf(*)` guarded by
`!dir$ ignore_tkr` and `!gcc$ attributes no_arg_check`, with no
`TYPE(*), DIMENSION(..)` and no `ASYNCHRONOUS` anywhere. This is conforming --
it is the standard's `.FALSE.` option, see error 5 -- so it belongs here as an
improvement rather than an error, now that the constants advertise it.

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

### `bind(C)`

Nothing is declared `bind(C)`. All 585 entry points rely on the compiler
lowercasing names and appending a single underscore, and on hidden character
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
  `MPI_Comm_copy_attr_function`, ...) in `src/mpi_f08_types.F90`, all 18 of
  which are in the JSON;
- the predefined callbacks in `src/mpif_attr_fns.F90`, all 14 of which are in
  the JSON as `predefined_function` entries.

An audit of the latter against the JSON found the types all correct but three
divergences worth knowing before generating them:

- `MPI_NULL_DELETE_FN`'s last argument is `ierror` in the JSON, `ierr` in the
  hand-written version. Harmless for an external subroutine with no explicit
  interface, but a divergence.
- `MPI_TYPE_NULL_DELETE_FN`'s `ierror` has kind `ERROR_CODE_SHOW_INTENT`, which
  is in none of the generator's kind lists, so generating these would hit
  `@assert false` until it is handled.
- `MPI_CONVERSION_FN_NULL`'s `userbuf` and `filebuf` have kind `C_BUFFER3`,
  which `aint_kinds` maps to `integer(MPI_ADDRESS_KIND)`. That is right where
  the parameter really is an address, as in `MPI_Alloc_mem`, and wrong here: the
  standard's binding for a conversion callback is `<TYPE> USERBUF(*)`, a choice
  buffer. The kind alone does not say which, so the generator would need to
  distinguish callbacks from ordinary functions.

## Verified as correct

Recorded so that they do not get re-investigated:

- **Nothing is silently dropped.** Replaying the generator's filters over
  `apis.json` gives 430 kept functions, 589 including `_c` variants, and
  `gen/mpi_f08_functions.F90` contains exactly those 589. Every omission is
  attributable to a filter.
- The 102 functions skipped as `not f90_expressible` are the C-only handle
  converters (`MPI_Comm_c2f`, `MPI_Comm_fromint`, ...) and the whole `MPI_T`
  interface, which the standard defines for C only.
- **Buffer sentinels work.** `MPI_BOTTOM`, `MPI_IN_PLACE`, `MPI_ARGV_NULL`,
  `MPI_ARGVS_NULL`, `MPI_ERRCODES_IGNORE`, `MPI_STATUS_IGNORE` and
  `MPI_STATUSES_IGNORE` are Cray-pointer arrays whose pointers live in common
  blocks initialised from the C addresses in `src/mpif_constants.c`, so Fortran
  passes the genuine C sentinel through.
- `MPI_Wtime`, `MPI_Wtick`, `MPI_Aint_add` and `MPI_Aint_diff` are hand-written
  rather than generated, and are present. `MPI_Sizeof` is a hand-written generic
  in `src/mpi_types.F90`. `MPI_Status_f2f08` and `MPI_Status_f082f` are
  implemented and public in `src/mpi_f08_types.F90`.
- `ierror` is `OPTIONAL` throughout the f08 bindings.
