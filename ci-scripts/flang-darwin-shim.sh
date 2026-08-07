#!/usr/bin/env bash

# Run flang on macOS, rewriting the Darwin linker options that flang does not
# accept but that libtool passes to the Fortran compiler when linking a shared
# library: `-dynamiclib`, `-install_name`, `-compatibility_version` and friends.
# flang wants `-shared`, and everything meant for the linker has to go through
# `-Wl,`.
#
# This exists because libtool assumes a Darwin Fortran compiler is either GNU or
# one of `ifort`/`nagfor`, and drives anything else with clang's options. Doing
# the translation here, on the actual argument list, rather than by patching
# libtool's command templates, keeps it independent of how a given libtool
# version happens to spell those templates.
#
# The name has to start with `flang` so that libtool's `cc_basename` tests still
# recognise the compiler (see ci-scripts/install-mpich.sh, which adds `flang*` to
# libtool's list of Darwin Fortran compilers that can build shared libraries).
#
# Usage: set FC to this script and FLANG_DARWIN_SHIM_FC to the real flang.

set -uo pipefail

real_fc=${FLANG_DARWIN_SHIM_FC:?FLANG_DARWIN_SHIM_FC must name the real flang}

args=()
while [[ $# -gt 0 ]]; do
    case $1 in
        # Wrong spelling of "build a shared library"
        -dynamiclib)
            args+=(-shared)
            ;;
        # Linker options that take a separate value
        -install_name | -compatibility_version | -current_version | \
        -dylib_file | -exported_symbols_list | -umbrella | -allowable_client | \
        -client_name | -bundle_loader | -multiply_defined | -seg1addr | \
        -segprot | -sectcreate | -undefined)
            if [[ $# -lt 2 ]]; then
                echo "$(basename "$0"): $1 needs a value" >&2
                exit 1
            fi
            args+=("-Wl,$1" "-Wl,$2")
            shift
            ;;
        # Linker options that stand alone
        -bundle | -single_module | -multi_module | -flat_namespace | \
        -twolevel_namespace | -no_fixup_chains | -headerpad_max_install_names | \
        -force_flat_namespace | -prebind | -keep_private_externs)
            args+=("-Wl,$1")
            ;;
        *)
            args+=("$1")
            ;;
    esac
    shift
done

# `${args[@]+...}` because macOS still ships bash 3.2, where expanding an empty
# array under `set -u` is an error
exec "${real_fc}" ${args[@]+"${args[@]}"}
