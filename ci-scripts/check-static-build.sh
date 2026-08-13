#!/usr/bin/env bash

# Check that an mpif installation asked for a static build really is one, and
# that the sentinel cells survived the archive.
#
# Usage: ci-scripts/check-static-build.sh <mpif-prefix>
#
# Two silent failures, both of which leave every test passing.
#
# The first is not being static at all. `bin/mpifort` links a bare
# `-lmpif`, so a prefix holding both an archive and a shared library lets
# the linker choose, and it chooses the shared one -- which is a perfectly good
# mpif, so the whole run is green and says nothing about archives. The prefix
# therefore has to hold the archive and nothing else, and the one installed
# executable has to prove it by not naming libmpif among its dynamic
# dependencies.
#
# The second is the one static linking actually risks, and nothing else can see
# it. The ten Fortran sentinels are COMMON blocks whose storage
# src/mpif_constants.c defines as read-only, poisoned cells, and it is the
# *address* that identifies a sentinel; a consumer's COMMON is a tentative
# definition the linker merges onto that cell. An archive yields a member only
# when something references a symbol in it -- and a consumer's COMMON is a
# definition rather than a reference, so nothing in the consumer asks for the
# cells. What does is gen/mpif_functions.c, reached because the consumer called
# some wrapper.
#
# Should that chain ever break, the link still succeeds and the program still
# works: the consumer's own tentative definitions become the definitions, C and
# Fortran resolve the same symbol to the same address, and every translation
# still matches. What is silently lost is both backstops behind the translation:
#
# - the cells are `const`, so a missed translation that makes MPI *write* through
#   a sentinel faults on the spot instead of corrupting. A consumer's COMMON is
#   writable, so that becomes a quiet scribble.
# - the cells are poisoned, so a missed *read* sends something conspicuous. A
#   consumer's COMMON is zero-filled. Measured: MPI_BOTTOM(1) reads 0xBAADC0DE
#   through the archive's cell and 0x00000000 without it.
#
# mpif_check_environment cannot catch this and does not claim to: it compares the
# Fortran sentinel's address against the cell, and those are one symbol whichever
# definition won, so it passes either way -- measured, with test/check_f08 against
# an archive the cell member had been removed from. The section each cell landed
# in is the only thing that tells the two apart, which is why this check exists
# and why it is not a duplicate of the run-time one.

set -eu

prefix="${1:-}"
if [ -z "$prefix" ]; then
  echo "usage: $(basename "$0") <mpif-prefix>" >&2
  exit 1
fi

repodir="$(cd "$(dirname "$0")/.." && pwd)"
me="$(basename "$0")"
status=0

# --- the archive, and nothing beside it -----------------------------------

archive="$prefix/lib/libmpif.a"
if [ ! -e "$archive" ]; then
  echo "$me: no $archive." >&2
  echo "       This prefix was not built with -DBUILD_SHARED_LIBS=OFF." >&2
  exit 1
fi

shared=""
for candidate in \
    "$prefix"/lib/libmpif.so \
    "$prefix"/lib/libmpif.so.* \
    "$prefix"/lib/libmpif.dylib \
    "$prefix"/lib/libmpif.*.dylib; do
  if [ -e "$candidate" ]; then
    shared="$shared $candidate"
  fi
done
if [ -n "$shared" ]; then
  echo "$me: $prefix/lib holds a shared library as well as the archive:" >&2
  for lib in $shared; do echo "         $lib" >&2; done
  echo "       \`-lmpif\` would then be ambiguous and every test would" >&2
  echo "       link the shared one. Install a static build into a prefix of" >&2
  echo "       its own." >&2
  exit 1
fi

# --- the installed executable is linked against the archive ----------------
#
# mpif_info is linked exactly the way an application is -- see CMakeLists.txt --
# so what it depends on is what a user's binary will depend on.

exe="$prefix/bin/mpif_info"
if [ ! -x "$exe" ]; then
  echo "$me: no $exe, so there is nothing to check the link of" >&2
  exit 1
fi

