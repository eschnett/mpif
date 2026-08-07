# Definitions shared by the scripts in this directory. Source it, don't run it:
#
#     source scripts/macos-common.sh <mpich|openmpi> <gcc|llvm>
#
# A "variant" is one MPI implementation built with one toolchain. Everything a
# variant needs lands in `mpi/` and `build-<variant>*/`, all of which git
# ignores, so `rm -rf mpi build-*` starts over.
#
# The compilers default to MacPorts, since that is where this is developed, but
# CC, CXX and FC from the environment take precedence -- so these scripts also
# work elsewhere, for instance to reproduce a CI failure with the same commands.

repodir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

mpi=${1:-}
toolchain=${2:-}
# Reject surplus arguments too: these scripts delete and rebuild directories, so
# a mistyped invocation should stop before doing any of that.
case ${#}/${mpi}/${toolchain} in
    2/mpich/gcc | 2/mpich/llvm | 2/openmpi/gcc | 2/openmpi/llvm) ;;
    *)
        echo "usage: $(basename "$0") <mpich|openmpi> <gcc|llvm>" >&2
        exit 1
        ;;
esac

case ${toolchain} in
    gcc)
        export CC=${CC:-gcc-mp-15}
        export CXX=${CXX:-g++-mp-15}
        export FC=${FC:-gfortran-mp-15}
        ;;
    llvm)
        export CC=${CC:-clang-mp-22}
        export CXX=${CXX:-clang++-mp-22}
        export FC=${FC:-flang-mp-22}
        ;;
esac

# Where the MPI implementations should look for hwloc
export HWLOC_PREFIX=${HWLOC_PREFIX:-/opt/local}

variant=${mpi}-${toolchain}

# Keeping the MPI source tree around lets a rebuild skip the download and
# `autogen`; see ci-scripts/install-${mpi}.sh
export MPI_SRC_DIR=${MPI_SRC_DIR:-${repodir}/mpi/src-${variant}}

# A sanitizer build is a *second* mpif beside the ordinary one, not a
# replacement: the instrumented library is slower and drags in the sanitizer
# runtime, so nothing should get it by accident, and having both means a
# suspected memory error can be re-run either way without a rebuild. It gets its
# own build tree and its own prefix, named after what it was built with:
#
#     MPIF_SANITIZE=address bash scripts/macos-build-mpif.sh mpich llvm
#     MPIF_SANITIZE=address bash scripts/macos-test-mpif.sh  mpich llvm
#
# leaves build-mpich-llvm-sanitize-address and mpi/mpif-mpich-llvm-sanitize-address
# alone beside build-mpich-llvm and mpi/mpif-mpich-llvm. The MPI underneath is
# shared and uninstrumented, which is the point rather than a shortcut: mpif's
# job is to be correct across the ABI boundary into someone else's library.
#
# Only the toolchains whose C compiler ships a sanitizer runtime can do this,
# which on this machine is `llvm` and not `gcc` -- MacPorts' gcc 15 has no
# libasan. CMake says so and stops; see MPIF_SANITIZE in CMakeLists.txt.
sanitize=${MPIF_SANITIZE:-}
sanitize_tag=
if [[ -n ${sanitize} ]]; then
    sanitize_tag=-sanitize-${sanitize//[;,]/-}
fi

# What a sanitizer run needs from the environment, unless the caller has said
# otherwise. Leak checking is off because the leaks that would be reported are
# the MPI's: both implementations keep allocations alive past MPI_Finalize, and
# LSan sees them as leaked because the process is instrumented and the library
# is not. Turn it back on -- ASAN_OPTIONS=detect_leaks=1 -- when the question is
# specifically whether mpif leaks, and read the report knowing what else is in
# it. (On macOS this is the default anyway; on Linux LSan is on unless told.)
if [[ -n ${sanitize} ]]; then
    export ASAN_OPTIONS=${ASAN_OPTIONS:-detect_leaks=0}
    export UBSAN_OPTIONS=${UBSAN_OPTIONS:-print_stacktrace=1:halt_on_error=1}
fi

mpi_prefix=${repodir}/mpi/${variant}
mpif_prefix=${repodir}/mpi/mpif-${variant}${sanitize_tag}
build=${repodir}/build-${variant}${sanitize_tag}

if [[ $(uname) == Darwin ]]; then
    shlib_ext=dylib
else
    shlib_ext=so
fi
