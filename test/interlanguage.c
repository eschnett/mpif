#include <mpi.h>

#include <stdio.h>
#include <stdlib.h>

void subf90_(const MPI_Fint *fcomm, const int *rank, const int *size, int *fstatus);

int main(int argc, char** argv) {
  MPI_Init(&argc, &argv);

  MPI_Comm comm;
  MPI_Comm_dup(MPI_COMM_WORLD, &comm);

  int rank, size;
  MPI_Comm_rank(comm, &rank);
  MPI_Comm_size(comm, &size);
  printf("Interlanguage C: %d/%d\n", rank, size);

  MPI_Status status;
  int sendbuf, recvbuf;
  sendbuf = rank;
  recvbuf = -1;
  MPI_Sendrecv(&sendbuf, 1, MPI_INT, (rank + 1) % size, 0, &recvbuf, 1, MPI_INT, (rank + size - 1) % size, 0,
               comm, MPI_STATUS_IGNORE);
  if (recvbuf != (rank + size - 1) % size)
    abort();

  sendbuf = rank;
  recvbuf = -1;
  MPI_Sendrecv(&sendbuf, 1, MPI_INT, (rank + 1) % size, 0, &recvbuf, 1, MPI_INT, (rank + size - 1) % size, 0,
               comm, &status);
  if (status.MPI_SOURCE != (rank + size - 1) % size || status.MPI_TAG != 0)
    abort();
  if (recvbuf != (rank + size - 1) % size)
    abort();

  MPI_Fint fcomm = MPI_Comm_c2f(comm);
  MPI_Fint fstatus[MPI_F_STATUS_SIZE];
  subf90_(&fcomm, &rank, &size, fstatus);
  MPI_Status_f2c(fstatus, &status);
  if (status.MPI_SOURCE != fstatus[MPI_F_SOURCE] || status.MPI_TAG != fstatus[MPI_F_TAG])
    abort();

  MPI_Comm_free(&comm);

  MPI_Finalize();

  return 0;
}
