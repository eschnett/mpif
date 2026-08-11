#!/usr/bin/env bash

# Cut a marked source file into one translation unit per MPI_ entry point.
#
# Usage: ci-scripts/split-wrappers.sh <input> <output-dir> <prefix>
#
# Prints nothing on success; writes <output-dir>/<prefix>.manifest, one output
# path per line, which CMakeLists.txt reads to build its source list. The
# output directory is emptied first, so each input needs one of its own; the
# prefix is what keeps object basenames unique once CMake has them all in one
# target.
#
# Why: MPI-5.0 section 15.2.1 requires (2) that MPI functions a profiler has not
# replaced "still be linked into an executable image without causing name
# clashes", and (4) that the wrapper functions of a layered Fortran binding be
# "separable from the rest of the library". Section 15.2.5 says what separable
# means, and it is a statement about archive members: the wrappers must be able
# to be copied "out of the base library and into the profiling one using a tool
# such as ar", "without bringing along any other unnecessary code". A shared mpif
# satisfies both by construction, the executable's definition winning at load
# time. An archive does not, as long as one member holds every wrapper: a
# consumer that defines mpi_send_ collides with the member the link needs for the
# other 585. So a static build compiles each MPI_ entry point on its own.
#
# What is split, and what is not:
#
# - MPI_-named regions get a file each. PMPI_-named regions do not: a profiling
#   library holds the MPI_ wrappers and calls PMPI_ into the base library, so
#   only the MPI_ names have to be extractable and only they can clash. They all
#   go to one <prefix>_rest file. That policy lives here rather than in
#   dev/mpiapi.jl, so revisiting it does not mean regenerating gen/.
# - Whatever lies *outside* a marked region is shared prologue -- the #includes,
#   gen/mpif_functions.c's five #undef/#define pairs, src/mpif_removed.c's
#   macros -- and every output gets a copy of all of it, in file order. That is
#   why the generator marks the PMPI_ bodies too: an unmarked body would be
#   prologue, and would be duplicated into every part.
#
# The outputs depend on the input and on this script and nothing else, so a stamp
# file is enough to make a re-run free. Without it every `cmake` re-run would
# rewrite ~1200 files and force a full rebuild.

set -eu

input="${1:-}"
outdir="${2:-}"
prefix="${3:-}"
if [ -z "$input" ] || [ -z "$outdir" ] || [ -z "$prefix" ]; then
  echo "usage: $(basename "$0") <input> <output-dir> <prefix>" >&2
  exit 1
fi
if [ ! -f "$input" ]; then
  echo "$(basename "$0"): no such file: $input" >&2
  exit 1
fi

me="${BASH_SOURCE[0]}"
stamp="$outdir/$prefix.stamp"
manifest="$outdir/$prefix.manifest"

if [ -f "$stamp" ] && [ -f "$manifest" ] &&
   [ "$stamp" -nt "$input" ] && [ "$stamp" -nt "$me" ]; then
  exit 0
fi

# The extension the parts get, from the input's own: .c stays .c, and .F90 has to
# stay .F90 rather than .f90 because the bodies carry #ifdef MPIF_HAVE_CFI and
# only the capitalised suffix is preprocessed.
case "$input" in
  *.c)   ext=.c ;;
  *.F90) ext=.F90 ;;
  *)     echo "$(basename "$0"): unhandled suffix: $input" >&2; exit 1 ;;
esac

rm -rf "$outdir"
mkdir -p "$outdir"

awk -v outdir="$outdir" -v prefix="$prefix" -v ext="$ext" \
    -v manifest="$manifest" -v me="$(basename "$0")" '
  { line[NR] = $0 }

  END {
    # First pass: the prologue is every line outside a marked region, in order.
    # Runs of blank lines collapse to one: the generator separates its entry
    # points with a blank line, which is outside every region, so without this
    # each part would carry 1180 of them ahead of its own body.
    # The depth is checked per line, not just at the end. A net-balance check
    # alone accepts a nested or misordered pair, and either one silently drops
    # code rather than failing: a region opened inside a region ends at the
    # first END, so the tail of the outer region joins the prologue that every
    # part carries, and an END ahead of its BEGIN takes the lines before it
    # into a region no name closes. The generated markers cannot get this
    # wrong, but the ones in src/mpif_removed.c are written by hand. The second
    # pass below walks the same lines and so needs no check of its own.
    #
    # No apostrophes in this comment: the whole awk program is a single-quoted
    # shell word.
    depth = 0
    blank = 0
    for (i = 1; i <= NR; i++) {
      if (index(line[i], "MPIF-SPLIT-BEGIN ")) {
        if (++depth > 1) {
          printf "%s: nested MPIF-SPLIT-BEGIN at line %d\n", me, i > "/dev/stderr"
          exit 1
        }
        continue
      }
      if (index(line[i], "MPIF-SPLIT-END")) {
        if (--depth < 0) {
          printf "%s: MPIF-SPLIT-END without a BEGIN at line %d\n", me, i > "/dev/stderr"
          exit 1
        }
        continue
      }
      if (depth != 0) continue
      if (line[i] ~ /^[ \t]*$/) { if (blank++) continue } else blank = 0
      prologue = prologue line[i] "\n"
    }
    if (depth != 0) {
      printf "%s: unterminated MPIF-SPLIT-BEGIN\n", me > "/dev/stderr"
      exit 1
    }

    # Second pass: each MPI_ region to a file of its own, everything else to one.
    depth = 0
    count = 0
    for (i = 1; i <= NR; i++) {
      if (index(line[i], "MPIF-SPLIT-BEGIN ")) {
        depth++
        nf = split(line[i], field, " ")
        name = field[nf]
        body = ""
        continue
      }
      if (index(line[i], "MPIF-SPLIT-END")) {
        depth--
        if (tolower(name) ~ /^mpi_/) {
          path = outdir "/" prefix "_" tolower(name) ext
          if (path in written) {
            printf "%s: two regions map to %s\n", me, path > "/dev/stderr"
            exit 1
          }
          written[path] = 1
          printf "%s%s", prologue, body > path
          close(path)
          print path > manifest
          count++
        } else {
          rest = rest body
        }
        continue
      }
      if (depth > 0) body = body line[i] "\n"
    }

    # Always written, even when empty: CMake lists it unconditionally, and for
    # gen/mpif_f08_wrappers.F90 it is where every PMPI_ specific lives.
    path = outdir "/" prefix "_rest" ext
    printf "%s%s", prologue, rest > path
    close(path)
    print path > manifest
    close(manifest)

    if (count == 0) {
      printf "%s: no MPIF-SPLIT-BEGIN markers in the input\n", me > "/dev/stderr"
      exit 1
    }
  }
' "$input"

touch "$stamp"
