// Implement missing functions for MPICH 5.0.0b1

#include <mpi.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef __SIZEOF_INT128__
typedef __int128 int128_t;
#endif

MPI_Info mpif_fortran_info = MPI_INFO_NULL;

int MPI_Abi_set_fortran_info(MPI_Info info) {
  if (mpif_fortran_info != MPI_INFO_NULL)
    return MPI_ERR_ABI;
  if (info == MPI_INFO_NULL)
    return MPI_ERR_ABI;
  const int ierr = MPI_Info_dup(info, &mpif_fortran_info);
  if (ierr != MPI_SUCCESS)
    return ierr;
  return MPI_SUCCESS;
}

int MPI_Abi_get_fortran_info(MPI_Info *info) {
  if (mpif_fortran_info == MPI_INFO_NULL)
    return MPI_ERR_ABI;
  const int ierr = MPI_Info_dup(mpif_fortran_info, info);
  if (ierr != MPI_SUCCESS)
    return ierr;
  return MPI_SUCCESS;
}

__attribute__((__constructor__))
static void mpif_init(void) {
  if (mpif_fortran_info != MPI_INFO_NULL)
    abort();
  MPI_Info_create(&mpif_fortran_info);
  MPI_Info_set(mpif_fortran_info, "mpi_logical_size", "4");
  MPI_Info_set(mpif_fortran_info, "mpi_integer_size", "4");
  MPI_Info_set(mpif_fortran_info, "mpi_real_size", "4");
  MPI_Info_set(mpif_fortran_info, "mpi_double_precision_size", "8");
  MPI_Info_set(mpif_fortran_info, "mpi_logical1_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_logical2_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_logical4_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_logical8_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_logical16_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer1_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer2_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer4_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer8_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer16_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_real2_supported", "false");
  MPI_Info_set(mpif_fortran_info, "mpi_real4_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_real8_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_real16_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_complex4_supported", "false");
  MPI_Info_set(mpif_fortran_info, "mpi_complex8_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_complex16_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_complex32_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_double_complex_supported", "true");
}



const int8_t mpif_false1 = 0, mpif_true1 = 1;
const int16_t mpif_false2 = 0, mpif_true2 = 1;
const int32_t mpif_false4 = 0, mpif_true4 = 1;
const int64_t mpif_false8 = 0, mpif_true8 = 1;
const int128_t mpif_false16 = 0, mpif_true16 = 1;

int MPI_Abi_set_fortran_booleans(int logical_size, void *logical_true,
                                 void *logical_false) {
  // We know the values, they cannot be set by the application
  return MPI_ERR_ABI;
}

int MPI_Abi_get_fortran_booleans(int logical_size, void *logical_true,
                                 void *logical_false, int *is_set) {
  switch (logical_size) {
  case 1: {
    *(int8_t *)logical_true = mpif_true1;
    *(int8_t *)logical_false = mpif_false1;
    break;
  }
  case 2: {
    *(int16_t *)logical_true = mpif_true2;
    *(int16_t *)logical_false = mpif_false2;
    break;
  }
  case 4: {
    *(int32_t *)logical_true = mpif_true4;
    *(int32_t *)logical_false = mpif_false4;
    break;
  }
  case 8: {
    *(int64_t *)logical_true = mpif_true8;
    *(int64_t *)logical_false = mpif_false8;
    break;
  }
  case 16: {
    *(int128_t *)logical_true = mpif_true16;
    *(int128_t *)logical_false = mpif_false16;
    break;
  }
  default:
    return MPI_ERR_SIZE; // or MPI_ERR_ARG?
  }
  *is_set = 1;
  return MPI_SUCCESS;
}
