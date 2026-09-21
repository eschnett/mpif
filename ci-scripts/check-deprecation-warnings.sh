#!/usr/bin/env bash

# Check that the fifteen routines mpif keeps outside the ABI warn at the call
# site, and that marking them broke nothing.
#
# mpif offers the five MPI-1 attribute routines MPI-2.0 deprecated and the ten
# MPI-1 routines MPI-3.0 removed, none of which are in the MPI-5.0 ABI (20.2.1).
# They are marked `!GCC$ ATTRIBUTES DEPRECATED` behind
# MPIF_HAVE_DEPRECATED_ATTRIBUTE, in gen/mpif_functions.F90,
# gen/mpif_f08_functions.F90 and src/mpif_removed.F90. See "Deprecation
# warnings" in CODE.md.
#
# Three things can go wrong silently, which is why this exists rather than a
# reading of the sources:
#
# - The directive reaches no one. A directive on a *generic* interface name is
#   accepted and does nothing, and the `#ifdef` may simply be off. Either way
#   the build is green and the warning never appears.
# - The directive breaks a caller. gfortran 9 and 10 reject the attribute
#   outright, so anything that carries it unguarded stops compiling.
# - mpif.h stops being includable. It is read by Fortran `include` and never
#   preprocessed, so it can carry no guard and therefore no directive; an
#   attempt to put one there would fail here rather than in a user's build.
#
# Whether the compiler *acts* on the attribute is measured here, not assumed:
# flang accepts the directive and ignores it, so CMake's probe says yes for a
# compiler that will never warn. This compiles its own module and looks for the
# warning, and holds mpif to the same standard only when its own probe warns.
#
# Usage: check-deprecation-warnings.sh <mpif-prefix>
#
# Environment:
#   FC   Fortran compiler for the self-probe (default: the prefix's mpifort)

set -euo pipefail

prefix=${1:?usage: check-deprecation-warnings.sh <mpif-prefix>}
mpifort=${prefix}/bin/mpifort

if [[ ! -x ${mpifort} ]]; then
    echo "check-deprecation-warnings.sh: no ${mpifort}" >&2
    exit 1
fi

workdir=$(mktemp -d)
trap 'rm -rf "${workdir}"' EXIT
cd "${workdir}"

status=0

# Compile <file> and print whatever the compiler said; the exit status is the
# compiler's. Output goes to a file rather than a variable so that a failing
# compile can be shown in full.
compile() {
    "${mpifort}" -c "$1" -o "${1%.*}.o" >"$1.log" 2>&1
}

# --- does this compiler act on the attribute at all? ---------------------

cat >probe_mod.F90 <<'EOF'
module probe_mod
  implicit none
  external :: probe_sub
!GCC$ ATTRIBUTES DEPRECATED :: probe_sub
end module probe_mod
EOF
cat >probe_use.f90 <<'EOF'
program probe_use
  use probe_mod
  implicit none
  call probe_sub()
end program probe_use
EOF

acts=no
if compile probe_mod.F90 && compile probe_use.f90 &&
       grep -qi 'deprecat' probe_use.f90.log; then
    acts=yes
fi

case ${acts} in
    yes) echo "check-deprecation-warnings.sh: this compiler acts on" \
              "!GCC\$ ATTRIBUTES DEPRECATED; the calls below must warn" ;;
    no)  echo "check-deprecation-warnings.sh: this compiler does not warn on" \
              "!GCC\$ ATTRIBUTES DEPRECATED (accepted and ignored, or rejected);" \
              "the calls below are only required to compile" ;;
esac

# --- the calls themselves ------------------------------------------------
#
# One per interface and per half of the list: a deprecated attribute routine
# through `use mpi` and through `use mpi_f08`, and a removed routine through
# `use mpi`. mpif.h is the fourth and is the one that must *not* warn.

cat >use_mpi_deprecated.f90 <<'EOF'
program use_mpi_deprecated
  use mpi
  implicit none
  integer :: keyval, ierror
  call MPI_Keyval_create(MPI_NULL_COPY_FN, MPI_NULL_DELETE_FN, keyval, 0, ierror)
end program use_mpi_deprecated
EOF

cat >use_mpi_removed.f90 <<'EOF'
program use_mpi_removed
  use mpi
  implicit none
  integer :: buf, address, ierror
  call MPI_Address(buf, address, ierror)
end program use_mpi_removed
EOF

cat >use_mpi_f08_deprecated.f90 <<'EOF'
program use_mpi_f08_deprecated
  use mpi_f08
  implicit none
  integer :: keyval, attribute_val, ierror
  keyval = 0
  attribute_val = 0
  call MPI_Attr_put(MPI_COMM_WORLD, keyval, attribute_val, ierror)
end program use_mpi_f08_deprecated
EOF

# Fixed form, as mpif.h's own callers are, and calling a routine from each half
# of the list. Nothing here can warn: mpif.h is never preprocessed, so it
# carries no guarded directive and declares neither of these names.
cat >include_mpif.f <<'EOF'
      program incmpif
      implicit none
      include 'mpif.h'
      integer buf, address, ierror, keyval
      call MPI_Address(buf, address, ierror)
      call MPI_Keyval_create(MPI_NULL_COPY_FN, MPI_NULL_DELETE_FN,
     &     keyval, 0, ierror)
      end
EOF

check_warns() {
    local src=$1 what=$2
    if ! compile "${src}"; then
        echo "check-deprecation-warnings.sh: ${what} does not compile:" >&2
        sed 's/^/    /' "${src}.log" >&2
        status=1
        return
    fi
    if grep -qi 'deprecat' "${src}.log"; then
        if [[ ${acts} == yes ]]; then
            printf '  %-28s warns, as it should\n' "${what}"
        else
            echo "check-deprecation-warnings.sh: ${what} warned although the" \
                 "self-probe did not; the probe is wrong" >&2
            status=1
        fi
    elif [[ ${acts} == yes ]]; then
        echo "check-deprecation-warnings.sh: ${what} compiles without a" \
             "deprecation warning, but this compiler acts on the attribute." >&2
        echo "    Either MPIF_HAVE_DEPRECATED_ATTRIBUTE was off for this" \
             "build, or the directive names something the call does not" \
             "resolve to -- a generic rather than a specific, say." >&2
        status=1
    else
        printf '  %-28s compiles (no warning expected here)\n' "${what}"
    fi
}

check_must_not_warn() {
    local src=$1 what=$2
    if ! compile "${src}"; then
        echo "check-deprecation-warnings.sh: ${what} does not compile:" >&2
        sed 's/^/    /' "${src}.log" >&2
        status=1
        return
    fi
    if grep -qi 'deprecat' "${src}.log"; then
        echo "check-deprecation-warnings.sh: ${what} warned. mpif.h is read by" \
             "Fortran \`include\` and never preprocessed, so a directive there" \
             "cannot be guarded and would break gfortran 9 and 10." >&2
        status=1
        return
    fi
    printf '  %-28s compiles and stays quiet\n' "${what}"
}

check_warns use_mpi_deprecated.f90 "use mpi, deprecated"
check_warns use_mpi_removed.f90 "use mpi, removed"
check_warns use_mpi_f08_deprecated.f90 "use mpi_f08, deprecated"
check_must_not_warn include_mpif.f "include 'mpif.h'"

if [[ ${status} -eq 0 ]]; then
    echo "check-deprecation-warnings.sh: ok"
fi
exit "${status}"
