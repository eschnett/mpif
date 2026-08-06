! Every mpi_f08 callback, written the way MPI-5.0 writes it, has to be passable.
!
! The standard gives no INTENT to any argument of any callback: its ABSTRACT
! INTERFACEs, in section 7.7.2 and the rest, and collected in Appendix A.1.3,
! are plain "TYPE(MPI_Comm) :: oldcomm", "INTEGER :: comm_keyval, ierror". A user
! who copies one out of the standard therefore writes no intents either, and
! INTENT is part of a dummy argument's characteristics: a callback whose
! interface is explicit -- a module procedure, which is how anyone writes one --
! must match the abstract interface exactly to be passed as a PROCEDURE(...)
! dummy. When mpif's interfaces carried intents the standard does not give, this
! file did not compile, with "INTENT mismatch in argument 'extra_state'" and
! twenty more like it.
!
! The assertion is therefore a compile-time one, and `pass_*` below is how it is
! made: each takes exactly the PROCEDURE(...) dummy that a generated wrapper
! declares, so handing it a callback checks the characteristics without needing
! MPI to call anything. Two are also registered with MPI and run for real, so
! that the file is not purely a compilation.
!
! The callbacks here are the standard's declarations argument for argument,
! except where mpif's abstract interface still diverges in *type* rather than
! intent: MPI_User_function and the two datarep conversion functions take their
! buffers as INTEGER(KIND=MPI_ADDRESS_KIND) where the standard gives
! TYPE(C_PTR), VALUE. That is MPI_User_function alone now; the datarep
! conversion functions were corrected when MPI_Register_datarep learned to
! forward its callbacks.
!
! MPI_Copy_function and MPI_Delete_function are the deprecated MPI-1 forms, which
! A.4 does not list for mpi_f08; mpif provides them for MPI_Keyval_create, so
! they are checked here too.

module callback_intents_f08_fns
  use mpi_f08
  use, intrinsic :: iso_c_binding, only: C_PTR
  implicit none

  ! Counts the two callbacks that are registered and run for real. It is a
  ! module variable rather than `extra_state` because MPI hands a callback its
  ! extra state by value -- `void *extra_state` in C -- so anything written
  ! there is lost, for every callback family and not only these two.
  integer :: ncalls = 0

