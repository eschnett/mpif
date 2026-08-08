#!/bin/bash

# Build and test mpif on macOS against MPICH built with LLVM.
#
# The compilers are MacPorts' (see scripts/macos-common.sh, where CC, CXX and
# FC from the environment take precedence). Everything lands under
# build/, in the `mpich-llvm` entry of each stage's directory, all git-ignored.

set -euo pipefail
exec "$(dirname "${BASH_SOURCE[0]}")/../scripts/macos-build.sh" mpich llvm
