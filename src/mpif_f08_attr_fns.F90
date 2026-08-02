! mpi_f08's predefined attribute copy and delete callbacks, and the null datarep
! conversion functions.
!
! The same thirteen names that src/mpif_attr_fns.F90 provides for mpif.h and the
! mpi module -- less the three MPI-1 forms, which mpi_f08 does not have -- but as
! separate procedures, because in mpi_f08 a handle is a derived type rather than
! an INTEGER. MPI-5.0 Appendix A.4 gives each of these a binding of its own, with
! TYPE(MPI_Comm) where A.5 has INTEGER.
!
! As in mpif.h, these are external subprograms rather than module procedures, so
! that src/mpif_callbacks.c can name their symbols portably: it recognises the
! address of the procedure it is handed and passes MPI the ABI sentinel that
! stands for it, and a module procedure's symbol is the compiler's to mangle.
! They carry mpif's own names here, and src/mpi_f08.F90 renames each to the
! standard's on the way out -- MPI_COMM_NULL_COPY_FN cannot be the symbol, since
! src/mpif_attr_fns.F90 already defines that one with INTEGER arguments.
!
! The interfaces match the abstract interfaces in src/mpif_f08_types.F90, down to
! carrying no INTENT on anything, which is what makes each passable as the
! PROCEDURE(...) dummy the generated wrappers declare -- INTENT is part of a
! dummy argument's characteristics, so a mismatch is a compile error rather than
! a difference of opinion. A.4 agrees, giving these thirteen bindings no intents
! either; its one MPI_TYPE_NULL_DELETE_FN INTENT(OUT) is discussed where the
! abstract interfaces are. That the two datarep conversion functions take their
! buffers as INTEGER(KIND=MPI_ADDRESS_KIND) rather than the TYPE(C_PTR), VALUE
! the standard gives them is a divergence of type rather than intent; the
! abstract interface is what is wrong there, and correcting it is a separate
! job.
!
! The bodies never run in the normal course of things, for the same reason as in
! src/mpif_attr_fns.F90: MPI is handed a sentinel, not a procedure. They do what
! the standard prescribes anyway -- the copy callbacks report .FALSE. except the
! DUP variants, the delete callbacks do nothing, the conversion functions do
! nothing -- in case a program calls one directly.

