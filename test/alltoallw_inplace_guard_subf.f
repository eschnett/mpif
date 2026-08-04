C     The mpif.h probe for alltoallw_inplace_guard.c. `sendtypes` is the address
C     of a single MPI_Fint whose successor is on an unreadable page, so any
C     conversion past the first element faults.

      subroutine alltoallw_inplace_probe_f(sendtypes)
      implicit none
      include "mpif.h"

      integer sendtypes(*)

      integer max_size
      parameter (max_size=8)
      integer ierror, rank, size, intsize, i, expected
      integer rcounts(max_size), rdispls(max_size), rtypes(max_size)
      integer rbuf(max_size)
      integer scounts(1), sdispls(1)

      call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)
      call MPI_Comm_size(MPI_COMM_WORLD, size, ierror)
      if (size .gt. max_size) call MPI_Abort(MPI_COMM_WORLD, 1, ierror)
      call MPI_Type_size(MPI_INTEGER, intsize, ierror)

      scounts(1) = -1
      sdispls(1) = -1

      do i = 1, size
         rcounts(i) = 1
         rdispls(i) = (i - 1) * intsize
         rtypes(i) = MPI_INTEGER
C        Block i is what I send to rank i-1.
         rbuf(i) = rank * size + (i - 1)
      enddo

      call MPI_Alltoallw(MPI_IN_PLACE, scounts, sdispls, sendtypes,
     .                   rbuf, rcounts, rdispls, rtypes,
     .                   MPI_COMM_WORLD, ierror)
      if (ierror .ne. MPI_SUCCESS)
     .     call MPI_Abort(MPI_COMM_WORLD, 1, ierror)

C     Block i is now what rank i-1 sent me.
      do i = 1, size
         expected = (i - 1) * size + rank
         if (rbuf(i) .ne. expected) then
            print *, 'mpif.h: rank ', rank, ': rbuf(', i, ') = ',
     .           rbuf(i), ', expected ', expected
            call MPI_Abort(MPI_COMM_WORLD, 1, ierror)
         endif
      enddo

      end
