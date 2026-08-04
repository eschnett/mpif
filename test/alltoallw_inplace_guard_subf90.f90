! The `mpi` and `mpi_f08` probes for alltoallw_inplace_guard.c. Both take the
! address of a single handle whose successor is on an unreadable page.
!
! The f08 one declares its dummy TYPE(MPI_Datatype), which is how it can be
! handed a C pointer at all: the type is BIND(C) around one default INTEGER, so an
! array of them is an MPI_Fint[]. That is the same interoperability the f08
! wrappers themselves now rely on to pass an assumed-size handle array through
! without repacking it.

subroutine alltoallw_inplace_probe_f90(sendtypes)
  use mpi
  implicit none

  integer :: sendtypes(*)

  integer, parameter :: max_size = 8
  integer :: ierror, rank, size, intsize, i, expected
  integer :: rcounts(max_size), rdispls(max_size), rtypes(max_size)
  integer :: rbuf(max_size)
  integer :: scounts(1), sdispls(1)

  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)
  call MPI_Comm_size(MPI_COMM_WORLD, size, ierror)
  if (size > max_size) call MPI_Abort(MPI_COMM_WORLD, 1, ierror)
  call MPI_Type_size(MPI_INTEGER, intsize, ierror)

  scounts(1) = -1
  sdispls(1) = -1

  do i = 1, size
     rcounts(i) = 1
     rdispls(i) = (i - 1) * intsize
     rtypes(i) = MPI_INTEGER
     rbuf(i) = rank * size + (i - 1)
  end do

  call MPI_Alltoallw(MPI_IN_PLACE, scounts, sdispls, sendtypes, &
                     rbuf, rcounts, rdispls, rtypes, MPI_COMM_WORLD, ierror)
  if (ierror /= MPI_SUCCESS) call MPI_Abort(MPI_COMM_WORLD, 1, ierror)

  do i = 1, size
     expected = (i - 1) * size + rank
     if (rbuf(i) /= expected) then
        print *, "mpi: rank ", rank, ": rbuf(", i, ") = ", rbuf(i), &
             ", expected ", expected
        call MPI_Abort(MPI_COMM_WORLD, 1, ierror)
     end if
  end do
end subroutine alltoallw_inplace_probe_f90

subroutine alltoallw_inplace_probe_f08(sendtypes)
  use mpi_f08
  implicit none

  type(MPI_Datatype) :: sendtypes(*)

  integer, parameter :: max_size = 8
  integer :: rank, size, intsize, i, expected
  integer :: rcounts(max_size), rdispls(max_size)
  type(MPI_Datatype) :: rtypes(max_size)
  integer :: rbuf(max_size)
  integer :: scounts(1), sdispls(1)

  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)
  if (size > max_size) call MPI_Abort(MPI_COMM_WORLD, 1)
  call MPI_Type_size(MPI_INTEGER, intsize)

  scounts(1) = -1
  sdispls(1) = -1

  do i = 1, size
     rcounts(i) = 1
     rdispls(i) = (i - 1) * intsize
     rtypes(i) = MPI_INTEGER
     rbuf(i) = rank * size + (i - 1)
  end do

  call MPI_Alltoallw(MPI_IN_PLACE, scounts, sdispls, sendtypes, &
                     rbuf, rcounts, rdispls, rtypes, MPI_COMM_WORLD)

  do i = 1, size
     expected = (i - 1) * size + rank
     if (rbuf(i) /= expected) then
        print *, "mpi_f08: rank ", rank, ": rbuf(", i, ") = ", rbuf(i), &
             ", expected ", expected
        call MPI_Abort(MPI_COMM_WORLD, 1)
     end if
  end do
end subroutine alltoallw_inplace_probe_f08
