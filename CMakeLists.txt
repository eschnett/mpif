cmake_minimum_required(VERSION 3.13...3.28)
project(
  mpif VERSION 1.0.0
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
set(SOVERSION 1)

set(CMAKE_C_STANDARD 11)   # C11 for <stdatomic.h>, used by the callback registry
set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/include)
include(GNUInstallDirs)

# CMake ships no `Platform/Apple-LLVMFlang-Fortran` module (still true as of
# CMake 4.4), so linking a Fortran shared library on macOS falls back to the
# settings for C: `CMAKE_SHARED_LIBRARY_CREATE_Fortran_FLAGS` drives the link
# with `-dynamiclib`, and `CMAKE_SHARED_LIBRARY_SONAME_Fortran_FLAG` inherits
# the C flag `-install_name` (see `CMakeCommonLanguageInclude.cmake`). flang
# accepts neither: it wants `-shared`, and linker options have to go through
# `-Wl,`. Do the same thing CMake's own `Platform/Apple-NAG-Fortran` module
# does, including gluing the SONAME flag directly to the name.
#
# The guard makes this disappear by itself once CMake grows a platform module
# of its own, since that will use the `-Wl,` form.
if(APPLE AND CMAKE_Fortran_COMPILER_ID STREQUAL "LLVMFlang"
    AND NOT CMAKE_SHARED_LIBRARY_SONAME_Fortran_FLAG MATCHES "^-Wl,")
  set(CMAKE_Fortran_OSX_COMPATIBILITY_VERSION_FLAG "-Wl,-compatibility_version -Wl,")
  set(CMAKE_Fortran_OSX_CURRENT_VERSION_FLAG "-Wl,-current_version -Wl,")
  set(CMAKE_SHARED_LIBRARY_CREATE_Fortran_FLAGS "-shared -Wl,-headerpad_max_install_names")
  set(CMAKE_SHARED_MODULE_CREATE_Fortran_FLAGS "-Wl,-bundle")
  set(CMAKE_SHARED_LIBRARY_SONAME_Fortran_FLAG "-Wl,-install_name -Wl,")
  set(CMAKE_Fortran_CREATE_SHARED_LIBRARY
    "<CMAKE_Fortran_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_Fortran_FLAGS> <LINK_FLAGS> -o <TARGET> <SONAME_FLAG><TARGET_INSTALLNAME_DIR><TARGET_SONAME> <OBJECTS> <LINK_LIBRARIES>")
endif()

find_package(MPI REQUIRED COMPONENTS C)

# What mpif takes from the MPI found above -- and what it deliberately does
# not. The library built here works with *any* MPI implementing the standard
# ABI, so nothing implementation-specific may be baked into it: it uses the
# ABI `mpi.h` (identical across implementations) and nothing else. The MPI
# prefix is remembered only as the *default* that the installed wrapper and
# mpif_info link against, overridable at link time (MPIF_MPI_PREFIX in
# bin/mpifort.in) and at run time (the loader's search path).
if(MPI_HOME)
  set(MPIF_MPI_PREFIX "${MPI_HOME}")
else()
  list(GET MPI_C_LIBRARIES 0 _mpif_mpi_first_lib)
  get_filename_component(_mpif_mpi_libdir "${_mpif_mpi_first_lib}" DIRECTORY)
  get_filename_component(MPIF_MPI_PREFIX "${_mpif_mpi_libdir}" DIRECTORY)
endif()
# The ABI library alone, for mpif_info: MPI-5.0 section 20.2.1 requires that
# implementations "not require more than mpi_abi or its versioned variant as
# the sole direct dependency of the application binary", and MPI_C_LIBRARIES
# lists more than that (MPICH adds libpmpi_abi, Open MPI libopen_mpi -- both
# internal, both reached transitively from libmpi_abi).
set(MPIF_MPI_ABI_LIBRARY "")
foreach(_mpif_lib IN LISTS MPI_C_LIBRARIES)
  if(_mpif_lib MATCHES "libmpi_abi")
    set(MPIF_MPI_ABI_LIBRARY "${_mpif_lib}")
    break()
  endif()
endforeach()
if(NOT MPIF_MPI_ABI_LIBRARY)
  message(FATAL_ERROR "MPI_C_LIBRARIES (${MPI_C_LIBRARIES}) names no libmpi_abi;"
    " mpif requires an MPI that implements the standard ABI")
