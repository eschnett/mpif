#!/bin/bash

# The whole local matrix, a stage at a time. Keeps going after a failure and
# reports what failed, since a problem in one toolchain is usually worth seeing
# next to the others that worked.
#
# Usage: dev/build-macos-all.sh [stage ...]
#
#   mpi        4  install the MPI implementations
#   mpif       4  build and install mpif against each
#   test       8  test/, every mpif against every runtime MPI
#   suite      8  the MPICH Fortran suite, same eight pairings
#   consume    4  find_package(mpif)
#   sanitize   4  the AddressSanitizer mpif and its tests, llvm only
#   all           all of the above, in that order (the default)
#
# The stages are separate because the two build stages are the expensive ones and
# the test stages are what gets re-run. They skip when their prefix is already
# marked complete, so `dev/build-macos-all.sh test` after an edit to test/ costs
# the eight test runs and nothing else -- and, for the same reason, it will *not*
# notice an edit to src/. Rebuild explicitly then:
#
#     MPIF_REBUILD=1 dev/build-macos-all.sh mpif test
#
# Each stage prints the provenance of what it is using, so a run against a stale
# build says so. See "the install-complete marker" in scripts/macos-common.sh.

set -uo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
scripts=${here}/../scripts

mpis="mpich openmpi"
toolchains="gcc llvm"
# MacPorts' gcc ships no libsanitizer on macOS, so the sanitizer stage is llvm's
# alone; CMake stops rather than producing an uninstrumented build under a
# sanitizer name. See MPIF_SANITIZE in CMakeLists.txt.
sanitize_toolchains="llvm"

failed=""
run() {
    local label=$1
    shift
    echo "### ${label}"
    if ! "$@"; then
        failed="${failed}
    ${label}"
    fi
}

stage_mpi() {
    for mpi in ${mpis}; do for tc in ${toolchains}; do
        run "mpi ${mpi} ${tc}" bash "${scripts}/macos-install-mpi.sh" "${mpi}" "${tc}"
    done; done
}

stage_mpif() {
    for mpi in ${mpis}; do for tc in ${toolchains}; do
        run "mpif ${mpi} ${tc}" bash "${scripts}/macos-build-mpif.sh" "${mpi}" "${tc}"
    done; done
}

stage_test() {
    for mpi in ${mpis}; do for tc in ${toolchains}; do for run_mpi in ${mpis}; do
        run "test ${mpi} ${tc} run-${run_mpi}" \
            bash "${scripts}/macos-test-mpif.sh" "${mpi}" "${tc}" "${run_mpi}"
    done; done; done
}

stage_suite() {
    for mpi in ${mpis}; do for tc in ${toolchains}; do for run_mpi in ${mpis}; do
        run "suite ${mpi} ${tc} run-${run_mpi}" \
            bash "${scripts}/macos-test-mpich-suite.sh" "${mpi}" "${tc}" "${run_mpi}"
    done; done; done
}

stage_consume() {
    for mpi in ${mpis}; do for tc in ${toolchains}; do
        run "consume ${mpi} ${tc}" bash "${scripts}/macos-test-consume.sh" "${mpi}" "${tc}"
    done; done
}

stage_sanitize() {
    for mpi in ${mpis}; do for tc in ${sanitize_toolchains}; do
        run "sanitize mpif ${mpi} ${tc}" \
            env MPIF_SANITIZE=address bash "${scripts}/macos-build-mpif.sh" "${mpi}" "${tc}"
        for run_mpi in ${mpis}; do
            run "sanitize test ${mpi} ${tc} run-${run_mpi}" \
                env MPIF_SANITIZE=address bash "${scripts}/macos-test-mpif.sh" \
                    "${mpi}" "${tc}" "${run_mpi}"
        done
    done; done
}

stages=${*:-all}
for stage in ${stages}; do
    case ${stage} in
        mpi | mpif | test | suite | consume | sanitize) "stage_${stage}" ;;
        all)
            stage_mpi
            stage_mpif
            stage_test
            stage_suite
            stage_consume
            stage_sanitize
            ;;
        *)
            echo "usage: $(basename "$0") [mpi|mpif|test|suite|consume|sanitize|all ...]" >&2
            exit 1
            ;;
    esac
done

if [[ -n ${failed} ]]; then
    echo "failed:${failed}" >&2
    exit 1
fi
echo "all requested stages passed: ${stages}"
