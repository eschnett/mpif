#!/bin/bash

# Build and run the tests in test/ against an installed mpif.
#
# Usage: scripts/macos-test-mpif.sh <mpich|openmpi> <gcc|llvm>

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

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
    -DMPI_mpi_abi_LIBRARY="${mpi_prefix}/lib/libmpi_abi.${shlib_ext}"
cmake --build "${build}-tests" --parallel
ctest --test-dir "${build}-tests" --output-on-failure
