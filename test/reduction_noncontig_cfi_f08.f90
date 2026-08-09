! The reduction family's contiguity rule, loudly. MPI-5.0 6.9.1: "Predefined
! operators work only with the MPI types listed in Section 6.9.2 and Section
! 6.9.4" -- so a noncontiguous section to MPI_Reduce cannot be described by a
! datatype built from its strides, on either side and whatever the layouts.
! MPICH's cdesc layer builds the hvector anyway and its own library aborts
! from inside internal_Reduce ("MPI_Op operation not defined for this
! datatype"); mpif returns MPI_ERR_BUFFER from the binding instead.
!
! Only meaningful where the descriptors reach the binding: on the fallback
! branch the compiler's copy-in makes every section contiguous, these calls
! are blocking, and the error must not fire.

program reduction_noncontig_cfi_f08
  use mpi_f08
  implicit none

  integer, parameter :: n = 9
  integer :: a(n), b(n), r(5)
  integer :: ierr, i

  call MPI_Init()

  if (.not. MPI_SUBARRAYS_SUPPORTED) then
     call MPI_Finalize()
     stop
  end if

  ! Contiguous reduction, which must keep working.
  do i = 1, n
     a(i) = 10 * i
  end do
  r = 0
  call MPI_Reduce(a(1:5), r, 5, MPI_INT, MPI_SUM, 0, MPI_COMM_SELF)
  do i = 1, 5
     if (r(i) /= 10 * i) stop 1
  end do

  ! A strided sendbuf: refused, not corrupted.
  ierr = MPI_SUCCESS
  call MPI_Reduce(a(1:n:2), r, 5, MPI_INT, MPI_SUM, 0, MPI_COMM_SELF, ierr)
  if (ierr /= MPI_ERR_BUFFER) stop 2

  ! A strided recvbuf: same answer.
  ierr = MPI_SUCCESS
  call MPI_Reduce(r, b(1:n:2), 5, MPI_INT, MPI_SUM, 0, MPI_COMM_SELF, ierr)
  if (ierr /= MPI_ERR_BUFFER) stop 3

  ! Both strided with the same layout: still refused -- one walked datatype
  ! would describe both, but 6.9.1 forbids handing it to MPI_SUM at all.
  ierr = MPI_SUCCESS
  call MPI_Reduce(a(1:n:2), b(1:n:2), 5, MPI_INT, MPI_SUM, 0, MPI_COMM_SELF, ierr)
  if (ierr /= MPI_ERR_BUFFER) stop 4

  call MPI_Finalize()
end program reduction_noncontig_cfi_f08
