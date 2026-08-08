# Definitions shared by the scripts in this directory. Source it, don't run it:
#
#     source scripts/macos-common.sh <mpich|openmpi> <gcc|llvm> [<run-mpi>]
#
# A "variant" is one MPI implementation built with one toolchain. `build/` is
# grouped by *stage* rather than by variant, so a stage's directories sit
# together and each can be built and thrown away without disturbing the others:
#
#     build/mpi/<variant>              the MPI               4
#     build/mpi-src/<variant>          its unpacked source   4
#     build/mpif/<variant>             mpif itself           4
#     build/mpif-build/<variant>       mpif's CMake tree     4
#     build/test/<variant>-run-<r>     test/                 8
#     build/suite/<variant>-run-<r>    the MPICH suite       8
#     build/consume/<variant>          the consume test      4
#
# `<r>` is the *runtime* MPI, the third argument, and it defaults to the
# implementation mpif was built against, so a native run is two arguments and a
# cross run is three. There are eight of each test because one installed mpif
# serves both runtimes: `bin/mpifort` reads MPIF_MPI_PREFIX from the environment
# and links whichever MPI it names, so the suite relinks through it and test/
# swaps DYLD_LIBRARY_PATH under unchanged binaries. Neither needs a second mpif.
#
# git ignores `/build*/`, so `rm -rf build` starts over.
#
# The compilers default to MacPorts, since that is where this is developed, but
# CC, CXX and FC from the environment take precedence -- so these scripts also
# work elsewhere, for instance to reproduce a CI failure with the same commands.

repodir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

# Only the scripts that run something have a runtime MPI. The rest set nothing
# and a third argument is then an error rather than a silently ignored word:
# these scripts delete and rebuild directories, so a mistyped invocation should
# stop before doing any of that.
takes_run_mpi=${takes_run_mpi:-no}

mpi=${1:-}
toolchain=${2:-}
case ${#}/${mpi}/${toolchain} in
    [23]/mpich/gcc | [23]/mpich/llvm | [23]/openmpi/gcc | [23]/openmpi/llvm) ;;
    *) bad_args=yes ;;
