// The specific procedures behind mpif.h's MPI_SIZEOF and PMPI_SIZEOF generics.
//
// MPI_SIZEOF reports the size of its argument, which Fortran knows and C does
// not, so each specific is a constant: the compiler picks the one whose dummy
// argument matches, and the size is the answer. `x` is never read. The mpi module
// has its own set, as Fortran module procedures in src/mpif_types.F90; these
// serve mpif.h, whose interfaces are external.
//
// Each is defined under two names. MPI-5.0 section 15.2 asks for a P-prefixed
// second procedure for every MPI procedure, and mpif.h cannot reach these bodies
// through a second generic the way the mpi module can: an external procedure may
// appear in only one interface body per scope. So the PMPI_SIZEOF generic in
// include/mpif_functions.h names a second set of specifics, and this is where
// they come from. The `p` goes after the `mpif_` prefix, as in every
// mpif-invented PMPI name. Neither implementation provides a PMPI_SIZEOF at all
// -- `nm` finds no pmpi_sizeof in MPICH's libmpifort in any spelling -- but the
// standard makes no exception for it, and here the exception would cost more to
// argue than to close.

#include <mpi.h>

#define MPIF_DEFINE_SIZEOF(suffix, bytes)                                      \
  void mpif_sizeof_##suffix##_(const void *restrict const x,                   \
                               int *restrict const size,                       \
                               int *restrict const ierror) {                   \
    *size = bytes;                                                             \
    if (ierror)                                                                \
      *ierror = MPI_SUCCESS;                                                   \
  }                                                                            \
                                                                               \
  void mpif_psizeof_##suffix##_(const void *restrict const x,                  \
                                int *restrict const size,                      \
                                int *restrict const ierror) {                  \
    *size = bytes;                                                             \
    if (ierror)                                                                \
      *ierror = MPI_SUCCESS;                                                   \
  }

MPIF_DEFINE_SIZEOF(logical1, 1)
MPIF_DEFINE_SIZEOF(logical2, 2)
MPIF_DEFINE_SIZEOF(logical4, 4)
MPIF_DEFINE_SIZEOF(logical8, 8)
MPIF_DEFINE_SIZEOF(logical16, 16)

MPIF_DEFINE_SIZEOF(integer1, 1)
MPIF_DEFINE_SIZEOF(integer2, 2)
MPIF_DEFINE_SIZEOF(integer4, 4)
MPIF_DEFINE_SIZEOF(integer8, 8)
MPIF_DEFINE_SIZEOF(integer16, 16)

MPIF_DEFINE_SIZEOF(real2, 2)
MPIF_DEFINE_SIZEOF(real4, 4)
MPIF_DEFINE_SIZEOF(real8, 8)
MPIF_DEFINE_SIZEOF(real16, 16)

MPIF_DEFINE_SIZEOF(complex4, 4)
MPIF_DEFINE_SIZEOF(complex8, 8)
MPIF_DEFINE_SIZEOF(complex16, 16)
MPIF_DEFINE_SIZEOF(complex32, 32)
