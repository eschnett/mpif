! mpif's runtime consistency checks, defined in src/mpif_check.c.
!
! The module exists so `use mpi` and `use mpi_f08` see the same two
! declarations that mpif.h gets from include/mpif_check_fns.h -- both come
! from that one header, so the two cannot drift apart, the arrangement
! src/mpif_attr_fns.F90 established. Unlike the attribute callbacks, mpi_f08
! needs no separate procedures here: the arguments are default INTEGERs and
! there are no handles, so all three bindings share the external symbols
! mpif_check_version_ and mpif_check_environment_.

module mpif_check_fns
  implicit none
  public
  save

  include "mpif_check_fns.h"
end module mpif_check_fns

! The Fortran half of mpif_check_environment's internal version check. The
! MPIF_VERSION/MPIF_SUBVERSION/MPIF_PATCH parameters of
! include/mpif_constants.h are hand-written, and the C side's
! MPIF_VERSION_MAJOR/_MINOR/_PATCH come from CMake's project(mpif VERSION);
! nothing ties the two together at build time except
! ci-scripts/check-headers.sh. This subroutine publishes the Fortran side's
! values so src/mpif_check.c can compare them at run time, the
! src/mpif_logical.F90 arrangement -- Fortran reports what only it knows --
! done with a subroutine rather than a block data.

subroutine mpif_check_header_version(major, minor, patch)
  use mpif_constants, only: MPIF_VERSION, MPIF_SUBVERSION, MPIF_PATCH
  implicit none
  integer, intent(out) :: major, minor, patch
  major = MPIF_VERSION
  minor = MPIF_SUBVERSION
  patch = MPIF_PATCH
end subroutine mpif_check_header_version
