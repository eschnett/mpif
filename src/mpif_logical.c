#include <mpif_logical.h>

#include <mpi.h>

// The bit patterns of Fortran's .TRUE. and .FALSE., as used by the Fortran
// compiler that built mpif. They come from the common blocks that
// src/mpif_logical.F90 initialises, which is the only place that knows them:
// gfortran and flang use 1, Intel uses -1.
//
// Reading them from Fortran, rather than asking the MPI library with
// MPI_Abi_get_fortran_booleans, is deliberate. The library reports whatever
// Fortran layer published its values, which need not have been built with the
// same compiler as mpif -- and it reports nothing at all when the
// implementation has no Fortran bindings of its own.

extern const MPI_Fint mpif_logical_true_;
extern const MPI_Fint mpif_logical_false_;

MPI_Fint mpif_bool2logical(int value) {
  return value ? mpif_logical_true_ : mpif_logical_false_;
}

int mpif_logical2bool(MPI_Fint value) {
  // Anything that is not .FALSE. counts as true: Intel, for one, treats any odd
  // value as .TRUE. rather than only its canonical -1.
  return value != mpif_logical_false_;
}
