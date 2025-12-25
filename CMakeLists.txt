cmake_minimum_required(VERSION 3.13...3.20)
project(
  mpif VERSION 0.1.1
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

include(CheckLanguage)

check_language(C)
if(NOT(CMAKE_C_COMPILER))
  message(FATAL_ERROR "No C support")
endif()
set(CMAKE_C_STANDARD 99)
enable_language(C)

check_language(Fortran)
if(NOT(CMAKE_Fortran_COMPILER))
  message(FATAL_ERROR "No Fortran support")
endif()
enable_language(Fortran)

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/include)
include(GNUInstallDirs)

find_package(MPI REQUIRED COMPONENTS C)

# Check for Fortran features

include(CheckFortranCompilerFlag)
check_fortran_compiler_flag(-fallow-argument-mismatch Fortran_flag_allow_argument_mismatch)
if(Fortran_flag_allow_argument_mismatch)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fallow-argument-mismatch")
endif()
check_fortran_compiler_flag(-fcray-pointer Fortran_flag_cray_pointer)
if(Fortran_flag_cray_pointer)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fcray-pointer")
endif()
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
add_compile_definitions(ENABLE_FORTRAN)

# configure_file(include/mpitrampoline.h.in include/mpitrampoline.h @ONLY)
# configure_file(include/mpitrampolinef.h.in include/mpitrampolinef.h @ONLY)
# configure_file(include/mpif_functions.h.in include/mpif_functions.h @ONLY)
# configure_file(src/mpi_f08_functions.F90.in src/mpi_f08_functions.F90 @ONLY)

add_library(mpif
  # MPI Fortran header files
  include/mpif.h
  # MPI Fortran modules
  src/mpi.F90
  src/mpi_constants.F90
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
target_include_directories(mpif PRIVATE include)
if(APPLE)
  # Ensure that there is only one instance of our MPI common blocks
  target_link_options(mpif INTERFACE "LINKER:-commons,use_dylibs")
endif()
target_link_libraries(mpif PRIVATE MPI::MPI_C)
list(APPEND public_headers
  include/mpif.h
  include/mpif_constants.h
  include/mpif_functions.h
)
set_target_properties(mpif PROPERTIES
  VERSION ${PROJECT_VERSION}
  SOVERSION ${SOVERSION}
  PUBLIC_HEADER "${public_headers}"
)

install(TARGETS mpif EXPORT mpifTargets)

install(FILES
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_f08.mod
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

# # Install pkgconfig files
# 
# configure_file(pkgconfig/MPItrampoline.pc.in pkgconfig/MPItrampoline.pc @ONLY)
# configure_file(pkgconfig/mpi-c.pc.in pkgconfig/mpi-c.pc @ONLY)
# configure_file(pkgconfig/mpi-cxx.pc.in pkgconfig/mpi-cxx.pc @ONLY)
# configure_file(pkgconfig/mpi-fort.pc.in pkgconfig/mpi-fort.pc @ONLY)
# install(
#   FILES
#   ${CMAKE_BINARY_DIR}/pkgconfig/MPItrampoline.pc
#   ${CMAKE_BINARY_DIR}/pkgconfig/mpi-c.pc
#   ${CMAKE_BINARY_DIR}/pkgconfig/mpi-cxx.pc
#   ${CMAKE_BINARY_DIR}/pkgconfig/mpi-fort.pc
#   DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
# )

# Install compiler wrappers

set(LINK_FLAGS "")
if(APPLE)
  # Ensure that there is only one copy of our common blocks in the final executable
  set(LINK_FLAGS "-Wl,-commons,use_dylibs")
endif()

configure_file(bin/mpifort.in bin/mpifc @ONLY)
configure_file(bin/mpifort.in bin/mpifort @ONLY)
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/bin/mpifc ${CMAKE_CURRENT_BINARY_DIR}/bin/mpifort
  DESTINATION ${CMAKE_INSTALL_BINDIR}
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)
