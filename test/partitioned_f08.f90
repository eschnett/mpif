! MPI_Psend_init and MPI_Precv_init take a count, not a plain INTEGER.
!
! Partitioned communication arrived in MPI-4.0, after large counts, so it never
! had a small form to be polymorphic against: MPI-5.0 gives the single Fortran
! binding "INTEGER(KIND=MPI_COUNT_KIND), INTENT(IN) :: count", and A.4 lists no
! `_c` variant of either routine. mpif declared a default INTEGER, which a
! conforming program cannot pass a count to.
!
! `count` below is an INTEGER(KIND=MPI_COUNT_KIND), which is the assertion: with
! a default-INTEGER dummy this does not compile, "Type mismatch in argument
! 'count' ... INTEGER(8) to INTEGER(4)".
!
! The assertion is therefore a compile-time one, and nothing here runs: MPICH's
! ch3 device does not implement partitioned communication at all --
! MPID_Psend_init is an `MPIR_Assert(0)` in src/mpid/ch3/src/mpid_part.c -- so a
! real call aborts inside MPI before mpif's argument handling could be judged
! either way. The calls sit behind a branch that is never taken, which is enough:
! the compiler checks the interface regardless, and that is what was wrong.
! See "MPICH: partitioned communication is not implemented" in MISSING.md, and
! "The ABI header gets the partitioned-communication count wrong, twice" for why
! the count cannot yet be a large one in practice.

program partitioned_f08
  use mpi_f08
  implicit none

  integer, parameter :: partitions = 2, per_partition = 3
  integer(MPI_COUNT_KIND), parameter :: count = per_partition

  integer :: sbuf(partitions * per_partition), rbuf(partitions * per_partition)
  integer :: i
  type(MPI_Request) :: sreq, rreq
  logical :: done, never

  call MPI_Init()

  do i = 1, size(sbuf)
     sbuf(i) = i * 10
  end do
  rbuf = -1

  ! Never executed; compiled for the interface check. `never` is a variable
  ! rather than a literal .false. so that the compiler cannot drop the calls
  ! before checking them.
  never = command_argument_count() < 0
  if (never) then
     ! The count is per partition, and is an INTEGER(KIND=MPI_COUNT_KIND).
     call MPI_Psend_init(sbuf, partitions, count, MPI_INTEGER, 0, 0, &
          MPI_COMM_SELF, MPI_INFO_NULL, sreq)
     call MPI_Precv_init(rbuf, partitions, count, MPI_INTEGER, 0, 0, &
          MPI_COMM_SELF, MPI_INFO_NULL, rreq)

     call MPI_Start(rreq)
     call MPI_Start(sreq)
     do i = 1, partitions
        call MPI_Pready(i - 1, sreq)
     end do
     call MPI_Wait(sreq, MPI_STATUS_IGNORE)
     call MPI_Wait(rreq, MPI_STATUS_IGNORE)
     call MPI_Parrived(rreq, 0, done)
     call MPI_Request_free(sreq)
     call MPI_Request_free(rreq)
     do i = 1, size(rbuf)
        if (rbuf(i) /= sbuf(i)) stop 1
     end do
  end if

  print '("partitioned_f08: all ok")'

  call MPI_Finalize()

end program partitioned_f08
