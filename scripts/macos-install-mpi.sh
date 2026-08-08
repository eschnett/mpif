#!/bin/bash

# Build and install one MPI implementation into `build/mpi/<variant>`, using
# the same script that CI and the Docker images use.
#
# Usage: scripts/macos-install-mpi.sh <mpich|openmpi> <gcc|llvm>
#
# Environment:
#   MPIF_REBUILD  rebuild even though the prefix is already marked complete.
#                 This is the expensive stage -- tens of minutes -- so by
#                 default a finished prefix is left alone. See "the
#                 install-complete marker" in scripts/macos-common.sh.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

if marker_present "${mpi_prefix}" && [[ -z ${rebuild} ]]; then
    echo "${mpi} (${toolchain}) is already installed in build/mpi/${variant}:"
    show_marker "${mpi_prefix}"
    echo "Set MPIF_REBUILD=1 to build it again."
    exit 0
fi

rm -rf "${mpi_prefix}"
"${repodir}/ci-scripts/install-${mpi}.sh" "${mpi_prefix}"

# Last, so that the marker means the prefix is a pruned standard-ABI one and not
# just that `make install` ran: install-${mpi}.sh finishes with prune-install.sh,
# install-mpi-header.sh and check-mpi-install.sh, and takes the prefix away with
# it if any of them fails.
write_marker "${mpi_prefix}" "MPI: ${mpi}, ${toolchain}"
