#!/usr/bin/env bash

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
# implementation rather than the standard. mpich-suite-xfail.txt beside this script says
# which, and this script fails only on a difference from that list, in either
# direction. See the head of that file for the format and the reasoning.
#
# Usage: test-mpich-suite.sh <mpi-prefix> <mpif-prefix> [<language>...]
#
#   <language> is one or more of f77, f90, f08; all three by default.
#
#   <mpi-prefix> is the MPI the suite *runs against*, and it is authoritative:
#   this script exports MPIF_MPI_PREFIX so mpif's wrapper links the suite's
#   Fortran tests against exactly this MPI, whatever default the mpif under
#   test was built with. Passing an mpif built against the *other*
#   implementation is therefore a supported cross-test, and its results are
#   gated against the same expected-failures rows as a native run of
#   <mpi-prefix> -- which is the assertion that results depend only on the
#   runtime MPI. (The tests are relinked rather than swapped underneath via
#   DYLD_LIBRARY_PATH because macOS SIP strips DYLD_* across the system perl
#   and shells this harness runs through; the same-binary swap is test/'s
#   job.)
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
#                    which row of mpich-suite-xfail.txt applies, as
#                    <mpi>/<toolchain>/<os>/<os-version>/<arch>. Detected by
#                    default and rarely worth setting; an undetectable variant is
#                    reported and cannot fail the run.
#   MPIF_SUITE_ARCH  the <arch> component alone, where `uname -m` cannot answer
#                    for the build. A container is the case: a `linux/386` image
#                    runs natively on an x86_64 kernel and buildx sets no 32-bit
#                    personality, so `uname -m` reports the host while the image
#                    and everything built in it are 32-bit. Prefer this over
#                    MPIF_SUITE_VARIANT when only the architecture is wrong, so
#                    that the rest of the key is still detected.
#   MPIF_KEEP_TESTS  if non-empty, keep each test executable and its object file
#                    after it has run instead of letting `runtests` delete them,
#                    and keep the work directory too. Set this before chasing a
#                    crash: the executable is what a debugger needs to turn the
#                    suite's "test failed" into a backtrace. What is kept lasts
#                    until the next run, which unpacks the suite again. Under the
#                    prebuild below both survive without this -- `runtests`
#                    deletes only what it built itself -- so what it still buys
#                    is the work directory, and everything, with the prebuild
#                    turned off.
#   MPIF_SUITE_PREBUILD
#                    set to 0 to let `runtests` compile each test on demand, one
#                    at a time, as it did before the prebuild below. Slow, but it
#                    is the reference behaviour to compare against, and it puts
#                    each test's compiler output next to that test in the log
#                    rather than in one batch ahead of them all.
#   MPIF_SUITE_BUILD_JOBS
#                    parallelism for the prebuild (default: the core count).

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

# The runtime MPI argument is authoritative for linking too; see the usage
# comment above. Absolute, because the wrapper turns it into -L and -rpath
# and the suite builds in directories it cd's into.
MPIF_MPI_PREFIX=$(cd "${mpi_prefix}" && pwd)
export MPIF_MPI_PREFIX

scriptdir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# The MPI install scripts are the directory above: this one and the two files it
# reads live apart from them so that editing the expected-failures list cannot
# invalidate a cached MPI build. See the comment in .github/workflows/ci.yaml.
installdir=$(cd "${scriptdir}/.." && pwd)
# See install-mpich.sh for why this is not `getconf` alone. The summary line
# reports it, and the prebuild below uses it as its default parallelism -- so a
# wrong answer costs speed rather than correctness, and a summary that says how
# many cores the numbers came from should not be able to say nothing.
nprocs=$(getconf _NPROCESSORS_ONLN 2>/dev/null ||
             sysctl -n hw.ncpu 2>/dev/null || echo 4)
maxnp=${MPIEXEC_MAXNP:-4}
build_jobs=${MPIF_SUITE_BUILD_JOBS:-${nprocs}}

# The suite compiles its C files with the implementation's own `mpicc` and its
# Fortran with mpif's `mpifort`, and the two only agree if the prefix exposes
# the standard ABI and nothing else. A prefix that still has the
# implementation's own `mpi.h` and library builds every test without complaint
# and then fails a handful of them in ways that look like mpif defects; that is
# MISSING.md "An unpruned Open MPI prefix", which cost a diagnosis. Twenty
# minutes of tests deserve the one compile it takes to rule that out.
if ! abi_check=$("${installdir}/check-mpi-install.sh" "${mpi_prefix}" 2>&1); then
    echo "${abi_check}" >&2
    echo "error: ${mpi_prefix} does not expose the standard ABI, so the suite" >&2
    echo "       would be testing something other than mpif. Reinstall it with" >&2
    echo "       ci-scripts/install-<mpi>.sh or scripts/macos-install-mpi.sh." >&2
    exit 1
