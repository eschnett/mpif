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
#   CXX              C++ compiler for the suite's configure to satisfy libtool
#                    with (default: c++). Nothing is compiled with it.
#   MPICH_TESTS_DIR  where to download and build the suite (default: a temporary
#                    directory, removed afterwards). Only the downloaded tarball
#                    is reused: the suite itself is unpacked, configured and
#                    built from scratch on every run, so keeping this directory
#                    saves the download and nothing else.
#   MPIEXEC_MAXNP    largest number of processes to give a test (default 4).
#                    Tests asking for more are skipped rather than
#                    oversubscribing a CI runner.
#   MPIEXEC_ARGS     extra arguments for mpiexec, e.g. `--oversubscribe` for
#                    Open MPI when MPIEXEC_MAXNP exceeds the available cores.
#   MPIF_KEEP_TESTS  if non-empty, keep each test executable after it has run
#                    instead of letting `runtests` delete it, and keep the work
#                    directory too. Set this before chasing a crash: the
#                    executable is what a debugger needs to turn the suite's
#                    "test failed" into a backtrace, and by default it is gone
#                    by the time the summary is printed. What is kept lasts
#                    until the next run, which unpacks the suite again.

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
    # Keeping the executables is pointless if the directory holding them goes
    # away when the script exits
    if [[ -z ${MPIF_KEEP_TESTS:-} ]]; then
        trap 'rm -rf "${workdir}"' EXIT
    fi
fi

tarball=${workdir}/mpich-${version}.tar.gz
suite=${workdir}/mpich-${version}/test/mpi

if [[ ! -f ${tarball} ]]; then
    curl -fsSL -o "${tarball}" \
         "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz"
fi
# Always unpack a fresh copy. `runtests` rebuilds a test only when its
# executable is missing, so a tree left from an earlier run relinks -- or simply
# reruns -- executables built against an older mpif or an older MPI, and the
# result is a pass or a failure that says nothing about what is installed now.
# Selectively deleting the stale pieces is what this used to ask of the caller,
# and it is easy to get wrong: leaving libtool's `.lo` stamps behind while
# removing the `.o` files they stand for breaks `util/libmtest_f77.la` with
# `ar: .libs/mtest_f77.o: No such file or directory`. Unpacking again costs a
# few seconds, and `configure` a couple of minutes.
rm -rf "${workdir}/mpich-${version}"
tar xzf "${tarball}" -C "${workdir}" "mpich-${version}/test/mpi"

cd "${suite}"

# Released tarballs ship a generated `configure`; a tree straight from git does not
if [[ ! -x configure ]]; then
    echo "no generated configure in the suite; running autoreconf"
    autoreconf -ifv -I confdb
fi

# `--enable-strictmpi` drops the tests that use MPICH extensions, which mpif
# does not claim to provide. Fortran is enabled automatically, by detecting the
# compilers; there is no --enable-f08. C++ is off because mpif has nothing to do
# with it.
#
# MPICXX still has to be set, even with --disable-cxx: libtool configures a C++
# tag regardless, and left to itself the suite runs AC_PATH_PROG for `mpicxx`
# and assigns whatever it finds on PATH to CXX. That is easily an unrelated
# MPI's wrapper, or one belonging to an MPI built without C++ support, and then
# `$CXX -E` fails, autoconf falls back to /lib/cpp, and configure dies in the
# C++ preprocessor sanity check. Point it at the plain C++ compiler instead;
# nothing is compiled with it.
./configure \
    --enable-strictmpi \
    --disable-cxx \
    MPICC="${mpi_prefix}/bin/mpicc" \
    MPICXX="${CXX:-c++}" \
    MPIF77="${mpif_prefix}/bin/mpifort" \
    MPIFC="${mpif_prefix}/bin/mpifort" \
    MPIEXEC="${mpi_prefix}/bin/mpiexec"

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
        # `-mpiexecarg=` is not a command line option -- it is a key recognised
        # inside testlist files. Extra mpiexec arguments reach `runtests` through
        # the environment instead, as a single string that it splices into the
        # command line verbatim.
        if [[ -n ${MPIEXEC_ARGS:-} ]]; then
            export MPITEST_MPIEXECARG="${MPIEXEC_ARGS}"
        fi
        # Run mpiexec through a filter that drops launcher banners; see
        # ci-scripts/mpiexec-filter.sh. The suite treats anything the launcher
        # prints as unexpected test output.
        export MPIF_REAL_MPIEXEC="${mpi_prefix}/bin/mpiexec"
        # `runtests` has no command line option for this -- it unlinks the
        # executable and its .o right after each test unless MPITEST_CLEANUP
        # says otherwise
        if [[ -n ${MPIF_KEEP_TESTS:-} ]]; then
            export MPITEST_CLEANUP=0
        fi
        ../runtests \
            -tests=testlist \
            -mpiexec="${scriptdir}/mpiexec-filter.sh" \
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
if [[ -n ${MPIF_KEEP_TESTS:-} ]]; then
    echo "  test executables kept under ${suite}"
fi
exit ${status}
