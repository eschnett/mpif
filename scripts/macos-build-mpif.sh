#!/bin/bash

# Configure, build and install mpif against an MPI installed by
# scripts/macos-install-mpi.sh.
#
# Usage: scripts/macos-build-mpif.sh <mpich|openmpi> <gcc|llvm>
#
# Environment:
#   MPIF_SANITIZE  build with these sanitizers (`address`, or a list such as
#                  `address,undefined`) into a build tree and prefix of their
#                  own, leaving the ordinary build alone. See
#                  scripts/macos-common.sh.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

# mpif is only mpif if the MPI underneath it exposes the standard ABI and
# nothing else. The install scripts now take a half-installed prefix away with
# them rather than leaving it (see MISSING.md "An unpruned Open MPI prefix"),
# but a prefix written some other way -- `make install` by hand is the one that
# happened -- still looks complete, and building against it produces an mpif
# that is wrong without failing. One compile settles it.
if ! abi_check=$("${repodir}/ci-scripts/check-mpi-install.sh" "${mpi_prefix}" 2>&1); then
    echo "${abi_check}" >&2
    echo "error: ${mpi_prefix} does not expose the standard ABI." >&2
    echo "       Reinstall it: scripts/macos-install-mpi.sh ${mpi} ${toolchain}" >&2
    exit 1
fi

rm -rf "${build}" "${mpif_prefix}"
cmake \
    -S "${repodir}" \
    -B "${build}" \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER="${CC}" \
    -DCMAKE_Fortran_COMPILER="${FC}" \
    -DCMAKE_INSTALL_PREFIX="${mpif_prefix}" \
    -DMPI_HOME="${mpi_prefix}" \
    -DMPIF_SANITIZE="${sanitize}"
cmake --build "${build}" --parallel
cmake --install "${build}"

# A sanitizer build that quietly came out uninstrumented passes every test, so
# nothing downstream would notice. Ask the object code instead.
if [[ -n ${sanitize} ]]; then
    bash "${repodir}/ci-scripts/check-sanitizer-build.sh" "${mpif_prefix}"
fi
