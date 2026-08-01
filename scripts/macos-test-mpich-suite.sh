#!/bin/bash

# Run MPICH's Fortran test suite against one locally built variant. Not part of
# macos-build.sh: it is much slower than test/, and its failures are expected
# until they have been triaged.
#
# Usage: scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm>

set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${here}/macos-common.sh" "$@"

# Keep the suite next to everything else a variant needs, so that a rerun skips
# the download and the configure
export MPICH_TESTS_DIR=${MPICH_TESTS_DIR:-${repodir}/mpi/tests-${variant}}

exec "${repodir}/ci-scripts/test-mpich-suite.sh" "${mpi_prefix}" "${mpif_prefix}"
