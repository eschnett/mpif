program comm_f08
  use mpi_f08
  implicit none

  integer :: size, rank

  call MPI_Init()

  call MPI_Comm_size(MPI_COMM_WORLD, size)
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)

  if (size < 1) stop 1
  if (rank < 0 .or. rank >= size) stop 1

  call MPI_Finalize()

end program comm_f08
