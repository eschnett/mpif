#!/bin/bash

# All four macOS variants, the same set CI builds. Keeps going after a failure
# and reports which variants failed, since a problem in one toolchain is
# usually worth seeing next to the others that worked.

set -uo pipefail
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

failed=""
for script in "${here}"/build-macos-{mpich,openmpi}-{gcc,llvm}.sh; do
    echo "### $(basename "${script}")"
    if ! "${script}"; then
        failed="${failed} $(basename "${script}")"
    fi
done

if [[ -n ${failed} ]]; then
    echo "failed:${failed}" >&2
    exit 1
fi
echo "all four variants built and tested"
