program sendrecv_f08
  use mpi_f08
  implicit none

  integer :: send, received
  type(MPI_Status) :: status

  call MPI_Init()

  send = 42
  received = -1
  call MPI_Sendrecv(send, 1, MPI_INTEGER, 0, 0, received, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, status)

  if (received /= send) stop 1

  call MPI_Finalize()

end program sendrecv_f08
