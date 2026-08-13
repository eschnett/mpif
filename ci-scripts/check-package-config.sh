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
# Seven configures, against the installed prefix:
#
#   1. optional, no ABI MPI      -- must succeed, mpif_FOUND false, and a
#                                   reason recorded in mpif_NOT_FOUND_MESSAGE
#   2. REQUIRED, no ABI MPI      -- must fail, and say what to do about it, so
#                                   fixing 1 does not quietly mute 2
#   3. optional, ABI MPI present -- must find it and define the imported
#                                   target, so this script cannot pass by
#                                   never finding anything
#   4. the recorded compiler     -- must not warn
#   5. another compiler          -- must warn, and still configure
#   6. another major version     -- must warn
#   7. another compiler, with
#      MPIF_SKIP_COMPILER_CHECK  -- must not warn
#
# Leg 3 points MPI_HOME at the MPI rather than pinning MPI_mpi_abi_LIBRARY the
# way the test harnesses do, because that is the branch nothing else exercises.
#
# Legs 4-7 are about the other half of what an installed mpif is: a set of
# `.mod` files in one compiler's private format. A consumer using another
# compiler is told so here, once, instead of by whatever its own compiler says
# about the first `use mpi_f08` it meets. Each leg states the consumer's
# compiler by setting CMAKE_Fortran_COMPILER_ID, which is what a project that
# enabled Fortran would have; the probe project still enables no language, so
# no compiler needs to exist for the leg to be run. Leg 4 is the one that keeps
# the other three honest -- without it, a config file that warned unconditionally
# would pass legs 5 and 6.
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

# The compiler-identity legs. They need an mpif that reports itself found --
# the compiler check runs after the ABI library is resolved, so that a consumer
# who has no MPI at all is told that one thing and not two -- hence the same
# guard as leg 3.
#
# What the installation recorded is read out of the config file rather than
# passed in: the value under test is exactly what a consumer will compare
# against, and reading it here also catches an install that recorded nothing.
recorded_id="$(sed -n 's/^set(mpif_Fortran_COMPILER_ID "\(.*\)")$/\1/p' "$config")"
recorded_version="$(sed -n 's/^set(mpif_Fortran_COMPILER_VERSION "\(.*\)")$/\1/p' "$config")"

# A leg's verdict is the presence of the warning in its log. The phrase is the
# first clause of the message in cmake/mpifConfig.cmake.in; matching that rather
# than the word "warning" keeps a warning from anywhere else -- a deprecated
# CMake feature, a policy -- from being read as this one.
warning_phrase="mpif was built with"

# $1: leg name, $2: extra cmake arguments, $3: "warn" or "quiet"
compiler_leg() {
  write_project 'find_package(mpif QUIET)'
  if ! configure "$1" "-DMPI_HOME=$mpi_prefix $2"; then
    fail "the compiler check ended the consumer's configure ($1). It warns;" \
         "it must not raise. See $work/$1.log:" \
         "$(tail -n 5 "$work/$1.log" 2>/dev/null)"
    return
  fi
  if [ "$(report_line 1)" != "found" ] || [ "$(report_line 3)" != "target" ]; then
    fail "the $1 leg left mpif not found or its target undefined, so what it" \
         "says about the compiler warning means nothing."
    return
  fi
  if grep -q "$warning_phrase" "$work/$1.log"; then
    if [ "$3" = "warn" ]; then
      echo "  $1: warned, and configured anyway"
    else
      fail "the $1 leg warned about the Fortran compiler when it should not" \
           "have. mpif was built with $recorded_id $recorded_version." \
           "$(grep -A 8 "$warning_phrase" "$work/$1.log" | head -n 9)"
    fi
  else
    if [ "$3" = "warn" ]; then
      fail "the $1 leg did not warn about the Fortran compiler." \
           "mpif was built with $recorded_id $recorded_version, and this leg" \
           "told the config file it was using something else. A consumer that" \
           "is not told here meets the mismatch as a module-file error in its" \
           "own sources instead."
    else
      echo "  $1: did not warn"
    fi
  fi
}

if [ -z "$mpi_prefix" ]; then
  echo "  no <mpi-prefix> given, so the compiler check is not exercised here"
elif [ -z "$recorded_id" ]; then
  fail "the config file records no mpif_Fortran_COMPILER_ID, so a consumer" \
       "using a different Fortran compiler than the one that built these" \
       "modules is told nothing about it. See $config."
else
  echo "$(basename "$0"): mpif records Fortran compiler" \
       "$recorded_id $recorded_version"

  # Leg 4: the compiler that built it.
  compiler_leg matching-compiler \
    "-DCMAKE_Fortran_COMPILER_ID=$recorded_id
     -DCMAKE_Fortran_COMPILER_VERSION=$recorded_version" quiet

  # Leg 5: another compiler. Whichever of the two this build is not, so that
  # the leg is a mismatch under either toolchain and the message it produces is
  # one a user could really see.
  if [ "$recorded_id" = "GNU" ]; then
    other_id=LLVMFlang
  else
    other_id=GNU
  fi
  compiler_leg other-compiler \
    "-DCMAKE_Fortran_COMPILER_ID=$other_id
     -DCMAKE_Fortran_COMPILER_VERSION=$recorded_version" warn

  # Leg 6: the same compiler, one major version on -- where the module format
  # turns over. Skipped if the recorded version does not begin with a number,
  # which would leave nothing to increment.
  recorded_major="${recorded_version%%.*}"
  case "$recorded_major" in
    ''|*[!0-9]*)
      echo "  recorded version \"$recorded_version\" has no major number," \
           "so the version leg is skipped"
      ;;
    *)
      compiler_leg other-major-version \
        "-DCMAKE_Fortran_COMPILER_ID=$recorded_id
         -DCMAKE_Fortran_COMPILER_VERSION=$((recorded_major + 1)).0.0" warn
      ;;
  esac

  # Leg 7: the escape hatch. A consumer who knows better than the comparison --
  # one using only mpif.h, say -- must be able to turn it off, or the warning
  # becomes something to be ignored on every configure.
  compiler_leg skip-compiler-check \
    "-DCMAKE_Fortran_COMPILER_ID=$other_id
     -DCMAKE_Fortran_COMPILER_VERSION=$recorded_version
     -DMPIF_SKIP_COMPILER_CHECK=ON" quiet
fi

if [ "$status" -eq 0 ]; then
  echo "$(basename "$0"): the package configuration file keeps its contract"
fi
exit "$status"
