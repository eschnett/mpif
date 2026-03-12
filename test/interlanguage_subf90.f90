subroutine subf90(comm, crank, csize)
  use mpi
  implicit none
  integer comm, crank, csize
  integer rank, size
  integer ierr
  call MPI_Comm_rank(comm, rank, ierr)
  call MPI_Comm_size(comm, size, ierr)
  print '("Interlanguage Fortran: ",i0,"/",i0)', rank, size
  if (rank /= crank .or. size /= csize) stop 1
end subroutine subf90
