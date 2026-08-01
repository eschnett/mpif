! Fortran's predefined attribute copy and delete callbacks, and the null
! datarep conversion function.
!
! The MPI ABI defines these as sentinel addresses rather than callable
! functions -- MPI_COMM_NULL_COPY_FN is `((MPI_Comm_copy_attr_function*)0x0)` --
! but Fortran has to name procedures, and include/mpif_functions.h declares them
! EXTERNAL. So they exist here as ordinary external subroutines, and
! src/mpif_callbacks.c recognises their addresses and passes MPI the sentinel it
! expects instead. Their bodies therefore never run in the normal course of
! things; they implement what the standard prescribes anyway, in case a program
! calls one directly, which is legal if pointless.
!
! These must not live in a module: mpif.h declares them EXTERNAL, so they have
! to be plain global symbols.
!
! The copy callbacks report .FALSE., meaning the attribute is not propagated,
! except for the DUP variants which copy it. The delete callbacks do nothing.
! All report MPI_SUCCESS.

! Deprecated in MPI-2.0, for MPI_Keyval_create. Attribute values and extra
! state are plain default integers in these, not address-sized.

subroutine MPI_NULL_COPY_FN(oldcomm, keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierr)
  use mpi_constants, only: MPI_SUCCESS
  implicit none
  integer, intent(in) :: oldcomm, keyval, extra_state, attribute_val_in
  integer, intent(out) :: attribute_val_out
  logical, intent(out) :: flag
  integer, intent(out) :: ierr
  attribute_val_out = 0
  flag = .false.
  ierr = MPI_SUCCESS
end subroutine MPI_NULL_COPY_FN

subroutine MPI_DUP_FN(oldcomm, keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierr)
  use mpi_constants, only: MPI_SUCCESS
  implicit none
  integer, intent(in) :: oldcomm, keyval, extra_state, attribute_val_in
  integer, intent(out) :: attribute_val_out
  logical, intent(out) :: flag
  integer, intent(out) :: ierr
  attribute_val_out = attribute_val_in
  flag = .true.
  ierr = MPI_SUCCESS
end subroutine MPI_DUP_FN

subroutine MPI_NULL_DELETE_FN(comm, keyval, attribute_val, extra_state, ierr)
  use mpi_constants, only: MPI_SUCCESS
  implicit none
  integer, intent(in) :: comm, keyval, attribute_val, extra_state
  integer, intent(out) :: ierr
  ierr = MPI_SUCCESS
end subroutine MPI_NULL_DELETE_FN

! Communicator attributes

