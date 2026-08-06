! The `mpi` module half of what test/waitall_f08.f90 asserts. The declaration
! there was `integer :: array_of_statuses(MPI_STATUS_SIZE)` and is now
! `(MPI_STATUS_SIZE, *)`, which is what the standard's binding says.
!
! Unlike mpi_f08, this interface was survivable before: Fortran's sequence
! association lets a larger actual argument through, so a call like the one
! below compiled and worked even against the scalar declaration. What it did not
! do was describe the argument correctly, and an explicit interface that lies is
! a trap for the next reader. This file therefore passes either way -- it is here
! so that the rank-two declaration is exercised from the interface that has one,
! and so that a future change to it has something to fail.
!
! Everything is done on MPI_COMM_SELF so that no launcher is needed.

program waitall_f90
  use mpi
  implicit none

  integer, parameter :: n = 4
  integer :: reqs(2*n)
  integer :: statuses(MPI_STATUS_SIZE, 2*n)
  integer :: sendbuf(n), recvbuf(n)
  integer :: i, cnt, ierror

  call MPI_Init(ierror)

  recvbuf = 0
  do i = 1, n
     call MPI_Irecv(recvbuf(i), 1, MPI_INTEGER, 0, i, MPI_COMM_SELF, reqs(i), ierror)
  end do
  do i = 1, n
     sendbuf(i) = 100 + i
     call MPI_Isend(sendbuf(i), 1, MPI_INTEGER, 0, i, MPI_COMM_SELF, reqs(n+i), ierror)
  end do

  call MPI_Waitall(2*n, reqs, statuses, ierror)
  if (ierror /= MPI_SUCCESS) stop 1

  do i = 1, n
     if (recvbuf(i) /= 100 + i) stop 2
     if (statuses(MPI_TAG, i) /= i) stop 3
     if (statuses(MPI_SOURCE, i) /= 0) stop 4
     call MPI_Get_count(statuses(1, i), MPI_INTEGER, cnt, ierror)
     if (cnt /= 1) stop 5
  end do
  print '("MPI_Waitall with a rank-two array of statuses: ok")'

  ! count = 0 is legal (MPI-5.0 3.7.5) and used to size the C wrapper's
  ! request temporary as a zero-length VLA, which C does not have.
  call MPI_Waitall(0, reqs, statuses, ierror)
  if (ierror /= MPI_SUCCESS) stop 6
  print '("MPI_Waitall with count = 0: ok")'

  print '("waitall_f90: all ok")'

  call MPI_Finalize(ierror)

end program waitall_f90
