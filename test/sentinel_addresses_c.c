// The sentinel cells in src/mpif_constants.c are the storage that mpif's
// Fortran sentinel COMMON blocks are merged onto, and their *addresses* are
// what identify a sentinel. This is the assertion that the storage still has
// the properties the rest of the design assumes.
//
// Two things are checked, and each has a way of going wrong that nothing else
// in the tree would notice:
//
// - **Distinctness.** The address is now the identity. Two sentinels at one
//   address would make the C translators in include/mpif_sentinels.h answer
//   the same question two ways, and no Fortran test could see it.
// - **Alignment.** Fortran's COMMON asks for the target's BIGGEST_ALIGNMENT
//   rather than the natural alignment of what the block holds -- 16 bytes on
//   aarch64, and on x86 whatever the enabled vector ISA implies: 16 by default,
//   32 with AVX, 64 with AVX-512. When the C definition asks for less than a
//   caller's COMMON does, GNU ld warns once per sentinel on every link, which is
//   https://github.com/eschnett/mpif/issues/2. The cure is to ask for more than
//   any caller will, and this fails on the first cell if that stops being true.
//   Nothing here is misaligned in a way that could crash; the test exists
//   because the alignment is otherwise invisible from inside mpif.
//
// Size is deliberately *not* here: each cell is exactly as large as the Fortran
// COMMON merged onto it, three different sizes, and only mpif_check_environment
// can compare against the Fortran side. This file sees one half.
//
// What is *not* here either: that each cell holds its ABI constant. It no longer does
// -- a cell's contents are poison, and the ABI value is produced by translation
// instead. That the translation is right, and that each Fortran sentinel arrives
// at the cell this file names, is mpif_check_environment's assertion, which can
// make it because it has the Fortran side to compare against.
//
// The names are mpif's own, not the standard's, so this test reaches past the
// public interface deliberately: the addresses are not otherwise observable.
// include/mpif_sentinels.h declares the same twelve, but it is an internal
// header that an installed mpif does not ship, so they are re-declared here --
// which also means a rename has to be made in both places.

#include <mpi.h>

#include <stdint.h>
#include <stdio.h>

// What src/mpif_constants.c promises. Kept as literals rather than shared
// through a header, so that a change there has to be made here too.
enum { REQUIRED_ALIGNMENT = 64 };

// Declared without a bound: the sizes are three different ones and they belong to
// src/mpif_constants.c, which mpif_check_environment compares against Fortran's
// view. Naming a wrong bound here would put a size on the *reference* and invite
// the very "size of symbol changed" warning the exact sizing exists to avoid.
extern const MPI_Fint mpif_bottom_[];
extern const MPI_Fint mpif_in_place_[];
extern const MPI_Fint mpif_buffer_automatic_[];
extern const char mpif_argv_null_[];
extern const char mpif_argvs_null_[];
extern const MPI_Fint mpif_errcodes_ignore_[];
extern const MPI_Fint mpif_status_ignore_[];
extern const MPI_Fint mpif_statuses_ignore_[];
extern const MPI_Fint mpif_f08_status_ignore_[];
extern const MPI_Fint mpif_f08_statuses_ignore_[];
extern const MPI_Fint mpif_unweighted_[];
extern const MPI_Fint mpif_weights_empty_[];

struct sentinel {
  const char *name;
  const void *cell;
};

int main(void) {
  const struct sentinel sentinels[] = {
      {"MPI_BOTTOM", mpif_bottom_},
      {"MPI_IN_PLACE", mpif_in_place_},
      {"MPI_BUFFER_AUTOMATIC", mpif_buffer_automatic_},
      {"MPI_ARGV_NULL", mpif_argv_null_},
      {"MPI_ARGVS_NULL", mpif_argvs_null_},
      {"MPI_ERRCODES_IGNORE", mpif_errcodes_ignore_},
      {"MPI_STATUS_IGNORE", mpif_status_ignore_},
      {"MPI_STATUSES_IGNORE", mpif_statuses_ignore_},
      {"MPI_STATUS_IGNORE (mpi_f08)", mpif_f08_status_ignore_},
      {"MPI_STATUSES_IGNORE (mpi_f08)", mpif_f08_statuses_ignore_},
      {"MPI_UNWEIGHTED", mpif_unweighted_},
      {"MPI_WEIGHTS_EMPTY", mpif_weights_empty_},
  };
  const int count = (int)(sizeof(sentinels) / sizeof(sentinels[0]));

  int failures = 0;

  for (int i = 0; i < count; ++i) {
    const uintptr_t address = (uintptr_t)sentinels[i].cell;
    if (address % REQUIRED_ALIGNMENT != 0) {
      printf("  %-30s cell at %#llx is not %d-byte aligned\n",
             sentinels[i].name, (unsigned long long)address,
             REQUIRED_ALIGNMENT);
      ++failures;
    }
    // The address is the identity, so a collision would silently conflate two
    // sentinels. O(n^2) over twelve.
    for (int j = 0; j < i; ++j) {
      if (sentinels[i].cell == sentinels[j].cell) {
        printf("  %-30s shares its address %#llx with %s\n", sentinels[i].name,
               (unsigned long long)address, sentinels[j].name);
        ++failures;
      }
    }
  }

  if (failures != 0) {
    printf("sentinel_addresses_c: %d problem(s)\n", failures);
    return 1;
  }
  printf("all %d sentinel cells are distinct and %d-byte aligned: ok\n", count,
         REQUIRED_ALIGNMENT);
  return 0;
}
