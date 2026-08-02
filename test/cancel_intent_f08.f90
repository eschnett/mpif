! MPI_Cancel takes its request INTENT(IN).
!
! MPI-5.0 A.4.1 gives the f08 binding "TYPE(MPI_Request), INTENT(IN) ::
! request", and means it: MPI_Cancel marks a request for cancellation, it does
! not replace the handle, and the request still has to be completed with
! MPI_Wait or MPI_Test afterwards. mpif declared it INTENT(INOUT), because the C
! entry point takes MPI_Request* and the wrapper has to hand it an address.
!
! That is invisible until a caller holds the request INTENT(IN) itself and
! forwards it, which is what `cancel_it` below does. Against an INTENT(INOUT)
! binding it does not compile: "Dummy argument 'request' with INTENT(IN) in
! variable definition context". Nothing at run time can show this -- the
! assertion is that the file builds.
!
! The request cancelled here is a receive that never matches, on MPI_COMM_SELF
! so that no launcher is needed.

module cancel_intent_f08_fns
  use mpi_f08
  implicit none

contains

  ! The point of the test: a request this procedure may not modify, handed
  ! straight to MPI_Cancel.
  subroutine cancel_it(request)
    type(MPI_Request), intent(in) :: request
    call MPI_Cancel(request)
  end subroutine cancel_it

end module cancel_intent_f08_fns

program cancel_intent_f08
  use mpi_f08
  use cancel_intent_f08_fns
  implicit none

  integer :: buf
  logical :: cancelled
  type(MPI_Request) :: request
  type(MPI_Status) :: status

  call MPI_Init()

  buf = 0
  call MPI_Irecv(buf, 1, MPI_INTEGER, MPI_PROC_NULL, 0, MPI_COMM_SELF, request)

  call cancel_it(request)

  ! The handle is still the caller's to complete, which is the other half of
  ! what INTENT(IN) says.
  call MPI_Wait(request, status)
  call MPI_Test_cancelled(status, cancelled)

  ! Whether a receive from MPI_PROC_NULL can be cancelled at all is the
  ! implementation's business -- it completes immediately, so a cancel may
  ! arrive too late. Either answer is fine; that the call was accepted is not.
  if (cancelled) then
     print '("cancel_intent_f08: all ok (cancelled)")'
  else
     print '("cancel_intent_f08: all ok (completed first)")'
  end if

  call MPI_Finalize()

end program cancel_intent_f08
