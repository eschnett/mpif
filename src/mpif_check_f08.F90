! The mpi_f08 half of mpif_check_environment's sentinel check.
!
! MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE are TYPE(MPI_Status) in mpi_f08 and
! INTEGER arrays in mpif.h and the mpi module, under the same two names, so the
! two sets cannot be reported from one scoping unit. A file of its own rather
! than a second subprogram in src/mpif_check_fns.F90 because that file's
! mpif_check_fns module is used by mpi.F90, which mpif_f08_types uses in turn --
! `use mpif_f08_types` there would be a circular file dependency.
!
! See the comment on mpif_check_sentinel in src/mpif_check.c for what this
! checks, and src/mpif_check_fns.F90 for the other ten. The indices continue that
! file's, and are the order of the table in src/mpif_check.c.

subroutine mpif_check_report_f08_sentinels()
  use, intrinsic :: iso_c_binding, only: c_loc, c_int
  use mpif_f08_types, only: MPI_STATUS_IGNORE, MPI_STATUSES_IGNORE
  use mpif_check_sentinel_fn, only: mpif_check_sentinel
  implicit none

  ! A scalar, so storage_size alone gives its size; the other is an array of one.
  call mpif_check_sentinel(11_c_int, c_loc(MPI_STATUS_IGNORE), &
       int(storage_size(MPI_STATUS_IGNORE) / 8, c_int))
  call mpif_check_sentinel(12_c_int, c_loc(MPI_STATUSES_IGNORE), &
       int(size(MPI_STATUSES_IGNORE) * storage_size(MPI_STATUSES_IGNORE) / 8, c_int))
end subroutine mpif_check_report_f08_sentinels
