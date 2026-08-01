! A generalized request's three callbacks are told only extra_state, so mpif
! passes MPI a box of its own holding the Fortran procedures and hands the
! caller's extra state on from there; see src/mpif_callbacks.c.
!
! The callbacks update module variables so the test can check each one ran, and
! free_fn also updates extra_state itself: the standard declares extra_state
! without an INTENT in all three interfaces, and the update is expected to reach
! the caller's variable.

module grequest_callbacks
  use mpi_f08
  implicit none

  integer :: query_calls = 0
  integer :: free_calls = 0
  integer :: cancel_calls = 0
  logical :: cancel_complete = .true.

contains

  subroutine query_fn(extra_state, status, ierror)
    integer(MPI_ADDRESS_KIND) :: extra_state
    type(MPI_Status) :: status
    integer :: ierror
    query_calls = query_calls + 1
    status%MPI_SOURCE = 7
    status%MPI_TAG = 11
    status%MPI_ERROR = MPI_SUCCESS
    ierror = MPI_SUCCESS
  end subroutine query_fn

  subroutine free_fn(extra_state, ierror)
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
    free_calls = free_calls + 1
    ! Must be visible to the caller afterwards
    extra_state = extra_state - 1
    ierror = MPI_SUCCESS
  end subroutine free_fn

  subroutine cancel_fn(extra_state, complete, ierror)
    integer(MPI_ADDRESS_KIND) :: extra_state
    logical :: complete
    integer :: ierror
    cancel_calls = cancel_calls + 1
    cancel_complete = complete
    ierror = MPI_SUCCESS
  end subroutine cancel_fn

end module grequest_callbacks

program grequest_f08
  use mpi_f08
  use grequest_callbacks
  implicit none

  type(MPI_Request) :: request
  type(MPI_Status) :: status
  integer(MPI_ADDRESS_KIND) :: extra_state
  logical :: flag

  call MPI_Init()

  ! A request completed by hand, then waited on: query_fn then free_fn
  extra_state = 42
  call MPI_Grequest_start(query_fn, free_fn, cancel_fn, extra_state, request)
  if (query_calls /= 0 .or. free_calls /= 0) stop 1

  call MPI_Test(request, flag, status)
  if (flag) stop 2

  call MPI_Grequest_complete(request)
  call MPI_Wait(request, status)

  if (query_calls < 1) stop 3
  if (free_calls /= 1) stop 4
  if (cancel_calls /= 0) stop 5
  ! What query_fn put there, carried back through the wait
  if (status%MPI_SOURCE /= 7) stop 6
  if (status%MPI_TAG /= 11) stop 7
  ! What free_fn did to the caller's own variable
  if (extra_state /= 41) stop 8
  print '("query/free: ok, extra_state is ", i0)', extra_state

  ! And the cancel path, which MPICH's greqf does not reach
  query_calls = 0
  free_calls = 0
  extra_state = 100
  call MPI_Grequest_start(query_fn, free_fn, cancel_fn, extra_state, request)
  call MPI_Cancel(request)
  if (cancel_calls /= 1) stop 9
  if (cancel_complete) stop 10

  call MPI_Grequest_complete(request)
  call MPI_Wait(request, MPI_STATUS_IGNORE)
  if (free_calls /= 1) stop 11
  if (extra_state /= 99) stop 12
  print '("cancel: ok, called once with complete=.false.")'

  print '("grequest_f08: all ok")'

  call MPI_Finalize()

end program grequest_f08
