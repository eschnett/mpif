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
! abstract interfaces are. The two datarep conversion functions take their
! buffers as TYPE(C_PTR), VALUE, as the standard gives them and as the
! trampoline in src/mpif_callbacks.c passes them.
!
! The bodies never run in the normal course of things, for the same reason as in
! src/mpif_attr_fns.F90: MPI is handed a sentinel, not a procedure. They do what
! the standard prescribes anyway -- the copy callbacks report .FALSE. and touch
! nothing else except the DUP variants, which copy; the delete callbacks do
! nothing; the conversion functions do nothing -- in case a program calls one
! directly, which MPICH's winattrf does.

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

     subroutine mpif_f08_type_null_delete_fn(datatype, type_keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype) :: datatype
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
       use, intrinsic :: iso_c_binding, only: C_PTR
       import :: MPI_Datatype
       implicit none
       type(C_PTR), value :: userbuf
       type(MPI_Datatype) :: datatype
       integer :: count
       type(C_PTR), value :: filebuf
       integer(MPI_OFFSET_KIND) :: position
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine mpif_f08_conversion_fn_null

     subroutine mpif_f08_conversion_fn_null_c(userbuf, datatype, count, filebuf, &
          position, extra_state, ierror)
       use mpif_f08_constants
       use, intrinsic :: iso_c_binding, only: C_PTR
       import :: MPI_Datatype
       implicit none
       type(C_PTR), value :: userbuf
       type(MPI_Datatype) :: datatype
       integer(MPI_COUNT_KIND) :: count
       type(C_PTR), value :: filebuf
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
  ! Nothing is written to attribute_val_out: MPI-5.0 has it that this "is a
  ! function that does nothing other than returning flag = 0 and MPI_SUCCESS",
  ! and MPICH's winattrf calls it directly and requires the argument to come back
  ! untouched. The DUP variants below do copy, which is what makes them DUP.
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
  ! Nothing is written to attribute_val_out: MPI-5.0 has it that this "is a
  ! function that does nothing other than returning flag = 0 and MPI_SUCCESS",
  ! and MPICH's winattrf calls it directly and requires the argument to come back
  ! untouched. The DUP variants below do copy, which is what makes them DUP.
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
  ! Nothing is written to attribute_val_out: MPI-5.0 has it that this "is a
  ! function that does nothing other than returning flag = 0 and MPI_SUCCESS",
  ! and MPICH's winattrf calls it directly and requires the argument to come back
  ! untouched. The DUP variants below do copy, which is what makes them DUP.
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

subroutine mpif_f08_type_null_delete_fn(datatype, type_keyval, attribute_val, extra_state, ierror)
  use mpif_f08_types, only: MPI_Datatype
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  type(MPI_Datatype) :: datatype
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

! A pure sentinel, meaning "no conversion is needed", and MPI never calls it --
! hence MPI_ERR_INTERN rather than a plausible-looking no-op, so that a call
! that somehow does arrive is noticed. Matches the mpif.h/mpi module twins'
! MPI_CONVERSION_FN_NULL/_C in mpif_attr_fns.F90.
subroutine mpif_f08_conversion_fn_null(userbuf, datatype, count, filebuf, &
     position, extra_state, ierror)
  use mpif_f08_types, only: MPI_Datatype
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_COUNT_KIND, MPI_ERR_INTERN, &
       MPI_OFFSET_KIND
  use, intrinsic :: iso_c_binding, only: C_PTR
  implicit none
  type(C_PTR), value :: userbuf
  type(MPI_Datatype) :: datatype
  integer :: count
  type(C_PTR), value :: filebuf
  integer(MPI_OFFSET_KIND) :: position
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
  ierror = MPI_ERR_INTERN
end subroutine mpif_f08_conversion_fn_null

subroutine mpif_f08_conversion_fn_null_c(userbuf, datatype, count, filebuf, &
     position, extra_state, ierror)
  use mpif_f08_types, only: MPI_Datatype
  use mpif_f08_constants, only: MPI_ADDRESS_KIND, MPI_COUNT_KIND, MPI_ERR_INTERN, &
       MPI_OFFSET_KIND
  use, intrinsic :: iso_c_binding, only: C_PTR
  implicit none
  type(C_PTR), value :: userbuf
  type(MPI_Datatype) :: datatype
  integer(MPI_COUNT_KIND) :: count
  type(C_PTR), value :: filebuf
  integer(MPI_OFFSET_KIND) :: position
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
  ierror = MPI_ERR_INTERN
end subroutine mpif_f08_conversion_fn_null_c
