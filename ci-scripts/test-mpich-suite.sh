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
# Some of its tests are expected to fail -- on blockers in the implementations,
# on features mpif does not have yet, and on tests that codify their own
# implementation rather than the standard. ci-scripts/mpich-suite-xfail.txt says
# which, and this script fails only on a difference from that list, in either
# direction. See the head of that file for the format and the reasoning.
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
#   MPIF_SUITE_VARIANT
#                    which row of ci-scripts/mpich-suite-xfail.txt applies, as
#                    <mpi>/<toolchain>/<os>. Detected by default and rarely
#                    worth setting; an undetectable variant is reported and
#                    cannot fail the run.
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

# Which row of the expected-failures list applies. Detected rather than passed
# in, so that every caller gets it right without having to remember: the MPI is
# told apart by a launcher only one of them installs, and the toolchain by what
# mpif's own wrapper reports. An undetectable component becomes "unknown", which
# matches no entry and no `triaged` line, so the run reports and cannot fail --
# loudly wrong rather than quietly lenient.
if [[ -n ${MPIF_SUITE_VARIANT:-} ]]; then
    variant=${MPIF_SUITE_VARIANT}
else
    if [[ -x ${mpi_prefix}/bin/ompi_info ]]; then
        variant_mpi=openmpi
    elif [[ -x ${mpi_prefix}/bin/mpiexec.hydra ]]; then
        variant_mpi=mpich
    else
        variant_mpi=unknown
    fi
    case $("${mpif_prefix}/bin/mpifort" --version 2>/dev/null | head -1) in
        *"GNU Fortran"*) variant_toolchain=gcc ;;
        *flang*|*Flang*) variant_toolchain=llvm ;;
        *)               variant_toolchain=unknown ;;
    esac
    variant=${variant_mpi}/${variant_toolchain}/$(uname -s | tr '[:upper:]' '[:lower:]')
fi

xfail_file=${scriptdir}/mpich-suite-xfail.txt
if [[ ! -f ${xfail_file} ]]; then
    echo "error: no expected-failures list at ${xfail_file}" >&2
    exit 1
fi

# Whether a difference from the list may fail the run for this variant
if awk -v variant="${variant}" '
        function matches(sel,   s, v, i) {
            if (split(sel, s, "/") != 3 || split(variant, v, "/") != 3) return 0
            for (i = 1; i <= 3; i++) if (s[i] != "*" && s[i] != v[i]) return 0
            return 1
        }
        { sub(/#.*/, "") }
        $1 == "triaged" && matches($2) { found = 1 }
        END { exit !found }
    ' "${xfail_file}"; then
    triaged=1
else
    triaged=0
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
# exits 0 whether or not tests failed, so the result has to be read out of its
# output. `-tapfile` rather than the human-readable summary the console gets:
# TAP names every test, which is what comparing against the expected-failures
# list needs, and a count cannot distinguish one test starting to fail from
# another starting to pass.
status=0
summaries=()
differences=()
for language in "${languages[@]}"; do
    if [[ ! -d ${language} ]]; then
        echo "error: the suite has no ${language} directory" >&2
        exit 1
    fi

    echo "=== ${language}"
    log=${workdir}/runtests-${language}.log
    # `runtests` writes this relative to the directory it runs in
    tap=$(cd "${language}" && pwd)/tap-${language}.txt
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
            -tapfile="${tap}" \
            -showprogress
    ) 2>&1 | tee "${log}"

    # `|| true` because a missing summary is a result to report, not a reason to
    # abort: under `set -e` with `pipefail`, grep finding nothing would otherwise
    # end the script here and skip the remaining languages
    summary=$(grep -E "tests (failed out of|passed)" "${log}" | tail -1 || true)
    summaries+=("${language}: ${summary:-no summary -- see ${log}}")

    if [[ ! -f ${tap} ]]; then
        summaries+=("${language}: no TAP output -- see ${log}")
        status=1
        continue
    fi

    # Compare against the list. A test appears in TAP as
    #   ok 1 - ./attr/attrmpi1f 1 # time=...
    # with `not ok` for a failure -- which includes a failure to build, since
    # `runtests` routes those through the same reporting -- and `# SKIP` for a
    # test that never ran. A skipped test says nothing either way, so it is
    # neither an unexpected failure nor an unexpected pass. Names repeat when
    # the same test runs at several process counts; failing once is failing.
    while read -r kind test; do
        differences+=("${language}: ${kind} ${test}")
    done < <(awk -v variant="${variant}" -v lang="${language}" -v tap="${tap}" '
        function matches(sel,   s, v, i) {
            if (split(sel, s, "/") != 3 || split(variant, v, "/") != 3) return 0
            for (i = 1; i <= 3; i++) if (s[i] != "*" && s[i] != v[i]) return 0
            return 1
        }
        # The expected-failures list first, then the TAP file
        FILENAME != tap {
            sub(/#.*/, "")
            if ($1 == "xfail" && matches($2) && $3 == lang) expected[$4] = 1
            next
        }
        # `ok N - <dir>/<name> <np> # ...`, and the name is the basename
        /^(ok|not ok) / {
            split($0, part, " - ")
            split(part[2], word, " ")
            n = split(word[1], path, "/")
            name = path[n]
            if ($0 ~ / # SKIP/) skipped[name] = 1
            else if ($1 == "not") failed[name] = 1
            else passed[name] = 1
        }
        END {
            for (name in failed)
                if (!(name in expected)) print "unexpected failure:", name
            # A name that both failed and passed -- the same test at two process
            # counts -- has failed, so the expectation held; do not report it
            # passing as well.
            for (name in expected)
                if ((name in passed) && !(name in failed)) print "unexpectedly passes:", name
        }
    ' "${xfail_file}" "${tap}")
done

echo
echo "=== MPICH Fortran test suite, ${version}, ${nprocs} cores, up to ${maxnp} processes per test"
printf '  %s\n' "${summaries[@]}"
if [[ -n ${MPIF_KEEP_TESTS:-} ]]; then
    echo "  test executables kept under ${suite}"
fi

echo
echo "=== Against ${xfail_file##*/}, variant ${variant}"
if [[ ${#differences[@]} -eq 0 ]]; then
    echo "  no differences: every failure is expected and every expectation held"
else
    printf '  %s\n' "${differences[@]}"
    echo
    echo "  An unexpected failure is a regression, or a test nobody has triaged"
    echo "  yet -- add it with the reason, or fix it. A test that unexpectedly"
    echo "  passes has been fixed: remove its line, so that the list keeps"
    echo "  guarding what it claims to."
    if [[ ${triaged} -eq 1 ]]; then
        status=1
    fi
fi
if [[ ${triaged} -eq 0 ]]; then
    echo
    echo "  ${variant} has no \`triaged\` line in ${xfail_file##*/}, so the above"
    echo "  is reported and cannot fail this run. Measure the variant, list its"
    echo "  failures with their reasons, and add the line."
fi

exit ${status}
