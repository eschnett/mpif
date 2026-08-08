#!/bin/bash

# Build and run the tests in test/ against an installed mpif.
#
# Usage: scripts/macos-test-mpif.sh <mpich|openmpi> <gcc|llvm> [<mpich|openmpi>]
#
# The first two arguments name the mpif under test (build/mpif/<variant>); which
# MPI the tests then *link* is not respecified here but read back from the
# installed wrapper (-showme:mpiprefix), so this script tests the default the
# installation actually remembers.
#
# The third names the MPI to *run* against, and defaults to the first. Giving the
# other implementation is the cross test: the binaries still link the remembered
# default, and DYLD_LIBRARY_PATH puts the runtime implementation in front of it
# at ctest time -- the same-binary cross test, exercising exactly the loader
# mechanism applications use. The launcher and the expected
# MPI_Get_library_version string come from the runtime MPI, so a swap that
# silently failed to happen fails the tests. Each of the eight combinations gets
# its own tree, build/test/<variant>-run-<runtime>, because the two configure the
# same directory differently and each deletes it before configuring.
#
# Environment:
#   MPIF_TEST_MPIEXEC_PREFLAGS
#                 overrides the Open MPI launcher flags below.
#   MPIF_SANITIZE test the sanitizer mpif built with the same variable set,
#                 rather than the ordinary one: it selects a different prefix
#                 and a different build tree. See scripts/macos-common.sh.

set -euo pipefail
takes_run_mpi=yes
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

require_marker "${mpif_prefix}" \
    "${MPIF_SANITIZE:+MPIF_SANITIZE=${MPIF_SANITIZE} }scripts/macos-build-mpif.sh ${mpi} ${toolchain}"
require_marker "${run_mpi_prefix}" \
    "scripts/macos-install-mpi.sh ${run_mpi} ${toolchain}"

echo "Testing the mpif in build/mpif/${tagged}, running against ${run_mpi}:"
show_marker "${mpif_prefix}"

link_mpi_prefix=$("${mpif_prefix}/bin/mpifort" -showme:mpiprefix)
check_native_prefix_agrees "${link_mpi_prefix}"

case ${run_mpi} in
    mpich)   run_mpi_library=MPICH ;;
    openmpi) run_mpi_library="Open MPI" ;;
esac

# The alltoallw tests need more than one rank, hence a launcher. It is pinned
# rather than left to find_package(MPI), which found an unrelated miniforge
# install here and would have run them against an MPI mpif was not built against;
# test/CMakeLists.txt fails the configure if this is missing. The launcher is
# the *runtime* MPI's, which for a native run is the remembered default.
#
# Open MPI gets the same two flags scripts/macos-test-mpich-suite.sh passes as
# MPIEXEC_ARGS, for the reasons spelled out there: it refuses to oversubscribe,
# and on macOS it picks a non-loopback interface it cannot configure and then
# hangs. Overridable the same way.
#
# MPICH adds nothing, so the array stays empty there, and `"${cmake_args[@]}"` on
# an empty array is an unbound variable under `set -u` in bash 3.2, which macOS
# ships -- the same trap ci-scripts/suite/test-mpich-suite.sh documents. It killed
# every MPICH run of this script at the cmake line, so the guarded expansion below
# is not decoration.
cmake_args=()
if [[ ${run_mpi} == openmpi ]]; then
    cmake_args+=("-DMPIEXEC_PREFLAGS=${MPIF_TEST_MPIEXEC_PREFLAGS:---oversubscribe;--mca;btl_tcp_if_include;lo0}")
fi

rm -rf "${tests_build}"
cmake \
    -S "${repodir}/test" \
    -B "${tests_build}" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER="${CC}" \
    -DCMAKE_Fortran_COMPILER="${FC}" \
    -DMPI_C_COMPILER="${link_mpi_prefix}/bin/mpicc" \
    -DMPI_Fortran_COMPILER="${mpif_prefix}/bin/mpifort" \
    -DMPI_C_HEADER_DIR="${link_mpi_prefix}/include" \
    -DMPI_C_LIB_NAMES=mpi_abi \
    -DMPI_mpi_abi_LIBRARY="${link_mpi_prefix}/lib/libmpi_abi.${shlib_ext}" \
    -DMPIEXEC_EXECUTABLE="${run_mpi_prefix}/bin/mpiexec" \
    -DMPIF_TEST_MPI_LIBRARY="${run_mpi_library}" \
    ${cmake_args[@]+"${cmake_args[@]}"}
cmake --build "${tests_build}" --parallel

if [[ ${run_mpi} != "${mpi}" ]]; then
    # The cross run: same binaries, the runtime MPI put in front of the linked
    # default by the loader's search path.
    DYLD_LIBRARY_PATH="${run_mpi_prefix}/lib" \
        ctest --test-dir "${tests_build}" --output-on-failure
else
    ctest --test-dir "${tests_build}" --output-on-failure
fi
