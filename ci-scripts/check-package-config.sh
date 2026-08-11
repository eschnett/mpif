#!/usr/bin/env bash

# Check that an installed mpif's CMake package configuration file keeps the
# contract find_package() imposes on one.
#
# Usage: ci-scripts/check-package-config.sh <mpif-prefix> [<mpi-prefix>]
#
# The failure this exists for is invisible to every other test here.
# `test-consume/` -- mpif's only consumer -- says find_package(mpif REQUIRED)
# and is always handed -DMPI_mpi_abi_LIBRARY, so it passes whether the config
# file reports a failure or aborts on one, and it never reaches the
# find_library fallback at all. What breaks in between is a *different*
# consumer: one that says find_package(mpif) without REQUIRED, expecting to
# carry on with mpif_FOUND false when no ABI MPI is installed. A
# message(FATAL_ERROR) in the config file ends that consumer's configure
# instead, and mpif cannot be an optional dependency of anything.
#
# Three configures, against the installed prefix:
#
#   1. optional, no ABI MPI      -- must succeed, mpif_FOUND false, and a
#                                   reason recorded in mpif_NOT_FOUND_MESSAGE
#   2. REQUIRED, no ABI MPI      -- must fail, and say what to do about it, so
#                                   fixing 1 does not quietly mute 2
#   3. optional, ABI MPI present -- must find it and define the imported
#                                   target, so this script cannot pass by
#                                   never finding anything
#
# Leg 3 points MPI_HOME at the MPI rather than pinning MPI_mpi_abi_LIBRARY the
# way the test harnesses do, because that is the branch nothing else exercises.
#
# The first two legs have to fail to find libmpi_abi *deterministically*: a
# copy in /usr/local or /opt/local would otherwise make this script lie about
# what it proved. CMAKE_FIND_ROOT_PATH at an empty directory, with
# CMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY, re-roots every library search into
# that directory and searches nowhere else -- one knob, rather than a list of
# system paths that would differ per platform. MPI_HOME is cleared from the
# environment for the same reason.
#
# The probe project enables no language (`LANGUAGES NONE`): nothing here is
# compiled or linked, so a compiler probe would be the whole cost of the
# script.

set -eu

mpif_prefix="${1:-}"
mpi_prefix="${2:-}"
if [ -z "$mpif_prefix" ]; then
  echo "usage: $(basename "$0") <mpif-prefix> [<mpi-prefix>]" >&2
  exit 1
fi

# Absolute, because the probe project configures in a temporary directory:
# a relative CMAKE_PREFIX_PATH or MPI_HOME there resolves against *that*
# directory, finds nothing, and every leg reports a not-found that says
# nothing about this installation.
absolute() {
  if [ ! -d "$1" ]; then
    echo "$(basename "$0"): no such directory: $1" >&2
    exit 1
  fi
  (cd "$1" && pwd -P)
}
mpif_prefix="$(absolute "$mpif_prefix")"
if [ -n "$mpi_prefix" ]; then
  mpi_prefix="$(absolute "$mpi_prefix")"
fi

