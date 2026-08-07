#!/usr/bin/env bash

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

# open-mpi/ompi#13280, the branch that added the MPI standard ABI, merged into
# `main` on 2026-08-05 as commit 003e0ca0d2d0145359c661f239633427919f4b13 --
# checked via `gh api repos/open-mpi/ompi/branches/main`, which reports that
# commit as `main`'s current tip. Pinned to that commit rather than tracking
# `main` by name, for the same reason the stamp below is keyed on this value:
# a floating ref would never invalidate the cached, prepared tree, and a
# moving upstream is exactly what the stamp exists to notice.
OMPI_COMMIT=003e0ca0d2d0145359c661f239633427919f4b13

prefix=${1:-}
prepare_only=${MPI_PREPARE_ONLY:-0}
if [[ ${prepare_only} != 1 && -z ${prefix} ]]; then
    echo "usage: install-openmpi.sh <prefix>" >&2
    exit 1
fi

scriptdir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repodir=$(cd "${scriptdir}/.." && pwd)
# See install-mpich.sh for why this is not `getconf` alone
nprocs=$(getconf _NPROCESSORS_ONLN 2>/dev/null ||
             sysctl -n hw.ncpu 2>/dev/null || echo 4)

# Fixes applied to the source tree below. Each patch says in its own preamble what
# it is, where it comes from and why it is still needed here. The one here is a
# local fix for a defect not reported upstream yet, and its preamble says so; the
# one that used to be, for the empty `MPI_Info_set` value, is upstream as of the
# commit above and was dropped. The array is expanded with the `${a[@]+...}`
# guard throughout so that being empty -- which it was, and may be again -- is not
# an unbound variable under `set -u` in bash 3.2, which is what macOS has.
patches=(
    "${scriptdir}/openmpi-fbtl-posix-aio.patch"
)

# A prefix is not usable when `make install` is done with it, only when the four
# steps after it are: until the wrapper compilers point at the ABI library, the
# implementation's own headers, modules and libraries are pruned away and the
# official ABI `mpi.h` is in place, the prefix looks complete and is wrong. That
# state is MISSING.md "An unpruned Open MPI prefix", and the window is wide --
# it spans `make install`, a `git clone` of the header from GitHub and
# everything between -- so an interrupted or failed run reaches it easily. A run
# that does not finish therefore takes the prefix with it: whatever looks for it
# next then fails saying it is not there, instead of quietly building against
# it.
scratch_srcdir=""
unfinished_prefix=""

discard() {
    if [[ -n ${scratch_srcdir} ]]; then
        rm -rf "${scratch_srcdir}"
        scratch_srcdir=""
    fi
    if [[ -n ${unfinished_prefix} ]]; then
        echo "install-openmpi.sh: did not finish; removing the half-installed" \
             "${unfinished_prefix}" >&2
        rm -rf "${unfinished_prefix}"
        unfinished_prefix=""
    fi
}

on_exit() {
    status=$?
    if [[ ${status} -eq 0 ]]; then
        if [[ -n ${scratch_srcdir} ]]; then
            rm -rf "${scratch_srcdir}"
        fi
        return
    fi
    discard
}

# Signals need their own handler, and it must not consult `$?`. An EXIT trap
# does not run at all when the shell dies of an untrapped signal, so Ctrl-C --
# the likeliest way an install ends early -- would leave the prefix behind; and
# naming INT in the EXIT trap is not enough either, because bash runs a trapped
# INT handler with a zero status and the `$?` test above then keeps the prefix.
# Both were measured rather than assumed; TERM and HUP behave differently again.
on_signal() {
    discard
    exit 1
}

trap on_exit EXIT
trap on_signal INT TERM HUP

if [[ -n ${MPI_SRC_DIR:-} ]]; then
    mkdir -p "${MPI_SRC_DIR}"
    srcdir=$(cd "${MPI_SRC_DIR}" && pwd)
else
    srcdir=$(mktemp -d)
    scratch_srcdir=${srcdir}
fi

tree=${srcdir}/ompi
# The stamp records what the prepared tree contains, so anything that changes
# that tree -- other than the bindings themselves -- belongs in its name. That
# includes the patches above and this script: without the checksum, editing
# either would silently reuse a tree prepared before the change.
stamp=${srcdir}/prepared-${OMPI_COMMIT}-$(cat "${BASH_SOURCE[0]}" ${patches[@]+"${patches[@]}"} | cksum | cut -d' ' -f1)

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
    for patch in ${patches[@]+"${patches[@]}"}; do
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

# Build and install. From here to the check at the bottom the prefix exists and
# is not yet a standard-ABI installation, which the handlers above are for.
make -j"${nprocs}"
unfinished_prefix=${prefix}
make install

# Point the wrapper compilers at the ABI library
perl -pi -e 's!-lmpi!-lmpi_abi!' "${prefix}/bin/ompi_wrapper_script"

# Expose the standard ABI only
"${scriptdir}/prune-install.sh" "${prefix}" "${scriptdir}/openmpi-prune.txt"
"${scriptdir}/install-mpi-header.sh" "${prefix}"
"${scriptdir}/check-mpi-install.sh" "${prefix}"

# The prefix is a standard-ABI installation now, and may survive the script
unfinished_prefix=""
