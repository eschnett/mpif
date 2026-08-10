! MPI_Buffer_detach, MPI_Comm_detach_buffer and MPI_Session_detach_buffer return
! the detached buffer through `buffer_addr`, and MPI-5.0 declares it differently
! in each binding -- but never as an integer:
!
! - `TYPE(C_PTR), INTENT(OUT)` in mpi_f08 (A.4.1, A.4.3 and A.4.12);
! - `<type> BUFFER_ADDR(*)`, a choice buffer, in the mpi module and mpif.h
!   (A.5.1, A.5.3 and A.5.12).
!
! mpif declared it `INTEGER(KIND=MPI_ADDRESS_KIND)` in all six bindings -- the
! three routines and their `_c` forms -- because `apis.json` gives the parameter
! the kind `C_BUFFER2` and the generator treated that as an address. That was
! wrong in both bindings at once:
!
! - in mpi_f08 a caller holding the TYPE(C_PTR) the standard asks for could not
!   pass it at all;
! - in the mpi module a caller passing anything but an address-sized integer did
!   not compile, which is what MPICH's `f90/pt2pt/bsendf90` does with a
!   `character dummy_buf(400)` -- "Type mismatch in argument 'buffer_addr' at
!   (1); passed CHARACTER(1) to INTEGER(8)".
!
! Both are asserted here, in one executable: `use mpi` and `use mpi_f08` cannot
! share a scoping unit, so the f08 half lives in a module of its own. Half the
! assertion is that this file compiles at all; the other half is that the address
! that comes back is the one that went in, since the f08 wrapper now returns it
! through a temporary and `transfer`.
!
! The address-sized integer the old declaration insisted on still has to work in
! the mpi module, a choice buffer accepting anything, and that is how a Fortran
! caller reads the address out where there is no TYPE(C_PTR) form; it is checked
! below on MPI_Comm_detach_buffer.

module buffer_detach_f08_part
  use mpi_f08
  use, intrinsic :: iso_c_binding, only: C_PTR, C_CHAR, C_LOC, C_ASSOCIATED
  implicit none
  ! Or every mpi_f08 name would be re-exported and clash with the mpi module's
  private
  public :: check_f08
contains

  ! mpi_f08: TYPE(C_PTR) is the only form, for all three routines
  subroutine check_f08()
    integer, parameter :: nbytes = 4000
    character(kind=C_CHAR), target :: buf(nbytes)
    character(kind=C_CHAR), target :: comm_buf(nbytes)
    character(kind=C_CHAR), target :: session_buf(nbytes)
    type(C_PTR) :: addr
    type(MPI_Session) :: session
    integer :: bsize, sendbuf, recvbuf

    ! The process-wide buffer, with a buffered send through it so that the detach
    ! has something to flush
    call MPI_Buffer_attach(buf, nbytes)
    sendbuf = 42
    call MPI_Bsend(sendbuf, 1, MPI_INTEGER, 0, 1, MPI_COMM_SELF)
    recvbuf = 0
    call MPI_Recv(recvbuf, 1, MPI_INTEGER, 0, 1, MPI_COMM_SELF, MPI_STATUS_IGNORE)
    if (recvbuf /= 42) stop 10
    call MPI_Buffer_detach(addr, bsize)
    if (.not. C_ASSOCIATED(addr, C_LOC(buf(1)))) stop 11
    if (bsize /= nbytes) stop 12
    print '("mpi_f08 MPI_Buffer_detach with TYPE(C_PTR): ok")'

    ! The communicator-specific buffer
    call MPI_Comm_attach_buffer(MPI_COMM_SELF, comm_buf, nbytes)
    call MPI_Comm_detach_buffer(MPI_COMM_SELF, addr, bsize)
    if (.not. C_ASSOCIATED(addr, C_LOC(comm_buf(1)))) stop 13
    if (bsize /= nbytes) stop 14
    print '("mpi_f08 MPI_Comm_detach_buffer with TYPE(C_PTR): ok")'

    ! The session-specific buffer
    ! MPI_ERRORS_ARE_FATAL rather than MPI_ERRHANDLER_NULL: the latter is not a
    ! valid error handler, and MPICH says so -- "internal_Session_init: Null
    ! errhandler".
    call MPI_Session_init(MPI_INFO_NULL, MPI_ERRORS_ARE_FATAL, session)
    call MPI_Session_attach_buffer(session, session_buf, nbytes)
    call MPI_Session_detach_buffer(session, addr, bsize)
    if (.not. C_ASSOCIATED(addr, C_LOC(session_buf(1)))) stop 15
    if (bsize /= nbytes) stop 16
    call MPI_Session_finalize(session)
    print '("mpi_f08 MPI_Session_detach_buffer with TYPE(C_PTR): ok")'

    ! MPI_BUFFER_AUTOMATIC, which is the reverse-direction sentinel and the only
    ! one in the interface. MPI-5.0 3.6 on the detach procedures: "If
    ! MPI_BUFFER_AUTOMATIC was used in the corresponding attach procedure, then
    ! MPI_BUFFER_AUTOMATIC is also returned in the detach procedure and the value
    ! returned in argument size is undefined ... When using Fortran mpi_f08, the
    ! returned value is identical to c_loc(MPI_BUFFER_AUTOMATIC)."
    !
    ! Two obligations in one assertion. C_LOC applying to MPI_BUFFER_AUTOMATIC at
    ! all is the advice to implementors immediately after -- "the implementation of
    ! MPI_BUFFER_AUTOMATIC must allow the intrinsic c_loc to be applied to it" --
    ! which needs the TARGET attribute on its declaration and which nothing else
    ! in the tree checks. And the value coming back has to have been translated
    ! from the ABI's (void*)2 into the address of mpif's own object, which is the
    ! one C-to-Fortran crossing anywhere in mpif.
    !
    ! `size` is undefined here by that same sentence, so it is deliberately not
    ! asserted.
    call MPI_Buffer_attach(MPI_BUFFER_AUTOMATIC, nbytes)
    sendbuf = 44
    call MPI_Bsend(sendbuf, 1, MPI_INTEGER, 0, 2, MPI_COMM_SELF)
    recvbuf = 0
    call MPI_Recv(recvbuf, 1, MPI_INTEGER, 0, 2, MPI_COMM_SELF, MPI_STATUS_IGNORE)
    if (recvbuf /= 44) stop 17
    call MPI_Buffer_detach(addr, bsize)
    if (.not. C_ASSOCIATED(addr, C_LOC(MPI_BUFFER_AUTOMATIC))) stop 18
    print '("mpi_f08 MPI_BUFFER_AUTOMATIC round-trip: ok")'

    ! The same for a communicator-level buffer, which is a different entry point
    call MPI_Comm_attach_buffer(MPI_COMM_SELF, MPI_BUFFER_AUTOMATIC, nbytes)
    call MPI_Comm_detach_buffer(MPI_COMM_SELF, addr, bsize)
    if (.not. C_ASSOCIATED(addr, C_LOC(MPI_BUFFER_AUTOMATIC))) stop 19
    print '("mpi_f08 MPI_BUFFER_AUTOMATIC through MPI_Comm_detach_buffer: ok")'
  end subroutine check_f08

