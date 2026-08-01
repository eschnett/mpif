#!/bin/bash

# Run MPICH's Fortran test suite against one locally built variant. Part of
# macos-build.sh, which does not let its failures fail the build; run it on its
# own to iterate on them.
#
# Usage: scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm>
#
# Set MPIF_KEEP_TESTS=1 to keep the compiled test executables, which is what a
# debugger needs to get a backtrace out of a crashing test; see
# ci-scripts/test-mpich-suite.sh for the other environment variables.

set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${here}/macos-common.sh" "$@"

# Keep the suite next to everything else a variant needs, so that a rerun skips
# the download and the configure
export MPICH_TESTS_DIR=${MPICH_TESTS_DIR:-${repodir}/mpi/tests-${variant}}

# Open MPI refuses to oversubscribe by default, and the suite asks for more
# processes than a small machine has cores. Same as the CI step.
if [[ ${mpi} == openmpi ]]; then
    export MPIEXEC_ARGS=${MPIEXEC_ARGS:---oversubscribe}
fi

exec "${repodir}/ci-scripts/test-mpich-suite.sh" "${mpi_prefix}" "${mpif_prefix}"
