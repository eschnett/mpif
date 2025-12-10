      program comm_f
      implicit none
      include "mpif.h"

      integer size, rank
      integer ierror

      call MPI_Init(ierror)

      call MPI_Comm_size(MPI_COMM_WORLD, size, ierror)
      call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)

      if (size < 1) stop 1
      if (rank < 0 .or. rank >= size) stop 1

      call MPI_Finalize(ierror)

      end
