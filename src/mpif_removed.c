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
//
// Each routine appears under two names, `mpi_type_hvector_` and
// `pmpi_type_hvector_`: MPI-5.0 section 15.2 asks for a P-prefixed second entry
// point for every MPI procedure, and MPICH's own binding provides all ten of
// these. Unlike the Fortran callbacks in src/mpif_attr_fns.F90, the P form here
// cannot forward to its twin, because which C entry point is called is the whole
// difference between them -- and forwarding to the twin's *Fortran* symbol would
// be worse than useless, landing in whatever a profiling layer had put there.
// So each body is written once as a macro over the Fortran symbol name and the C
// entry point, and instantiated twice.
//
// The MPIF-SPLIT markers around each instantiation are what
// ci-scripts/split-wrappers.sh cuts on, exactly as in gen/mpif_functions.c: a
// static build compiles each MPI_ entry point as a translation unit of its own.
// The macros and the two #includes fall outside every marked region, which is
// how they become the prologue every part gets a copy of.

#include <mpif_sentinels.h>

#include <mpi.h>

#include <stddef.h>
#include <stdint.h>

// MPI_TYPE_HVECTOR -> MPI_TYPE_CREATE_HVECTOR
// MPI_TYPE_HINDEXED -> MPI_TYPE_CREATE_HINDEXED
// MPI_TYPE_STRUCT -> MPI_TYPE_CREATE_STRUCT
//
// Only the byte displacements changed type, from INTEGER to
// INTEGER(KIND=MPI_ADDRESS_KIND); the block counts were always INTEGERs.

// Only convert on success: on failure c_newtype holds nothing meaningful, and
// MPI_Type_toint aborts when handed an invalid datatype.
#define MPIF_NEWTYPE_ON_SUCCESS                                                \
  *newtype = *ierror == MPI_SUCCESS ? MPI_Type_toint(c_newtype)                \
                                    : (MPI_Fint)(intptr_t)MPI_DATATYPE_NULL

#define MPIF_DEFINE_TYPE_HVECTOR(fname, type_create_hvector)                   \
  void fname(const MPI_Fint *count, const MPI_Fint *blocklength,               \
             const MPI_Fint *stride, const MPI_Fint *oldtype,                  \
             MPI_Fint *newtype, MPI_Fint *ierror) {                            \
    MPI_Datatype c_newtype;                                                    \
    *ierror = type_create_hvector(*count, *blocklength, (MPI_Aint)*stride,      \
                                  MPI_Type_fromint(*oldtype), &c_newtype);     \
    MPIF_NEWTYPE_ON_SUCCESS;                                                   \
  }

// MPIF-SPLIT-BEGIN mpi_type_hvector_
MPIF_DEFINE_TYPE_HVECTOR(mpi_type_hvector_, MPI_Type_create_hvector)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_type_hvector_
MPIF_DEFINE_TYPE_HVECTOR(pmpi_type_hvector_, PMPI_Type_create_hvector)
// MPIF-SPLIT-END

#define MPIF_DEFINE_TYPE_HINDEXED(fname, type_create_hindexed)                 \
  void fname(const MPI_Fint *count, const MPI_Fint *array_of_blocklengths,     \
             const MPI_Fint *array_of_displacements, const MPI_Fint *oldtype,  \
             MPI_Fint *newtype, MPI_Fint *ierror) {                            \
    MPI_Aint c_displacements[*count > 0 ? *count : 1];                         \
    for (int i = 0; i < *count; ++i)                                           \
      c_displacements[i] = (MPI_Aint)array_of_displacements[i];                \
    MPI_Datatype c_newtype;                                                    \
    *ierror =                                                                  \
        type_create_hindexed(*count, array_of_blocklengths, c_displacements,   \
                             MPI_Type_fromint(*oldtype), &c_newtype);          \
    MPIF_NEWTYPE_ON_SUCCESS;                                                   \
  }

// MPIF-SPLIT-BEGIN mpi_type_hindexed_
MPIF_DEFINE_TYPE_HINDEXED(mpi_type_hindexed_, MPI_Type_create_hindexed)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_type_hindexed_
MPIF_DEFINE_TYPE_HINDEXED(pmpi_type_hindexed_, PMPI_Type_create_hindexed)
// MPIF-SPLIT-END

