! MPI_ARGV_NULL and MPI_ARGVS_NULL stand in for MPI_Comm_spawn's `argv` and
! MPI_Comm_spawn_multiple's `array_of_argv`, both of which are CHARACTER in
! Fortran. Declaring them INTEGER, as mpif once did, makes them unusable: the
! call does not compile at all, which is what killed MPICH's f77 and f90
! spawn/spawnf and spawn/spawnmult2f tests.
!
! This is a compile-time check, so the assertion is the build itself -- if the
! constants get the wrong type again, this file stops compiling and the test
! fails. It deliberately does not spawn: that needs a process launcher, and mpif's
! tests run the executable directly. Nor does it read the arrays, because mpif.h
! places them at the address of the C constants, which are null pointers; the
! generated wrappers recognise them by address instead.

program argv_null_f08
  use mpi_f08
  implicit none

  call takes_argv(MPI_ARGV_NULL)
  call takes_argvs(MPI_ARGVS_NULL)

  print '("argv_null_f08: all ok")'

contains

  ! The shape MPI_Comm_spawn declares for `argv`
  subroutine takes_argv(argv)
    character*(*), intent(in) :: argv(*)
  end subroutine takes_argv

  ! The shape MPI_Comm_spawn_multiple declares for `array_of_argv`
  subroutine takes_argvs(array_of_argv)
    character*(*), intent(in) :: array_of_argv(1, *)
  end subroutine takes_argvs

end program argv_null_f08
