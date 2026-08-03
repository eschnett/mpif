! The PMPI names through the mpi module. MPI-5.0 section 19.1.5: "Within the
! mpi_f08 and mpi modules and (deprecated) mpif.h include file, for all MPI
! procedures, a second procedure with the same calling conventions shall be
! supplied, except that the name is modified by prefixing with the letter 'P'".
!
! Here the interfaces are explicit, which is the point of testing them: `use mpi`
! declared no PMPI name at all before, so this whole file failed to compile with
! "Function 'pmpi_wtick' has no IMPLICIT type" -- which is what MPICH's
! f90/timer/wtimef90 reported too.
!
! The two generics are the interesting cases. PMPI_SIZEOF shares its specifics
! with MPI_SIZEOF, a module procedure being allowed in more than one generic
! interface; PMPI_ALLOC_MEM gathers the address-kind specific with the TYPE(C_PTR)
! overload, which is a second hand-written procedure in src/mpif_cptr.F90 and a
! generic declared in src/mpi.F90 where both halves are visible.

program pmpi_f90
  use mpi
  use, intrinsic :: iso_c_binding, only: C_PTR, C_NULL_PTR, C_F_POINTER, C_ASSOCIATED
  implicit none

  integer, parameter :: n = 8
  integer :: ierr, rank, size, sz, elemsize, extent, i
  double precision :: t0, t1
  integer(MPI_ADDRESS_KIND) :: bytes, baseptr_aint, attr
  type(C_PTR) :: baseptr
  integer, pointer :: a(:)
  integer :: keyval, i4
  logical :: flag

  call PMPI_Init(ierr)
  if (ierr /= MPI_SUCCESS) stop 1

  call PMPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  call PMPI_Comm_size(MPI_COMM_WORLD, size, ierr)
  if (rank < 0 .or. rank >= size) stop 2

  ! The four function-valued names
  if (PMPI_Wtick() <= 0.0d0) stop 3
  t0 = PMPI_Wtime()
  t1 = PMPI_Wtime()
  if (t1 < t0) stop 4
  if (PMPI_Aint_add(1024_MPI_ADDRESS_KIND, 16_MPI_ADDRESS_KIND) /= 1040) stop 5
  if (PMPI_Aint_diff(1040_MPI_ADDRESS_KIND, 1024_MPI_ADDRESS_KIND) /= 16) stop 6

  ! PMPI_SIZEOF over the same specifics as MPI_SIZEOF, scalar and rank one
  call PMPI_Type_size(MPI_INTEGER, elemsize, ierr)
  call PMPI_Sizeof(i4, sz, ierr)
  if (sz /= elemsize) stop 7

  ! PMPI_ALLOC_MEM through both halves of its generic
  bytes = int(n, MPI_ADDRESS_KIND) * elemsize

  baseptr_aint = 0
  call PMPI_Alloc_mem(bytes, MPI_INFO_NULL, baseptr_aint, ierr)
  if (ierr /= MPI_SUCCESS) stop 8
  if (baseptr_aint == 0) stop 9
  ! MPI_FREE_MEM takes the buffer, not its address, so the address has to become
  ! one first -- the same round trip test/alloc_mem_cptr.f90 makes.
  call C_F_POINTER(transfer(baseptr_aint, C_NULL_PTR), a, [n])
  a(1) = 321
  if (a(1) /= 321) stop 10
  call PMPI_Free_mem(a, ierr)

  call PMPI_Alloc_mem(bytes, MPI_INFO_NULL, baseptr, ierr)
  if (ierr /= MPI_SUCCESS) stop 11
  if (.not. C_ASSOCIATED(baseptr)) stop 12
  call C_F_POINTER(baseptr, a, [n])
  do i = 1, n
     a(i) = i * 5
  end do
  do i = 1, n
     if (a(i) /= i * 5) stop 13
  end do
  call PMPI_Free_mem(a, ierr)

  ! A predefined callback passed to a PMPI routine, keeping its MPI_ name. There
  ! is no PMPI_ form of it and none wanted -- A.1.1 lists these among the defined
  ! constants, with an ABI value of 0 or 1, so there is no entry point to
  ! name-shift. Mixing the prefixes is the supported idiom; what this asserts is
  ! that the address still reaches src/mpif_callbacks.c on the PMPI path.
  call PMPI_Comm_create_keyval(MPI_COMM_DUP_FN, MPI_COMM_NULL_DELETE_FN, &
       keyval, 0_MPI_ADDRESS_KIND, ierr)
  if (ierr /= MPI_SUCCESS) stop 14
  call PMPI_Comm_set_attr(MPI_COMM_WORLD, keyval, 7_MPI_ADDRESS_KIND, ierr)
  if (ierr /= MPI_SUCCESS) stop 15
  call PMPI_Comm_get_attr(MPI_COMM_WORLD, keyval, attr, flag, ierr)
  if (ierr /= MPI_SUCCESS) stop 16
  if (.not. flag) stop 17
  if (attr /= 7) stop 18
  call PMPI_Comm_free_keyval(keyval, ierr)

  ! One of the removed MPI-1 routines. Reachable from mpif.h only -- no interface
  ! declares it -- so it is called here through an explicit EXTERNAL declaration
  ! rather than left to `use mpi`, which cannot see it.
  block
    external :: PMPI_Type_extent
    call PMPI_Type_extent(MPI_INTEGER, extent, ierr)
    if (ierr /= MPI_SUCCESS) stop 19
    if (extent /= elemsize) stop 20
  end block

  print '("pmpi_f90: all ok")'

  call PMPI_Finalize(ierr)
  if (ierr /= MPI_SUCCESS) stop 21

end program pmpi_f90
