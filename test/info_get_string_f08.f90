! MPI_Info_get_string is the one string-returning routine where the caller says
! how much room there is, and the Fortran and C conventions for saying it differ:
! the C `buflen` counts the terminating NUL, the Fortran one does not. On top of
! that, `buflen` need not agree with `len(value)` at all, and MPI writes nothing
! whatsoever when the key is missing or `buflen` is zero.
!
! `canary` is declared right after `value` so that a wrapper sizing its internal
! buffer from `buflen` rather than from `len(value)` is caught here rather than
! by a crash somewhere later.

program info_get_string_f08
  use mpi_f08
  implicit none

  character*(*), parameter :: canary_text = "canary"
  character*(*), parameter :: short_key = "short"
  character*(*), parameter :: short_value = "123456789"
  character*(*), parameter :: long_key = "long"

  type(MPI_Info) :: info
  character*(16) :: value
  character*(16) :: canary
  character*(64) :: long_value
  integer :: buflen
  logical :: flag
  integer :: n

  long_value = repeat("x", 40)

  call MPI_Init()

  call MPI_Info_create(info)
  call MPI_Info_set(info, short_key, short_value)
  call MPI_Info_set(info, long_key, trim(long_value))

  ! A key that is not there: `flag` is false, and nothing else is touched
  canary = canary_text
  value = canary_text
  buflen = len(value)
  call MPI_Info_get_string(info, "missing", buflen, value, flag)
  if (flag) stop 1
  if (value /= canary_text) stop 2
  if (buflen /= len(value)) stop 3
  if (canary /= canary_text) stop 4
  print '("missing key: ok")'

  ! buflen == 0 asks for the length without asking for the value, so `value`
  ! must come back untouched
  canary = canary_text
  value = canary_text
  buflen = 0
  call MPI_Info_get_string(info, short_key, buflen, value, flag)
  if (.not. flag) stop 5
  if (buflen /= len(short_value)) stop 6
  if (value /= canary_text) stop 7
  if (canary /= canary_text) stop 8
  print '("buflen 0: ok, length is ",i0)', buflen

  ! Room for less than the value: `value` is truncated and blank padded, but
  ! `buflen` still reports the length the value actually has
  canary = canary_text
  value = ""
  buflen = 4
  call MPI_Info_get_string(info, short_key, buflen, value, flag)
  if (.not. flag) stop 9
  if (buflen /= len(short_value)) stop 10
  if (value(1:4) /= short_value(1:4)) stop 11
  do n = 5, len(value)
     if (value(n:n) /= " ") stop 12
  end do
  if (canary /= canary_text) stop 13
  print '("buflen 4: ok, value is """,a,"""")', trim(value)

  ! Exactly enough room for the whole value
  canary = canary_text
  value = ""
  buflen = len(short_value)
  call MPI_Info_get_string(info, short_key, buflen, value, flag)
  if (.not. flag) stop 14
  if (buflen /= len(short_value)) stop 15
  if (value /= short_value) stop 16
  if (canary /= canary_text) stop 17
  print '("buflen ",i0,": ok, value is """,a,"""")', len(short_value), trim(value)

  ! More room claimed than `value` has, and a value longer than either. Nothing
  ! may be written past `value`, and `buflen` reports the full length needed.
  canary = canary_text
  value = ""
  buflen = 1000
  call MPI_Info_get_string(info, long_key, buflen, value, flag)
  if (.not. flag) stop 18
  if (buflen /= len_trim(long_value)) stop 19
  if (value /= repeat("x", len(value))) stop 20
  if (canary /= canary_text) stop 21
  print '("buflen 1000 into a ",i0,"-character value: ok, length is ",i0)', &
       len(value), buflen

  call MPI_Info_free(info)

  print '("info_get_string_f08: all ok")'

  call MPI_Finalize()

end program info_get_string_f08
