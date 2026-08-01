#!/bin/bash

# Run MPICH's Fortran test suite against one locally built variant. Part of
# macos-build.sh, which does not let its failures fail the build; run it on its
# own to iterate on them.
#
# Usage: scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm>
#
# Set MPIF_KEEP_TESTS=1 to keep the compiled test executables, which is what a
# debugger needs to get a backtrace out of a crashing test; see
# ci-scripts/test-mpich-suite.sh for the other environment variables.

set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${here}/macos-common.sh" "$@"

# Keep the suite next to everything else a variant needs, so that a rerun skips
# the download and the configure
export MPICH_TESTS_DIR=${MPICH_TESTS_DIR:-${repodir}/mpi/tests-${variant}}

# Two things Open MPI needs here, both overridable by setting MPIEXEC_ARGS.
#
# --oversubscribe: Open MPI refuses to oversubscribe by default, and the suite
# asks for more processes than a small machine has cores. The CI step passes
# this one too.
#
# --mca btl_tcp_if_include lo0: on macOS, Open MPI picks a non-loopback
# interface and then fails to configure the socket --
#
#     btl_tcp_endpoint.c: setsockopt(TCP_NODELAY) failed: Invalid argument (22)
#     WARNING: Open MPI failed to get or set flags on a TCP socket.
#     This may cause unpredictable behavior, and may end up hanging [...]
#
# -- and it does hang, in any test that communicates across a spawned
# intercommunicator, which is every test in the spawn directories. Each one then
# burns runtests' 180-second timeout, so the suite appears stuck rather than
# failing. Pinning TCP to the loopback interface avoids it. This is Open MPI
# talking to itself on one machine, so nothing else is reachable anyway.
#
# Not an mpif problem: a pure C program that spawns and then sends across the
# intercommunicator hangs the same way, with no Fortran involved.
if [[ ${mpi} == openmpi ]]; then
    export MPIEXEC_ARGS="${MPIEXEC_ARGS:---oversubscribe --mca btl_tcp_if_include lo0}"
fi

exec "${repodir}/ci-scripts/test-mpich-suite.sh" "${mpi_prefix}" "${mpif_prefix}"
