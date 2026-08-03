#!/usr/bin/env python3

"""Check the generated mpi_f08 declarations against MPI-5.0 Appendix A.4.

The generator derives every f08 INTENT from the parameter's `param_direction`
in `data/apis.json`, and the standard's own bindings do not always agree. Where
they disagree the standard has usually omitted an intent deliberately, in a
place where the direction of the data does not tell the whole story, and a
generator that reads only the direction cannot know. Two such divergences were
real defects: INTENT(OUT) on a status destroyed the caller's `status%MPI_ERROR`
before the call, and INTENT(IN) on a callback's `extra_state` stopped a
conforming callback from compiling at all.

The declared *type* is checked the same way and for the same reason. Intents
alone missed `MPI_Buffer_detach`'s `buffer_addr`, which is INTENT(OUT) on both
sides and TYPE(C_PTR) in the standard against INTEGER(KIND=MPI_ADDRESS_KIND)
here -- a caller cannot pass what the standard says to pass. Comparing types
costs nothing extra, both declarations having been parsed already.

So compare the two, routine by routine, rather than waiting for the third one.
Appendix A.4 lists the bindings and `pdftotext -layout` makes them greppable;
what comes out is regular enough to parse, and the parse checks itself -- every
routine's argument list has to be exactly covered by its declarations, and this
exits nonzero if any is not.

Usage:  python3 dev/check-f08-bindings.py [doc/mpi50-report.pdf]

Keep a copy of the standard at doc/mpi50-report.pdf; it is git-ignored.

Exits 0 when the only divergences left are the expected ones, which are named
in EXPECTED below and printed as a reminder rather than an error.
"""

import json
import os
import re
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PDF = sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "doc", "mpi50-report.pdf")
GEN = os.path.join(REPO, "gen", "mpif_f08_functions.F90")

# Divergences that are known, deliberate and recorded in MISSING.md. Anything
# else is a finding.
EXPECTED = """\
Choice buffers. The standard declares an input buffer
`TYPE(*), DIMENSION(..), INTENT(IN)`; mpif declares every choice buffer
`integer :: buf(*)` under `ignore_tkr`/`no_arg_check` and gives it no intent,
which is the `MPI_SUBARRAYS_SUPPORTED == .FALSE.` option the standard offers.
Omitting the intent is what lets the wrapper hand the buffer on to a dummy that
has none; it forbids nothing a conforming program may do. See "Assumed-rank
choice buffers" in MISSING.md."""


def text_of_appendix(pdf):
    """The lines of Appendix A.4, with margin line numbers and running heads gone."""
    out = subprocess.run(
        ["pdftotext", "-layout", pdf, "-"], check=True, capture_output=True, text=True
    ).stdout.split("\n")

    stripped = []
    for ln in out:
        ln = re.sub(r"\s{2,}\d+\s*$", "", ln)  # margin numbers, right-hand pages
        ln = re.sub(r"^\s*\d+\s{2,}", "", ln)  # margin numbers, left-hand pages
        stripped.append(ln.strip())

    # The heading and the running head above it read the same once the page
    # number is off; either will do as the start. The table of contents does
    # not, its dot leaders surviving the strip.
    start = end = None
    for n, s in enumerate(stripped):
        if start is None:
            if s == "A.4 Fortran 2008 Bindings with the mpi_f08 Module":
                start = n
        elif s.startswith("A.5 Fortran Bindings with mpif.h or the mpi Module"):
            end = n
            break
    if start is None or end is None:
        sys.exit(f"{pdf}: could not find Appendix A.4")

    clean = []
    for s in stripped[start + 1 : end]:
        if not s or re.fullmatch(r"\d+", s):
            continue
        if "Appendix A Language Bindings Summary" in s:
            continue
        if re.match(r"^A\.4(\.\d+)? [A-Z(]", s):
            continue
        if s == "A.4 Fortran 2008 Bindings with the mpi_f08 Module":
            continue
        clean.append(s)
    return clean


DECL = re.compile(
    r"^(TYPE\s*\(|INTEGER|LOGICAL|CHARACTER|REAL|DOUBLE|COMPLEX|PROCEDURE|EXTERNAL|"
    r"USE\b|ABSTRACT|IMPLICIT|CLASS)",
    re.I,
)
# A binding, optionally preceded by its result type: "DOUBLE PRECISION MPI_Wtime()".
SIG = re.compile(r"^(?:[A-Z][A-Z_() =]*[A-Z)] +)?(MPI_[A-Za-z0-9_]*)\s*\(")


def split_names(rhs):
    """The declared names on the right of a `::`, ignoring commas inside ()."""
    depth, buf, names = 0, "", []
    for ch in rhs:
        if ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
        if ch == "," and depth == 0:
            names.append(buf)
            buf = ""
        else:
            buf += ch
    names.append(buf)
    return [m.group(0).lower() for m in (re.match(r"[A-Za-z_]\w*", n.strip()) for n in names) if m]


def attributes(lhs):
    m = re.search(r"INTENT\s*\(\s*(IN\s*OUT|INOUT|IN|OUT)\s*\)", lhs, re.I)
    return {
        "intent": m.group(1).upper().replace(" ", "").replace("INOUT", "INOUT") if m else None,
        "type": lhs.strip(),
        "base": base_type(lhs),
    }


