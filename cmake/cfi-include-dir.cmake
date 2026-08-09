# Where the C compiler can read the Fortran compiler's descriptors from.
#
# The cdesc entry points and the TS 29113 probe include
# <ISO_Fortran_binding.h>, whose owner is the *Fortran* compiler. Usually the
# C compiler finds it unaided -- gcc ships it in its own internal include
# directory, and MacPorts and apt install flang's copy into clang's resource
# directory -- but not always: Homebrew's clang and flang are separate kegs,
# and FreeBSD compiles C with clang and Fortran with gfortran. Both misses
# surfaced the same way, the MPIF_HAVE_CFI probe silently taking the
# fallback, which CI's suite gate then reported as the three scheme-1B tests
# failing on the macos/llvm rows.
#
# The Fortran compiler's copy is found and *copied alone* into a directory of
# its own, because pointing -I at where it lives is not safe: gfortran's copy
# sits in gcc's internal include directory beside gcc's own stddef.h, whose
# __float128 lines clang rejects. In the copy's directory the header's own
# `#include <stddef.h>` resolves to the C compiler's headers, as it should.
#
# Sets MPIF_CFI_INCLUDE_DIR: the directory to add with -I, or "" where the C
# compiler needs no help or no copy was found (then the probe fails and the
# fallback is taken, honestly). A wrong answer here cannot produce a wrong
# build, because the probe compiles, links and runs against this very
# directory.
include(CheckIncludeFile)
check_include_file(ISO_Fortran_binding.h MPIF_CFI_HEADER_IN_C_PATH)
if(MPIF_CFI_HEADER_IN_C_PATH)
  set(MPIF_CFI_INCLUDE_DIR "")
else()
  # Two hints, each read off the compiler itself rather than its path --
  # MacPorts' flang-mp-* is a wrapper script, so following symlinks is not
  # enough:
  # - flang prints "InstalledDir: <bindir>" in --version, and LLVM installs
  #   the header at <bindir>/../include/flang (Homebrew's keg, apt's
  #   /usr/lib/llvm-*, MacPorts' libexec/llvm-*).
  # - gfortran's -print-file-name=include is gcc's internal include
  #   directory, which holds its copy.
  execute_process(
    COMMAND "${CMAKE_Fortran_COMPILER}" --version
    RESULT_VARIABLE _mpif_cfi_version_result
    OUTPUT_VARIABLE _mpif_cfi_version
    ERROR_QUIET)
  set(_mpif_cfi_hints "")
  if(_mpif_cfi_version_result EQUAL 0 AND
     _mpif_cfi_version MATCHES "InstalledDir: ([^\n]*)")
    list(APPEND _mpif_cfi_hints "${CMAKE_MATCH_1}/../include/flang")
  endif()
  execute_process(
    COMMAND "${CMAKE_Fortran_COMPILER}" -print-file-name=include
    RESULT_VARIABLE _mpif_cfi_print_result
    OUTPUT_VARIABLE _mpif_cfi_print_include
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET)
  if(_mpif_cfi_print_result EQUAL 0 AND IS_ABSOLUTE "${_mpif_cfi_print_include}")
    list(APPEND _mpif_cfi_hints "${_mpif_cfi_print_include}")
  endif()
  find_file(MPIF_CFI_HEADER ISO_Fortran_binding.h
    HINTS ${_mpif_cfi_hints}
    NO_DEFAULT_PATH)
  if(MPIF_CFI_HEADER)
    set(MPIF_CFI_INCLUDE_DIR "${CMAKE_CURRENT_BINARY_DIR}/mpif-cfi-include")
    configure_file("${MPIF_CFI_HEADER}"
      "${MPIF_CFI_INCLUDE_DIR}/ISO_Fortran_binding.h" COPYONLY)
  else()
    set(MPIF_CFI_INCLUDE_DIR "")
  endif()
endif()
