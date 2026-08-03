! What the PMPI interface is for: a profiling layer that replaces an MPI entry
! point and calls the library's own through the P name.
!
! Everything else about PMPI can be checked by calling it -- that the names exist,
! link, and do what their twins do. This checks the property that makes them worth
! having, and it is a property of the pair rather than of either name: the program
! below defines its own external `mpi_comm_rank_` and `mpi_barrier_`, so its
! `call MPI_Comm_rank` lands in its own routine, which counts the call and then
! reaches the real one through PMPI_Comm_rank. This is MPICH's f90/profile/
! profile1f90 in miniature.
!
! The counter is the assertion, and it asserts in both directions. Reaching one
! means the interception happened at all; reaching exactly one means PMPI_Comm_rank
! did not come back through the interceptor -- which is what a `pmpi_comm_rank_`
! that called C's MPI_Comm_rank would do wherever a tool had replaced that too,
! and what a `PMPI_Comm_rank` implemented as a rename of `MPI_Comm_rank` would do
! immediately, and unboundedly.
!
! It works because libmpifort_abi is a shared library: the executable's definition
! of `mpi_comm_rank_` takes precedence over the library's for the executable's own
! calls. That is the same mechanism a real tools layer relies on.

module profile_counts
  implicit none
  integer :: rank_calls = 0
  integer :: barrier_calls = 0
end module profile_counts

! The interceptors. `only:` rather than a plain `use mpi`, so that MPI_Comm_rank
! is not use-associated into a scope that defines a procedure of that name.

subroutine MPI_Comm_rank(comm, rank, ierror)
  use mpi, only: PMPI_Comm_rank
  use profile_counts, only: rank_calls
  implicit none
  integer :: comm, rank, ierror
  rank_calls = rank_calls + 1
  call PMPI_Comm_rank(comm, rank, ierror)
end subroutine MPI_Comm_rank

subroutine MPI_Barrier(comm, ierror)
  use mpi, only: PMPI_Barrier
  use profile_counts, only: barrier_calls
  implicit none
  integer :: comm, ierror
  barrier_calls = barrier_calls + 1
  call PMPI_Barrier(comm, ierror)
end subroutine MPI_Barrier

program profile_f90
  use mpi
  use profile_counts
  implicit none

  integer :: ierr, rank, size, prank

  call MPI_Init(ierr)
  if (ierr /= MPI_SUCCESS) stop 1

  ! Intercepted: our routine runs, and the value it hands back is the real one
  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  if (ierr /= MPI_SUCCESS) stop 2
  if (rank_calls /= 1) stop 3

  call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)
  if (rank < 0 .or. rank >= size) stop 4

  ! Not intercepted -- nothing here defines `pmpi_comm_rank_` -- and it must agree
  call PMPI_Comm_rank(MPI_COMM_WORLD, prank, ierr)
  if (ierr /= MPI_SUCCESS) stop 5
  if (prank /= rank) stop 6
  ! Still one: the P name is the way past the interceptor, not back into it
  if (rank_calls /= 1) stop 7

  call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  if (rank_calls /= 2) stop 8

  call MPI_Barrier(MPI_COMM_WORLD, ierr)
  if (ierr /= MPI_SUCCESS) stop 9
  if (barrier_calls /= 1) stop 10

  call PMPI_Barrier(MPI_COMM_WORLD, ierr)
  if (ierr /= MPI_SUCCESS) stop 11
  if (barrier_calls /= 1) stop 12

  print '("profile_f90: ", I0, " intercepted MPI_Comm_rank, ", I0, &
       " intercepted MPI_Barrier, all ok")', rank_calls, barrier_calls

  call MPI_Finalize(ierr)

end program profile_f90
