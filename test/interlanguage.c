#include <mpi.h>
#include <stdio.h>

void subf90_(const MPI_Fint *fcomm, const int *rank, const int *size);

int main(int argc, char** argv) {
  MPI_Init(&argc, &argv);
  MPI_Comm comm;
  MPI_Comm_dup(MPI_COMM_WORLD, &comm);
  int rank, size;
  MPI_Comm_rank(comm, &rank);
  MPI_Comm_size(comm, &size);
  printf("Interlanguage C: %d/%d\n", rank, size);
  MPI_Fint fcomm = MPI_Comm_c2f(comm);
  subf90_(&fcomm, &rank, &size);
  MPI_Comm_free(&comm);
  MPI_Finalize();
  return 0;
}
