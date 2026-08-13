#ifndef MPIF_SENTINELS_H
#define MPIF_SENTINELS_H

#include <mpi.h>

// The Fortran sentinels, by address.
//
// MPI-5.0 A.1.1 gives the ten sentinels ABI values that are not addresses of
// anything: MPI_BOTTOM is (void*)0, MPI_IN_PLACE (void*)1,
// MPI_BUFFER_AUTOMATIC (void*)2, MPI_UNWEIGHTED (int*)10, MPI_WEIGHTS_EMPTY
// (int*)11, and the other five are null pointers. No Fortran entity can be
// declared *at* such an address, so the Fortran sentinels are ordinary COMMON
// blocks -- see include/mpif_constants.h and src/mpif_f08_types.F90 -- and each
// cell below is the storage one of those blocks is merged onto. It is the
// *address* that identifies a sentinel; the contents are never read.
//
// This is what MPI-5.0 section 2.5.4's advice to implementors describes:
// "Typically, these constants are implemented as predefined static variables
// (e.g., a variable in an MPI-declared COMMON block), relying on the fact that
// the target compiler passes data by address. Inside the subroutine, this
// address can be extracted by some mechanism outside the Fortran standard
// (e.g., by Fortran extensions or by implementing the function in C)."
// Section 3.2.6 grants the same for the statuses in particular:
// "MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE are not required to have the same
// values in C and Fortran."
//
// The consequence, and the reason this header exists, is that a wrapper cannot
// forward a sentinel: every argument that can carry one has to translate the
// Fortran address into the ABI value.
//
// Defining the cells here rather than letting Fortran's COMMON be the only
// definition keeps the arrangement that has always been in use: the C side is
// an initialized -- so never tentative, so independent of -fcommon -- strong
// definition, and each Fortran COMMON is a tentative definition the linker
// merges onto it. On macOS that merge needs -Wl,-commons,use_dylibs, which
// CMakeLists.txt puts in the library's INTERFACE link options and in the
// installed mpifort wrapper.

// Each cell's size, matching *exactly* the Fortran COMMON block merged onto it.
//
// Not one uniform size, and this is not a free choice. GNU ld warns once per
// sentinel on every link when a definition's size differs from the common it
// resolves --
//
//     ld: warning: size of symbol `mpif_unweighted_' changed from 4 in
//     caller.o to 64 in libmpif.so
//
// -- so a cell merely *big enough* produces ten or twelve of those in every
// consumer's build. That is the same kind of per-link noise in someone else's
// build as the alignment warning of https://github.com/eschnett/mpif/issues/2,
// and it appears only on ELF: macOS's linker says nothing, so it has to be
// measured in a Linux build (ci-scripts/compile-only.sh in a container) rather
// than here.
//
// The three sizes are the three Fortran shapes in include/mpif_constants.h and
// src/mpif_f08_types.F90. Keep them in step: mpif_check_environment compares each
// against what Fortran reports, and requires equality rather than a fit.
#define MPIF_SENTINEL_INT_WORDS 1    // integer :: X(1)
#define MPIF_SENTINEL_CHAR_BYTES 1   // character(len=1) :: X(1), X(1,1)
#define MPIF_SENTINEL_STATUS_WORDS 8 // X(MPI_STATUS_SIZE), X(MPI_STATUS_SIZE,1)
                                     // and TYPE(MPI_Status)

// Ask for more alignment than any caller's COMMON will. Fortran asks for the
// target's BIGGEST_ALIGNMENT rather than the natural alignment of what the
// block holds: 16 bytes on aarch64, and on x86 whatever the enabled vector ISA
// implies -- 16 by default, 32 with AVX, 64 with AVX-512. Ask for less than the
// caller does and GNU ld warns, once per sentinel and on every link:
//
//     ld: warning: alignment 16 of normal symbol `mpif_statuses_ignore_'
//     in libmpif.so is smaller than 32 used by the common definition
//
// Nothing is ever genuinely misaligned -- no vector instruction touches these
// -- but the warning is alarming and it fired for everyone building for a
// machine wider than the one mpif was built for. See
// https://github.com/eschnett/mpif/issues/2. 64 bytes covers AVX-512, and
// __BIGGEST_ALIGNMENT__ takes over should a target ever exceed that; it is the
// same quantity the Fortran side is using.
#ifdef __BIGGEST_ALIGNMENT__
#define MPIF_SENTINEL_ALIGNMENT \
  (__BIGGEST_ALIGNMENT__ > 64 ? __BIGGEST_ALIGNMENT__ : 64)
#else
#define MPIF_SENTINEL_ALIGNMENT 64
#endif
#define MPIF_SENTINEL __attribute__((__aligned__(MPIF_SENTINEL_ALIGNMENT)))

