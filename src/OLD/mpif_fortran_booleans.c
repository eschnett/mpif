// Set Fortran booleans

#include <mpi.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef __SIZEOF_INT128__
typedef __int128 int128_t;
#endif

static const int8_t mpif_false1 = 0, mpif_true1 = 1;
static const int16_t mpif_false2 = 0, mpif_true2 = 1;
static const int32_t mpif_false4 = 0, mpif_true4 = 1;
static const int64_t mpif_false8 = 0, mpif_true8 = 1;
static const int128_t mpif_false16 = 0, mpif_true16 = 1;

__attribute__((__constructor__)) static void mpif_set_fortran_booleans(void) {
  int ierror;
  ierror = MPI_Abi_set_fortran_booleans(1, (void*)&mpif_true1, (void*)&mpif_false1);
  if (ierror)
    abort();
  ierror = MPI_Abi_set_fortran_booleans(2, (void*)&mpif_true2, (void*)&mpif_false2);
  if (ierror)
    abort();
  ierror = MPI_Abi_set_fortran_booleans(4, (void*)&mpif_true4, (void*)&mpif_false4);
  if (ierror)
    abort();
  ierror = MPI_Abi_set_fortran_booleans(8, (void*)&mpif_true8, (void*)&mpif_false8);
  if (ierror)
    abort();
  ierror = MPI_Abi_set_fortran_booleans(16, (void*)&mpif_true16, (void*)&mpif_false16);
  if (ierror)
    abort();
}
