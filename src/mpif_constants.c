#include <mpi.h>
#include <stdint.h>
#include <stdlib.h>

const intptr_t _mpi_bottom_ptr = (intptr_t)MPI_BOTTOM;
const intptr_t _mpi_in_place_ptr = (intptr_t)MPI_IN_PLACE;
const intptr_t _mpi_buffer_automatic_ptr = (intptr_t)MPI_BUFFER_AUTOMATIC;

const intptr_t mpi_argv_null_ptr = (intptr_t)MPI_ARGV_NULL;
const intptr_t mpi_argvs_null_ptr = (intptr_t)MPI_ARGVS_NULL;
const intptr_t mpi_errcodes_ignore_ptr = (intptr_t)MPI_ERRCODES_IGNORE;
const intptr_t mpi_status_ignore_ptr = (intptr_t)MPI_STATUS_IGNORE;
const intptr_t mpi_statuses_ignore_ptr = (intptr_t)MPI_STATUSES_IGNORE;
const intptr_t mpi_unweighted_ptr = 10;    //(intptr_t)MPI_UNWEIGHTED;
const intptr_t mpi_weights_empty_ptr = 11; //(intptr_t)MPI_WEIGHTS_EMPTY;
