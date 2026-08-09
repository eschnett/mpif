#!/usr/bin/env bash

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
# Upstream fixes that are on `main` but not in the release above, fetched from
# https://github.com/pmodels/mpich/commit/<commit>.patch and applied in order:
# - 689a0869: the fix behind mpich-abi-util-one-copy.patch, in the form that
#   applies to files this release still generates differently.
# - bb167f1c: "config: actually apply libmpi_abi.so version-info". The ABI
#   library's `-version-info 1:0:0` never reached libtool (a misspelled m4
#   macro, `libmpi_abi_so_verion_m4`, and a missing AC_SUBST), so libmpi_abi
#   was installed as libmpi_abi.so.0 / libmpi_abi.0.dylib instead of the
#   conventional libmpi_abi.so.1 that every implementation of ABI version 1
#   exposes so applications can switch implementations without relinking.
#   Open MPI already ships libmpi_abi.so.1; without this fix the two versioned
#   names disagree and the loader cannot substitute one MPI for the other.
MPICH_PATCH_COMMITS=(
    689a0869c8f58167e3b0b5db13f8ce8db5f24009
    bb167f1c850c85705733e8aa35d7d9810b2947b6
)

prefix=${1:-}
prepare_only=${MPI_PREPARE_ONLY:-0}
if [[ ${prepare_only} != 1 && -z ${prefix} ]]; then
    echo "usage: install-mpich.sh <prefix>" >&2
    exit 1
fi

scriptdir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repodir=$(cd "${scriptdir}/.." && pwd)
# glibc and macOS answer `getconf _NPROCESSORS_ONLN`; FreeBSD's getconf(1) does
# not document it, so fall back to the sysctl that does, and to a plausible
# number rather than to an empty `-j`, which would be an unbounded build.
nprocs=$(getconf _NPROCESSORS_ONLN 2>/dev/null ||
             sysctl -n hw.ncpu 2>/dev/null || echo 4)

# Fixes applied to the source tree below. Each patch says in its own preamble
# what it is, where it comes from and why it is still needed here. The first is an
# upstream fix that is on `main` but not in the release above -- the first commit in
# ${MPICH_PATCH_COMMITS} is the same idea, and this is the one whose upstream commit
# does not apply to this release. The others are local fixes, and their preambles
# say where each stands: f90-datatypes is pmodels/mpich#7929 and type-get-contents
# is #7930, both open upstream; darwin-weak is not reported yet.
#
# These are applied before `autogen.sh` runs, so a patch against a file that
# autogen regenerates would be overwritten without a word. That is why
# type-get-contents patches `maint/local_python/binding_c.py` rather than the
# `src/binding/abi/c_binding_abi.c` it generates.
patches=(
    "${scriptdir}/mpich-abi-util-one-copy.patch"
    "${scriptdir}/mpich-abi-f90-datatypes.patch"
    "${scriptdir}/mpich-abi-type-get-contents.patch"
    "${scriptdir}/mpich-abi-darwin-weak.patch"
)

# A prefix is not usable when `make install` is done with it, only when the
# steps after it are: until the wrapper compilers select the ABI, the
# implementation's own headers, modules and libraries are pruned away and the
# official ABI `mpi.h` is in place, the prefix looks complete and is wrong. That
# state is MISSING.md "An unpruned Open MPI prefix" -- found on Open MPI, but
# this script has the same window, spanning `make install`, a `git clone` of the
# header from GitHub and everything between. A run that does not finish
# therefore takes the prefix with it: whatever looks for it next then fails
# saying it is not there, instead of quietly building against it.
scratch_srcdir=""
unfinished_prefix=""

