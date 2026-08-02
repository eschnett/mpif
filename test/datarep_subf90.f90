! The Fortran half of test/datarep_c.c: datarep callbacks written the way an
! mpif.h or `use mpi` program writes them, for the C side to drive through the
! trampolines in src/mpif_callbacks.c.
!
! External subprograms rather than module procedures, so that C can name their
! symbols -- `dr_read_fn_` and friends -- without depending on how a compiler
! mangles a module procedure's name.
!
! The callbacks check their own arguments and report through `ierror`, so the C
! side needs no shared state: a nonzero code means the trampoline marshalled
! something wrong, and the converted bytes say whether the buffers arrived the
! right way round.
!
! `userbuf` and `filebuf` are choice buffers here, which is what MPI-5.0 A.5
! gives a datarep conversion function -- "<TYPE> USERBUF(*)". mpi_f08 spells the
! same thing TYPE(C_PTR), VALUE, and the two are the same pointer in the same
! register, which is what lets one C trampoline serve both.

subroutine dr_read_fn(userbuf, datatype, count, filebuf, position, &
     extra_state, ierror)
  use mpi
  implicit none
  integer(kind=1) :: userbuf(*), filebuf(*)
  integer :: datatype
  integer :: count
  integer(MPI_OFFSET_KIND) :: position
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
  integer :: i

  ! The values test/datarep_c.c passes. Getting any of them wrong is the
  ! marshalling bug this test is for.
  if (datatype /= MPI_BYTE) then
     ierror = 101
     return
  end if
  if (count /= 8) then
     ierror = 102
     return
  end if
  if (position /= 3) then
     ierror = 103
     return
  end if
  if (extra_state /= 20260802_MPI_ADDRESS_KIND) then
     ierror = 104
     return
  end if

  ! A read converts from the file buffer into the user buffer.
  do i = 1, count
     userbuf(i) = not(filebuf(i))
  end do
  ierror = MPI_SUCCESS
end subroutine dr_read_fn

subroutine dr_write_fn(userbuf, datatype, count, filebuf, position, &
     extra_state, ierror)
  use mpi
  implicit none
  integer(kind=1) :: userbuf(*), filebuf(*)
  integer :: datatype
  integer :: count
  integer(MPI_OFFSET_KIND) :: position
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror
  integer :: i

  if (extra_state /= 20260802_MPI_ADDRESS_KIND) then
     ierror = 104
     return
  end if

  ! And a write the other way round, which is how the two trampolines are told
  ! apart: one procedure serving both would not notice them being swapped.
  do i = 1, count
     filebuf(i) = not(userbuf(i))
  end do
  ierror = MPI_SUCCESS
end subroutine dr_write_fn

subroutine dr_extent_fn(datatype, extent, extra_state, ierror)
  use mpi
  implicit none
  integer :: datatype
  integer(MPI_ADDRESS_KIND) :: extent
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror

  if (datatype /= MPI_INTEGER) then
     ierror = 105
     return
  end if
  if (extra_state /= 20260802_MPI_ADDRESS_KIND) then
     ierror = 104
     return
  end if

  extent = 44
  ierror = MPI_SUCCESS
end subroutine dr_extent_fn

! The extent callback that reports failure, so that the C side can check the
! trampoline leaves MPI's `extent` alone rather than passing on whatever the
! callback happened to leave in it.
subroutine dr_extent_fail_fn(datatype, extent, extra_state, ierror)
  use mpi
  implicit none
  integer :: datatype
  integer(MPI_ADDRESS_KIND) :: extent
  integer(MPI_ADDRESS_KIND) :: extra_state
  integer :: ierror

  extent = 99
  ierror = MPI_ERR_OTHER
end subroutine dr_extent_fail_fn
