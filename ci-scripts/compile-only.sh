#!/usr/bin/env bash

# Configure, build and install mpif, and build its tests, against an MPI that
# cannot run. What this stage answers is whether the configure stage detects a
# compiler's features correctly and whether the code compiles -- nothing about
# behaviour, which is what the twelve variants in .github/workflows/ci.yaml are
# for.
#
# It costs a runner and no MPI build, so a compiler is cheap to add: the MPI is
# the Forum's ABI stub library (ci-scripts/install-mpi-stubs.sh), which any C
# compiler produces in seconds on any libc. That is why the old-gfortran rows
# can be plain Debian containers.
#
# Both halves of the CFI decision are built, in this order:
#
#   1. the probe's own answer, whatever it is
#   2. -DMPIF_ENABLE_CFI=OFF
#
# because MPIF_HAVE_CFI selects between two different bodies of generated code,
# and a single build only ever compiles one of them. A compiler that probes
# "yes" would otherwise never see the ignore_tkr fallback, and one that probes
# "no" would never see the scheme-1B wrappers or gen/mpif_f08_cdesc.c at all.
#
# Usage: compile-only.sh <work-dir>
#
# Environment:
#   CC, FC             the compilers under test. Required: which compiler this
#                      is is the entire content of the answer, so it is named
#                      rather than defaulted.
#   MPIF_COMPILE_JOBS  parallelism for the mpif and test builds

set -euo pipefail

workdir=${1:?usage: compile-only.sh <work-dir>}
: "${CC:?compile-only.sh: set CC to the C compiler under test}"
: "${FC:?compile-only.sh: set FC to the Fortran compiler under test}"

repodir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

mkdir -p "${workdir}"
workdir=$(cd "${workdir}" && pwd)

mpi_prefix=${workdir}/mpi-stubs
jobs=${MPIF_COMPILE_JOBS:-$( (nproc || sysctl -n hw.ncpu || echo 2) 2>/dev/null )}

echo "=== compilers ==="
"${CC}" --version | head -1
"${FC}" --version | head -1

echo "=== the stub MPI ==="
bash "${repodir}/ci-scripts/install-mpi-stubs.sh" "${mpi_prefix}"

# One pass over both branches. `default` lets the probe decide and is the
# interesting one; `no-cfi` forces the fallback.
#
# A branch that fails does not stop the other one. Which of the two a compiler
# fails on is most of the diagnosis -- ifx compiles the whole library and then
# hits an internal compiler error on the first assumed-rank sentinel, and
# whether its fallback branch is clean is what says the defect is in that path
# and nowhere else. Stopping at the first failure would cost a whole CI run to
# learn it. The exit status still reflects both.
branch_status=""
run_branch() {
    branch=$1
    case ${branch} in
        default) enable_cfi=ON  expect_subarrays=auto ;;
        no-cfi)  enable_cfi=OFF expect_subarrays=OFF ;;
    esac

    build=${workdir}/build-${branch}
    prefix=${workdir}/mpif-${branch}
    testbuild=${workdir}/test-${branch}
    rm -rf "${build}" "${prefix}" "${testbuild}"

    echo "=== mpif (${branch}) ==="
    # MPI_C_COMPILER names the stub wrapper rather than letting find_package(MPI)
    # search for it. The search starts by looking for an mpiexec and takes its
    # prefix as the hint for everything else; the stub prefix has no mpiexec, so
    # the search walks off it and finds whatever unrelated MPI is on PATH --
    # measured here, where it picked a miniforge install. test/CMakeLists.txt
    # pins MPIEXEC_EXECUTABLE against the same hazard.
    cmake \
        -S "${repodir}" \
        -B "${build}" \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_C_COMPILER="${CC}" \
        -DCMAKE_Fortran_COMPILER="${FC}" \
        -DCMAKE_INSTALL_PREFIX="${prefix}" \
        -DMPI_HOME="${mpi_prefix}" \
        -DMPI_C_COMPILER="${mpi_prefix}/bin/mpicc" \
        -DMPIF_ENABLE_CFI="${enable_cfi}"

    echo "=== probes (${branch}) ==="
    bash "${repodir}/ci-scripts/check-configure-probes.sh" "${build}"

    cmake --build "${build}" --parallel "${jobs}"
    cmake --install "${build}"

    echo "=== test/ (${branch}) ==="
    # MPIF_TEST_BUILD_ONLY builds every test and registers none: there is no
    # launcher, and nothing linked against the stub library can run.
    # MPIF_TEST_EXPECT_SUBARRAYS is passed rather than left at "auto" on the
    # no-cfi branch, where the probe would re-derive "yes" and disagree with the
    # library that was actually built.
    cmake \
        -S "${repodir}/test" \
        -B "${testbuild}" \
        -DCMAKE_BUILD_TYPE=Debug \
        -DCMAKE_C_COMPILER="${CC}" \
        -DCMAKE_Fortran_COMPILER="${FC}" \
        -DMPI_HOME="${mpi_prefix}" \
        -DMPI_C_COMPILER="${mpi_prefix}/bin/mpicc" \
        -DMPI_Fortran_COMPILER="${prefix}/bin/mpifort" \
        -DMPIF_TEST_BUILD_ONLY=ON \
        -DMPIF_TEST_EXPECT_SUBARRAYS="${expect_subarrays}"
    cmake --build "${testbuild}" --parallel "${jobs}"
}

status=0
for branch in default no-cfi; do
    # The subshell re-enables `set -e` for itself, because bash disables it
    # inside a function or subshell whose status is being tested -- which is
    # exactly what the `if` below does.
    set +e
    ( set -e; run_branch "${branch}" )
    rc=$?
    set -e
    if [[ ${rc} -eq 0 ]]; then
        branch_status="${branch_status}${branch}=ok "
    else
        branch_status="${branch_status}${branch}=FAILED "
        status=1
    fi
done

# The lines worth reading at the end of a long log. MPIF_HAVE_CFI reaches the
# cache only when the probe ran, so its absence on the no-cfi branch is the
# expected "no" rather than a missing answer, and a branch that died before
# configuring has no cache at all.
echo "=== summary ==="
for branch in default no-cfi; do
    cache=${workdir}/build-${branch}/CMakeCache.txt
    have=no
    if [[ -f ${cache} ]]; then
        case $(sed -n 's|^MPIF_HAVE_CFI:[A-Z]*=\(.*\)|\1|p' "${cache}" | head -1) in
            ""|OFF|FALSE|NO|0) have=no ;;
            *) have=yes ;;
        esac
    else
        have="(not configured)"
    fi
    printf '%-10s MPIF_HAVE_CFI=%s\n' "${branch}" "${have}"
done
echo "compile-only.sh: ${branch_status}"
exit "${status}"
