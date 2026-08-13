#!/usr/bin/env bash

# Check that an mpif installation built with -DMPIF_SANITIZE is really
# instrumented.
#
# Usage: ci-scripts/check-sanitizer-build.sh <mpif-prefix>
#
# The failure this exists for is silent. A sanitizer build whose flags never
# reached the compiler produces a library that works perfectly, passes all 69
# tests, and reports nothing -- exactly what a *correct* sanitizer build does
# on clean code, so no test can tell the two apart. The difference is visible
# only in the object code: instrumented translation units call into the
# runtime, so they carry undefined `__asan_*` (or `__ubsan_*`, ...) references,
# and an uninstrumented one carries none.
#
# The other half -- that the runtime is actually reachable at load time -- needs
# no check here, because it is not silent: a missing runtime makes every
# executable linked against the library die in the loader, which the test suite
# reports as 69 failures.
#
# This was measured rather than assumed. Building mpif with MPIF_SANITIZE=address
# and a deliberate one-byte heap overflow put back into
# `mpif_strdup_f2c_trim` failed `info_get_string_f08` with the file and line;
# the same overflow in the ordinary build passed all 69 tests. See CODE.md
# "Sanitizer builds".

set -eu

prefix="${1:-}"
if [ -z "$prefix" ]; then
  echo "usage: $(basename "$0") <mpif-prefix>" >&2
  exit 1
fi

# The versioned real file rather than the `.so`/`.dylib` symlink, so that this
# says which file it looked at when it fails.
lib=""
for candidate in \
    "$prefix"/lib/libmpif.so \
    "$prefix"/lib/libmpif.*.dylib \
    "$prefix"/lib/libmpif.so.*; do
  if [ -e "$candidate" ]; then
    lib="$candidate"
    break
  fi
done
if [ -z "$lib" ]; then
  echo "$(basename "$0"): no libmpif under $prefix/lib" >&2
  exit 1
fi

# `nm -D` reads the dynamic symbol table, which is the one that survives a
# strip; it is a GNU/ELF spelling that macOS's nm rejects, where plain `nm -u`
# is what answers. Try each, and use whichever produced output.
symbols="$(nm -D -u "$lib" 2>/dev/null || true)"
if [ -z "$symbols" ]; then
  symbols="$(nm -u "$lib" 2>/dev/null || true)"
fi
if [ -z "$symbols" ]; then
  echo "$(basename "$0"): nm listed no undefined symbols in $lib," \
       "so this check cannot say anything about it" >&2
  exit 1
fi

# Mach-O prefixes C symbols with an underscore, so the runtime's entry points
# are `___asan_*` there and `__asan_*` on ELF; matching from the second
# underscore covers both.
if printf '%s\n' "$symbols" | grep -Eq '_(asan|ubsan|tsan|lsan|hwasan|sanitizer)_'; then
  echo "$(basename "$0"): $lib is instrumented"
  exit 0
fi

echo "$(basename "$0"): $lib references no sanitizer runtime." >&2
echo "       It was installed from a build that was asked for a sanitizer but" >&2
echo "       did not get one, and it will report nothing however it is run." >&2
exit 1