#define MPIF_DEFINE_TYPE_STRUCT(fname, type_create_struct)                     \
  void fname(const MPI_Fint *count, const MPI_Fint *array_of_blocklengths,     \
             const MPI_Fint *array_of_displacements,                           \
             const MPI_Fint *array_of_types, MPI_Fint *newtype,                \
             MPI_Fint *ierror) {                                               \
    MPI_Aint c_displacements[*count > 0 ? *count : 1];                         \
    MPI_Datatype c_types[*count > 0 ? *count : 1];                             \
    for (int i = 0; i < *count; ++i) {                                         \
      c_displacements[i] = (MPI_Aint)array_of_displacements[i];                \
      c_types[i] = MPI_Type_fromint(array_of_types[i]);                        \
    }                                                                          \
    MPI_Datatype c_newtype;                                                    \
    *ierror = type_create_struct(*count, array_of_blocklengths,                \
                                 c_displacements, c_types, &c_newtype);        \
    MPIF_NEWTYPE_ON_SUCCESS;                                                   \
  }

// MPIF-SPLIT-BEGIN mpi_type_struct_
MPIF_DEFINE_TYPE_STRUCT(mpi_type_struct_, MPI_Type_create_struct)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_type_struct_
MPIF_DEFINE_TYPE_STRUCT(pmpi_type_struct_, PMPI_Type_create_struct)
// MPIF-SPLIT-END

// MPI_ADDRESS -> MPI_GET_ADDRESS
//
// `location` is a choice buffer, so it arrives as a bare address -- and so it may
// be MPI_BOTTOM, which has to be translated exactly as the generated
// MPI_Get_address translates it, or the removed routine and its replacement
// disagree about what MPI_ADDRESS(MPI_BOTTOM, ...) returns. MPI-5.0 2.5.6 wants
// zero there, absolute addresses being "displacements relative to address zero",
// which is what handing MPI the ABI's (void*)0 produces.
//
// This is the only hand-written entry point that takes a choice buffer; see
// include/mpif_sentinels.h for the rest.

#define MPIF_DEFINE_ADDRESS(fname, get_address)                                \
  void fname(const void *location, MPI_Fint *address, MPI_Fint *ierror) {      \
    MPI_Aint c_address;                                                        \
    *ierror = get_address(mpif_c_cbuffer(location), &c_address);               \
    *address = (MPI_Fint)c_address;                                            \
  }

// MPIF-SPLIT-BEGIN mpi_address_
MPIF_DEFINE_ADDRESS(mpi_address_, MPI_Get_address)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_address_
MPIF_DEFINE_ADDRESS(pmpi_address_, PMPI_Get_address)
// MPIF-SPLIT-END

// MPI_TYPE_EXTENT, MPI_TYPE_LB and MPI_TYPE_UB -> MPI_TYPE_GET_EXTENT
//
// The MPI-1 routines predate the distinction between the true extent and the
// extent with padding, and there was never an MPI_TYPE_GET_UB: the upper bound
// is the lower bound plus the extent.

#define MPIF_DEFINE_TYPE_EXTENT(fname, type_get_extent)                        \
  void fname(const MPI_Fint *datatype, MPI_Fint *extent, MPI_Fint *ierror) {   \
    MPI_Aint lb, c_extent;                                                     \
    *ierror = type_get_extent(MPI_Type_fromint(*datatype), &lb, &c_extent);    \
    *extent = (MPI_Fint)c_extent;                                              \
  }

// MPIF-SPLIT-BEGIN mpi_type_extent_
MPIF_DEFINE_TYPE_EXTENT(mpi_type_extent_, MPI_Type_get_extent)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_type_extent_
MPIF_DEFINE_TYPE_EXTENT(pmpi_type_extent_, PMPI_Type_get_extent)
// MPIF-SPLIT-END

#define MPIF_DEFINE_TYPE_LB(fname, type_get_extent)                            \
  void fname(const MPI_Fint *datatype, MPI_Fint *displacement,                 \
             MPI_Fint *ierror) {                                               \
    MPI_Aint lb, extent;                                                       \
    *ierror = type_get_extent(MPI_Type_fromint(*datatype), &lb, &extent);      \
    *displacement = (MPI_Fint)lb;                                              \
  }

// MPIF-SPLIT-BEGIN mpi_type_lb_
MPIF_DEFINE_TYPE_LB(mpi_type_lb_, MPI_Type_get_extent)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_type_lb_
MPIF_DEFINE_TYPE_LB(pmpi_type_lb_, PMPI_Type_get_extent)
// MPIF-SPLIT-END

#define MPIF_DEFINE_TYPE_UB(fname, type_get_extent)                            \
  void fname(const MPI_Fint *datatype, MPI_Fint *displacement,                 \
             MPI_Fint *ierror) {                                               \
    MPI_Aint lb, extent;                                                       \
    *ierror = type_get_extent(MPI_Type_fromint(*datatype), &lb, &extent);      \
    *displacement = (MPI_Fint)(lb + extent);                                   \
  }

