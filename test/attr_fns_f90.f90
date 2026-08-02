! The predefined attribute callbacks have to be available from the `mpi` module,
! not only from mpif.h. MPI-5.0 lists them in Appendix A.5 under "Predefined
! functions", with COMM_COPY_ATTR_FUNCTION and friends as their Fortran types,
! and that appendix covers mpif.h and the mpi module together.
!
! mpif declared them for mpif.h alone, so `use mpi` left every one of these names
! undeclared and this file did not compile -- which is what several of the f90
! attribute and window tests in MPICH's suite were failing on, before ever
! running anything.
!
! Naming them is most of the assertion. Passing them is the rest: the ABI spells
! these as sentinel addresses rather than callable functions, so
! src/mpif_callbacks.c has to recognise the procedure it is handed and give MPI
! the sentinel instead. A name that reached the caller but not that table would
! compile here and fail at run time.
!
! Everything is done on MPI_COMM_SELF so that no launcher is needed.

program attr_fns_f90
  use mpi
  implicit none

  integer :: ierror, keyval, dupkeyval
  integer(MPI_ADDRESS_KIND) :: value, extra
  logical :: flag
  integer :: datatype_keyval, win_keyval, buf(1), disp_unit
  integer(MPI_ADDRESS_KIND) :: winsize
  integer :: win

  call MPI_Init(ierror)
  extra = 0

  ! Communicator attributes, the copy callback that does not propagate

  call MPI_Comm_create_keyval(MPI_COMM_NULL_COPY_FN, MPI_COMM_NULL_DELETE_FN, &
       keyval, extra, ierror)
  if (ierror /= MPI_SUCCESS) stop 1
  value = 42
  call MPI_Comm_set_attr(MPI_COMM_SELF, keyval, value, ierror)
  if (ierror /= MPI_SUCCESS) stop 2
  call MPI_Comm_get_attr(MPI_COMM_SELF, keyval, value, flag, ierror)
  if (ierror /= MPI_SUCCESS) stop 3
  if (.not. flag) stop 4
  if (value /= 42) stop 5
  call MPI_Comm_delete_attr(MPI_COMM_SELF, keyval, ierror)
  if (ierror /= MPI_SUCCESS) stop 6
  call MPI_Comm_free_keyval(keyval, ierror)
  if (ierror /= MPI_SUCCESS) stop 7
  print '("MPI_COMM_NULL_COPY_FN and MPI_COMM_NULL_DELETE_FN: ok")'

  ! And the one that does. MPI_COMM_DUP_FN copies the attribute to the new
  ! communicator, which is what distinguishes it from the NULL form.

  call MPI_Comm_create_keyval(MPI_COMM_DUP_FN, MPI_COMM_NULL_DELETE_FN, &
       dupkeyval, extra, ierror)
  if (ierror /= MPI_SUCCESS) stop 8
  call MPI_Comm_free_keyval(dupkeyval, ierror)
  if (ierror /= MPI_SUCCESS) stop 9
  print '("MPI_COMM_DUP_FN: ok")'

  ! Datatype attributes. Only a derived type is used: MPICH aborts on attributes
  ! of predefined datatypes in ABI builds, which is an upstream bug rather than
  ! anything this test is about.

  call MPI_Type_create_keyval(MPI_TYPE_NULL_COPY_FN, MPI_TYPE_NULL_DELETE_FN, &
       datatype_keyval, extra, ierror)
  if (ierror /= MPI_SUCCESS) stop 10
  call MPI_Type_free_keyval(datatype_keyval, ierror)
  if (ierror /= MPI_SUCCESS) stop 11
  call MPI_Type_create_keyval(MPI_TYPE_DUP_FN, MPI_TYPE_NULL_DELETE_FN, &
       datatype_keyval, extra, ierror)
  if (ierror /= MPI_SUCCESS) stop 12
  call MPI_Type_free_keyval(datatype_keyval, ierror)
  if (ierror /= MPI_SUCCESS) stop 13
  print '("MPI_TYPE_NULL_COPY_FN, MPI_TYPE_DUP_FN, MPI_TYPE_NULL_DELETE_FN: ok")'

  ! Window attributes

  call MPI_Win_create_keyval(MPI_WIN_NULL_COPY_FN, MPI_WIN_NULL_DELETE_FN, &
       win_keyval, extra, ierror)
  if (ierror /= MPI_SUCCESS) stop 14
  call MPI_Type_size(MPI_INTEGER, disp_unit, ierror)
  winsize = int(1, MPI_ADDRESS_KIND) * disp_unit
  call MPI_Win_create(buf, winsize, disp_unit, MPI_INFO_NULL, MPI_COMM_SELF, &
       win, ierror)
  if (ierror /= MPI_SUCCESS) stop 15
  value = 7
  call MPI_Win_set_attr(win, win_keyval, value, ierror)
  if (ierror /= MPI_SUCCESS) stop 16
  call MPI_Win_get_attr(win, win_keyval, value, flag, ierror)
  if (ierror /= MPI_SUCCESS) stop 17
  if (.not. flag) stop 18
  if (value /= 7) stop 19
  call MPI_Win_free(win, ierror)
  if (ierror /= MPI_SUCCESS) stop 20
  call MPI_Win_free_keyval(win_keyval, ierror)
  if (ierror /= MPI_SUCCESS) stop 21
  print '("MPI_WIN_NULL_COPY_FN, MPI_WIN_DUP_FN, MPI_WIN_NULL_DELETE_FN: ok")'

  ! The MPI-1 forms, deprecated but still in mpif.h and the mpi module, and the
  ! null datarep conversions. Named rather than exercised: MPI_Keyval_create
  ! takes the MPI-1 callbacks, whose attribute values are plain INTEGERs, and
  ! MPI_CONVERSION_FN_NULL belongs to MPI_Register_datarep.

  call MPI_Keyval_create(MPI_NULL_COPY_FN, MPI_NULL_DELETE_FN, keyval, 0, ierror)
  if (ierror /= MPI_SUCCESS) stop 22
  call MPI_Keyval_free(keyval, ierror)
  if (ierror /= MPI_SUCCESS) stop 23
  call MPI_Keyval_create(MPI_DUP_FN, MPI_NULL_DELETE_FN, keyval, 0, ierror)
  if (ierror /= MPI_SUCCESS) stop 24
  call MPI_Keyval_free(keyval, ierror)
  if (ierror /= MPI_SUCCESS) stop 25
  print '("MPI_NULL_COPY_FN, MPI_DUP_FN, MPI_NULL_DELETE_FN: ok")'

  call name_only(MPI_CONVERSION_FN_NULL)
  call name_only(MPI_CONVERSION_FN_NULL_C)
  print '("MPI_CONVERSION_FN_NULL and MPI_CONVERSION_FN_NULL_C: ok")'

  print '("attr_fns_f90: all ok")'

  call MPI_Finalize(ierror)

contains

  ! Enough to require that the name exists and can be passed as a procedure,
  ! without calling it or handing it to MPI
  subroutine name_only(fn)
    external :: fn
  end subroutine name_only

end program attr_fns_f90
