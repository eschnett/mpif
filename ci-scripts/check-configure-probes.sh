#!/usr/bin/env bash

# Report what mpif's configure stage decided about the Fortran compiler, and
# fail on the one answer that is wrong everywhere.
#
# This exists for the compile-only stage (ci-scripts/compile-only.sh), where a
# build that merely succeeds proves less than it looks like it does. Every
# probe in CMakeLists.txt guards code: a false one silently removes routines
# from the library, and MPIF_HAVE_CFI silently chooses between two different
# bodies of generated code. A probe that comes out wrong for an unrelated
# reason -- the compiler rejecting `loc`, the C compiler unable to find
# ISO_Fortran_binding.h -- still builds, and reports nothing. Both have
# happened here: HISTORY.md's MPIF_HAVE_INTEGER16 guarding specifics nothing
# defined, and commit eb18f28's macOS/llvm rows taking the CFI fallback
# quietly, which only the suite gate noticed.
#
# So the values are printed for a human to read against the compiler in the
# job's name, and the one invariant that does not depend on the compiler is
# asserted.
#
# Usage: check-configure-probes.sh <build-dir>

set -euo pipefail

builddir=${1:?usage: check-configure-probes.sh <build-dir>}
cache=${builddir}/CMakeCache.txt

if [[ ! -f ${cache} ]]; then
    echo "check-configure-probes.sh: no ${cache}" >&2
    exit 1
fi

# The raw cache value of <name>, or the empty string if it is absent. Entries
# are `<name>:<type>=<value>`.
cache_value() {
    sed -n "s|^$1:[A-Z]*=||p" "${cache}" | head -1
}

# The pointer width, which decides the address-kind invariant below. Not a
# cache entry: CMake records it as CMAKE_C_SIZEOF_DATA_PTR in the compiler
# description it writes beside the cache.
pointer_size() {
    sed -n 's|^set(CMAKE_C_SIZEOF_DATA_PTR "\([0-9]*\)").*|\1|p' \
        "${builddir}"/CMakeFiles/*/CMakeCCompiler.cmake 2>/dev/null | head -1
}

# CMake spells a false probe as an empty value, and a true one as 1 or TRUE.
is_true() {
    case $(cache_value "$1") in
        ""|OFF|FALSE|NO|0|*-NOTFOUND) return 1 ;;
        *) return 0 ;;
    esac
}

report() {
    if is_true "$1"; then
        printf 'probe %-46s yes\n' "$1"
    else
        printf 'probe %-46s no\n' "$1"
    fi
}

echo "Configure probes in ${builddir}"
printf 'probe %-46s %s\n' CMAKE_Fortran_COMPILER "$(cache_value CMAKE_Fortran_COMPILER)"
printf 'probe %-46s %s\n' CMAKE_C_COMPILER "$(cache_value CMAKE_C_COMPILER)"
printf 'probe %-46s %s\n' pointer-size "$(pointer_size)"

# Optional kinds: each removes specifics from the mpi module where it is false.
report HAVE_LOGICAL16
report HAVE_INTEGER16
report HAVE_REAL2
report HAVE_REAL16

# Extensions mpif needs. The first two ask gfortran's spelling of the flag, so
# a compiler that has the feature without the flag reports "no" and is fine --
# flang does, measured. HAVE_Fortran_cray_pointer is the feature itself, and a
# "no" there has already stopped the configure with a message of its own.
report Fortran_flag_allow_argument_mismatch
report Fortran_flag_cray_pointer
report HAVE_Fortran_cray_pointer

# The large-count generics that are legal on only one width, and whether the
# compiler agrees with the rule that decided them.
report MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND
report MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND
report MPIF_GENERIC_DISTINGUISHES_ADDRESS_FROM_INTEGER
report MPIF_GENERIC_DISTINGUISHES_ADDRESS_FROM_COUNT

# TS 29113 choice buffers -- the one probe whose answer changes which code
# exists. MPIF_CFI_HEADER says whether cmake/cfi-include-dir.cmake had to find
# the Fortran compiler's copy, and where.
report MPIF_ENABLE_CFI
report MPIF_HAVE_CFI
report MPIF_CFI_HEADER_IN_C_PATH
printf 'probe %-46s %s\n' MPIF_CFI_HEADER "$(cache_value MPIF_CFI_HEADER)"

status=0

# In the standard ABI MPI_Aint is intptr_t while MPI_Count is int64_t, so on a
# 64-bit platform MPI_ADDRESS_KIND (8) differs from the default integer kind
# (4) and not from MPI_COUNT_KIND (8), and on a 32-bit one it is the other way
# round. Exactly one of the two, always, and which one follows from the pointer
# width alone -- so this is checkable without knowing anything about the
# compiler, which is the point. Eight routines' generics are emitted under
# these guards; both false would drop them everywhere and both true would be a
# duplicate-specific error, and neither is a thing a compiler is entitled to.
integer_differs=no
count_differs=no
is_true MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND && integer_differs=yes
is_true MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND && count_differs=yes

size=$(pointer_size)
case ${size} in
    8) want_integer=yes want_count=no ;;
    4) want_integer=no want_count=yes ;;
    *) echo "check-configure-probes.sh: the C compiler's pointer size is" \
            "\"${size}\", neither 4 nor 8" >&2
       exit 1 ;;
esac

if [[ ${integer_differs} != "${want_integer}" || ${count_differs} != "${want_count}" ]]; then
    echo "check-configure-probes.sh: the address-kind probes disagree with a" \
         "$(( size * 8 ))-bit platform:" >&2
    echo "  MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND is ${integer_differs}," \
         "expected ${want_integer}" >&2
    echo "  MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND   is ${count_differs}," \
         "expected ${want_count}" >&2
    echo "  Each probe is a generic over two specifics differing only in one" \
         "argument's kind, so a compiler that rejected it for an unrelated" \
         "reason reports the same 'no' as one where the kinds agree." >&2
    status=1
fi

# A compiler that resolves generics by some rule other than the standard's is
# reported and not refused: mpif emits what the standard says is legal, so the
# generated code is right either way, and following the compiler instead would
# mean emitting an ambiguous generic. nvfortran 26.5 is the measured case; see
# MISSING.md. Named as a defect rather than left to be read off two lines.
for pair in INTEGER:MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND \
            COUNT:MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND; do
    which=${pair%%:*}
    guard=${pair#*:}
    agrees=MPIF_GENERIC_DISTINGUISHES_ADDRESS_FROM_${which}
    if is_true "${guard}"; then want=yes; else want=no; fi
    if is_true "${agrees}"; then got=yes; else got=no; fi
    if [[ ${want} != "${got}" ]]; then
        echo "note: this compiler resolves generics by its own rule:" \
             "${guard} is ${want}, but it says a generic over the two" \
             "specifics is ${got}. mpif follows the standard. Not fatal."
    fi
done

# -DMPIF_ENABLE_CFI=OFF is how the fallback branch stays testable; a build that
# asked for it and got the TS branch anyway is testing the wrong one.
if ! is_true MPIF_ENABLE_CFI && is_true MPIF_HAVE_CFI; then
    echo "check-configure-probes.sh: MPIF_ENABLE_CFI is off but MPIF_HAVE_CFI" \
         "is on" >&2
    status=1
fi

exit "${status}"
