#!/bin/bash

# Build and install MPICH with the MPI standard ABI, extended with the
# Fortran/C handle conversion functions (`MPI_Comm_c2f` and friends) that
# MPICH's ABI library does not yet provide; see fortran/f2c_abi_mpich.c.
#
# The resulting installation exposes the standard ABI only: MPICH's own
# `mpi.h`, Fortran modules and non-ABI libraries are removed, and the official
# ABI `mpi.h` is installed in their place.
#
# Usage: install-mpich.sh <prefix>
#
# Environment:
#   CC, CXX, FC     compilers to build MPICH with (default: system compilers)
#   HWLOC_PREFIX    where hwloc is installed, if not in a default location
#                   (e.g. /opt/local for MacPorts, /opt/homebrew for Homebrew)

set -euo pipefail

MPICH_VERSION=5.0.1
# https://github.com/pmodels/mpich/commit/689a0869c8f58167e3b0b5db13f8ce8db5f24009
MPICH_PATCH_COMMIT=689a0869c8f58167e3b0b5db13f8ce8db5f24009

prefix=${1:?usage: install-mpich.sh <prefix>}

scriptdir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repodir=$(cd "${scriptdir}/.." && pwd)
nprocs=$(getconf _NPROCESSORS_ONLN)

workdir=$(mktemp -d)
trap 'rm -rf "${workdir}"' EXIT
cd "${workdir}"

# Download
curl -fsSLO "https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz"
tar xzf "mpich-${MPICH_VERSION}.tar.gz"
cd "mpich-${MPICH_VERSION}"

curl -fsSL -o mpich.patch \
     "https://github.com/pmodels/mpich/commit/${MPICH_PATCH_COMMIT}.patch"
patch -p1 <mpich.patch

# Add the Fortran/C handle conversion functions to the ABI library
cp "${repodir}/fortran/f2c_abi_mpich.c" src/binding/abi/fortran_binding_abi.c
perl -pi -e 's!src/binding/abi/c_binding_abi\.c!src/binding/abi/c_binding_abi.c src/binding/abi/fortran_binding_abi.c!' \
     src/binding/abi/Makefile.mk
# Fail loudly if upstream renamed the file we hooked into: without this the
# bindings would be silently left out of the library, and the failure would
# only show up much later as undefined symbols when linking a test.
grep -q 'fortran_binding_abi\.c' src/binding/abi/Makefile.mk

./autogen.sh

# Configure
configure_flags=(
    --disable-dependency-tracking
    --disable-doc
    --enable-cxx=no
    --enable-fortran
    --enable-mpi-abi
    --enable-static=no
    --prefix="${prefix}"
    --with-device=ch3
    "--with-hwloc${HWLOC_PREFIX:+=${HWLOC_PREFIX}}"
)
./configure "${configure_flags[@]}"

# Remove the MPI_File_{c2f,f2c} bindings, which are not part of the ABI.
# This has to happen after `configure`, which regenerates the file.
patch -p1 <"${repodir}/fortran/mpich-disable-file.patch"

# Build and install
make -j"${nprocs}"
make install

# Point the wrapper compilers at the ABI library
perl -pi -e 's!mpi_abi=no!mpi_abi=yes!' "${prefix}/bin/mpicc" "${prefix}/bin/mpicxx"

# Expose the standard ABI only
"${scriptdir}/prune-install.sh" "${prefix}" "${scriptdir}/mpich-prune.txt"
"${scriptdir}/install-mpi-header.sh" "${prefix}"
