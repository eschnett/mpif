! MPI_Alltoallw over an intercommunicator whose two groups have different sizes.
!
! For an intercommunicator the arrays are indexed over the *remote* group -- the
! outcome is "as if each MPI process in group A sends a message to each MPI
! process in group B, and vice versa" (MPI-5.0 6.8) -- while MPI_COMM_SIZE
! "returns the size of the local group" (7.6). mpif used the latter, so on the
! group of one it converted one handle where the implementation reads two, and on
! the group of two it read one element past a one-element array. Three ranks
! rather than two, because at two the groups are the same size and the defect is
! invisible.

program alltoallw_inter_f08
  use mpi_f08
  implicit none

  integer, parameter :: max_size = 8
  integer :: rank, size, intsize, i, expected
  integer :: remote_size, remote_leader
  type(MPI_Comm) :: local_comm, inter
  integer :: scounts(max_size), sdispls(max_size)
  integer :: rcounts(max_size), rdispls(max_size)
  type(MPI_Datatype) :: stypes(max_size), rtypes(max_size)
  integer :: sbuf(max_size), rbuf(max_size)

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)
  if (size /= 3) then
     print *, "this test wants exactly three ranks, not ", size
     call MPI_Abort(MPI_COMM_WORLD, 1)
  end if
  call MPI_Type_size(MPI_INTEGER, intsize)

  ! Groups {0} and {1, 2}, each ordered by world rank since that is the key.
  if (rank == 0) then
     call MPI_Comm_split(MPI_COMM_WORLD, 0, rank, local_comm)
     remote_leader = 1
  else
     call MPI_Comm_split(MPI_COMM_WORLD, 1, rank, local_comm)
     remote_leader = 0
  end if
  call MPI_Intercomm_create(local_comm, 0, MPI_COMM_WORLD, remote_leader, 7, inter)
  call MPI_Comm_remote_size(inter, remote_size)

  do i = 1, remote_size
     scounts(i) = 1
     sdispls(i) = (i - 1) * intsize
     stypes(i) = MPI_INTEGER
     ! My own world rank, to every member of the remote group.
     sbuf(i) = rank
     rcounts(i) = 1
     rdispls(i) = (i - 1) * intsize
     rtypes(i) = MPI_INTEGER
     rbuf(i) = -1
  end do

  call MPI_Alltoallw(sbuf, scounts, sdispls, stypes, &
                     rbuf, rcounts, rdispls, rtypes, inter)

  do i = 1, remote_size
     ! Block i is the world rank of the remote group's i-th member: {1, 2} seen
     ! from rank 0, and {0} seen from ranks 1 and 2.
     if (rank == 0) then
        expected = i
     else
        expected = 0
     end if
     if (rbuf(i) /= expected) then
        print *, "rank ", rank, ": rbuf(", i, ") = ", rbuf(i), ", expected ", expected
        call MPI_Abort(MPI_COMM_WORLD, 1)
     end if
  end do

  call MPI_Comm_free(inter)
  call MPI_Comm_free(local_comm)
  call MPI_Finalize()
end program alltoallw_inter_f08
