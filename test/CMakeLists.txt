cmake_minimum_required(VERSION 3.13...3.28)
project(
  mpif-tests VERSION 0.1.0
  DESCRIPTION "Tests for MPI Fortran bindings"
  HOMEPAGE_URL "https://github.com/eschnett/mpif"
  LANGUAGES C Fortran
  )

find_package(MPI REQUIRED COMPONENTS C Fortran)

# Keep the Fortran wrapper's flags off the C compiler. FindMPI reads
# `mpifort -showme:compile` and puts what it prints into MPI::MPI_Fortran's
# INTERFACE_COMPILE_OPTIONS *unguarded*, and CMake applies a target's interface
# compile options to every language in the target that consumes it. mpif's
# wrapper reports gfortran's `-fallow-argument-mismatch`, which mpif.h genuinely
# needs, so the three targets below that mix C and Fortran (`interlanguage`,
# `c2f`, `datarep_c`) hand it to the C compiler as well. It used to report
# `-fcray-pointer` too, for sentinels that were Cray pointees; one flag or two,
# the problem and the fix are the same.
#
# That went unnoticed on every variant until FreeBSD, because it depends on the
# two compilers coming from different projects: gcc's C frontend only warns
# ("command-line option '-fallow-argument-mismatch' is valid for Fortran but not
# for C"), flang rejects the flag so the check in the parent project never adds
# it, and clang errors outright. FreeBSD compiles C with clang and Fortran with
# gfortran, and got `cc: error: unknown argument:
# '-fallow-argument-mismatch'`. Verified on this machine too: the flag was in
# `C_FLAGS` in a gcc build's flags.make all along.
get_target_property(mpif_test_fortran_options MPI::MPI_Fortran INTERFACE_COMPILE_OPTIONS)
if(mpif_test_fortran_options)
  set_property(TARGET MPI::MPI_Fortran PROPERTY INTERFACE_COMPILE_OPTIONS
    "$<$<COMPILE_LANGUAGE:Fortran>:${mpif_test_fortran_options}>")
endif()

# What the library-identity tests expect MPI_Get_library_version to answer:
# mpif_check_environment compares this case-insensitively as a substring. The
# default "mpi" matches both "MPICH ..." and "Open MPI ...", so the tests pass
# under either implementation; CI passes "MPICH" or "Open MPI" for the
# *runtime* MPI, and in a cross-configuration -- binaries linked against one
# implementation, executed against the other via the loader's search path --
# that is what proves the swap actually happened.
set(MPIF_TEST_MPI_LIBRARY "mpi" CACHE STRING
  "Substring that MPI_Get_library_version must contain, asserted by the env-check and mpif_info tests")

enable_testing()

# Build every test, register none of them. This is for the compile-only CI
# stage (ci-scripts/compile-only.sh), whose MPI is the ABI stub library: it has
# no mpiexec, and nothing linked against it can run anyway. Compiling these
# programs is still most of what that stage is for -- they are where a
# compiler meets `use mpi`, `use mpi_f08` and `include 'mpif.h'` as an
# application does, rather than as the library that defines them.
#
# It guards registration, not target creation, so a build-only configuration
# builds exactly the same binaries from exactly the same sources.
option(MPIF_TEST_BUILD_ONLY
  "Build the tests but register none with CTest; for an MPI that cannot run" OFF)

