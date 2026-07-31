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

    # libtool only believes that GNU, Intel and NAG Fortran compilers can build
    # shared libraries on macOS: `_LT_DARWIN_LINKER_FEATURES` in libtool.m4 has
    # `case $cc_basename in ifort*|nagfor*) _lt_dar_can_shared=yes ;; *)
    # _lt_dar_can_shared=$GCC ;; esac`, and for the Fortran tag `GCC` is
    # `ac_cv_fc_compiler_gnu`. flang is neither GNU nor on the list, so libtool
    # concludes `ld_shlibs_FC=no` -- and since `can_build_shared` is *untagged*,
    # that switches off shared libraries for the entire build, the C libraries
    # included. MPICH then installs static libraries only, and the installation
    # is unusable here because pruning removes the non-ABI libraries that
    # libmpi_abi.a needs symbols from.
    #
    # Patch the generated `configure` rather than confdb/libtool.m4, which
    # `autogen.sh` overwrites with the system libtool's copy.
    #
    # Being on that list is necessary but not sufficient: libtool then links
    # Fortran shared libraries with `$FC -dynamiclib ... -install_name <name>`,
    # and flang understands neither option (it wants `-shared`, and linker
    # options have to go through `-Wl,`). Translate those, in the Fortran tags
    # only -- clang accepts them, so the C and C++ tags must keep them as they
    # are. This is the same flang limitation that CMakeLists.txt works around
    # for mpif's own library.
    if [[ $(uname) == Darwin ]]; then
        perl -pi -e 's!\bifort\*\|nagfor\*\)!ifort*|nagfor*|flang*)!g' configure
        grep -q 'ifort\*|nagfor\*|flang\*)' configure

        perl -pi -e 'if (/^\s*archive(_expsym)?_cmds_(FC|F77)=/) {
                         s/-dynamiclib/-shared/g;
                         s/-install_name /-Wl,-install_name,/g;
                     }
                     if (/^\s*module_cmds_(FC|F77)=/) {
                         s/ -bundle/ -Wl,-bundle/g;
                     }' configure
        # The Fortran tags must be free of the options flang rejects, and the C
        # tag must still have them.
        ! grep -qE '^\s*archive(_expsym)?_cmds_(FC|F77)=.*(-dynamiclib|-install_name )' configure
        grep -q -- '-dynamiclib' configure
    fi

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
    # Explicit, because MPICH does not default to shared libraries everywhere:
    # on macOS it builds static ones only, and the resulting installation is
    # unusable here, since pruning removes the non-ABI libraries that the
    # static libmpi_abi.a still needs symbols from.
    --enable-shared=yes
    --enable-static=no
    --prefix="${prefix}"
    --with-device=ch3
    "--with-hwloc${HWLOC_PREFIX:+=${HWLOC_PREFIX}}"
)
./configure "${configure_flags[@]}"

# Stop here if libtool decided against shared libraries anyway, rather than
# building for many minutes and failing much later with a confusing error.
if ! grep -q '^build_libtool_libs=yes' libtool; then
    echo "error: configure did not enable shared libraries:" >&2
    grep '^build_libtool_libs=\|^can_build_shared=' libtool >&2
    echo "error: look for 'supports shared libraries' in ${tree}/config.log;" >&2
    echo "error: one language's linker check turns them off for all of them" >&2
    exit 1
fi

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
"${scriptdir}/check-mpi-install.sh" "${prefix}"
