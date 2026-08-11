! MPI_SESSION_GET_NTH_PSET is the second of the two routines where the caller
! says how much room its string has and MPI answers with how much it needs, and
! MPI-5.0 11.3.2 gives it MPI_INFO_GET_STRING's semantics word for word:
!
! - "In C, pset_len includes the required space for the null terminator", so the
!   Fortran count is one less and the value coming back has to be adjusted;
! - "If pset_len is set to 0, pset_name is not changed" -- the standard's own
!   recommended idiom for asking the length alone, and the case where the
!   wrapper's internal buffer is never written and must not be copied out;
! - "the string value returned in pset_name is truncated" when there is not
!   enough room;
! - and pset_len need not agree with len(pset_name) at all, so a wrapper that
!   sizes its internal buffer from pset_len writes past the end of it.
!
! `canary` is declared right after `small_name` so that the last of those is
! caught here rather than by a crash somewhere later.
!
! What is *not* asserted is the length coming back from a query that passed a
! non-zero one in. The standard says "On return, the value of pset_len will be
! set to the required buffer size", unconditionally, but neither implementation
! does that -- both write pset_len only when the value passed in was zero, so
! what comes back is the length mpif handed them, less the NUL. See MISSING.md
! "MPI_SESSION_GET_NTH_PSET reports the required length only when asked for it
! alone". Each such case below therefore admits either answer, which still
! pins the off-by-one in both worlds.
!
! Nothing below assumes what the process set is called: the first query
! establishes the name and its length, and every later case is checked against
! that.

program session_get_nth_pset_f08
  use mpi_f08
  implicit none

  character*(*), parameter :: canary_text = "canary"

  type(MPI_Session) :: session
  character*(256) :: full_name
  character*(256) :: exact_name
  character*(4) :: small_name
  character*(16) :: canary
  integer :: npsets, pset_len, want, n

  ! Sessions need no MPI_INIT, but Open MPI's MPI_Errhandler_fromint refuses to
  ! translate MPI_ERRORS_ARE_FATAL before one -- "The MPI_Errhandler_fromint()
  ! function was called before MPI_INIT was invoked" -- and mpif has to call it
  ! to turn the Fortran INTEGER handle into a C one.
  call MPI_Init()

  ! MPI_ERRORS_ARE_FATAL rather than MPI_ERRHANDLER_NULL: the latter is not a
  ! valid error handler, and MPICH says so -- "internal_Session_init: Null
  ! errhandler".
  call MPI_Session_init(MPI_INFO_NULL, MPI_ERRORS_ARE_FATAL, session)

  call MPI_Session_get_num_psets(session, MPI_INFO_NULL, npsets)
  if (npsets < 1) stop 1
  print '("process sets: ",i0)', npsets

  ! Room to spare. This is the only case that learns what the answer is.
  full_name = ""
  pset_len = len(full_name)
  call MPI_Session_get_nth_pset(session, MPI_INFO_NULL, 0, pset_len, full_name)
  want = len_trim(full_name)
  if (want == 0) stop 2
  ! The name has to fit, or there is nothing here to compare against
  if (want >= len(full_name)) stop 3
  if (pset_len /= want .and. pset_len /= len(full_name)) stop 4
  print '("full query: """,a,""", length ",i0)', trim(full_name), pset_len

  ! pset_len = 0 asks for the length and nothing else. `pset_name` must come
  ! back untouched, and this is the one case where every implementation does
  ! report the length -- in characters, C's terminating NUL taken back off.
  ! Every process set, since this is the idiom the standard recommends and a
  ! caller may use it on any of them.
  do n = 0, npsets - 1
     canary = canary_text
     small_name = canary_text
     pset_len = 0
     call MPI_Session_get_nth_pset(session, MPI_INFO_NULL, n, pset_len, small_name)
     if (pset_len <= 0) stop 5
     if (small_name /= canary_text(1:len(small_name))) stop 6
     if (canary /= canary_text) stop 7
     if (n == 0 .and. pset_len /= want) stop 8
     print '("pset ",i0,": length-only query: ok, length is ",i0)', n, pset_len
  end do

  ! Exactly enough room for the whole name
  exact_name = ""
  pset_len = want
  call MPI_Session_get_nth_pset(session, MPI_INFO_NULL, 0, pset_len, exact_name(1:want))
  if (pset_len /= want) stop 9
  if (exact_name /= full_name) stop 10
  print '("exact fit: ok, length is ",i0)', pset_len

  if (want > len(small_name)) then

     ! Room for less than the name: `pset_name` is truncated and blank padded
     canary = canary_text
     small_name = ""
     pset_len = len(small_name)
     call MPI_Session_get_nth_pset(session, MPI_INFO_NULL, 0, pset_len, small_name)
     if (pset_len /= want .and. pset_len /= len(small_name)) stop 11
     if (small_name /= full_name(1:len(small_name))) stop 12
     if (canary /= canary_text) stop 13
     print '("pset_len ",i0,": ok, name is """,a,""", length ",i0)', &
          len(small_name), small_name, pset_len

     ! More room claimed than `small_name` has, and a name longer than either.
     ! Nothing may be written past `small_name`.
     canary = canary_text
     small_name = ""
     pset_len = 1000
     call MPI_Session_get_nth_pset(session, MPI_INFO_NULL, 0, pset_len, small_name)
     if (pset_len /= want .and. pset_len /= len(small_name)) stop 14
     if (small_name /= full_name(1:len(small_name))) stop 15
     if (canary /= canary_text) stop 16
     print '("pset_len 1000 into a ",i0,"-character name: ok, length is ",i0)', &
          len(small_name), pset_len

  end if

  call MPI_Session_finalize(session)

  print '("session_get_nth_pset_f08: all ok")'

  call MPI_Finalize()

end program session_get_nth_pset_f08