subroutine MPI_COMM_NULL_COPY_FN(oldcomm, comm_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: oldcomm, comm_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: extra_state, attribute_val_in
  integer(MPI_ADDRESS_KIND), intent(out) :: attribute_val_out
  logical, intent(out) :: flag
  integer, intent(out) :: ierror
  attribute_val_out = 0
  flag = .false.
  ierror = MPI_SUCCESS
end subroutine MPI_COMM_NULL_COPY_FN

subroutine MPI_COMM_DUP_FN(oldcomm, comm_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: oldcomm, comm_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: extra_state, attribute_val_in
  integer(MPI_ADDRESS_KIND), intent(out) :: attribute_val_out
  logical, intent(out) :: flag
  integer, intent(out) :: ierror
  attribute_val_out = attribute_val_in
  flag = .true.
  ierror = MPI_SUCCESS
end subroutine MPI_COMM_DUP_FN

subroutine MPI_COMM_NULL_DELETE_FN(comm, comm_keyval, attribute_val, &
     extra_state, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: comm, comm_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: attribute_val, extra_state
  integer, intent(out) :: ierror
  ierror = MPI_SUCCESS
end subroutine MPI_COMM_NULL_DELETE_FN

! Datatype attributes

subroutine MPI_TYPE_NULL_COPY_FN(oldtype, type_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: oldtype, type_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: extra_state, attribute_val_in
  integer(MPI_ADDRESS_KIND), intent(out) :: attribute_val_out
  logical, intent(out) :: flag
  integer, intent(out) :: ierror
  attribute_val_out = 0
  flag = .false.
  ierror = MPI_SUCCESS
end subroutine MPI_TYPE_NULL_COPY_FN

subroutine MPI_TYPE_DUP_FN(oldtype, type_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: oldtype, type_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: extra_state, attribute_val_in
  integer(MPI_ADDRESS_KIND), intent(out) :: attribute_val_out
  logical, intent(out) :: flag
  integer, intent(out) :: ierror
  attribute_val_out = attribute_val_in
  flag = .true.
  ierror = MPI_SUCCESS
end subroutine MPI_TYPE_DUP_FN

subroutine MPI_TYPE_NULL_DELETE_FN(datatype, type_keyval, attribute_val, &
     extra_state, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: datatype, type_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: attribute_val, extra_state
  integer, intent(out) :: ierror
  ierror = MPI_SUCCESS
end subroutine MPI_TYPE_NULL_DELETE_FN

! Window attributes

subroutine MPI_WIN_NULL_COPY_FN(oldwin, win_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: oldwin, win_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: extra_state, attribute_val_in
  integer(MPI_ADDRESS_KIND), intent(out) :: attribute_val_out
  logical, intent(out) :: flag
  integer, intent(out) :: ierror
  attribute_val_out = 0
  flag = .false.
  ierror = MPI_SUCCESS
end subroutine MPI_WIN_NULL_COPY_FN

subroutine MPI_WIN_DUP_FN(oldwin, win_keyval, extra_state, &
     attribute_val_in, attribute_val_out, flag, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: oldwin, win_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: extra_state, attribute_val_in
  integer(MPI_ADDRESS_KIND), intent(out) :: attribute_val_out
  logical, intent(out) :: flag
  integer, intent(out) :: ierror
  attribute_val_out = attribute_val_in
  flag = .true.
  ierror = MPI_SUCCESS
end subroutine MPI_WIN_DUP_FN

subroutine MPI_WIN_NULL_DELETE_FN(win, win_keyval, attribute_val, &
     extra_state, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_SUCCESS
  implicit none
  integer, intent(in) :: win, win_keyval
  integer(MPI_ADDRESS_KIND), intent(in) :: attribute_val, extra_state
  integer, intent(out) :: ierror
  ierror = MPI_SUCCESS
end subroutine MPI_WIN_NULL_DELETE_FN

! Datarep conversion. This one is a pure sentinel, meaning "no conversion is
! needed", and MPI never calls it -- hence MPI_ERR_INTERN rather than a
! plausible-looking no-op, so that a call that somehow does arrive is noticed.

subroutine MPI_CONVERSION_FN_NULL(userbuf, datatype, count, filebuf, &
     position, extra_state, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_ERR_INTERN, MPI_OFFSET_KIND
  implicit none
  integer, intent(in) :: userbuf(*), filebuf(*)
  integer, intent(in) :: datatype, count
  integer(MPI_OFFSET_KIND), intent(in) :: position
  integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
  integer, intent(out) :: ierror
  ierror = MPI_ERR_INTERN
end subroutine MPI_CONVERSION_FN_NULL

subroutine MPI_CONVERSION_FN_NULL_C(userbuf, datatype, count, filebuf, &
     position, extra_state, ierror)
  use mpi_constants, only: MPI_ADDRESS_KIND, MPI_COUNT_KIND, MPI_ERR_INTERN, &
       MPI_OFFSET_KIND
  implicit none
  integer, intent(in) :: userbuf(*), filebuf(*)
  integer, intent(in) :: datatype
  integer(MPI_COUNT_KIND), intent(in) :: count
  integer(MPI_OFFSET_KIND), intent(in) :: position
  integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
  integer, intent(out) :: ierror
  ierror = MPI_ERR_INTERN
end subroutine MPI_CONVERSION_FN_NULL_C
