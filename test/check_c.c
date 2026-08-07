// mpif_check_environment from C. No C header is installed for it -- nothing
// needs one yet, and CODE.md records the decision -- so the prototype is
// declared here, which is also the documented idiom for C callers.
// mpif_check_version is not exercised: its point is comparing the caller's
// compile-time MPIF_VERSION against the loaded library, and C has no such
// macro to pass.

#include <mpi.h>

#include <stddef.h>

void mpif_check_environment(void);

int main(void) {
  mpif_check_environment();
  MPI_Init(NULL, NULL);
  mpif_check_environment();
  MPI_Finalize();
  mpif_check_environment();
  return 0;
}