# The dynamic dependencies, in whichever spelling this platform has.
if command -v otool >/dev/null 2>&1; then
  needed="$(otool -L "$exe" | tail -n +2)"
elif command -v readelf >/dev/null 2>&1; then
  needed="$(readelf -d "$exe" | grep NEEDED || true)"
elif command -v objdump >/dev/null 2>&1; then
  needed="$(objdump -p "$exe" | grep NEEDED || true)"
else
  echo "$me: neither otool, readelf nor objdump is available," \
       "so the link cannot be checked" >&2
  exit 1
fi
if [ -z "$needed" ]; then
  echo "$me: found no dynamic dependencies of $exe at all," \
       "so this check cannot say anything about it" >&2
  exit 1
fi

# `libmpif\.` and not a bare `libmpif`: the name is a prefix of MPICH's own
# `libmpifort`, which a prefix that was pruned wrongly could still be carrying,
# and matching that here would report the wrong defect. Every shared form of
# this library has a dot after the name -- libmpif.so.1, libmpif.1.dylib.
if grep -q 'libmpif\.' <<<"$needed"; then
  echo "$me: $exe still depends on libmpif at run time:" >&2
  printf '%s\n' "$needed" | grep 'libmpif\.' | sed 's/^/         /' >&2
  echo "       It was linked against a shared mpif, not the archive." >&2
  status=1
fi

# The other half of the same claim: mpif is static, the MPI is not. MPI-5.0
# section 20.2.1 wants mpi_abi to be the application binary's sole direct MPI
# dependency, and it is the loader that picks the implementation -- so an
# executable that had swallowed the MPI too would have lost that.
if ! grep -q 'libmpi_abi' <<<"$needed"; then
  echo "$me: $exe does not depend on libmpi_abi." >&2
  echo "       A static mpif still links the MPI dynamically; see" >&2
  echo "       \"Choosing the MPI at run time\" in CODE.md." >&2
  status=1
fi

# --- every sentinel cell came out of the archive ---------------------------
#
# The names are read from the header that declares them rather than listed here,
# so this cannot fall behind the set the way a copy would. Same rule as
# ci-scripts/check-headers.sh, which pins that set to MPI-5.0 section 2.5.4's
# ten.

sentinels_header="$repodir/include/mpif_sentinels.h"
cells="$(sed -n 's|^extern const [A-Za-z_][A-Za-z_0-9]* \(mpif_[a-z0-9_]*\)\[.*|\1|p' \
    "$sentinels_header")"
if [ -z "$cells" ]; then
  echo "$me: found no cell declarations in $sentinels_header," \
       "so this check cannot say anything about them" >&2
  exit 1
fi

# `nm -m` is Mach-O's spelling and names the section outright; ELF's nm answers
# with a type letter, where `R`/`r` is read-only data and `B`/`b`/`D`/`d`/`C` is
# not. Try the first and fall back to the second, the way
# ci-scripts/check-sanitizer-build.sh does for `nm -D`.
#
# Deciding by the output rather than by its exit status: GNU nm has no `-m` and
# errors, but llvm-nm takes it as `--format=darwin` and will print that format
# for an ELF file too, where the section names it reports are not the ones below.
# A real Mach-O listing names sections as `(__SEG,__sect)`, so that is the test.
nm_flavour=elf
symbols="$(nm -m "$exe" 2>/dev/null || true)"
if grep -q '(__[A-Za-z_]*,__' <<<"$symbols"; then
  nm_flavour=mach-o
else
  symbols="$(nm "$exe" 2>/dev/null || true)"
fi
if [ -z "$symbols" ]; then
  echo "$me: nm listed no symbols in $exe," \
       "so this check cannot say anything about it" >&2
  exit 1
fi

