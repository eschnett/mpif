module mpi_f08_functions
  use mpi, only: &
    MPIF_Init => MPI_Init, &
    MPI_VERSION
  implicit none
  private
  save

  public :: MPI_Init

contains

  subroutine MPI_Init( &
  )
    use mpi_constants
    implicit none
  end subroutine MPI_Init

end module mpi_f08_functions
