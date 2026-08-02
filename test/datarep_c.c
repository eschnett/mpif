// The datarep trampolines, driven directly.
//
// Neither implementation implements user-defined datareps -- see "Registered
// datareps are not implemented" in MISSING.md -- so nothing will ever call
// these trampolines through MPI, and the marshalling they do would otherwise
// be entirely untested. Calling them from here is the substitute: build the box
// the generated wrapper builds, hand each trampoline the arguments MPI would,
// and check what the Fortran callbacks in test/datarep_subf90.f90 saw.
//
// What that covers is every conversion the trampoline performs: the datatype
// handle to an INTEGER, the count, the position, the extra state, the two
// buffer pointers, and the error code coming back. What it cannot cover is
// whether MPI calls them with what the standard says, which is not testable
// until an implementation calls them at all.
//
// The prototypes are declared here rather than included from
// include/mpif_callbacks.h, which mpif does not install. Repeating them is the
// point as much as a necessity: this file is the C side of an ABI the Fortran
// side has to agree with, so writing it out again is a check on both.

#include <mpi.h>

#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef void (*mpif_fortran_procedure)(void);

void *mpif_datarep_reserve(mpif_fortran_procedure read_fn,
                           mpif_fortran_procedure write_fn,
                           mpif_fortran_procedure extent_fn,
                           MPI_Aint extra_state);
void mpif_datarep_cancel(void *box);
int mpif_datarep_read_trampoline(void *userbuf, MPI_Datatype datatype,
                                 int count, void *filebuf, MPI_Offset position,
                                 void *extra_state);
int mpif_datarep_write_trampoline(void *userbuf, MPI_Datatype datatype,
                                  int count, void *filebuf, MPI_Offset position,
                                  void *extra_state);
int mpif_datarep_read_trampoline_c(void *userbuf, MPI_Datatype datatype,
                                   MPI_Count count, void *filebuf,
                                   MPI_Offset position, void *extra_state);
int mpif_datarep_write_trampoline_c(void *userbuf, MPI_Datatype datatype,
                                    MPI_Count count, void *filebuf,
                                    MPI_Offset position, void *extra_state);
int mpif_datarep_extent_trampoline(MPI_Datatype datatype, MPI_Aint *extent,
                                   void *extra_state);

// The Fortran callbacks, named by their symbols
extern void dr_read_fn_(void);
extern void dr_write_fn_(void);
extern void dr_extent_fn_(void);
extern void dr_extent_fail_fn_(void);

enum { N = 8 };
static const MPI_Aint TOKEN = 20260802;
static const MPI_Offset POSITION = 3;

static int failures = 0;

static void check(int ok, const char *what) {
  if (!ok) {
    printf("  %s: FAILED\n", what);
    ++failures;
  }
}

// The conversion the Fortran callbacks perform, so that the expectation is
// written once.
static void expect_complement(const unsigned char *got,
                              const unsigned char *from, const char *what) {
  for (int i = 0; i < N; ++i) {
    if (got[i] != (unsigned char)~from[i]) {
      printf("  %s: byte %d is 0x%02x, want 0x%02x\n", what, i, got[i],
             (unsigned char)~from[i]);
      ++failures;
      return;
    }
  }
}

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  void *const box = mpif_datarep_reserve(
      (mpif_fortran_procedure)dr_read_fn_, (mpif_fortran_procedure)dr_write_fn_,
      (mpif_fortran_procedure)dr_extent_fn_, TOKEN);
  check(box != NULL, "mpif_datarep_reserve");
  if (!box) {
    MPI_Finalize();
    return 1;
  }

  unsigned char user[N], file[N];
  for (int i = 0; i < N; ++i)
    file[i] = (unsigned char)(0x10 + i);
  memset(user, 0, sizeof user);

  // A read converts file -> user.
  int err = mpif_datarep_read_trampoline(user, MPI_BYTE, N, file, POSITION, box);
  check(err == MPI_SUCCESS, "read trampoline error code");
  expect_complement(user, file, "read trampoline");

  // A write converts user -> file, so swapping the two trampolines would show
  // up here as the buffers going the wrong way.
  for (int i = 0; i < N; ++i)
    user[i] = (unsigned char)(0x40 + i);
  memset(file, 0, sizeof file);
  err = mpif_datarep_write_trampoline(user, MPI_BYTE, N, file, POSITION, box);
  check(err == MPI_SUCCESS, "write trampoline error code");
  expect_complement(file, user, "write trampoline");

  // The large-count pair takes the same route with an MPI_Count. The Fortran
  // callbacks are the small-count ones, which is wrong for a real call and
  // right for this one: what is being checked is that the trampoline passes a
  // count by address like everything else, and the small-count callback would
  // read the low half of an MPI_Count as its INTEGER either way on a
  // little-endian machine. Only the buffers are asserted on.
  memset(user, 0, sizeof user);
  for (int i = 0; i < N; ++i)
    file[i] = (unsigned char)(0x70 + i);
  err = mpif_datarep_read_trampoline_c(user, MPI_BYTE, N, file, POSITION, box);
  expect_complement(user, file, "read trampoline (large count)");

  for (int i = 0; i < N; ++i)
    user[i] = (unsigned char)(0xa0 + i);
  memset(file, 0, sizeof file);
  err = mpif_datarep_write_trampoline_c(user, MPI_BYTE, N, file, POSITION, box);
  expect_complement(file, user, "write trampoline (large count)");

  // The extent callback reports through a pointer MPI owns.
  MPI_Aint extent = -1;
  err = mpif_datarep_extent_trampoline(MPI_INTEGER, &extent, box);
  check(err == MPI_SUCCESS, "extent trampoline error code");
  check(extent == 44, "extent trampoline value");

  // On failure the extent has to be left alone rather than handed to MPI: the
  // standard leaves an output argument undefined when a call fails, and the
  // failing callback sets it to 99 on the way out.
  void *const failbox = mpif_datarep_reserve(
      (mpif_fortran_procedure)dr_read_fn_, (mpif_fortran_procedure)dr_write_fn_,
      (mpif_fortran_procedure)dr_extent_fail_fn_, TOKEN);
  extent = -1;
  err = mpif_datarep_extent_trampoline(MPI_INTEGER, &extent, failbox);
  check(err != MPI_SUCCESS, "failing extent reports an error");
  check(extent == -1, "failing extent leaves the value alone");
  mpif_datarep_cancel(failbox);

  mpif_datarep_cancel(box);

  MPI_Finalize();

  if (failures) {
    printf("datarep_c: %d failures\n", failures);
    return 1;
  }
  printf("datarep_c: all ok\n");
  return 0;
}
