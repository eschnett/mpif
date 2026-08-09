# The TS 29113 probe: does this toolchain pass an assumed-rank actual to a
# bind(C) routine as a C descriptor the C compiler can read? Built by the
# try_compile in the top-level CMakeLists.txt, which treats "this project
# configures, compiles, links and (via the POST_BUILD step below) runs
# cleanly" as MPIF_HAVE_CFI.
#
# Compile acceptance alone is not the question -- nvfortran accepts the
# gfortran directive probe without honoring it (open-mpi/ompi#11582), and
# MPICH's compile-only TS check false-passed and then failed at link on
# CFI_is_contiguous (pmodels/mpich#6505) -- so the probe links that very
# symbol and, where the build machine can run what it compiles, executes the
# result and checks the descriptors' contents. MPIF_PROBE_RUN is OFF when the
# outer configure is cross-compiling; the link still catches the MPICH-class
# failure there.
cmake_minimum_required(VERSION 3.13...3.28)
project(cfi-probe C Fortran)

add_executable(cfi-probe probe.f90 probe.c)

if(DEFINED MPIF_PROBE_Fortran_FLAGS)
  separate_arguments(_mpif_probe_fflags UNIX_COMMAND "${MPIF_PROBE_Fortran_FLAGS}")
  target_compile_options(cfi-probe PRIVATE
    $<$<COMPILE_LANGUAGE:Fortran>:${_mpif_probe_fflags}>)
endif()

if(MPIF_PROBE_RUN)
  add_custom_command(TARGET cfi-probe POST_BUILD
    COMMAND cfi-probe
    COMMENT "Running the TS 29113 descriptor probe")
endif()
