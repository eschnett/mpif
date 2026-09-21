#!/usr/bin/env bash

# Run mpiexec, dropping launcher banners that would otherwise look like test
# output.
#
# The MPICH test suite compares each program's combined output against what the
# test is expected to print, so anything the launcher says of its own accord is
# reported as "Unexpected output". Open MPI 5 says this on every single run:
#
#     ----------------------------------------------------------------
#     A deprecated MCA variable value was specified in the environment or
#     on the command line.  Deprecated MCA variables should be avoided;
#     they may disappear in future releases.
#
#     Deprecated variable: schizo_proxy
#     New variable:        personality
#     ----------------------------------------------------------------
#
# and it is not the user's doing: ompi/tools/mpirun/main.c does
# `setenv("PRTE_MCA_schizo_proxy", "ompi", 1)` while the PRRTE bundled with it
# has renamed that variable to `personality`. Because the tool sets the variable
# itself, and overwrites whatever was there, no environment setting can prevent
# it, and the warning in mca_base_var.c is unconditional -- the
# `suppress_override_warning` knob covers only override warnings.
#
# So filter it out here instead. Only blocks that say "deprecated MCA variable"
# are dropped: genuine Open MPI errors use the same dashed delimiters and must
# still reach the test suite.
#
# One single line is dropped as well, by exact text:
#
#     [warn] event_active: event has no event_base set.
#
# libevent prints it through PRRTE while a spawn test tears down, after the
# program has printed its "No Errors" -- so the test passed and `runtests`
# failed it for the trailing line. Seen on aarch64 Linux with the Open MPI the
# installer pins, on `spawnmult2f90`, and intermittently: one run had it under
# f90 alone, another under f90 and f08. That is why it is filtered rather than
# listed in mpich-suite-xfail.txt -- an expectation that only sometimes holds
# would fail as "unexpectedly passes" the moment the warning did not fire.
# Matched in full, so a libevent warning about anything else still gets through.

set -uo pipefail

if [[ -z ${MPIF_REAL_MPIEXEC:-} ]]; then
    echo "$0: MPIF_REAL_MPIEXEC is not set" >&2
    exit 1
fi

# `runtests` merges stderr into stdout anyway, so merge here too and filter the
# lot. PIPESTATUS, with pipefail off for the filter, keeps mpiexec's exit status.
"${MPIF_REAL_MPIEXEC}" "$@" 2>&1 | awk '
    # Buffer a dashed block, then decide whether to print it. Ten dashes are
    # matched literally rather than with an interval expression, which not every
    # awk supports.
    function dashes(line) { return substr(line, 1, 10) == "----------" }
    !inblock && dashes($0) { inblock = 1; buf = $0 "\n"; next }
    inblock {
        buf = buf $0 "\n"
        if (dashes($0)) {
            if (buf !~ /deprecated MCA variable/) printf "%s", buf
            inblock = 0
            buf = ""
        }
        next
    }
    /^\[warn\] event_active: event has no event_base set\.$/ { next }
    { print }
    # An unterminated block is not ours to judge, so pass it through
    END { if (inblock) printf "%s", buf }
'
exit "${PIPESTATUS[0]}"
