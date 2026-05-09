cmake_minimum_required(VERSION 3.13...3.28)
project(
  mpif VERSION 0.2.0
  DESCRIPTION "MPI Fortran bindings"
  HOMEPAGE_URL "https://github.com/eschnett/mpif"
  LANGUAGES C Fortran
  )

# SOVERSION is the ABI version of mpif. (That's different from the
# MPI_ABI version.)
#
# SOVERSION is handled differently under Linux and macOS. We are using
# a single-digit SOVERSION to avoid confusion between VERSION (which
# consists of 3 numbers) and SOVERSION.
#
# Different SOVERSIONs are incompatible; there is no need to have a
# major/minor version number.
set(SOVERSION 0)

set(CMAKE_C_STANDARD 99)
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/include)
include(GNUInstallDirs)

find_package(MPI REQUIRED COMPONENTS C)

# Check for Fortran features

include(CheckFortranCompilerFlag)
include(CheckFortranSourceCompiles)

check_fortran_source_compiles(
  "
  program test
    logical*16 :: x
  end
  "
  HAVE_LOGICAL16
  SRC_EXT f90
)

check_fortran_source_compiles(
  "
  program test
    real*2 :: x
  end program
  "
  HAVE_REAL2
  SRC_EXT f90
)
check_fortran_source_compiles(
  "
  program test
    real*16 :: x
  end
  "
  HAVE_REAL16
  SRC_EXT f90
)

set(MPIF_Fortran_FLAGS_LIST "")
check_fortran_compiler_flag(-fallow-argument-mismatch Fortran_flag_allow_argument_mismatch)
if(Fortran_flag_allow_argument_mismatch)
  list(APPEND MPIF_Fortran_FLAGS_LIST -fallow-argument-mismatch)
endif()
check_fortran_compiler_flag(-fcray-pointer Fortran_flag_cray_pointer)
if(Fortran_flag_cray_pointer)
  list(APPEND MPIF_Fortran_FLAGS_LIST -fcray-pointer)
endif()
list(JOIN MPIF_Fortran_FLAGS_LIST " " MPIF_Fortran_FLAGS_STR)

check_fortran_source_compiles(
  "
  end
  subroutine sub(buf)
    implicit none
    integer buf(*)
  end
  subroutine caller1(buf)
    implicit none
    integer buf(1)
    interface
       subroutine sub(buf)
         implicit none
         integer buf(*)
         !dir$ ignore_tkr(tkr) buf
       end subroutine sub
    end interface
    call sub(buf)
  end subroutine caller1
  subroutine caller2(buf)
    implicit none
    real buf(1)
    interface
       subroutine sub(buf)
         implicit none
         integer buf(*)
         !dir$ ignore_tkr(tkr) buf
       end subroutine sub
    end interface
    call sub(buf)
  end subroutine caller2
  subroutine caller3(buf)
    implicit none
    real buf
    interface
       subroutine sub(buf)
         implicit none
         integer buf(*)
         !dir$ ignore_tkr(tkr) buf
       end subroutine sub
    end interface
    call sub(buf)
  end subroutine caller3
  "
  HAVE_Fortran_attribute_dir_ignore_tkr
  SRC_EXT f90
)
if(HAVE_Fortran_attribute_dir_ignore_tkr)
  set(DIR_IGNORE_TKR "")
else()
  set(DIR_IGNORE_TKR "!disabled ")
endif()
check_fortran_source_compiles(
  "
  end
  subroutine sub(buf)
    implicit none
    !gcc$ attributes no_arg_check :: buf
    integer buf(*)
  end
  subroutine caller1(buf)
    implicit none
    integer buf(1)
    interface
       subroutine sub(buf)
         implicit none
         integer buf(*)
         !gcc$ attributes no_arg_check :: buf
       end subroutine sub
    end interface
    call sub(buf)
  end subroutine caller1
  subroutine caller2(buf)
    implicit none
    real buf(1)
    interface
       subroutine sub(buf)
         implicit none
         integer buf(*)
         !gcc$ attributes no_arg_check :: buf
       end subroutine sub
    end interface
    call sub(buf)
  end subroutine caller2
  subroutine caller3(buf)
    implicit none
    real buf
    interface
       subroutine sub(buf)
         implicit none
         integer buf(*)
         !gcc$ attributes no_arg_check :: buf
       end subroutine sub
    end interface
    call sub(buf)
  end subroutine caller3
  "
  HAVE_Fortran_attribute_gcc_attributes_no_arg_check
  SRC_EXT f90
)
if(HAVE_Fortran_attribute_gcc_attributes_no_arg_check)
  set(GCC_ATTRIBUTES_NO_ARG_CHECK "")
