module mpi_f08_functions
  use mpi, only: &
       MPIF_Init => MPI_Init, &
       MPIF_Finalize => MPI_Finalize
  implicit none
  private
  save

  public :: MPI_Init

contains

  subroutine MPI_Init(ierror)
    integer, optional, intent(out) :: ierror
    integer :: ierror1
    call MPIF_Init(ierror1)
    if (present(ierror)) ierror = ierror1
  end subroutine MPI_Init

  subroutine MPI_Finalize(ierror)
    integer, optional, intent(out) :: ierror
    integer :: ierror1
    call MPIF_Finalize(ierror1)
    if (present(ierror)) ierror = ierror1
  end subroutine MPI_Finalize

end module mpi_f08_functions
