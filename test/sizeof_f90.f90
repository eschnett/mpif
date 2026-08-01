! MPI_Sizeof is a hand-written generic in src/mpif_types.F90, one specific per
! type and rank. It used to have only assumed-size specifics, so a scalar
! argument matched nothing; `size` and `ierror` were declared REAL or COMPLEX
! rather than INTEGER in the real and complex specifics; and there was no
! CHARACTER form at all. Every call below failed to compile.
!
! Rank two and above still resolves to nothing, which is where MPICH's own
! binding stops too, so this checks scalars and rank-1 arrays only.
!
! MPI_Sizeof lives in the mpi module and mpif.h; MPI-4.0 removed the mpi_f08
! form.

program sizeof_f90
  use mpi
  implicit none

  integer :: ierr, sz, ref, errs

  integer          :: i1, i1v(5)
  real             :: r1, r1v(2)
  double precision :: d1, d1v(3)
  complex          :: c1, c1v(4)
  character        :: ch1, ch1v(6)
  logical          :: l1, l1v(7)

  errs = 0
  call MPI_Init(ierr)

  call MPI_Type_size(MPI_INTEGER, ref, ierr)
  call MPI_Sizeof(i1, sz, ierr)
  if (sz /= ref) stop 1
  call MPI_Sizeof(i1v, sz, ierr)
  if (sz /= ref) stop 2

  call MPI_Type_size(MPI_REAL, ref, ierr)
  call MPI_Sizeof(r1, sz, ierr)
  if (sz /= ref) stop 3
  call MPI_Sizeof(r1v, sz, ierr)
  if (sz /= ref) stop 4

  call MPI_Type_size(MPI_DOUBLE_PRECISION, ref, ierr)
  call MPI_Sizeof(d1, sz, ierr)
  if (sz /= ref) stop 5
  call MPI_Sizeof(d1v, sz, ierr)
  if (sz /= ref) stop 6

  call MPI_Type_size(MPI_COMPLEX, ref, ierr)
  call MPI_Sizeof(c1, sz, ierr)
  if (sz /= ref) stop 7
  call MPI_Sizeof(c1v, sz, ierr)
  if (sz /= ref) stop 8

  call MPI_Type_size(MPI_LOGICAL, ref, ierr)
  call MPI_Sizeof(l1, sz, ierr)
  if (sz /= ref) stop 9
  call MPI_Sizeof(l1v, sz, ierr)
  if (sz /= ref) stop 10

  ! CHARACTER had no specific at all
  call MPI_Type_size(MPI_CHARACTER, ref, ierr)
  call MPI_Sizeof(ch1, sz, ierr)
  if (sz /= ref) stop 11
  call MPI_Sizeof(ch1v, sz, ierr)
  if (sz /= ref) stop 12

  print '("scalars and rank-1 arrays agree with MPI_Type_size")'

  ! ierror is optional in mpif's specifics, so omitting it must work
  sz = 0
  call MPI_Sizeof(r1, sz)
  call MPI_Type_size(MPI_REAL, ref, ierr)
  if (sz /= ref) stop 13
  print '("optional ierror: ok")'

  print '("sizeof_f90: all ok")'

  call MPI_Finalize(ierr)

end program sizeof_f90
