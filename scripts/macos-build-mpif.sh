#!/bin/bash

# Configure, build and install mpif against an MPI installed by
# scripts/macos-install-mpi.sh.
#
# Usage: scripts/macos-build-mpif.sh <mpich|openmpi> <gcc|llvm>
#
# Environment:
#   MPIF_SANITIZE  build with these sanitizers (`address`, or a list such as
#                  `address,undefined`) into a build tree and prefix of their
#                  own, leaving the ordinary build alone. See
#                  scripts/macos-common.sh.
#   MPIF_REBUILD   rebuild even though the prefix is already marked complete.
#   MPIF_ENABLE_CFI=0  force the ignore_tkr fallback on a toolchain whose
#                  TS 29113 probe would pass, which is how that branch stays
#                  testable. The prefix is the ordinary one, so rebuild with
#                  MPIF_REBUILD=1 (and without this) afterwards.
#
# The MPI has to be installed already; this refuses to start otherwise rather
# than configuring against a prefix that is missing or half-written.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

require_marker "${mpi_prefix}" "scripts/macos-install-mpi.sh ${mpi} ${toolchain}"

if marker_present "${mpif_prefix}" && [[ -z ${rebuild} ]]; then
    echo "mpif is already installed in build/mpif/${tagged}:"
    show_marker "${mpif_prefix}"
    echo "Set MPIF_REBUILD=1 to build it again."
    exit 0
fi

echo "Building mpif against the MPI in build/mpi/${variant}:"
show_marker "${mpi_prefix}"

# mpif is only mpif if the MPI underneath it exposes the standard ABI and
# nothing else. The install scripts now take a half-installed prefix away with
# them rather than leaving it (see MISSING.md "An unpruned Open MPI prefix"),
# but a prefix written some other way -- `make install` by hand is the one that
# happened -- still looks complete, and building against it produces an mpif
# that is wrong without failing. One compile settles it.
if ! abi_check=$("${repodir}/ci-scripts/check-mpi-install.sh" "${mpi_prefix}" 2>&1); then
    echo "${abi_check}" >&2
    echo "error: ${mpi_prefix} does not expose the standard ABI." >&2
    echo "       Reinstall it: scripts/macos-install-mpi.sh ${mpi} ${toolchain}" >&2
    exit 1
fi

rm -rf "${build}" "${mpif_prefix}"
cmake \
    -S "${repodir}" \
    -B "${build}" \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER="${CC}" \
    -DCMAKE_Fortran_COMPILER="${FC}" \
    -DCMAKE_INSTALL_PREFIX="${mpif_prefix}" \
    -DMPI_HOME="${mpi_prefix}" \
    -DMPIF_SANITIZE="${sanitize}" \
    -DMPIF_ENABLE_CFI="${MPIF_ENABLE_CFI:-ON}"
cmake --build "${build}" --parallel
cmake --install "${build}"

# A sanitizer build that quietly came out uninstrumented passes every test, so
# nothing downstream would notice. Ask the object code instead.
if [[ -n ${sanitize} ]]; then
    bash "${repodir}/ci-scripts/check-sanitizer-build.sh" "${mpif_prefix}"
fi

# Last, after the sanitizer check, so the marker means the whole stage finished.
# The MPI's own marker line goes in it because a reinstall at the same path can
# change what libmpi_abi's install name says while the path itself is unchanged,
# and then this mpif is stale without any path having moved.
write_marker "${mpif_prefix}" "mpif: ${mpi}, ${toolchain}${sanitize:+, sanitize=${sanitize}}" \
    "mpi      build/mpi/${variant} $(sed -n 2p "${mpi_prefix}/install-complete")"