esac
if [[ ${#} -eq 3 && ${takes_run_mpi} != yes ]]; then
    bad_args=yes
fi
if [[ -n ${bad_args:-} ]]; then
    if [[ ${takes_run_mpi} == yes ]]; then
        echo "usage: $(basename "$0") <mpich|openmpi> <gcc|llvm> [<mpich|openmpi>]" >&2
    else
        echo "usage: $(basename "$0") <mpich|openmpi> <gcc|llvm>" >&2
    fi
    exit 1
fi

# The MPI the tests run against, as opposed to the one mpif was built against.
# Defaulting it to `mpi` is what makes a native run and a cross run the same
# command with one word changed, rather than one command and one environment
# variable.
run_mpi=${3:-${mpi}}
case ${run_mpi} in
    mpich | openmpi) ;;
    *)
        echo "error: the runtime MPI must be mpich or openmpi, not '${run_mpi}'" >&2
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

# A sanitizer build is a *second* mpif beside the ordinary one, not a
# replacement: the instrumented library is slower and drags in the sanitizer
# runtime, so nothing should get it by accident, and having both means a
# suspected memory error can be re-run either way without a rebuild. It gets its
# own build tree and its own prefix, named after what it was built with:
#
#     MPIF_SANITIZE=address bash scripts/macos-build-mpif.sh mpich llvm
#     MPIF_SANITIZE=address bash scripts/macos-test-mpif.sh  mpich llvm
#
# leaves build/mpif/mpich-llvm-sanitize-address alone beside
# build/mpif/mpich-llvm. The MPI underneath is shared and uninstrumented, which
# is the point rather than a shortcut: mpif's job is to be correct across the ABI
# boundary into someone else's library. That is why `mpi_prefix` and
# `MPI_SRC_DIR` below are the only paths that do *not* carry the tag, and why a
# sanitizer build needs no MPI of its own.
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

# `tagged` names everything mpif owns, `variant` everything the MPI owns. The
# distinction is the sanitizer one above and nothing else, so the two are equal
# for an ordinary build.
tagged=${variant}${sanitize_tag}

# Keeping the source tree around lets a rebuild skip the download and `autogen`;
# see ci-scripts/install-${mpi}.sh
export MPI_SRC_DIR=${MPI_SRC_DIR:-${repodir}/build/mpi-src/${variant}}
mpi_prefix=${repodir}/build/mpi/${variant}

# The MPI the tests run against. Never tagged, and keyed on `run_mpi` rather than
# `mpi`, which is the whole of what makes a cross run cross.
run_mpi_prefix=${repodir}/build/mpi/${run_mpi}-${toolchain}

mpif_prefix=${repodir}/build/mpif/${tagged}
build=${repodir}/build/mpif-build/${tagged}
tests_build=${repodir}/build/test/${tagged}-run-${run_mpi}
suite_dir=${repodir}/build/suite/${tagged}-run-${run_mpi}
consume_build=${repodir}/build/consume/${tagged}

if [[ $(uname) == Darwin ]]; then
    shlib_ext=dylib
else
    shlib_ext=so
fi

# --- the install-complete marker ------------------------------------------
#
# The MPI and mpif stages are expensive and are run over and over while working
# through the sixteen test runs, so each leaves a marker saying it finished, and
# a later run of the same stage does nothing. `MPIF_REBUILD=1` deletes and
# rebuilds anyway.
#
# The marker is a plain file, not a checksum of the inputs, and that is a
# decision rather than an economy: it cannot be made complete. The prefix depends
# on ci-scripts/install-mpi-header.sh, which clones mpi-forum/mpi-abi-stubs at
# whatever HEAD is that day, so no checksum over files in this repository says
# what the prefix was built from. A marker that looked authoritative and was not
# would be worse than one that plainly says "I was here".
#
# What it costs is that editing src/ and rerunning a test stage tests the *old*
# mpif and passes. That is the failure mode "Stale build artifacts were the
# biggest time sink" in CLAUDE.md is about, and the answer here is provenance
# rather than prevention: the marker records how the build was made, every stage
# that depends on one prints it, and a run against a stale build therefore says
# so on screen. `MPIF_REBUILD=1` is the cure. Only the two *build* stages skip;
# the test, suite and consume trees are still deleted and rebuilt every run.
rebuild=${MPIF_REBUILD:-}

# Write the marker. Call it last, after every check the stage makes, so that its
# presence means the stage finished rather than that it started.
write_marker() {
    local dir=$1 what=$2
    shift 2
    # `|| true` on both: a repository without git, or a `git status` that fails
    # for any reason, should not fail an otherwise finished build.
    local head dirty=
    head=$(git -C "${repodir}" rev-parse --short HEAD 2>/dev/null || true)
    if [[ -n ${head} && -n $(git -C "${repodir}" status --porcelain 2>/dev/null || true) ]]; then
        dirty=" (dirty)"
    fi
    {
        echo "${what}"
        echo "built    $(date -u +%Y-%m-%dT%H:%M:%SZ)"
        if [[ -n ${head} ]]; then echo "commit   ${head}${dirty}"; fi
        echo "compiler CC=${CC} FC=${FC}"
        local line
        for line in "$@"; do echo "${line}"; done
    } >"${dir}/install-complete"
}

marker_present() {
    [[ -f $1/install-complete ]]
}

# Print what a marker records, indented, so that a stage which is about to use
# somebody else's output says whose and how old.
show_marker() {
    local dir=$1
    sed 's|^|    |' "${dir}/install-complete"
}

# A native run is meant to test the MPI the installation actually remembers, so
# it used to read that back from the wrapper instead of naming a path. Now that
# the path is computed, check the two agree rather than lose the property: they
# can only differ if the mpif was installed against some other prefix, and then
# "native" would be linking one implementation and launching another.
check_native_prefix_agrees() {
    local wrapper_says=$1
    if [[ ${run_mpi} == "${mpi}" && ${wrapper_says} != "${run_mpi_prefix}" ]]; then
        echo "error: this mpif remembers ${wrapper_says}," >&2
        echo "error: but a native run of ${variant} expects ${run_mpi_prefix}." >&2
        echo "error: rebuild it: scripts/macos-build-mpif.sh ${mpi} ${toolchain}" >&2
        exit 1
    fi
}

# Refuse to start rather than fail later on a missing file. `what` is the stage
# that would produce it, so the message says what to run.
require_marker() {
    local dir=$1 what=$2
    if ! marker_present "${dir}"; then
        echo "error: ${dir#"${repodir}/"} is not a finished installation." >&2
        echo "error: run ${what} first." >&2
        exit 1
    fi
}
