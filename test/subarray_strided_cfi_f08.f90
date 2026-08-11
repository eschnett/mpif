! Sections whose *inner* dimension is the strided one, which is the shape the
! cdesc walker gets wrong when it places a level with MPI_Type_contiguous.
! Contiguous replicates at multiples of the inner type's extent, and an
! hvector's extent is short of the span it covers -- sm*(n-1) + e, not sm*n --
! so a dimension above a strided one whose stride happens to equal the span
! reads and writes every replica but the first at the wrong address. On
! integer a(20,3), a(1:20:2,:) is the smallest instance: the second column
! lands 4 bytes early, at a(20,1).
!
! test/subarray_nonblocking_f08.f90 cannot see this. Its two shapes are a 1-D
! strided section (one level, nothing above it) and ma(:, 2:6:2) (dense inner,
! strided outer -- the strided level is last). Neither has a level above a
! strided one.
!
! Every call here is blocking, so the fallback branch must pass too: without
! assumed-rank buffers the compiler makes a contiguous copy, which is correct.
! On the TS branch the descriptor reaches the walker and the datatype it
! builds is the whole assertion.

program subarray_strided_cfi_f08
  use mpi_f08
  implicit none

  integer, parameter :: n = 20, m = 3
  integer :: a(n, m), b(n, m)
  integer :: flat(n / 2 * m)
  integer :: ma(7, 6)
  integer :: mflat(21)
  integer :: t(2, 4, 3)
  integer :: tflat(2 * 2 * 3)
  integer :: i, j, k, p

  call MPI_Init()

  do j = 1, m
     do i = 1, n
        a(i, j) = 100 * j + i
     end do
  end do

  ! Sending the section, receiving contiguously: this checks the addresses the
  ! walked type *reads*. The contiguous counterpart is what makes the check
  ! unambiguous -- section to section, a misplacement on both sides could
  ! agree with itself.
  flat = -1
  call MPI_Sendrecv(a(1:n:2, :), 30, MPI_INT, 0, 1, &
                    flat, 30, MPI_INT, 0, 1, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  p = 0
  do j = 1, m
     do i = 1, n, 2
        p = p + 1
        if (flat(p) /= a(i, j)) stop 1
     end do
  end do

  ! The same shape receiving: the addresses the walked type *writes*, and that
  ! it writes nowhere else. The wrong walk lands on b(20,1) and on the even
  ! rows of the later columns.
  do p = 1, 30
     flat(p) = 1000 + p
  end do
  b = -7
  call MPI_Sendrecv(flat, 30, MPI_INT, 0, 2, &
                    b(1:n:2, :), 30, MPI_INT, 0, 2, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  p = 0
  do j = 1, m
     do i = 1, n, 2
        p = p + 1
        if (b(i, j) /= flat(p)) stop 2
     end do
  end do
  do j = 1, m
     do i = 2, n, 2
        if (b(i, j) /= -7) stop 3
     end do
  end do

  ! Rank 3, with the strided dimension in the middle: dense innermost, then a
  ! stride, then a dimension whose stride is the span below it -- the same
  ! wrong contiguous, one level further up.
  do k = 1, 3
     do j = 1, 4
        do i = 1, 2
           t(i, j, k) = 100 * k + 10 * j + i
        end do
     end do
  end do
  tflat = -1
  call MPI_Sendrecv(t(:, 1:4:2, :), 12, MPI_INT, 0, 3, &
                    tflat, 12, MPI_INT, 0, 3, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  p = 0
  do k = 1, 3
     do j = 1, 4, 2
        do i = 1, 2
           p = p + 1
           if (tflat(p) /= t(i, j, k)) stop 4
        end do
     end do
  end do

  ! A count that stops short of the descriptor -- two of the three columns --
  ! so the outer level is partial as well as sitting above a strided one.
  flat = -1
  call MPI_Sendrecv(a(1:n:2, :), 20, MPI_INT, 0, 4, &
                    flat, 20, MPI_INT, 0, 4, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  p = 0
  do j = 1, 2
     do i = 1, n, 2
        p = p + 1
        if (flat(p) /= a(i, j)) stop 5
     end do
  end do

  ! The contrast, and a guard that the fix left it alone: strided outermost,
  ! where the contiguous level is below the stride and is right.
  do j = 1, 6
     do i = 1, 7
        ma(i, j) = 100 * j + i
     end do
  end do
  mflat = -1
  call MPI_Sendrecv(ma(:, 2:6:2), 21, MPI_INT, 0, 5, &
                    mflat, 21, MPI_INT, 0, 5, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  p = 0
  do j = 2, 6, 2
     do i = 1, 7
        p = p + 1
        if (mflat(p) /= ma(i, j)) stop 6
     end do
  end do

  call MPI_Finalize()
end program subarray_strided_cfi_f08
