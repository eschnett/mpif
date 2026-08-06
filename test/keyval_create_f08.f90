! MPI_Keyval_create's two callback arguments are the deprecated MPI-1 forms:
! MPI_Copy_function and MPI_Delete_function. MPI-5.0's own Fortran binding for
! them (Chapter 16, and A.1.4/A.5) gives every argument default INTEGER,
! `extra_state` included -- unlike MPI_Comm_copy_attr_function and its
! relatives, where `extra_state` is INTEGER(KIND=MPI_ADDRESS_KIND). A callback
! written to match the standard, with plain INTEGER `extra_state` and no
! intents, used to fail "There is no specific subroutine for the generic
! 'mpi_keyval_create'" against mpif's abstract interfaces, which declared
! `extra_state` address-sized. A callback written to match mpif's interface
! instead compiled, but read 8 bytes through the C trampoline's pointer to a
! 4-byte MPI_Fint -- see src/mpif_callbacks.c's fortran_copy_fn_10 and
! comm_copy_attr_10.
!
! my_copy and my_delete below are written exactly as the standard writes
! COPY_FUNCTION and DELETE_FUNCTION: the compile is half the assertion, and the
! values the copy callback actually sees are the other half.

module keyval_create_f08_fns
  use mpi_f08
  implicit none

  integer :: copy_ran = 0
  integer :: seen_extra_state = -1
  integer :: seen_attribute_val_in = -1

contains

  subroutine my_copy(oldcomm, keyval, extra_state, attribute_val_in, &
       attribute_val_out, flag, ierror)
    type(MPI_Comm) :: oldcomm
    integer :: keyval
    integer :: extra_state
    integer :: attribute_val_in
    integer :: attribute_val_out
    logical :: flag
    integer :: ierror
    copy_ran = copy_ran + 1
    seen_extra_state = extra_state
    seen_attribute_val_in = attribute_val_in
    attribute_val_out = attribute_val_in
    flag = .true.
    ierror = MPI_SUCCESS
  end subroutine my_copy

  subroutine my_delete(comm, keyval, attribute_val, extra_state, ierror)
    type(MPI_Comm) :: comm
    integer :: keyval
    integer :: attribute_val
    integer :: extra_state
    integer :: ierror
    ierror = MPI_SUCCESS
  end subroutine my_delete

end module keyval_create_f08_fns

program keyval_create_f08
  use mpi_f08
  use keyval_create_f08_fns
  implicit none

  integer :: keyval, value, got_value
  logical :: flag
  type(MPI_Comm) :: dup

  call MPI_Init()

  call MPI_Keyval_create(my_copy, my_delete, keyval, 42)

  value = 99
  call MPI_Attr_put(MPI_COMM_WORLD, keyval, value)

  call MPI_Comm_dup(MPI_COMM_WORLD, dup)

  if (copy_ran /= 1) stop 1
  if (seen_extra_state /= 42) stop 2
  if (seen_attribute_val_in /= 99) stop 3
  print '("my_copy ran once: extra_state=", i0, ", attribute_val_in=", i0)', &
       seen_extra_state, seen_attribute_val_in

  call MPI_Attr_get(dup, keyval, got_value, flag)
  if (.not. flag) stop 4
  if (got_value /= 99) stop 5
  print '("dup carries the copied attribute: ", i0)', got_value

  call MPI_Attr_delete(dup, keyval)
  call MPI_Attr_delete(MPI_COMM_WORLD, keyval)
  call MPI_Comm_free(dup)
  call MPI_Comm_free_keyval(keyval)

  print '("keyval_create_f08: all ok")'

  call MPI_Finalize()

end program keyval_create_f08
