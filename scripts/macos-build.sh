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

# MPICH's suite has failures that are expected -- on blockers in the
# implementations and on features mpif does not have yet -- so what fails the
# build is a difference from ci-scripts/mpich-suite-xfail.txt rather than a
# failure. The CI step and the docker builds use the same list, so a local run
# and a CI run agree on what "passing" means.
"${here}/macos-test-mpich-suite.sh" "$@"
