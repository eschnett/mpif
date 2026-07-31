#!/bin/bash

# Configure, build and install mpif against an MPI installed by
# scripts/macos-install-mpi.sh.
#
# Usage: scripts/macos-build-mpif.sh <mpich|openmpi> <gcc|llvm>

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

rm -rf "${build}" "${mpif_prefix}"
cmake \
    -S "${repodir}" \
    -B "${build}" \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER="${CC}" \
    -DCMAKE_Fortran_COMPILER="${FC}" \
    -DCMAKE_INSTALL_PREFIX="${mpif_prefix}" \
    -DMPI_HOME="${mpi_prefix}"
cmake --build "${build}" --parallel
cmake --install "${build}"