fi

# Take the version from the install script, so the suite always matches the
# MPICH we know how to build rather than drifting away from it
version=$(sed -n 's/^MPICH_VERSION=//p' "${installdir}/install-mpich.sh")
if [[ -z ${version} ]]; then
    echo "error: cannot read MPICH_VERSION from ${installdir}/install-mpich.sh" >&2
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
# told apart by a launcher only one of them installs, the toolchain by what mpif's
# own wrapper reports, and the OS, its version and the architecture by asking the
# system.
#
# Five components, `<mpi>/<toolchain>/<os>/<os-version>/<arch>`. The architecture
# is in the key because the two Linux runners disagree about eleven spawn tests,
# and the OS version because two environments that agree on everything else still
# do not agree: the Docker images run Ubuntu 26.04 where CI's runners run 24.04,
# and they differ over `MPI_Dist_graph_create` and `i_fcoll_test`.
#
# The version is coarse on purpose -- a distribution's VERSION_ID and the major
# version of macOS or FreeBSD, so 24.04, 26.04, 15, 26, 14. A finer one would churn
# every time a runner image is refreshed, and expectations would go stale for no
# reason.
#
# An undetectable component becomes "unknown", which matches no entry and no
# `triaged` line, so the run reports and cannot fail -- loudly wrong rather than
# quietly lenient.
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
    variant_os=$(uname -s | tr '[:upper:]' '[:lower:]')
    case ${variant_os} in
        darwin)
            # The major version alone: 26 rather than 26.5.2
            variant_osversion=$(sw_vers -productVersion 2>/dev/null | cut -d. -f1)
            ;;
        linux)
            # VERSION_ID is the release, and for the distributions used here it is
            # already the whole identity: Ubuntu's 24.04 against 26.04
            variant_osversion=$(. /etc/os-release 2>/dev/null && echo "${VERSION_ID:-}")
            ;;
        freebsd)
            # `uname -r` is 14.3-RELEASE; the major version alone, as on Darwin,
            # so that a patch release does not retire the variant's row
            variant_osversion=$(uname -r | cut -d. -f1)
            ;;
        *)
            variant_osversion=
            ;;
    esac
    variant_osversion=${variant_osversion:-unknown}
    # `uname -m` describes the kernel, which in a container need not be what the
    # build targets; MPIF_SUITE_ARCH is how such an environment says so.
    variant_arch=${MPIF_SUITE_ARCH:-$(uname -m)}
    variant=${variant_mpi}/${variant_toolchain}/${variant_os}/${variant_osversion}/${variant_arch}
fi

xfail_file=${scriptdir}/mpich-suite-xfail.txt
if [[ ! -f ${xfail_file} ]]; then
    echo "error: no expected-failures list at ${xfail_file}" >&2
    exit 1
fi

