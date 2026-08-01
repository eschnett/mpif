# Missing features and known errors

A review of `dev/mpiapi.jl`, the generator that produces `gen/mpif_functions.c`,
`gen/mpif_functions.F90` and `gen/mpif_f08_functions.F90` from the MPI standard's
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

### 1. Callbacks: all but `MPI_Register_datarep` now work

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

**Generalized request callbacks** work too, and cost no pool at all. `query_fn`,
`free_fn` and `cancel_fn` are told only `extra_state`, so there is again nothing
to look up when one fires -- but `extra_state` is mpif's to choose, so it hands
MPI a box holding the three Fortran procedures and one trampoline apiece is
enough. There is therefore no limit on how many generalized requests a program
may have. The box belongs to one request and the free trampoline releases it,
which is safe because "free_fn will be invoked only once per request by a correct
program" and "the request is not deallocated until after free_fn completes".

Two details differ from the other families. The box holds the *address* of the
caller's `extra_state` rather than a copy of its value, so that the callbacks
alias it: MPI-5.0 declares `extra_state` with no INTENT in all three grequest
interfaces, unlike the attribute callbacks where it is INTENT(IN) and a copy is
right, and MPICH's `greqf` requires a `free_fn` that decrements it to be visible
to the caller afterwards. And `status` passes through untouched, the C
`MPI_Status` being three `int`s followed by five more and `MPI_STATUS_SIZE` being
8, so one address serves `INTEGER STATUS(MPI_STATUS_SIZE)` and the `bind(C)`
`TYPE(MPI_Status)` alike.

The f08 abstract interfaces for these three had picked up intents the standard
does not give them, `INTENT(IN) :: extra_state` in particular. That made a
conforming callback fail to compile -- "INTENT mismatch in argument
'extra_state'" -- whenever it was a module procedure rather than an external one,
so the intents are now omitted, matching the standard exactly.

Still reporting `MPI_ERR_OTHER`:

- `MPI_Register_datarep`, whose conversion and extent callbacks also pass
  `extra_state` and can take the same treatment as the generalized requests
  above. Datareps are never deregistered, so a box would live for the duration
  rather than being freed. `MPI_CONVERSION_FN_NULL` already works, being
  predefined.

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
and the `mpi` module, and are re-exported by `src/mpif_f08_constants.F90` for
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
`src/mpif_f08_types.F90`, where `extra_state` was already address-sized but
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

### 9. An array of statuses is declared as a single status

Six routines take one: `MPI_Waitall`, `MPI_Waitsome`, `MPI_Testall`,
`MPI_Testsome`, `MPI_Request_get_status_all` and `MPI_Request_get_status_some`.
`apis.json` gives their `array_of_statuses` the `STATUS` kind with `length` `"*"`,
but the generator's `STATUS` branch ignores `length` and emits a scalar for both
Fortran interfaces:

    push!(f_declarations, "integer :: $parname(MPI_STATUS_SIZE)")
    push!(f08_declarations, "type(MPI_Status), intent($param_direction) :: $parname")

They should be `integer :: $parname(MPI_STATUS_SIZE, *)` and
`type(MPI_Status), intent(out) :: $parname(*)`.

In `mpi_f08` this makes the six routines unusable: passing the array the standard
calls for is a compile error, `Rank mismatch in argument 'array_of_statuses'
(scalar and rank-1)`. In `mpif.h` and the `mpi` module the wrong declaration is
survivable -- Fortran sequence association lets a larger actual argument through,
and a four-request `MPI_Waitall` over receive requests returns all four statuses
correctly -- but the interface still describes the wrong thing.

Two consequences behind that one:

- The f08 wrapper sizes its temporary for one status,
  `integer :: tmp_array_of_statuses(MPI_STATUS_SIZE)`, and converts one, while
  the C wrapper hands MPI the caller's buffer cast to `MPI_Status*` and MPI
  writes `count` of them. Fixing the declaration alone would leave the f08 path
  overrunning that temporary.
