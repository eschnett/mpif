/* Which MPI ABI library file did the dynamic loader actually resolve?
 *
 * The standard ABI makes that a run-time question: the executable records
 * only the conventional versioned name (libmpi_abi.so.1 on Linux, an install
 * name ending in libmpi_abi.1.dylib on macOS) plus a default rpath, and the
 * loader's search path -- LD_LIBRARY_PATH / DYLD_LIBRARY_PATH -- can put a
 * different implementation in front of the default. dladdr on the address of
 * MPI_Init names the image that won.
 *
 * The direct MPI_Init reference below is also what obliges this executable to
 * link -lmpi_abi itself, keeping mpif_info shaped like a real application:
 * per MPI-5.0 section 20.2.1 the ABI library is the sole direct MPI
 * dependency of the application binary, and libmpifort_abi deliberately
 * carries none.
 *
 * Compiled into bin/mpif_info only, never into the library. */

#define _GNU_SOURCE 1 /* dladdr is a GNU extension on glibc */
#include <dlfcn.h>
#include <string.h>

#include <mpi.h>

/* Fill a Fortran character buffer (blank-padded, no NUL) with the pathname of
   the image providing MPI_Init, or a diagnostic if dladdr cannot say. Called
   from src/mpif_info.f90; the result is printed from Fortran so the output
   does not interleave two runtimes' stdout buffering. */
void mpif_info_loaded_library(char *path, int len) {
  const char *name = "(unknown: dladdr reported nothing)";
  Dl_info info;
  if (dladdr((const void *)&MPI_Init, &info) && info.dli_fname &&
      info.dli_fname[0])
    name = info.dli_fname;
  int n = (int)strlen(name);
  if (n > len)
    n = len;
  memcpy(path, name, (size_t)n);
  memset(path + n, ' ', (size_t)(len - n));
}
