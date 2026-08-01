#!/bin/bash

# Remove the files that an MPI installation must not expose to mpif.
#
# mpif requires an MPI that provides *only* the standard ABI: the
# implementation's own `mpi.h`, Fortran modules and non-ABI libraries must be
# gone, otherwise a build can silently pick them up instead of the ABI ones.
#
# Usage: prune-install.sh <prefix> <list-file>
#
# <list-file> holds one glob per line, relative to <prefix>. Blank lines and
# `#` comments are ignored. A pattern matching nothing is reported as a warning
# rather than an error, since upstream renames files from time to time and a
# stale entry should not break the build.
#
# This script deliberately uses no arrays: macOS still ships bash 3.2, where
# expanding an empty array under `set -u` is an error rather than an empty list.

set -euo pipefail
shopt -s nullglob extglob

prefix=${1:?usage: prune-install.sh <prefix> <list-file>}
list=${2:?usage: prune-install.sh <prefix> <list-file>}

missing=""
missing_count=0

while IFS= read -r line || [[ -n ${line} ]]; do
    # Strip the comment, then surrounding whitespace. This must not go through
    # `echo`: with `nullglob` set, an unquoted glob that matches nothing in the
    # current directory would expand to nothing and the pattern would silently
    # be dropped.
    pattern=${line%%#*}
    pattern=${pattern##+([[:space:]])}
    pattern=${pattern%%+([[:space:]])}
    if [[ -z ${pattern} ]]; then
        continue
    fi

    # Iterate the glob directly. `nullglob` makes a pattern that matches
    # nothing expand to no words at all, so the body simply does not run; a
    # pattern without wildcards always yields one word, hence the -e test.
    # shellcheck disable=SC2231  # the pattern must be glob-expanded
    found=0
    for match in "${prefix}"/${pattern}; do
        if [[ -e ${match} || -L ${match} ]]; then
            rm -rf "${match}"
            found=1
        fi
    done

    if [[ ${found} -eq 0 ]]; then
        missing="${missing}    ${pattern}"$'\n'
        missing_count=$((missing_count + 1))
    fi
done <"${list}"

if [[ ${missing_count} -gt 0 ]]; then
    echo "prune-install.sh: warning: ${missing_count} pattern(s) from" \
         "$(basename "${list}") matched nothing in ${prefix}:" >&2
    printf '%s' "${missing}" >&2
    echo "prune-install.sh: warning: has the MPI installation layout changed?" >&2
fi
