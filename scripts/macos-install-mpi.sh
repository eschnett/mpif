#!/bin/bash

# Build and install one MPI implementation into `mpi/<variant>`, using the same
# script that CI and the Docker images use.
#
# Usage: scripts/macos-install-mpi.sh <mpich|openmpi> <gcc|llvm>

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

rm -rf "${mpi_prefix}"
"${repodir}/ci-scripts/install-${mpi}.sh" "${mpi_prefix}"
