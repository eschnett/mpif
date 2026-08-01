# Missing features and known errors

A review of `dev/mpiapi.jl`, the generator that produces `gen/mpif_functions.c`,
`gen/mpi_functions.F90` and `gen/mpi_f08_functions.F90` from the MPI standard's
`apis.json`.

Findings were checked against `data/apis.json`, the generated output, and the
official ABI header, rather than by reading the generator alone. Line numbers
refer to the state of the code when the review was written.

## Errors

### 1. Every binding that takes a callback aborts at runtime

`dev/mpiapi.jl` emits `abort();` as the C-side conversion for `FUNCTION` and
`POLYFUNCTION` parameters. Thirteen generated wrappers contain it:

    mpi_op_create_               mpi_op_create_c_           mpi_comm_create_keyval_
    mpi_type_create_keyval_      mpi_win_create_keyval_     mpi_keyval_create_
    mpi_grequest_start_          mpi_register_datarep_      mpi_register_datarep_c_
    mpi_comm_create_errhandler_  mpi_file_create_errhandler_
    mpi_win_create_errhandler_   mpi_session_create_errhandler_

User-defined reductions, attribute keyvals, generalized requests, datareps and
custom error handlers therefore compile and link, and then kill the process.

Removing the `abort()` is not enough. The generator passes the Fortran procedure
straight through to the C call, but MPI invokes callbacks with C ABI handles,
while a Fortran callback expects `INTEGER` handles (`mpif.h`, `use mpi`) or
`TYPE(MPI_Comm)` and friends (`use mpi_f08`). Each callback type needs a C
trampoline plus a registry to recover the user's procedure, and `extra_state`
has to be marshalled as `INTEGER(KIND=MPI_ADDRESS_KIND)`.

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

### 4. The 13 predefined attribute callbacks are declared but never defined

`include/mpif_functions.h` declares `external :: MPI_COMM_NULL_COPY_FN`,
`MPI_COMM_DUP_FN`, `MPI_CONVERSION_FN_NULL` and the rest, but the generator
skips every entry with a `predefined_function` attribute and nothing implements
them: there is no Fortran symbol, and they are absent from the `mpi` and
`mpi_f08` modules. `mpif.h` users get a link error, module users cannot name
them at all. Because mpif prunes the implementation's Fortran library, the
implementation's own symbols are not available as a fallback either.

### 5. `MPI_SUBARRAYS_SUPPORTED` and `MPI_ASYNC_PROTECTS_NONBLOCKING` are undefined

Both are required constants in all three interfaces. Neither appears anywhere.
Given the buffer handling described below, both should currently be `.FALSE.`.

### 6. `loc()` is used to detect `MPI_STATUS_IGNORE`

77 occurrences in the f08 layer. `loc()` is a widely implemented extension but
not standard Fortran, and comparing addresses silently fails if the argument
arrives as a copy.

## Missing features

### Standard-conforming choice buffers

The f08 bindings declare choice buffers as `integer :: buf(*)` guarded by
`!dir$ ignore_tkr` and `!gcc$ attributes no_arg_check`. There is not one
`TYPE(*), DIMENSION(..)` and not one `ASYNCHRONOUS` in the generated code; both
are what the MPI-3 and later f08 bindings are defined in terms of.

The practical consequence is that non-contiguous actual arguments are handled by
the compiler making a temporary. That is harmless for blocking calls and wrong
for nonblocking ones, where the temporary dies before the request completes.
`MPI_SUBARRAYS_SUPPORTED` exists precisely to tell users this; see error 5.

### `bind(C)`

Nothing is declared `bind(C)`. All 585 entry points rely on the compiler
lowercasing names and appending a single underscore, and on hidden character
lengths being appended at the end of the argument list as `size_t`. That is
correct for gfortran 8 and later and for flang, and an unstated assumption
otherwise -- gfortran before 8 passed hidden lengths as `int`.

### Publishing the Fortran type information to the MPI library

mpif exposes `MPI_Abi_set_fortran_info` and `MPI_Abi_set_fortran_booleans` as
bindings but never calls them. The booleans are now known in C, from
`src/mpif_logical.F90`, so publishing them is a few lines; the type sizes would
need the same treatment. An implementation built without its own Fortran
bindings leaves `MPI_INTEGER` and friends as `MPI_DATATYPE_NULL` internally
(see `MPIR_Abi_set_fortran_info_impl` in MPICH), which is why MPICH currently
has to be built with `--enable-fortran` even though all of its Fortran output is
then pruned away. If mpif published its own sizes at initialisation, the
implementation could be built with `--enable-fortran=no`, which would also
sidestep the flang/libtool problems on macOS entirely.

### Generated callback interfaces

The f08 abstract interfaces (`MPI_User_function`, `MPI_Comm_copy_attr_function`,
...) are hand-maintained in `src/mpi_f08_types.F90`, although `apis.json`
describes all 18. They can drift from the standard.

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