contains

  subroutine copy_fn(oldcomm, keyval, extra_state, attribute_val_in, &
       attribute_val_out, flag, ierror)
    type(MPI_Comm) :: oldcomm
    integer :: keyval
    integer :: extra_state
    integer :: attribute_val_in
    integer :: attribute_val_out
    logical :: flag
    integer :: ierror
    attribute_val_out = attribute_val_in
    flag = .true.
    ierror = MPI_SUCCESS
  end subroutine copy_fn

  subroutine delete_fn(comm, keyval, attribute_val, extra_state, ierror)
    type(MPI_Comm) :: comm
    integer :: keyval
    integer :: attribute_val
    integer :: extra_state
    integer :: ierror
    ierror = MPI_SUCCESS
  end subroutine delete_fn

  subroutine user_fn(invec, inoutvec, len, datatype)
    type(C_PTR), value :: invec
    type(C_PTR), value :: inoutvec
    integer :: len
    type(MPI_Datatype) :: datatype
  end subroutine user_fn

  subroutine user_fn_c(invec, inoutvec, len, datatype)
    type(C_PTR), value :: invec
    type(C_PTR), value :: inoutvec
    integer(MPI_COUNT_KIND) :: len
    type(MPI_Datatype) :: datatype
  end subroutine user_fn_c

  subroutine comm_copy_attr_fn(oldcomm, comm_keyval, extra_state, &
       attribute_val_in, attribute_val_out, flag, ierror)
    type(MPI_Comm) :: oldcomm
    integer :: comm_keyval
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer(MPI_ADDRESS_KIND) :: attribute_val_in
    integer(MPI_ADDRESS_KIND) :: attribute_val_out
    logical :: flag
    integer :: ierror
    ncalls = ncalls + 1
    attribute_val_out = attribute_val_in
    flag = .true.
    ierror = MPI_SUCCESS
  end subroutine comm_copy_attr_fn

  subroutine comm_delete_attr_fn(comm, comm_keyval, attribute_val, &
       extra_state, ierror)
    type(MPI_Comm) :: comm
    integer :: comm_keyval
    integer(MPI_ADDRESS_KIND) :: attribute_val
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
    ncalls = ncalls + 1
    ierror = MPI_SUCCESS
  end subroutine comm_delete_attr_fn

  subroutine comm_errhandler_fn(comm, error_code)
    type(MPI_Comm) :: comm
    integer :: error_code
  end subroutine comm_errhandler_fn

  subroutine datarep_conversion_fn(userbuf, datatype, count, filebuf, &
       position, extra_state, ierror)
    type(C_PTR), value :: userbuf
    type(MPI_Datatype) :: datatype
    integer :: count
    type(C_PTR), value :: filebuf
    integer(MPI_OFFSET_KIND) :: position
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
  end subroutine datarep_conversion_fn

  subroutine datarep_conversion_fn_c(userbuf, datatype, count, filebuf, &
       position, extra_state, ierror)
    type(C_PTR), value :: userbuf
    type(MPI_Datatype) :: datatype
    integer(MPI_COUNT_KIND) :: count
    type(C_PTR), value :: filebuf
    integer(MPI_OFFSET_KIND) :: position
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
  end subroutine datarep_conversion_fn_c

  subroutine datarep_extent_fn(datatype, extent, extra_state, ierror)
    type(MPI_Datatype) :: datatype
    integer(MPI_ADDRESS_KIND) :: extent
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
  end subroutine datarep_extent_fn

  subroutine file_errhandler_fn(file, error_code)
    type(MPI_File) :: file
    integer :: error_code
  end subroutine file_errhandler_fn

  subroutine grequest_query_fn(extra_state, status, ierror)
    integer(MPI_ADDRESS_KIND) :: extra_state
    type(MPI_Status) :: status
    integer :: ierror
    ierror = MPI_SUCCESS
  end subroutine grequest_query_fn

  subroutine grequest_cancel_fn(extra_state, complete, ierror)
    integer(MPI_ADDRESS_KIND) :: extra_state
    logical :: complete
    integer :: ierror
    ierror = MPI_SUCCESS
  end subroutine grequest_cancel_fn

  subroutine grequest_free_fn(extra_state, ierror)
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
    extra_state = extra_state - 1
    ierror = MPI_SUCCESS
  end subroutine grequest_free_fn

  subroutine session_errhandler_fn(session, error_code)
    type(MPI_Session) :: session
    integer :: error_code
  end subroutine session_errhandler_fn

  subroutine type_copy_attr_fn(oldtype, type_keyval, extra_state, &
       attribute_val_in, attribute_val_out, flag, ierror)
    type(MPI_Datatype) :: oldtype
    integer :: type_keyval
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer(MPI_ADDRESS_KIND) :: attribute_val_in
    integer(MPI_ADDRESS_KIND) :: attribute_val_out
    logical :: flag
    integer :: ierror
    attribute_val_out = attribute_val_in
    flag = .true.
    ierror = MPI_SUCCESS
  end subroutine type_copy_attr_fn

  subroutine type_delete_attr_fn(type, type_keyval, attribute_val, &
       extra_state, ierror)
    type(MPI_Datatype) :: type
    integer :: type_keyval
    integer(MPI_ADDRESS_KIND) :: attribute_val
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
    ierror = MPI_SUCCESS
  end subroutine type_delete_attr_fn

  subroutine win_errhandler_fn(win, error_code)
    type(MPI_Win) :: win
    integer :: error_code
  end subroutine win_errhandler_fn

  subroutine win_copy_attr_fn(oldwin, win_keyval, extra_state, &
       attribute_val_in, attribute_val_out, flag, ierror)
    type(MPI_Win) :: oldwin
    integer :: win_keyval
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer(MPI_ADDRESS_KIND) :: attribute_val_in
    integer(MPI_ADDRESS_KIND) :: attribute_val_out
    logical :: flag
    integer :: ierror
    attribute_val_out = attribute_val_in
    flag = .true.
    ierror = MPI_SUCCESS
  end subroutine win_copy_attr_fn

  subroutine win_delete_attr_fn(win, win_keyval, attribute_val, &
       extra_state, ierror)
    type(MPI_Win) :: win
    integer :: win_keyval
    integer(MPI_ADDRESS_KIND) :: attribute_val
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
    ierror = MPI_SUCCESS
  end subroutine win_delete_attr_fn

  ! One per abstract interface, each declaring the dummy exactly as a generated
  ! wrapper does. Passing a callback to one of these is the whole assertion.

  subroutine pass_copy_function(fn)
    procedure(MPI_Copy_function) :: fn
  end subroutine pass_copy_function

  subroutine pass_delete_function(fn)
    procedure(MPI_Delete_function) :: fn
  end subroutine pass_delete_function

  subroutine pass_user_function(fn)
    procedure(MPI_User_function) :: fn
  end subroutine pass_user_function

  subroutine pass_user_function_c(fn)
    procedure(MPI_User_function_c) :: fn
  end subroutine pass_user_function_c

  subroutine pass_comm_copy_attr_function(fn)
    procedure(MPI_Comm_copy_attr_function) :: fn
  end subroutine pass_comm_copy_attr_function

  subroutine pass_comm_delete_attr_function(fn)
    procedure(MPI_Comm_delete_attr_function) :: fn
  end subroutine pass_comm_delete_attr_function

  subroutine pass_comm_errhandler_function(fn)
    procedure(MPI_Comm_errhandler_function) :: fn
  end subroutine pass_comm_errhandler_function

  subroutine pass_datarep_conversion_function(fn)
    procedure(MPI_Datarep_conversion_function) :: fn
  end subroutine pass_datarep_conversion_function

  subroutine pass_datarep_conversion_function_c(fn)
    procedure(MPI_Datarep_conversion_function_c) :: fn
  end subroutine pass_datarep_conversion_function_c

  subroutine pass_datarep_extent_function(fn)
    procedure(MPI_Datarep_extent_function) :: fn
  end subroutine pass_datarep_extent_function

  subroutine pass_file_errhandler_function(fn)
    procedure(MPI_File_errhandler_function) :: fn
  end subroutine pass_file_errhandler_function

  subroutine pass_grequest_query_function(fn)
    procedure(MPI_Grequest_query_function) :: fn
  end subroutine pass_grequest_query_function

  subroutine pass_grequest_cancel_function(fn)
    procedure(MPI_Grequest_cancel_function) :: fn
  end subroutine pass_grequest_cancel_function

  subroutine pass_grequest_free_function(fn)
    procedure(MPI_Grequest_free_function) :: fn
  end subroutine pass_grequest_free_function

  subroutine pass_session_errhandler_function(fn)
    procedure(MPI_Session_errhandler_function) :: fn
  end subroutine pass_session_errhandler_function

  subroutine pass_type_copy_attr_function(fn)
    procedure(MPI_Type_copy_attr_function) :: fn
  end subroutine pass_type_copy_attr_function

  subroutine pass_type_delete_attr_function(fn)
    procedure(MPI_Type_delete_attr_function) :: fn
  end subroutine pass_type_delete_attr_function

  subroutine pass_win_errhandler_function(fn)
    procedure(MPI_Win_errhandler_function) :: fn
  end subroutine pass_win_errhandler_function

  subroutine pass_win_copy_attr_function(fn)
    procedure(MPI_Win_copy_attr_function) :: fn
  end subroutine pass_win_copy_attr_function

  subroutine pass_win_delete_attr_function(fn)
    procedure(MPI_Win_delete_attr_function) :: fn
  end subroutine pass_win_delete_attr_function

