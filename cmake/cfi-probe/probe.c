/* The C half of the TS 29113 probe; see CMakeLists.txt here. Checks that an
 * assumed-rank dummy arrived as a descriptor whose base address, element
 * length, rank and contiguity are what the Fortran caller knows them to be.
 * The base-address check is the load-bearing one: a noncontiguous section
 * must arrive pointing into the caller's array, not at a copy, or
 * MPI_SUBARRAYS_SUPPORTED would be a lie. */

#include <ISO_Fortran_binding.h>
#include <stddef.h>

int probe_c(const CFI_cdesc_t *buf, void *expected_base,
            size_t expected_elem_len, int expected_rank,
            int expected_contiguous) {
  if (buf->base_addr != expected_base)
    return 1;
  if (buf->elem_len != expected_elem_len)
    return 2;
  if ((int)buf->rank != expected_rank)
    return 3;
  if ((CFI_is_contiguous(buf) != 0) != (expected_contiguous != 0))
    return 4;
  return 0;
}
