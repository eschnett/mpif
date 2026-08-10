! MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE from mpif.h and from the mpi module.
!
! Both were exercised only from mpi_f08 before, and only incidentally. Two
! reasons this matters more than it looks:
!
! - there are *four* objects, not two. mpif.h and the mpi module share one pair of
!   INTEGER arrays; mpi_f08 has its own pair of TYPE(MPI_Status)es, because the
!   name means a different type there. All four arrive at the same C entry points,
!   the f08 wrappers reaching them through mpif_f08_raw, so mpif_c_status has to
!   recognise all four -- and until this test, only the f08 pair was ever passed.
!   MPI-5.0 3.2.6 is what permits them to differ: "MPI_STATUS_IGNORE and
!   MPI_STATUSES_IGNORE are not required to have the same values in C and Fortran."
! - MPI_STATUSES_IGNORE is its own sentinel, not a synonym. Both are null in the
!   ABI, so a wrapper that recognised only MPI_STATUS_IGNORE would still work --
!   until one of them stopped being null. test/waitall_f08.f90 records the defect
!   that came of exactly that conflation.
!
! A missed translation here is loud rather than silent, but only because the
! sentinel cells are const: MPI writes the status into read-only memory and the
! process dies. What that does not cover is a call that returns before writing,
! so the assertions below are on the payload -- if the sentinel had been treated
! as a real status object the transfer itself would still be correct, and it is
! the fault that catches it.

module statuses_ignore_f90_part
  use mpi
  implicit none
  private
  public :: check_f90
contains

  subroutine check_f90()
    integer, parameter :: n = 2
    integer :: send_buf(n), recv_buf(n)
    integer :: requests(n)
    integer :: i, ierror

    ! Scalar: MPI_STATUS_IGNORE
    send_buf(1) = 42
    recv_buf(1) = 0
    call MPI_Sendrecv(send_buf, 1, MPI_INTEGER, 0, 7, &
                      recv_buf, 1, MPI_INTEGER, 0, 7, &
                      MPI_COMM_SELF, MPI_STATUS_IGNORE, ierror)
    if (ierror /= MPI_SUCCESS) stop 11
    if (recv_buf(1) /= 42) stop 12

    call MPI_Recv_init(recv_buf, 1, MPI_INTEGER, 0, 8, MPI_COMM_SELF, requests(1), ierror)
    call MPI_Start(requests(1), ierror)
    send_buf(1) = 43
    call MPI_Send(send_buf, 1, MPI_INTEGER, 0, 8, MPI_COMM_SELF, ierror)
    call MPI_Wait(requests(1), MPI_STATUS_IGNORE, ierror)
    if (ierror /= MPI_SUCCESS) stop 13
    if (recv_buf(1) /= 43) stop 14
    call MPI_Request_free(requests(1), ierror)

    ! Array: MPI_STATUSES_IGNORE, which is the other object
    do i = 1, n
       send_buf(i) = 100 + i
       recv_buf(i) = 0
    end do
    call MPI_Irecv(recv_buf, n, MPI_INTEGER, 0, 9, MPI_COMM_SELF, requests(1), ierror)
    call MPI_Isend(send_buf, n, MPI_INTEGER, 0, 9, MPI_COMM_SELF, requests(2), ierror)
    call MPI_Waitall(n, requests, MPI_STATUSES_IGNORE, ierror)
    if (ierror /= MPI_SUCCESS) stop 15
    do i = 1, n
       if (recv_buf(i) /= 100 + i) stop 16
    end do
  end subroutine check_f90

end module statuses_ignore_f90_part

program statuses_ignore
  use statuses_ignore_f90_part, only: check_f90
  implicit none
  integer :: ierror

  call MPI_Init(ierror)
  call check_f90()
  call check_mpif_h()
  call MPI_Finalize(ierror)

contains

  subroutine check_mpif_h()
    implicit none
    include 'mpif.h'
    integer, parameter :: n = 2
    integer :: send_buf(n), recv_buf(n)
    integer :: requests(n)
    integer :: i, ierr

    send_buf(1) = 42
    recv_buf(1) = 0
    call MPI_Sendrecv(send_buf, 1, MPI_INTEGER, 0, 7, &
                      recv_buf, 1, MPI_INTEGER, 0, 7, &
                      MPI_COMM_SELF, MPI_STATUS_IGNORE, ierr)
    if (ierr /= MPI_SUCCESS) stop 21
    if (recv_buf(1) /= 42) stop 22

    do i = 1, n
       send_buf(i) = 200 + i
       recv_buf(i) = 0
    end do
    call MPI_Irecv(recv_buf, n, MPI_INTEGER, 0, 9, MPI_COMM_SELF, requests(1), ierr)
    call MPI_Isend(send_buf, n, MPI_INTEGER, 0, 9, MPI_COMM_SELF, requests(2), ierr)
    call MPI_Waitall(n, requests, MPI_STATUSES_IGNORE, ierr)
    if (ierr /= MPI_SUCCESS) stop 23
    do i = 1, n
       if (recv_buf(i) /= 200 + i) stop 24
    end do

    ! MPI_Testall too: the same sentinel through a different entry point, and one
    ! whose `flag` says the requests really were complete.
    block
      logical :: flag
      call MPI_Irecv(recv_buf, 1, MPI_INTEGER, 0, 10, MPI_COMM_SELF, requests(1), ierr)
      call MPI_Send(send_buf, 1, MPI_INTEGER, 0, 10, MPI_COMM_SELF, ierr)
      flag = .false.
      do while (.not. flag)
         call MPI_Testall(1, requests, flag, MPI_STATUSES_IGNORE, ierr)
         if (ierr /= MPI_SUCCESS) stop 25
      end do
    end block
  end subroutine check_mpif_h

end program statuses_ignore