end module buffer_detach_f08_part

program buffer_detach
  use mpi
  use buffer_detach_f08_part
  implicit none

  integer, parameter :: nbytes = 4000
  ! The bsendf90 shape: a CHARACTER buffer, and a CHARACTER variable to receive
  ! the address. Sixteen of them so that there is room for a pointer whatever
  ! its size.
  character :: buf(nbytes)
  character :: addr_bytes(16)
  character :: comm_buf(nbytes)
  integer(MPI_ADDRESS_KIND) :: addr, expected
  integer :: ierr, bsize, sendbuf, recvbuf

  call MPI_Init(ierr)
  if (ierr /= MPI_SUCCESS) stop 1

  ! The process-wide buffer, detached into a CHARACTER variable, which is what
  ! the standard's `<type> BUFFER_ADDR(*)` allows and what mpif used to reject
  call MPI_Get_address(buf, expected, ierr)
  if (ierr /= MPI_SUCCESS) stop 2
  call MPI_Buffer_attach(buf, nbytes, ierr)
  if (ierr /= MPI_SUCCESS) stop 3
  sendbuf = 42
  call MPI_Bsend(sendbuf, 1, MPI_INTEGER, 0, 1, MPI_COMM_SELF, ierr)
  if (ierr /= MPI_SUCCESS) stop 4
  recvbuf = 0
  call MPI_Recv(recvbuf, 1, MPI_INTEGER, 0, 1, MPI_COMM_SELF, MPI_STATUS_IGNORE, ierr)
  if (ierr /= MPI_SUCCESS) stop 5
  if (recvbuf /= 42) stop 6
  addr_bytes = achar(0)
  call MPI_Buffer_detach(addr_bytes, bsize, ierr)
  if (ierr /= MPI_SUCCESS) stop 7
  ! MPI writes the address into whatever it is handed, so the first bytes of the
  ! CHARACTER variable are the pointer
  if (transfer(addr_bytes, addr) /= expected) stop 8
  if (bsize /= nbytes) stop 9
  print '("mpi module MPI_Buffer_detach with a CHARACTER buffer_addr: ok")'

  ! The address-sized integer, which the old declaration was in the shape of and
  ! which a choice buffer still accepts
  call MPI_Get_address(comm_buf, expected, ierr)
  if (ierr /= MPI_SUCCESS) stop 20
  call MPI_Comm_attach_buffer(MPI_COMM_SELF, comm_buf, nbytes, ierr)
  if (ierr /= MPI_SUCCESS) stop 21
  addr = 0
  call MPI_Comm_detach_buffer(MPI_COMM_SELF, addr, bsize, ierr)
  if (ierr /= MPI_SUCCESS) stop 22
  if (addr /= expected) stop 23
  if (bsize /= nbytes) stop 24
  print '("mpi module MPI_Comm_detach_buffer with an address-kind buffer_addr: ok")'

  call check_f08()

  print '("buffer_detach: all ok")'

  call MPI_Finalize(ierr)

end program buffer_detach
