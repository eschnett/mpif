! Interposing an mpi_f08 wrapper, which is what the Table 19.1 specific procedure
! names are for and what could not be done before they existed.
!
! `test/profile_f90.f90` is this test for the mpi module, where the specific has
! always been the external `mpi_comm_rank_` and a tool has always been able to
! replace it. In mpi_f08 the wrappers used to be module procedures named
! MPI_Comm_rank, so a call resolved to a symbol the compiler had mangled and
! nothing could stand in front of it. They are external procedures now, named as
! Table 19.1 gives them -- `MPI_Comm_rank_f08` always, this routine having no
! choice buffer; a buffer routine is `MPI_Send_f08ts` where MPIF_HAVE_CFI makes
! its buffers `TYPE(*), DIMENSION(..)` and `MPI_Send_f08` on the `ignore_tkr`
! fallback (the suite's f08/profile1f90 interposes the former) -- so the
! program below can define its own and have `call MPI_Comm_rank(...)` land in it.
!
! Section 19.1.5 is what this asserts: a profiling routine "should provide the
! same specific Fortran procedure names and calling conventions, and therefore can
! interpose itself as the MPI library routine. The profiling routine can
! internally call the matching PMPI routine".
!
! The interposed routine must match the specific exactly -- its dummy argument
! names included, since a caller may use keywords -- because the generic in
! mpi_f08 is declared over that interface and the definition here has to be the
! procedure it describes.

module profile_f08_counts
  implicit none
  integer :: rank_calls = 0
  integer :: barrier_calls = 0
end module profile_f08_counts

! The interceptors, under the specific names. `only:` keeps the generic out of a
! scope that defines one of its specifics.

subroutine MPI_Comm_rank_f08(comm, rank, ierror)
  use mpi_f08, only: MPI_Comm, PMPI_Comm_rank
  use profile_f08_counts, only: rank_calls
  implicit none
  type(MPI_Comm), intent(in) :: comm
  integer, intent(out) :: rank
  integer, optional, intent(out) :: ierror
  rank_calls = rank_calls + 1
  call PMPI_Comm_rank(comm, rank, ierror)
end subroutine MPI_Comm_rank_f08

subroutine MPI_Barrier_f08(comm, ierror)
  use mpi_f08, only: MPI_Comm, PMPI_Barrier
  use profile_f08_counts, only: barrier_calls
  implicit none
  type(MPI_Comm), intent(in) :: comm
  integer, optional, intent(out) :: ierror
  barrier_calls = barrier_calls + 1
  call PMPI_Barrier(comm, ierror)
end subroutine MPI_Barrier_f08

program profile_f08
  use mpi_f08
  use profile_f08_counts
  implicit none

  integer :: rank, size, prank

  call MPI_Init()

  ! Written as the generic, resolved to the specific, and the specific is ours
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  if (rank_calls /= 1) stop 1

  call MPI_Comm_size(MPI_COMM_WORLD, size)
  if (rank < 0 .or. rank >= size) stop 2

  ! The P name is the way past the interceptor, not back into it
  call PMPI_Comm_rank(MPI_COMM_WORLD, prank)
  if (prank /= rank) stop 3
  if (rank_calls /= 1) stop 4

  ! ierror omitted above and supplied here: both reach the same dummy, which is
  ! OPTIONAL in the specific as A.4 requires
  block
    integer :: ierr
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    if (ierr /= MPI_SUCCESS) stop 5
    if (rank_calls /= 2) stop 6
  end block

  call MPI_Barrier(MPI_COMM_WORLD)
  if (barrier_calls /= 1) stop 7
  call PMPI_Barrier(MPI_COMM_WORLD)
  if (barrier_calls /= 1) stop 8

  print '("profile_f08: ", I0, " intercepted MPI_Comm_rank, ", I0, &
       " intercepted MPI_Barrier, all ok")', rank_calls, barrier_calls

  call MPI_Finalize()

end program profile_f08
