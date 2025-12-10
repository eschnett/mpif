      program init_f
      implicit none

      include "mpif.h"

      logical initialized, finalized
      integer ierror

      call MPI_Initialized(initialized, ierror)
      if (initialized) stop 1
      call MPI_Finalized(finalized, ierror)
      if (finalized) stop 1

      call MPI_Init(ierror)

      call MPI_Initialized(initialized, ierror)
      if (.not.initialized) stop 1
      call MPI_Finalized(finalized, ierror)
      if (finalized) stop 1

      call MPI_Finalize(ierror)

      call MPI_Initialized(initialized, ierror)
      call MPI_Finalized(finalized, ierror)
      if (.not.finalized) stop 1

      end
