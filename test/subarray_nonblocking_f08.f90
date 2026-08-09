! Noncontiguous sections through nonblocking calls, which is the case
! MPI_SUBARRAYS_SUPPORTED names: without assumed-rank buffers the compiler
! passes a(1:7:2) by copy-in/copy-out and the copy dies at the wrapper's
! return, before MPI_Wait -- MPICH's f08/subarray test14/test15 signature,
! nothing arrives at all. With them, the descriptor reaches the cdesc layer,
! which builds a datatype from its strides.
!
! Compiled -O2 on purpose (see test/CMakeLists.txt): ASYNCHRONOUS on the
! arrays is what forbids the caller's optimiser from caching or moving the
! accesses across the wait, and -O0 would hide a binding that lost the
! attribute.

program subarray_nonblocking_f08
  use mpi_f08
  implicit none

  integer, parameter :: n = 10
  integer, asynchronous :: a(n), b(n)
  integer, asynchronous :: ma(7, 6), mb(7, 6)
  type(MPI_Request) :: reqs(2)
  integer :: i, j

  call MPI_Init()

  if (.not. MPI_SUBARRAYS_SUPPORTED) then
     ! The fallback binding: a noncontiguous actual to a nonblocking call is
     ! invalid there, and subarrays_constants_f08 checks the constant itself.
     call MPI_Finalize()
     stop
  end if

  ! A strided one-dimensional section, self-messaged.
  do i = 1, n
     a(i) = 10 * i
  end do
  b = 0
  call MPI_Irecv(b(1:7:2), 4, MPI_INT, 0, 1, MPI_COMM_SELF, reqs(1))
  call MPI_Isend(a(1:7:2), 4, MPI_INT, 0, 1, MPI_COMM_SELF, reqs(2))
  call MPI_Waitall(2, reqs, MPI_STATUSES_IGNORE)
  do i = 1, n
     if (mod(i, 2) == 1 .and. i <= 7) then
        if (b(i) /= a(i)) stop 1
     else
        if (b(i) /= 0) stop 2
     end if
  end do

  ! A two-dimensional column section, strided in the outer dimension only --
  ! test14's shape.
  do j = 1, 6
     do i = 1, 7
        ma(i, j) = 100 * j + i
     end do
  end do
  mb = 0
  call MPI_Irecv(mb(:, 2:6:2), 21, MPI_INT, 0, 2, MPI_COMM_SELF, reqs(1))
  call MPI_Isend(ma(:, 2:6:2), 21, MPI_INT, 0, 2, MPI_COMM_SELF, reqs(2))
  call MPI_Waitall(2, reqs, MPI_STATUSES_IGNORE)
  do j = 1, 6
     do i = 1, 7
        if (j == 2 .or. j == 4 .or. j == 6) then
           if (mb(i, j) /= ma(i, j)) stop 3
        else
           if (mb(i, j) /= 0) stop 4
        end if
     end do
  end do

  call MPI_Finalize()
end program subarray_nonblocking_f08