endif()

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
    integer*16 :: x
  end
  "
  HAVE_INTEGER16
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

# The flag is not the feature. Cray pointers are how mpif.h declares its
# sentinels -- `pointer (MPIF_BOTTOM_PTR, MPI_BOTTOM)` and nine more in
# include/mpif_constants.h, each paired with the common block of its own name --
# so every consumer of mpif.h needs them, and mpif does not build without them.
# Only gfortran spells the permission `-fcray-pointer`; flang answers "no" to
# the check above and supports the declaration anyway, and ifx and nvfortran do
# the same. So ask for the feature, with whatever flags that check did produce.
# Without this a compiler having neither fails a hundred lines into mpif.h with
# an error naming a sentinel, which reads as mpif being wrong rather than as the
# extension being absent.
set(saved_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
set(CMAKE_REQUIRED_FLAGS "${MPIF_Fortran_FLAGS_STR}")
check_fortran_source_compiles(
  "
  program test
    integer :: sentinel(1)
    pointer (sentinel_ptr, sentinel)
    common /sentinel_ptr/ sentinel_ptr
    sentinel(1) = 0
  end
  "
  HAVE_Fortran_cray_pointer
  SRC_EXT f90
)
set(CMAKE_REQUIRED_FLAGS "${saved_CMAKE_REQUIRED_FLAGS}")
if(NOT HAVE_Fortran_cray_pointer)
  message(FATAL_ERROR
    "${CMAKE_Fortran_COMPILER_ID} does not accept a Cray pointer declaration"
    " (`pointer (p, x)`) with \"${MPIF_Fortran_FLAGS_STR}\". mpif.h declares"
    " MPI_BOTTOM, MPI_IN_PLACE and eight other sentinels that way; see"
    " include/mpif_constants.h. If this compiler has the extension under some"
    " other flag, that flag belongs in MPIF_Fortran_FLAGS_LIST above.")
endif()

# In the MPI standard ABI, MPI_Aint is intptr_t while MPI_Count and MPI_Offset
# are int64_t, so MPI_ADDRESS_KIND is 4 where MPI_COUNT_KIND is 8 on a 32-bit
# platform and both are 8 on a 64-bit one. mpi_f08 overloads a small-count
# routine with its `_c` companion under the base name, and that is legal only
# where some argument's kind differs between the two -- which for eight routines
# is exactly this question, in one direction or the other. `gen/` is one
# committed file compiled on both, so it asks here rather than at generation
# time; see the guards in dev/mpiapi.jl.
#
# Each probe is the ambiguity itself: a generic over two specifics differing
# only in the kind of one argument, which compiles if and only if the two kinds
# differ. `loc` needs the same flags the library is built with.
set(saved_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
set(CMAKE_REQUIRED_FLAGS "${MPIF_Fortran_FLAGS_STR}")
check_fortran_source_compiles(
  "
  module probe
    implicit none
    integer :: dummy
    integer, parameter :: address_kind = kind(loc(dummy))
    interface generic
       module procedure specific_integer
       module procedure specific_address
    end interface generic
  contains
    subroutine specific_integer(n)
      integer :: n
    end subroutine specific_integer
    subroutine specific_address(n)
      integer(address_kind) :: n
    end subroutine specific_address
  end module probe
  end
  "
  MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND
  SRC_EXT f90
)
check_fortran_source_compiles(
  "
  module probe
    implicit none
    integer :: dummy
    integer, parameter :: address_kind = kind(loc(dummy))
    integer, parameter :: count_kind = selected_int_kind(18)
    interface generic
       module procedure specific_address
       module procedure specific_count
    end interface generic
  contains
    subroutine specific_address(n)
      integer(address_kind) :: n
    end subroutine specific_address
    subroutine specific_count(n)
      integer(count_kind) :: n
    end subroutine specific_count
  end module probe
  end
  "
  MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND
  SRC_EXT f90
)
set(CMAKE_REQUIRED_FLAGS "${saved_CMAKE_REQUIRED_FLAGS}")

# TS 29113 choice buffers
#
# Where the toolchain passes an assumed-rank actual to a bind(C) routine as a
# C descriptor the C compiler can read, mpi_f08 declares its choice buffers
# `TYPE(*), DIMENSION(..)` and routes them through the cdesc entry points, and
# advertises MPI_SUBARRAYS_SUPPORTED and MPI_ASYNC_PROTECTS_NONBLOCKING as
# .TRUE.; everywhere else it keeps the ignore_tkr fallback and .FALSE.. The
# probe is a real two-language program (cmake/cfi-probe/) that compiles,
# links CFI_is_contiguous and, unless cross-compiling, runs and checks the
# descriptors it receives -- never compile acceptance alone, which both
# open-mpi/ompi#11582 and pmodels/mpich#6505 show to be untrustworthy here.
#
# -DMPIF_ENABLE_CFI=OFF forces the fallback on a capable toolchain, which is
# how the fallback branch stays testable.
option(MPIF_ENABLE_CFI
  "Use TS 29113 assumed-rank choice buffers in mpi_f08 where the toolchain supports them" ON)
if(MPIF_ENABLE_CFI)
  # Where the C compiler cannot find ISO_Fortran_binding.h on its own, this
  # finds the Fortran compiler's copy; the probe and the cdesc sources use
  # the same answer.
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/cfi-include-dir.cmake)
  if(CMAKE_CROSSCOMPILING)
    set(_mpif_cfi_probe_run OFF)
  else()
    set(_mpif_cfi_probe_run ON)
  endif()
  try_compile(MPIF_HAVE_CFI
    ${CMAKE_CURRENT_BINARY_DIR}/cfi-probe
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/cfi-probe
    cfi-probe
    CMAKE_FLAGS
      "-DMPIF_PROBE_Fortran_FLAGS=${MPIF_Fortran_FLAGS_STR}"
      "-DMPIF_PROBE_RUN=${_mpif_cfi_probe_run}"
      "-DMPIF_PROBE_CFI_INCLUDE_DIR=${MPIF_CFI_INCLUDE_DIR}"
    OUTPUT_VARIABLE _mpif_cfi_probe_output)
else()
  set(MPIF_HAVE_CFI FALSE)
  set(MPIF_CFI_INCLUDE_DIR "")
endif()
if(MPIF_HAVE_CFI)
  message(STATUS "TS 29113 assumed-rank choice buffers: yes (MPIF_HAVE_CFI)")
else()
  message(STATUS "TS 29113 assumed-rank choice buffers: no (mpi_f08 keeps the ignore_tkr fallback and MPI_SUBARRAYS_SUPPORTED = .false.)")
endif()

# Sanitizers
#
# `-DMPIF_SANITIZE=address` builds mpif with AddressSanitizer, which is what
# makes a memory error in mpif's own code a report with a backtrace instead of
# a corrupted MPI three calls later. mpif's C is where that matters: the
# conversion layer allocates, copies strings and walks handle arrays, and both
# memory defects this project has fixed so far -- the `MPI_Info_get_string`
# overrun and the `array_of_commands` scan -- were there, each pinned down by
# hand with an mmap'ed guard page because no sanitizer build existed.
#
# It is off by default. The instrumented library is a different library --
# slower, and carrying a dependency on the sanitizer runtime -- so it is built
# beside the ordinary one rather than instead of it; see the `MPIF_SANITIZE`
# handling in `scripts/macos-common.sh`, which gives it its own build tree and
# its own prefix.
#
# MemorySanitizer, the one that would answer "was this byte ever written",
# is deliberately not among the options: see `MISSING.md` "MemorySanitizer
# cannot be run against an MPI".
set(MPIF_SANITIZE "" CACHE STRING
  "Sanitizers to build mpif with, semicolon-separated (e.g. address, or address;undefined). Empty builds without.")

set(MPIF_SANITIZE_C_FLAGS "")
set(MPIF_SANITIZE_Fortran_FLAGS "")
set(MPIF_SANITIZE_LIBRARIES "")
set(MPIF_SANITIZE_RUNTIME "")
set(MPIF_SANITIZE_RPATH "")

if(MPIF_SANITIZE)
  include(CheckCSourceCompiles)
  list(JOIN MPIF_SANITIZE "," MPIF_SANITIZE_CSV)
  set(_mpif_san_flags "-fsanitize=${MPIF_SANITIZE_CSV}" -fno-omit-frame-pointer)

  # Both probes link as well as compile, and linking is the half that decides:
  # every compiler here *accepts* `-fsanitize=address` on the command line, and
  # the ones that cannot do it fail at the link with `library 'asan' not found`
  # -- MacPorts' and Homebrew's GCC ship no libsanitizer on macOS. A probe that
  # only compiled would report those as working and produce an "instrumented"
  # build that is nothing of the kind.
  set(_mpif_saved_flags "${CMAKE_REQUIRED_FLAGS}")
  set(_mpif_saved_link "${CMAKE_REQUIRED_LINK_OPTIONS}")
  string(JOIN " " CMAKE_REQUIRED_FLAGS ${_mpif_san_flags})
  set(CMAKE_REQUIRED_LINK_OPTIONS ${_mpif_san_flags})
  check_c_source_compiles("int main(void) { return 0; }" MPIF_SANITIZE_C_WORKS)
  check_fortran_source_compiles("end" MPIF_SANITIZE_Fortran_WORKS SRC_EXT f90)
  set(CMAKE_REQUIRED_FLAGS "${_mpif_saved_flags}")
  set(CMAKE_REQUIRED_LINK_OPTIONS "${_mpif_saved_link}")

  if(NOT MPIF_SANITIZE_C_WORKS)
    message(FATAL_ERROR
      "MPIF_SANITIZE=${MPIF_SANITIZE}, but ${CMAKE_C_COMPILER} cannot build and "
      "link \"-fsanitize=${MPIF_SANITIZE_CSV}\". See "
      "${CMAKE_BINARY_DIR}/CMakeFiles/CMakeConfigureLog.yaml for what it said. "
      "A missing libasan/libubsan is the usual answer -- GCC on macOS ships "
      "none -- and the cure is a toolchain that has one, Clang here.")
  endif()

  set(MPIF_SANITIZE_C_FLAGS ${_mpif_san_flags})

  if(MPIF_SANITIZE_Fortran_WORKS)
    # gfortran: instrument the Fortran too, and let its own driver bring in the
    # runtime when it links the library.
    set(MPIF_SANITIZE_Fortran_FLAGS ${_mpif_san_flags})
  endif()

  # Where the sanitizer runtime actually is, which is needed in two places and
  # for two different reasons.
  #
  # The first is the library's own link, and only under flang, which has no
  # `-fsanitize` at all as of LLVM 22 -- the string appears in its `--help`
  # only inside the description of `-fomit-frame-pointer`. A Fortran source in
  # the target makes flang the link driver, so there the runtime has to be
  # named by hand rather than asked for by flag. On macOS it would otherwise
  # link *silently*: the library is built with `-undefined dynamic_lookup`, so
  # its unresolved `___asan_*` references look like the MPI ones and are left
  # for load time, turning a configure-time diagnostic into a dyld failure.
  #
  # The second is every executable the installed wrapper links, under *both*
  # toolchains, and that one is a hard requirement of ELF rather than a
  # convenience. See MPIF_SANITIZE_LINK_STR below.
  foreach(_mpif_san IN LISTS MPIF_SANITIZE)
    # The runtime is not named after the flag: `-fsanitize=address` is served
    # by asan, `undefined` by ubsan. Anything not in this table is passed
    # through under its own name, which either finds a runtime or produces the
    # diagnostic below.
    set(_mpif_san_rt "${_mpif_san}")
    if(_mpif_san STREQUAL "address")
      set(_mpif_san_rt asan)
    elseif(_mpif_san STREQUAL "undefined")
      set(_mpif_san_rt ubsan)
    elseif(_mpif_san STREQUAL "thread")
      set(_mpif_san_rt tsan)
    elseif(_mpif_san STREQUAL "leak")
      set(_mpif_san_rt lsan)
    endif()
    # Clang's spellings first, then GCC's plain `libasan.so`. Clang on Darwin
    # has one name; on ELF the unsuffixed form is the per-target layout LLVM
    # has used since 18 and the suffixed one is what older resource
    # directories carry. `ubsan_standalone` is Clang's name for what GCC calls
    # `ubsan`, hence both.
    if(APPLE)
      set(_mpif_san_candidates
        "libclang_rt.${_mpif_san_rt}_osx_dynamic.dylib"
        "libclang_rt.${_mpif_san_rt}_standalone_osx_dynamic.dylib")
    else()
      set(_mpif_san_candidates
        "libclang_rt.${_mpif_san_rt}.so"
        "libclang_rt.${_mpif_san_rt}-${CMAKE_SYSTEM_PROCESSOR}.so"
        "libclang_rt.${_mpif_san_rt}_standalone.so"
        "libclang_rt.${_mpif_san_rt}_standalone-${CMAKE_SYSTEM_PROCESSOR}.so"
        "lib${_mpif_san_rt}.so")
    endif()
    unset(_mpif_san_lib)
    foreach(_mpif_cand IN LISTS _mpif_san_candidates)
      # `-print-file-name` echoes its argument back unchanged when it knows
      # nothing about it, so "is it an absolute path that exists" is the test.
      execute_process(
        COMMAND "${CMAKE_C_COMPILER}" "-print-file-name=${_mpif_cand}"
        OUTPUT_VARIABLE _mpif_cand_path
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET)
      if(IS_ABSOLUTE "${_mpif_cand_path}" AND EXISTS "${_mpif_cand_path}")
        set(_mpif_san_lib "${_mpif_cand_path}")
        break()
      endif()
    endforeach()
    if(NOT _mpif_san_lib)
      message(FATAL_ERROR
        "MPIF_SANITIZE lists \"${_mpif_san}\" and ${CMAKE_C_COMPILER} can build "
        "with it, but none of ${_mpif_san_candidates} was found, so its runtime "
        "cannot be named on a link line. Every executable an mpif wrapper links "
        "has to name it -- see MPIF_SANITIZE_LINK_STR in CMakeLists.txt -- so "
        "there is no build to fall back to. Ask "
        "\"${CMAKE_C_COMPILER}\" -print-runtime-dir for where it looked.")
    endif()
    get_filename_component(_mpif_san_dir "${_mpif_san_lib}" DIRECTORY)
    list(APPEND MPIF_SANITIZE_RUNTIME "${_mpif_san_lib}")
    list(APPEND MPIF_SANITIZE_RPATH "${_mpif_san_dir}")
  endforeach()
  list(REMOVE_DUPLICATES MPIF_SANITIZE_RPATH)
  message(STATUS "Sanitizer runtime: ${MPIF_SANITIZE_RUNTIME}")

  if(NOT MPIF_SANITIZE_Fortran_WORKS)
    # Only flang needs this: gfortran's `-fsanitize` already put the runtime on
    # the library's link line.
    set(MPIF_SANITIZE_LIBRARIES ${MPIF_SANITIZE_RUNTIME})
  endif()
endif()
# What the installed wrapper adds to every executable it links: the sanitizer
# runtime by absolute path, and an rpath to its directory. Empty when this is
# not a sanitizer build, and then the wrapper is byte-for-byte what it always
# was.
#
# On ELF this is a requirement, not a nicety. ASan refuses to run when its
# runtime is not first in the process's initial library list -- "ASan runtime
# does not come first in initial library list; you should either link runtime
# to your application or manually preload it with LD_PRELOAD" -- because
# anything loaded ahead of it, libc included, wins the symbol lookup for
# `malloc`, and an ASan whose allocator is not in play tracks nothing. Reaching
# the runtime as a dependency-of-a-dependency through libmpifort_abi is exactly
# that situation: the executable's DT_NEEDED begins with libmpifort_abi and libc
# arrives before libasan. Measured, on both toolchains, as 69 of 69 tests dying
# on that line. macOS has no such rule and worked either way; naming it in both
# is one arrangement to explain instead of two.
#
# It goes in MPIF_FCLIBS, and first, for two reasons that are both about being
# preserved rather than about being correct. First in the list because DT_NEEDED
# follows link order, and first is what ASan is asking for. In the *libraries*
# rather than the compile or link flags because `find_package(MPI)` splits what
# the wrapper reports and keeps only some of it: it puts `-showme:compile` into
# INTERFACE_COMPILE_OPTIONS verbatim, but from `-showme:link` it keeps the
# `-Wl,` forms and drops everything else. A `-fsanitize=address` there
# therefore reaches the compile and not the link, which is worse than not
# having it at all -- the probe object gets `__asan_*` references that nothing
# resolves, and `find_package` fails with
# "undefined reference to symbol '__asan_unregister_globals'" and
# "DSO missing from command line". That was measured too, and is why this
# names a library instead.
#
# `--no-as-needed` leads it on ELF, and is deliberately never restored. The
# executable references no sanitizer symbol of its own -- the instrumented code
# is all inside libmpifort_abi -- so GNU ld's default `--as-needed` drops the
# runtime as a library that contributed nothing, DT_NEEDED and all. Measured:
# with the runtime named but not pinned, `readelf -d` on a test binary listed
# libmpifort_abi first and no libasan anywhere, and all 69 tests still failed on
# the link-order line.
#
# Not restored, because `find_package(MPI)` does not keep this string intact.
# It splits what the wrapper reports into MPI_Fortran_LINK_FLAGS and
# MPI_Fortran_LIB_NAMES, hoists every `-Wl,` form ahead of the object file and
# appends the libraries at the end -- so a matching `-Wl,--as-needed` lands
# next to its opening flag, hundreds of arguments before the library it was
# meant to stop covering, and cancels it. `--push-state`/`--pop-state` would be
# the tidy spelling and it fails the same way. Leaving `--no-as-needed` on
# covers libmpifort_abi and libmpi_abi too, which is harmless -- both are
# genuinely used, and MPI-5.0 section 20.2.1 wants libmpi_abi recorded as a
# direct dependency in any case.
#
# Darwin needs none of it: ld64 records a dylib whether or not it was used, and
# has no link-order rule to satisfy in the first place.
set(MPIF_SANITIZE_LINK_STR "")
if(MPIF_SANITIZE_RUNTIME AND NOT APPLE)
  string(APPEND MPIF_SANITIZE_LINK_STR " -Wl,--no-as-needed")
endif()
foreach(_mpif_san_rt_lib IN LISTS MPIF_SANITIZE_RUNTIME)
  string(APPEND MPIF_SANITIZE_LINK_STR " ${_mpif_san_rt_lib}")
endforeach()
foreach(_mpif_san_rt_dir IN LISTS MPIF_SANITIZE_RPATH)
  string(APPEND MPIF_SANITIZE_LINK_STR " -Wl,-rpath,${_mpif_san_rt_dir}")
endforeach()

add_library(mpifort_abi SHARED
  # MPI Fortran header files
  include/mpif.h
  # MPI Fortran modules
  src/mpi.F90
  src/mpif_constants.F90
  src/mpif_cptr.F90
  src/mpif_handle_types.F90
  src/mpif_types.F90
  src/mpi_f08.F90
  src/mpif_f08_constants.F90
  src/mpif_f08_types.F90
  src/mpif_f08_attr_fns.F90
  # Implementation
  include/mpif_attrs.h
  include/mpif_callbacks.h
  include/mpif_cdesc.h
  include/mpif_logical.h
  include/mpif_strings.h
  src/mpif_attr_fns.F90
  src/mpif_attrs.c
  src/mpif_callbacks.c
  src/mpif_cdesc.c
  src/mpif_check.c
  src/mpif_check_fns.F90
  src/mpif_constants.c
  src/mpif_logical.F90
  src/mpif_logical.c
  src/mpif_removed.c
  src/mpif_sizeof.c
  src/mpif_strings.c
  gen/mpif_functions.c
  gen/mpif_functions.F90
  gen/mpif_f08_cdesc.c
  gen/mpif_f08_functions.F90
  gen/mpif_f08_wrappers.F90
)
target_include_directories(mpifort_abi
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_Fortran_MODULE_DIRECTORY}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
if(MPIF_HAVE_CFI AND MPIF_CFI_INCLUDE_DIR)
  # The Fortran compiler's ISO_Fortran_binding.h, for gen/mpif_f08_cdesc.c
  # and src/mpif_cdesc.c on toolchains whose C compiler does not ship it;
  # see cmake/cfi-include-dir.cmake.
  target_include_directories(mpifort_abi PRIVATE "${MPIF_CFI_INCLUDE_DIR}")
endif()
target_compile_definitions(mpifort_abi PRIVATE
  ENABLE_FORTRAN
  # mpif's own version, for src/mpif_check.c. Not spelled MPIF_VERSION /
  # MPIF_SUBVERSION / MPIF_PATCH: these definitions reach the preprocessed
  # .F90 sources too, and src/mpif_f08_constants.F90 spells those tokens.
  MPIF_VERSION_MAJOR=${PROJECT_VERSION_MAJOR}
  MPIF_VERSION_MINOR=${PROJECT_VERSION_MINOR}
  MPIF_VERSION_PATCH=${PROJECT_VERSION_PATCH}
  $<$<BOOL:${HAVE_LOGICAL16}>:MPIF_HAVE_LOGICAL16>
  $<$<BOOL:${HAVE_INTEGER16}>:MPIF_HAVE_INTEGER16>
  $<$<BOOL:${HAVE_REAL2}>:MPIF_HAVE_REAL2>
  $<$<BOOL:${HAVE_REAL16}>:MPIF_HAVE_REAL16>
  $<$<BOOL:${MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND}>:MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND>
  $<$<BOOL:${MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND}>:MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND>
  $<$<BOOL:${MPIF_HAVE_CFI}>:MPIF_HAVE_CFI>
)
target_compile_options(mpifort_abi PRIVATE
  $<$<COMPILE_LANGUAGE:Fortran>:${MPIF_Fortran_FLAGS_LIST}>
  $<$<COMPILE_LANGUAGE:C>:${MPIF_SANITIZE_C_FLAGS}>
  $<$<COMPILE_LANGUAGE:Fortran>:${MPIF_SANITIZE_Fortran_FLAGS}>
)
# The link, in whichever of the two shapes the Fortran compiler allows: its own
# `-fsanitize` flag where it has one, the runtime library and an rpath to it
# where it has not. Both are PUBLIC, so an executable linking mpifort_abi
# inherits them; the tests and mpif_info do exactly that.
target_link_options(mpifort_abi PUBLIC ${MPIF_SANITIZE_Fortran_FLAGS})
target_link_libraries(mpifort_abi PUBLIC ${MPIF_SANITIZE_LIBRARIES})
if(MPIF_SANITIZE_RPATH)
  set_property(TARGET mpifort_abi APPEND PROPERTY BUILD_RPATH ${MPIF_SANITIZE_RPATH})
  set_property(TARGET mpifort_abi APPEND PROPERTY INSTALL_RPATH ${MPIF_SANITIZE_RPATH})
endif()
if(APPLE)
  # Ensure that there is only one instance of our MPI common blocks
  target_link_options(mpifort_abi INTERFACE "LINKER:-commons,use_dylibs")
endif()
# The library links NO MPI: its MPI_*/PMPI_* references stay undefined and
# resolve at load time from the libmpi_abi that the application links, which
# is the standard's own model -- MPI-5.0 section 20.2.1 makes mpi_abi "the
# sole direct dependency of the application binary". Linking MPI::MPI_C here
# would record the build-time implementation's library set (MPICH's
# libpmpi_abi, Open MPI's libopen_mpi, and their absolute paths on macOS) in
# an artifact that must work with either implementation; a cross-run would
# then load two MPI libraries at once. Only the header's include directory is
# taken, and as a plain path rather than through MPI::MPI_C, whose interface
# compile definitions would leak MPICH's -DMPI_ABI into the compile line --
# inert today, but a per-implementation difference in what is supposed to be
# an implementation-independent build.
target_include_directories(mpifort_abi PRIVATE ${MPI_C_INCLUDE_DIRS})
if(APPLE)
  # ELF shared libraries may have undefined symbols by default; ld64 needs to
  # be told. Symbols marked for dynamic lookup bind flat at load time, from
  # whatever images the executable brought in.
  target_link_options(mpifort_abi PRIVATE "LINKER:-undefined,dynamic_lookup")
endif()
list(APPEND public_headers
  include/mpif.h
  include/mpif_attr_fns.h
  include/mpif_check_fns.h
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
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_attr_fns.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_check_fns.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_constants.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_cptr.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_f08_attr_fns.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_f08_constants.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_f08_functions.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_f08_raw.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_f08_types.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_handle_types.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpi_f08.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_functions.mod
  ${CMAKE_Fortran_MODULE_DIRECTORY}/mpif_types.mod
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

# The wrapper links applications with a generic `-lmpi_abi` from
# $MPIF_MPI_PREFIX/lib rather than the absolute library list FindMPI reports:
# the executable's sole direct MPI dependency is the ABI library's
# conventional versioned name, the same for every implementation, so the
# loader's search path can substitute another MPI at run time. On ELF the
# baked default must be DT_RUNPATH, which LD_LIBRARY_PATH precedes -- DT_RPATH
# would shadow the override.
if(APPLE)
  set(MPIF_LINKER_DTAGS_FLAG "")
else()
  set(MPIF_LINKER_DTAGS_FLAG "-Wl,--enable-new-dtags")
endif()
configure_file(bin/mpifort.in bin/mpifc @ONLY)
configure_file(bin/mpifort.in bin/mpifort @ONLY)
install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/bin/mpifc ${CMAKE_CURRENT_BINARY_DIR}/bin/mpifort
  DESTINATION ${CMAKE_INSTALL_BINDIR}
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)

# mpif_info, the diagnostic that prints what a launched setup actually loaded
# and runs mpif_check_environment. Not part of the mpifort_abiTargets export
# set: it is a program, not something to link against.
#
# It is linked like an ordinary application on purpose: mpifort_abi, the ABI
# library (only -- not MPI_C_LIBRARIES, whose extra entries would make the
# build implementation a direct dependency), and the default rpath. It finds
# its MPI exactly the way user binaries do, so what it reports is what an
# application will experience -- a dlopen design was considered and rejected
# because a probe that selects its MPI through a private mechanism does not
# test the mechanism applications use. src/mpif_info_dladdr.c reports which
# libmpi_abi file the loader actually resolved, and its direct MPI_Init
# reference is also what obliges the executable to link -lmpi_abi.

add_executable(mpif_info src/mpif_info.f90 src/mpif_info_dladdr.c)
target_compile_options(mpif_info PRIVATE
  $<$<COMPILE_LANGUAGE:Fortran>:${MPIF_Fortran_FLAGS_LIST}>
  $<$<COMPILE_LANGUAGE:C>:${MPIF_SANITIZE_C_FLAGS}>
  $<$<COMPILE_LANGUAGE:Fortran>:${MPIF_SANITIZE_Fortran_FLAGS}>
)
target_include_directories(mpif_info PRIVATE ${MPI_C_INCLUDE_DIRS})
# The sanitizer runtime leads the list for the same reason the wrapper puts it
# first, and needs saying separately because this is the one executable the
# wrapper does not link: CMake emits a target's own libraries in the order
# given, so without this libmpifort_abi comes first and the runtime arrives
# behind it -- measured as mpif_info and mpif_info_singleton failing on the
# link-order line under flang while the other 67 tests passed. Under gfortran
# it happened to work already, mpifort_abi's PUBLIC `-fsanitize=address` link
# option reaching this target and letting the driver order the runtime itself.
# Empty lists expand to nothing, so an ordinary build gets what it always got.
if(MPIF_SANITIZE_RUNTIME AND NOT APPLE)
  target_link_options(mpif_info PRIVATE "LINKER:--no-as-needed")
endif()
target_link_libraries(mpif_info PRIVATE
  ${MPIF_SANITIZE_RUNTIME} mpifort_abi ${MPIF_MPI_ABI_LIBRARY} ${CMAKE_DL_LIBS})
if(NOT APPLE)
  # The default MPI below must be DT_RUNPATH, not DT_RPATH, so that
  # LD_LIBRARY_PATH can put another implementation in front of it.
  target_link_options(mpif_info PRIVATE "LINKER:--enable-new-dtags")
endif()
# The installed binary must find libmpifort_abi -- whose install name is
# @rpath/libmpifort_abi.1.dylib -- and the *default* MPI: on Linux the
# executable records the ABI library's bare SONAME, on macOS its absolute
# install name, and either way the loader's search path can override the
# default at run time. Nothing else in this project needs an RPATH: the
# library's consumers get theirs from bin/mpifort.in, which bakes in the same
# default. Without this, `cmake --install` strips the build RPATH and installs
# nothing in its place, and bin/mpif_info dies at load.
set(MPIF_INFO_RPATH
  "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}"
  "${MPIF_MPI_PREFIX}/lib"
  # In a sanitizer build the runtime is a dependency of libmpifort_abi, which
  # carries its own rpath to it -- but BUILD_WITH_INSTALL_RPATH below replaces
  # this binary's entire rpath with this list, so the directory has to be named
  # again rather than inherited from the link.
  ${MPIF_SANITIZE_RPATH}
)
# Linked with the install RPATH from the start: rewriting it at install time
# is what CMake does by default, and on macOS install_name_tool cannot grow
# the load commands when the install paths are longer than the build ones
# ("larger updated load commands do not fit"). The binary is only ever run
# installed, so the build-tree copy pointing at the install prefix costs
# nothing.
set_target_properties(mpif_info PROPERTIES
  INSTALL_RPATH "${MPIF_INFO_RPATH}"
  BUILD_WITH_INSTALL_RPATH TRUE
)
install(TARGETS mpif_info RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