- `MPI_STATUSES_IGNORE` is never detected. It does not appear anywhere in
  `gen/mpif_f08_functions.F90`; the generated guards all compare against
  `MPI_STATUS_IGNORE`. Since the two sentinels are different addresses, passing
  `MPI_STATUSES_IGNORE` fails the comparison and the wrapper converts into it --
  and it points at the C constant, which is a null pointer.

### 10. Info keys and values were mishandled in several ways — fixed

Four separate defects in the info getters, all found by `f77/info`, `f90/info`
and `f08/info` in MPICH's suite, plus one shared with `MPI_Comm_spawn`:

- `MPI_Info_get_string`'s `buflen` was passed straight through, but Fortran
  counts characters and C counts characters plus the terminating NUL, so the
  value came back truncated by one and the returned length was one too large.
- The same argument was used to size the C buffer without being clamped to the
  caller's `CHARACTER`, so a `buflen` larger than `len(value)` -- which MPICH's
  own `infogetstrf90` passes -- had MPI writing past the end of a stack array.
- `MPI_Info_get` and `MPI_Info_get_string` copied their internal buffer out even
  when the key did not exist, or when `buflen` was zero. MPI writes nothing in
  those cases, so this handed back an uninitialised buffer and ran `strlen` over
  it. The standard is explicit for `MPI_INFO_GET`: "otherwise it sets flag to
  false and leaves value unchanged".
- Leading blanks were not stripped from info keys and values. MPI-5.0 section 10
  requires it -- "In Fortran, leading and trailing spaces are stripped from both"
  -- so ` See Below` was stored with its space and a later lookup of `See Below`
  missed.

Fixed. The leading-blank stripping is deliberately per argument rather than a
change to `mpif_strdup_f2c`: the standard asks for it only for info keys and
values and for `MPI_COMM_SPAWN`'s `command` and `argv` (which
`MPI_COMM_SPAWN_MULTIPLE` inherits by being "identical to MPI_COMM_SPAWN except
that there are multiple executable specifications"), while
`MPI_ADD_ERROR_STRING` is specified to strip trailing blanks only and the
standard says nothing at all about port names, service names, file names or
datareps. `dev/mpiapi.jl` carries the list as `strip_leading_blanks` and selects
`mpif_strdup_f2c_trim`; note that MPICH's own binding strips both ends of every
string, which is more than the standard requires.

### 11. The spawn argument vectors were unusable — fixed

`MPI_ARGV_NULL` and `MPI_ARGVS_NULL` were declared `integer` in
`include/mpif_constants.h`. They stand in for `argv` and `array_of_argv`, which
are `CHARACTER` in Fortran, so passing them did not compile at all --
`Type mismatch in argument 'argv'; passed INTEGER(4) to CHARACTER(*)`, which is
what killed `f77/spawn/spawnf` and `spawnmult2f` and their f90 and f08
counterparts. They are now `character*1 MPI_ARGV_NULL(1)` and
`character*1 MPI_ARGVS_NULL(1,1)`, the shapes MPI-5.0's rationale permits.

Correcting the type alone would have traded a compile error for a crash. The
Cray pointer puts these arrays at the address of the C constants, which are
`(char**)0`, and unlike `MPI_ERRCODES_IGNORE` -- forwarded to C untouched -- an
argument vector has to be converted element by element, so the conversion read
address zero. The wrappers now recognise them by address and pass the C constant
through. The comparison is against the constant rather than against `NULL`, since
the standard only says `MPI_ARGVS_NULL` is "likely to be `(char ***)0`".

Separately, `MPI_Comm_spawn_multiple`'s `array_of_commands` was scanned for a
blank-terminated entry, as `argv` correctly is. It has no terminator: `count`
gives the "number of commands", so the scan ran off the end of the caller's array
and `mpif_fcount` faulted. It now takes the count from `count`.

### 12. `MPI_STATUS_IGNORE` was `INTEGER` in `mpi_f08` — fixed