else()
  set(GCC_ATTRIBUTES_NO_ARG_CHECK "!disabled ")
endif()

add_library(mpifort_abi SHARED
  # MPI Fortran header files
  include/mpif.h
  # MPI Fortran modules
  src/mpi.F90
  src/mpi_constants.F90
  src/mpi_types.F90
  src/mpi_f08.F90
  src/mpi_f08_constants.F90
  src/mpi_f08_types.F90
  # Implementation
  include/mpif_strings.h
  src/mpif_constants.c
  src/mpif_sizeof.c
  src/mpif_strings.c
  gen/mpif_functions.c
  gen/mpi_functions.F90
  gen/mpi_f08_functions.F90
)
target_include_directories(mpifort_abi
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_Fortran_MODULE_DIRECTORY}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
target_compile_definitions(mpifort_abi PRIVATE
  ENABLE_FORTRAN
  $<$<BOOL:${HAVE_LOGICAL16}>:MPIF_HAVE_LOGICAL16>
  $<$<BOOL:${HAVE_REAL2}>:MPIF_HAVE_REAL2>
  $<$<BOOL:${HAVE_REAL16}>:MPIF_HAVE_REAL16>
)
target_compile_options(mpifort_abi PRIVATE
  $<$<COMPILE_LANGUAGE:Fortran>:${MPIF_Fortran_FLAGS_LIST}>
)
if(APPLE)
  # Ensure that there is only one instance of our MPI common blocks
  target_link_options(mpifort_abi INTERFACE "LINKER:-commons,use_dylibs")
endif()
target_link_libraries(mpifort_abi PRIVATE MPI::MPI_C)
list(APPEND public_headers
  include/mpif.h
  include/mpif_constants.h
  include/mpif_functions.h
)
set_target_properties(mpifort_abi PROPERTIES
  VERSION ${PROJECT_VERSION}
  SOVERSION ${SOVERSION}
  PUBLIC_HEADER "${public_headers}"
)

install(TARGETS mpifort_abi EXPORT mpifort_abiTargets
  LIBRARY       DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE       DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME       DESTINATION ${CMAKE_INSTALL_BINDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  INCLUDES      DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(FILES
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_constants.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_f08_constants.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_f08_functions.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_f08_types.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_f08.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_functions.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_types.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi.mod
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# Generate and install package configuration so consumers can use
# find_package(mpif).

include(CMakePackageConfigHelpers)
set(MPIF_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/mpif")

install(EXPORT mpifort_abiTargets
  FILE mpifTargets.cmake
  NAMESPACE mpif::
  DESTINATION ${MPIF_INSTALL_CMAKEDIR}
)

configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/mpifConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/mpifConfig.cmake
  INSTALL_DESTINATION ${MPIF_INSTALL_CMAKEDIR}
)
write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/mpifConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/mpifConfig.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/mpifConfigVersion.cmake
  DESTINATION ${MPIF_INSTALL_CMAKEDIR}
)

# Install compiler wrappers

set(LINK_FLAGS "")
if(APPLE)
  # Ensure that there is only one copy of our common blocks in the final executable
  set(LINK_FLAGS "-Wl,-commons,use_dylibs")
endif()

list(JOIN MPI_C_LINK_FLAGS " " MPI_C_LINK_FLAGS_STR)
list(JOIN MPI_C_LIBRARIES " " MPI_C_LIBRARIES_STR)
configure_file(bin/mpifort.in bin/mpifc @ONLY)
configure_file(bin/mpifort.in bin/mpifort @ONLY)
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/bin/mpifc ${CMAKE_CURRENT_BINARY_DIR}/bin/mpifort
  DESTINATION ${CMAKE_INSTALL_BINDIR}
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)
