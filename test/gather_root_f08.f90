! MPI_Gather and MPI_Scatter with a root that is not rank 0.
!
! Every root-only argument used to be converted on rank 0 rather than at the
! root. gen/mpif_functions.c emitted
!
!   q_comm_rank == 0 ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
!
! so a gather to root 1 handed the implementation MPI_DATATYPE_NULL at the one
! process where `recvtype` is significant, and MPICH said so:
!
!   Fatal error in internal_Gather: Invalid datatype, error stack:
!   internal_Gather(9362): MPI_Gather(... recvtype=MPI_DATATYPE_NULL, 1,
!   MPI_COMM_WORLD) failed
!
! MPICH's own Fortran suite never caught it because its collective tests all set
! root = 0, where the wrong guard and the right one agree. Two ranks and root = 1
! is the smallest call that tells them apart. See "Root-only arguments are
! converted at the root" in CODE.md.
!
! One interface is enough here: mpi_f08's MPI_Gather calls the mpi module's, and
! that is the single C entry point mpif.h, mpi and mpi_f08 all reach, so the guard
! under test is the same object code for all three.

program gather_root_f08
  use mpi_f08
  implicit none

  integer, parameter :: root = 1
  integer :: rank, nranks, ierror, i
  integer :: sendbuf(2), recvbuf(2)
  integer :: sendcount, recvcount
  type(MPI_Datatype) :: sendtype, recvtype

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, nranks)
  if (nranks /= 2) then
     print *, "this test wants exactly two ranks, not ", nranks
     call MPI_Abort(MPI_COMM_WORLD, 1)
  end if

  ! The gather. `recvbuf`, `recvcount` and `recvtype` are "significant only at
  ! root, and are ignored for all participants except the root" (MPI-5.0 6.1), so
  ! away from the root they are set to something MPI must not look at.
  sendbuf(1) = 100 + rank
  recvbuf = -1
  if (rank == root) then
     recvcount = 1
     recvtype = MPI_INTEGER
  else
     recvcount = 0
     recvtype = MPI_DATATYPE_NULL
  end if
  ierror = MPI_SUCCESS - 1
  call MPI_Gather(sendbuf, 1, MPI_INTEGER, recvbuf, recvcount, recvtype, &
                  root, MPI_COMM_WORLD, ierror)
  if (ierror /= MPI_SUCCESS) then
     print *, "rank ", rank, ": MPI_Gather returned ", ierror
     call MPI_Abort(MPI_COMM_WORLD, 1)
  end if
  if (rank == root) then
     do i = 1, nranks
        if (recvbuf(i) /= 100 + i - 1) then
           print *, "rank ", rank, ": recvbuf(", i, ") = ", recvbuf(i), &
                    ", expected ", 100 + i - 1
           call MPI_Abort(MPI_COMM_WORLD, 1)
        end if
     end do
  end if

  ! The scatter, whose root-only argument is `sendtype` and which therefore goes
  ! through the same guard from the other side.
  recvbuf = -1
  if (rank == root) then
     do i = 1, nranks
        sendbuf(i) = 200 + i - 1
     end do
     sendcount = 1
     sendtype = MPI_INTEGER
  else
     sendcount = 0
     sendtype = MPI_DATATYPE_NULL
  end if
  ierror = MPI_SUCCESS - 1
  call MPI_Scatter(sendbuf, sendcount, sendtype, recvbuf, 1, MPI_INTEGER, &
                   root, MPI_COMM_WORLD, ierror)
  if (ierror /= MPI_SUCCESS) then
     print *, "rank ", rank, ": MPI_Scatter returned ", ierror
     call MPI_Abort(MPI_COMM_WORLD, 1)
  end if
  if (recvbuf(1) /= 200 + rank) then
     print *, "rank ", rank, ": recvbuf(1) = ", recvbuf(1), &
              ", expected ", 200 + rank
     call MPI_Abort(MPI_COMM_WORLD, 1)
  end if

  call MPI_Finalize()
end program gather_root_f08
