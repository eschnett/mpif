module mpi_functions
  implicit none
  public
  save

  interface

  subroutine MPI_Init( &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: argc
    integer :: ierror
  end subroutine MPI_Init

  end interface

end module mpi_functions
