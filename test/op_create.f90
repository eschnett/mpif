! A user-defined reduction operator, from all three Fortran interfaces.
!
! The callback's buffers are the point. MPI-5.0 declares `MPI_User_function`'s
! `invec` and `inoutvec` `TYPE(C_PTR), VALUE` in `mpi_f08` (section 6.9.5, and
! again in 19.1.6) and `<type> INVEC(LEN)` -- choice buffers -- in `mpif.h` and
! the `mpi` module. mpif declared them `INTEGER(KIND=MPI_ADDRESS_KIND)` by
! reference in `mpi_f08`, which asks for the address of a *variable holding* the
! buffer address, one indirection too many: a callback written against mpif's own
! interface read the first bytes of the data as a pointer. The trampoline in
! `src/mpif_callbacks.c` passes the buffer address itself, as it must for the
! other two interfaces, there being one C entry point behind all three.
!
! Nothing exercised any of this before: MPICH's suite has no f08 test that calls
! `MPI_Op_create`, and mpif had none either. Both halves of the assertion are
! here, and the f08 half makes two at once -- that a callback written the way the
! standard writes it can be passed at all, which is a compile-time claim, and
! that the buffers it then receives are the data, which is a run-time one.
!
! `MPI_Reduce_local` rather than a collective, because these tests run on one
! process and a one-process reduction need not call the operator at all --
! `MPI_Reduce_local` always does. Both the small and the large-count forms are
! covered, `MPI_Op_create` and `MPI_Op_create_c` having an abstract interface
! each.
!
! `use mpi` and `use mpi_f08` cannot share a scoping unit, so the f08 half lives
! in a module of its own.

module op_create_f08_part
  use mpi_f08
  use, intrinsic :: iso_c_binding, only: C_PTR, C_F_POINTER
  implicit none
  ! Or every mpi_f08 name would be re-exported and clash with the mpi module's
  private
  public :: check_f08
contains

  ! Written exactly as MPI-5.0 declares MPI_User_function, intents and all --
  ! which is to say none -- so that passing it to the PROCEDURE(MPI_User_function)
  ! dummy of the generated wrapper asserts that mpif's interface is the
  ! standard's.
  subroutine f08_sum(invec, inoutvec, len, datatype)
    type(C_PTR), value :: invec
    type(C_PTR), value :: inoutvec
    integer :: len
    type(MPI_Datatype) :: datatype
    integer, pointer :: in(:), inout(:)

    if (datatype /= MPI_INTEGER) stop 30
    call C_F_POINTER(invec, in, [len])
    call C_F_POINTER(inoutvec, inout, [len])
    inout(1:len) = inout(1:len) + in(1:len)
  end subroutine f08_sum

  ! The large-count form: the same, with an MPI_COUNT_KIND length
  subroutine f08_sum_c(invec, inoutvec, len, datatype)
    type(C_PTR), value :: invec
    type(C_PTR), value :: inoutvec
    integer(MPI_COUNT_KIND) :: len
    type(MPI_Datatype) :: datatype
    integer, pointer :: in(:), inout(:)

    if (datatype /= MPI_INTEGER) stop 31
    call C_F_POINTER(invec, in, [len])
    call C_F_POINTER(inoutvec, inout, [len])
    inout(1:len) = inout(1:len) + in(1:len)
  end subroutine f08_sum_c

  subroutine check_f08()
    integer, parameter :: n = 4
    integer :: inbuf(n), inoutbuf(n), i
    integer(MPI_COUNT_KIND) :: count_c
    type(MPI_Op) :: op

    do i = 1, n
       inbuf(i) = i
       inoutbuf(i) = 10 * i
    end do

    call MPI_Op_create(f08_sum, .true., op)
    call MPI_Reduce_local(inbuf, inoutbuf, n, MPI_INTEGER, op)
    do i = 1, n
       if (inoutbuf(i) /= 11 * i) stop 32
    end do
    call MPI_Op_free(op)
    print '("mpi_f08 MPI_Op_create with TYPE(C_PTR), VALUE buffers: ok")'

    do i = 1, n
       inoutbuf(i) = 100 * i
    end do
    count_c = n
    call MPI_Op_create_c(f08_sum_c, .true., op)
    call MPI_Reduce_local_c(inbuf, inoutbuf, count_c, MPI_INTEGER, op)
    do i = 1, n
       if (inoutbuf(i) /= 101 * i) stop 33
    end do
    call MPI_Op_free(op)
    print '("mpi_f08 MPI_Op_create_c with TYPE(C_PTR), VALUE buffers: ok")'
  end subroutine check_f08

end module op_create_f08_part

! The mpi module's form, which is the standard's `<type> INVEC(LEN)`. An external
! subroutine, as MPI_Op_create's `external :: user_fn` expects; the trampoline
! hands it the same address the f08 callback receives as a TYPE(C_PTR).
subroutine f90_sum(invec, inoutvec, len, datatype)
  implicit none
  integer :: len, datatype
  integer :: invec(len), inoutvec(len)
  integer :: i

  do i = 1, len
     inoutvec(i) = inoutvec(i) + invec(i)
  end do
end subroutine f90_sum

program op_create
  use mpi
  use op_create_f08_part
  implicit none

  integer, parameter :: n = 4
  integer :: inbuf(n), inoutbuf(n), i, ierr, op
  external :: f90_sum

  call MPI_Init(ierr)
  if (ierr /= MPI_SUCCESS) stop 1

  do i = 1, n
     inbuf(i) = i
     inoutbuf(i) = 10 * i
  end do

  call MPI_Op_create(f90_sum, .true., op, ierr)
  if (ierr /= MPI_SUCCESS) stop 2
  call MPI_Reduce_local(inbuf, inoutbuf, n, MPI_INTEGER, op, ierr)
  if (ierr /= MPI_SUCCESS) stop 3
  do i = 1, n
     if (inoutbuf(i) /= 11 * i) stop 4
  end do
  call MPI_Op_free(op, ierr)
  if (ierr /= MPI_SUCCESS) stop 5
  print '("mpi module MPI_Op_create with a choice-buffer callback: ok")'

  call check_f08()

  print '("op_create: all ok")'

  call MPI_Finalize(ierr)

end program op_create
