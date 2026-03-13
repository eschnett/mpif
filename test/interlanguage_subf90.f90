subroutine subf90(comm, crank, csize, status)
  use mpi
  implicit none
  integer comm, crank, csize
  integer rank, size
  integer sendbuf, recvbuf
  integer status(MPI_STATUS_SIZE)
  integer ierr

  call MPI_Comm_rank(comm, rank, ierr)
  call MPI_Comm_size(comm, size, ierr)
  print '("Interlanguage Fortran: ",i0,"/",i0)', rank, size

  if (rank /= crank .or. size /= csize) stop 1

  sendbuf = rank;
  recvbuf = -1;
  call MPI_Sendrecv(sendbuf, 1, MPI_INT, mod(rank + 1, size), 0, recvbuf, 1, MPI_INT, mod(rank + size - 1, size), 0, &
       comm, MPI_STATUS_IGNORE, ierr)
  if (recvbuf /= mod(rank + size - 1, size)) stop 1

  sendbuf = rank
  recvbuf = -1;
  call MPI_Sendrecv(sendbuf, 1, MPI_INT, mod(rank + 1, size), 0, recvbuf, 1, MPI_INT, mod(rank + size - 1, size), 0, &
       comm, status, ierr)
  if (status(MPI_SOURCE) /= mod(rank + size - 1, size) .or. status(MPI_TAG) /= 0) stop
  if (recvbuf /= mod(rank + size - 1, size)) stop 1
end subroutine subf90
