! MPI_Alltoallw with MPI_IN_PLACE, where MPI-5.0 6.8 says "sendcounts, sdispls
! and sendtypes are ignored".
!
! mpif converted them anyway, once per member of the group, so a caller who took
! the standard at its word and passed a one-element array was over-read by
! however many ranks there are beyond the first. MPICH's own vw_inplacef,
! vw_inplacef90, nonblocking_inpf and nonblocking_inpf90 all pass an
! uninitialised `stypes(1)` here; the last two failed often enough to be recorded
! as flaky and blamed on a defect in MPI_Type_get_contents that neither of them
! calls, and the first two passed on nothing but what happened to be next on the
! stack.
!
! This test has the realistic shape -- a one-element `sendtypes`, the way the
! standard permits and MPICH's own tests do -- and checks that the operation
! works. It is deliberately *not* the test for the over-read, which it cannot be:
! putting the defect back leaves it passing, because whether the extra read is
! observable depends entirely on what happens to be adjacent. A poisoned handle
! was tried and did not help either; MPI_Type_fromint derives a pointer from an
! out-of-range value without complaint. test/alltoallw_inplace_guard.c is the
! sharp one, with a guard page under the second element.

program alltoallw_inplace_f08
  use mpi_f08
  implicit none

  integer, parameter :: max_size = 8
  integer :: rank, size, intsize, i, expected
  integer :: rcounts(max_size), rdispls(max_size)
  type(MPI_Datatype) :: rtypes(max_size)
  integer :: rbuf(max_size)
  ! One element, since the standard says the send arguments are ignored.
  integer :: scounts(1), sdispls(1)
  type(MPI_Datatype) :: stypes(1)

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)
  if (size > max_size) call MPI_Abort(MPI_COMM_WORLD, 1)
  call MPI_Type_size(MPI_INTEGER, intsize)

  scounts(1) = -1
  sdispls(1) = -1
  stypes(1) = MPI_DATATYPE_NULL

  do i = 1, size
     rcounts(i) = 1
     rdispls(i) = (i - 1) * intsize
     rtypes(i) = MPI_INTEGER
     ! Block i is what I send to rank i-1.
     rbuf(i) = rank * size + (i - 1)
  end do

  call MPI_Alltoallw(MPI_IN_PLACE, scounts, sdispls, stypes, &
                     rbuf, rcounts, rdispls, rtypes, MPI_COMM_WORLD)

  ! Block i is now what rank i-1 sent me.
  do i = 1, size
     expected = (i - 1) * size + rank
     if (rbuf(i) /= expected) then
        print *, "rank ", rank, ": rbuf(", i, ") = ", rbuf(i), ", expected ", expected
        call MPI_Abort(MPI_COMM_WORLD, 1)
     end if
  end do

  call MPI_Finalize()
end program alltoallw_inplace_f08