// The status cells serve both an INTEGER MPI_STATUS_SIZE array and a
// TYPE(MPI_Status); src/mpif_constants.c asserts the two are the same eight
// integers, and this is the third side of that triangle.
_Static_assert(MPIF_SENTINEL_STATUS_WORDS * sizeof(MPI_Fint) == sizeof(MPI_Status),
               "a status cell is both MPI_STATUS_SIZE integers and an MPI_Status");

// The cells are const, so they live in read-only memory and a wrapper that
// forgot to translate faults on the spot rather than scribbling on an object of
// four or thirty-two bytes -- MPI writing a status, spawn writing array_of_errcodes,
// MPI_Dist_graph_neighbors writing weights. That covers writes only; a missed
// *read* would quietly send the cell's contents, so the contents are poison,
// chosen by what the bytes would be interpreted as.
// For cells whose bytes mpif can make no use of: distinctive, and assertable
// at a receiver that was sent one by mistake.
#define MPIF_POISON_INT {(MPI_Fint)0xBAADC0DE}
#define MPIF_POISON_CHAR {(char)0xA5}

// For the four status cells, whose words *are* interpreted -- as a source, a
// tag, an error and a count. Poison that crashes is worth more here than poison
// that is merely recognisable, and the constraints pull in both directions:
//
// - it must not be negative. 0xBAADC0DE as an int is, and negative is how the
//   standard spells MPI_UNDEFINED, MPI_ANY_SOURCE and MPI_PROC_NULL, so code is
//   written to tolerate it and a wrong status would pass unnoticed.
// - it must survive being scaled. A count out of MPI_Get_count gets multiplied
//   by an element size, and 0x7EADC0DE * 4 wraps back to something small, which
//   is the failure being avoided.
//
// 0x0EADC0DE is about 2.5e8: positive, still huge after a multiplication by
// eight, and so an absurd count whose first use kills the caller. Eight words
// written out, because a braced initializer cannot be generated and a short one
// would leave the rest zero rather than poisoned.
#define MPIF_POISON_STATUS                                              \
  {                                                                     \
    (MPI_Fint)0x0EADC0DE, (MPI_Fint)0x0EADC0DE, (MPI_Fint)0x0EADC0DE,   \
    (MPI_Fint)0x0EADC0DE, (MPI_Fint)0x0EADC0DE, (MPI_Fint)0x0EADC0DE,   \
    (MPI_Fint)0x0EADC0DE, (MPI_Fint)0x0EADC0DE                          \
  }

// The twelve cells. src/mpif_constants.c defines them; the COMMON blocks named
// beside each one are merged onto them.
//
// mpi_f08's two status sentinels have cells of their own rather than sharing
// mpif.h's: they are TYPE(MPI_Status) where mpif.h and the mpi module declare
// INTEGER arrays, so they are different objects and now have different
// addresses. Section 3.2.6 permits that, and it is an improvement -- a C layer
// can tell the two apart, which it could not while both were null.

extern const MPI_Fint mpif_bottom_[MPIF_SENTINEL_INT_WORDS];           // /MPIF_BOTTOM/
extern const MPI_Fint mpif_in_place_[MPIF_SENTINEL_INT_WORDS];         // /MPIF_IN_PLACE/
extern const MPI_Fint mpif_buffer_automatic_[MPIF_SENTINEL_INT_WORDS]; // /MPIF_BUFFER_AUTOMATIC/

extern const char mpif_argv_null_[MPIF_SENTINEL_CHAR_BYTES];  // /MPIF_ARGV_NULL/
extern const char mpif_argvs_null_[MPIF_SENTINEL_CHAR_BYTES]; // /MPIF_ARGVS_NULL/

extern const MPI_Fint mpif_errcodes_ignore_[MPIF_SENTINEL_INT_WORDS]; // /MPIF_ERRCODES_IGNORE/
extern const MPI_Fint mpif_unweighted_[MPIF_SENTINEL_INT_WORDS];      // /MPIF_UNWEIGHTED/
extern const MPI_Fint mpif_weights_empty_[MPIF_SENTINEL_INT_WORDS];   // /MPIF_WEIGHTS_EMPTY/

extern const MPI_Fint mpif_status_ignore_[MPIF_SENTINEL_STATUS_WORDS];       // /MPIF_STATUS_IGNORE/
extern const MPI_Fint mpif_statuses_ignore_[MPIF_SENTINEL_STATUS_WORDS];     // /MPIF_STATUSES_IGNORE/
extern const MPI_Fint mpif_f08_status_ignore_[MPIF_SENTINEL_STATUS_WORDS];   // /MPIF_F08_STATUS_IGNORE/
extern const MPI_Fint mpif_f08_statuses_ignore_[MPIF_SENTINEL_STATUS_WORDS]; // /MPIF_F08_STATUSES_IGNORE/

