! The named handle types, TYPE(MPI_Status), the handle comparison operators and
! the two status converters.
!
! MPI-5.0 section 19.1.3 requires all of this from *both* Fortran modules: among
! the mpi module's obligations it lists "Define the derived type MPI_Status and
! all named handle types that are used in the mpi_f08 module. For these named
! handle types, overload the operators .EQ. and .NE. to allow handle comparison
! via the .EQ., .NE., == and /= operators." MPI_Status_f2f08 and MPI_Status_f082f
! (section 19.3.5, Appendix A.5.13) are the only two A.5 bindings marked "not
! available with mpif.h", which is to say required in the mpi module and exempt
! only for the include file.
!
! "that are used in the mpi_f08 module" is why they live here rather than being
! declared twice: it is one set of types, so a TYPE(MPI_Status) obtained through
! the mpi module is the very same type mpi_f08 expects, and passing one to the
! other needs no conversion. Open MPI reads it the same way and has a module of
! exactly this shape, ompi/mpi/fortran/use-mpi/mpi-types.F90, whose comment says
! "yes, the MPI spec requires that the TYPE(MPI_Blah) types all show up in both
! modules". MPICH instead declares a second, distinct set in its mpi_constants,
! so its `use mpi` MPI_Comm and its `use mpi_f08` MPI_Comm are different types.
!
! The module sits *below* both mpi and mpif_f08_types because it cannot sit
! beside either. mpif_f08_types cannot export the types down into mpi: it does
! `use mpi, only: ...` to build its PARAMETER handle constants out of the mpi
! module's INTEGER constants, so mpi using it back would be circular. Only
! mpif_constants is below this, and all this needs from it are MPI_STATUS_SIZE,
! the three status indices and MPI_SUCCESS.
!
! The f08 PARAMETER handle constants (`type(MPI_Comm), parameter ::
! MPI_COMM_WORLD`) deliberately stay in mpif_f08_types. In the mpi module
! MPI_COMM_WORLD must remain the INTEGER constant that mpif.h and the mpi module
! give it; only the types are shared, not the constants named after them.

module mpif_handle_types
  use mpif_constants, only: &
       MPI_STATUS_SIZE, &
       MPI_SOURCE, &
       MPI_TAG, &
       MPI_ERROR, &
       MPI_SUCCESS

  implicit none
  private
  save

  ! Handles

  type, bind(C), public :: MPI_Comm
     integer :: MPI_VAL
  end type MPI_Comm

  type, bind(C), public :: MPI_Datatype
     integer :: MPI_VAL
  end type MPI_Datatype

  type, bind(C), public :: MPI_Errhandler
     integer :: MPI_VAL
  end type MPI_Errhandler

  type, bind(C), public :: MPI_File
     integer :: MPI_VAL
  end type MPI_File

  type, bind(C), public :: MPI_Group
     integer :: MPI_VAL
  end type MPI_Group

  type, bind(C), public :: MPI_Info
     integer :: MPI_VAL
  end type MPI_Info

  type, bind(C), public :: MPI_Message
     integer :: MPI_VAL
  end type MPI_Message

  type, bind(C), public :: MPI_Op
     integer :: MPI_VAL
  end type MPI_Op

  type, bind(C), public :: MPI_Request
     integer :: MPI_VAL
  end type MPI_Request

  type, bind(C), public :: MPI_Session
     integer :: MPI_VAL
  end type MPI_Session

  type, bind(C), public :: MPI_Win
     integer :: MPI_VAL
  end type MPI_Win

  public :: operator(==), operator(/=)

  interface operator(==)
     module procedure mpif_comm_equal
     module procedure mpif_datatype_equal
     module procedure mpif_errhandler_equal
     module procedure mpif_file_equal
     module procedure mpif_group_equal
     module procedure mpif_info_equal
     module procedure mpif_message_equal
     module procedure mpif_op_equal
     module procedure mpif_request_equal
     module procedure mpif_session_equal
     module procedure mpif_win_equal
  end interface operator(==)

  interface operator(/=)
     module procedure mpif_comm_not_equal
     module procedure mpif_datatype_not_equal
     module procedure mpif_errhandler_not_equal
     module procedure mpif_file_not_equal
     module procedure mpif_group_not_equal
     module procedure mpif_info_not_equal
     module procedure mpif_message_not_equal
     module procedure mpif_op_not_equal
     module procedure mpif_request_not_equal
     module procedure mpif_session_not_equal
     module procedure mpif_win_not_equal
  end interface operator(/=)

  ! Status

  type, bind(C), public :: MPI_Status
     integer :: MPI_SOURCE
     integer :: MPI_TAG
     integer :: MPI_ERROR
     integer :: MPI_INTERNAL(5)
  end type MPI_Status

  public :: MPI_Status_f2f08
  public :: MPI_Status_f082f

  ! MPI-5.0 section 15.2 asks for a P-prefixed second procedure for every MPI
  ! procedure, these two included; MPICH has all four as module procedures too,
  ! in its use_mpi_f08/mpi_f08_types.f90, and so reachable from mpi_f08 only.
  public :: PMPI_Status_f2f08
  public :: PMPI_Status_f082f

