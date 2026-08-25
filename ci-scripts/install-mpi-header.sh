#!/usr/bin/env bash

# Install the official MPI ABI header into an MPI installation, replacing
# whatever `mpi.h` the implementation shipped.
#
# The header comes from the MPI Forum's ABI stubs repository, patched by
# `fortran/mpi.h.patch`, which adds the Fortran/C handle conversion
# declarations and the four status sentinels the stubs header omits -- it says
# nothing about Fortran at all. See MISSING.md.
#
# Usage: install-mpi-header.sh <prefix>

set -euo pipefail

# Pinned to a commit rather than to the default branch, so that what a build
# gets does not depend on the day it runs, and so that an upstream change is
# something to adopt deliberately rather than something to discover in a
# failure. ci-scripts/install-mpi-stubs.sh reads this variable out of this file
# by name -- the two take the same header from the same repository, and must
# not drift apart.
#
# Bumping it: change the SHA, then run `patch --dry-run` (or any build) to see
# whether fortran/mpi.h.patch still applies. This one is 2026-08-20, and is the
# first that carries the partitioned-communication prototypes MPI-5.0 has
# (mpi-forum/mpi-abi-stubs#93), which retired the other half of that patch.
MPI_ABI_STUBS_COMMIT=a8470014382bf4a4f39f9b3539857b36ac7b35c9

prefix=${1:?usage: install-mpi-header.sh <prefix>}

repodir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

workdir=$(mktemp -d)
trap 'rm -rf "${workdir}"' EXIT

git clone --quiet --depth 1 \
    https://github.com/mpi-forum/mpi-abi-stubs "${workdir}/mpi-abi-stubs"
git -C "${workdir}/mpi-abi-stubs" fetch --quiet --depth 1 origin \
    "${MPI_ABI_STUBS_COMMIT}"
git -C "${workdir}/mpi-abi-stubs" checkout --quiet "${MPI_ABI_STUBS_COMMIT}"

mkdir -p "${prefix}/include"
cp "${workdir}/mpi-abi-stubs/mpi.h" "${prefix}/include/mpi.h"
patch -d "${prefix}/include" -p1 <"${repodir}/fortran/mpi.h.patch"
