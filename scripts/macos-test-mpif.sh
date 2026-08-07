#!/bin/bash

# Build and run the tests in test/ against an installed mpif.
#
# Usage: scripts/macos-test-mpif.sh <mpich|openmpi> <gcc|llvm>
#
# Environment:
#   MPIF_RUN_MPI  <mpich|openmpi>: run the tests against this MPI instead of
#                 the default remembered by the mpif under test. The binaries
#                 still *link* the remembered default; DYLD_LIBRARY_PATH puts
#                 the runtime implementation in front of it at ctest time --
#                 the same-binary cross test, exercising exactly the loader
#                 mechanism applications use. The launcher and the expected
#                 MPI_Get_library_version string come from the runtime MPI,
#                 so a swap that silently failed to happen fails the tests.
#   MPIF_TEST_MPIEXEC_PREFLAGS
#                 overrides the Open MPI launcher flags below.
#
# The variant arguments name the mpif under test (mpi/mpif-<variant>); which
# MPI the tests then link is *not* respecified here but read back from the
# installed wrapper (-showme:mpiprefix), so this script tests the default the
# installation actually remembers.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/macos-common.sh" "$@"

link_mpi_prefix=$("${mpif_prefix}/bin/mpifort" -showme:mpiprefix)

run_mpi=${MPIF_RUN_MPI:-${mpi}}
case ${run_mpi} in
    mpich)   run_mpi_library=MPICH ;;
    openmpi) run_mpi_library="Open MPI" ;;
    *)
        echo "error: MPIF_RUN_MPI must be mpich or openmpi, not '${run_mpi}'" >&2
        exit 1
        ;;
esac
run_mpi_prefix=${repodir}/mpi/${run_mpi}-${toolchain}

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

rm -rf "${build}-tests"
cmake \
    -S "${repodir}/test" \
    -B "${build}-tests" \
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
cmake --build "${build}-tests" --parallel

if [[ -n ${MPIF_RUN_MPI:-} ]]; then
    # The cross run: same binaries, the runtime MPI put in front of the linked
    # default by the loader's search path.
    DYLD_LIBRARY_PATH="${run_mpi_prefix}/lib" \
        ctest --test-dir "${build}-tests" --output-on-failure
else
    ctest --test-dir "${build}-tests" --output-on-failure
fi
