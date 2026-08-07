program check_f08
  use mpi_f08
  implicit none

  ! Both checks are callable at any time; before MPI_Init and after
  ! MPI_Finalize the environment check does what MPI-5.0 Table 11.1 allows and
  ! skips the rest. A failure aborts, so reaching the end is the assertion.
  ! Run at three ranks so the token ring, the head count and the cross-rank
  ! comparisons are non-degenerate -- at one rank every wrong neighbor is the
  ! right one.
  call mpif_check_version(MPIF_VERSION, MPIF_SUBVERSION, MPIF_PATCH)
  call mpif_check_environment()

  call MPI_Init()
  call mpif_check_version(MPIF_VERSION, MPIF_SUBVERSION, MPIF_PATCH)
  call mpif_check_environment()
  call MPI_Finalize()

  call mpif_check_environment()

end program check_f08
