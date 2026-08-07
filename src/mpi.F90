module mpi
  use mpif_constants
  use mpif_types
  use mpif_functions
  use mpif_cptr
  use mpif_attr_fns
  use mpif_check_fns

  ! MPI-5.0 section 19.1.3 requires the mpi module to "Define the derived type
  ! MPI_Status and all named handle types that are used in the mpi_f08 module",
  ! with .EQ. and .NE. overloaded on the handle types, and A.5.13 gives
  ! MPI_Status_f2f08 and MPI_Status_f082f Fortran bindings marked "not available
  ! with mpif.h" -- the only two A.5 names so marked, which is to say required
  ! here and exempt only for the include file. mpif_handle_types holds all of it,
  ! and mpif_f08_types uses the same module, so the types are one set rather than
  ! two; see the comment there for why it sits below both.
  !
  ! The handle *constants* are not affected: MPI_COMM_WORLD in this module stays
  ! the INTEGER parameter from mpif_constants, and only mpi_f08 has the
  ! TYPE(MPI_Comm) one.
  use mpif_handle_types

  implicit none
  public
  save

  ! Gather each address-kind specific from mpif_functions together with its
  ! TYPE(C_PTR) overload from mpif_cptr, which is the generic MPI-5.0 requires the
  ! mpi module to provide. The generics have to be declared here, where both
  ! halves are visible: one inside mpif_cptr would shadow the use-associated
  ! specific rather than extend it, and one in each of two modules is an ambiguous
  ! reference at the point of use.
  !
  ! Naming a generic after one of its own specifics is deliberate, and is what the
  ! standard's own interface block for MPI_ALLOC_MEM does.

  interface MPI_Alloc_mem
     procedure MPI_Alloc_mem
     procedure MPI_Alloc_mem_cptr
  end interface MPI_Alloc_mem

  interface MPI_Win_allocate
     procedure MPI_Win_allocate
     procedure MPI_Win_allocate_cptr
  end interface MPI_Win_allocate

  interface MPI_Win_allocate_c
     procedure MPI_Win_allocate_c
     procedure mpif_win_allocate_c_cptr
  end interface MPI_Win_allocate_c

  interface MPI_Win_allocate_shared
     procedure MPI_Win_allocate_shared
     procedure MPI_Win_allocate_shared_cptr
  end interface MPI_Win_allocate_shared

  interface MPI_Win_allocate_shared_c
     procedure MPI_Win_allocate_shared_c
     procedure mpif_win_allocate_shared_c_cptr
  end interface MPI_Win_allocate_shared_c

  interface MPI_Win_shared_query
     procedure MPI_Win_shared_query
     procedure MPI_Win_shared_query_cptr
  end interface MPI_Win_shared_query

  interface MPI_Win_shared_query_c
     procedure MPI_Win_shared_query_c
     procedure mpif_win_shared_query_c_cptr
  end interface MPI_Win_shared_query_c

  ! And the same seven for the PMPI names, MPI-5.0 section 15.2 asking for a
  ! P-prefixed second procedure for every MPI procedure. A profiling layer that
  ! intercepts a call written against the generic has to be able to make the same
  ! call through PMPI, TYPE(C_PTR) actual argument and all.

  interface PMPI_Alloc_mem
     procedure PMPI_Alloc_mem
     procedure PMPI_Alloc_mem_cptr
  end interface PMPI_Alloc_mem

  interface PMPI_Win_allocate
     procedure PMPI_Win_allocate
     procedure PMPI_Win_allocate_cptr
  end interface PMPI_Win_allocate

  interface PMPI_Win_allocate_c
     procedure PMPI_Win_allocate_c
     procedure mpif_pwin_allocate_c_cptr
  end interface PMPI_Win_allocate_c

  interface PMPI_Win_allocate_shared
     procedure PMPI_Win_allocate_shared
     procedure PMPI_Win_allocate_shared_cptr
  end interface PMPI_Win_allocate_shared

  interface PMPI_Win_allocate_shared_c
     procedure PMPI_Win_allocate_shared_c
     procedure mpif_pwin_allocate_shared_c_cptr
  end interface PMPI_Win_allocate_shared_c

  interface PMPI_Win_shared_query
     procedure PMPI_Win_shared_query
     procedure PMPI_Win_shared_query_cptr
  end interface PMPI_Win_shared_query

  interface PMPI_Win_shared_query_c
     procedure PMPI_Win_shared_query_c
     procedure mpif_pwin_shared_query_c_cptr
  end interface PMPI_Win_shared_query_c

end module mpi
