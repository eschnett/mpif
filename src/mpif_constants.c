#include <mpi.h>
#include <stdint.h>
#include <stdlib.h>

const intptr_t mpif_bottom_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_BOTTOM;
const intptr_t mpif_in_place_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_IN_PLACE;
const intptr_t mpif_buffer_automatic_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_BUFFER_AUTOMATIC;

const intptr_t mpif_argv_null_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_ARGV_NULL;
const intptr_t mpif_argvs_null_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_ARGVS_NULL;
const intptr_t mpif_errcodes_ignore_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_ERRCODES_IGNORE;
const intptr_t mpif_status_ignore_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_STATUS_IGNORE;
const intptr_t mpif_statuses_ignore_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_STATUSES_IGNORE;
// mpi_f08's two status sentinels take their addresses from here rather than
// from the two cells above; see the comment on their declarations in
// src/mpif_f08_types.F90 for the gfortran bug that separates them. The same
// values, so all three interfaces still name one address.
const intptr_t mpif_f08_status_ignore_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_STATUS_IGNORE;
const intptr_t mpif_f08_statuses_ignore_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_STATUSES_IGNORE;
const intptr_t mpif_unweighted_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_UNWEIGHTED;
const intptr_t mpif_weights_empty_ptr_ __attribute__((__aligned__(16))) = (intptr_t)MPI_WEIGHTS_EMPTY;
