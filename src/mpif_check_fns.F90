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

! The one declaration of mpif_check_sentinel, shared by the reporter below and
! the one in src/mpif_check_f08.F90 rather than written out in each. It is not
! part of any of the three interfaces -- nothing outside mpif calls it, mpi.F90
! does not use this module, and CMakeLists.txt's explicit .mod install list
! leaves it out.
module mpif_check_sentinel_fn
  implicit none
  public
  save

  interface
     subroutine mpif_check_sentinel(index, address, bytes) &
          bind(C, name="mpif_check_sentinel")
       use, intrinsic :: iso_c_binding, only: c_int, c_ptr
       implicit none
       integer(c_int), value :: index
       type(c_ptr), value :: address
       integer(c_int), value :: bytes
     end subroutine mpif_check_sentinel
  end interface
end module mpif_check_sentinel_fn

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

! The Fortran half of mpif_check_environment's sentinel check: hand C the
! address and the size of every sentinel mpif.h declares, so that it can compare
! them against the cells src/mpif_constants.c defines. See the comment on
! mpif_check_sentinel in src/mpif_check.c for what can go wrong and why nothing
! else can see it; src/mpif_check_f08.F90 reports the two that only mpi_f08 has.
!
! c_loc rather than the GNU loc() extension, and one bind(C) entry point for all
! twelve rather than a per-type family: the sentinels carry TARGET, so this is
! ordinary standard Fortran. It is also the only test that MPI-5.0 section 3.6's
! "the implementation of MPI_BUFFER_AUTOMATIC must allow the intrinsic c_loc to
! be applied to it" is satisfied.
!
! The indices are the order of the table in src/mpif_check.c. A sentinel dropped
! from here is caught by that file's count of how many were reported.

subroutine mpif_check_report_sentinels()
  use, intrinsic :: iso_c_binding, only: c_loc, c_int
  use mpif_constants, only: &
       MPI_BOTTOM, MPI_IN_PLACE, MPI_BUFFER_AUTOMATIC, &
       MPI_ARGV_NULL, MPI_ARGVS_NULL, MPI_ERRCODES_IGNORE, &
       MPI_STATUS_IGNORE, MPI_STATUSES_IGNORE, &
       MPI_UNWEIGHTED, MPI_WEIGHTS_EMPTY
  use mpif_check_sentinel_fn, only: mpif_check_sentinel
  implicit none

  call mpif_check_sentinel(1_c_int, c_loc(MPI_BOTTOM), &
       int(size(MPI_BOTTOM) * storage_size(MPI_BOTTOM) / 8, c_int))
  call mpif_check_sentinel(2_c_int, c_loc(MPI_IN_PLACE), &
       int(size(MPI_IN_PLACE) * storage_size(MPI_IN_PLACE) / 8, c_int))
  call mpif_check_sentinel(3_c_int, c_loc(MPI_BUFFER_AUTOMATIC), &
       int(size(MPI_BUFFER_AUTOMATIC) * storage_size(MPI_BUFFER_AUTOMATIC) / 8, c_int))
  call mpif_check_sentinel(4_c_int, c_loc(MPI_ARGV_NULL), &
       int(size(MPI_ARGV_NULL) * storage_size(MPI_ARGV_NULL) / 8, c_int))
  call mpif_check_sentinel(5_c_int, c_loc(MPI_ARGVS_NULL), &
       int(size(MPI_ARGVS_NULL) * storage_size(MPI_ARGVS_NULL) / 8, c_int))
  call mpif_check_sentinel(6_c_int, c_loc(MPI_ERRCODES_IGNORE), &
       int(size(MPI_ERRCODES_IGNORE) * storage_size(MPI_ERRCODES_IGNORE) / 8, c_int))
  call mpif_check_sentinel(7_c_int, c_loc(MPI_STATUS_IGNORE), &
       int(size(MPI_STATUS_IGNORE) * storage_size(MPI_STATUS_IGNORE) / 8, c_int))
  call mpif_check_sentinel(8_c_int, c_loc(MPI_STATUSES_IGNORE), &
       int(size(MPI_STATUSES_IGNORE) * storage_size(MPI_STATUSES_IGNORE) / 8, c_int))
  call mpif_check_sentinel(9_c_int, c_loc(MPI_UNWEIGHTED), &
       int(size(MPI_UNWEIGHTED) * storage_size(MPI_UNWEIGHTED) / 8, c_int))
  call mpif_check_sentinel(10_c_int, c_loc(MPI_WEIGHTS_EMPTY), &
       int(size(MPI_WEIGHTS_EMPTY) * storage_size(MPI_WEIGHTS_EMPTY) / 8, c_int))
end subroutine mpif_check_report_sentinels
