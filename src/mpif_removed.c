// MPI-1 routines that the standard has removed.
//
// MPI-2.0 deprecated these and MPI-4.0 removed them, so they are absent from the
// ABI: its rationale is that keeping deprecated features would make deleting
// them later an ABI break, so they were left out from the start. mpif therefore
// cannot forward them, and the generator does not know about them at all --
// `apis.json` describes the current standard.
//
// They are defined here anyway, for the same reason as the deprecated combiner
// constants in include/mpif_constants.h: legacy Fortran still calls them, both
// MPICH and Open MPI still provide them, and code that compiles everywhere else
// should compile here. Each is a thin layer over its replacement.
//
// The reason all of these were deprecated is that they describe displacements,
// extents and addresses as default INTEGERs. On a 64-bit platform an address
// does not fit -- on arm64 macOS a stack address is around 0x16d000000, well
// past INT_MAX -- so the values below are truncated. That is not a defect
// introduced here: it is the deficiency that got the routines removed, and every
// implementation that still offers them truncates identically. Truncation is
// silent rather than an error because the usual idiom survives it: code calls
// MPI_ADDRESS on two objects and subtracts, and the difference is correct modulo
// 2^32 as long as the objects are less than 2 GiB apart.
//
// Fortran calling convention as elsewhere in mpif: lowercase name with a
// trailing underscore, every argument by reference, handles as default INTEGERs.

#include <mpi.h>

#include <stddef.h>
#include <stdint.h>

// Handle conversions.
//
// These have to short-circuit predefined handles the way the generated
// MPIF_Type_fromint and MPIF_Type_toint do, because some implementations
// mishandle them -- forwarding MPI_INTEGER straight to MPI_Type_fromint yields
// an invalid datatype, the constructor below then fails, and converting the
// resulting garbage back aborts inside MPI_Type_toint. Every predefined handle
// the ABI defines is a small integer, well below the addresses a real handle
// carries, so a range test covers them all without enumerating them, and keeps
// working as the ABI adds more.
//
// TODO: the generator should emit its helpers into a shared header so this file
// can include them instead; see MISSING.md section 1a.

enum { MPIF_PREDEFINED_HANDLE_MAX = 0x1000 };

static MPI_Datatype type_fromint(MPI_Fint datatype) {
  if ((uintptr_t)(intptr_t)datatype < MPIF_PREDEFINED_HANDLE_MAX)
    return (MPI_Datatype)(intptr_t)datatype;
  return MPI_Type_fromint(datatype);
}

static MPI_Fint type_toint(MPI_Datatype datatype) {
  if ((uintptr_t)datatype < MPIF_PREDEFINED_HANDLE_MAX)
    return (MPI_Fint)(intptr_t)datatype;
  return MPI_Type_toint(datatype);
}

// MPI_TYPE_HVECTOR -> MPI_TYPE_CREATE_HVECTOR
// MPI_TYPE_HINDEXED -> MPI_TYPE_CREATE_HINDEXED
// MPI_TYPE_STRUCT -> MPI_TYPE_CREATE_STRUCT
//
// Only the byte displacements changed type, from INTEGER to
// INTEGER(KIND=MPI_ADDRESS_KIND); the block counts were always INTEGERs.

void mpi_type_hvector_(const MPI_Fint *count, const MPI_Fint *blocklength,
                       const MPI_Fint *stride, const MPI_Fint *oldtype,
                       MPI_Fint *newtype, MPI_Fint *ierror) {
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_hvector(*count, *blocklength, (MPI_Aint)*stride,
                                    type_fromint(*oldtype), &c_newtype);
  // Only convert on success: on failure c_newtype holds nothing meaningful, and
  // MPI_Type_toint aborts when handed an invalid datatype.
  *newtype = *ierror == MPI_SUCCESS ? type_toint(c_newtype)
                                    : (MPI_Fint)(intptr_t)MPI_DATATYPE_NULL;
}

void mpi_type_hindexed_(const MPI_Fint *count,
                        const MPI_Fint *array_of_blocklengths,
                        const MPI_Fint *array_of_displacements,
                        const MPI_Fint *oldtype, MPI_Fint *newtype,
                        MPI_Fint *ierror) {
  MPI_Aint c_displacements[*count];
  for (int i = 0; i < *count; ++i)
    c_displacements[i] = (MPI_Aint)array_of_displacements[i];
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_hindexed(*count, array_of_blocklengths,
                                     c_displacements, type_fromint(*oldtype),
                                     &c_newtype);
  // Only convert on success: on failure c_newtype holds nothing meaningful, and
  // MPI_Type_toint aborts when handed an invalid datatype.
  *newtype = *ierror == MPI_SUCCESS ? type_toint(c_newtype)
                                    : (MPI_Fint)(intptr_t)MPI_DATATYPE_NULL;
}