def base_type(lhs):
    """The declaration with the attributes and the spelling differences taken out.

    The two sides say the same thing in different words -- `INTEGER(KIND=
    MPI_COUNT_KIND)` against `integer(MPI_COUNT_KIND)`, `CHARACTER(LEN=*)`
    against `character*(*)` -- so a textual comparison has to be given the
    vocabulary first. What is left is the type and its kind, which is what a
    caller has to match.
    """
    t = lhs.lower()
    # attributes are not part of the type; intent is compared separately
    for attr in ("intent", "optional", "asynchronous", "value", "pointer",
                 "allocatable", "target", "external", "dimension"):
        t = re.sub(rf",\s*{attr}\s*(\([^)]*\))?", "", t)
    t = re.sub(r"^\s*(use|import)\b.*", "", t)
    t = t.replace("kind=", "").replace("len=", "")
    # `character*(*)` and `character(*)` are the same declaration
    t = re.sub(r"character\s*\*\s*\(", "character(", t)
    t = re.sub(r"\s+", "", t)
    return t.strip(",")


def parse_standard(pdf):
    """{routine: {"args": [...], "params": {name: attrs}}} from Appendix A.4."""
    # Rejoin declarations the layout has wrapped: a continuation is a line that
    # starts neither a binding nor a declaration.
    logical = []
    for s in text_of_appendix(pdf):
        if SIG.match(s) or DECL.match(s):
            logical.append(s)
        elif logical:
            logical[-1] += " " + s

    routines, cur = {}, None
    for s in logical:
        m = SIG.match(s)
        if m:
            name = m.group(1)
            # The large-count variant is flagged "!(_c)" and is sometimes
            # already spelled with the suffix, as MPI_Op_create_c is.
            if "!(_c)" in s and not name.lower().endswith("_c"):
                name += "_c"
            depth, args = 0, ""
            for i, ch in enumerate(s[m.end() - 1 :]):
                depth += (ch == "(") - (ch == ")")
                if depth == 0:
                    args = s[m.end() : m.end() - 1 + i]
                    break
            cur = {"args": [a.strip().lower() for a in args.split(",") if a.strip()], "params": {}}
            routines[name] = cur
        elif cur is not None and "::" in s and not re.match(r"^(USE|IMPLICIT|ABSTRACT)", s, re.I):
            lhs, rhs = s.split("::", 1)
            for n in split_names(rhs):
                cur["params"][n] = attributes(lhs)
    return routines


def parse_generated(path):
    """The same shape, from gen/mpif_f08_functions.F90."""
    lines = open(path).read().split("\n")
    routines = {}
    i, n = 0, len(lines)
    while i < n:
        m = re.match(r"^  (?:subroutine|function) (\w+)\( *&?\s*$", lines[i])
        if not m:
            i += 1
            continue
        name = m.group(1)
        args, i = [], i + 1
        while not re.match(r"^  \)", lines[i]):
            a = lines[i].strip().rstrip("&").strip().rstrip(",").strip()
            if a:
                args.append(a.lower())
            i += 1
        params = {}
        while i < n and not re.match(r"^  end (?:subroutine|function) ", lines[i]):
            s, i = lines[i].strip(), i + 1
            if s.startswith("!") or "::" not in s:
                continue
            lhs, rhs = s.split("::", 1)
            if re.match(r"^(use|implicit|interface)\b", lhs.strip(), re.I):
                continue
            for x in split_names(rhs):
                if x in args:
                    params[x] = attributes(lhs)
        routines[name] = {"args": args, "params": params}
    return routines


def main():
    if not os.path.exists(PDF):
        sys.exit(f"{PDF}: not found. Keep a copy of the MPI-5.0 standard there.")
    std = parse_standard(PDF)
    gen = parse_generated(GEN)

    problems = 0

    # The parse checks itself: in A.4 every argument is declared exactly once,
    # so anything else means the text was misread and no comparison below can
    # be trusted.
    for name, r in sorted(std.items()):
        missing = set(r["args"]) - set(r["params"])
        extra = set(r["params"]) - set(r["args"])
        if missing or extra:
            problems += 1
            print(f"PARSE  {name}: undeclared {sorted(missing)}, not an argument {sorted(extra)}")

    shared = sorted(set(std) & set(gen))
    print(f"{len(std)} bindings in A.4, {len(gen)} generated, {len(shared)} in both")
    for name in sorted(set(gen) - set(std)):
        print(f"note   {name}: generated, not in A.4")
    for name in sorted(set(std) - set(gen)):
        print(f"note   {name}: in A.4, not generated (hand-written or a callback)")

    buffers = 0
    for name in shared:
        s, g = std[name], gen[name]
        if s["args"] != g["args"]:
            problems += 1
            print(f"ARGS   {name}: A.4 {s['args']}, generated {g['args']}")
            continue
        for p in g["args"]:
            sp, gp = s["params"][p], g["params"][p]
            # A choice buffer is `TYPE(*), DIMENSION(..)` in the standard and
            # `integer :: buf(*)` here, deliberately, so neither its type nor its
            # missing intent is a finding. Count them and move on.
            if "DIMENSION(..)" in sp["type"]:
                buffers += 1
                continue
            if sp["intent"] != gp["intent"]:
                problems += 1
                print(
                    f"INTENT {name} / {p}: A.4 says {sp['intent'] or 'no intent'}, "
                    f"generated says {gp['intent'] or 'no intent'}"
                    f"\n         A.4:       {sp['type']}"
                    f"\n         generated: {gp['type']}"
                )
            if sp["base"] != gp["base"]:
                problems += 1
                print(
                    f"TYPE   {name} / {p}: A.4 says {sp['base']}, "
                    f"generated says {gp['base']}"
                    f"\n         A.4:       {sp['type']}"
                    f"\n         generated: {gp['type']}"
                )

    print()
    if buffers:
        print(f"{buffers} choice-buffer intents omitted, as expected:\n{EXPECTED}\n")
    if problems:
        print(f"{problems} unexplained divergences")
        return 1
    print("no unexplained divergences")
    return 0


if __name__ == "__main__":
    sys.exit(main())
