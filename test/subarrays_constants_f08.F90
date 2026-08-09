! MPI_SUBARRAYS_SUPPORTED and MPI_ASYNC_PROTECTS_NONBLOCKING must say what the
! build actually did: .true. in mpi_f08 where the TS 29113 probe passed and
! the assumed-rank buffers are in, .false. everywhere else -- and .false. in
! the mpi module always, which keeps ignore_tkr whatever the probe said.
!
! The expected value arrives as MPIF_EXPECT_SUBARRAYS from test/CMakeLists.txt,
! which re-runs the same probe (or takes an explicit override), so this test
! cannot pass vacuously: a build whose constants disagree with its buffers
! fails here whichever way the disagreement goes.

subroutine check_f08(expected)
  use mpi_f08, only: MPI_SUBARRAYS_SUPPORTED, MPI_ASYNC_PROTECTS_NONBLOCKING
  implicit none
  logical, intent(in) :: expected
  if (MPI_SUBARRAYS_SUPPORTED .neqv. expected) stop 1
  if (MPI_ASYNC_PROTECTS_NONBLOCKING .neqv. expected) stop 2
end subroutine check_f08

subroutine check_f90
  use mpi, only: MPI_SUBARRAYS_SUPPORTED, MPI_ASYNC_PROTECTS_NONBLOCKING
  implicit none
  if (MPI_SUBARRAYS_SUPPORTED) stop 3
  if (MPI_ASYNC_PROTECTS_NONBLOCKING) stop 4
end subroutine check_f90

program subarrays_constants_f08
  use mpi_f08, only: MPI_Init, MPI_Finalize
  implicit none
#if MPIF_EXPECT_SUBARRAYS
  logical, parameter :: expected = .true.
#else
  logical, parameter :: expected = .false.
#endif
  call MPI_Init()
  call check_f08(expected)
  call check_f90
  call MPI_Finalize()
end program subarrays_constants_f08
