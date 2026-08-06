! MPI-5.0 section 19.1.3 requires the mpi module to "Define the derived type
! MPI_Status and all named handle types that are used in the mpi_f08 module. For
! these named handle types, overload the operators .EQ. and .NE. to allow handle
! comparison via the .EQ., .NE., == and /= operators."  A.5.13 adds
! MPI_Status_f2f08 and MPI_Status_f082f, the only two A.5 bindings marked "not
! available with mpif.h" -- required here, exempt only for the include file.
!
! mpif had none of it in the mpi module: the declarations at the top of the
! program below failed to compile with
!
!     Error: Derived type 'mpi_status' at (1) is being used before it is defined
!     Error: Derived type 'mpi_comm' at (1) is being used before it is defined
!
! which is what this test is here to keep from coming back. The types now live in
! src/mpif_handle_types.F90, which both mpi and mpif_f08_types use.
!
! "all named handle types that are used in the mpi_f08 module" is one set of
! types, not two, so the companion module below is the other half of the test: it
! is written in mpi_f08 terms and receives handles and a status built here, in mpi
! module terms. If the two modules declared types of their own the calls would not
! compile. (MPICH does declare two sets; Open MPI shares one, as mpif now does.)

module handle_types_f08_companion
  use mpi_f08
  implicit none
  private

  public :: f08_check_comm
  public :: f08_check_status

contains

  ! TYPE(MPI_Comm) and the f08 PARAMETER MPI_COMM_WORLD, against a handle the
  ! caller built out of the mpi module's INTEGER MPI_COMM_WORLD.
  subroutine f08_check_comm(comm)
    type(MPI_Comm), intent(in) :: comm
    if (comm /= MPI_COMM_WORLD) stop 1
    if (.not. comm == MPI_COMM_WORLD) stop 1
  end subroutine f08_check_comm

  ! The status the caller converted with MPI_Status_f2f08, read through mpi_f08's
  ! own MPI_Get_count: that reaches the MPI_INTERNAL fields, which the named
  ! components do not, so it is the assertion that the whole status crossed over.
  subroutine f08_check_status(status, expect_count)
    type(MPI_Status), intent(in) :: status
    integer, intent(in) :: expect_count
    integer :: count
    call MPI_Get_count(status, MPI_INTEGER, count)
    if (count /= expect_count) stop 1
  end subroutine f08_check_status

end module handle_types_f08_companion

