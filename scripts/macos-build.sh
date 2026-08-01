#!/bin/bash

# Everything for one variant, from nothing to passing tests: build and install
# the MPI implementation, build and install mpif, run mpif's own tests, then run
# MPICH's Fortran test suite.
#
# Usage: scripts/macos-build.sh <mpich|openmpi> <gcc|llvm>

set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

"${here}/macos-install-mpi.sh" "$@"
"${here}/macos-build-mpif.sh" "$@"
"${here}/macos-test-mpif.sh" "$@"

# MPICH's suite still has untriaged failures, so it reports without failing the
# build -- the same as the CI step, so that a local run and a CI run agree on
# what "passing" means.
#TODO Let this fail the build once the failures have been triaged, together
#TODO with the continue-on-error in .github/workflows/ci.yaml
if ! "${here}/macos-test-mpich-suite.sh" "$@"; then
    echo "$(basename "$0"): MPICH's Fortran test suite reported failures," \
         "which is not fatal yet -- see above" >&2
fi
