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

  ! `disp_unit` is the other direction: a plain INTEGER in the small form and an
  ! MPI_Aint in the large one, so MPI_Win_create's two specifics differ in kind
  ! only where those two differ -- on a 64-bit platform and not on a 32-bit one,
  ! where an MPI_Aint *is* a default INTEGER. An address-kind actual therefore has
  ! to be accepted either way: through the generic where it exists, and through
  ! the small specific where the two kinds are the same kind.
  call MPI_Win_free(win)
  call MPI_Win_create(buf, winsize, int(disp_unit, MPI_ADDRESS_KIND), &
                      MPI_INFO_NULL, MPI_COMM_SELF, win)

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

  ! A displacement has to span whatever range an address does here, which is the
  ! point of the address kind: never narrower than a default INTEGER, and wider
  ! wherever a pointer is, MPI_Aint being intptr_t in the ABI. Asserted against
  ! huge() rather than against a literal such as 3000000000, which is what this
  ! used to do and which is a compile error on a 32-bit platform -- there the two
  ! kinds coincide and there is no larger value to write down. Not used in a call
  ! -- the window is small -- but it must at least fit and survive assignment.
  if (huge(target_disp) < huge(0)) stop 3
  target_disp = huge(target_disp)
  if (target_disp /= huge(target_disp)) stop 4

  call MPI_Win_free(win)

  print '("rma_disp_f08: all ok")'

  call MPI_Finalize()

end program rma_disp_f08
