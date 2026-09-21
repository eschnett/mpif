! The Fortran half of src/mpif_removed.c: the ten MPI-1 routines MPI-3.0
! removed, named so that a compiler that understands `!GCC$ ATTRIBUTES
! DEPRECATED` can say so at the call site. See "Deprecation warnings" in
! CODE.md.
!
! EXTERNAL and not an interface block, deliberately. These routines are
! reachable today because Fortran lets a program call an undeclared external
! procedure, and their arguments are wrong in the way that got them removed --
! displacements, extents and addresses as default INTEGERs. An interface block
! would start type-checking calls that compile everywhere else, which is the
! opposite of why src/mpif_removed.c exists; EXTERNAL declares the name and
! leaves the interface implicit, so the only thing that changes is that the
! attribute has something to attach to.
!
! Only `mpi` uses this module, not `mpi_f08`: these take INTEGER handles, and
! MPI-3.0 removed them before mpi_f08 could have offered them. An mpi_f08
! program can still reach them as undeclared externals, exactly as it can now,
! and gets no warning -- see MISSING.md.

module mpif_removed
  implicit none
  public
  save

  ! MPI_TYPE_HVECTOR, MPI_TYPE_HINDEXED and MPI_TYPE_STRUCT -> the
  ! MPI_TYPE_CREATE_ forms, whose byte displacements are
  ! INTEGER(KIND=MPI_ADDRESS_KIND).
  external :: MPI_Type_hvector, PMPI_Type_hvector
  external :: MPI_Type_hindexed, PMPI_Type_hindexed
  external :: MPI_Type_struct, PMPI_Type_struct

  ! MPI_ADDRESS -> MPI_GET_ADDRESS.
  external :: MPI_Address, PMPI_Address

  ! MPI_TYPE_EXTENT, MPI_TYPE_LB and MPI_TYPE_UB -> MPI_TYPE_GET_EXTENT.
  external :: MPI_Type_extent, PMPI_Type_extent
  external :: MPI_Type_lb, PMPI_Type_lb
  external :: MPI_Type_ub, PMPI_Type_ub

  ! MPI_ERRHANDLER_CREATE, _SET and _GET -> the MPI_COMM_ forms.
  external :: MPI_Errhandler_create, PMPI_Errhandler_create
  external :: MPI_Errhandler_set, PMPI_Errhandler_set
  external :: MPI_Errhandler_get, PMPI_Errhandler_get

#ifdef MPIF_HAVE_DEPRECATED_ATTRIBUTE
  ! Removed in MPI-3.0 and outside the MPI-5.0 ABI; mpif keeps them and
  ! forwards to the replacements named above. See CODE.md.
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Type_hvector
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Type_hvector
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Type_hindexed
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Type_hindexed
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Type_struct
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Type_struct
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Address
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Address
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Type_extent
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Type_extent
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Type_lb
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Type_lb
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Type_ub
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Type_ub
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Errhandler_create
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Errhandler_create
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Errhandler_set
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Errhandler_set
!GCC$ ATTRIBUTES DEPRECATED :: MPI_Errhandler_get
!GCC$ ATTRIBUTES DEPRECATED :: PMPI_Errhandler_get
#endif
end module mpif_removed
