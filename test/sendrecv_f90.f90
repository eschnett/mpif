program sendrecv_f90
  use mpi
  implicit none

  integer :: send, received
  integer :: status(MPI_STATUS_SIZE)
  integer :: ierror

  call MPI_Init(ierror)

  send = 42
  received = -1
  call MPI_Sendrecv(send, 1, MPI_INTEGER, 0, 0, received, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, status, ierror)

  if (received /= send) stop 1

  call MPI_Finalize(ierror)

end program sendrecv_f90
