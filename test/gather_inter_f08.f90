! MPI_Gather and MPI_Scatter over an intercommunicator, where the root is named by
! MPI_ROOT rather than by a rank.
!
! MPI-5.0 6.2.3: "for the group containing the root, all MPI processes in the
! group must call the routine using a special argument for the root. For this, the
! root uses the special value MPI_ROOT; all other MPI processes in the same group
! as the root use MPI_PROC_NULL. All MPI processes in the other group ... pass the
! same value in argument root, which is the rank of the root in group A." So on an
! intercommunicator a process's own rank says nothing about whether a root-only
! argument is significant to it, and mpif has to test `root == MPI_ROOT` instead.
!
! Three ranks rather than two, and the root deliberately second in its group: with
! one process per group both have local rank 0, and the old `q_comm_rank == 0`
! guard would come out right by accident. Group A is {world 1, world 2} and the
! root is world 2, whose rank in A is 1 -- so before the fix the root skipped the
! conversion and MPICH aborted with "Invalid datatype", exactly as for a gather to
! root 1 on an intracommunicator. See test/gather_root_f08.f90 and "Root-only
! arguments are converted at the root" in CODE.md.

program gather_inter_f08
  use mpi_f08
  implicit none

  integer :: rank, nranks, ierror, remote_size
  integer :: remote_leader, root
  type(MPI_Comm) :: local_comm, inter
  integer :: sendbuf(2), recvbuf(2)
  integer :: sendcount, recvcount
  type(MPI_Datatype) :: sendtype, recvtype
  logical :: at_root

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, nranks)
  if (nranks /= 3) then
     print *, "this test wants exactly three ranks, not ", nranks
     call MPI_Abort(MPI_COMM_WORLD, 1)
  end if

  ! Groups {0} and {1, 2}, each ordered by world rank since that is the key. The
  ! second is group A, the one containing the root.
  if (rank == 0) then
     call MPI_Comm_split(MPI_COMM_WORLD, 0, rank, local_comm)
     remote_leader = 1
  else
     call MPI_Comm_split(MPI_COMM_WORLD, 1, rank, local_comm)
     remote_leader = 0
  end if
  call MPI_Intercomm_create(local_comm, 0, MPI_COMM_WORLD, remote_leader, 7, inter)
  call MPI_Comm_remote_size(inter, remote_size)

  ! World rank 2, which is rank 1 of group A -- not rank 0 of anything.
  at_root = rank == 2
  if (at_root) then
     root = MPI_ROOT
  else if (rank == 1) then
     root = MPI_PROC_NULL
  else
     root = 1
  end if

  ! The gather: from every process of group B, which is world rank 0 alone, to the
  ! root. Away from the root the receive arguments are not significant.
  sendbuf(1) = 42
  recvbuf = -1
  if (at_root) then
     recvcount = 1
     recvtype = MPI_INTEGER
  else
     recvcount = 0
     recvtype = MPI_DATATYPE_NULL
  end if
  ierror = MPI_SUCCESS - 1
  call MPI_Gather(sendbuf, 1, MPI_INTEGER, recvbuf, recvcount, recvtype, &
                  root, inter, ierror)
  if (ierror /= MPI_SUCCESS) then
     print *, "rank ", rank, ": MPI_Gather returned ", ierror
     call MPI_Abort(MPI_COMM_WORLD, 1)
  end if
  if (at_root) then
     if (remote_size /= 1) then
        print *, "rank ", rank, ": remote_size = ", remote_size, ", expected 1"
        call MPI_Abort(MPI_COMM_WORLD, 1)
     end if
     if (recvbuf(1) /= 42) then
        print *, "rank ", rank, ": recvbuf(1) = ", recvbuf(1), ", expected 42"
        call MPI_Abort(MPI_COMM_WORLD, 1)
     end if
  end if

  ! The scatter, the same way round: `sendtype` is the root-only argument, and the
  ! data goes from the root to group B.
  recvbuf = -1
  if (at_root) then
     sendbuf(1) = 77
     sendcount = 1
     sendtype = MPI_INTEGER
  else
     sendcount = 0
     sendtype = MPI_DATATYPE_NULL
  end if
  ierror = MPI_SUCCESS - 1
  call MPI_Scatter(sendbuf, sendcount, sendtype, recvbuf, 1, MPI_INTEGER, &
                   root, inter, ierror)
  if (ierror /= MPI_SUCCESS) then
     print *, "rank ", rank, ": MPI_Scatter returned ", ierror
     call MPI_Abort(MPI_COMM_WORLD, 1)
  end if
  if (rank == 0) then
     if (recvbuf(1) /= 77) then
        print *, "rank ", rank, ": recvbuf(1) = ", recvbuf(1), ", expected 77"
        call MPI_Abort(MPI_COMM_WORLD, 1)
     end if
  end if

  call MPI_Comm_free(inter)
  call MPI_Comm_free(local_comm)
  call MPI_Finalize()
end program gather_inter_f08
