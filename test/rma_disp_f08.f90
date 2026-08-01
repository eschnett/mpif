! The `target_disp` of MPI_Put and the nine other one-sided routines is
! INTEGER(KIND=MPI_ADDRESS_KIND) in the standard's Fortran binding, matching the
! MPI_Aint that C takes. mpif's generator had RMA_DISPLACEMENT_NNI in its list of
! plain-integer kinds, so it emitted a default INTEGER and the window tests in
! MPICH's suite would not compile -- "Type mismatch in argument 'target_disp';
! passed INTEGER(8) to INTEGER(4)".
!
! Passing an address-kind displacement is therefore the assertion here: with the
! old declaration this file does not compile. The put and get are done on
! MPI_COMM_SELF so that no launcher is needed.

program rma_disp_f08
  use mpi_f08
  implicit none

  integer, parameter :: n = 4
  integer :: buf(n), out(n), i, disp_unit
  integer(MPI_ADDRESS_KIND) :: winsize, target_disp
  type(MPI_Win) :: win

  call MPI_Init()

  call MPI_Type_size(MPI_INTEGER, disp_unit)
  winsize = int(n, MPI_ADDRESS_KIND) * disp_unit

  buf = 0
  call MPI_Win_create(buf, winsize, disp_unit, MPI_INFO_NULL, MPI_COMM_SELF, win)

  ! Write each element through the window at its own displacement
  call MPI_Win_fence(0, win)
  do i = 1, n
     target_disp = int(i - 1, MPI_ADDRESS_KIND)
     out(i) = 100 + i
     call MPI_Put(out(i), 1, MPI_INTEGER, 0, target_disp, 1, MPI_INTEGER, win)
  end do
  call MPI_Win_fence(0, win)

  do i = 1, n
     if (buf(i) /= 100 + i) stop 1
  end do
  print '("MPI_Put with an address-kind target_disp: ok")'

  ! And read them back
  out = 0
  call MPI_Win_fence(0, win)
  do i = 1, n
     target_disp = int(i - 1, MPI_ADDRESS_KIND)
     call MPI_Get(out(i), 1, MPI_INTEGER, 0, target_disp, 1, MPI_INTEGER, win)
  end do
  call MPI_Win_fence(0, win)

  do i = 1, n
     if (out(i) /= 100 + i) stop 2
  end do
  print '("MPI_Get with an address-kind target_disp: ok")'

  ! A displacement too large for a default INTEGER still has to be expressible,
  ! which is the point of the address kind. Not used in a call -- the window is
  ! small -- but it must at least fit and survive assignment.
  target_disp = 3000000000_MPI_ADDRESS_KIND
  if (target_disp /= 3000000000_MPI_ADDRESS_KIND) stop 3

  call MPI_Win_free(win)

  print '("rma_disp_f08: all ok")'

  call MPI_Finalize()

end program rma_disp_f08
