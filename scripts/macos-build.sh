#!/bin/bash

# Everything for one variant, from nothing to passing tests: build and install
# the MPI implementation, build and install mpif, run the tests.
#
# Usage: scripts/macos-build.sh <mpich|openmpi> <gcc|llvm>

set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

"${here}/macos-install-mpi.sh" "$@"
"${here}/macos-build-mpif.sh" "$@"
"${here}/macos-test-mpif.sh" "$@"