# Most of these tests are single-rank and run the executable directly. NPROCS
# asks for more, which needs mpiexec.
#
# It needs the *variant's* mpiexec, not whichever one find_package(MPI) happens to
# turn up: it found an unrelated miniforge install here, which would have run the
# tests against an MPI that mpif was not built against and reported whatever came
# of that. So every caller pins MPIEXEC_EXECUTABLE -- scripts/macos-test-mpif.sh,
# .github/workflows/ci.yaml and every docker/*.dockerfile -- and a caller that
# forgets fails here rather than at run time. MPIEXEC_PREFLAGS is how the
# launcher's own requirements get in, `--allow-run-as-root` in the containers and
# `--oversubscribe --mca btl_tcp_if_include lo` for Open MPI; the suite passes the
# same things through MPIEXEC_ARGS.
# A target whose `main` is in C but whose sources include Fortran, so CMake
# links it with the Fortran driver. Two drivers then contribute a `main` of
# their own, which calls the Fortran main program:
#
# - ifx, out of for_main.o: "undefined reference to `MAIN__'".
# - nvfortran, out of f90main.o: "multiple definition of `main'" *and*
#   "undefined reference to `MAIN_'" -- one underscore, and both complaints at
#   once because its object defines the symbol rather than only referring to it.
#
# Each has a flag for exactly this, telling the driver the program's `main` is
# somebody else's. gfortran and flang need nothing, hence the guard.
#
# The four targets are every one here that mixes the two languages, which is
# also the set the INTERFACE_COMPILE_OPTIONS rewrite above exists for: mixing
# them in one target is what finds this class of defect. `mpif_test_c_main`
# rather than a property on each: the list is worth having in one place, since
# a fifth such target would otherwise fail on a compiler nobody runs locally.
#
# The linker language stays Fortran -- these programs call Fortran and need its
# runtime.
function(mpif_test_c_main name)
  if(NOT TARGET ${name})
    return()
  endif()
  if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
    target_link_options(${name} PRIVATE -nofor-main)
  elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^(NVHPC|PGI)$")
    target_link_options(${name} PRIVATE -Mnomain)
  endif()
endfunction()