`mpif_f08_constants.F90` re-exported the `INTEGER` arrays that `mpif.h` and the
`mpi` module declare, so the sentinel could not be passed to a
`TYPE(MPI_Status)` dummy argument and every f08 spawn test failed to compile.

The two interfaces need different declarations of one name, so `mpi_f08` can no
longer re-export: `MPI_STATUS_IGNORE` and `MPI_STATUSES_IGNORE` are now declared
in `src/mpif_f08_types.F90`, where `MPI_Status` exists, with the same Cray pointer
into the same common block. All three interfaces still name one address. The
generated wrappers already compared `loc(status)` against the sentinel, so
nothing else changed -- but see error 9 for `MPI_STATUSES_IGNORE`, which is still
not detected anywhere.

### 13. Attribute values were converted when MPI had not set one — fixed

`mpi_attr_get_`, `mpi_comm_get_attr_`, `mpi_type_get_attr_` and
`mpi_win_get_attr_` called `mpif_attr_value` unconditionally. MPI writes
`attribute_val` only when there is an attribute to report, so on a false flag the
`void *` was still whatever the stack held -- and for the predefined keyvals the
conversion dereferences it, `MPI_UNIVERSE_SIZE` and friends being a pointer to an
`int` in C but a value in Fortran. That is a wild read; it crashed MPICH's f08
spawn tests, whose `MTestSpawnPossible` asks `MPI_COMM_WORLD` for
`MPI_UNIVERSE_SIZE` without knowing whether it is set.

Fixed: zero on a false flag or an error, which is what MPICH's own Fortran
binding does. Note that a user-defined keyval does not show the bug -- MPI nulls
the pointer there and `mpif_attr_value` already guarded against that -- so
`test/comm_get_attr_f08.f90` uses `MPI_APPNUM`. Not `MPI_UNIVERSE_SIZE`: asking
for that makes MPICH talk to the process manager, and `test/` runs its
executables directly with no launcher.

### 14. `MPI_Sizeof` was unusable — fixed

`src/mpif_types.F90` defines the generic by hand, and every specific is wrong in
the same three ways. Taking `mpif_sizeof_real4` as the example:

    subroutine mpif_sizeof_real4(x, size, ierror)
      real*4                      :: x(*)
      real, intent(out)           :: size
      real, intent(out), optional :: ierror