module mpif_f08_attr_fns
  use mpif_f08_types
  implicit none
  private

  public :: mpif_f08_comm_null_copy_fn
  public :: mpif_f08_comm_dup_fn
  public :: mpif_f08_type_null_copy_fn
  public :: mpif_f08_type_dup_fn
  public :: mpif_f08_win_null_copy_fn
  public :: mpif_f08_win_dup_fn
  public :: mpif_f08_comm_null_delete_fn
  public :: mpif_f08_type_null_delete_fn
  public :: mpif_f08_win_null_delete_fn
  public :: mpif_f08_conversion_fn_null
  public :: mpif_f08_conversion_fn_null_c

  interface
     subroutine mpif_f08_comm_null_copy_fn(oldcomm, comm_keyval, extra_state, &
          attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm) :: oldcomm
       integer :: comm_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine mpif_f08_comm_null_copy_fn

     subroutine mpif_f08_comm_dup_fn(oldcomm, comm_keyval, extra_state, &
          attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm) :: oldcomm
       integer :: comm_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine mpif_f08_comm_dup_fn

     subroutine mpif_f08_type_null_copy_fn(oldtype, type_keyval, extra_state, &
          attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype) :: oldtype
       integer :: type_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine mpif_f08_type_null_copy_fn

     subroutine mpif_f08_type_dup_fn(oldtype, type_keyval, extra_state, &
          attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype) :: oldtype
       integer :: type_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine mpif_f08_type_dup_fn

     subroutine mpif_f08_win_null_copy_fn(oldwin, win_keyval, extra_state, &
          attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Win
       implicit none
       type(MPI_Win) :: oldwin
       integer :: win_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine mpif_f08_win_null_copy_fn

     subroutine mpif_f08_win_dup_fn(oldwin, win_keyval, extra_state, &
          attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Win
       implicit none
       type(MPI_Win) :: oldwin
       integer :: win_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine mpif_f08_win_dup_fn

     subroutine mpif_f08_comm_null_delete_fn(comm, comm_keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm) :: comm
       integer :: comm_keyval
       integer(MPI_ADDRESS_KIND) :: attribute_val
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine mpif_f08_comm_null_delete_fn

     subroutine mpif_f08_type_null_delete_fn(type, type_keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype) :: type
       integer :: type_keyval
       integer(MPI_ADDRESS_KIND) :: attribute_val
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine mpif_f08_type_null_delete_fn

     subroutine mpif_f08_win_null_delete_fn(win, win_keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Win
       implicit none
       type(MPI_Win) :: win
       integer :: win_keyval
       integer(MPI_ADDRESS_KIND) :: attribute_val
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine mpif_f08_win_null_delete_fn

     subroutine mpif_f08_conversion_fn_null(userbuf, datatype, count, filebuf, &
          position, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       integer(MPI_ADDRESS_KIND) :: userbuf
       type(MPI_Datatype) :: datatype
       integer :: count
       integer(MPI_ADDRESS_KIND) :: filebuf
       integer(MPI_OFFSET_KIND) :: position
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine mpif_f08_conversion_fn_null

     subroutine mpif_f08_conversion_fn_null_c(userbuf, datatype, count, filebuf, &
          position, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       integer(MPI_ADDRESS_KIND) :: userbuf
       type(MPI_Datatype) :: datatype
       integer(MPI_COUNT_KIND) :: count
       integer(MPI_ADDRESS_KIND) :: filebuf
       integer(MPI_OFFSET_KIND) :: position
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine mpif_f08_conversion_fn_null_c
  end interface

end module mpif_f08_attr_fns

subroutine mpif_f08_comm_null_copy_fn(oldcomm, comm_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpif_f08_types, only: MPI_Comm
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  type(MPI_Comm) :: oldcomm
  integer :: comm_keyval
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer(MPI_ADDRESS_KIND) :: attribute_val_in
  integer(MPI_ADDRESS_KIND) :: attribute_val_out
  logical :: flag
  integer :: ierror
  attribute_val_out = 0
  flag = .false.
  ierror = MPI_SUCCESS
end subroutine mpif_f08_comm_null_copy_fn

subroutine mpif_f08_comm_dup_fn(oldcomm, comm_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpif_f08_types, only: MPI_Comm
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  type(MPI_Comm) :: oldcomm
  integer :: comm_keyval
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer(MPI_ADDRESS_KIND) :: attribute_val_in
  integer(MPI_ADDRESS_KIND) :: attribute_val_out
  logical :: flag
  integer :: ierror
  attribute_val_out = attribute_val_in
  flag = .true.
  ierror = MPI_SUCCESS
end subroutine mpif_f08_comm_dup_fn

subroutine mpif_f08_type_null_copy_fn(oldtype, type_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpif_f08_types, only: MPI_Datatype
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  type(MPI_Datatype) :: oldtype
  integer :: type_keyval
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer(MPI_ADDRESS_KIND) :: attribute_val_in
  integer(MPI_ADDRESS_KIND) :: attribute_val_out
  logical :: flag
  integer :: ierror
  attribute_val_out = 0
  flag = .false.
  ierror = MPI_SUCCESS
end subroutine mpif_f08_type_null_copy_fn

subroutine mpif_f08_type_dup_fn(oldtype, type_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpif_f08_types, only: MPI_Datatype
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
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
end subroutine mpif_f08_type_dup_fn

subroutine mpif_f08_win_null_copy_fn(oldwin, win_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpif_f08_types, only: MPI_Win
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  type(MPI_Win) :: oldwin
  integer :: win_keyval
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer(MPI_ADDRESS_KIND) :: attribute_val_in
  integer(MPI_ADDRESS_KIND) :: attribute_val_out
  logical :: flag
  integer :: ierror
  attribute_val_out = 0
  flag = .false.
  ierror = MPI_SUCCESS
end subroutine mpif_f08_win_null_copy_fn

subroutine mpif_f08_win_dup_fn(oldwin, win_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpif_f08_types, only: MPI_Win
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
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
end subroutine mpif_f08_win_dup_fn

subroutine mpif_f08_comm_null_delete_fn(comm, comm_keyval, attribute_val, extra_state, ierror)
  use mpif_f08_types, only: MPI_Comm
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  type(MPI_Comm) :: comm
  integer :: comm_keyval
  integer(MPI_ADDRESS_KIND) :: attribute_val
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
  ierror = MPI_SUCCESS
end subroutine mpif_f08_comm_null_delete_fn

subroutine mpif_f08_type_null_delete_fn(type, type_keyval, attribute_val, extra_state, ierror)
  use mpif_f08_types, only: MPI_Datatype
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  type(MPI_Datatype) :: type
  integer :: type_keyval
  integer(MPI_ADDRESS_KIND) :: attribute_val
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
  ierror = MPI_SUCCESS
end subroutine mpif_f08_type_null_delete_fn

subroutine mpif_f08_win_null_delete_fn(win, win_keyval, attribute_val, extra_state, ierror)
  use mpif_f08_types, only: MPI_Win
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  type(MPI_Win) :: win
  integer :: win_keyval
  integer(MPI_ADDRESS_KIND) :: attribute_val
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
  ierror = MPI_SUCCESS
end subroutine mpif_f08_win_null_delete_fn

subroutine mpif_f08_conversion_fn_null(userbuf, datatype, count, filebuf, &
     position, extra_state, ierror)
  use mpif_f08_types, only: MPI_Datatype
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_COUNT_KIND, MPI_OFFSET_KIND
  implicit none
  integer(MPI_ADDRESS_KIND) :: userbuf
  type(MPI_Datatype) :: datatype
  integer :: count
  integer(MPI_ADDRESS_KIND) :: filebuf
  integer(MPI_OFFSET_KIND) :: position
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
end subroutine mpif_f08_conversion_fn_null

subroutine mpif_f08_conversion_fn_null_c(userbuf, datatype, count, filebuf, &
     position, extra_state, ierror)
  use mpif_f08_types, only: MPI_Datatype
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_COUNT_KIND, MPI_OFFSET_KIND
  implicit none
  integer(MPI_ADDRESS_KIND) :: userbuf
  type(MPI_Datatype) :: datatype
  integer(MPI_COUNT_KIND) :: count
  integer(MPI_ADDRESS_KIND) :: filebuf
  integer(MPI_OFFSET_KIND) :: position
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
end subroutine mpif_f08_conversion_fn_null_c