// The translators. One per family of argument, each a couple of pointer
// compares, applied by the generated wrappers to every argument that can carry a
// sentinel -- see the crossing set in dev/mpiapi.jl, which asserts per parameter
// that none is forwarded bare.
//
// Translating unconditionally cannot produce a false positive: a real Fortran
// object is never at one of these addresses. Passing a sentinel where the
// standard does not permit one stays MPI's error to report, exactly as it was
// when the Fortran and C values coincided.

// MPI_BOTTOM, MPI_IN_PLACE, MPI_BUFFER_AUTOMATIC. Two spellings because seven
// routines declare their buffer non-const -- MPI_Buffer_attach and the other two
// attach procedures among them, which is where MPI_BUFFER_AUTOMATIC belongs.
static inline const void *mpif_c_cbuffer(const void *p) {
  if (p == (const void *)mpif_bottom_)
    return MPI_BOTTOM;
  if (p == (const void *)mpif_in_place_)
    return MPI_IN_PLACE;
  if (p == (const void *)mpif_buffer_automatic_)
    return MPI_BUFFER_AUTOMATIC;
  return p;
}

static inline void *mpif_c_buffer(void *p) {
  if (p == (const void *)mpif_bottom_)
    return MPI_BOTTOM;
  if (p == (const void *)mpif_in_place_)
    return MPI_IN_PLACE;
  if (p == (const void *)mpif_buffer_automatic_)
    return MPI_BUFFER_AUTOMATIC;
  return p;
}

// The reverse direction, and the only one. MPI-5.0 section 3.6 on the three
// detach procedures: "If MPI_BUFFER_AUTOMATIC was used in the corresponding
// attach procedure, then MPI_BUFFER_AUTOMATIC is also returned in the detach
// procedure ... When using Fortran mpi_f08, the returned value is identical to
// c_loc(MPI_BUFFER_AUTOMATIC)." So what MPI writes back has to become the
// Fortran object's address before the caller sees it.
static inline const void *mpif_f_buffer_addr(const void *p) {
  if (p == MPI_BUFFER_AUTOMATIC)
    return (const void *)mpif_buffer_automatic_;
  return p;
}

// All four status cells, not two. The f08 wrappers forward TYPE(MPI_Status) to
// the same C entry points mpif.h reaches through mpif_f08_raw, so `status` may be
// either interface's object. All four are null in the ABI, so one function
// checking all four is exactly equivalent to a scalar/array pair that only looked
// stricter -- and MPI-5.0 section 3.2.6 is what lets the Fortran and C values
// differ in the first place.
static inline MPI_Status *mpif_c_status(void *p) {
  if (p == (const void *)mpif_status_ignore_ ||
      p == (const void *)mpif_f08_status_ignore_)
    return MPI_STATUS_IGNORE;
  if (p == (const void *)mpif_statuses_ignore_ ||
      p == (const void *)mpif_f08_statuses_ignore_)
    return MPI_STATUSES_IGNORE;
  return (MPI_Status *)p;
}

static inline const MPI_Status *mpif_c_cstatus(const void *p) {
  return mpif_c_status((void *)p);
}

// MPI_UNWEIGHTED and MPI_WEIGHTS_EMPTY, on the three routines that take weights
// and the one that returns them -- MPI_Dist_graph_neighbors' weight arguments are
// OUT and still carry an IN sentinel, MPI-5.0 section 8.5.5: "If MPI_UNWEIGHTED
// is supplied for sourceweights or destweights or both ... then no weight
// information is returned in that array."
static inline MPI_Fint *mpif_c_weights(MPI_Fint *p) {
  if (p == (const MPI_Fint *)mpif_unweighted_)
    return (MPI_Fint *)MPI_UNWEIGHTED;
  if (p == (const MPI_Fint *)mpif_weights_empty_)
    return (MPI_Fint *)MPI_WEIGHTS_EMPTY;
  return p;
}

static inline const MPI_Fint *mpif_c_cweights(const MPI_Fint *p) {
  return mpif_c_weights((MPI_Fint *)p);
}

// MPI_Comm_spawn's and MPI_Comm_spawn_multiple's array_of_errcodes. MPI writes
// maxprocs of them, so a missed translation here is an overrun rather than a
// wrong value.
static inline MPI_Fint *mpif_c_errcodes(MPI_Fint *p) {
  if (p == (const MPI_Fint *)mpif_errcodes_ignore_)
    return (MPI_Fint *)MPI_ERRCODES_IGNORE;
  return p;
}

// The two argument-vector sentinels are predicates rather than translations: an
// argument vector is converted element by element, so the wrapper has to skip the
// conversion entirely and substitute the C constant, not map an address. Both are
// null pointers in C, which is why the conversion would otherwise read through
// address zero.
static inline int mpif_is_argv_null(const void *p) {
  return p == (const void *)mpif_argv_null_;
}

static inline int mpif_is_argvs_null(const void *p) {
  return p == (const void *)mpif_argvs_null_;
}

#endif // #ifndef MPIF_SENTINELS_H