void mpi_type_struct_(const MPI_Fint *count,
                      const MPI_Fint *array_of_blocklengths,
                      const MPI_Fint *array_of_displacements,
                      const MPI_Fint *array_of_types, MPI_Fint *newtype,
                      MPI_Fint *ierror) {
  MPI_Aint c_displacements[*count];
  MPI_Datatype c_types[*count];
  for (int i = 0; i < *count; ++i) {
    c_displacements[i] = (MPI_Aint)array_of_displacements[i];
    c_types[i] = type_fromint(array_of_types[i]);
  }
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_struct(*count, array_of_blocklengths,
                                   c_displacements, c_types, &c_newtype);
  // Only convert on success: on failure c_newtype holds nothing meaningful, and
  // MPI_Type_toint aborts when handed an invalid datatype.
  *newtype = *ierror == MPI_SUCCESS ? type_toint(c_newtype)
                                    : (MPI_Fint)(intptr_t)MPI_DATATYPE_NULL;
}

// MPI_ADDRESS -> MPI_GET_ADDRESS
//
// `location` is a choice buffer, so it arrives as a bare address.

void mpi_address_(const void *location, MPI_Fint *address, MPI_Fint *ierror) {
  MPI_Aint c_address;
  *ierror = MPI_Get_address(location, &c_address);
  *address = (MPI_Fint)c_address;
}

// MPI_TYPE_EXTENT, MPI_TYPE_LB and MPI_TYPE_UB -> MPI_TYPE_GET_EXTENT
//
// The MPI-1 routines predate the distinction between the true extent and the
// extent with padding, and there was never an MPI_TYPE_GET_UB: the upper bound
// is the lower bound plus the extent.

void mpi_type_extent_(const MPI_Fint *datatype, MPI_Fint *extent,
                      MPI_Fint *ierror) {
  MPI_Aint lb, c_extent;
  *ierror = MPI_Type_get_extent(type_fromint(*datatype), &lb, &c_extent);
  *extent = (MPI_Fint)c_extent;
}

void mpi_type_lb_(const MPI_Fint *datatype, MPI_Fint *displacement,
                  MPI_Fint *ierror) {
  MPI_Aint lb, extent;
  *ierror = MPI_Type_get_extent(type_fromint(*datatype), &lb, &extent);
  *displacement = (MPI_Fint)lb;
}

void mpi_type_ub_(const MPI_Fint *datatype, MPI_Fint *displacement,
                  MPI_Fint *ierror) {
  MPI_Aint lb, extent;
  *ierror = MPI_Type_get_extent(type_fromint(*datatype), &lb, &extent);
  *displacement = (MPI_Fint)(lb + extent);
}

// MPI_ERRHANDLER_CREATE -> MPI_COMM_CREATE_ERRHANDLER
// MPI_ERRHANDLER_SET -> MPI_COMM_SET_ERRHANDLER
// MPI_ERRHANDLER_GET -> MPI_COMM_GET_ERRHANDLER
//
// MPI_Handler_function was removed with them; it is the same signature as
// MPI_Comm_errhandler_function, so the trampoline pool in src/mpif_callbacks.c
// serves this too.

#include <mpif_callbacks.h>

// TODO: share these with the generated wrappers instead of repeating them; see
// MISSING.md section 1a.
static MPI_Comm comm_fromint(MPI_Fint comm) {
  switch (comm) {
  case (MPI_Fint)(intptr_t)MPI_COMM_NULL:
  case (MPI_Fint)(intptr_t)MPI_COMM_WORLD:
  case (MPI_Fint)(intptr_t)MPI_COMM_SELF:
    return (MPI_Comm)(intptr_t)comm;
  }
  return MPI_Comm_fromint(comm);
}

void mpi_errhandler_create_(void (*function)(void), MPI_Fint *errhandler,
                            MPI_Fint *ierror) {
  int slot;
  void *const c_function = mpif_errhandler_reserve(
      (mpif_fortran_procedure)function, MPIF_ERRHANDLER_COMM, &slot);
  if (!c_function) {
    *ierror = MPI_ERR_OTHER;
    return;
  }
  MPI_Errhandler c_errhandler;
  *ierror = MPI_Comm_create_errhandler(
      (MPI_Comm_errhandler_function *)c_function, &c_errhandler);
  if (*ierror == MPI_SUCCESS)
    *errhandler = MPI_Errhandler_toint(c_errhandler);
  else
    mpif_errhandler_cancel(slot);
}

void mpi_errhandler_set_(const MPI_Fint *comm, const MPI_Fint *errhandler,
                         MPI_Fint *ierror) {
  *ierror = MPI_Comm_set_errhandler(comm_fromint(*comm),
                                    MPI_Errhandler_fromint(*errhandler));
}

void mpi_errhandler_get_(const MPI_Fint *comm, MPI_Fint *errhandler,
                         MPI_Fint *ierror) {
  MPI_Errhandler c_errhandler;
  *ierror = MPI_Comm_get_errhandler(comm_fromint(*comm), &c_errhandler);
  *errhandler = MPI_Errhandler_toint(c_errhandler);
}