- `size` and `ierror` are `real`. The standard's binding is `INTEGER SIZE,
  IERROR`, and `size = 4` is assigning an integer count to a real.
- `x` is `x(*)`, rank one, so a scalar argument matches nothing in the generic.
  `MPI_SIZEOF` is meant to take an argument of any type *and any rank*.
- There is no `CHARACTER` specific at all; the generic covers only `LOGICAL`,
  `INTEGER`, `REAL` and `COMPLEX` kinds.

`f90/datatype/sizeof` and `sizeof2` declare `real r1,r1v(2)` ... `character
ch1,ch1v(6)` and call `MPI_Sizeof` on each, so they fail to compile with 15
instances of "There is no specific subroutine for the generic 'mpi_sizeof'".

`MPI_Sizeof` is deprecated in MPI-4.0 and its `mpi_f08` form was removed, but the
`mpi` module and `mpif.h` still have it.

Fixed: `size` and `ierror` are `INTEGER` in every specific, there is a scalar
specific alongside each assumed-size one, and `CHARACTER` is covered. `sizeof`
and both copies of `sizeof2` now report no errors.

Still not covered is an argument of rank two or more, which resolves to nothing.
A Fortran generic needs a specific per type, kind *and* rank, so full coverage
would mean sixteen ranks apiece; MPICH's own binding generates exactly the same
two forms per type and stops in the same place. Assumed-rank would collapse them
into one specific each, at the cost of requiring Fortran 2018 -- the same
trade-off recorded under "Assumed-rank choice buffers" below, and worth taking
in one go rather than for this deprecated routine alone.

### 15. RMA displacements were declared as default `INTEGER` — fixed

`RMA_DISPLACEMENT_NNI` sits in the generator's `int_kinds`, so `MPI_Put`,
`MPI_Get`, `MPI_Accumulate` and the rest emit

    integer :: target_disp

where the standard's binding is `INTEGER(KIND=MPI_ADDRESS_KIND) TARGET_DISP`.
This is error 6 again, for a different kind: address-sized in C, four bytes in
Fortran. It shows up as eleven instances of "Type mismatch in argument
'target_disp'; passed INTEGER(8) to INTEGER(4)" across the `f90` window tests,
which is the benign direction -- the compiler rejects it rather than truncating
silently -- but a caller that follows the mpif interface and declares a plain
`INTEGER` would pass four bytes where C reads eight.

Fixed: `RMA_DISPLACEMENT_NNI` moved to `aint_kinds`, as `ATTRIBUTE_VAL` and
`EXTRA_STATE` did, so all three interfaces now say `MPI_Aint` and
`INTEGER(KIND=MPI_ADDRESS_KIND)`. It does not embiggen -- the large-count forms
take an `MPI_Aint` too -- so one list entry covers both. Not to be confused with
`POLYRMA_DISPLACEMENT`, the `disp_unit` of `MPI_Win_create`, which really is a
plain `INTEGER` in the small form and stays in `int_aint_kinds`.

### 16. The `TYPE(C_PTR)` forms of the memory-allocating routines were missing — fixed

Four routines hand back a base address, and the standard makes each a generic in
the `mpi` module and `mpif.h` with two specifics -- one taking
`INTEGER(KIND=MPI_ADDRESS_KIND) BASEPTR`, one taking `TYPE(C_PTR) BASEPTR`:

    SUBROUTINE MPI_ALLOC_MEM(SIZE, INFO, BASEPTR, IERROR)
        INTEGER(KIND=MPI_ADDRESS_KIND) :: SIZE, BASEPTR
    SUBROUTINE MPI_ALLOC_MEM_CPTR(SIZE, INFO, BASEPTR, IERROR)
        TYPE(C_PTR) :: BASEPTR

and likewise `MPI_WIN_ALLOCATE_CPTR`, `MPI_WIN_ALLOCATE_SHARED_CPTR` and
`MPI_WIN_SHARED_QUERY_CPTR`. mpif generates only the address-kind form, so
`f90/misc/alloc_mem` does not compile: "Type mismatch in argument 'baseptr';
passed TYPE(C_PTR) to INTEGER(8)".

The `_CPTR` names are the standard's way of writing an overload in an interface
block and are not separate entry points, so this is a Fortran-side addition
only -- the C side is already a `void*` either way.

mpi_f08 had the opposite half of the same bug: there the standard has *only* the
`TYPE(C_PTR)` form, and mpif emitted the address-kind one.

Fixed. The f08 declaration is generated, `baseptr` becoming `TYPE(C_PTR)` with a
`transfer` from the address-sized integer the C wrapper writes. The mpi module's
overload is hand-written in `src/mpif_cptr.F90`, which calls the generated
address-kind interface under a renamed alias, with the generics gathered in
`src/mpi.F90`. The large-count variants are covered too; mpif spells those as
separate names rather than further overloads, so each has its own generic.

Where the generics live is forced, and was worth establishing by experiment:

- A generic declared inside `mpif_cptr` *shadows* the use-associated specific
  rather than extending it, so the address-kind form stops resolving.
- A specific from one module and a same-named generic from another are an
  ambiguous reference at the point of use.
- A generic naming one of its own specifics, in a scope where both are visible,
  works -- and is what the standard's own interface block for `MPI_ALLOC_MEM`
  writes. Hence `interface MPI_Alloc_mem; procedure MPI_Alloc_mem; procedure
  MPI_Alloc_mem_cptr; end interface` in `src/mpi.F90`.

`mpif.h` needed nothing: its interfaces are implicit, so a `TYPE(C_PTR)` actual
argument already reached the same C wrapper unchecked.

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

`test/predefined_types_c.c` is the probe that found it. The three pair types are
behind `MPIF_PROBE_PAIRTYPES=1` there, off by default: the failure is a SIGSEGV
inside `MPI_Type_get_name`, so unlike every other result the probe collects it
cannot be caught and reported -- it takes the whole probe down, and with it the
rest of the answers. Set the variable to check whether the upstream fix has
landed.

### OpenMPI: an empty info value is rejected

https://github.com/open-mpi/ompi/issues/14246

`MPI_Info_set(info, "key", "")` returns `MPI_ERR_INFO_VALUE` (33) under OpenMPI
and `MPI_SUCCESS` under MPICH. The ABI defines that class as "Value longer than
MPI_MAX_INFO_VAL", and the standard uses empty info values meaningfully elsewhere
-- a memory allocation kinds value "corresponding to the empty string represents
no memory allocation kinds" -- so an empty value looks legitimate and OpenMPI's
refusal looks wrong.

Worse, the standard gives the empty value a defined meaning on two reserved keys.
For both `"mpi_memory_alloc_kinds"` and `"mpi_assert_memory_alloc_kinds"`: "A
value corresponding to the empty string represents no memory allocation kinds."
Under Open MPI there is no way to say that through an info object.

The cause is a zero-length test sitting alongside the NULL and over-long ones in
`ompi/mpi/c/info_set.c.in`:

    value_length = (value) ? (int)strlen (value) : 0;
    if ((NULL == value) || (0 == value_length) ||
        (@MPI_MAX_INFO_VAL@ <= value_length)) {

Open MPI's own doc comment on that function states only the length rule. The
zero-length *key* check just above is a separate question -- MPICH rejects an
empty key too -- and is not part of this.

It reaches Fortran through the blank stripping of error 10: a value of nothing
but spaces becomes the empty string, which is exactly what `MPI_COMM_SPAWN`'s
`argv` requires of the same helper. Not reported upstream yet, and not worked
around; `test/info_blanks_f08.f90` avoids asserting on it so that mpif's own
tests do not fail on the implementations' disagreement.

The reproducer to send with the report is
`bug-ompi-info-value/ompi-empty-info-value.c`; it is pure C, with no Fortran
involved, and exits 0 on MPICH and 1 on Open MPI.

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

### OpenMPI on macOS: spawned intercommunicators hang

Not an mpif problem either, and not really a blocker so much as a trap. Open MPI
picks a non-loopback interface and then cannot configure the socket --
`setsockopt(TCP_NODELAY) failed: Invalid argument (22)`, followed by its own
warning that this "may end up hanging". It does, in any test that communicates
across a spawned intercommunicator, and each one then burns runtests' 180-second
timeout rather than failing, so the suite looks stuck rather than broken. A pure
C spawn-and-send reproduces it.

`scripts/macos-test-mpich-suite.sh` and the CI step both pass
`--mca btl_tcp_if_include lo0` for Open MPI to avoid it; the CI one is guarded on
`RUNNER_OS`, Linux needing neither the flag nor the same interface name.

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

### The PMPI profiling interface

There is none. `nm` on the built library finds no `pmpi_` symbol at all, for any
of the 585 entry points, and the generator emits none.

`include/mpif_functions.h` is worse than silent about it: it declares four PMPI
names it does not define,

    double precision, external :: MPI_Wtick, PMPI_Wtick
    double precision, external :: MPI_Wtime, PMPI_Wtime
    integer(MPI_ADDRESS_KIND), external :: MPI_Aint_add, PMPI_Aint_add
    ... PMPI_Aint_diff

so an `mpif.h` program that calls one gets a link error rather than a diagnostic:
`Undefined symbols: "_pmpi_wtime_"`. The `mpi` and `mpi_f08` modules do not
declare them at all, which is what `f08/timer/wtimef90` hits --
`Function 'pmpi_wtick' has no IMPLICIT type`.

Because mpif prunes the implementation's own Fortran library, its `pmpi_*`
symbols are not available as a fallback either. Generating the PMPI names
alongside the MPI ones should be mechanical: each would be the same wrapper under
a second symbol, calling the same C entry point.

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
  `MPI_Comm_copy_attr_function`, ...) in `src/mpif_f08_types.F90`, all 18 of
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

## Namespace

Only what the MPI standard defines may be spelled `MPI_` or `mpi_`; everything
mpif invents is `mpif_` or `MPIF_`. Two modules are the standard's and keep their
names, `mpi` and `mpi_f08`; the seven mpif provides beneath them are
`mpif_constants`, `mpif_types`, `mpif_functions`, `mpif_cptr`,
`mpif_f08_constants`, `mpif_f08_types` and `mpif_f08_functions`. Their `.mod`
files follow, which also removes a real collision: MPICH installs an
`mpi_constants.mod` and Open MPI an `mpi_types.mod` and `mpi_f08_types.mod` of
their own, and mpif used to ship files of exactly those names.

The Fortran entry points that C provides -- `mpi_send_`, `mpi_alloc_mem_`, ... --
are of course named after the MPI routines they implement; that is what makes
them callable. Everything else on the C side is `mpif_`.

Two judgement calls worth recording:

- `MPI_Alloc_mem_cptr`, `MPI_Win_allocate_cptr`, `MPI_Win_allocate_shared_cptr`
  and `MPI_Win_shared_query_cptr` keep `MPI_`, because the standard names them:
  "The base procedure name of this overloaded function is MPI_ALLOC_MEM_CPTR."
- Their large-count counterparts do not exist in the standard -- section 19.1.5's
  rules for implied specific names cover the `_f08` and `_f` schemes, not a
  `_c_cptr` combination -- so those are `mpif_win_allocate_c_cptr` and friends.

The procedures behind `operator(==)` and `operator(/=)` on the handle types were
`MPI_Comm_equal` and so on, which the standard does not define; they are now
`mpif_comm_equal` and friends. They were already private to `mpif_f08_types`.

## Verified as correct

Recorded so that they do not get re-investigated:

- **Nothing is silently dropped.** Replaying the generator's filters over
  `apis.json` gives 430 kept functions, 589 including `_c` variants, and
  `gen/mpif_f08_functions.F90` contains exactly those 589. Every omission is
  attributable to a filter.
- The 102 functions skipped as `not f90_expressible` are the C-only handle
  converters (`MPI_Comm_c2f`, `MPI_Comm_fromint`, ...) and the whole `MPI_T`
  interface, which the standard defines for C only.
- **Buffer sentinels reach C intact.** `MPI_BOTTOM`, `MPI_IN_PLACE`,
  `MPI_ARGV_NULL`, `MPI_ARGVS_NULL`, `MPI_ERRCODES_IGNORE`, `MPI_STATUS_IGNORE`
  and `MPI_STATUSES_IGNORE` are Cray-pointer arrays whose pointers live in common
  blocks initialised from the C addresses in `src/mpif_constants.c`, so Fortran
  passes the genuine C sentinel through. Verified for the argv pair by handing
  them to a C probe with the wrappers' calling convention: both arrive as
  `base=0x0`.

  The addressing being right is only half of it, though, and this entry used to
  claim more than it should have. A sentinel also has to have a type the caller
  can pass (error 11), and any wrapper that does not simply forward it has to
  recognise it rather than dereference it -- which is still not done for
  `MPI_STATUSES_IGNORE` (error 9).
- `MPI_Wtime`, `MPI_Wtick`, `MPI_Aint_add` and `MPI_Aint_diff` are hand-written
  rather than generated, and are present. `MPI_Sizeof` is a hand-written generic
  in `src/mpif_types.F90`. `MPI_Status_f2f08` and `MPI_Status_f082f` are
  implemented and public in `src/mpif_f08_types.F90`.
- `ierror` is `OPTIONAL` throughout the f08 bindings.