// MPIF-SPLIT-BEGIN mpi_type_ub_
MPIF_DEFINE_TYPE_UB(mpi_type_ub_, MPI_Type_get_extent)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_type_ub_
MPIF_DEFINE_TYPE_UB(pmpi_type_ub_, PMPI_Type_get_extent)
// MPIF-SPLIT-END

// MPI_ERRHANDLER_CREATE -> MPI_COMM_CREATE_ERRHANDLER
// MPI_ERRHANDLER_SET -> MPI_COMM_SET_ERRHANDLER
// MPI_ERRHANDLER_GET -> MPI_COMM_GET_ERRHANDLER
//
// MPI_Handler_function was removed with them; it is the same signature as
// MPI_Comm_errhandler_function, so the trampoline pool in src/mpif_callbacks.c
// serves this too. The pool is shared between the two copies, as every registry
// in mpif is: a program may create an errhandler through one name and set it
// through the other, and must not be able to tell.

#include <mpif_callbacks.h>

#define MPIF_DEFINE_ERRHANDLER_CREATE(fname, comm_create_errhandler)           \
  void fname(void (*function)(void), MPI_Fint *errhandler, MPI_Fint *ierror) { \
    int slot;                                                                  \
    void *const c_function = mpif_errhandler_reserve(                          \
        (mpif_fortran_procedure)function, MPIF_ERRHANDLER_COMM, &slot);        \
    if (!c_function) {                                                         \
      *ierror = MPI_ERR_OTHER;                                                 \
      return;                                                                  \
    }                                                                          \
    MPI_Errhandler c_errhandler;                                               \
    *ierror = comm_create_errhandler(                                          \
        (MPI_Comm_errhandler_function *)c_function, &c_errhandler);            \
    if (*ierror == MPI_SUCCESS)                                                \
      *errhandler = MPI_Errhandler_toint(c_errhandler);                        \
    else                                                                       \
      mpif_errhandler_cancel(slot);                                            \
  }

// MPIF-SPLIT-BEGIN mpi_errhandler_create_
MPIF_DEFINE_ERRHANDLER_CREATE(mpi_errhandler_create_,
                              MPI_Comm_create_errhandler)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_errhandler_create_
MPIF_DEFINE_ERRHANDLER_CREATE(pmpi_errhandler_create_,
                              PMPI_Comm_create_errhandler)
// MPIF-SPLIT-END

#define MPIF_DEFINE_ERRHANDLER_SET(fname, comm_set_errhandler)                 \
  void fname(const MPI_Fint *comm, const MPI_Fint *errhandler,                 \
             MPI_Fint *ierror) {                                               \
    *ierror = comm_set_errhandler(MPI_Comm_fromint(*comm),                     \
                                  MPI_Errhandler_fromint(*errhandler));        \
  }

// MPIF-SPLIT-BEGIN mpi_errhandler_set_
MPIF_DEFINE_ERRHANDLER_SET(mpi_errhandler_set_, MPI_Comm_set_errhandler)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_errhandler_set_
MPIF_DEFINE_ERRHANDLER_SET(pmpi_errhandler_set_, PMPI_Comm_set_errhandler)
// MPIF-SPLIT-END

#define MPIF_DEFINE_ERRHANDLER_GET(fname, comm_get_errhandler)                 \
  void fname(const MPI_Fint *comm, MPI_Fint *errhandler, MPI_Fint *ierror) {   \
    /* Initialised for the failure path, on which the conversion below runs    \
       anyway; MPI_Errhandler_toint on an unwritten temporary may abort, as    \
       MPIF_NEWTYPE_ON_SUCCESS records for datatypes. The generated wrappers   \
       initialise their out-handle temporaries the same way. */                \
    MPI_Errhandler c_errhandler = MPI_ERRHANDLER_NULL;                         \
    *ierror = comm_get_errhandler(MPI_Comm_fromint(*comm), &c_errhandler);     \
    *errhandler = MPI_Errhandler_toint(c_errhandler);                          \
  }

// MPIF-SPLIT-BEGIN mpi_errhandler_get_
MPIF_DEFINE_ERRHANDLER_GET(mpi_errhandler_get_, MPI_Comm_get_errhandler)
// MPIF-SPLIT-END
// MPIF-SPLIT-BEGIN pmpi_errhandler_get_
MPIF_DEFINE_ERRHANDLER_GET(pmpi_errhandler_get_, PMPI_Comm_get_errhandler)
// MPIF-SPLIT-END
