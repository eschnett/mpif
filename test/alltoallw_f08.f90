! MPI_Alltoallw through mpi_f08, with correctly sized and fully initialised
! arrays -- the plainest possible use of the routine.
!
! It failed under gfortran before the f08 wrappers stopped passing
! `sendtypes%MPI_VAL`. A component reference of an assumed-size dummy has no
! extent the compiler knows, and gfortran repacked it anyway: the descriptor it
! built carried `ubound = -1`, so the copy loop moved zero elements and handed
! the C wrapper a stack slot instead of the caller's array. The four `MPI_Fint`s
! read out of it were that slot, `tmp_ierror` and the two halves of the saved
! `comm` pointer, so MPI_Type_fromint was given a stack address, and MPICH
! reported it as "Assertion failed in file src/binding/abi/mpi_abi_util.h at line
! 140". The arrays here being valid is the point: nothing the caller does is
! wrong, and the handles never reached MPI.

program alltoallw_f08
  use mpi_f08
  implicit none

  integer, parameter :: max_size = 8
  integer :: rank, size, intsize, i, expected
  ! Deliberately longer than the communicator, with only the first `size`
  ! entries set, which is what a caller of an assumed-size argument may do.
  type(MPI_Datatype) :: stypes(max_size), rtypes(max_size)
  integer :: scounts(max_size), sdispls(max_size)
  integer :: rcounts(max_size), rdispls(max_size)
  integer :: sbuf(max_size), rbuf(max_size)

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)
  if (size > max_size) call MPI_Abort(MPI_COMM_WORLD, 1)
  call MPI_Type_size(MPI_INTEGER, intsize)

  do i = 1, size
     scounts(i) = 1
     sdispls(i) = (i - 1) * intsize
     stypes(i) = MPI_INTEGER
     sbuf(i) = rank * size + i
     rcounts(i) = 1
     rdispls(i) = (i - 1) * intsize
     rtypes(i) = MPI_INTEGER
     rbuf(i) = -1
  end do

  call MPI_Alltoallw(sbuf, scounts, sdispls, stypes, &
                     rbuf, rcounts, rdispls, rtypes, MPI_COMM_WORLD)

  ! Block i comes from rank i-1, which put `(i-1)*size + (rank+1)` there.
  do i = 1, size
     expected = (i - 1) * size + rank + 1
     if (rbuf(i) /= expected) then
        print *, "rank ", rank, ": rbuf(", i, ") = ", rbuf(i), ", expected ", expected
        call MPI_Abort(MPI_COMM_WORLD, 1)
     end if
  end do

  call MPI_Finalize()
end program alltoallw_f08