discard() {
    if [[ -n ${scratch_srcdir} ]]; then
        rm -rf "${scratch_srcdir}"
        scratch_srcdir=""
    fi
    if [[ -n ${unfinished_prefix} ]]; then
        echo "install-mpich.sh: did not finish; removing the half-installed" \
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
# Both were measured rather than assumed; see install-openmpi.sh, which has the
# same block.
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

tree=${srcdir}/mpich-${MPICH_VERSION}
# The stamp records what the prepared tree contains, so anything that changes
# that tree -- other than the bindings themselves -- belongs in its name. That
# includes the patches above, the upstream commits fetched by URL (their hashes
# are part of this script's text) and this script itself, since it patches the
# tree too: without the checksum, editing any of them would silently reuse a
# tree prepared by an older version.
stamp=${srcdir}/prepared-${MPICH_VERSION}-$(cat "${BASH_SOURCE[0]}" "${patches[@]}" | cksum | cut -d' ' -f1)

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

    for commit in "${MPICH_PATCH_COMMITS[@]}"; do
        curl -fsSL -o "mpich-${commit}.patch" \
             "https://github.com/pmodels/mpich/commit/${commit}.patch"
        patch -p1 <"mpich-${commit}.patch"
    done

    # Carry the upstream fixes this release does not have yet. `git apply`
    # rather than `patch`, because it refuses to apply with fuzz: once a release
    # picks a fix up, or moves the code it touches, the patch stops applying and
    # says so here rather than landing somewhere unintended. This runs before
    # the bindings are hooked in below, which edits one of the same files.
    for patch in "${patches[@]}"; do
        echo "Applying $(basename "${patch}")"
        git apply "${patch}"
    done

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
    # Being on that list only restores shared libraries; the link commands
    # themselves are adjusted after `configure`, where the Fortran compiler is
    # known. gfortran matches neither entry in the case statement and so is
    # unaffected by this.
    if [[ $(uname) == Darwin ]]; then
        perl -pi -e 's!\bifort\*\|nagfor\*\)!ifort*|nagfor*|flang*)!g' configure
        grep -q 'ifort\*|nagfor\*|flang\*)' configure
    fi

    touch "${stamp}"
fi

if [[ ${prepare_only} == 1 ]]; then
    echo "Prepared source tree in ${tree}"
    exit 0
fi

cd "${tree}"

# libtool drives the Fortran compiler with clang's Darwin options when linking a
# shared library (`-dynamiclib`, a bare `-install_name`, `-compatibility_version`
# ...), which flang rejects. Put a wrapper in front of it that rewrites them; see
# ci-scripts/flang-darwin-shim.sh for why that is done here rather than by patching
# libtool's command templates. Deciding on the compiler's behaviour rather than
# its name leaves gfortran alone and retires this once flang accepts the options.
if [[ $(uname) == Darwin && -n ${FC:-} ]]; then
    probe=darwin-fortran-probe
    rm -rf "${probe}"
    mkdir "${probe}"
    printf 'end\n' >"${probe}/probe.f90"
    if ! (cd "${probe}" &&
              ${FC} -dynamiclib -install_name @rpath/libprobe.dylib \
                    -o libprobe.dylib probe.f90) >/dev/null 2>&1; then
        echo "${FC} rejects Darwin's linker options; wrapping it for libtool"
        export FLANG_DARWIN_SHIM_FC=${FC}
        export FC=${scriptdir}/flang-darwin-shim.sh
    fi
    rm -rf "${probe}"
fi

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

# Build and install. `V=1` because automake's silent rules hide the libtool
# link commands, and those are exactly what one needs to see when a compiler
# rejects an option that libtool chose for it.
make V=1 -j"${nprocs}"
# From here to the check at the bottom the prefix exists and is not yet a
# standard-ABI installation, which the handlers above are for.
unfinished_prefix=${prefix}
make install

# Point the wrapper compilers at the ABI library
perl -pi -e 's!mpi_abi=no!mpi_abi=yes!' "${prefix}/bin/mpicc" "${prefix}/bin/mpicxx"

# Expose the standard ABI only
"${scriptdir}/prune-install.sh" "${prefix}" "${scriptdir}/mpich-prune.txt"
"${scriptdir}/install-mpi-header.sh" "${prefix}"
"${scriptdir}/check-mpi-install.sh" "${prefix}"

# The prefix is a standard-ABI installation now, and may survive the script
unfinished_prefix=""
