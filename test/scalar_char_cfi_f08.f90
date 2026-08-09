! The actual-argument shapes an assumed-rank choice buffer must accept beyond
! plain arrays: scalars (rank-0 descriptors), character scalars, and strided
! character sections -- the last being the one walker path where the
! descriptor's element is longer than the datatype, elem_len 8 against
! MPI_CHARACTER's size 1, so the walk has to fold the factor into its base
! type. All calls are blocking, so the fallback branch must pass too.
!
! Compiled -O2 on purpose, like subarray_nonblocking_f08: what this asserts is
! partly about what the caller's optimiser is allowed to assume around the
! call.

program scalar_char_cfi_f08
  use mpi_f08
  implicit none

  integer :: sx, rx
  character(len=8) :: cs, cr
  character(len=8) :: sa(5), ra(3)
  integer :: i

  call MPI_Init()

  ! A scalar actual: a rank-0 descriptor whose base address is the scalar.
  sx = 42
  rx = 0
  call MPI_Sendrecv(sx, 1, MPI_INT, 0, 1, &
                    rx, 1, MPI_INT, 0, 1, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  if (rx /= 42) stop 1

  ! A character scalar: elem_len is the string length.
  cs = 'abcdefgh'
  cr = ''
  call MPI_Sendrecv(cs, 8, MPI_CHARACTER, 0, 2, &
                    cr, 8, MPI_CHARACTER, 0, 2, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  if (cr /= 'abcdefgh') stop 2

  ! A strided character section: three len-8 strings out of five, 24
  ! MPI_CHARACTERs, received contiguously.
  do i = 1, 5
     write (sa(i), '(a7,i1)') 'string_', i
  end do
  ra = ''
  call MPI_Sendrecv(sa(1:5:2), 24, MPI_CHARACTER, 0, 3, &
                    ra, 24, MPI_CHARACTER, 0, 3, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  if (ra(1) /= sa(1)) stop 3
  if (ra(2) /= sa(3)) stop 4
  if (ra(3) /= sa(5)) stop 5

  call MPI_Finalize()
end program scalar_char_cfi_f08
