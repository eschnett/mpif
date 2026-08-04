// The same defect as `ompi-aio-eagain.c`, on one process and instrumented, so
// that what survives can be counted rather than just called wrong. Four
// measurements, in order, all through MPI_File_iwrite_all on a file view of 512
// blocks of 16 integers at stride 32 -- the fragmentation is the whole point,
// and a vector type makes it in one line where the test's darray needs four
// processes:
//
//   (a) a contiguous nonblocking collective write, as a control: it succeeds and
//       MPI_Get_count reports every element.
//   (b) the fragmented one: Open MPI prints
//           mca_fbtl_posix_ipwritev: error in aio_write(): Resource temporarily
//           unavailable
//       MPI_File_iwrite_all returns MPI_SUCCESS, MPI_Wait returns MPI_SUCCESS,
//       and MPI_Get_count reports 0 -- the count is the only thing in the
//       interface that admits anything happened. Exactly `kern.aioprocmax`
//       blocks reach the file, 16 here, out of 512; the file is left short.
//   (c) and (d) contiguous again, single-request, identical to (a): they now
//       fail too. The failing call in (b) free()s the aiocbs of the 16 requests
//       it did queue without ever calling aio_return on them, so those 16 slots
//       -- every slot the process has -- are gone for good. One EAGAIN
//       permanently disables nonblocking file I/O for the process, which is why
//       `f08/io/i_fcoll_test` reads back nothing at all rather than the 16
//       blocks the write left behind.
//
// `posix-aio-limit.c` measures the 16 and the aio_return behaviour with no MPI
// in the way. MISSING.md, "a nonblocking collective write is lost when the aio
// queue fills", has the reading of Open MPI's source that ties them together.
//
// Prints what it finds and exits 1 unless (a) succeeds and (b) does not.
//
//   mpicc -o ompi-aio-eagain-probe ompi-aio-eagain-probe.c
//   mpiexec -n 1 ./ompi-aio-eagain-probe

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

enum { NBLK = 512, BLK = 16 };  // 512 blocks of 16 ints, stride 2*BLK

static const char *path = "ompi-aio-eagain-probe.dat";

// One nonblocking collective write of `count` integers, reporting the count the
// completed request claims to have transferred.
static int write_all(MPI_File fh, const int *buf, int count, const char *label) {
  MPI_Request req;
  MPI_Status status;
  int transferred = -1;

  MPI_File_iwrite_all(fh, buf, count, MPI_INT, &req);
  MPI_Wait(&req, &status);
  MPI_Get_count(&status, MPI_INT, &transferred);

  printf("  %-28s MPI_Get_count = %5d of %5d%s\n", label, transferred, count,
         transferred == count ? "" : "   <-- lost");
  return transferred == count;
}

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  const int count = NBLK * BLK;
  int *buf = malloc((size_t)count * sizeof *buf);
  for (int i = 0; i < count; ++i) {
    buf[i] = i + 1;
  }

  MPI_Datatype fragmented;
  MPI_Type_vector(NBLK, BLK, 2 * BLK, MPI_INT, &fragmented);
  MPI_Type_commit(&fragmented);

  MPI_File fh;
  MPI_File_delete(path, MPI_INFO_NULL);
  MPI_File_open(MPI_COMM_WORLD, path, MPI_MODE_CREATE | MPI_MODE_RDWR,
                MPI_INFO_NULL, &fh);

  MPI_File_set_view(fh, 0, MPI_INT, MPI_INT, "native", MPI_INFO_NULL);
  int control = write_all(fh, buf, 64, "(a) contiguous, control");

  MPI_File_set_view(fh, 0, MPI_INT, fragmented, "native", MPI_INFO_NULL);
  int fault = write_all(fh, buf, count, "(b) 512 blocks of 16");

  MPI_File_set_view(fh, 0, MPI_INT, MPI_INT, "native", MPI_INFO_NULL);
  int after = write_all(fh, buf, 64, "(c) contiguous, after (b)");
  int again = write_all(fh, buf, 64, "(d) contiguous, once more");

  MPI_File_close(&fh);

  // The fragmented view spans NBLK*2*BLK integers, of which the write covers
  // the first of every pair of blocks; a complete write leaves a file ending
  // with the last block, at (NBLK-1)*2*BLK + BLK integers.
  struct stat st;
  if (0 == stat(path, &st)) {
    const long expected = (long)((NBLK - 1) * 2 * BLK + BLK) * (long)sizeof(int);
    printf("  file is %lld bytes, a complete write leaves %ld"
           " (%lld blocks of %d bytes landed)\n",
           (long long)st.st_size, expected,
           (long long)(st.st_size ? (st.st_size - BLK * sizeof(int)) /
                                            (2 * BLK * sizeof(int)) +
                                        1
                                  : 0),
           (int)(BLK * sizeof(int)));
  }

  MPI_Type_free(&fragmented);
  free(buf);

  int ok = control && !fault;
  if (!ok) {
    printf("  probe inconclusive: the control must succeed and (b) must not\n");
  } else if (after || again) {
    printf("  note: (c)/(d) succeeded, so the aio slots were not leaked here\n");
  }

  MPI_File_delete(path, MPI_INFO_NULL);
  MPI_Finalize();
  return ok ? 0 : 1;
}
