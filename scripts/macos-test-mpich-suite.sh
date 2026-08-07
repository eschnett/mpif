#!/bin/bash

# Run MPICH's Fortran test suite against one locally built variant. Part of
# macos-build.sh, and it fails the build if the suite differs from
# ci-scripts/suite/mpich-suite-xfail.txt -- which lists the failures that are expected
# -- in either direction. Run it on its own to iterate on a difference.
#
# Usage: scripts/macos-test-mpich-suite.sh <mpich|openmpi> <gcc|llvm>
#
# The variant arguments name the mpif under test (mpi/mpif-<variant>); the MPI
# the suite runs against is by default the one that installation remembers,
# read back from its wrapper (-showme:mpiprefix) rather than respecified here.
#
# Set MPIF_RUN_MPI=<mpich|openmpi> to run the suite against the other
# implementation instead -- the cross test. test-mpich-suite.sh relinks the
# suite's tests against its first argument (it exports MPIF_MPI_PREFIX), and
# gates the outcome against the runtime MPI's expected-failure rows, so a
# cross run must report exactly what a native run of that runtime MPI reports.
#
# Set MPIF_KEEP_TESTS=1 to keep the compiled test executables, which is what a
# debugger needs to get a backtrace out of a crashing test; see
# ci-scripts/suite/test-mpich-suite.sh for the other environment variables.

set -euo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${here}/macos-common.sh" "$@"

if [[ -n ${MPIF_RUN_MPI:-} ]]; then
    run_mpi=${MPIF_RUN_MPI}
    case ${run_mpi} in
        mpich | openmpi) ;;
        *)
            echo "error: MPIF_RUN_MPI must be mpich or openmpi, not '${run_mpi}'" >&2
            exit 1
            ;;
    esac
    run_mpi_prefix=${repodir}/mpi/${run_mpi}-${toolchain}
    # A cross run gets its own tree: MPICH_TESTS_DIR names the *pairing*, not
    # just the variant, because two suite runs sharing a tree rebuild and
    # delete executables under each other ("Only one suite run per variant at
    # a time" in CLAUDE.md), and a cross run may well run beside a native one.
    export MPICH_TESTS_DIR=${MPICH_TESTS_DIR:-${repodir}/mpi/tests-${variant}-run-${run_mpi}}
else
    run_mpi=${mpi}
    run_mpi_prefix=$("${mpif_prefix}/bin/mpifort" -showme:mpiprefix)
    # Keep the suite next to everything else a variant needs, so that a rerun
    # skips the download and the configure
    export MPICH_TESTS_DIR=${MPICH_TESTS_DIR:-${repodir}/mpi/tests-${variant}}
fi

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