program handle_types_f90
  use mpi
  use handle_types_f08_companion, only: f08_check_comm, f08_check_status
  implicit none

  integer, parameter :: n = 7
  integer, parameter :: tag = 42

  type(MPI_Status) :: s, s2
  type(MPI_Comm) :: c1, c2, c3

  type(MPI_Datatype) :: d1, d2
  type(MPI_Errhandler) :: e1, e2
  type(MPI_File) :: fh1, fh2
  type(MPI_Group) :: g1, g2
  type(MPI_Info) :: i1, i2
  type(MPI_Message) :: m1, m2
  type(MPI_Op) :: o1, o2
  type(MPI_Request) :: r1, r2
  type(MPI_Session) :: se1, se2
  type(MPI_Win) :: w1, w2

  integer :: fstatus(MPI_STATUS_SIZE), fstatus2(MPI_STATUS_SIZE)
  integer :: sendbuf(n), recvbuf(n)
  integer :: rank, count, count2
  integer :: ierror

  call MPI_Init(ierror)
  if (ierror /= MPI_SUCCESS) stop 1

  ! Handle comparison. All four spellings the standard names, on MPI_Comm, and
  ! then == and /= on the other ten types so that every specific behind the two
  ! generics is reached. The MPI_VALs need not be valid handles; nothing here
  ! passes one to MPI.

  c1 = MPI_Comm(MPI_COMM_WORLD)
  c2 = MPI_Comm(MPI_COMM_WORLD)
  c3 = MPI_Comm(MPI_COMM_SELF)

  if (.not. c1 == c2) stop 1
  if (c1 /= c2) stop 1
  if (.not. c1 .EQ. c2) stop 1
  if (c1 .NE. c2) stop 1

  if (c1 == c3) stop 1
  if (.not. c1 /= c3) stop 1
  if (c1 .EQ. c3) stop 1
  if (.not. c1 .NE. c3) stop 1

  d1 = MPI_Datatype(MPI_INTEGER)
  d2 = MPI_Datatype(MPI_REAL)
  if (.not. d1 == d1) stop 1
  if (.not. d1 /= d2) stop 1

  e1 = MPI_Errhandler(MPI_ERRORS_RETURN)
  e2 = MPI_Errhandler(MPI_ERRHANDLER_NULL)
  if (.not. e1 == e1) stop 1
  if (.not. e1 /= e2) stop 1

  fh1 = MPI_File(MPI_FILE_NULL)
  fh2 = MPI_File(MPI_FILE_NULL + 1)
  if (.not. fh1 == fh1) stop 1
  if (.not. fh1 /= fh2) stop 1

  g1 = MPI_Group(MPI_GROUP_EMPTY)
  g2 = MPI_Group(MPI_GROUP_NULL)
  if (.not. g1 == g1) stop 1
  if (.not. g1 /= g2) stop 1

  i1 = MPI_Info(MPI_INFO_ENV)
  i2 = MPI_Info(MPI_INFO_NULL)
  if (.not. i1 == i1) stop 1
  if (.not. i1 /= i2) stop 1

  m1 = MPI_Message(MPI_MESSAGE_NO_PROC)
  m2 = MPI_Message(MPI_MESSAGE_NULL)
  if (.not. m1 == m1) stop 1
  if (.not. m1 /= m2) stop 1

  o1 = MPI_Op(MPI_SUM)
  o2 = MPI_Op(MPI_MAX)
  if (.not. o1 == o1) stop 1
  if (.not. o1 /= o2) stop 1

  r1 = MPI_Request(MPI_REQUEST_NULL)
  r2 = MPI_Request(MPI_REQUEST_NULL + 1)
  if (.not. r1 == r1) stop 1
  if (.not. r1 /= r2) stop 1

  se1 = MPI_Session(MPI_SESSION_NULL)
  se2 = MPI_Session(MPI_SESSION_NULL + 1)
  if (.not. se1 == se1) stop 1
  if (.not. se1 /= se2) stop 1

  w1 = MPI_Win(MPI_WIN_NULL)
  w2 = MPI_Win(MPI_WIN_NULL + 1)
  if (.not. w1 == w1) stop 1
  if (.not. w1 /= w2) stop 1

  ! One set of types, not two: the handle goes to a procedure that declares its
  ! dummy argument in mpi_f08's terms.
  call f08_check_comm(c1)

  ! A real status, round-tripped. MPI_Sendrecv to self so that one rank suffices.

  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)
  if (ierror /= MPI_SUCCESS) stop 1

  sendbuf = [1, 2, 3, 4, 5, 6, 7]
  recvbuf = 0

  call MPI_Sendrecv(sendbuf, n, MPI_INTEGER, rank, tag, &
                    recvbuf, n, MPI_INTEGER, rank, tag, &
                    MPI_COMM_WORLD, fstatus, ierror)
  if (ierror /= MPI_SUCCESS) stop 1
  if (any(recvbuf /= sendbuf)) stop 1

  call MPI_Get_count(fstatus, MPI_INTEGER, count, ierror)
  if (ierror /= MPI_SUCCESS) stop 1
  if (count /= n) stop 1

  call MPI_Status_f2f08(fstatus, s, ierror)
  if (ierror /= MPI_SUCCESS) stop 1
  if (s%MPI_SOURCE /= rank) stop 1
  if (s%MPI_TAG /= tag) stop 1
  if (s%MPI_ERROR /= fstatus(MPI_ERROR)) stop 1

  ! The count is not one of the three named components, so this is what says the
  ! internal fields came across as well.
  call f08_check_status(s, n)

  ! ... and back. Every element has to survive, the internal ones included, which
  ! is why the whole array is compared and MPI_Get_count asked again.
  call MPI_Status_f082f(s, fstatus2, ierror)
  if (ierror /= MPI_SUCCESS) stop 1
  if (any(fstatus2 /= fstatus)) stop 1

  call MPI_Get_count(fstatus2, MPI_INTEGER, count2, ierror)
  if (ierror /= MPI_SUCCESS) stop 1
  if (count2 /= n) stop 1

  ! The P forms, once each. MPI-5.0 section 15.2 asks for a P-prefixed second
  ! procedure for every MPI procedure.
  call PMPI_Status_f2f08(fstatus, s2, ierror)
  if (ierror /= MPI_SUCCESS) stop 1
  if (s2%MPI_SOURCE /= s%MPI_SOURCE) stop 1
  if (s2%MPI_TAG /= s%MPI_TAG) stop 1
  if (s2%MPI_ERROR /= s%MPI_ERROR) stop 1

  fstatus2 = -1
  call PMPI_Status_f082f(s2, fstatus2, ierror)
  if (ierror /= MPI_SUCCESS) stop 1
  if (any(fstatus2 /= fstatus)) stop 1

  ! `ierror` is OPTIONAL in both, as A.5.13 gives it.
  call MPI_Status_f2f08(fstatus, s2)
  call MPI_Status_f082f(s2, fstatus2)
  if (any(fstatus2 /= fstatus)) stop 1

  call MPI_Finalize(ierror)
  if (ierror /= MPI_SUCCESS) stop 1

end program handle_types_f90
