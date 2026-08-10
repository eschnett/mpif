! MPI_BOTTOM from mpif.h and from the mpi module, with an absolute-address
! datatype.
!
! test/bottom_cfi_f08.f90 covers the assumed-rank path; these two interfaces had
! no MPI_BOTTOM test of their own, and they reach a different set of entry points
! -- the ignore_tkr ones in gen/mpif_functions.c rather than the cdesc ones.
!
! This is the test that catches a *read-side* missed translation, the one kind the
! read-only sentinel cells cannot turn into a fault. The datatype's displacements
! come from MPI_Get_address, so they are true addresses, and the standard's rule
! (MPI-5.0 2.5.6: absolute addresses are "displacements relative to address zero")
! only holds if MPI is handed the ABI's (void*)0. Hand it the address of mpif's
! own COMMON block instead and every displacement is off by that address: the
! transfer reads and writes wild memory rather than x and y, so `y /= 42` -- or a
! crash. MPI_Get_address is itself a buffer crossing and is translated on the same
! path, which is what makes the two consistent.

module bottom_f90_part
  use mpi
  implicit none
  private
  public :: check_f90
contains

  subroutine check_f90()
    integer :: x, y
    integer(MPI_ADDRESS_KIND) :: addr_x(1), addr_y(1)
    integer :: tx, ty
    integer :: ierror

    call MPI_Get_address(x, addr_x(1), ierror)
    call MPI_Get_address(y, addr_y(1), ierror)
    call MPI_Type_create_hindexed_block(1, 1, addr_x, MPI_INT, tx, ierror)
    call MPI_Type_create_hindexed_block(1, 1, addr_y, MPI_INT, ty, ierror)
    call MPI_Type_commit(tx, ierror)
    call MPI_Type_commit(ty, ierror)

    x = 42
    y = 0
    call MPI_Sendrecv(MPI_BOTTOM, 1, tx, 0, 7, &
                      MPI_BOTTOM, 1, ty, 0, 7, &
                      MPI_COMM_SELF, MPI_STATUS_IGNORE, ierror)
    if (ierror /= MPI_SUCCESS) stop 11
    if (y /= 42) stop 12

    ! MPI_Get_address(MPI_BOTTOM) is zero, which is the same statement about the
    ! same translation seen from the other side.
    call MPI_Get_address(MPI_BOTTOM, addr_x(1), ierror)
    if (addr_x(1) /= 0) stop 13

    call MPI_Type_free(tx, ierror)
    call MPI_Type_free(ty, ierror)
  end subroutine check_f90

end module bottom_f90_part

program bottom
  use bottom_f90_part, only: check_f90
  implicit none
  integer :: ierror

  call MPI_Init(ierror)
  call check_f90()
  call check_mpif_h()
  call MPI_Finalize(ierror)

contains

  subroutine check_mpif_h()
    implicit none
    include 'mpif.h'
    integer :: x, y
    integer(MPI_ADDRESS_KIND) :: addr_x(1), addr_y(1)
    integer :: tx, ty
    integer :: ierr

    call MPI_Get_address(x, addr_x(1), ierr)
    call MPI_Get_address(y, addr_y(1), ierr)
    call MPI_Type_create_hindexed_block(1, 1, addr_x, MPI_INT, tx, ierr)
    call MPI_Type_create_hindexed_block(1, 1, addr_y, MPI_INT, ty, ierr)
    call MPI_Type_commit(tx, ierr)
    call MPI_Type_commit(ty, ierr)

    x = 42
    y = 0
    call MPI_Sendrecv(MPI_BOTTOM, 1, tx, 0, 7, &
                      MPI_BOTTOM, 1, ty, 0, 7, &
                      MPI_COMM_SELF, MPI_STATUS_IGNORE, ierr)
    if (ierr /= MPI_SUCCESS) stop 21
    if (y /= 42) stop 22

    call MPI_Get_address(MPI_BOTTOM, addr_x(1), ierr)
    if (addr_x(1) /= 0) stop 23

    ! MPI_ADDRESS is MPI_GET_ADDRESS's removed MPI-1 form, hand-written in
    ! src/mpif_removed.c rather than generated, and the only hand-written entry
    ! point that takes a choice buffer. It has to translate MPI_BOTTOM the same
    ! way, or the two disagree about the same question.
    block
      integer :: short_addr
      call MPI_ADDRESS(MPI_BOTTOM, short_addr, ierr)
      if (short_addr /= 0) stop 24
    end block

    call MPI_Type_free(tx, ierr)
    call MPI_Type_free(ty, ierr)
  end subroutine check_mpif_h

end program bottom
