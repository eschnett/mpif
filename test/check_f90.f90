program check_f90
  use mpi
  implicit none

  integer :: ierror

  ! Both checks are callable at any time; before MPI_Init and after
  ! MPI_Finalize the environment check does what MPI-5.0 Table 11.1 allows and
  ! skips the rest. A failure aborts, so reaching the end is the assertion.
  !
  ! This binary is also reused by the check_env* tests in CMakeLists.txt,
  ! which run it under mpiexec with the MPIF_* variables set to values that
  ! must pass or must abort.
  call mpif_check_version(MPIF_VERSION, MPIF_SUBVERSION, MPIF_PATCH)
  call mpif_check_environment()

  call MPI_Init(ierror)
  call mpif_check_version(MPIF_VERSION, MPIF_SUBVERSION, MPIF_PATCH)
  call mpif_check_environment()
  call MPI_Finalize(ierror)

  call mpif_check_environment()

end program check_f90
