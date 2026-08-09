! MPI_IN_PLACE through an assumed-rank dummy: the sentinel must pass through
! the descriptor unchanged -- its base address *is* the C constant, see
! mpif_cdesc_is_sentinel -- and must be recognised as a sentinel rather than
! examined as a buffer. The second half checks the reduction-family
! contiguity rule beside it: MPI-5.0 6.9.1 confines predefined operators to
! the listed basic datatypes, so a noncontiguous section to MPI_Allreduce
! cannot be described by a walked datatype and mpif refuses it with
! MPI_ERR_BUFFER -- on the TS branch. On the fallback branch the same call is
! blocking copy-in/copy-out and must succeed instead, so both expectations
! are written out.

program inplace_cfi_f08
  use mpi_f08
  implicit none

  integer, parameter :: n = 9
  integer :: buf(n)
  integer :: rank, size
  integer :: i, ierr

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)

  ! Contiguous MPI_IN_PLACE, the case every binding must get right.
  buf = rank + 1
  call MPI_Allreduce(MPI_IN_PLACE, buf, n, MPI_INT, MPI_SUM, MPI_COMM_WORLD)
  do i = 1, n
     if (buf(i) /= size * (size + 1) / 2) stop 1
  end do

  ! A strided recvbuf beside the sentinel.
  do i = 1, n
     buf(i) = 10 * i + rank + 1
  end do
  ierr = MPI_SUCCESS
  call MPI_Allreduce(MPI_IN_PLACE, buf(1:n:2), 5, MPI_INT, MPI_SUM, &
                     MPI_COMM_WORLD, ierr)
  if (MPI_SUBARRAYS_SUPPORTED) then
     ! Refused: a walked datatype under MPI_SUM would be erroneous (6.9.1),
     ! and the sentinel beside it must not change that answer.
     if (ierr /= MPI_ERR_BUFFER) stop 2
  else
     ! The compiler's copy-in/copy-out, correct for a blocking call.
     if (ierr /= MPI_SUCCESS) stop 3
     do i = 1, n
        if (mod(i, 2) == 1) then
           if (buf(i) /= size * (10 * i) + size * (size + 1) / 2) stop 4
        else
           if (buf(i) /= 10 * i + rank + 1) stop 5
        end if
     end do
  end if

  call MPI_Finalize()
end program inplace_cfi_f08
