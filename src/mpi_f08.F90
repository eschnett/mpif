module mpi_f08
  use mpif_f08_types
  use mpif_f08_constants
  use mpif_f08_functions

  ! mpif's own runtime consistency checks. The same external subroutines serve
  ! all three bindings -- their arguments are default INTEGERs with no handles
  ! among them, so mpi_f08 needs no separate procedures; see
  ! src/mpif_check_fns.F90.
  use mpif_check_fns

  ! The predefined attribute callbacks, under the names MPI-5.0 gives them in
  ! Appendix A.4. They are renamed here rather than declared under these names in
  ! src/mpif_f08_attr_fns.F90, because that would make their global symbols
  ! `mpi_comm_null_copy_fn_` and so on -- which src/mpif_attr_fns.F90 already
  ! defines, with the INTEGER handles that mpif.h and the mpi module take.
  !
  ! mpi_f08 has no MPI_NULL_COPY_FN, MPI_DUP_FN or MPI_NULL_DELETE_FN: those are
  ! the MPI-1 forms, and Appendix A.4 does not list them.
  use mpif_f08_attr_fns, only: &
       MPI_COMM_NULL_COPY_FN => mpif_f08_comm_null_copy_fn, &
       MPI_COMM_DUP_FN => mpif_f08_comm_dup_fn, &
       MPI_COMM_NULL_DELETE_FN => mpif_f08_comm_null_delete_fn, &
       MPI_TYPE_NULL_COPY_FN => mpif_f08_type_null_copy_fn, &
       MPI_TYPE_DUP_FN => mpif_f08_type_dup_fn, &
       MPI_TYPE_NULL_DELETE_FN => mpif_f08_type_null_delete_fn, &
       MPI_WIN_NULL_COPY_FN => mpif_f08_win_null_copy_fn, &
       MPI_WIN_DUP_FN => mpif_f08_win_dup_fn, &
       MPI_WIN_NULL_DELETE_FN => mpif_f08_win_null_delete_fn, &
       MPI_CONVERSION_FN_NULL => mpif_f08_conversion_fn_null, &
       MPI_CONVERSION_FN_NULL_C => mpif_f08_conversion_fn_null_c

  implicit none
  public
  save
end module mpi_f08
