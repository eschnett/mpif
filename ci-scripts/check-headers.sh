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
# Second: that every Cray pointer in mpif_constants.h is the variable C
# initialises.
#
# The sentinels -- MPI_BOTTOM, MPI_STATUS_IGNORE and the rest -- are Cray
# pointers whose pointer variable lives in a common block that
# src/mpif_constants.c defines. If the name in `pointer (P, X)` differs from the
# one in `common /P/ P`, the pointer is a fresh implicitly declared local that
# nothing ever assigns, X ends up at an arbitrary address, and MPI writes
# through it. Nothing warns: both spellings are valid Fortran.
#
# This went unnoticed in MPI_STATUS_IGNORE for a while, so check it mechanically.

set -eu

srcdir="$(cd "$(dirname "$0")/.." && pwd)"
header="$srcdir/include/mpif_constants.h"
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

while read -r ptr target; do
  # The pointer variable must appear in a common block of the same name...
  if ! grep -q "^ *common /$ptr/ *$ptr *$" "$header"; then
    echo "$header: pointer ($ptr, $target) has no matching 'common /$ptr/ $ptr'" >&2
    status=1
    continue
  fi
  # ...and C must define it, under the usual Fortran linkage name.
  lower="$(echo "$ptr" | tr '[:upper:]' '[:lower:]')"
  if ! grep -q "\\b${lower}_\\b" "$csrc"; then
    echo "$header: pointer ($ptr, $target) is not defined by $csrc as ${lower}_" >&2
    status=1
  fi
done < <(sed -n 's/^ *pointer (\([A-Za-z0-9_]*\), *\([A-Za-z0-9_]*\)).*/\1 \2/p' "$header")

if [ $status -eq 0 ]; then
  echo "mpif_constants.h: all Cray pointers are paired with their common block and C definition"
fi

exit $status
