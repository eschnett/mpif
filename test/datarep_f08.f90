! MPI_Register_datarep accepts Fortran callbacks.
!
! Until the box in src/mpif_callbacks.c existed, mpif refused every one of them
! itself: the conversion and extent callbacks are told only `extra_state`, so
! there was nothing for a trampoline to look up, and any user-defined procedure
! got MPI_ERR_OTHER and a diagnostic without MPI ever seeing the call.
! `extra_state` is mpif's to choose, so it now carries a box holding the three
! Fortran procedures.
!
! What this file can assert stops there, because neither implementation
! implements user-defined datareps -- see "Registered datareps are not
! implemented" in MISSING.md. MPICH's ROMIO rejects a non-NULL conversion
! function outright and accepts only native, external32 and internal in
! MPI_File_set_view, so a registered datarep can never be used; Open MPI's ompio
! returns an error from register_datarep unconditionally. The callbacks
! therefore never fire, whatever mpif does.
!
! So the registration below uses MPI_CONVERSION_FN_NULL for the two conversions
! and a Fortran procedure for the extent, which is the one combination ROMIO
! accepts -- and which mpif refused before this worked, the extent function
! being user-defined. test/datarep_c.c covers what is left, calling the
! trampolines directly with known arguments, since no implementation will.
!
! Everything is done on MPI_COMM_SELF so that no launcher is needed.

module datarep_f08_fns
  use mpi_f08
  implicit none

  integer(MPI_ADDRESS_KIND), parameter :: TOKEN = 20260802_MPI_ADDRESS_KIND

contains

  subroutine extent_fn(datatype, extent, extra_state, ierror)
    type(MPI_Datatype) :: datatype
    integer(MPI_ADDRESS_KIND) :: extent
    integer(MPI_ADDRESS_KIND) :: extra_state
    integer :: ierror
    integer :: size

    if (extra_state /= TOKEN) then
       ierror = MPI_ERR_OTHER
       return
    end if

    ! One byte in the file per byte in memory: this datarep would change values
    ! and not sizes.
    call MPI_Type_size(datatype, size)
    extent = size
    ierror = MPI_SUCCESS
  end subroutine extent_fn

end module datarep_f08_fns

program datarep_f08
  use mpi_f08
  use datarep_f08_fns
  implicit none

  integer :: ierror

  call MPI_Init()

  ! The assertion. Before the box existed this returned MPI_ERR_OTHER from
  ! mpif's own refusal, with "mpif: MPI_Register_datarep: ... not supported" on
  ! stderr, because `extent_fn` is not one of the predefined callbacks.
  call MPI_Register_datarep("mpif-null", MPI_CONVERSION_FN_NULL, &
       MPI_CONVERSION_FN_NULL, extent_fn, TOKEN, ierror)
  if (ierror /= MPI_SUCCESS) stop 1

  ! Registering the same name twice would show the first registration really
  ! took, and is not asserted on: MPICH reports MPI_ERR_DUP_DATAREP, and Open MPI
  ! reports success, because it never registered anything the first time either.
  ! See the blocker in MISSING.md.

  print '("datarep_f08: all ok")'

  call MPI_Finalize()

end program datarep_f08
