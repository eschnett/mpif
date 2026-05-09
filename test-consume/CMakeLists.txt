cmake_minimum_required(VERSION 3.13...3.28)
project(mpif-consume LANGUAGES Fortran)

find_package(mpif REQUIRED)

enable_testing()
add_executable(consume_f08 consume_f08.f90)
target_link_libraries(consume_f08 PRIVATE mpif::mpifort_abi)
add_test(NAME consume_f08 COMMAND consume_f08)