for cell in $cells; do
  # Mach-O prefixes C symbols with an underscore; match either spelling, and
  # anchor on the end of the line so mpif_status_ignore_ does not match
  # mpif_f08_status_ignore_.
  line="$(grep -E "[ _]${cell}\$" <<<"$symbols" | head -1 || true)"
  if [ -z "$line" ]; then
    echo "$me: $exe defines no symbol ${cell}." >&2
    echo "       Every sentinel cell should be in it: the executable is what" >&2
    echo "       the Fortran COMMON blocks are merged into." >&2
    status=1
    continue
  fi
  # `grep -c` exits nonzero when the count is zero, which `set -e` would take for
  # a failure of this script; zero is the answer being looked for.
  case "$nm_flavour" in
    mach-o) readonly_symbol=$(printf '%s\n' "$line" \
                | grep -c '__TEXT,__const\|__DATA_CONST,\|__DATA,__const' || true) ;;
    elf)    readonly_symbol=$(printf '%s\n' "$line" \
                | grep -cE '^[0-9a-fA-F]+ [Rr] ' || true) ;;
  esac
  if [ "$readonly_symbol" -eq 0 ]; then
    echo "$me: ${cell} is not read-only in $exe:" >&2
    echo "         $line" >&2
    echo "       src/mpif_constants.c's member was not pulled out of the" >&2
    echo "       archive, so the consumer's own COMMON became the definition." >&2
    echo "       Translation still works -- both sides see one symbol -- but the" >&2
    echo "       cell is now writable and zero rather than read-only and" >&2
    echo "       poisoned, so a missed translation corrupts silently instead of" >&2
    echo "       faulting. See \"Static linking\" in CODE.md." >&2
    status=1
  fi
done

# --- and so did the .TRUE./.FALSE. bit patterns ---------------------------
#
# src/mpif_logical.F90 is a BLOCK DATA whose only incoming reference is from
# src/mpif_logical.c. Unlike the cells, nothing outside mpif declares those two
# COMMON blocks, so a member that failed to come out of the archive is a link
# error rather than a silent substitution -- measured, by removing it and getting
# "Undefined symbols: _mpif_logical_true_, referenced from _mpif_bool2logical".
# That is the asymmetry: the sentinels can be quietly replaced because the
# consumer defines them too, and these cannot. Checked anyway, cheaply, since
# what makes it loud is a property of the current reference graph.
for symbol in mpif_logical_true_ mpif_logical_false_; do
  if ! grep -qE "[ _]${symbol}\$" <<<"$symbols"; then
    echo "$me: $exe defines no symbol ${symbol}," \
         "so src/mpif_logical.F90's BLOCK DATA did not reach the link" >&2
    status=1
  fi
done

# --- the wrappers are separable -------------------------------------------
#
# MPI-5.0 section 15.2.1 requires (2) that MPI functions a profiler has not
# replaced still link "without causing name clashes" and (4) that the wrappers of
# a layered Fortran binding be "separable from the rest of the library". Section
# 15.2.5 says what that means, and it is a statement about archive members: they
# have to be extractable "using a tool such as ar" and "without bringing along
# any other unnecessary code". A member holding two MPI entry points fails both
# at once -- a consumer replacing one of them collides with the member the link
# needs for the other. So: no member may define more than one.
#
# Two families of MPI-named symbols are deliberately not entry points and are
# excluded by name:
#
# - *_cdesc, gen/mpif_f08_cdesc.c's bind(C) targets. mpif invented those names;
#   they are not in the standard, so nothing replaces them and nothing else
#   defines them.
# - the predefined callbacks, MPI_COMM_DUP_FN and the rest. MPI-5.0 A.1.1 lists
#   all twelve among the *defined constants*, so in the ABI they are constants
#   rather than entry points; src/mpif_attr_fns.F90 keeps them together and
#   CODE.md records why they have no PMPI form either.
#
# The PMPI_ forms are not separated and do not need to be: a profiling library
# holds the MPI_ wrappers and calls PMPI_ into the base library.

members="$(mktemp -d)"
trap 'rm -rf "$members"' EXIT
# `ar x` extracts into the working directory and has no option to say where, so
# the archive has to be named absolutely across the `cd`.
archive_abs="$(cd "$(dirname "$archive")" && pwd)/$(basename "$archive")"
if ! (cd "$members" && ar x "$archive_abs"); then
  echo "$me: could not unpack $archive with ar" >&2
  exit 1
