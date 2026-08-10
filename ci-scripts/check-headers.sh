#!/usr/bin/env bash

# Two consistency checks on mpif's headers.
#
# First: mpif's version. It is written down twice -- `project(mpif VERSION
# x.y.z)` in CMakeLists.txt, which is what src/mpif_check.c gets compiled
# with, and the MPIF_VERSION/MPIF_SUBVERSION/MPIF_PATCH parameters in
# include/mpif_constants.h, which is what callers see -- and nothing else ties
# the two together. (SOVERSION is deliberately not compared: CMakeLists.txt
# declares it an independent single number.) mpif_check_environment compares
# the same pair at run time, which catches an install mixing pieces of two
# builds; this catches the plain edit-one-forget-the-other in CI.
#
# Second: that every sentinel COMMON block is one src/mpif_constants.c defines,
# and that the set of sentinels is the standard's.
#
# The sentinels -- MPI_BOTTOM, MPI_STATUS_IGNORE and the rest -- are COMMON
# blocks whose storage src/mpif_constants.c defines, and a wrapper recognises one
# by comparing the address it was handed against that storage. Rename a block
# without renaming the cell and the two stop being the same object: the compare
# never matches, the sentinel is passed to MPI as an ordinary buffer, and nothing
# warns. mpif_check_environment catches it at run time, in any of the three
# interfaces; this catches it in CI without a build, and covers both declaration
# sites where the run-time check needs a working library.
#
# The set is checked too, against MPI-5.0 2.5.4's list of the ten constants that
# "cannot be used in initialization expressions or assignments in Fortran", so
# that a sentinel added to the standard cannot be half-implemented.

set -eu

srcdir="$(cd "$(dirname "$0")/.." && pwd)"
header="$srcdir/include/mpif_constants.h"
f08_header="$srcdir/src/mpif_f08_types.F90"
csrc="$srcdir/src/mpif_constants.c"

status=0

cmake_version="$(sed -n 's/^ *mpif VERSION \([0-9][0-9.]*\).*/\1/p' "$srcdir/CMakeLists.txt")"
if [ -z "$cmake_version" ]; then
  echo "CMakeLists.txt: found no 'mpif VERSION x.y.z' line to compare against" >&2
  status=1
else
  for pair in "MPIF_VERSION:1" "MPIF_SUBVERSION:2" "MPIF_PATCH:3"; do
    param="${pair%:*}"
    component="$(echo "$cmake_version" | cut -d. -f"${pair#*:}")"
    declared="$(sed -n "s/^ *integer, parameter :: $param *= *\([0-9][0-9]*\).*/\1/p" "$header")"
    if [ -z "$declared" ]; then
      echo "$header: found no 'integer, parameter :: $param = ...' line" >&2
      status=1
    elif [ "$declared" != "$component" ]; then
      echo "$header: $param is $declared but CMakeLists.txt says mpif VERSION $cmake_version" >&2
      status=1
    fi
  done
fi

if [ $status -eq 0 ]; then
  echo "mpif_constants.h: MPIF_VERSION/MPIF_SUBVERSION/MPIF_PATCH match CMakeLists.txt's $cmake_version"
fi

# Every sentinel COMMON block, from both files that declare one, against the C
# definition it has to be merged onto. The linkage name is the block name
# lowercased with a trailing underscore, which is what src/mpif_constants.c
# spells and what every toolchain mpif is built with produces.
found=""
while read -r file block var; do
  lower="$(echo "$block" | tr '[:upper:]' '[:lower:]')"
  if ! grep -q "\\b${lower}_\\[" "$csrc"; then
    echo "$file: common /$block/ $var is not defined by $csrc as ${lower}_" >&2
    status=1
  fi
  found="$found $var"
done < <(
  sed -n 's|^ *common /\(MPIF_[A-Z0-9_]*\)/ *\([A-Za-z0-9_]*\) *$|'"$header"' \1 \2|p' "$header"
  sed -n 's|^ *common /\(MPIF_[A-Z0-9_]*\)/ *\([A-Za-z0-9_]*\) *$|'"$f08_header"' \1 \2|p' "$f08_header"
)

# And the set is the standard's ten. mpi_f08's two status sentinels are separate
# objects under names already in the list, so counting distinct names gives ten
# either way.
expected="MPI_ARGVS_NULL MPI_ARGV_NULL MPI_BOTTOM MPI_BUFFER_AUTOMATIC
MPI_ERRCODES_IGNORE MPI_IN_PLACE MPI_STATUSES_IGNORE MPI_STATUS_IGNORE
MPI_UNWEIGHTED MPI_WEIGHTS_EMPTY"
actual="$(echo "$found" | tr ' ' '\n' | grep -v '^$' | sort -u)"
if [ "$actual" != "$(echo "$expected" | tr -s ' \n' '\n' | sort -u)" ]; then
  echo "the sentinels declared as COMMON blocks are not MPI-5.0 2.5.4's ten:" >&2
  diff <(echo "$expected" | tr -s ' \n' '\n' | sort -u) <(echo "$actual") >&2 || true
  status=1
fi

if [ $status -eq 0 ]; then
  echo "mpif_constants.h, mpif_f08_types.F90: all ten sentinels' common blocks have their C definition"
fi

exit $status
