// Does MPI_Alltoallw with MPI_IN_PLACE read `sendtypes` at all?
//
// MPI-5.0 6.8 says it must not: "In such a case, sendcounts, sdispls and
// sendtypes are ignored." mpif converted one handle per member of the group
// regardless, so a caller who passed the one-element array the standard entitles
// it to was over-read by every rank past the first.
//
// The over-read is the defect, and nothing about its *value* is observable:
// MPI_Type_fromint hands back `(ABI_Datatype) x` unexamined for 0 < x < 4096 and
// derives a pointer from anything else, so whether the garbage aborts, converts
// to a plausible handle, or converts to a wild one is a property of what happened
// to be adjacent. A poisoned handle value was tried first and proved exactly that
// -- with the defect put back the test still passed, because -12345 is neither
// builtin nor in range and MPICH just built a pointer out of it.
//
// So the read itself is made to fault. Two pages, the second PROT_NONE, and the
// one-element array placed so its last byte ends the first: element 0 is
// readable, element 1 is not. ASan would not do this job, the faulting read
// being inside a hand-rolled loop in a library it does not instrument.
//
// Each of the three bindings gets a turn, since the defect was in the shared C
// wrapper and reached all of them.

#include <mpi.h>

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

void alltoallw_inplace_probe_f_(MPI_Fint *sendtypes);
void alltoallw_inplace_probe_f90_(MPI_Fint *sendtypes);
void alltoallw_inplace_probe_f08_(MPI_Fint *sendtypes);

// One MPI_Fint whose next MPI_Fint is on an unreadable page.
static MPI_Fint *guarded_handle(void) {
  const long pagesize = sysconf(_SC_PAGESIZE);
  char *const base = mmap(NULL, 2 * pagesize, PROT_READ | PROT_WRITE,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  if (base == MAP_FAILED)
    abort();
  if (mprotect(base + pagesize, pagesize, PROT_NONE) != 0)
    abort();
  MPI_Fint *const handle = (MPI_Fint *)(base + pagesize - sizeof(MPI_Fint));
  // The standard says this is never read, so what it holds cannot matter. It is
  // MPI_DATATYPE_NULL rather than anything eye-catching for that reason: if the
  // value ever does matter, that is the defect.
  *handle = MPI_Type_toint(MPI_DATATYPE_NULL);
  return handle;
}

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  int size;
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  if (size < 2) {
    // At one rank the wrapper reads exactly the one element it is given, so the
    // guard page cannot be reached and the test would pass either way.
    fprintf(stderr, "this test wants at least two ranks, not %d\n", size);
    MPI_Abort(MPI_COMM_WORLD, 1);
  }

  alltoallw_inplace_probe_f_(guarded_handle());
  alltoallw_inplace_probe_f90_(guarded_handle());
  alltoallw_inplace_probe_f08_(guarded_handle());

  MPI_Finalize();
}
