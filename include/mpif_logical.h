#ifndef MPIF_LOGICAL_H
#define MPIF_LOGICAL_H

#include <mpi.h>

// Convert between C truth values and Fortran LOGICAL.
//
// Fortran's .TRUE. and .FALSE. are not necessarily 1 and 0: gfortran and flang
// use 1, Intel uses -1. The representation belongs to the Fortran compiler that
// built mpif, which publishes it in a common block; see src/mpif_logical.F90
// and src/mpif_logical.c.

#ifdef __cplusplus
extern "C" {
#endif

// Fortran LOGICAL for a C truth value
MPI_Fint mpif_bool2logical(int value);

// C truth value for a Fortran LOGICAL
int mpif_logical2bool(MPI_Fint value);

#ifdef __cplusplus
}
#endif

#endif // #ifndef MPIF_LOGICAL_H
