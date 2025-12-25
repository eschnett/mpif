program inplace_f08
  use mpi_f08
  implicit none

  integer :: rank, size
  integer :: sum

  call MPI_Init()

  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)

  sum = rank
  call MPI_Allreduce(MPI_IN_PLACE, sum, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD)
  if (sum /= (size - 1) * size / 2) stop 1

  call MPI_Finalize()
end program inplace_f08
