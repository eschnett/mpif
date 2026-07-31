#!/bin/bash

# Check that a pruned MPI installation is still usable, by compiling and
# linking a trivial program with the installed wrapper compiler.
#
# Pruning deletes the implementation's non-ABI libraries (see
# prune-install.sh). If the ABI library still depends on one of them, the
# installation is broken -- and the symptom otherwise appears much later and
# much less clearly, as CMake reporting `Could NOT find MPI_C (missing:
# MPI_C_WORKS)` with the actual linker error buried in its configure log.
#
# The test program also calls MPI_Comm_c2f, so this doubles as a check that the
# Fortran/C handle conversion functions that mpif adds are really exported.
#
# Usage: check-mpi-install.sh <prefix>

set -euo pipefail

prefix=${1:?usage: check-mpi-install.sh <prefix>}

workdir=$(mktemp -d)
trap 'rm -rf "${workdir}"' EXIT

cat >"${workdir}/check.c" <<'EOF'
#include <mpi.h>

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Fint fcomm = MPI_Comm_c2f(MPI_COMM_WORLD);
    (void)fcomm;
    MPI_Finalize();
    return 0;
}
EOF

echo "Checking the MPI installation in ${prefix}"

# What the wrapper thinks it should do (MPICH spells this `-show`, Open MPI
# `--showme`); purely informational, so do not fail if neither is understood.
"${prefix}/bin/mpicc" -show 2>/dev/null ||
    "${prefix}/bin/mpicc" --showme 2>/dev/null ||
    echo "(the wrapper compiler does not report its command line)"

# What the ABI library depends on. This is where a library that pruning removed
# but that is still needed shows up.
library=""
for candidate in "${prefix}"/lib/libmpi_abi.dylib "${prefix}"/lib/libmpi_abi.so; do
    if [[ -e ${candidate} ]]; then
        library=${candidate}
        break
    fi
done
if [[ -z ${library} ]]; then
    echo "error: no libmpi_abi library in ${prefix}/lib:" >&2
    ls "${prefix}/lib" >&2
    exit 1
fi

echo "Dependencies of ${library}:"
if [[ $(uname) == Darwin ]]; then
    otool -L "${library}"
else
    dependencies=$(readelf -d "${library}" | grep -E 'NEEDED|R(UN)?PATH' || true)
    echo "${dependencies:-    (none recorded)}"
fi

"${prefix}/bin/mpicc" -o "${workdir}/check" "${workdir}/check.c"

echo "OK: the installed MPI compiles and links a program that uses the ABI"
echo "    and the Fortran/C handle conversion functions"
