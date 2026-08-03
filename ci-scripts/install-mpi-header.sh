#!/bin/bash

# Install the official MPI ABI header into an MPI installation, replacing
# whatever `mpi.h` the implementation shipped.
#
# The header comes from the MPI Forum's ABI stubs repository, patched by
# `fortran/mpi.h.patch`, which adds the Fortran/C handle conversion declarations
# the stubs header omits and corrects the partitioned-communication prototypes it
# gets wrong -- an `int` count where MPI-5.0 and both implementations have an
# MPI_Count, plus MPI_Psend_init_c and MPI_Precv_init_c, which the standard does
# not define at all. See MISSING.md.
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
