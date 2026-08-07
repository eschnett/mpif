      program check_f
      implicit none

      include "mpif.h"

      integer ierror

c     Both checks are callable at any time; before MPI_Init and after
c     MPI_Finalize the environment check does what MPI-5.0 Table 11.1
c     allows and skips the rest. A failure aborts, so reaching the end
c     is the assertion.
      call mpif_check_version(MPIF_VERSION, MPIF_SUBVERSION,
     &     MPIF_PATCH)
      call mpif_check_environment()

      call MPI_Init(ierror)
      call mpif_check_version(MPIF_VERSION, MPIF_SUBVERSION,
     &     MPIF_PATCH)
      call mpif_check_environment()
      call MPI_Finalize(ierror)

      call mpif_check_environment()

      end
