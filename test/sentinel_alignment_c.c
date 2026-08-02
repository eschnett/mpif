// The sentinel cells in src/mpif_constants.c are over-aligned on purpose, and
// this is the assertion that they still are.
//
// Each cell is the pointee of a Cray pointer in a COMMON block of the same name.
// The Fortran side's COMMON is a tentative definition that the linker merges
// with the C one, and it asks for the target's BIGGEST_ALIGNMENT rather than the
// natural alignment of the pointer inside it -- 16 bytes on aarch64, and on x86
// whatever the enabled vector ISA implies: 16 by default, 32 with AVX, 64 with
// AVX-512. When the C definition asks for less than a caller's COMMON does, GNU
// ld warns once per sentinel on every link, which is
// https://github.com/eschnett/mpif/issues/2. The cure is to ask for more than
// any caller will.
//
// Nothing here is misaligned in a way that could crash: the cell holds an
// address, the pointee lives elsewhere, and no vector instruction touches it.
// The test exists because the alignment is otherwise invisible from inside mpif
// -- it only shows up as a warning in someone else's build, on a machine wider
// than the one mpif was built for. Dropping the attribute, or putting 16 back,
// fails this on the first cell.
//
// The names are mpif's own, not the standard's, so this test reaches past the
// public interface deliberately: the addresses are not otherwise observable.
// Fortran cannot make this check -- `loc(MPI_BOTTOM)` gives the pointee, which
// is the ABI constant's address, not the cell's.

#include <mpi.h>

#include <stdint.h>
#include <stdio.h>

// What src/mpif_constants.c promises. Kept as a literal rather than shared
// through a header, so that a change there has to be made here too.
enum { REQUIRED = 64 };

extern const intptr_t mpif_bottom_ptr_;
extern const intptr_t mpif_in_place_ptr_;
extern const intptr_t mpif_buffer_automatic_ptr_;
extern const intptr_t mpif_argv_null_ptr_;
extern const intptr_t mpif_argvs_null_ptr_;
extern const intptr_t mpif_errcodes_ignore_ptr_;
extern const intptr_t mpif_status_ignore_ptr_;
extern const intptr_t mpif_statuses_ignore_ptr_;
extern const intptr_t mpif_f08_status_ignore_ptr_;
extern const intptr_t mpif_f08_statuses_ignore_ptr_;
extern const intptr_t mpif_unweighted_ptr_;
extern const intptr_t mpif_weights_empty_ptr_;

struct sentinel {
  const char *name;
  const intptr_t *cell;
  const void *expected;
};

int main(void) {
  const struct sentinel sentinels[] = {
      {"MPI_BOTTOM", &mpif_bottom_ptr_, MPI_BOTTOM},
      {"MPI_IN_PLACE", &mpif_in_place_ptr_, MPI_IN_PLACE},
      {"MPI_BUFFER_AUTOMATIC", &mpif_buffer_automatic_ptr_,
       MPI_BUFFER_AUTOMATIC},
      {"MPI_ARGV_NULL", &mpif_argv_null_ptr_, MPI_ARGV_NULL},
      {"MPI_ARGVS_NULL", &mpif_argvs_null_ptr_, MPI_ARGVS_NULL},
      {"MPI_ERRCODES_IGNORE", &mpif_errcodes_ignore_ptr_, MPI_ERRCODES_IGNORE},
      {"MPI_STATUS_IGNORE", &mpif_status_ignore_ptr_, MPI_STATUS_IGNORE},
      {"MPI_STATUSES_IGNORE", &mpif_statuses_ignore_ptr_, MPI_STATUSES_IGNORE},
      {"MPI_STATUS_IGNORE (mpi_f08)", &mpif_f08_status_ignore_ptr_,
       MPI_STATUS_IGNORE},
      {"MPI_STATUSES_IGNORE (mpi_f08)", &mpif_f08_statuses_ignore_ptr_,
       MPI_STATUSES_IGNORE},
      {"MPI_UNWEIGHTED", &mpif_unweighted_ptr_, MPI_UNWEIGHTED},
      {"MPI_WEIGHTS_EMPTY", &mpif_weights_empty_ptr_, MPI_WEIGHTS_EMPTY},
  };
  const int count = (int)(sizeof(sentinels) / sizeof(sentinels[0]));

  int failures = 0;
  for (int i = 0; i < count; ++i) {
    const uintptr_t address = (uintptr_t)sentinels[i].cell;
    if (address % REQUIRED != 0) {
      printf("  %-30s cell at %#llx is not %d-byte aligned\n",
             sentinels[i].name, (unsigned long long)address, REQUIRED);
      ++failures;
    }
    // And the cell still holds what it is supposed to. Over-aligning must not
    // be the only thing this file is checked for: an alignment that is right
    // about the wrong value would be worse than the warning.
    if (*sentinels[i].cell != (intptr_t)sentinels[i].expected) {
      printf("  %-30s holds %#llx, expected %#llx\n", sentinels[i].name,
             (unsigned long long)*sentinels[i].cell,
             (unsigned long long)(intptr_t)sentinels[i].expected);
      ++failures;
    }
  }

  if (failures != 0) {
    printf("sentinel_alignment_c: %d problem(s)\n", failures);
    return 1;
  }
  printf("all %d sentinels are %d-byte aligned and hold the ABI constant: ok\n",
         count, REQUIRED);
  return 0;
}
