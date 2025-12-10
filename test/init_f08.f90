program init_f08
  use mpi_f08
  implicit none

  logical :: initialized, finalized

  call MPI_Initialized(initialized)
  if (initialized) stop 1
  call MPI_Finalized(finalized)
  if (finalized) stop 1

  call MPI_Init()

  call MPI_Initialized(initialized)
  if (.not.initialized) stop 1
  call MPI_Finalized(finalized)
  if (finalized) stop 1

  call MPI_Finalize()

  call MPI_Initialized(initialized)
  call MPI_Finalized(finalized)
  if (.not.finalized) stop 1

end program init_f08
