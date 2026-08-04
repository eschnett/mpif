#!/bin/bash

# Build and run the tests in test/ against an installed mpif.
#
# Usage: scripts/macos-test-mpif.sh <mpich|openmpi> <gcc|llvm>

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

# The alltoallw tests need more than one rank, hence a launcher. It is pinned
# rather than left to find_package(MPI), which found an unrelated miniforge
# install here and would have run them against an MPI mpif was not built against;
# test/CMakeLists.txt fails the configure if this is missing.
#
# Open MPI gets the same two flags scripts/macos-test-mpich-suite.sh passes as
# MPIEXEC_ARGS, for the reasons spelled out there: it refuses to oversubscribe,
# and on macOS it picks a non-loopback interface it cannot configure and then
# hangs. Overridable the same way.
cmake_args=()
if [[ ${mpi} == openmpi ]]; then
    cmake_args+=("-DMPIEXEC_PREFLAGS=${MPIF_TEST_MPIEXEC_PREFLAGS:---oversubscribe;--mca;btl_tcp_if_include;lo0}")
fi

rm -rf "${build}-tests"
cmake \
    -S "${repodir}/test" \
    -B "${build}-tests" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER="${CC}" \
    -DCMAKE_Fortran_COMPILER="${FC}" \
    -DMPI_C_COMPILER="${mpi_prefix}/bin/mpicc" \
    -DMPI_Fortran_COMPILER="${mpif_prefix}/bin/mpifort" \
    -DMPI_C_HEADER_DIR="${mpi_prefix}/include" \
    -DMPI_C_LIB_NAMES=mpi_abi \
    -DMPI_mpi_abi_LIBRARY="${mpi_prefix}/lib/libmpi_abi.${shlib_ext}" \
    -DMPIEXEC_EXECUTABLE="${mpi_prefix}/bin/mpiexec" \
    "${cmake_args[@]}"
cmake --build "${build}-tests" --parallel
ctest --test-dir "${build}-tests" --output-on-failure
