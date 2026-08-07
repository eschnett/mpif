program check_version_fail_f90
  use mpi
  implicit none

  ! A major version the loaded library cannot be. The test passes when the
  ! abort's diagnostic appears -- CMakeLists.txt matches it with
  ! PASS_REGULAR_EXPRESSION -- so the stop below must not be reached.
  call mpif_check_version(MPIF_VERSION + 1, MPIF_SUBVERSION, MPIF_PATCH)
  stop 1

end program check_version_fail_f90