# Not a fixed lib/cmake/mpif: GNUInstallDirs answers lib64 on some
# distributions and a multiarch path on others, and find_package looks in all
# of them. This says which file the run actually judged.
config=""
for candidate in "$mpif_prefix"/lib*/cmake/mpif/mpifConfig.cmake \
                 "$mpif_prefix"/lib*/*/cmake/mpif/mpifConfig.cmake \
                 "$mpif_prefix"/share/cmake/mpif/mpifConfig.cmake; do
  if [ -f "$candidate" ]; then
    config="$candidate"
    break
  fi
done
if [ -z "$config" ]; then
  echo "$(basename "$0"): no mpifConfig.cmake under $mpif_prefix" >&2
  exit 1
fi
echo "$(basename "$0"): checking $config"

work="$(mktemp -d "${TMPDIR:-/tmp}/mpif-package-config.XXXXXX")"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/src" "$work/empty-root"

status=0

# Each leg reports what it found through a file rather than through the
# console, so that a leg cannot be judged by text CMake happened to print.
report="$work/report.txt"

write_project() {
  # $1: the find_package() call to make
  cat >"$work/src/CMakeLists.txt" <<EOF
cmake_minimum_required(VERSION 3.13...3.28)
project(mpif-package-config-probe LANGUAGES NONE)

$1

if(mpif_FOUND)
  file(WRITE "\${MPIF_REPORT}" "found\n\${mpif_NOT_FOUND_MESSAGE}\n")
else()
  file(WRITE "\${MPIF_REPORT}" "not-found\n\${mpif_NOT_FOUND_MESSAGE}\n")
endif()
if(TARGET mpif::mpifort_abi)
  file(APPEND "\${MPIF_REPORT}" "target\n")
else()
  file(APPEND "\${MPIF_REPORT}" "no-target\n")
endif()
EOF
}

# $1: leg name, $2: extra cmake arguments (word-split on purpose)
configure() {
  rm -rf "$work/build" "$report"
  # shellcheck disable=SC2086
  env -u MPI_HOME cmake \
      -S "$work/src" \
      -B "$work/build" \
      -DMPIF_REPORT="$report" \
      -DCMAKE_PREFIX_PATH="$mpif_prefix" \
      $2 >"$work/$1.log" 2>&1
}

report_line() {  # $1: 1-based line of $report
  sed -n "$1p" "$report" 2>/dev/null || true
}

fail() {
  echo "$(basename "$0"): $1" >&2
  shift
  for line in "$@"; do
    echo "       $line" >&2
  done
  status=1
}

no_mpi_args="-DCMAKE_FIND_ROOT_PATH=$work/empty-root
             -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY"

# Leg 1: an optional consumer with no ABI MPI to be had.
write_project 'find_package(mpif QUIET)'
if configure optional-missing "$no_mpi_args"; then
  found="$(report_line 1)"
  why="$(report_line 2)"
  target="$(report_line 3)"
  if [ "$found" != "not-found" ]; then
    fail "with no libmpi_abi to find, find_package(mpif QUIET) reported $found." \
         "It should report the package as not found."
  elif [ -z "$why" ]; then
    fail "mpif reported itself not found without setting" \
         "mpif_NOT_FOUND_MESSAGE, so a REQUIRED consumer is told nothing" \
         "about what to install or set."
  elif [ "$target" != "no-target" ]; then
    fail "a not-found mpif left mpif::mpifort_abi defined." \
         "The target carries no ABI library, so a consumer that reaches it" \
         "links an executable that dies at its first MPI call."
  else
    echo "  optional consumer, no ABI MPI: configure survived, mpif_FOUND false"
  fi
else
  fail "find_package(mpif QUIET) ended the consumer's configure when no" \
       "libmpi_abi was there to be found. A package configuration file" \
       "reports a failure -- mpif_NOT_FOUND_MESSAGE, mpif_FOUND FALSE," \
       "return() -- rather than raising one, so that mpif can be an optional" \
       "dependency. See $work/optional-missing.log:" \
       "$(tail -n 5 "$work/optional-missing.log" 2>/dev/null)"
fi

# Leg 2: the same absence, REQUIRED. Fixing leg 1 must not mute this one.
write_project 'find_package(mpif REQUIRED)'
if configure required-missing "$no_mpi_args"; then
  fail "find_package(mpif REQUIRED) succeeded with no libmpi_abi anywhere." \
       "A REQUIRED consumer must not configure against an mpif that cannot" \
       "be linked."
elif ! grep -q "MPIF_MPI_ABI_LIBRARY" "$work/required-missing.log"; then
  fail "find_package(mpif REQUIRED) failed without saying what to do about" \
       "it. CMake prints the package's own reason; mpif_NOT_FOUND_MESSAGE" \
       "should name MPI_HOME and MPIF_MPI_ABI_LIBRARY. It said:" \
       "$(tail -n 5 "$work/required-missing.log" 2>/dev/null)"
else
  echo "  REQUIRED consumer, no ABI MPI: configure failed, reason reported"
fi

# Leg 3: an ABI MPI is there. Without this the two legs above would pass on an
# mpif that can never be found at all.
if [ -z "$mpi_prefix" ]; then
  echo "  no <mpi-prefix> given, so the found case is not checked here"
else
  write_project 'find_package(mpif QUIET)'
  if configure optional-present "-DMPI_HOME=$mpi_prefix"; then
    found="$(report_line 1)"
    target="$(report_line 3)"
    if [ "$found" != "found" ]; then
      fail "with MPI_HOME=$mpi_prefix, find_package(mpif QUIET) reported" \
           "$found. The find_library fallback did not turn up" \
           "$mpi_prefix/lib/libmpi_abi."
    elif [ "$target" != "target" ]; then
      fail "mpif reported itself found but defined no mpif::mpifort_abi."
    else
      echo "  optional consumer, MPI_HOME set: found, target defined"
    fi
  else
    fail "find_package(mpif QUIET) with MPI_HOME=$mpi_prefix ended the" \
         "consumer's configure. See $work/optional-present.log:" \
         "$(tail -n 5 "$work/optional-present.log" 2>/dev/null)"
  fi
fi

if [ "$status" -eq 0 ]; then
  echo "$(basename "$0"): the package configuration file keeps its contract"
fi
exit "$status"
