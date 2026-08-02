! MPI-5.0 section 3.2.5: "In general, message-passing calls do not modify the
! value of the error code field of status variables. This field may be updated
! only by the functions in Section 3.7.5 that return multiple statuses. The field
! is updated if and only if such function returns with an error code of
! MPI_ERR_IN_STATUS."
!
! An MPI written in C keeps that rule by doing nothing: the caller's status is
! the object MPI writes into, so a field it does not set keeps its value. mpif's
! f08 wrappers cannot, because they hand MPI a temporary and copy it back
! afterwards -- so a field MPI leaves alone held whatever was on the stack, and
! that reached the caller. Every f08 call that returns a status overwrote
! status%MPI_ERROR with garbage.
!
! This is what failed MPICH's f08/pt2pt/mprobef08, which sets MPI_ERROR to a
! sentinel before each of its calls and requires it to survive. Its f77 and f90
! copies passed all along: mpif.h and the mpi module hand MPI the caller's own
! INTEGER array, so there is no temporary to lose the field in.
!
! The sentinel below is deliberately an error code no call here can produce.
!
! Everything is done on MPI_COMM_SELF so that no launcher is needed.

program status_error_f08
  use mpi_f08
  implicit none

  integer, parameter :: sentinel = MPI_ERR_DIMS
  integer :: sendbuf, recvbuf, count
  type(MPI_Status) :: status, statuses(2)
  type(MPI_Request) :: reqs(2)
  type(MPI_Message) :: message
  logical :: flag

  call MPI_Init()

  sendbuf = 11

  ! A blocking receive, the plainest single-status call

  status%MPI_ERROR = sentinel
  call MPI_Sendrecv(sendbuf, 1, MPI_INTEGER, 0, 1, recvbuf, 1, MPI_INTEGER, &
       0, 1, MPI_COMM_SELF, status)
  if (recvbuf /= 11) stop 1
  if (status%MPI_ERROR /= sentinel) stop 2
  if (status%MPI_TAG /= 1) stop 3
  print '("MPI_Sendrecv leaves status%MPI_ERROR alone: ok")'

  ! MPI_Wait, and MPI_Get_count on the status afterwards, to show that leaving
  ! the error field alone has not damaged the rest of it

  call MPI_Isend(sendbuf, 1, MPI_INTEGER, 0, 2, MPI_COMM_SELF, reqs(1))
  call MPI_Irecv(recvbuf, 1, MPI_INTEGER, 0, 2, MPI_COMM_SELF, reqs(2))
  status%MPI_ERROR = sentinel
  call MPI_Wait(reqs(2), status)
  if (status%MPI_ERROR /= sentinel) stop 4
  call MPI_Get_count(status, MPI_INTEGER, count)
  if (count /= 1) stop 5
  call MPI_Wait(reqs(1), MPI_STATUS_IGNORE)
  print '("MPI_Wait leaves status%MPI_ERROR alone: ok")'

  ! The matched-probe routines, which is where MPICH's suite catches this

  call MPI_Isend(sendbuf, 1, MPI_INTEGER, 0, 3, MPI_COMM_SELF, reqs(1))
  status%MPI_ERROR = sentinel
  call MPI_Mprobe(0, 3, MPI_COMM_SELF, message, status)
  if (status%MPI_ERROR /= sentinel) stop 6
  if (status%MPI_TAG /= 3) stop 7
  status%MPI_ERROR = sentinel
  call MPI_Mrecv(recvbuf, 1, MPI_INTEGER, message, status)
  if (status%MPI_ERROR /= sentinel) stop 8
  if (recvbuf /= 11) stop 9
  call MPI_Wait(reqs(1), MPI_STATUS_IGNORE)
  print '("MPI_Mprobe and MPI_Mrecv leave status%MPI_ERROR alone: ok")'

  ! MPI_Improbe with nothing to match: flag is false and the status is undefined,
  ! but the error field is still not MPI's to touch

  status%MPI_ERROR = sentinel
  call MPI_Improbe(0, 99, MPI_COMM_SELF, flag, message, status)
  if (flag) stop 10
  if (status%MPI_ERROR /= sentinel) stop 11
  print '("MPI_Improbe leaves status%MPI_ERROR alone: ok")'

  ! An array of statuses is the exception the standard names: these are the
  ! routines allowed to set the error field. It says "if and only if such
  ! function returns with an error code of MPI_ERR_IN_STATUS", and MPICH is more
  ! eager than that -- a successful MPI_Waitall sets every MPI_ERROR to
  ! MPI_SUCCESS. That is the implementation's business, not mpif's: the array
  ! goes to MPI as the caller's own, exactly as it does from mpif.h and the mpi
  ! module, which have always behaved this way. So the assertion here is that the
  ! rest of the status is right, not that the error field survived.
  !
  ! It is worth knowing that this changed. While the f08 layer converted through
  ! a temporary it could and did preserve the field, making mpi_f08 quieter than
  ! its own mpi module. Passing the status through gives up that difference, and
  ! consistency between the three interfaces is the better bargain.

  call MPI_Isend(sendbuf, 1, MPI_INTEGER, 0, 4, MPI_COMM_SELF, reqs(1))
  call MPI_Irecv(recvbuf, 1, MPI_INTEGER, 0, 4, MPI_COMM_SELF, reqs(2))
  call MPI_Waitall(2, reqs, statuses)
  if (statuses(2)%MPI_TAG /= 4) stop 12
  if (statuses(2)%MPI_SOURCE /= 0) stop 13
  call MPI_Get_count(statuses(2), MPI_INTEGER, count)
  if (count /= 1) stop 14
  print '("MPI_Waitall fills in the array it is given: ok")'

  print '("status_error_f08: all ok")'

  call MPI_Finalize()

end program status_error_f08
