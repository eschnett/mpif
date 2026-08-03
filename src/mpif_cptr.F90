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
! gen/mpif_functions.F90, which this module calls under a renamed alias so that
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
!
! Two naming styles, deliberately. The standard names the four overloads it
! defines -- MPI_ALLOC_MEM_CPTR, MPI_WIN_ALLOCATE_CPTR,
! MPI_WIN_ALLOCATE_SHARED_CPTR and MPI_WIN_SHARED_QUERY_CPTR -- so those keep
! their MPI_ names. It says nothing about a large-count form of them; section
! 19.1.5's rules for implied specific names cover the _f08 and _f schemes, not a
! _c_cptr combination. Those three are mpif's own invention and are therefore
! spelled mpif_, since nothing outside the standard should claim the MPI_ prefix.

! Each of the seven has a PMPI form too, MPI-5.0 section 15.2 asking for a
! P-prefixed second procedure for every MPI procedure and MPICH's own binding
! providing `pmpi_alloc_mem_cptr_` and the rest. The four the standard names take
! PMPI_ names, that whole prefix being reserved to the implementation -- "programs
! must not declare functions with names beginning with any prefix of the form
! PMPI_" -- so nothing is claimed here that is not mpif's to claim. The three
! mpif invented carry the `p` after the `mpif_` prefix instead, as every
! mpif-invented PMPI name does.
!
! They cannot forward to their twins: each has to reach the PMPI interface rather
! than the MPI one, which is the point of having them.

module mpif_cptr
  use mpif_constants
  use mpif_functions, only: &
       MPIF_Alloc_mem                => MPI_Alloc_mem               , &
       MPIF_Win_allocate             => MPI_Win_allocate            , &
       MPIF_Win_allocate_c           => MPI_Win_allocate_c          , &
       MPIF_Win_allocate_shared      => MPI_Win_allocate_shared     , &
       MPIF_Win_allocate_shared_c    => MPI_Win_allocate_shared_c   , &
       MPIF_Win_shared_query         => MPI_Win_shared_query        , &
       MPIF_Win_shared_query_c       => MPI_Win_shared_query_c
  use mpif_functions, only: &
       PMPIF_Alloc_mem               => PMPI_Alloc_mem              , &
       PMPIF_Win_allocate            => PMPI_Win_allocate           , &
       PMPIF_Win_allocate_c          => PMPI_Win_allocate_c         , &
       PMPIF_Win_allocate_shared     => PMPI_Win_allocate_shared    , &
       PMPIF_Win_allocate_shared_c   => PMPI_Win_allocate_shared_c  , &
       PMPIF_Win_shared_query        => PMPI_Win_shared_query       , &
       PMPIF_Win_shared_query_c      => PMPI_Win_shared_query_c
  use, intrinsic :: iso_c_binding, only: C_PTR, C_NULL_PTR

  implicit none
  private

  public :: MPI_Alloc_mem_cptr
  public :: MPI_Win_allocate_cptr
  public :: mpif_win_allocate_c_cptr
  public :: MPI_Win_allocate_shared_cptr
  public :: mpif_win_allocate_shared_c_cptr
  public :: MPI_Win_shared_query_cptr
  public :: mpif_win_shared_query_c_cptr

  public :: PMPI_Alloc_mem_cptr
  public :: PMPI_Win_allocate_cptr
  public :: mpif_pwin_allocate_c_cptr
  public :: PMPI_Win_allocate_shared_cptr
  public :: mpif_pwin_allocate_shared_c_cptr
  public :: PMPI_Win_shared_query_cptr
  public :: mpif_pwin_shared_query_c_cptr

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

  subroutine mpif_win_allocate_c_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
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
  end subroutine mpif_win_allocate_c_cptr

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

  subroutine mpif_win_allocate_shared_c_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
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
  end subroutine mpif_win_allocate_shared_c_cptr

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

  subroutine mpif_win_shared_query_c_cptr(win, rank, size, disp_unit, baseptr, ierror)
    integer :: win
    integer :: rank
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    type(C_PTR) :: baseptr
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call MPIF_Win_shared_query_c(win, rank, size, disp_unit, tmp_baseptr, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine mpif_win_shared_query_c_cptr

  subroutine PMPI_Alloc_mem_cptr(size, info, baseptr, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer :: info
    type(C_PTR) :: baseptr
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call PMPIF_Alloc_mem(size, info, tmp_baseptr, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine PMPI_Alloc_mem_cptr

  subroutine PMPI_Win_allocate_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    integer :: info
    integer :: comm
    type(C_PTR) :: baseptr
    integer :: win
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call PMPIF_Win_allocate(size, disp_unit, info, comm, tmp_baseptr, win, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine PMPI_Win_allocate_cptr

  subroutine mpif_pwin_allocate_c_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    integer :: info
    integer :: comm
    type(C_PTR) :: baseptr
    integer :: win
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call PMPIF_Win_allocate_c(size, disp_unit, info, comm, tmp_baseptr, win, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine mpif_pwin_allocate_c_cptr

  subroutine PMPI_Win_allocate_shared_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    integer :: info
    integer :: comm
    type(C_PTR) :: baseptr
    integer :: win
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call PMPIF_Win_allocate_shared(size, disp_unit, info, comm, tmp_baseptr, win, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine PMPI_Win_allocate_shared_cptr

  subroutine mpif_pwin_allocate_shared_c_cptr(size, disp_unit, info, comm, baseptr, win, ierror)
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    integer :: info
    integer :: comm
    type(C_PTR) :: baseptr
    integer :: win
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call PMPIF_Win_allocate_shared_c(size, disp_unit, info, comm, tmp_baseptr, win, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine mpif_pwin_allocate_shared_c_cptr

  subroutine PMPI_Win_shared_query_cptr(win, rank, size, disp_unit, baseptr, ierror)
    integer :: win
    integer :: rank
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    type(C_PTR) :: baseptr
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call PMPIF_Win_shared_query(win, rank, size, disp_unit, tmp_baseptr, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine PMPI_Win_shared_query_cptr

  subroutine mpif_pwin_shared_query_c_cptr(win, rank, size, disp_unit, baseptr, ierror)
    integer :: win
    integer :: rank
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    type(C_PTR) :: baseptr
    integer :: ierror
    integer(MPI_ADDRESS_KIND) :: tmp_baseptr
    call PMPIF_Win_shared_query_c(win, rank, size, disp_unit, tmp_baseptr, ierror)
    baseptr = transfer(tmp_baseptr, C_NULL_PTR)
  end subroutine mpif_pwin_shared_query_c_cptr

end module mpif_cptr
