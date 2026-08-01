! MPI_Alloc_mem and the window allocators hand back a base address, and the
! standard gives them two Fortran bindings in the mpi module and mpif.h: the base
! one with INTEGER(KIND=MPI_ADDRESS_KIND) BASEPTR and an overload with
! TYPE(C_PTR) BASEPTR under the same generic name. mpif had only the first, so
! `f90/misc/alloc_mem` would not compile -- "Type mismatch in argument 'baseptr';
! passed TYPE(C_PTR) to INTEGER(8)".
!
! In mpi_f08 the standard has only the TYPE(C_PTR) form, and mpif had the
! address-kind one there instead, so that was wrong in the other direction.
!
! Both are checked here, in one executable: `use mpi` and `use mpi_f08` cannot
! share a scoping unit, so the f08 half lives in a module of its own.

module alloc_mem_f08_part
  use mpi_f08
  use, intrinsic :: iso_c_binding, only: C_PTR, C_F_POINTER, C_ASSOCIATED
  implicit none
  ! Or every mpi_f08 name would be re-exported and clash with the mpi module's
  private
  public :: check_f08
contains

  ! mpi_f08: TYPE(C_PTR) is the only form
  subroutine check_f08()
    integer, parameter :: n = 8
    integer(MPI_ADDRESS_KIND) :: bytes
    type(C_PTR) :: baseptr
    integer, pointer :: a(:)
    integer :: elemsize, i

    call MPI_Type_size(MPI_INTEGER, elemsize)
    bytes = int(n, MPI_ADDRESS_KIND) * elemsize

    call MPI_Alloc_mem(bytes, MPI_INFO_NULL, baseptr)
    if (.not. C_ASSOCIATED(baseptr)) stop 10
    call C_F_POINTER(baseptr, a, [n])
    do i = 1, n
       a(i) = i * 3
    end do
    do i = 1, n
       if (a(i) /= i * 3) stop 11
    end do
    call MPI_Free_mem(a)
    print '("mpi_f08 MPI_Alloc_mem with TYPE(C_PTR): ok")'
  end subroutine check_f08

end module alloc_mem_f08_part

program alloc_mem_cptr
  use mpi
  use alloc_mem_f08_part
  use, intrinsic :: iso_c_binding, only: C_PTR, C_NULL_PTR, C_F_POINTER, C_ASSOCIATED
  implicit none

  integer, parameter :: n = 8
  integer :: ierr, elemsize, i, win, disp_unit
  integer(MPI_ADDRESS_KIND) :: bytes, baseptr_aint
  type(C_PTR) :: baseptr
  integer, pointer :: a(:)

  call MPI_Init(ierr)
  call MPI_Type_size(MPI_INTEGER, elemsize, ierr)
  bytes = int(n, MPI_ADDRESS_KIND) * elemsize

  ! The address-kind specific of the generic, which is what mpif always had
  baseptr_aint = 0
  call MPI_Alloc_mem(bytes, MPI_INFO_NULL, baseptr_aint, ierr)
  if (ierr /= MPI_SUCCESS) stop 1
  if (baseptr_aint == 0) stop 2
  call C_F_POINTER(transfer(baseptr_aint, C_NULL_PTR), a, [n])
  a(1) = 123
  if (a(1) /= 123) stop 3
  call MPI_Free_mem(a, ierr)
  print '("mpi module MPI_Alloc_mem with an address-kind baseptr: ok")'

  ! The TYPE(C_PTR) overload, which it did not have
  call MPI_Alloc_mem(bytes, MPI_INFO_NULL, baseptr, ierr)
  if (ierr /= MPI_SUCCESS) stop 4
  if (.not. C_ASSOCIATED(baseptr)) stop 5
  call C_F_POINTER(baseptr, a, [n])
  do i = 1, n
     a(i) = i * 2
  end do
  do i = 1, n
     if (a(i) /= i * 2) stop 6
  end do
  call MPI_Free_mem(a, ierr)
  print '("mpi module MPI_Alloc_mem with TYPE(C_PTR): ok")'

  ! The same overload on a window allocator
  disp_unit = elemsize
  call MPI_Win_allocate(bytes, disp_unit, MPI_INFO_NULL, MPI_COMM_SELF, baseptr, win, ierr)
  if (ierr /= MPI_SUCCESS) stop 7
  if (.not. C_ASSOCIATED(baseptr)) stop 8
  call C_F_POINTER(baseptr, a, [n])
  a(n) = 77
  if (a(n) /= 77) stop 9
  call MPI_Win_free(win, ierr)
  print '("mpi module MPI_Win_allocate with TYPE(C_PTR): ok")'

  call check_f08()

  print '("alloc_mem_cptr: all ok")'

  call MPI_Finalize(ierr)

end program alloc_mem_cptr
