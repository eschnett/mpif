! MPI-5.0 requires the Fortran bindings to strip leading as well as trailing
! spaces from info keys and values -- section 10 "The Info Object" ("In Fortran,
! leading and trailing spaces are stripped from both") and MPI_INFO_SET ("In
! Fortran, leading and trailing spaces in key and value are stripped"). Fortran
! pads strings with blanks on the right, so the trailing half is unavoidable; the
! leading half needs a separate helper, and only for the arguments the standard
! names. See mpif_strdup_f2c_trim in src/mpif_strings.c.
!
! Also checks that MPI_Info_get leaves value alone when the key does not exist,
! which the standard spells out as "otherwise it sets flag to false and leaves
! value unchanged".

program info_blanks_f08
  use mpi_f08
  implicit none

  character*(*), parameter :: canary_text = "canary"

  type(MPI_Info) :: info
  character*(MPI_MAX_INFO_KEY) :: key
  character*(MPI_MAX_INFO_VAL) :: value
  integer :: nkeys, valuelen, buflen
  logical :: flag

  call MPI_Init()
  call MPI_Info_create(info)

  ! Leading blanks on the key, leading and trailing blanks on the value
  call MPI_Info_set(info, "  spaced key", "  spaced value  ")

  call MPI_Info_get_nkeys(info, nkeys)
  if (nkeys /= 1) stop 1

  ! The key must have been stored without its leading blanks
  call MPI_Info_get_nthkey(info, 0, key)
  if (key /= "spaced key") stop 2

  ! ... and must be findable under the stripped spelling
  buflen = len(value)
  value = ""
  call MPI_Info_get_string(info, "spaced key", buflen, value, flag)
  if (.not. flag) stop 3
  if (value /= "spaced value") stop 4
  if (buflen /= len("spaced value")) stop 5

  ! A leading-blank key on lookup is stripped too, so it finds the same entry
  buflen = len(value)
  value = ""
  call MPI_Info_get_string(info, "   spaced key   ", buflen, value, flag)
  if (.not. flag) stop 6
  if (value /= "spaced value") stop 7

  call MPI_Info_get_valuelen(info, "  spaced key", valuelen, flag)
  if (.not. flag) stop 8
  if (valuelen /= len("spaced value")) stop 9
  print '("leading blanks stripped from key and value: ok")'

  ! Not tested here: an all-blank value, which strips to the empty string. That
  ! is what MPI_COMM_SPAWN's `argv` requires of the same helper, but Open MPI
  ! rejects an empty info value with MPI_ERR_INFO_VALUE, so asserting it through
  ! MPI_Info_set would test the implementations' disagreement rather than mpif.

  ! MPI_Info_get must leave value alone for a key that is not there
  value = canary_text
  call MPI_Info_get(info, "missing", len(value), value, flag)
  if (flag) stop 10
  if (value /= canary_text) stop 11
  print '("MPI_Info_get leaves value unchanged for a missing key: ok")'

  ! A leading-blank key reaches MPI_Info_delete stripped as well
  call MPI_Info_delete(info, "  spaced key")
  call MPI_Info_get_nkeys(info, nkeys)
  if (nkeys /= 0) stop 12
  print '("leading blanks stripped for MPI_Info_delete: ok")'

  call MPI_Info_free(info)

  print '("info_blanks_f08: all ok")'

  call MPI_Finalize()

end program info_blanks_f08
