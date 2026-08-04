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
# Compiling and linking is not on its own evidence that the installation exposes
# the standard ABI: an installation that still has the implementation's own
# `mpi.h` and its own library compiles this program perfectly well, and then
# every C file in a mixed C/Fortran program disagrees with mpif about what a
# handle is. So the program asserts MPI_ABI_VERSION at compile time and the
# executable is checked for the ABI library afterwards. See MISSING.md
# "An unpruned Open MPI prefix".
#
# Usage: check-mpi-install.sh <prefix>

set -euo pipefail

prefix=${1:?usage: check-mpi-install.sh <prefix>}

workdir=$(mktemp -d)
trap 'rm -rf "${workdir}"' EXIT

cat >"${workdir}/check.c" <<'EOF'
#include <mpi.h>

/* MPI-5.0 section 20.2, "Implementation Requirements": the macros
   MPI_ABI_VERSION and MPI_ABI_SUBVERSION "are present in the MPI header and
   modules so that applications can check for consistency between the
   compilation environment and the properties of the implementation at
   runtime", and are 1 and 0 for MPI-5.0. An implementation that does not
   provide the ABI reports -1 -- which is exactly what Open MPI's own mpi.h
   says, so this catches a prefix whose header was never replaced. */
#if !defined(MPI_ABI_VERSION) || MPI_ABI_VERSION < 1
#error "this mpi.h is not the MPI standard ABI header"
#endif

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

dependencies_of() {
    if [[ $(uname) == Darwin ]]; then
        otool -L "$1"
    else
        readelf -d "$1" | grep -E 'NEEDED|R(UN)?PATH' || true
    fi
}

echo "Dependencies of ${library}:"
dependencies=$(dependencies_of "${library}")
echo "${dependencies:-    (none recorded)}"

"${prefix}/bin/mpicc" -o "${workdir}/check" "${workdir}/check.c"

# Which library the wrapper actually linked. The header assertion above says the
# compilation environment is the ABI; this says the link is too. They can differ:
# Open MPI installs libmpi_abi beside its own libmpi, and its wrapper names the
# latter until install-openmpi.sh repoints it.
linked=$(dependencies_of "${workdir}/check")
if ! grep -q 'libmpi_abi' <<<"${linked}"; then
    echo "error: ${prefix}/bin/mpicc does not link the ABI library." >&2
    echo "       Dependencies of the test program:" >&2
    echo "${linked:-    (none recorded)}" >&2
    exit 1
fi

echo "OK: the installed MPI compiles and links a program that uses the ABI"
echo "    and the Fortran/C handle conversion functions"