function(add_mpi_test name)
  cmake_parse_arguments(T "" "NPROCS" "SOURCES;LIBS" ${ARGN})
  add_executable(${name} ${T_SOURCES})
  target_link_libraries(${name} PRIVATE ${T_LIBS})
  if(MPIF_TEST_BUILD_ONLY)
    return()
  endif()
  if(T_NPROCS)
    if(NOT MPIEXEC_EXECUTABLE OR NOT EXISTS "${MPIEXEC_EXECUTABLE}")
      message(FATAL_ERROR
        "${name} needs ${T_NPROCS} ranks, but MPIEXEC_EXECUTABLE is "
        "\"${MPIEXEC_EXECUTABLE}\", which is not a file. Pass "
        "-DMPIEXEC_EXECUTABLE=<mpi-prefix>/bin/mpiexec: it must be the launcher "
        "of the MPI that mpif was built against, and letting find_package(MPI) "
        "guess has picked an unrelated one.")
    endif()
    add_test(
      NAME ${name}
      COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${T_NPROCS}
              ${MPIEXEC_PREFLAGS} $<TARGET_FILE:${name}> ${MPIEXEC_POSTFLAGS}
      )
  else()
    add_test(NAME ${name} COMMAND ${name})
  endif()
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
mpif_test_c_main(interlanguage)
mpif_test_c_main(c2f)
add_mpi_test(type_create_struct_c   SOURCES type_create_struct_c.c                  LIBS MPI::MPI_C)
add_mpi_test(predefined_types_c     SOURCES predefined_types_c.c                    LIBS MPI::MPI_C)
add_mpi_test(type_create_struct_f08 SOURCES type_create_struct_f08.f90              LIBS MPI::MPI_Fortran)
add_mpi_test(info_get_string_f08    SOURCES info_get_string_f08.f90                 LIBS MPI::MPI_Fortran)
add_mpi_test(info_blanks_f08        SOURCES info_blanks_f08.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(session_get_nth_pset_f08 SOURCES session_get_nth_pset_f08.f90          LIBS MPI::MPI_Fortran)
add_mpi_test(argv_null_f08          SOURCES argv_null_f08.f90                       LIBS MPI::MPI_Fortran)
add_mpi_test(comm_get_attr_f08      SOURCES comm_get_attr_f08.f90                   LIBS MPI::MPI_Fortran)
add_mpi_test(keyval_create_f08      SOURCES keyval_create_f08.f90                   LIBS MPI::MPI_Fortran)
add_mpi_test(grequest_f08           SOURCES grequest_f08.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(sizeof_f               SOURCES sizeof_f.f                              LIBS MPI::MPI_Fortran)
add_mpi_test(sizeof_f90             SOURCES sizeof_f90.f90                          LIBS MPI::MPI_Fortran)
add_mpi_test(cart_get_f90           SOURCES cart_get_f90.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(rma_disp_f08           SOURCES rma_disp_f08.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(alloc_mem_cptr        SOURCES alloc_mem_cptr.f90                      LIBS MPI::MPI_Fortran)
add_mpi_test(large_count_f08        SOURCES large_count_f08.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(attr_fns_f90           SOURCES attr_fns_f90.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(attr_fns_f08           SOURCES attr_fns_f08.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(partitioned_f08        SOURCES partitioned_f08.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(datarep_f08            SOURCES datarep_f08.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(datarep_c              SOURCES datarep_c.c datarep_subf90.f90          LIBS MPI::MPI_Fortran MPI::MPI_C)
mpif_test_c_main(datarep_c)
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
add_mpi_test(handle_types_f90       SOURCES handle_types_f90.f90                    LIBS MPI::MPI_Fortran)
add_mpi_test(sentinel_addresses_c   SOURCES sentinel_addresses_c.c                  LIBS MPI::MPI_Fortran MPI::MPI_C)
add_mpi_test(buffer_detach          SOURCES buffer_detach.f90                       LIBS MPI::MPI_Fortran)
add_mpi_test(op_create              SOURCES op_create.f90                           LIBS MPI::MPI_Fortran)
add_mpi_test(waitall_f90            SOURCES waitall_f90.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(waitall_f08            SOURCES waitall_f08.f90                         LIBS MPI::MPI_Fortran)
# The sentinels that reach C as an address mpif has to translate. One file per
# sentinel family, each covering the interfaces that had no test of it.
add_mpi_test(bottom                 SOURCES bottom.f90                              LIBS MPI::MPI_Fortran)
add_mpi_test(statuses_ignore        SOURCES statuses_ignore.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(dist_graph_weights     SOURCES dist_graph_weights.f90                  LIBS MPI::MPI_Fortran)
add_mpi_test(pmpi_f                 SOURCES pmpi_f.f                                LIBS MPI::MPI_Fortran)
add_mpi_test(pmpi_f90               SOURCES pmpi_f90.f90                            LIBS MPI::MPI_Fortran)
add_mpi_test(pmpi_f08               SOURCES pmpi_f08.f90                            LIBS MPI::MPI_Fortran)
# Interposition: each replaces two of mpif's entry points with its own. They run
# against an archive as well as a shared library, because MPIF_SPLIT_WRAPPERS
# gives every MPI_ entry point a translation unit of its own -- MPI-5.0 section
# 15.2.1(2) and (4). Configure a static mpif with -DMPIF_SPLIT_WRAPPERS=OFF and
# these two stop linking, which is what makes them a test of it.
add_mpi_test(profile_f90            SOURCES profile_f90.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(profile_f08            SOURCES profile_f08.f90                         LIBS MPI::MPI_Fortran)

# The alltoallw family, whose handle arrays are the one place mpif has to work
# out for itself how many entries there are. Multi-rank on purpose: at one rank
# every wrong length coincides with the right one.
add_mpi_test(alltoallw_f08          SOURCES alltoallw_f08.f90         NPROCS 2      LIBS MPI::MPI_Fortran)
add_mpi_test(alltoallw_inplace_f    SOURCES alltoallw_inplace_f.f     NPROCS 2      LIBS MPI::MPI_Fortran)
add_mpi_test(alltoallw_inplace_f90  SOURCES alltoallw_inplace_f90.f90 NPROCS 2      LIBS MPI::MPI_Fortran)
add_mpi_test(alltoallw_inplace_f08  SOURCES alltoallw_inplace_f08.f90 NPROCS 2      LIBS MPI::MPI_Fortran)
add_mpi_test(neighbor_alltoallw_f08 SOURCES neighbor_alltoallw_f08.f90 NPROCS 2     LIBS MPI::MPI_Fortran)
# The three above check that in-place works; this one checks that `sendtypes` is
# not read, which needs a guard page and therefore C.
add_mpi_test(alltoallw_inplace_guard
  SOURCES alltoallw_inplace_guard.c alltoallw_inplace_guard_subf.f alltoallw_inplace_guard_subf90.f90
  NPROCS 2 LIBS MPI::MPI_Fortran MPI::MPI_C)
mpif_test_c_main(alltoallw_inplace_guard)
# Three, so that the two groups differ in size and the local one is the wrong
# answer.
add_mpi_test(alltoallw_inter_f08    SOURCES alltoallw_inter_f08.f90   NPROCS 3      LIBS MPI::MPI_Fortran)

# mpif's own runtime consistency checks. The positive tests call both routines
# before MPI_Init, between MPI_Init and MPI_Finalize, and after MPI_Finalize;
# a failure aborts, so running to completion is the assertion. Three ranks for
# the f08 one so the token ring, the head count and the cross-rank comparisons
# are non-degenerate. check_c links MPI::MPI_Fortran too: the routines live in
# libmpifort_abi, which plain MPI::MPI_C does not pull in.
add_mpi_test(check_f                SOURCES check_f.f                               LIBS MPI::MPI_Fortran)
add_mpi_test(check_f90              SOURCES check_f90.f90                           LIBS MPI::MPI_Fortran)
add_mpi_test(check_f08              SOURCES check_f08.f90             NPROCS 3      LIBS MPI::MPI_Fortran)
add_mpi_test(check_c                SOURCES check_c.c                               LIBS MPI::MPI_Fortran MPI::MPI_C)

# The optional environment variables, reusing the check_f90 binary under
# mpiexec. One positive run in which every variable holds -- "mpi" is a
# case-insensitive substring of both "MPICH ..." and "Open MPI ...", and two
# ranks on the one local node satisfy the node counts -- and one expected
# abort per variable. The abort tests pass on the diagnostic rather than the
# exit status (PASS_REGULAR_EXPRESSION decides regardless of it): the
# pre-initialization failure path raises SIGABRT, which WILL_FAIL would report
# as an exception, and under mpiexec the launcher absorbs the signal anyway.
#
# The positive run passes on the layout line that stating a node expectation
# makes rank 0 print, which is the only thing that checks that instrument -- and
# which also states the layout the two negative node tests need to be wrong. Note
# what that line must not say: its prefix is "mpif: node layout: " and not
# "mpif: mpif_check_environment: ", because a line carrying the latter would
# satisfy every failure test below without any check having failed. See the
# printing walk in src/mpif_check.c and MISSING.md "The `check_env*_fail` tests
# flake, on CI runners and not here".
#
# check_f90 itself prints, on stderr and under its own "check_f90: " prefix, the
# MPIF_* variables it can see and whether it reached the end. That is the other
# half of the same instrument: when one of these tests flakes, those two lines
# say whether the process saw the expectation at all, or whether the launcher
# threw its output away.
function(add_check_env_test name nprocs env)
  if(MPIF_TEST_BUILD_ONLY)
    return()
  endif()
  add_test(
    NAME ${name}
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${nprocs}
            ${MPIEXEC_PREFLAGS} $<TARGET_FILE:check_f90> ${MPIEXEC_POSTFLAGS}
    )
  set_tests_properties(${name} PROPERTIES ENVIRONMENT "${env}")
  if(ARGC GREATER 3)
    set_tests_properties(${name} PROPERTIES PASS_REGULAR_EXPRESSION "${ARGV3}")
  endif()
endfunction()
add_check_env_test(check_env 2
  "MPIF_SIZE=2;MPIF_NUM_NODES=1;MPIF_NODE_SIZE=2;MPIF_MPI_LIBRARY=${MPIF_TEST_MPI_LIBRARY}"
  "mpif: node layout: .*: 2 processes on 1 node")
add_check_env_test(check_env_size_fail 2 "MPIF_SIZE=3"
  "mpif: mpif_check_environment: ")
add_check_env_test(check_env_nodes_fail 2 "MPIF_NUM_NODES=2"
  "mpif: mpif_check_environment: ")
add_check_env_test(check_env_nodesize_fail 2 "MPIF_NODE_SIZE=1"
  "mpif: mpif_check_environment: ")
add_check_env_test(check_env_library_fail 1 "MPIF_MPI_LIBRARY=not-a-real-mpi"
  "mpif: mpif_check_environment: ")

# The wrong-mpiexec failure: run *without* a launcher, so MPI_Init comes up as
# a singleton, with a launcher variable claiming four processes. SLURM_NTASKS
# rather than PMI_SIZE or OMPI_COMM_WORLD_SIZE because neither implementation's
# singleton initialization should react to it without the rest of the SLURM
# environment.
if(NOT MPIF_TEST_BUILD_ONLY)
  add_test(NAME check_env_mpiexec_fail COMMAND $<TARGET_FILE:check_f90>)
  set_tests_properties(check_env_mpiexec_fail PROPERTIES
    ENVIRONMENT "SLURM_NTASKS=4"
    PASS_REGULAR_EXPRESSION "mpif: mpif_check_environment: ")
endif()

# mpif_info is installed by the main project; running it here is what
# verifies its INSTALL_RPATH -- every other executable in this file gets its
# rpath from the mpifort wrapper, that one has to carry its own. The test
# project knows mpif's prefix only through MPI_Fortran_COMPILER, so the
# binary's path is derived from the wrapper's. Both runs set the full
# complement of MPIF_* variables, so the environment check inside checks them
# for real: "mpi" is a case-insensitive substring of both implementations'
# library strings, and the counts hold on the one local node. Passing on the
# final line of output rather than the exit status alone, so a binary that
# silently printed nothing would fail.
if(NOT MPIF_TEST_BUILD_ONLY)
  get_filename_component(mpif_bindir "${MPI_Fortran_COMPILER}" DIRECTORY)
  add_test(
    NAME mpif_info
    COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} 3
            ${MPIEXEC_PREFLAGS} ${mpif_bindir}/mpif_info ${MPIEXEC_POSTFLAGS}
    )
  set_tests_properties(mpif_info PROPERTIES
    ENVIRONMENT "MPIF_SIZE=3;MPIF_NUM_NODES=1;MPIF_NODE_SIZE=3;MPIF_MPI_LIBRARY=${MPIF_TEST_MPI_LIBRARY}"
    PASS_REGULAR_EXPRESSION "mpif_check_environment: passed")
  add_test(NAME mpif_info_singleton COMMAND ${mpif_bindir}/mpif_info)
  set_tests_properties(mpif_info_singleton PROPERTIES
    ENVIRONMENT "MPIF_SIZE=1;MPIF_NUM_NODES=1;MPIF_NODE_SIZE=1;MPIF_MPI_LIBRARY=${MPIF_TEST_MPI_LIBRARY}"
    PASS_REGULAR_EXPRESSION "mpif_check_environment: passed")
endif()

# The version handshake's failure path: a major version the loaded library
# cannot be.
add_mpi_test(check_version_fail_f90 SOURCES check_version_fail_f90.f90 NPROCS 1     LIBS MPI::MPI_Fortran)
if(NOT MPIF_TEST_BUILD_ONLY)
  set_tests_properties(check_version_fail_f90 PROPERTIES
    PASS_REGULAR_EXPRESSION "mpif: mpif_check_version: ")
endif()

# Root-only arguments, which mpif converts only where they are significant and
# used to convert on rank 0 instead of at the root. Both need more than one rank
# for the same reason: at one rank every process is the root.
add_mpi_test(gather_root_f08        SOURCES gather_root_f08.f90       NPROCS 2      LIBS MPI::MPI_Fortran)
# Three, so that the root is not the first process of its own group and MPI_ROOT
# is the only thing that identifies it.
add_mpi_test(gather_inter_f08       SOURCES gather_inter_f08.f90      NPROCS 3      LIBS MPI::MPI_Fortran)

# TS 29113 choice buffers. The expected value of MPI_SUBARRAYS_SUPPORTED is
# re-derived here -- "auto" runs the same probe the mpif build ran, an
# explicit ON/OFF overrides it -- so subarrays_constants_f08 cannot pass
# vacuously: an mpi_f08 whose constants disagree with what its buffers can do
# fails the test whichever way the disagreement goes. A build configured with
# -DMPIF_ENABLE_CFI=OFF on a capable toolchain has to pass OFF here too.
set(MPIF_TEST_EXPECT_SUBARRAYS "auto" CACHE STRING
  "Expected MPI_SUBARRAYS_SUPPORTED in mpi_f08: auto, ON or OFF")
if(MPIF_TEST_EXPECT_SUBARRAYS STREQUAL "auto")
  include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/cfi-include-dir.cmake)
  if(CMAKE_CROSSCOMPILING)
    set(_mpif_test_cfi_probe_run OFF)
  else()
    set(_mpif_test_cfi_probe_run ON)
  endif()
  try_compile(MPIF_TEST_HAVE_CFI
    ${CMAKE_CURRENT_BINARY_DIR}/cfi-probe
    ${CMAKE_CURRENT_SOURCE_DIR}/../cmake/cfi-probe
    cfi-probe
    CMAKE_FLAGS
      "-DMPIF_PROBE_RUN=${_mpif_test_cfi_probe_run}"
      "-DMPIF_PROBE_CFI_INCLUDE_DIR=${MPIF_CFI_INCLUDE_DIR}")
  set(_mpif_test_expect ${MPIF_TEST_HAVE_CFI})
else()
  set(_mpif_test_expect ${MPIF_TEST_EXPECT_SUBARRAYS})
endif()
add_mpi_test(subarrays_constants_f08 SOURCES subarrays_constants_f08.F90 LIBS MPI::MPI_Fortran)
if(_mpif_test_expect)
  target_compile_definitions(subarrays_constants_f08 PRIVATE MPIF_EXPECT_SUBARRAYS=1)
else()
  target_compile_definitions(subarrays_constants_f08 PRIVATE MPIF_EXPECT_SUBARRAYS=0)
endif()

# Noncontiguous sections to nonblocking calls -- the case the constant names.
# -O2 on purpose, like status_error_f08: ASYNCHRONOUS on the caller's arrays
# is what holds the optimiser off across MPI_Wait, and -O0 would hide a
# binding that lost the attribute.
add_mpi_test(subarray_nonblocking_f08 SOURCES subarray_nonblocking_f08.f90 LIBS MPI::MPI_Fortran)
target_compile_options(subarray_nonblocking_f08 PRIVATE $<$<COMPILE_LANGUAGE:Fortran>:-O2>)
# Sentinels, layouts and shapes through descriptors. The blocking cases must
# pass on the fallback branch too (compiler copy-in/copy-out is correct
# there); on the TS branch they exercise the cdesc walker, the sentinel
# recognition, and the reduction family's 6.9.1 contiguity refusal.
add_mpi_test(inplace_cfi_f08        SOURCES inplace_cfi_f08.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(bottom_cfi_f08         SOURCES bottom_cfi_f08.f90                      LIBS MPI::MPI_Fortran)
add_mpi_test(scalar_char_cfi_f08    SOURCES scalar_char_cfi_f08.f90                 LIBS MPI::MPI_Fortran)
target_compile_options(scalar_char_cfi_f08 PRIVATE $<$<COMPILE_LANGUAGE:Fortran>:-O2>)
add_mpi_test(reduction_noncontig_cfi_f08 SOURCES reduction_noncontig_cfi_f08.f90  LIBS MPI::MPI_Fortran)
# Sections with a dimension *above* a strided one -- the shape where the walker
# may not place a level with MPI_Type_contiguous, since that replicates by the
# inner extent and an hvector's extent is short of its span. See the file's
# header. subarray_nonblocking_f08's two sections both put the strided level
# last and pass either way.
add_mpi_test(subarray_strided_cfi_f08 SOURCES subarray_strided_cfi_f08.f90       LIBS MPI::MPI_Fortran)
