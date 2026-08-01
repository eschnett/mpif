module mpi
  use mpif_constants
  use mpif_types
  use mpif_functions
  use mpif_cptr

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

end module mpi
