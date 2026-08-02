#!/bin/bash

# Build and install OpenMPI with the MPI standard ABI, extended with the
# Fortran/C handle conversion functions (`MPI_Comm_c2f` and friends) that
# OpenMPI's ABI library does not yet provide; see fortran/f2c_abi_openmpi.c.
#
# The resulting installation exposes the standard ABI only: OpenMPI's own
# `mpi.h`, Fortran modules and non-ABI libraries are removed, and the official
# ABI `mpi.h` is installed in their place.
#
# Usage: install-openmpi.sh [<prefix>]
#
# Environment:
#   CC, CXX, FC       compilers to build OpenMPI with (default: system compilers)
#   HWLOC_PREFIX      where hwloc is installed, if not in a default location
#                     (e.g. /opt/local for MacPorts, /opt/homebrew for Homebrew)
#   MPI_SRC_DIR       where to download and build. Defaults to a temporary
#                     directory that is removed afterwards. If it already holds
#                     a tree prepared for this commit, the download and
#                     `autogen.pl` steps are skipped -- this is what CI caches.
#   MPI_PREPARE_ONLY  set to 1 to only prepare the source tree (download,
#                     patches, bindings, autogen) and stop before configuring;
#                     <prefix> is then not needed.

set -euo pipefail

# The head of https://github.com/open-mpi/ompi/pull/13280, the branch that adds
# the MPI standard ABI. It is a pull request rather than a branch of the main
# repository, so the commit is fetched by hash below rather than by name.
OMPI_COMMIT=d0346f672a7698f32e9f346b5ca8681ab7887b36

prefix=${1:-}
prepare_only=${MPI_PREPARE_ONLY:-0}
if [[ ${prepare_only} != 1 && -z ${prefix} ]]; then
    echo "usage: install-openmpi.sh <prefix>" >&2
    exit 1
fi

scriptdir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repodir=$(cd "${scriptdir}/.." && pwd)
nprocs=$(getconf _NPROCESSORS_ONLN)

# Upstream fixes that have not reached the ABI branch yet, applied to the source
# tree below. Each patch says in its own preamble what it is, where it comes from
# and why it is still needed here.
patches=(
    "${scriptdir}/openmpi-info-set-empty-value.patch"
)

if [[ -n ${MPI_SRC_DIR:-} ]]; then
    mkdir -p "${MPI_SRC_DIR}"
    srcdir=$(cd "${MPI_SRC_DIR}" && pwd)
else
    srcdir=$(mktemp -d)
    trap 'rm -rf "${srcdir}"' EXIT
fi

tree=${srcdir}/ompi
# The stamp records what the prepared tree contains, so anything that changes
# that tree -- other than the bindings themselves -- belongs in its name. That
# includes the patches above and this script: without the checksum, editing
# either would silently reuse a tree prepared before the change.
stamp=${srcdir}/prepared-${OMPI_COMMIT}-$(cat "${BASH_SOURCE[0]}" "${patches[@]}" | cksum | cut -d' ' -f1)

# Copy in the Fortran/C handle conversion functions. Only the contents of this
# file vary from run to run, so this happens on every run, including when the
# prepared tree came from a cache.
install_bindings() {
    cp "${repodir}/fortran/f2c_abi_openmpi.c" "${tree}/ompi/mpi/c/f2c_abi.c"
}

if [[ -f ${stamp} ]]; then
    echo "Reusing the prepared source tree in ${tree}"
    install_bindings
else
    rm -rf "${tree}"

    # Download
    git clone --quiet --depth 1 https://github.com/open-mpi/ompi.git "${tree}"
    cd "${tree}"
    git fetch --quiet --depth 1 origin "${OMPI_COMMIT}"
    git checkout --quiet "${OMPI_COMMIT}"
    git submodule update --init --recursive

    # Carry the upstream fixes the ABI branch does not have yet. `git apply`
    # rather than `patch`, because it refuses to apply with fuzz: once the
    # branch picks a fix up, or moves the code it touches, the patch stops
    # applying and says so here rather than landing somewhere unintended.
    for patch in "${patches[@]}"; do
        echo "Applying $(basename "${patch}")"
        git apply "${patch}"
    done

    # Add the Fortran/C handle conversion functions to the ABI library
    install_bindings
    perl -pi -e 's!comm_fromint_abi\.c!f2c_abi.c comm_fromint_abi.c!' \
         ompi/mpi/c/Makefile_abi.include
    # Fail loudly if upstream renamed the file we hooked into: without this the
    # bindings would be silently left out of the library, and the failure would
    # only show up much later as undefined symbols when linking a test.
    grep -q 'f2c_abi\.c' ompi/mpi/c/Makefile_abi.include

    ./autogen.pl

    touch "${stamp}"
fi

if [[ ${prepare_only} == 1 ]]; then
    echo "Prepared source tree in ${tree}"
    exit 0
fi

cd "${tree}"

# Configure
configure_flags=(
    --enable-mpi-fortran=yes
    --enable-mpi1-compatibility=yes
    --enable-script-wrapper-compilers
    --enable-shared=yes
    --enable-standard-abi=yes
    --enable-static=no
    --prefix="${prefix}"
    "--with-hwloc${HWLOC_PREFIX:+=${HWLOC_PREFIX}}"
    --with-libevent=internal
)
./configure "${configure_flags[@]}"

# Build and install
make -j"${nprocs}"
make install

# Point the wrapper compilers at the ABI library
perl -pi -e 's!-lmpi!-lmpi_abi!' "${prefix}/bin/ompi_wrapper_script"

# Expose the standard ABI only
"${scriptdir}/prune-install.sh" "${prefix}" "${scriptdir}/openmpi-prune.txt"
"${scriptdir}/install-mpi-header.sh" "${prefix}"
"${scriptdir}/check-mpi-install.sh" "${prefix}"
