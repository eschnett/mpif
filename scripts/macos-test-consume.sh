#!/bin/bash

# Check that an installed mpif can be consumed the way a user would consume it,
# through find_package(mpif).
#
# Usage: scripts/macos-test-consume.sh <mpich|openmpi> <gcc|llvm>
#
# There is no runtime-MPI argument: this checks that find_package(mpif) resolves
# and that what it produces runs, which is a property of the installation rather
# than of either implementation, so it is only run natively.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

require_marker "${mpif_prefix}" \
    "${MPIF_STATIC:+MPIF_STATIC=${MPIF_STATIC} }${MPIF_SANITIZE:+MPIF_SANITIZE=${MPIF_SANITIZE} }scripts/macos-build-mpif.sh ${mpi} ${toolchain}"

echo "Consuming the mpif in build/mpif/${tagged}:"
show_marker "${mpif_prefix}"

build=${consume_build}

rm -rf "${build}"
cmake \
    -S "${repodir}/test-consume" \
    -B "${build}" \
    -DCMAKE_Fortran_COMPILER="${FC}" \
    -DCMAKE_PREFIX_PATH="${mpif_prefix};${mpi_prefix}" \
    -DMPI_C_COMPILER="${mpi_prefix}/bin/mpicc" \
    -DMPI_C_HEADER_DIR="${mpi_prefix}/include" \
    -DMPI_C_LIB_NAMES=mpi_abi \
    -DMPI_mpi_abi_LIBRARY="${mpi_prefix}/lib/libmpi_abi.${shlib_ext}"
cmake --build "${build}" --parallel
ctest --test-dir "${build}" --output-on-failure
