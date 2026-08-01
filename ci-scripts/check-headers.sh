#!/bin/bash

# Check that every Cray pointer in mpif_constants.h is the variable C
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
