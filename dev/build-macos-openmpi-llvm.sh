#!/bin/bash

# Build and test mpif on macOS against OpenMPI built with LLVM.
#
# The compilers are MacPorts' (see scripts/macos-common.sh, where CC, CXX and FC from the
# environment take precedence). Everything lands in mpi/ and
# build-openmpi-llvm*/, all of which git ignores.

set -euo pipefail
exec "$(dirname "${BASH_SOURCE[0]}")/../scripts/macos-build.sh" openmpi llvm
