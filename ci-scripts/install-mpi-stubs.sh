#!/usr/bin/env bash

# Build and install the MPI Forum's ABI stub implementation as a prefix mpif
# can be configured against, extended with the Fortran/C handle conversion
# functions its library does not provide; see fortran/f2c_abi_stubs.c.
#
# **Nothing built against this prefix can run.** Every MPI entry point in the
# stub library calls abort(). What it gives is the one thing mpif's configure
# stage insists on -- an MPI whose `mpi.h` is the official ABI header and whose
# library is named `libmpi_abi` -- in seconds, with any C compiler, on any
# libc. That is what makes the compile-only CI stage possible: mpif's library
# links no MPI at all (see "Choosing the MPI at run time" in CODE.md), so a
# library that cannot run is enough to compile and link everything.
#
# The clone is pinned to the same commit install-mpi-header.sh's is, read out of
# that script by name -- the two take the same header from the same repository,
# and pinning one while the other floated would be worse than either.
#
# Usage: install-mpi-stubs.sh <prefix>
#
# Environment:
#   CC   C compiler to build the stub library with (default: system compiler)

set -euo pipefail

prefix=${1:?usage: install-mpi-stubs.sh <prefix>}

repodir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

workdir=$(mktemp -d)
trap 'rm -rf "${workdir}"' EXIT

commit=$(sed -n 's/^MPI_ABI_STUBS_COMMIT=//p' \
    "${repodir}/ci-scripts/install-mpi-header.sh")
if [[ -z ${commit} ]]; then
    echo "install-mpi-stubs.sh: cannot read MPI_ABI_STUBS_COMMIT from" >&2
    echo "                      ci-scripts/install-mpi-header.sh" >&2
    exit 1
fi

git clone --quiet --depth 1 \
    https://github.com/mpi-forum/mpi-abi-stubs "${workdir}/mpi-abi-stubs"
git -C "${workdir}/mpi-abi-stubs" fetch --quiet --depth 1 origin "${commit}"
git -C "${workdir}/mpi-abi-stubs" checkout --quiet "${commit}"

# Both sources in one library. The copy into the stub tree is what
# install-mpich.sh does with f2c_abi_mpich.c, and here it also settles the
# `#include "mpi.h"`, which resolves beside the including file. SOURCE_C is a
# cache variable the stubs project passes straight to add_library, which splits
# a `;`-separated value the way CMake splits any list.
#
# The library is built against the *unpatched* header in the clone, and the
# patch goes on the installed copy afterwards, where install-mpi-header.sh puts
# it. So f2c_abi_stubs.c compiles against a header that declares no Fortran
# anything, and carries the two typedefs it needs itself.
cp "${repodir}/fortran/f2c_abi_stubs.c" "${workdir}/mpi-abi-stubs/"

cmake -S "${workdir}/mpi-abi-stubs" -B "${workdir}/build" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${prefix}" \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DSOURCE_C="${workdir}/mpi-abi-stubs/mpilib.c;${workdir}/mpi-abi-stubs/f2c_abi_stubs.c"
cmake --build "${workdir}/build" --parallel
cmake --install "${workdir}/build"

patch -d "${prefix}/include" -p1 <"${repodir}/fortran/mpi.h.patch"

# The two things the prefix is asked for later, checked here rather than in
# whatever fails next: find_package(MPI) reads the wrapper, and mpif's
# CMakeLists.txt requires a library named libmpi_abi among what it reports.
"${prefix}/bin/mpicc" -show-link-info
case $("${prefix}/bin/mpicc" -show-link-info) in
    *-lmpi_abi*) ;;
    *) echo "install-mpi-stubs.sh: ${prefix}/bin/mpicc does not report -lmpi_abi" >&2
       exit 1 ;;
esac
ls "${prefix}"/lib/libmpi_abi.*

echo "install-mpi-stubs.sh: installed the ABI stubs into ${prefix} (cannot run anything)"
