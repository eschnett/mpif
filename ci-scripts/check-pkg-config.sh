#!/usr/bin/env bash

# Check that an installed mpif's pkg-config file describes an mpif that can
# actually be compiled, linked and run against.
#
# Usage: ci-scripts/check-pkg-config.sh <mpif-prefix> [<mpi-prefix>]
#
# pkg-config is the third way to consume an installed mpif, beside
# find_package(mpif) -- which test-consume/ and check-package-config.sh cover --
# and bin/mpifort, which test/ uses for everything it builds. Nothing else here
# goes near lib/pkgconfig/mpif.pc, and it can be wrong in ways the other two
# routes cannot: cmake/mpif.pc.in and bin/mpifort.in publish one flag inventory
# through two mechanisms, and while every *value* either bakes in comes from the
# same CMake variable, the shape of the two link lines is written out twice.
#
# Nine legs, against the installed prefix:
#
#   0. the file is there            -- and this one gates even when no
#                                      pkg-config is installed to read it
#   1. which pkg-config answered    -- freedesktop pkg-config and pkgconf are
#                                      different programs; the log says which
#   2. --exists, --modversion       -- matches what bin/mpifort reports, so a
#                                      version that reached one file and not the
#                                      other is caught
#   3. --cflags                     -- names a directory that holds mpif.h and
#                                      mpi_f08.mod, and carries no Fortran-only
#                                      flag, which pkg-config has no per-language
#                                      field to keep off a C compile line
#   4. --libs inventory             -- both -l, both -L, both rpaths, the
#                                      platform link flag
#   5. compile, link and run        -- plain $FC and these flags alone, with
#                                      LD_LIBRARY_PATH and DYLD_LIBRARY_PATH
#                                      cleared, so the rpath is what finds the
#                                      libraries
#   6. the rpath is a runpath       -- on ELF, DT_RUNPATH and not DT_RPATH:
#                                      only RUNPATH yields to LD_LIBRARY_PATH
#   7. agreement with the wrapper   -- the same tokens bin/mpifort reports
#   8. --define-variable=mpi_prefix -- redirects both the -L and the rpath, the
#                                      pkg-config spelling of MPIF_MPI_PREFIX
#
# Leg 5 is the one that makes the rest worth having. `pkg-config --libs` is
# worthless if the executable it produces cannot start, and this is the only
# check in the tree that builds something from published flags with no CMake and
# no wrapper in the way and then runs it with the loader's search path emptied.
# It is also the only leg that can see a *reordering* -- the sanitizer runtime
# moving behind -lmpif, which ASan refuses to run with -- because leg 7 compares
# sets.
#
# Legs 1-8 need a pkg-config to ask. When there is none on PATH they are skipped
# with a reason printed, the way check-package-config.sh skips its legs that
# need an <mpi-prefix>: pkg-config is not a dependency of mpif, and a run that
# cannot ask should say so rather than pass silently or fail on the tool's
# absence. Leg 0 needs nothing and always runs.

set -eu

mpif_prefix="${1:-}"
mpi_prefix="${2:-}"
if [ -z "$mpif_prefix" ]; then
  echo "usage: $(basename "$0") <mpif-prefix> [<mpi-prefix>]" >&2
  exit 1
fi

repodir="$(cd "$(dirname "$0")/.." && pwd -P)"

# Absolute, because leg 5 compiles in a temporary directory: a relative prefix
# there resolves against *that* directory and every leg would then be judging
# something else. Same reason as check-package-config.sh.
absolute() {
  if [ ! -d "$1" ]; then
    echo "$(basename "$0"): no such directory: $1" >&2
    exit 1
  fi
  (cd "$1" && pwd -P)
}
mpif_prefix="$(absolute "$mpif_prefix")"
if [ -n "$mpi_prefix" ]; then
  mpi_prefix="$(absolute "$mpi_prefix")"
fi

status=0

fail() {
  echo "$(basename "$0"): $1" >&2
  shift
  for line in "$@"; do
    echo "       $line" >&2
  done
  status=1
}

