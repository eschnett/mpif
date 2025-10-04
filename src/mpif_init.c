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

extern MPI_Info mpif_abi_info;
extern MPI_Info mpif_fortran_info;

// #ifdef __APPLE__
#define CONSTRUCTOR_PRIORITY
// #else
// #define CONSTRUCTOR_PRIORITY (1000)
// #endif
__attribute__((__constructor__ CONSTRUCTOR_PRIORITY)) void mpif_init(void) {
  if (mpif_abi_info != MPI_INFO_NULL)
    abort();
  MPI_Info_create(&mpif_abi_info);
  MPI_Info_set(mpif_abi_info, "mpi_aint_size", "4");
  MPI_Info_set(mpif_abi_info, "mpi_count_size", "4");
  MPI_Info_set(mpif_abi_info, "mpi_offset_size", "4");

  if (mpif_fortran_info != MPI_INFO_NULL)
    abort();
  MPI_Info_create(&mpif_fortran_info);
  MPI_Info_set(mpif_fortran_info, "mpi_logical_size", "4");
  MPI_Info_set(mpif_fortran_info, "mpi_integer_size", "4");
  MPI_Info_set(mpif_fortran_info, "mpi_real_size", "4");
  MPI_Info_set(mpif_fortran_info, "mpi_double_precision_size", "8");
  MPI_Info_set(mpif_fortran_info, "mpi_logical1_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_logical2_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_logical4_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_logical8_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_logical16_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer1_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer2_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer4_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer8_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_integer16_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_real2_supported", "false");
  MPI_Info_set(mpif_fortran_info, "mpi_real4_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_real8_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_real16_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_complex4_supported", "false");
  MPI_Info_set(mpif_fortran_info, "mpi_complex8_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_complex16_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_complex32_supported", "true");
  MPI_Info_set(mpif_fortran_info, "mpi_double_complex_supported", "true");
}
