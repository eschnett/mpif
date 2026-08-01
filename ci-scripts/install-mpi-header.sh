#!/bin/bash

# Install the official MPI ABI header into an MPI installation, replacing
# whatever `mpi.h` the implementation shipped.
#
# The header comes from the MPI Forum's ABI stubs repository, patched by
# `fortran/mpi.h.patch` (which adds the Fortran/C handle conversion
# declarations that the stubs header omits).
#
# Usage: install-mpi-header.sh <prefix>

set -euo pipefail

prefix=${1:?usage: install-mpi-header.sh <prefix>}

repodir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

workdir=$(mktemp -d)
trap 'rm -rf "${workdir}"' EXIT

git clone --quiet --depth 1 \
    https://github.com/mpi-forum/mpi-abi-stubs "${workdir}/mpi-abi-stubs"

mkdir -p "${prefix}/include"
cp "${workdir}/mpi-abi-stubs/mpi.h" "${prefix}/include/mpi.h"
patch -d "${prefix}/include" -p1 <"${repodir}/fortran/mpi.h.patch"
