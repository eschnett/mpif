C     The mpif.h form of alltoallw_inplace_f08, and the shape MPICH's own
C     vw_inplacef and nonblocking_inpf have. Checks that the operation works;
C     test/alltoallw_inplace_guard.c is what catches the over-read.

      program alltoallw_inplace_f
      implicit none
      include "mpif.h"

      integer max_size
      parameter (max_size=8)
      integer ierror, rank, size, intsize, i, expected
      integer rcounts(max_size), rdispls(max_size), rtypes(max_size)
      integer rbuf(max_size)
      integer scounts(1), sdispls(1), stypes(1)

      call MPI_Init(ierror)
      call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)
      call MPI_Comm_size(MPI_COMM_WORLD, size, ierror)
      if (size .gt. max_size) call MPI_Abort(MPI_COMM_WORLD, 1, ierror)
      call MPI_Type_size(MPI_INTEGER, intsize, ierror)

      scounts(1) = -1
      sdispls(1) = -1
      stypes(1) = MPI_DATATYPE_NULL

      do i = 1, size
         rcounts(i) = 1
         rdispls(i) = (i - 1) * intsize
         rtypes(i) = MPI_INTEGER
         rbuf(i) = rank * size + (i - 1)
      enddo

      call MPI_Alltoallw(MPI_IN_PLACE, scounts, sdispls, stypes,
     .                   rbuf, rcounts, rdispls, rtypes,
     .                   MPI_COMM_WORLD, ierror)
      if (ierror .ne. MPI_SUCCESS)
     .     call MPI_Abort(MPI_COMM_WORLD, 1, ierror)

      do i = 1, size
         expected = (i - 1) * size + rank
         if (rbuf(i) .ne. expected) then
            print *, 'rank ', rank, ': rbuf(', i, ') = ', rbuf(i),
     .           ', expected ', expected
            call MPI_Abort(MPI_COMM_WORLD, 1, ierror)
         endif
      enddo

      call MPI_Finalize(ierror)

      end
