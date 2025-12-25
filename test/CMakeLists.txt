cmake_minimum_required(VERSION 3.12...3.20)
project(
  mpif-tests VERSION 0.1.0
  DESCRIPTION "Tests for MPI Fortran bindings"
  HOMEPAGE_URL "https://github.com/eschnett/mpif"
  LANGUAGES Fortran
  )

include(CheckLanguage)

check_language(Fortran)
if(NOT(CMAKE_Fortran_COMPILER))
  message(FATAL_ERROR "No Fortran support")
endif()
enable_language(Fortran)

find_package(MPI REQUIRED COMPONENTS Fortran)

enable_testing()

add_executable(init_f init_f.f)
target_link_libraries(init_f MPI::MPI_Fortran)
add_test(NAME init_f COMMAND init_f)

add_executable(init_f90 init_f90.f90)
target_link_libraries(init_f90 MPI::MPI_Fortran)
add_test(NAME init_f90 COMMAND init_f90)

add_executable(init_f08 init_f08.f90)
target_link_libraries(init_f08 MPI::MPI_Fortran)
add_test(NAME init_f08 COMMAND init_f08)

add_executable(comm_f comm_f.f)
target_link_libraries(comm_f MPI::MPI_Fortran)
add_test(NAME comm_f COMMAND comm_f)

add_executable(comm_f90 comm_f90.f90)
target_link_libraries(comm_f90 MPI::MPI_Fortran)
add_test(NAME comm_f90 COMMAND comm_f90)

add_executable(comm_f08 comm_f08.f90)
target_link_libraries(comm_f08 MPI::MPI_Fortran)
add_test(NAME comm_f08 COMMAND comm_f08)

add_executable(sendrecv_f90 sendrecv_f90.f90)
target_link_libraries(sendrecv_f90 MPI::MPI_Fortran)
add_test(NAME sendrecv_f90 COMMAND sendrecv_f90)

add_executable(sendrecv_f08 sendrecv_f08.f90)
target_link_libraries(sendrecv_f08 MPI::MPI_Fortran)
add_test(NAME sendrecv_f08 COMMAND sendrecv_f08)

add_executable(inplace_f90 inplace_f90.f90)
target_link_libraries(inplace_f90 MPI::MPI_Fortran)
add_test(NAME inplace_f90 COMMAND inplace_f90)

add_executable(inplace_f08 inplace_f08.f90)
target_link_libraries(inplace_f08 MPI::MPI_Fortran)
add_test(NAME inplace_f08 COMMAND inplace_f08)

add_executable(version_f08 version_f08.f90)
target_link_libraries(version_f08 MPI::MPI_Fortran)
add_test(NAME version_f08 COMMAND version_f08)