# Whether a difference from the list may fail the run for this variant
if awk -v variant="${variant}" '
        function matches(sel,   s, v, i) {
            if (split(sel, s, "/") != 5 || split(variant, v, "/") != 5) return 0
            for (i = 1; i <= 5; i++) if (s[i] != "*" && s[i] != v[i]) return 0
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
unexpected=()
flakynotes=()
for language in "${languages[@]}"; do
    if [[ ! -d ${language} ]]; then
        echo "error: the suite has no ${language} directory" >&2
        exit 1
    fi

    echo "=== ${language}"
    log=${workdir}/runtests-${language}.log
    # `runtests` writes this relative to the directory it runs in
    tap=$(cd "${language}" && pwd)/tap-${language}.txt

    # Compile the language's tests before running any of them, in parallel.
    #
    # `runtests` builds each test on demand, one at a time, and that -- not the
    # MPI -- is most of a suite run: summing the per-test `time=` fields of a
    # tap-*.txt against the wall time in the matching runtests-*.log puts test
    # execution at under a third of it, so the rest is a single compiler using
    # one core while the others idle. That is worst where it costs most, the
    # three-core macOS runners being the longest legs in CI.
    #
    # `all` in a language directory is exactly the right set: each leaf
    # Makefile's `noinst_PROGRAMS` lists the programs its testlist names and
    # nothing else, so this compiles what is about to be run and not one program
    # more. Afterwards `runtests` finds each executable already there --
    # BuildMPIProgram tests `! -x $programname` -- and its `make` is a no-op.
    #
    # The util libraries first and on their own, because every leaf Makefile
    # carries its own rule to recurse into util and build them. Automake's
    # recursive rule walks SUBDIRS in a serial shell loop, so no two leaves can
    # be in util at once and -j applies within a leaf, where make builds each
    # library once; this is insurance against that reasoning being wrong rather
    # than a fix for a race that has been seen. Getting it wrong looks like
    # `ar: .libs/mtest_f77.o: No such file or directory`.
    #
    # The status is deliberately discarded. A test that does not compile is a
    # result for `runtests` to report -- it finds no executable, runs `make`
    # itself, fails, and routes that through the same TAP `not ok` as a test that
    # ran and failed, which is what the comparison below is gating on. `-k` so
    # that one broken test does not hide the rest, the same reason
    # ci-scripts/compile-only.sh retries with it.
    if [[ ${MPIF_SUITE_PREBUILD:-1} != 0 ]]; then
        echo "--- building ${language} with ${build_jobs} jobs"
        (
            cd "${language}"
            make -C ../util "libmtest_${language}.la" libmtest_single.la
            make -k -j"${build_jobs}" all
        ) || echo "--- ${language}: some tests did not compile; runtests will report them"
    fi

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
        # mpiexec-filter.sh beside this script. The suite treats anything the launcher
        # prints as unexpected test output.
        export MPIF_REAL_MPIEXEC="${mpi_prefix}/bin/mpiexec"
        # `runtests` has no command line option for this -- it unlinks the
        # executable and its .o right after each test unless MPITEST_CLEANUP
        # says otherwise. With the prebuild above both survive regardless: the
        # unlink is guarded by the same `! -x` answer that decided whether
        # runtests built the test at all. So this is for the prebuild being off.
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
        case ${kind} in
            flaky,*)     flakynotes+=("${language}: ${kind} ${test}") ;;
            unexpected)
                # `read` leaves the name at the end of ${test}, as in
                # "failure: spawnf"; "unexpectedly passes" gives a different
                # ${kind} and is not dumped, there being no output to show
                differences+=("${language}: ${kind} ${test}")
                unexpected+=("${language} ${test##* } ${tap}")
                ;;
            *)           differences+=("${language}: ${kind} ${test}") ;;
        esac
    done < <(awk -v variant="${variant}" -v lang="${language}" -v tap="${tap}" '
        function matches(sel,   s, v, i) {
            if (split(sel, s, "/") != 5 || split(variant, v, "/") != 5) return 0
            for (i = 1; i <= 5; i++) if (s[i] != "*" && s[i] != v[i]) return 0
            return 1
        }
        # The expected-failures list first, then the TAP file
        FILENAME != tap {
            sub(/#.*/, "")
            if ($1 == "xfail" && matches($2) && $3 == lang) expected[$4] = 1
            if ($1 == "flaky" && matches($2) && $3 == lang) flaky[$4] = 1
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
                if (!(name in expected) && !(name in flaky)) print "unexpected failure:", name
            # A name that both failed and passed -- the same test at two process
            # counts -- has failed, so the expectation held; do not report it
            # passing as well.
            for (name in expected)
                if ((name in passed) && !(name in failed)) print "unexpectedly passes:", name
            # Flaky entries are reported for visibility and judged neither way
            for (name in flaky)
                if (name in failed) print "flaky, failed this time:", name
                else if (name in passed) print "flaky, passed this time:", name
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
if [[ ${#flakynotes[@]} -gt 0 ]]; then
    printf '  %s\n' "${flakynotes[@]}"
fi
if [[ ${#differences[@]} -eq 0 ]]; then
    echo "  no differences: every failure is expected and every expectation held"
else
    printf '  %s\n' "${differences[@]}"
    echo
    echo "  An unexpected failure is a regression, or a test nobody has triaged"
    echo "  yet -- add it with the reason, or fix it. A test that unexpectedly"
    echo "  passes has been fixed: remove its line, so that the list keeps"
    echo "  guarding what it claims to."

    # What each unexpected failure actually printed, in full. `runtests` reports
    # this on its own console too, and stops at ten lines with "... ..." -- which
    # is how a diagnosis comes to be about the first ten lines of a longer story:
    # eleven Open MPI spawn tests were read as failing on a warning, and the fatal
    # error two lines past the cut was the real one. The TAP file has all of it,
    # and this is read from there.
    #
    # Guarded because there need not be any: a run whose only differences are
    # unexpected *passes* leaves this empty, and `"${unexpected[@]}"` on an empty
    # array is an unbound variable under `set -u` in bash 3.2, which macOS ships.
    # That aborted the script here rather than reaching its verdict -- exit 1 by
    # accident, and none of the tail below printed.
    for entry in ${unexpected[@]+"${unexpected[@]}"}; do
        read -r language test tapfile <<<"${entry}"
        echo
        echo "--- ${language} ${test}, as recorded in ${tapfile##*/}"
        awk -v want="${test}" '
            /^(ok|not ok) / {
                split($0, part, " - ")
                split(part[2], word, " ")
                n = split(word[1], path, "/")
                show = (path[n] == want)
            }
            show
        ' "${tapfile}" | sed 's/^/  /'
    done
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
