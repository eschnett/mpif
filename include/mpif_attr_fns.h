!     Fortran's predefined attribute copy and delete callbacks, and the null
!     datarep conversion functions. Defined as external subprograms in
!     src/mpif_attr_fns.F90.
!
!     Included both by mpif_functions.h, which serves mpif.h, and by the
!     mpif_attr_fns module in src/mpif_attr_fns.F90, which is how the same names
!     reach the mpi module. The mpi_f08 module needs its own procedures rather
!     than these, its handles being derived types rather than INTEGERs.
!
!     Written to be valid in fixed and free form alike, as everything included
!     by mpif.h has to be.

      external :: MPI_NULL_COPY_FN
      external :: MPI_DUP_FN
      external :: MPI_NULL_DELETE_FN
      external :: MPI_COMM_NULL_COPY_FN
      external :: MPI_COMM_DUP_FN
      external :: MPI_COMM_NULL_DELETE_FN
      external :: MPI_TYPE_NULL_COPY_FN
      external :: MPI_TYPE_DUP_FN
      external :: MPI_TYPE_NULL_DELETE_FN
      external :: MPI_WIN_NULL_COPY_FN
      external :: MPI_WIN_DUP_FN
      external :: MPI_WIN_NULL_DELETE_FN
      external :: MPI_CONVERSION_FN_NULL
      external :: MPI_CONVERSION_FN_NULL_C