fi
# One nm over every member at once: `-A` then prints the file name on each line,
# which is what the grouping below keys on. `nm -A` on the *archive* would not
# do, its member field being spelled differently by ELF and Mach-O nm -- and the
# file-name field is spelled two ways as well, which is the trap here:
#
#     Mach-O:  foo.o: 00000000000002ec T _mpi_recv_
#     GNU:     foo.o:0000000000000008 T mpi_recv_
#
# GNU binutils glues the address straight onto the name. Strip an address before
# the colon as well as a bare colon, so the key is the member under either
# spelling. Getting this wrong does not fail: it makes every key unique, every
# group a group of one, and the whole check vacuous while it still reports the
# entry-point count -- which is what it did on every GNU-nm run until 2026-08-11.
# So a field that survives both strips and still does not look like a member is
# an error rather than a pass. The `.o$` test is exact and not a guess: the glob
# above is `*.o`, so every file nm was handed ends that way.
report="$(nm -g -A "$members"/*.o 2>/dev/null | awk '
  $(NF-1) != "U" && $(NF-1) != "C" && $NF ~ /^_?mpi_/ {
    sym = $NF; sub(/^_/, "", sym)
    if (sym ~ /_cdesc$/) next
    if (sym ~ /_fn(_null)?(_c)?_$/) next
    total++
    member = $1
    sub(/:[0-9a-fA-F]+$/, "", member)
    sub(/:$/, "", member)
    sub(/^.*\//, "", member)
    if (member !~ /\.o$/) { unparsed++; if (unparsed == 1) sample = $0 }
    n[member]++
    if (n[member] <= 4) e[member] = e[member] " " sym
  }
  END {
    printf "total %d\n", total + 0
    printf "unparsed %d %s\n", unparsed + 0, sample
    for (m in n) if (n[m] > 1) printf "crowded %s %d%s\n", m, n[m], e[m]
  }
')"
found="$(printf '%s\n' "$report" | sed -n 's/^total //p')"
unparsed="$(printf '%s\n' "$report" | sed -n 's/^unparsed //p')"
crowded="$(printf '%s\n' "$report" | sed -n 's/^crowded //p')"
if [ "$found" -eq 0 ]; then
  echo "$me: found no MPI entry points in $archive at all," \
       "so this check cannot say anything about them" >&2
  exit 1
fi
if [ "${unparsed%% *}" -ne 0 ]; then
  echo "$me: ${unparsed%% *} of nm's lines name no archive member in their" \
       "first field:" >&2
  echo "         ${unparsed#* }" >&2
  echo "       This check groups symbols by that field. Unread, every symbol" >&2
  echo "       lands in a group of its own and no member could ever be" >&2
  echo "       reported as crowded, so the check would pass without checking." >&2
  echo "       Teach the awk above whatever spelling this nm uses." >&2
  status=1
fi
if [ -n "$crowded" ]; then
  echo "$me: these archive members define more than one MPI entry point:" >&2
  printf '%s\n' "$crowded" | sed 's/^/         /' >&2
  echo "       A consumer replacing one of them -- which is what a profiling" >&2
  echo "       layer does, and what test/profile_f90.f90 and" >&2
  echo "       test/profile_f08.f90 do -- gets a duplicate symbol, because the" >&2
  echo "       link needs that member for the others. MPI-5.0 section 15.2.1(2)" >&2
  echo "       and (4) forbid it. Was the library configured with" >&2
  echo "       -DMPIF_SPLIT_WRAPPERS=OFF?" >&2
  status=1
fi

if [ "$status" -eq 0 ]; then
  count=$(printf '%s\n' "$cells" | wc -l | tr -d ' ')
  echo "$me: $exe links $archive statically," \
       "with $count read-only sentinel cells and libmpi_abi still dynamic;" \
       "$found separable MPI entry points"
fi
exit "$status"
