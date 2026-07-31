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
# `autogen`; see scripts/install-${mpi}.sh
export MPI_SRC_DIR=${MPI_SRC_DIR:-${repodir}/mpi/src-${variant}}

mpi_prefix=${repodir}/mpi/${variant}
mpif_prefix=${repodir}/mpi/mpif-${variant}
build=${repodir}/build-${variant}

if [[ $(uname) == Darwin ]]; then
    shlib_ext=dylib
else
    shlib_ext=so
fi