# Leg 0: find the file. Not a fixed lib/pkgconfig: GNUInstallDirs answers lib64
# on some distributions and a multiarch path on others, CMakeLists.txt derives
# MPIF_INSTALL_PKGCONFIGDIR from whichever it got, and pkg-config looks in all
# of them. This says which file the run actually judged.
pc=""
for candidate in "$mpif_prefix"/lib*/pkgconfig/mpif.pc \
                 "$mpif_prefix"/lib*/*/pkgconfig/mpif.pc \
                 "$mpif_prefix"/share/pkgconfig/mpif.pc; do
  if [ -f "$candidate" ]; then
    pc="$candidate"
    break
  fi
done
if [ -z "$pc" ]; then
  fail "no mpif.pc under $mpif_prefix." \
       "CMakeLists.txt installs one into MPIF_INSTALL_PKGCONFIGDIR" \
       "(\${CMAKE_INSTALL_LIBDIR}/pkgconfig); a consumer asking pkg-config for" \
       "mpif finds nothing at all."
  exit "$status"
fi
echo "$(basename "$0"): checking $pc"

# Leg 1: which pkg-config. PKG_CONFIG from the environment is autoconf's
# convention for naming another one.
PKG_CONFIG="${PKG_CONFIG:-pkg-config}"
have_pkg_config=yes
if ! command -v "$PKG_CONFIG" >/dev/null 2>&1; then
  have_pkg_config=no
  echo "  no $PKG_CONFIG on PATH, so the query legs are not exercised here"
else
  # `--about` is pkgconf's; freedesktop pkg-config rejects it. The two are
  # different programs with different fragment handling, and this is the line
  # that lets a divergent result name the one that produced it.
  if "$PKG_CONFIG" --about >/dev/null 2>&1; then
    flavour=pkgconf
  else
    flavour="freedesktop pkg-config"
  fi
  echo "  $flavour $("$PKG_CONFIG" --version 2>/dev/null) at $(command -v "$PKG_CONFIG")"
fi

if [ "$have_pkg_config" = no ]; then
  if [ "$status" -eq 0 ]; then
    echo "$(basename "$0"): mpif.pc is installed; its contents were not read"
  fi
  exit "$status"
fi

work="$(mktemp -d "${TMPDIR:-/tmp}/mpif-pkg-config.XXXXXX")"
trap 'rm -rf "$work"' EXIT

pcdir="$(dirname "$pc")"

# Every query goes through this, and each variable it sets or clears is load
# bearing -- the analogue of check-package-config.sh's empty CMAKE_FIND_ROOT_PATH.
#
# PKG_CONFIG_LIBDIR *replaces* the built-in search directories, but
# PKG_CONFIG_PATH is searched *before* it (measured on 0.29.2), so clearing the
# latter is what keeps another mpif.pc elsewhere on the machine from being what
# this run judged. PKG_CONFIG_SYSROOT_DIR silently prefixes every -I and -L.
# PKG_CONFIG_TOP_BUILD_DIR substitutes into ${pc_top_builddir}.
#
# The two ALLOW_SYSTEM_* variables are for a prefix that happens to be /usr or
# /usr/local: without them pkg-config drops -L/usr/lib and -I/usr/include from
# its answer, which is right for the caller and wrong for legs 4 and 7, which
# would then judge a line with pieces missing for a reason that is not a defect.
pc_query() {
  env -u PKG_CONFIG_PATH -u PKG_CONFIG_SYSROOT_DIR -u PKG_CONFIG_TOP_BUILD_DIR \
      PKG_CONFIG_LIBDIR="$pcdir" \
      PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 \
      "$PKG_CONFIG" "$@"
}

# Leg 2: identity. The version comes from bin/mpifort rather than from
# CMakeLists.txt, so this compares two installed artifacts against each other
# instead of either against the source it was generated from.
wrapper="$mpif_prefix/bin/mpifort"
if ! pc_query --exists mpif; then
  # Nothing below can mean anything if the file does not parse, so this one
  # stops rather than accumulating.
  fail "pkg-config cannot read $pc:" \
       "$(pc_query --print-errors --exists mpif 2>&1 || true)"
  exit "$status"
fi
if [ ! -x "$wrapper" ]; then
  echo "  no $wrapper, so the version and wrapper-agreement legs are skipped"
else
  pc_version="$(pc_query --modversion mpif)"
  wrapper_version="$("$wrapper" -showme:version | sed -n '1s/^mpif //p')"
  if [ "$pc_version" != "$wrapper_version" ]; then
    fail "mpif.pc says Version $pc_version and bin/mpifort says" \
         "$wrapper_version. Both are @PROJECT_VERSION@; one of the two" \
         "templates was not regenerated."
  else
    echo "  --modversion: $pc_version, the same as bin/mpifort reports"
  fi
fi

# Leg 3: the include directory, and nothing else in Cflags. A wrong directory
# would also fail leg 5, but this says which of the two is wrong.
#
# The second half is the one leg 7 cannot do: a Fortran-only flag that moved from
# the fortran_flags variable into Cflags leaves the per-phase token sets
# unchanged, so only an explicit assertion catches it. It is worth an assertion
# because pkg-config has one compile-flag field for every language and the
# regression is a known one -- clang errors on -fallow-argument-mismatch, which
# is how it broke the FreeBSD leg through FindMPI's unguarded interface compile
# options. See test/CMakeLists.txt and cmake/mpif.pc.in's header.
pc_cflags="$(pc_query --cflags mpif)"
pc_incdir="${pc_cflags#*-I}"
pc_incdir="${pc_incdir%% *}"
if [ -z "$pc_incdir" ] || [ "$pc_cflags" = "$pc_incdir" ]; then
  fail "--cflags is \"$pc_cflags\", which names no include directory."
elif [ ! -f "$pc_incdir/mpif.h" ] || [ ! -f "$pc_incdir/mpi_f08.mod" ]; then
  fail "--cflags points at $pc_incdir, which does not hold both mpif.h and" \
       "mpi_f08.mod. A consumer's first 'use mpi_f08' or mpif.h include fails" \
       "there."
else
  # pc_fflags is read here as well as in leg 5; the variable is set before both.
  leaked=""
  for token in $(pc_query --variable=fortran_flags mpif); do
    case " $pc_cflags " in
      *" $token "*) leaked="$leaked $token" ;;
    esac
  done
  if [ -n "$leaked" ]; then
    fail "--cflags carries$leaked, which mpif.pc keeps in its fortran_flags" \
         "variable on purpose. pkg-config has one compile-flag field for every" \
         "language, and a consumer that wraps this file in an imported target" \
         "-- pkg_check_modules(IMPORTED_TARGET), Meson's dependency() -- hands" \
         "it to its C compiler too, where clang errors on it."
  else
    echo "  --cflags: $pc_incdir alone, holding mpif.h and mpi_f08.mod"
  fi
fi

# Leg 4: what --libs must name. The platform flag is asked for by name rather
# than taken on trust because it is the one piece that differs by system: on
# Darwin -Wl,-commons,use_dylibs keeps a single instance of mpif's COMMON
# blocks, and on ELF -Wl,--enable-new-dtags is what makes the rpaths below
# RUNPATH rather than RPATH.
pc_libs="$(pc_query --libs mpif)"
pc_mpi_libdir="$(pc_query --variable=mpi_libdir mpif)"
pc_libdir="$(pc_query --variable=libdir mpif)"
if [ "$(uname -s)" = Darwin ]; then
  platform_flag="-Wl,-commons,use_dylibs"
else
  platform_flag="-Wl,--enable-new-dtags"
fi
missing=""
for want in -lmpif -lmpi_abi \
            "-L$pc_libdir" "-Wl,-rpath,$pc_libdir" \
            "-L$pc_mpi_libdir" "-Wl,-rpath,$pc_mpi_libdir" \
            "$platform_flag"; do
  case " $pc_libs " in
    *" $want "*) ;;
    *) missing="$missing $want" ;;
  esac
done
if [ -n "$missing" ]; then
  fail "--libs is missing$missing." \
       "It said: $pc_libs" \
       "A fragment that pkg-config dropped or rewrote is as likely a cause as" \
       "one cmake/mpif.pc.in never wrote; the flavour is named above."
else
  echo "  --libs: both libraries, both -L, both rpaths, $platform_flag"
fi

# Leg 5: compile, link and run, with nothing but these flags.
#
# The compiler comes out of the .pc file. That is what fortran_compiler is for
# -- the installed .mod files are in one compiler's private format, so a check
# that used any other compiler would be testing nothing -- and reading it here
# is what keeps the three recorded compiler variables from being decoration.
# $FC covers an installation whose recorded compiler has since moved.
fc="$(pc_query --variable=fortran_compiler mpif)"
if [ -z "$fc" ] || ! command -v "$fc" >/dev/null 2>&1; then
  fc="${FC:-}"
fi
pc_fflags="$(pc_query --variable=fortran_flags mpif)"
if [ -z "$fc" ] || ! command -v "$fc" >/dev/null 2>&1; then
  echo "  neither mpif.pc's fortran_compiler nor \$FC names a compiler that is" \
       "here, so nothing is compiled"
else
  # In $work, never the repository: this produces an object file and an
  # executable.
  #
  # Unquoted on purpose -- these are flag lists, and word-splitting them is the
  # point. Same idiom as check-package-config.sh's cmake arguments.
  compiled=yes
  # shellcheck disable=SC2086
  if ! "$fc" $pc_cflags $pc_fflags \
       -c "$repodir/test-consume/consume_f08.f90" -o "$work/consume.o" \
       >"$work/compile.log" 2>&1; then
    compiled=no
    fail "compiling test-consume/consume_f08.f90 with pkg-config's flags" \
         "failed. \`$fc \$(pkg-config --cflags mpif)" \
         "\$(pkg-config --variable=fortran_flags mpif) -c\` is the whole" \
         "compile line a pkg-config consumer has. See $work/compile.log:" \
         "$(tail -n 5 "$work/compile.log" 2>/dev/null)"
  # shellcheck disable=SC2086
  elif ! "$fc" $pc_fflags "$work/consume.o" -o "$work/consume" $pc_libs \
       >"$work/link.log" 2>&1; then
    compiled=no
    fail "linking with pkg-config's --libs failed. See $work/link.log:" \
         "$(tail -n 5 "$work/link.log" 2>/dev/null)"
  fi

  if [ "$compiled" = yes ]; then
    # The loader's search path is cleared, which is what makes this an assertion
    # about the rpaths in --libs and not about the environment the check
    # happened to run in. It matters concretely: CI's static job sets
    # LD_LIBRARY_PATH to the MPI's lib for the whole job, so without this the
    # run would pass with no rpath baked in at all.
    #
    # detect_leaks=0 for the reason scripts/macos-common.sh sets it: under a
    # sanitizer build the leaks reported are the uninstrumented MPI's.
    if env -u LD_LIBRARY_PATH -u DYLD_LIBRARY_PATH \
           ASAN_OPTIONS="${ASAN_OPTIONS:-detect_leaks=0}" \
           "$work/consume" >"$work/run.log" 2>&1; then
      echo "  compiled, linked and ran with the loader's search path cleared"
    else
      fail "the executable built from pkg-config's flags alone did not run" \
           "with LD_LIBRARY_PATH and DYLD_LIBRARY_PATH cleared. Either the" \
           "rpaths in --libs do not reach libmpif and libmpi_abi, or -- on ELF," \
           "under a sanitizer -- the runtime is behind -lmpif, which leg 7" \
           "cannot see. See $work/run.log:" \
           "$(tail -n 5 "$work/run.log" 2>/dev/null)"
    fi

    # Leg 6: and the rpath is the kind that yields. On ELF, LD_LIBRARY_PATH
    # precedes DT_RUNPATH but is shadowed by DT_RPATH, so an executable built
    # with the wrong one links, runs, and then cannot be pointed at another MPI
    # -- which is the whole arrangement in CODE.md "Choosing the MPI at run
    # time". Mach-O has one kind of LC_RPATH and nothing to distinguish.
    if command -v otool >/dev/null 2>&1; then
      if otool -l "$work/consume" | grep -qF "path $pc_libdir "; then
        echo "  LC_RPATH names $pc_libdir"
      else
        fail "the executable has no LC_RPATH for $pc_libdir, so it found" \
             "libmpif some other way and this run proves nothing about the" \
             "rpaths in --libs."
      fi
    elif command -v readelf >/dev/null 2>&1; then
      dynamic="$(readelf -d "$work/consume" 2>/dev/null || true)"
      if printf '%s\n' "$dynamic" | grep -qF "(RPATH)"; then
        fail "the executable carries DT_RPATH, not DT_RUNPATH." \
             "LD_LIBRARY_PATH cannot override DT_RPATH, so this binary is" \
             "pinned to the MPI it was linked against;" \
             "-Wl,--enable-new-dtags in mpif.pc's Libs is what prevents it."
      elif printf '%s\n' "$dynamic" | grep -F "(RUNPATH)" | grep -qF "$pc_libdir"; then
        echo "  DT_RUNPATH names $pc_libdir, so LD_LIBRARY_PATH still wins"
      else
        fail "the executable has no DT_RUNPATH naming $pc_libdir, so it found" \
             "libmpif some other way and this run proves nothing about the" \
             "rpaths in --libs."
      fi
    else
      echo "  neither otool nor readelf is here, so the rpath is not inspected"
    fi
  fi
fi

# Leg 7: the same inventory the wrapper reports.
#
# Compared as sorted, deduplicated token *sets*, not sequences, and that is not
# laziness. Measured on pkg-config 0.29.2: every -L is hoisted to the front of
# --libs, and a duplicate -L is collapsed while a duplicate -Wl,-rpath is not --
# while bin/mpifort's -showme:link names mpif's -L and rpath twice, once outside
# MPIF_FCLIBS and once in. A sequence comparison would therefore fail on a
# correct pair. What this leg is for is a token on one side and not the other,
# which is what drift between the two templates looks like; a reordering is
# leg 5's business.
#
# The wrapper is asked with its own environment overrides cleared, or the two
# sides can disagree for a reason that is not drift.
tokens() {  # flags on stdin, one sorted unique token per line
  tr ' \t' '\n\n' | sed '/^$/d' | sort -u
}
if [ ! -x "$wrapper" ]; then
  : # already reported above
else
  wrapper_env() {
    env -u MPIF_FC -u MPIF_FCFLAGS -u MPIF_FCLIBS \
        -u MPIF_MPI_PREFIX -u MPIF_MPI_LIBDIR "$wrapper" "$@"
  }
  for phase in compile link; do
    case "$phase" in
      compile) printf '%s %s\n' "$pc_cflags" "$pc_fflags" >"$work/pc-$phase" ;;
      link)    printf '%s %s\n' "$pc_libs" "$pc_fflags" >"$work/pc-$phase" ;;
    esac
    tokens <"$work/pc-$phase" >"$work/pc-$phase.tokens"
    wrapper_env "-showme:$phase" | tokens >"$work/wrapper-$phase.tokens"
    if diff -u "$work/wrapper-$phase.tokens" "$work/pc-$phase.tokens" \
         >"$work/$phase.diff" 2>&1; then
      echo "  $phase flags: the same tokens as bin/mpifort -showme:$phase"
    else
      fail "mpif.pc and bin/mpifort disagree about the $phase flags." \
           "cmake/mpif.pc.in and bin/mpifort.in publish one inventory twice;" \
           "-showme:$phase is on the left, pkg-config on the right:" \
           "$(sed -n '3,20p' "$work/$phase.diff")"
    fi
  done
fi

# Leg 8: the MPI in the .pc is a default, not a fact. This is the pkg-config
# counterpart of the wrapper's MPIF_MPI_PREFIX, which the suite's cross-runs
# already exercise by relinking through it.
pc_mpi_prefix="$(pc_query --variable=mpi_prefix mpif)"
case "$pc_mpi_libdir" in
  "$pc_mpi_prefix"/*)
    redirected="$(pc_query --define-variable=mpi_prefix=/nonexistent-mpi \
                           --libs mpif)"
    if [ "$redirected" = "$pc_libs" ]; then
      fail "--define-variable=mpi_prefix=/nonexistent-mpi changed nothing." \
           "mpi_libdir is \"$pc_mpi_libdir\" and should be written relative to" \
           "\${mpi_prefix} -- see MPIF_PC_MPI_LIBDIR in CMakeLists.txt -- so" \
           "that a consumer can link another MPI without a new mpif."
    else
      # Asked for separately rather than as one pattern, because pkg-config
      # hoists every -L to the front and the two need not stay adjacent.
      redirect_missing=""
      for want in "-L/nonexistent-mpi/" "-Wl,-rpath,/nonexistent-mpi/"; do
        case " $redirected " in
          *" $want"*) ;;
          *) redirect_missing="$redirect_missing $want" ;;
        esac
      done
      if [ -n "$redirect_missing" ]; then
        fail "--define-variable=mpi_prefix=/nonexistent-mpi left$redirect_missing" \
             "out of --libs, so a consumer cannot point this mpif at another" \
             "MPI. It said: $redirected"
      else
        echo "  --define-variable=mpi_prefix: redirects both the -L and the rpath"
      fi
    fi
    ;;
  *)
    # An MPI whose libdir is not under its prefix gets an absolute mpi_libdir
    # from CMakeLists.txt and loses this, exactly as the wrapper does; a
    # consumer redirects mpi_libdir itself. Nothing installed here is such an
    # MPI -- same gap as MISSING.md "No test exercises an MPI whose libdir is
    # not `lib`".
    echo "  mpi_libdir \"$pc_mpi_libdir\" is not under mpi_prefix" \
         "\"$pc_mpi_prefix\", so the redirect is not exercised here"
    ;;
esac

# The second argument is not used by any leg above: what a pkg-config consumer
# links is the MPI recorded in the file, and leg 8 redirects it to a path that
# deliberately does not exist. It is accepted so that this script and
# check-package-config.sh take the same two arguments at both call sites, and
# checked so that a caller passing a wrong path hears about it here.
if [ -n "$mpi_prefix" ] && [ "$mpi_prefix" != "$pc_mpi_prefix" ]; then
  echo "  note: mpif.pc records mpi_prefix $pc_mpi_prefix, not the" \
       "$mpi_prefix given on the command line"
fi

if [ "$status" -eq 0 ]; then
  echo "$(basename "$0"): the pkg-config file keeps its contract"
fi
exit "$status"
