program inplace_f90
  use mpi
  implicit none

  integer :: rank, size
  integer :: sum
  integer :: ierror

  call MPI_Init(ierror)

  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)
  call MPI_Comm_size(MPI_COMM_WORLD, size, ierror)

  sum = rank
  call MPI_Allreduce(MPI_IN_PLACE, sum, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD, ierror)
  if (sum /= (size - 1) * size / 2) stop 1

  call MPI_Finalize(ierror)
end program inplace_f90
