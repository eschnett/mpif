#include <mpif_strings.h>
#include <mpi.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef MPI_Datarep_extent_function MPI_Datarep_extent_function_c;

void mpi_init_(
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Init(
    NULL,
    NULL
  );
}
