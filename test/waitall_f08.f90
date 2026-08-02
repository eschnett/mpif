! `array_of_statuses` is an array in all six routines that take one --
! MPI_Waitall, MPI_Waitsome, MPI_Testall, MPI_Testsome,
! MPI_Request_get_status_all and MPI_Request_get_status_some -- and mpif
! declared it as a single status, because the generator ignored the parameter's
! length. In mpi_f08 that made the six unusable: passing the array the standard
! asks for was a compile error, "Rank mismatch in argument 'array_of_statuses'
! (scalar and rank-1)". So this file does not compile at all against the old
! declaration, which is the first assertion here.
!
! The second is what the declaration alone would not have fixed. The C wrapper
! hands MPI the caller's buffer and MPI fills in one status per request, while
! the f08 wrapper converted through a temporary sized for one status -- so
! every element past the first was written outside it. Hence the per-element
! checks below rather than a look at statuses(1).
!
! It also covers error 18, the indices those routines report: MPI_Waitsome's
! `array_of_indices` and MPI_Waitany's scalar `index` came straight from C,
! numbered from zero, where Fortran numbers requests from one.
!
! The third is MPI_STATUSES_IGNORE, which no generated wrapper named: the guards
! all compared against MPI_STATUS_IGNORE. Both are ((MPI_Status*)0) in the ABI,
! so that comparison was not wrong -- but naming the sentinel the caller actually
! passes is what keeps it from depending on the two sharing a value. Passing it
! at all took fixing something else first; see the declaration of
! MPI_STATUSES_IGNORE in src/mpif_f08_types.F90.
!
! Everything is done on MPI_COMM_SELF so that no launcher is needed.

program waitall_f08
  use mpi_f08
  implicit none

  integer, parameter :: n = 4
  type(MPI_Request) :: reqs(2*n)
  type(MPI_Status) :: statuses(2*n)
  type(MPI_Status) :: status
  integer :: sendbuf(n), recvbuf(n), indices(2*n)
  integer :: i, cnt, outcount, done, idx
  logical :: flag

  call MPI_Init()

  ! MPI_Waitall, with the statuses reported

  call post(reqs)
  call MPI_Waitall(2*n, reqs, statuses)
  call check_recvbuf(1)
  ! The receives are the first n requests, each with its own tag. A one-status
  ! temporary could not have produced any of these but the first.
  do i = 1, n
     if (statuses(i)%MPI_TAG /= i) stop 2
     if (statuses(i)%MPI_SOURCE /= 0) stop 3
     call MPI_Get_count(statuses(i), MPI_INTEGER, cnt)
     if (cnt /= 1) stop 4
  end do
  print '("MPI_Waitall with an array of statuses: ok")'

  ! MPI_Waitall, ignoring them. The sentinel has to be recognised rather than
  ! written through.

  call post(reqs)
  call MPI_Waitall(2*n, reqs, MPI_STATUSES_IGNORE)
  call check_recvbuf(5)
  print '("MPI_Waitall with MPI_STATUSES_IGNORE: ok")'

  ! MPI_Testall, which reports the same array once every request is complete

  call post(reqs)
  flag = .false.
  do while (.not. flag)
     call MPI_Testall(2*n, reqs, flag, statuses)
  end do
  call check_recvbuf(6)
  do i = 1, n
     if (statuses(i)%MPI_TAG /= i) stop 7
  end do
  print '("MPI_Testall with an array of statuses: ok")'

  ! MPI_Waitsome, which fills in only the first `outcount` entries. The rest
  ! stay the caller's, which is why the copy back is bounded by `outcount` and
  ! not by the length of the array.

  call post(reqs)
  statuses(:)%MPI_TAG = -1
  done = 0
  do while (done < 2*n)
     call MPI_Waitsome(2*n, reqs, outcount, indices, statuses)
     if (outcount == MPI_UNDEFINED) stop 8
     if (outcount < 1 .or. outcount > 2*n) stop 9
     ! Status i belongs to request indices(i), and those are 1-based in Fortran
     ! where C counts from zero -- error 18, which was passing them through. Only
     ! the receives, the first n requests, have a tag to check: a send's status
     ! carries none, and Open MPI leaves it alone where MPICH fills it in.
     do i = 1, outcount
        if (indices(i) < 1 .or. indices(i) > 2*n) stop 12
        if (indices(i) <= n) then
           if (statuses(i)%MPI_TAG /= indices(i)) stop 13
        end if
     end do
     ! Nothing past outcount is touched, which is what bounds the copy back
     do i = outcount + 1, 2*n
        if (statuses(i)%MPI_TAG /= -1) stop 10
     end do
     done = done + outcount
     statuses(:)%MPI_TAG = -1
  end do
  call check_recvbuf(11)
  print '("MPI_Waitsome with an array of statuses: ok")'

  ! MPI_Waitany, for the scalar half of error 18. Its index is 1-based too, and
  ! MPI_UNDEFINED once nothing is left to wait for.

  call post(reqs)
  do i = 1, 2*n
     call MPI_Waitany(2*n, reqs, idx, status)
     if (idx < 1 .or. idx > 2*n) stop 14
     if (idx <= n) then
        if (status%MPI_TAG /= idx) stop 15
     end if
  end do
  call check_recvbuf(16)
  call MPI_Waitany(2*n, reqs, idx, status)
  if (idx /= MPI_UNDEFINED) stop 17
  print '("MPI_Waitany with a 1-based index: ok")'

  print '("waitall_f08: all ok")'

  call MPI_Finalize()

contains

  ! n receives, then n sends of one integer each, tagged 1..n, all to self
  subroutine post(requests)
    type(MPI_Request), intent(out) :: requests(2*n)
    integer :: j
    recvbuf = 0
    do j = 1, n
       call MPI_Irecv(recvbuf(j), 1, MPI_INTEGER, 0, j, MPI_COMM_SELF, requests(j))
    end do
    do j = 1, n
       sendbuf(j) = 100 + j
       call MPI_Isend(sendbuf(j), 1, MPI_INTEGER, 0, j, MPI_COMM_SELF, requests(n+j))
    end do
  end subroutine post

  subroutine check_recvbuf(code)
    integer, intent(in) :: code
    integer :: j
    do j = 1, n
       if (recvbuf(j) /= 100 + j) then
          print '("recvbuf wrong at element ", i0, ", check ", i0)', j, code
          stop 1
       end if
    end do
  end subroutine check_recvbuf

end program waitall_f08
