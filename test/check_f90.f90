program check_f90
  use mpi
  use, intrinsic :: iso_fortran_env, only: error_unit
  implicit none

  integer :: ierror

  ! What this process can see, and that it got to the end. Both lines are the
  ! instrument for the check_env*_fail flake, and they are here rather than in
  ! the library because they are about the test, not about mpif: MISSING.md
  ! "The check_env*_fail tests flake, on CI runners and not here" says which
  ! cause each outcome points to. Written to stderr like mpif's own
  ! diagnostics, so that all of this process's output shares one fd and one
  ! fate; a prefix of "check_f90: " and not "mpif: mpif_check_environment: ",
  ! which is what the failure tests in CMakeLists.txt pass on.
  call show_environment()

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

  write (error_unit, '(a)') "check_f90: every check completed"
  flush (error_unit)

contains

  ! One line naming every variable mpif_check_environment reads, with the value
  ! this process sees or <unset>. Printed before the first check, so a run that
  ! aborts still leaves it -- unless the launcher drops the process's output
  ! entirely, which is the other candidate and the reason the line exists.
  subroutine show_environment()
    character(len=1024) :: line

    line = "check_f90: environment:"
    call append_variable(line, "MPIF_SIZE")
    call append_variable(line, "MPIF_NUM_NODES")
    call append_variable(line, "MPIF_NODE_SIZE")
    call append_variable(line, "MPIF_MPI_LIBRARY")
    write (error_unit, '(a)') trim(line)
    flush (error_unit)
  end subroutine show_environment

  subroutine append_variable(line, name)
    character(len=*), intent(inout) :: line
    character(len=*), intent(in) :: name

    character(len=256) :: value
    integer :: length, status

    call get_environment_variable(name, value, length, status)
    ! status 0 is "present"; 1 is "not present" and -1 "value truncated", and
    ! the truncated case still has the first len(value) characters to show.
    if (status == 0 .or. status == -1) then
      line = trim(line) // " " // name // "=" // value(1:min(length, len(value)))
    else
      line = trim(line) // " " // name // "=<unset>"
    end if
  end subroutine append_variable

end program check_f90
