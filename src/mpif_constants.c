#include <mpif_sentinels.h>

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

// The storage each Fortran sentinel's COMMON block is merged onto. The address
// of a cell is what identifies the sentinel; nothing reads the contents, which
// is why they are poison. include/mpif_sentinels.h holds the declarations, the
// size and alignment rules, the two poison patterns and the argument for the
// whole arrangement; the COMMON blocks themselves are in
// include/mpif_constants.h and src/mpif_f08_types.F90.
//
// Defining the symbols here is what makes the addresses available to C before
// the program starts, with no initialisation step to run.

const MPI_Fint mpif_bottom_[MPIF_SENTINEL_INT_WORDS] MPIF_SENTINEL = MPIF_POISON_INT;
const MPI_Fint mpif_in_place_[MPIF_SENTINEL_INT_WORDS] MPIF_SENTINEL = MPIF_POISON_INT;
const MPI_Fint mpif_buffer_automatic_[MPIF_SENTINEL_INT_WORDS] MPIF_SENTINEL = MPIF_POISON_INT;

// CHARACTER in Fortran, so one byte rather than one INTEGER; see the shape
// rationale in include/mpif_constants.h.
const char mpif_argv_null_[MPIF_SENTINEL_CHAR_BYTES] MPIF_SENTINEL = MPIF_POISON_CHAR;
const char mpif_argvs_null_[MPIF_SENTINEL_CHAR_BYTES] MPIF_SENTINEL = MPIF_POISON_CHAR;

const MPI_Fint mpif_errcodes_ignore_[MPIF_SENTINEL_INT_WORDS] MPIF_SENTINEL = MPIF_POISON_INT;
const MPI_Fint mpif_unweighted_[MPIF_SENTINEL_INT_WORDS] MPIF_SENTINEL = MPIF_POISON_INT;
const MPI_Fint mpif_weights_empty_[MPIF_SENTINEL_INT_WORDS] MPIF_SENTINEL = MPIF_POISON_INT;

// The four status cells get the poison that crashes rather than the poison that
// is merely recognisable; see MPIF_POISON_STATUS. mpi_f08's two are separate
// objects from mpif.h's, being TYPE(MPI_Status) rather than INTEGER arrays, so
// the four addresses are distinct and a C layer can tell them apart -- which
// section 3.2.6 permits and which was impossible while all four were null.
const MPI_Fint mpif_status_ignore_[MPIF_SENTINEL_STATUS_WORDS] MPIF_SENTINEL = MPIF_POISON_STATUS;
const MPI_Fint mpif_statuses_ignore_[MPIF_SENTINEL_STATUS_WORDS] MPIF_SENTINEL = MPIF_POISON_STATUS;
const MPI_Fint mpif_f08_status_ignore_[MPIF_SENTINEL_STATUS_WORDS] MPIF_SENTINEL = MPIF_POISON_STATUS;
const MPI_Fint mpif_f08_statuses_ignore_[MPIF_SENTINEL_STATUS_WORDS] MPIF_SENTINEL = MPIF_POISON_STATUS;
