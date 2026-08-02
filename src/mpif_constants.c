#include <mpi.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

// The f08 bindings hand MPI the caller's own TYPE(MPI_Status) rather than
// converting it into an INTEGER array first, which is sound only because the two
// are the same eight integers in the same order. Both halves are guaranteed --
// the layout is the ABI's, the constants are mpif's, in
// include/mpif_constants.h -- so this is not a hopeful assumption, but it is one
// that a future edit could break silently. Fail the build instead.
//
// MPI_Fint, not int. The wrapper is handed a Fortran INTEGER array and casts it
// to MPI_Status*, so what has to hold is that the struct is eight Fortran
// integers -- and MPI_Fint is what a Fortran INTEGER is called on this side.
// Against `int` these would be near-tautologies, the ABI having declared the
// struct as eight ints: they would catch padding and nothing else. Against
// MPI_Fint they catch the case that would actually break the cast, a Fortran
// whose default INTEGER is not the size of a C int.
//
// The indices are Fortran's, counting from one; the offsets are C's, counting
// bytes from zero.
_Static_assert(sizeof(MPI_Status) == 8 * sizeof(MPI_Fint),
               "MPI_STATUS_SIZE is 8 in include/mpif_constants.h");
_Static_assert(offsetof(MPI_Status, MPI_SOURCE) == (1 - 1) * sizeof(MPI_Fint),
               "MPI_SOURCE is 1 in include/mpif_constants.h");
_Static_assert(offsetof(MPI_Status, MPI_TAG) == (2 - 1) * sizeof(MPI_Fint),
               "MPI_TAG is 2 in include/mpif_constants.h");
_Static_assert(offsetof(MPI_Status, MPI_ERROR) == (3 - 1) * sizeof(MPI_Fint),
               "MPI_ERROR is 3 in include/mpif_constants.h");

// Each cell below is the pointee of a Cray pointer declared in a COMMON block
// of the same name -- see include/mpif_constants.h and src/mpif_f08_types.F90 --
// and defining the symbol here is what puts the ABI constant's address there
// before the program starts, with no initialisation step to run.
//
// The Fortran side's COMMON is a tentative definition that the linker merges
// with this one, and it asks for the target's BIGGEST_ALIGNMENT rather than the
// natural alignment of the pointer it holds. That is 16 bytes on aarch64, and on
// x86 whatever the enabled vector ISA implies: 16 by default, 32 with AVX, 64
// with AVX-512. Ask for less than the caller's COMMON does and GNU ld warns,
// once per sentinel and on every link:
//
//     ld: warning: alignment 16 of normal symbol `mpif_statuses_ignore_ptr_'
//     in libmpifort_abi.so is smaller than 32 used by the common definition
//
// Nothing is ever genuinely misaligned -- the cell holds an address, the pointee
// lives elsewhere, and no vector instruction touches it -- but the warning is
// alarming and it fired for everyone building for a machine wider than the one
// mpif was built for. See https://github.com/eschnett/mpif/issues/2.
//
// So ask for more than any caller will. 64 bytes covers AVX-512, and
// __BIGGEST_ALIGNMENT__ takes over should a target ever exceed that; it is the
// same quantity the Fortran side is using. Over-aligning twelve pointers costs
// padding in .rodata and nothing else.
#ifdef __BIGGEST_ALIGNMENT__
#define MPIF_SENTINEL_ALIGNMENT \
  (__BIGGEST_ALIGNMENT__ > 64 ? __BIGGEST_ALIGNMENT__ : 64)
#else
#define MPIF_SENTINEL_ALIGNMENT 64
#endif
#define MPIF_SENTINEL __attribute__((__aligned__(MPIF_SENTINEL_ALIGNMENT)))

const intptr_t mpif_bottom_ptr_ MPIF_SENTINEL = (intptr_t)MPI_BOTTOM;
const intptr_t mpif_in_place_ptr_ MPIF_SENTINEL = (intptr_t)MPI_IN_PLACE;
const intptr_t mpif_buffer_automatic_ptr_ MPIF_SENTINEL = (intptr_t)MPI_BUFFER_AUTOMATIC;

const intptr_t mpif_argv_null_ptr_ MPIF_SENTINEL = (intptr_t)MPI_ARGV_NULL;
const intptr_t mpif_argvs_null_ptr_ MPIF_SENTINEL = (intptr_t)MPI_ARGVS_NULL;
const intptr_t mpif_errcodes_ignore_ptr_ MPIF_SENTINEL = (intptr_t)MPI_ERRCODES_IGNORE;
const intptr_t mpif_status_ignore_ptr_ MPIF_SENTINEL = (intptr_t)MPI_STATUS_IGNORE;
const intptr_t mpif_statuses_ignore_ptr_ MPIF_SENTINEL = (intptr_t)MPI_STATUSES_IGNORE;
// mpi_f08's two status sentinels take their addresses from here rather than
// from the two cells above; see the comment on their declarations in
// src/mpif_f08_types.F90 for the gfortran bug that separates them. The same
// values, so all three interfaces still name one address.
const intptr_t mpif_f08_status_ignore_ptr_ MPIF_SENTINEL = (intptr_t)MPI_STATUS_IGNORE;
const intptr_t mpif_f08_statuses_ignore_ptr_ MPIF_SENTINEL = (intptr_t)MPI_STATUSES_IGNORE;
const intptr_t mpif_unweighted_ptr_ MPIF_SENTINEL = (intptr_t)MPI_UNWEIGHTED;
const intptr_t mpif_weights_empty_ptr_ MPIF_SENTINEL = (intptr_t)MPI_WEIGHTS_EMPTY;
