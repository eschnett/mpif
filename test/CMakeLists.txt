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
add_mpi_test(type_create_struct_f08 SOURCES type_create_struct_f08.f90              LIBS MPI::MPI_Fortran)