contains

  logical function mpif_comm_equal(comm1, comm2) result(result)
    type(MPI_Comm), intent(in) :: comm1, comm2
    result = comm1%MPI_VAL == comm2%MPI_VAL
  end function mpif_comm_equal

  logical function mpif_comm_not_equal(comm1, comm2) result(result)
    type(MPI_Comm), intent(in) :: comm1, comm2
    result = .not.(comm1 == comm2)
  end function mpif_comm_not_equal

  logical function mpif_datatype_equal(type1, type2) result(result)
    type(MPI_Datatype), intent(in) :: type1, type2
    result = type1%MPI_VAL == type2%MPI_VAL
  end function mpif_datatype_equal

  logical function mpif_datatype_not_equal(type1, type2) result(result)
    type(MPI_Datatype), intent(in) :: type1, type2
    result = .not.(type1 == type2)
  end function mpif_datatype_not_equal

  logical function mpif_errhandler_equal(errhandler1, errhandler2) result(result)
    type(MPI_Errhandler), intent(in) :: errhandler1, errhandler2
    result = errhandler1%MPI_VAL == errhandler2%MPI_VAL
  end function mpif_errhandler_equal

  logical function mpif_errhandler_not_equal(errhandler1, errhandler2) result(result)
    type(MPI_Errhandler), intent(in) :: errhandler1, errhandler2
    result = .not.(errhandler1 == errhandler2)
  end function mpif_errhandler_not_equal

  logical function mpif_file_equal(file1, file2) result(result)
    type(MPI_File), intent(in) :: file1, file2
    result = file1%MPI_VAL == file2%MPI_VAL
  end function mpif_file_equal

  logical function mpif_file_not_equal(file1, file2) result(result)
    type(MPI_File), intent(in) :: file1, file2
    result = .not.(file1 == file2)
  end function mpif_file_not_equal

  logical function mpif_group_equal(group1, group2) result(result)
    type(MPI_Group), intent(in) :: group1, group2
    result = group1%MPI_VAL == group2%MPI_VAL
  end function mpif_group_equal

  logical function mpif_group_not_equal(group1, group2) result(result)
    type(MPI_Group), intent(in) :: group1, group2
    result = .not.(group1 == group2)
  end function mpif_group_not_equal

  logical function mpif_info_equal(info1, info2) result(result)
    type(MPI_Info), intent(in) :: info1, info2
    result = info1%MPI_VAL == info2%MPI_VAL
  end function mpif_info_equal

  logical function mpif_info_not_equal(info1, info2) result(result)
    type(MPI_Info), intent(in) :: info1, info2
    result = .not.(info1 == info2)
  end function mpif_info_not_equal

  logical function mpif_message_equal(message1, message2) result(result)
    type(MPI_Message), intent(in) :: message1, message2
    result = message1%MPI_VAL == message2%MPI_VAL
  end function mpif_message_equal

  logical function mpif_message_not_equal(message1, message2) result(result)
    type(MPI_Message), intent(in) :: message1, message2
    result = .not.(message1 == message2)
  end function mpif_message_not_equal

  logical function mpif_op_equal(op1, op2) result(result)
    type(MPI_Op), intent(in) :: op1, op2
    result = op1%MPI_VAL == op2%MPI_VAL
  end function mpif_op_equal

  logical function mpif_op_not_equal(op1, op2) result(result)
    type(MPI_Op), intent(in) :: op1, op2
    result = .not.(op1 == op2)
  end function mpif_op_not_equal

  logical function mpif_request_equal(request1, request2) result(result)
    type(MPI_Request), intent(in) :: request1, request2
    result = request1%MPI_VAL == request2%MPI_VAL
  end function mpif_request_equal

  logical function mpif_request_not_equal(request1, request2) result(result)
    type(MPI_Request), intent(in) :: request1, request2
    result = .not.(request1 == request2)
  end function mpif_request_not_equal

  logical function mpif_session_equal(session1, session2) result(result)
    type(MPI_Session), intent(in) :: session1, session2
    result = session1%MPI_VAL == session2%MPI_VAL
  end function mpif_session_equal

  logical function mpif_session_not_equal(session1, session2) result(result)
    type(MPI_Session), intent(in) :: session1, session2
    result = .not.(session1 == session2)
  end function mpif_session_not_equal

  logical function mpif_win_equal(win1, win2) result(result)
    type(MPI_Win), intent(in) :: win1, win2
    result = win1%MPI_VAL == win2%MPI_VAL
  end function mpif_win_equal

  logical function mpif_win_not_equal(win1, win2) result(result)
    type(MPI_Win), intent(in) :: win1, win2
    result = .not.(win1 == win2)
  end function mpif_win_not_equal

  subroutine MPI_Status_f2f08(f_status, f08_status, ierror)
    integer, intent(in) :: f_status(MPI_STATUS_SIZE)
    type(MPI_Status), intent(out) :: f08_status
    integer, optional, intent(out) :: ierror
    f08_status%MPI_SOURCE = f_status(MPI_SOURCE)
    f08_status%MPI_TAG = f_status(MPI_TAG)
    f08_status%MPI_ERROR = f_status(MPI_ERROR)
    f08_status%MPI_internal(1:5) = f_status(4:8)
    if (present(ierror)) ierror = MPI_SUCCESS
  end subroutine MPI_Status_f2f08

  subroutine MPI_Status_f082f(f08_status, f_status, ierror)
    type(MPI_Status), intent(in) :: f08_status
    integer, intent(out) :: f_status(MPI_STATUS_SIZE)
    integer, optional, intent(out) :: ierror
    f_status(MPI_SOURCE) = f08_status%MPI_SOURCE
    f_status(MPI_TAG) = f08_status%MPI_TAG
    f_status(MPI_ERROR) = f08_status%MPI_ERROR
    f_status(4:8) = f08_status%MPI_internal(1:5)
    if (present(ierror)) ierror = MPI_SUCCESS
  end subroutine MPI_Status_f082f

  ! Both conversions are pure Fortran -- MPI is not involved and there is nothing
  ! for a tool to interpose between these and the library -- so the P forms
  ! forward, leaving the field-by-field copy written once.

  subroutine PMPI_Status_f2f08(f_status, f08_status, ierror)
    integer, intent(in) :: f_status(MPI_STATUS_SIZE)
    type(MPI_Status), intent(out) :: f08_status
    integer, optional, intent(out) :: ierror
    call MPI_Status_f2f08(f_status, f08_status, ierror)
  end subroutine PMPI_Status_f2f08

  subroutine PMPI_Status_f082f(f08_status, f_status, ierror)
    type(MPI_Status), intent(in) :: f08_status
    integer, intent(out) :: f_status(MPI_STATUS_SIZE)
    integer, optional, intent(out) :: ierror
    call MPI_Status_f082f(f08_status, f_status, ierror)
  end subroutine PMPI_Status_f082f

end module mpif_handle_types
