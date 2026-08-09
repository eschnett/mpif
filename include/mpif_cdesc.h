// The descriptor side of the TS 29113 choice buffers: what the generated
// cdesc entry points of gen/mpif_f08_cdesc.c share. Compiled only where the
// CMake probe set MPIF_HAVE_CFI; on the fallback branch mpi_f08 keeps the
// ignore_tkr buffers and nothing includes this.

#ifndef MPIF_CDESC_H
#define MPIF_CDESC_H

#ifdef MPIF_HAVE_CFI

#include <ISO_Fortran_binding.h>
#include <mpi.h>

// A derived datatype describing what `cdesc` holds `oldcount` elements of
// `oldtype` in, for a descriptor that is not contiguous: the caller passes
// the new type with count 1 where it would have passed (oldcount, oldtype),
// and frees it right after the call -- legal even for a nonblocking one,
// the request holding its own reference. Returns MPI_SUCCESS or the error
// class to hand the caller; on error *newtype is untouched.
int mpif_cdesc_create_datatype(const CFI_cdesc_t *cdesc, MPI_Count oldcount,
                               MPI_Datatype oldtype, MPI_Datatype *newtype);

// The buffer sentinels, by address. src/mpif_constants.c points the Fortran
// MPI_BOTTOM, MPI_IN_PLACE and MPI_BUFFER_AUTOMATIC at the C constants
// themselves -- (void*)0, 1 and 2 in the standard ABI -- so the base_addr of
// a sentinel actual argument *is* the C sentinel and passes through
// unchanged; the only thing a cdesc entry must do is not walk it.
static inline int mpif_cdesc_is_sentinel(const void *p) {
  return p == MPI_BOTTOM || p == MPI_IN_PLACE || p == MPI_BUFFER_AUTOMATIC;
}

#endif

#endif
