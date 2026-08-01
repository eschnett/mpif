! The TYPE(C_PTR) forms of the routines that hand back a base address.
!
! MPI-5.0 gives each of these two Fortran bindings in the mpi module and mpif.h:
! the base one with INTEGER(KIND=MPI_ADDRESS_KIND) BASEPTR, and an overload with
! TYPE(C_PTR) BASEPTR under the same generic name. "If the Fortran compiler
! provides TYPE(C_PTR), then the following generic interface must be provided in
! the mpi module and should be provided in the (deprecated) mpif.h include file
! through overloading, i.e., with the same routine name as the routine with
! INTEGER(KIND=MPI_ADDRESS_KIND) BASEPTR, but with a different specific procedure
! name" -- and it names that procedure MPI_ALLOC_MEM_CPTR.
!
! Only the second specific lives here; the first is the generated interface in
! gen/mpi_functions.F90, which this module calls under a renamed alias so that
! the generic in src/mpi.F90 can gather the two. The address MPI writes is
! pointer-sized either way, so the conversion is a `transfer`.
!
! mpif.h needs nothing: its interfaces are implicit, so a TYPE(C_PTR) actual
! argument reaches the same C wrapper unchecked. mpi_f08 needs nothing either --
! there the standard has only the TYPE(C_PTR) form, which the generator emits
! directly.
!
! The large-count variants are here too. mpif spells them as separate names
! rather than as further overloads, so each gets its own generic.

module mpi_cptr
  use mpi_constants
  use mpi_functions, only: &
       MPIF_Alloc_mem                => MPI_Alloc_mem               , &
       MPIF_Win_allocate             => MPI_Win_allocate            , &
       MPIF_Win_allocate_c           => MPI_Win_allocate_c          , &
       MPIF_Win_allocate_shared      => MPI_Win_allocate_shared     , &
       MPIF_Win_allocate_shared_c    => MPI_Win_allocate_shared_c   , &
       MPIF_Win_shared_query         => MPI_Win_shared_query        , &
       MPIF_Win_shared_query_c       => MPI_Win_shared_query_c
  use, intrinsic :: iso_c_binding, only: C_PTR, C_NULL_PTR

  implicit none
  private

  public :: MPI_Alloc_mem_cptr
  public :: MPI_Win_allocate_cptr
  public :: MPI_Win_allocate_c_cptr
  public :: MPI_Win_allocate_shared_cptr
  public :: MPI_Win_allocate_shared_c_cptr
  public :: MPI_Win_shared_query_cptr
  public :: MPI_Win_shared_query_c_cptr

contains

  subroutine MPI_Alloc_mem_cptr(size, info, baseptr, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer :: info
    type(C_PTR) :: baseptr
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call MPIF_Alloc_mem(size, info, tmp_baseptr, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine MPI_Alloc_mem_cptr

  subroutine MPI_Win_allocate_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    integer :: info
    integer :: comm
    type(C_PTR) :: baseptr
    integer :: win
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call MPIF_Win_allocate(size, disp_unit, info, comm, tmp_baseptr, win, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine MPI_Win_allocate_cptr

  subroutine MPI_Win_allocate_c_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    integer :: info
    integer :: comm
    type(C_PTR) :: baseptr
    integer :: win
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call MPIF_Win_allocate_c(size, disp_unit, info, comm, tmp_baseptr, win, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine MPI_Win_allocate_c_cptr

  subroutine MPI_Win_allocate_shared_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    integer :: info
    integer :: comm
    type(C_PTR) :: baseptr
    integer :: win
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call MPIF_Win_allocate_shared(size, disp_unit, info, comm, tmp_baseptr, win, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine MPI_Win_allocate_shared_cptr

  subroutine MPI_Win_allocate_shared_c_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    integer :: info
    integer :: comm
    type(C_PTR) :: baseptr
    integer :: win
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call MPIF_Win_allocate_shared_c(size, disp_unit, info, comm, tmp_baseptr, win, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine MPI_Win_allocate_shared_c_cptr

  subroutine MPI_Win_shared_query_cptr(win, rank, size, disp_unit, baseptr, ierror)
    integer :: win
    integer :: rank
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    type(C_PTR) :: baseptr
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call MPIF_Win_shared_query(win, rank, size, disp_unit, tmp_baseptr, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine MPI_Win_shared_query_cptr

  subroutine MPI_Win_shared_query_c_cptr(win, rank, size, disp_unit, baseptr, ierror)
    integer :: win
    integer :: rank
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    type(C_PTR) :: baseptr
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call MPIF_Win_shared_query_c(win, rank, size, disp_unit, tmp_baseptr, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine MPI_Win_shared_query_c_cptr

end module mpi_cptr
