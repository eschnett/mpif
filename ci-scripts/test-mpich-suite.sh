#!/bin/bash

# Run the Fortran part of MPICH's own MPI test suite against an installed MPI
# and an installed mpif.
#
# MPICH ships around 300 Fortran tests covering all three interfaces mpif
# implements -- `include 'mpif.h'`, `use mpi` and `use mpi_f08` -- and turns all
# of them off when its own build targets the standard ABI ("only a subset of
# tests work with (experimental) MPI-5 ABI" in test/mpi/configure.ac), because
# the ABI has no Fortran bindings. That is precisely the gap mpif fills, so this
# suite tests mpif far more broadly than test/ does. The C tests are MPICH's own
# business and are left alone here.
#
# The suite lives in the MPICH release tarball but is a standalone autoconf
# project that builds against any MPI, so this works for OpenMPI just as well.
#
# Usage: test-mpich-suite.sh <mpi-prefix> <mpif-prefix> [<language>...]
#
#   <language> is one or more of f77, f90, f08; all three by default.
#
# Environment:
#   MPICH_TESTS_DIR  where to download and build the suite (default: a temporary
#                    directory, removed afterwards). Keeping it avoids
#                    re-downloading and re-configuring on every run.
#   MPIEXEC_MAXNP    largest number of processes to give a test (default 4).
#                    Tests asking for more are skipped rather than
#                    oversubscribing a CI runner.
#   MPIEXEC_ARGS     extra arguments for mpiexec, e.g. `--oversubscribe` for
#                    Open MPI when MPIEXEC_MAXNP exceeds the available cores.

set -euo pipefail

mpi_prefix=${1:-}
mpif_prefix=${2:-}
if [[ -z ${mpi_prefix} || -z ${mpif_prefix} ]]; then
    echo "usage: $(basename "$0") <mpi-prefix> <mpif-prefix> [f77|f90|f08 ...]" >&2
    exit 1
fi
shift 2
languages=("$@")
if [[ ${#languages[@]} -eq 0 ]]; then
    languages=(f77 f90 f08)
fi

scriptdir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
nprocs=$(getconf _NPROCESSORS_ONLN)
maxnp=${MPIEXEC_MAXNP:-4}

# Take the version from the install script, so the suite always matches the
# MPICH we know how to build rather than drifting away from it
version=$(sed -n 's/^MPICH_VERSION=//p' "${scriptdir}/install-mpich.sh")
if [[ -z ${version} ]]; then
    echo "error: cannot read MPICH_VERSION from ${scriptdir}/install-mpich.sh" >&2
    exit 1
fi

if [[ -n ${MPICH_TESTS_DIR:-} ]]; then
    mkdir -p "${MPICH_TESTS_DIR}"
    workdir=$(cd "${MPICH_TESTS_DIR}" && pwd)
else
    workdir=$(mktemp -d)
    trap 'rm -rf "${workdir}"' EXIT
fi

tarball=${workdir}/mpich-${version}.tar.gz
suite=${workdir}/mpich-${version}/test/mpi

if [[ ! -f ${tarball} ]]; then
    curl -fsSL -o "${tarball}" \
         "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz"
fi
if [[ ! -d ${suite} ]]; then
    tar xzf "${tarball}" -C "${workdir}" "mpich-${version}/test/mpi"
fi

cd "${suite}"

# Released tarballs ship a generated `configure`; a tree straight from git does not
if [[ ! -x configure ]]; then
    echo "no generated configure in the suite; running autoreconf"
    autoreconf -ifv -I confdb
fi

# `--enable-strictmpi` drops the tests that use MPICH extensions, which mpif
# does not claim to provide. Fortran is enabled automatically, by detecting the
# compilers; there is no --enable-f08. C++ is off because mpif has nothing to do
# with it and its wrappers may well have been pruned away.
if [[ ! -f Makefile ]]; then
    ./configure \
        --enable-strictmpi \
        --disable-cxx \
        MPICC="${mpi_prefix}/bin/mpicc" \
        MPIF77="${mpif_prefix}/bin/mpifort" \
        MPIFC="${mpif_prefix}/bin/mpifort" \
        MPIEXEC="${mpi_prefix}/bin/mpiexec"
fi

# `runtests` compiles each test on demand, runs it, and prints a summary -- but
# exits 0 whether or not tests failed, so the summary is what has to be checked.
status=0
summaries=()
for language in "${languages[@]}"; do
    if [[ ! -d ${language} ]]; then
        echo "error: the suite has no ${language} directory" >&2
        exit 1
    fi

    echo "=== ${language}"
    log=${workdir}/runtests-${language}.log
    (
        cd "${language}"
        ../runtests \
            -tests=testlist \
            -mpiexec="${mpi_prefix}/bin/mpiexec" \
            ${MPIEXEC_ARGS:+-mpiexecarg="${MPIEXEC_ARGS}"} \
            -maxnp="${maxnp}" \
            -showprogress
    ) 2>&1 | tee "${log}"

    # `|| true` because a missing summary is a result to report, not a reason to
    # abort: under `set -e` with `pipefail`, grep finding nothing would otherwise
    # end the script here and skip the remaining languages
    summary=$(grep -E "tests (failed out of|passed)" "${log}" | tail -1 || true)
    summaries+=("${language}: ${summary:-no summary -- see ${log}}")
    case ${summary} in
        *"tests passed"*) ;;
        *) status=1 ;;
    esac
done

echo
echo "=== MPICH Fortran test suite, ${version}, ${nprocs} cores, up to ${maxnp} processes per test"
printf '  %s\n' "${summaries[@]}"
exit ${status}
