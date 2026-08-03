cmake_minimum_required(VERSION 3.13...3.28)
project(
  mpif-tests VERSION 0.1.0
  DESCRIPTION "Tests for MPI Fortran bindings"
  HOMEPAGE_URL "https://github.com/eschnett/mpif"
  LANGUAGES C Fortran
  )

find_package(MPI REQUIRED COMPONENTS C Fortran)

enable_testing()

function(add_mpi_test name)
  cmake_parse_arguments(T "" "" "SOURCES;LIBS" ${ARGN})
  add_executable(${name} ${T_SOURCES})
  target_link_libraries(${name} PRIVATE ${T_LIBS})
  add_test(NAME ${name} COMMAND ${name})
endfunction()

add_mpi_test(init_f                 SOURCES init_f.f                                LIBS MPI::MPI_Fortran)
add_mpi_test(init_f90               SOURCES init_f90.f90                            LIBS MPI::MPI_Fortran)
add_mpi_test(init_f08               SOURCES init_f08.f90                            LIBS MPI::MPI_Fortran)
add_mpi_test(comm_f                 SOURCES comm_f.f                                LIBS MPI::MPI_Fortran)
add_mpi_test(comm_f90               SOURCES comm_f90.f90                            LIBS MPI::MPI_Fortran)
add_mpi_test(comm_f08               SOURCES comm_f08.f90                            LIBS MPI::MPI_Fortran)
add_mpi_test(sendrecv_f90           SOURCES sendrecv_f90.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(sendrecv_f08           SOURCES sendrecv_f08.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(inplace_f90            SOURCES inplace_f90.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(inplace_f08            SOURCES inplace_f08.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(version_c              SOURCES version_c.c                             LIBS MPI::MPI_C)
add_mpi_test(version_f08            SOURCES version_f08.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(interlanguage          SOURCES interlanguage.c interlanguage_subf90.f90 LIBS MPI::MPI_Fortran MPI::MPI_C)
add_mpi_test(c2f                    SOURCES c2f.c c2f_subf90.f90                    LIBS MPI::MPI_Fortran MPI::MPI_C)
add_mpi_test(type_create_struct_c   SOURCES type_create_struct_c.c                  LIBS MPI::MPI_C)
add_mpi_test(predefined_types_c     SOURCES predefined_types_c.c                    LIBS MPI::MPI_C)
add_mpi_test(type_create_struct_f08 SOURCES type_create_struct_f08.f90              LIBS MPI::MPI_Fortran)
add_mpi_test(info_get_string_f08    SOURCES info_get_string_f08.f90                 LIBS MPI::MPI_Fortran)
add_mpi_test(info_blanks_f08        SOURCES info_blanks_f08.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(argv_null_f08          SOURCES argv_null_f08.f90                       LIBS MPI::MPI_Fortran)
add_mpi_test(comm_get_attr_f08      SOURCES comm_get_attr_f08.f90                   LIBS MPI::MPI_Fortran)
add_mpi_test(grequest_f08           SOURCES grequest_f08.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(sizeof_f90             SOURCES sizeof_f90.f90                          LIBS MPI::MPI_Fortran)
add_mpi_test(rma_disp_f08           SOURCES rma_disp_f08.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(alloc_mem_cptr        SOURCES alloc_mem_cptr.f90                      LIBS MPI::MPI_Fortran)
add_mpi_test(large_count_f08        SOURCES large_count_f08.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(attr_fns_f90           SOURCES attr_fns_f90.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(attr_fns_f08           SOURCES attr_fns_f08.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(partitioned_f08        SOURCES partitioned_f08.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(datarep_f08            SOURCES datarep_f08.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(datarep_c              SOURCES datarep_c.c datarep_subf90.f90          LIBS MPI::MPI_Fortran MPI::MPI_C)
add_mpi_test(callback_intents_f08   SOURCES callback_intents_f08.f90                LIBS MPI::MPI_Fortran)
add_mpi_test(cancel_intent_f08      SOURCES cancel_intent_f08.f90                   LIBS MPI::MPI_Fortran)
add_mpi_test(status_error_f08       SOURCES status_error_f08.f90                    LIBS MPI::MPI_Fortran)
# This one has to be optimised to assert what it is for. It sets
# status%MPI_ERROR before each call and requires the value to survive, and the
# way that breaks is a caller-side dead store: an INTENT(OUT) status in the
# binding tells the compiler the incoming value cannot be read, so the store is
# deleted -- at -O2, and not at the -O0 the rest of these tests are built with.
# MPICH's mprobef08 caught it only because its suite compiles with -O2.
target_compile_options(status_error_f08 PRIVATE $<$<COMPILE_LANGUAGE:Fortran>:-O2>)
add_mpi_test(sentinel_alignment_c   SOURCES sentinel_alignment_c.c                  LIBS MPI::MPI_Fortran MPI::MPI_C)
add_mpi_test(buffer_detach          SOURCES buffer_detach.f90                       LIBS MPI::MPI_Fortran)
add_mpi_test(waitall_f90            SOURCES waitall_f90.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(waitall_f08            SOURCES waitall_f08.f90                         LIBS MPI::MPI_Fortran)
