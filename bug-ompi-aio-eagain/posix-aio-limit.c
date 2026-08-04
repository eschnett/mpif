// What macOS actually allows one process to have outstanding in aio, and what
// it takes to give a slot back. Two facts, neither of them Open MPI's, but both
// needed to read `ompi-aio-eagain.c`'s failure -- see MISSING.md, "a nonblocking
// collective write is lost when the aio queue fills".
//
// 1. The ceiling is `kern.aioprocmax`, per process, 16 on macOS 26. It is *not*
//    `kern.aiomax` (90 here), which is the system-wide total and is what
//    `sysconf(_SC_AIO_MAX)` reports -- and `sysconf(_SC_AIO_MAX)` is what
//    ompi/mca/fbtl/posix/fbtl_posix.c's `mca_fbtl_posix_module_init` sizes its
//    batch of concurrent `aio_write`s from.
//
// 2. A request that has *completed* still holds its slot until `aio_return` is
//    called on it. So abandoning an aiocb -- as the fbtl's error path does, by
//    free()ing the array of them -- does not merely lose that operation, it
//    retires the slot for the life of the process.
//
// No MPI. Compile and run it as an ordinary program:
//
//   cc -o posix-aio-limit posix-aio-limit.c && ./posix-aio-limit

#include <aio.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/sysctl.h>
#include <unistd.h>

enum { N = 64, LEN = 64 };  // more requests than any plausible limit

static void report_sysctl(const char *name) {
  int val = 0;
  size_t len = sizeof val;
  if (0 == sysctlbyname(name, &val, &len, NULL, 0)) {
    printf("    %-18s = %d\n", name, val);
  }
}

int main(void) {
  printf("  the two limits, and what sysconf reports:\n");
  report_sysctl("kern.aioprocmax");
  report_sysctl("kern.aiomax");
  printf("    %-18s = %ld\n", "_SC_AIO_MAX", sysconf(_SC_AIO_MAX));

  const char *path = "posix-aio-limit.dat";
  int fd = open(path, O_CREAT | O_RDWR | O_TRUNC, 0644);
  if (-1 == fd) {
    perror("open");
    return 1;
  }

  char buf[LEN];
  memset(buf, 'x', sizeof buf);

  struct aiocb cb[N];
  memset(cb, 0, sizeof cb);

  int queued = 0;
  for (int i = 0; i < N; ++i) {
    cb[i].aio_fildes = fd;
    cb[i].aio_buf = buf;
    cb[i].aio_nbytes = LEN;
    cb[i].aio_offset = (off_t)i * LEN;
    cb[i].aio_sigevent.sigev_notify = SIGEV_NONE;
    if (-1 == aio_write(&cb[i])) {
      printf("  aio_write #%d refused: %s (errno %d)\n", i + 1, strerror(errno),
             errno);
      break;
    }
    ++queued;
  }
  printf("  (1) outstanding aio_write()s accepted: %d\n", queued);

  // Wait for every one of them to finish, but reap none.
  for (int i = 0; i < queued; ++i) {
    while (EINPROGRESS == aio_error(&cb[i])) {
      usleep(1000);
    }
  }
  printf("      all %d now report aio_error() == 0, i.e. complete\n", queued);

  struct aiocb extra;
  memset(&extra, 0, sizeof extra);
  extra.aio_fildes = fd;
  extra.aio_buf = buf;
  extra.aio_nbytes = LEN;
  extra.aio_offset = 1 << 20;
  extra.aio_sigevent.sigev_notify = SIGEV_NONE;

  int held = aio_write(&extra);
  printf("  (2) one more, with those %d complete but not aio_return()ed: %s\n",
         queued, -1 == held ? strerror(errno) : "accepted");
  if (0 == held) {
    while (EINPROGRESS == aio_error(&extra)) {
      usleep(1000);
    }
    aio_return(&extra);
  }

  for (int i = 0; i < queued; ++i) {
    aio_return(&cb[i]);
  }
  int freed = aio_write(&extra);
  printf("  (3) the same call once they have been aio_return()ed: %s\n",
         -1 == freed ? strerror(errno) : "accepted");
  if (0 == freed) {
    while (EINPROGRESS == aio_error(&extra)) {
      usleep(1000);
    }
    aio_return(&extra);
  }

  close(fd);
  unlink(path);

  // (2) failing and (3) succeeding is the point; anything else and the
  // reasoning in MISSING.md needs revisiting.
  return (-1 == held && 0 == freed) ? 0 : 1;
}
