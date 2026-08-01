! MPI writes attribute_val only when there is an attribute to report, so on a
! false flag the C `void*` it was given is still uninitialised. mpif has to convert
! that pointer to a Fortran INTEGER(MPI_ADDRESS_KIND), and for the predefined
! keyvals the conversion dereferences it -- MPI_UNIVERSE_SIZE and friends are a
! pointer to an int in C but a value in Fortran. Doing that unconditionally is a
! wild read, which is what crashed MPICH's f08 spawn tests: their
! MTestSpawnPossible asks MPI_COMM_WORLD for MPI_UNIVERSE_SIZE without knowing
! whether it is set. mpif now returns zero instead, as MPICH's own Fortran binding
! does.

program comm_get_attr_f08
  use mpi_f08
  implicit none

  integer :: keyval
  integer(MPI_ADDRESS_KIND) :: val
  logical :: flag

  ! mpif provides these as external subroutines (src/mpif_attr_fns.F90) rather
  ! than as entities of the mpi_f08 module, so they need declaring here
  procedure(MPI_Comm_copy_attr_function) :: MPI_COMM_NULL_COPY_FN
  procedure(MPI_Comm_delete_attr_function) :: MPI_COMM_NULL_DELETE_FN

  call MPI_Init()

  ! A keyval that exists but has no attribute attached: flag is false, and the
  ! value must be a defined zero rather than whatever was on the stack
  call MPI_Comm_create_keyval(MPI_COMM_NULL_COPY_FN, MPI_COMM_NULL_DELETE_FN, keyval, 0_MPI_ADDRESS_KIND)
  val = 12345
  flag = .true.
  call MPI_Comm_get_attr(MPI_COMM_WORLD, keyval, val, flag)
  if (flag) stop 1
  if (val /= 0) stop 2
  print '("unset keyval: flag=.false., val=0 as expected")'

  ! Now one it does have, to be sure the normal path still reports the value
  call MPI_Comm_set_attr(MPI_COMM_WORLD, keyval, 67890_MPI_ADDRESS_KIND)
  val = 0
  flag = .false.
  call MPI_Comm_get_attr(MPI_COMM_WORLD, keyval, val, flag)
  if (.not. flag) stop 3
  if (val /= 67890) stop 4
  print '("set keyval: flag=.true., val=", i0)', val

  call MPI_Comm_delete_attr(MPI_COMM_WORLD, keyval)
  call MPI_Comm_free_keyval(keyval)

  ! A predefined keyval that is set. These are a pointer to an int in C but a value
  ! in Fortran, so the conversion dereferences the pointer rather than just casting
  ! it, and MPI_TAG_UB is always there.
  val = 12345
  flag = .false.
  call MPI_Comm_get_attr(MPI_COMM_WORLD, MPI_TAG_UB, val, flag)
  if (.not. flag) stop 5
  if (val <= 0) stop 6
  print '("MPI_TAG_UB: flag=.true., val=", i0)', val

  ! And a predefined keyval that is not set, which is the case that crashed: the
  ! conversion dereferences a pointer MPI never wrote. Unlike a user keyval, where
  ! MPI nulls the pointer and the old code got away with it, this one segfaults
  ! without the guard.
  !
  ! MPI_APPNUM rather than MPI_UNIVERSE_SIZE, which is what the f08 spawn tests
  ! actually tripped over: asking for that one makes MPICH talk to the process
  ! manager, and these tests run the executable directly, so it hangs waiting for
  ! an mpiexec that was never started.
  val = 12345
  flag = .true.
  call MPI_Comm_get_attr(MPI_COMM_WORLD, MPI_APPNUM, val, flag)
  if (flag) then
     ! Set after all, under whatever launched this; then it must be sane
     if (val < 0) stop 7
     print '("MPI_APPNUM is set: ", i0)', val
  else
     if (val /= 0) stop 8
     print '("unset predefined keyval: flag=.false., val=0 as expected")'
  end if

  print '("comm_get_attr_f08: all ok")'

  call MPI_Finalize()

end program comm_get_attr_f08
