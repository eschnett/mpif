#!/bin/bash

# Build and install MPICH with the MPI standard ABI, extended with the
# Fortran/C handle conversion functions (`MPI_Comm_c2f` and friends) that
# MPICH's ABI library does not yet provide; see fortran/f2c_abi_mpich.c.
#
# The resulting installation exposes the standard ABI only: MPICH's own
# `mpi.h`, Fortran modules and non-ABI libraries are removed, and the official
# ABI `mpi.h` is installed in their place.
#
# Usage: install-mpich.sh [<prefix>]
#
# Environment:
#   CC, CXX, FC       compilers to build MPICH with (default: system compilers)
#   HWLOC_PREFIX      where hwloc is installed, if not in a default location
#                     (e.g. /opt/local for MacPorts, /opt/homebrew for Homebrew)
#   MPI_SRC_DIR       where to download and build. Defaults to a temporary
#                     directory that is removed afterwards. If it already holds
#                     a tree prepared for this version, the download and
#                     `autogen.sh` steps are skipped -- this is what CI caches.
#   MPI_PREPARE_ONLY  set to 1 to only prepare the source tree (download,
#                     bindings, autogen) and stop before configuring; <prefix>
#                     is then not needed.

set -euo pipefail

MPICH_VERSION=5.0.1
# https://github.com/pmodels/mpich/commit/689a0869c8f58167e3b0b5db13f8ce8db5f24009
MPICH_PATCH_COMMIT=689a0869c8f58167e3b0b5db13f8ce8db5f24009

prefix=${1:-}
prepare_only=${MPI_PREPARE_ONLY:-0}
if [[ ${prepare_only} != 1 && -z ${prefix} ]]; then
    echo "usage: install-mpich.sh <prefix>" >&2
    exit 1
fi

scriptdir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repodir=$(cd "${scriptdir}/.." && pwd)
nprocs=$(getconf _NPROCESSORS_ONLN)

if [[ -n ${MPI_SRC_DIR:-} ]]; then
    mkdir -p "${MPI_SRC_DIR}"
    srcdir=$(cd "${MPI_SRC_DIR}" && pwd)
else
    srcdir=$(mktemp -d)
    trap 'rm -rf "${srcdir}"' EXIT
fi

tree=${srcdir}/mpich-${MPICH_VERSION}
# The stamp records what the prepared tree contains, so anything that changes
# that tree -- other than the bindings themselves -- belongs in its name.
stamp=${srcdir}/prepared-${MPICH_VERSION}-${MPICH_PATCH_COMMIT}

# Copy in the Fortran/C handle conversion functions. Only the contents of this
# file vary from run to run, so this happens on every run, including when the
# prepared tree came from a cache.
install_bindings() {
    cp "${repodir}/fortran/f2c_abi_mpich.c" \
       "${tree}/src/binding/abi/fortran_binding_abi.c"
}

if [[ -f ${stamp} ]]; then
    echo "Reusing the prepared source tree in ${tree}"
    install_bindings
else
    rm -rf "${tree}"

    # Download
    cd "${srcdir}"
    curl -fsSLO "https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz"
    tar xzf "mpich-${MPICH_VERSION}.tar.gz"
    cd "${tree}"

    curl -fsSL -o mpich.patch \
         "https://github.com/pmodels/mpich/commit/${MPICH_PATCH_COMMIT}.patch"
    patch -p1 <mpich.patch

    # Add the Fortran/C handle conversion functions to the ABI library
    install_bindings
    perl -pi -e 's!src/binding/abi/c_binding_abi\.c!src/binding/abi/c_binding_abi.c src/binding/abi/fortran_binding_abi.c!' \
         src/binding/abi/Makefile.mk
    # Fail loudly if upstream renamed the file we hooked into: without this the
    # bindings would be silently left out of the library, and the failure would
    # only show up much later as undefined symbols when linking a test.
    grep -q 'fortran_binding_abi\.c' src/binding/abi/Makefile.mk

    ./autogen.sh

    touch "${stamp}"
fi

if [[ ${prepare_only} == 1 ]]; then
    echo "Prepared source tree in ${tree}"
    exit 0
fi

cd "${tree}"

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

# Remove the MPI_File_{c2f,f2c} bindings, which are not part of the ABI. This
# has to happen after `configure`, which regenerates the file. Testing for the
# symbol rather than letting `patch` detect an already-applied patch keeps this
# portable to Apple's `patch`, and works whether or not the source tree was
# restored from a cache.
if grep -q 'MPI_File_c2f' src/binding/abi/io_abi.c; then
    patch -p1 <"${repodir}/fortran/mpich-disable-file.patch"
else
    echo "The MPI_File_{c2f,f2c} bindings are already disabled"
fi

# Build and install
make -j"${nprocs}"
make install

# Point the wrapper compilers at the ABI library
perl -pi -e 's!mpi_abi=no!mpi_abi=yes!' "${prefix}/bin/mpicc" "${prefix}/bin/mpicxx"

# Expose the standard ABI only
"${scriptdir}/prune-install.sh" "${prefix}" "${scriptdir}/mpich-prune.txt"
"${scriptdir}/install-mpi-header.sh" "${prefix}"
