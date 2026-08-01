#include <mpif_callbacks.h>

#include <mpi.h>
#include <stddef.h>
#include <stdio.h>

// The Fortran side of the predefined callbacks, from src/mpif_attr_fns.F90.
// Only their addresses are used; they are never called through these
// declarations, so the empty argument lists are harmless.
extern void mpi_null_copy_fn_(void);
extern void mpi_dup_fn_(void);
extern void mpi_null_delete_fn_(void);
extern void mpi_comm_null_copy_fn_(void);
extern void mpi_comm_dup_fn_(void);
extern void mpi_comm_null_delete_fn_(void);
extern void mpi_type_null_copy_fn_(void);
extern void mpi_type_dup_fn_(void);
extern void mpi_type_null_delete_fn_(void);
extern void mpi_win_null_copy_fn_(void);
extern void mpi_win_dup_fn_(void);
extern void mpi_win_null_delete_fn_(void);
extern void mpi_conversion_fn_null_(void);
extern void mpi_conversion_fn_null_c_(void);

struct predefined_callback {
  mpif_fortran_procedure fortran;
  void *abi;
};

// Casting a function pointer to void* is not strictly conforming C, but it is
// well defined on every platform mpif targets, and the ABI's own sentinels are
// function pointers holding the addresses 0x0 and 0x1.
static const struct predefined_callback predefined_callbacks[] = {
    // Deprecated in MPI-2.0, still used by MPI_Keyval_create
    {mpi_null_copy_fn_, (void *)MPI_NULL_COPY_FN},
    {mpi_dup_fn_, (void *)MPI_DUP_FN},
    {mpi_null_delete_fn_, (void *)MPI_NULL_DELETE_FN},

    {mpi_comm_null_copy_fn_, (void *)MPI_COMM_NULL_COPY_FN},
    {mpi_comm_dup_fn_, (void *)MPI_COMM_DUP_FN},
    {mpi_comm_null_delete_fn_, (void *)MPI_COMM_NULL_DELETE_FN},

    {mpi_type_null_copy_fn_, (void *)MPI_TYPE_NULL_COPY_FN},
    {mpi_type_dup_fn_, (void *)MPI_TYPE_DUP_FN},
    {mpi_type_null_delete_fn_, (void *)MPI_TYPE_NULL_DELETE_FN},

    {mpi_win_null_copy_fn_, (void *)MPI_WIN_NULL_COPY_FN},
    {mpi_win_dup_fn_, (void *)MPI_WIN_DUP_FN},
    {mpi_win_null_delete_fn_, (void *)MPI_WIN_NULL_DELETE_FN},

    {mpi_conversion_fn_null_, (void *)MPI_CONVERSION_FN_NULL},
    {mpi_conversion_fn_null_c_, (void *)MPI_CONVERSION_FN_NULL_C},
};

int mpif_predefined_callback(mpif_fortran_procedure callback, void **result) {
  const size_t count =
      sizeof predefined_callbacks / sizeof *predefined_callbacks;
  for (size_t i = 0; i < count; ++i) {
    if (predefined_callbacks[i].fortran == callback) {
      *result = predefined_callbacks[i].abi;
      return 1;
    }
  }
  return 0;
}

int mpif_unsupported_callback(const char *routine, const char *argument) {
  fprintf(stderr,
          "mpif: %s: a user-defined Fortran procedure was passed as %s, "
          "which mpif cannot forward to MPI yet; returning MPI_ERR_OTHER. "
          "Only the predefined callbacks such as MPI_COMM_NULL_COPY_FN work "
          "at the moment; see MISSING.md.\n",
          routine, argument);
  return MPI_ERR_OTHER;
}
