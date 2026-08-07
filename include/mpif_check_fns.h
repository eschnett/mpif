!     mpif's runtime consistency checks, mpif_check_version and
!     mpif_check_environment. Defined in src/mpif_check.c; see the comment
!     there for what they check and when each may be called. When MPI is
!     initialized and not finalized, mpif_check_environment is collective
!     over MPI_COMM_WORLD.
!
!     Included both by mpif_functions.h, which serves mpif.h, and by the
!     mpif_check_fns module in src/mpif_check_fns.F90, which is how the same
!     names reach the mpi module and, through it, mpi_f08.
!
!     Written to be valid in fixed and free form alike, as everything included
!     by mpif.h has to be.

      interface

      subroutine mpif_check_version(major, minor, patch)
      implicit none
      integer, intent(in) :: major, minor, patch
      end subroutine mpif_check_version

      subroutine mpif_check_environment()
      implicit none
      end subroutine mpif_check_environment

      end interface
