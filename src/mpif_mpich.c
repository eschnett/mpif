// Implement missing function from MPICH 4.3.2

#include <mpi.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef __SIZEOF_INT128__
typedef __int128 int128_t;
#endif

int MPI_Abi_get_version(int *abi_major, int *abi_minor) {
  *abi_major = MPI_ABI_VERSION;
  *abi_minor = MPI_ABI_SUBVERSION;
  return MPI_SUCCESS;
}

MPI_Info mpif_abi_info = MPI_INFO_NULL;

int MPI_Abi_get_info(MPI_Info *info) {
  if (mpif_abi_info == MPI_INFO_NULL)
    return MPI_ERR_ABI;
  const int ierr = MPI_Info_dup(mpif_abi_info, info);
  if (ierr != MPI_SUCCESS)
    return ierr;
  return MPI_SUCCESS;
}

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