end module callback_intents_f08_fns

program callback_intents_f08
  use mpi_f08
  use callback_intents_f08_fns
  implicit none

  integer :: keyval
  integer(MPI_ADDRESS_KIND) :: extra, value
  logical :: flag
  type(MPI_Comm) :: dup

  call MPI_Init()

  ! All twenty, checked at compile time.

  call pass_copy_function(copy_fn)
  call pass_delete_function(delete_fn)
  call pass_user_function(user_fn)
  call pass_user_function_c(user_fn_c)
  call pass_comm_copy_attr_function(comm_copy_attr_fn)
  call pass_comm_delete_attr_function(comm_delete_attr_fn)
  call pass_comm_errhandler_function(comm_errhandler_fn)
  call pass_datarep_conversion_function(datarep_conversion_fn)
  call pass_datarep_conversion_function_c(datarep_conversion_fn_c)
  call pass_datarep_extent_function(datarep_extent_fn)
  call pass_file_errhandler_function(file_errhandler_fn)
  call pass_grequest_query_function(grequest_query_fn)
  call pass_grequest_cancel_function(grequest_cancel_fn)
  call pass_grequest_free_function(grequest_free_fn)
  call pass_session_errhandler_function(session_errhandler_fn)
  call pass_type_copy_attr_function(type_copy_attr_fn)
  call pass_type_delete_attr_function(type_delete_attr_fn)
  call pass_win_errhandler_function(win_errhandler_fn)
  call pass_win_copy_attr_function(win_copy_attr_fn)
  call pass_win_delete_attr_function(win_delete_attr_fn)

  ! And two of them for real, so that this is not only a compilation. The copy
  ! callback runs during MPI_Comm_dup, and the delete callback twice: once when
  ! the duplicate is freed and once when the attribute is deleted.

  extra = 0
  call MPI_Comm_create_keyval(comm_copy_attr_fn, comm_delete_attr_fn, keyval, extra)
  value = 42
  call MPI_Comm_set_attr(MPI_COMM_SELF, keyval, value)

  call MPI_Comm_dup(MPI_COMM_SELF, dup)
  call MPI_Comm_get_attr(dup, keyval, value, flag)
  if (.not. flag) stop 1
  if (value /= 42) stop 2
  call MPI_Comm_free(dup)

  call MPI_Comm_delete_attr(MPI_COMM_SELF, keyval)
  call MPI_Comm_free_keyval(keyval)

  ! Once for the dup, once for each of the two deletes.
  if (ncalls /= 3) stop 3

  print '("callback_intents_f08: all ok")'

  call MPI_Finalize()

end program callback_intents_f08
