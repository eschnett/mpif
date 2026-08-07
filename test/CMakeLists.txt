cmake_minimum_required(VERSION 3.13...3.28)
project(
  mpif-tests VERSION 0.1.0
  DESCRIPTION "Tests for MPI Fortran bindings"
  HOMEPAGE_URL "https://github.com/eschnett/mpif"
  LANGUAGES C Fortran
  )

find_package(MPI REQUIRED COMPONENTS C Fortran)

enable_testing()

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
function(add_mpi_test name)
  cmake_parse_arguments(T "" "NPROCS" "SOURCES;LIBS" ${ARGN})
  add_executable(${name} ${T_SOURCES})
  target_link_libraries(${name} PRIVATE ${T_LIBS})
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
add_mpi_test(type_create_struct_c   SOURCES type_create_struct_c.c                  LIBS MPI::MPI_C)
add_mpi_test(predefined_types_c     SOURCES predefined_types_c.c                    LIBS MPI::MPI_C)
add_mpi_test(type_create_struct_f08 SOURCES type_create_struct_f08.f90              LIBS MPI::MPI_Fortran)
add_mpi_test(info_get_string_f08    SOURCES info_get_string_f08.f90                 LIBS MPI::MPI_Fortran)
add_mpi_test(info_blanks_f08        SOURCES info_blanks_f08.f90                     LIBS MPI::MPI_Fortran)
add_mpi_test(argv_null_f08          SOURCES argv_null_f08.f90                       LIBS MPI::MPI_Fortran)
add_mpi_test(comm_get_attr_f08      SOURCES comm_get_attr_f08.f90                   LIBS MPI::MPI_Fortran)
add_mpi_test(keyval_create_f08      SOURCES keyval_create_f08.f90                   LIBS MPI::MPI_Fortran)
add_mpi_test(grequest_f08           SOURCES grequest_f08.f90                        LIBS MPI::MPI_Fortran)
add_mpi_test(sizeof_f               SOURCES sizeof_f.f                              LIBS MPI::MPI_Fortran)
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
add_mpi_test(handle_types_f90       SOURCES handle_types_f90.f90                    LIBS MPI::MPI_Fortran)
add_mpi_test(sentinel_alignment_c   SOURCES sentinel_alignment_c.c                  LIBS MPI::MPI_Fortran MPI::MPI_C)
add_mpi_test(buffer_detach          SOURCES buffer_detach.f90                       LIBS MPI::MPI_Fortran)
add_mpi_test(op_create              SOURCES op_create.f90                           LIBS MPI::MPI_Fortran)
add_mpi_test(waitall_f90            SOURCES waitall_f90.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(waitall_f08            SOURCES waitall_f08.f90                         LIBS MPI::MPI_Fortran)
add_mpi_test(pmpi_f                 SOURCES pmpi_f.f                                LIBS MPI::MPI_Fortran)
add_mpi_test(pmpi_f90               SOURCES pmpi_f90.f90                            LIBS MPI::MPI_Fortran)
add_mpi_test(pmpi_f08               SOURCES pmpi_f08.f90                            LIBS MPI::MPI_Fortran)
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
function(add_check_env_test name nprocs env)
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
  "MPIF_SIZE=2;MPIF_NUM_NODES=1;MPIF_NODE_SIZE=2;MPIF_MPI_LIBRARY=mpi")
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
add_test(NAME check_env_mpiexec_fail COMMAND $<TARGET_FILE:check_f90>)
set_tests_properties(check_env_mpiexec_fail PROPERTIES
  ENVIRONMENT "SLURM_NTASKS=4"
  PASS_REGULAR_EXPRESSION "mpif: mpif_check_environment: ")

# The version handshake's failure path: a major version the loaded library
# cannot be.
add_mpi_test(check_version_fail_f90 SOURCES check_version_fail_f90.f90 NPROCS 1     LIBS MPI::MPI_Fortran)
set_tests_properties(check_version_fail_f90 PROPERTIES
  PASS_REGULAR_EXPRESSION "mpif: mpif_check_version: ")

# Root-only arguments, which mpif converts only where they are significant and
# used to convert on rank 0 instead of at the root. Both need more than one rank
# for the same reason: at one rank every process is the root.
add_mpi_test(gather_root_f08        SOURCES gather_root_f08.f90       NPROCS 2      LIBS MPI::MPI_Fortran)
# Three, so that the root is not the first process of its own group and MPI_ROOT
# is the only thing that identifies it.
add_mpi_test(gather_inter_f08       SOURCES gather_inter_f08.f90      NPROCS 3      LIBS MPI::MPI_Fortran)
