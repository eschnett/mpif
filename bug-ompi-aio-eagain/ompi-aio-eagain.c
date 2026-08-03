// MPICH's `f08/io/i_fcoll_test` fails under Open MPI on macOS with a flood of
//
//     mca_fbtl_posix_ipwritev: error in aio_write():  Resource temporarily unavailable
//     mca_fbtl_posix_ipreadv: error in aio_read(): errno 35 Resource temporarily unavailable
//
// after which the data read back is zero: the nonblocking collective write never
// reached the file, and MPI_Wait reported success anyway.
//
// This is the same thing in C, with no Fortran: the test's own access pattern,
// which is what matters -- a 32x32x32 array of integers distributed over the
// processes with MPI_Type_create_darray, so that each process's share of the file
// is many small pieces rather than one run. A contiguous view does not reproduce
// it; the noncontiguous one issues far more asynchronous requests than macOS
// allows outstanding, `sysctl kern.aioprocmax` being 16 here.
// ompi/mca/fbtl/posix/fbtl_posix_ipwritev.c reports the EAGAIN and gives up,
// rather than retrying or falling back to a synchronous write.
//
// Prints what it finds and exits 1 if the data does not survive the round trip.
// Run on 4 processes, as the test does.
//
//   mpicc -o ompi-aio-eagain ompi-aio-eagain.c && mpiexec -n 4 ./ompi-aio-eagain

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

enum { SIDE = 32 };  // a 32^3 array of integers, as in the test

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  int rank, nprocs;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &nprocs);

  const int gsizes[3] = {SIDE, SIDE, SIDE};
  const int distribs[3] = {MPI_DISTRIBUTE_BLOCK, MPI_DISTRIBUTE_BLOCK,
                           MPI_DISTRIBUTE_BLOCK};
  const int dargs[3] = {MPI_DISTRIBUTE_DFLT_DARG, MPI_DISTRIBUTE_DFLT_DARG,
                        MPI_DISTRIBUTE_DFLT_DARG};
  int psizes[3] = {0, 0, 0};
  MPI_Dims_create(nprocs, 3, psizes);

  MPI_Datatype filetype;
  MPI_Type_create_darray(nprocs, rank, 3, gsizes, distribs, dargs, psizes,
                         MPI_ORDER_FORTRAN, MPI_INT, &filetype);
  MPI_Type_commit(&filetype);

  int intsize, typesize;
  MPI_Type_size(MPI_INT, &intsize);
  MPI_Type_size(filetype, &typesize);
  const int count = typesize / intsize;  // integers this process holds

  int *out = malloc((size_t)count * sizeof *out);
  int *in = malloc((size_t)count * sizeof *in);
  for (int i = 0; i < count; ++i) {
    out[i] = rank * count + i + 1;
    in[i] = 0;
  }

  const char *path = "ompi-aio-eagain.dat";
  MPI_File fh;
  MPI_Request req;

  MPI_File_open(MPI_COMM_WORLD, path, MPI_MODE_CREATE | MPI_MODE_RDWR,
                MPI_INFO_NULL, &fh);
  MPI_File_set_view(fh, 0, MPI_INT, filetype, "native", MPI_INFO_NULL);
  MPI_File_iwrite_all(fh, out, count, MPI_INT, &req);
  MPI_Wait(&req, MPI_STATUS_IGNORE);
  MPI_File_close(&fh);

  MPI_File_open(MPI_COMM_WORLD, path, MPI_MODE_RDONLY, MPI_INFO_NULL, &fh);
  MPI_File_set_view(fh, 0, MPI_INT, filetype, "native", MPI_INFO_NULL);
  MPI_File_iread_all(fh, in, count, MPI_INT, &req);
  MPI_Wait(&req, MPI_STATUS_IGNORE);
  MPI_File_close(&fh);

  int errs = 0;
  for (int i = 0; i < count; ++i)
    if (in[i] != out[i])
      ++errs;
  printf("rank %d: %d of %d integers wrong%s\n", rank, errs, count,
         errs ? " -- the nonblocking collective write was lost" : "");

  int total = 0;
  MPI_Reduce(&errs, &total, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
  if (rank == 0) {
    if (total == 0)
      printf("No Errors\n");
    MPI_File_delete(path, MPI_INFO_NULL);
  }

  MPI_Type_free(&filetype);
  free(out);
  free(in);
  MPI_Finalize();
  return total != 0;
}
