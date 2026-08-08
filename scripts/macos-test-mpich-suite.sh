#!/bin/bash

# Run MPICH's Fortran test suite against one locally built variant. Part of
# macos-build.sh, and it fails the build if the suite differs from
# ci-scripts/suite/mpich-suite-xfail.txt -- which lists the failures that are expected
# -- in either direction. Run it on its own to iterate on a difference.
#
# Usage: scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm> [<mpich|openmpi>]
#
# The first two arguments name the mpif under test (build/mpif/<variant>). The
# third names the MPI the suite runs against and defaults to the first.
#
# Giving the other implementation is the cross test: test-mpich-suite.sh relinks
# the suite's tests against its first argument (it exports MPIF_MPI_PREFIX), and
# gates the outcome against the *runtime* MPI's expected-failure rows, so a cross
# run must report exactly what a native run of that runtime MPI reports. Each of
# the eight combinations gets its own tree, build/suite/<variant>-run-<runtime>,
# because two suite runs sharing a tree rebuild and delete executables under each
# other ("Only one suite run per variant at a time" in CLAUDE.md).
#
# Set MPIF_KEEP_TESTS=1 to keep the compiled test executables, which is what a
# debugger needs to get a backtrace out of a crashing test; see
# ci-scripts/suite/test-mpich-suite.sh for the other environment variables.

set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
takes_run_mpi=yes
source "${here}/macos-common.sh" "$@"

require_marker "${mpif_prefix}" \
    "${MPIF_SANITIZE:+MPIF_SANITIZE=${MPIF_SANITIZE} }scripts/macos-build-mpif.sh ${mpi} ${toolchain}"
require_marker "${run_mpi_prefix}" \
    "scripts/macos-install-mpi.sh ${run_mpi} ${toolchain}"

echo "Running the MPICH suite on the mpif in build/mpif/${tagged}, against ${run_mpi}:"
show_marker "${mpif_prefix}"

check_native_prefix_agrees "$("${mpif_prefix}/bin/mpifort" -showme:mpiprefix)"

export MPICH_TESTS_DIR=${MPICH_TESTS_DIR:-${suite_dir}}

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
#
# The CI step does the same, with lo instead of lo0 on Linux.
if [[ ${run_mpi} == openmpi ]]; then
    export MPIEXEC_ARGS="${MPIEXEC_ARGS:---oversubscribe --mca btl_tcp_if_include lo0}"
fi

# MPICH needs the same thing said its own way, and for a different reason. Its
# ch3:nemesis:tcp business card carries the address a spawned child connects back
# to, and GetSockInterfaceAddr in
# src/mpid/ch3/channels/nemesis/netmod/tcp/tcp_init.c works down a list to find
# it: MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE, then MPIR_CVAR_CH3_INTERFACE_HOSTNAME,
# then the name the process manager gives, which is gethostname(). With nothing
# set that last one wins, and it is only right while the machine's own name
# resolves to an address the machine actually has. Off a network where it does
# not, every spawn test dies after runtests' 180-second timeout with
#
#     init_spawn(226): spawned process group was unable to connect back to the
#         parent on port <tag#0$description#<host>$port#53122$ifname#<stale-ip>$>
#     MPIDI_Create_inter_root_communicator_connect(316): Connection timed out in
#         180 seconds
#
# and the `ifname#` in that message is the address to check: if the machine has
# no such address, this is that. Measured here with a ten-line C program that
# spawns itself, no Fortran in sight, so it is not an mpif problem; lo0 took it
# from a 180-second timeout to 0.08 seconds. As with Open MPI above, the suite is
# one machine talking to itself, so the loopback is all it ever needed.
#
# The interface, not MPIR_CVAR_CH3_INTERFACE_HOSTNAME=127.0.0.1, which also works
# -- MPICH rejects the two set together, and naming the interface leaves the
# choice of address to it. Do not use a real interface: en0 was tried here and
# fails immediately with "Named port ... does not exist" rather than timing out,
# which is a different symptom and was not chased, the loopback being the answer
# either way.
if [[ ${run_mpi} == mpich ]]; then
    export MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE="${MPIR_CVAR_NEMESIS_TCP_NETWORK_IFACE:-lo0}"
fi

exec "${repodir}/ci-scripts/suite/test-mpich-suite.sh" "${run_mpi_prefix}" "${mpif_prefix}"
