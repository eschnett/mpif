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

set -euo pipefail
shopt -s nullglob extglob

prefix=${1:?usage: prune-install.sh <prefix> <list-file>}
list=${2:?usage: prune-install.sh <prefix> <list-file>}

missing=()

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

    # shellcheck disable=SC2206  # the pattern must be glob-expanded
    matches=("${prefix}"/${pattern})

    # `nullglob` drops patterns that match nothing, but a pattern without
    # wildcards survives even when the file is absent, so check explicitly.
    found=()
    for match in "${matches[@]}"; do
        if [[ -e ${match} || -L ${match} ]]; then
            found+=("${match}")
        fi
    done

    if [[ ${#found[@]} -eq 0 ]]; then
        missing+=("${pattern}")
        continue
    fi

    rm -rf "${found[@]}"
done <"${list}"

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "prune-install.sh: warning: ${#missing[@]} pattern(s) from" \
         "$(basename "${list}") matched nothing in ${prefix}:" >&2
    printf '    %s\n' "${missing[@]}" >&2
    echo "prune-install.sh: warning: has the MPI installation layout changed?" >&2
fi
