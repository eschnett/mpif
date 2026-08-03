#!/usr/bin/env python3

"""Check mpif's mpi_f08 declarations against the MPI-5.0 appendices.

Three sets of declarations, each against the appendix that gives it:

  gen/mpif_f08_functions.F90   the 590 generated wrappers        against A.4
  src/mpif_f08_types.F90       the 20 callback ABSTRACT INTERFACEs against A.1.3
  src/mpif_f08_attr_fns.F90    the 11 predefined callbacks       against A.4

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
costs nothing extra, both declarations having been parsed already, and VALUE
comes with them: for a TYPE(C_PTR) it is the difference between a pointer and
the address of a pointer.

The last two sets are hand-written, which is why they are here. Nothing else
holds them to the standard, and `MPI_User_function`'s buffers were
INTEGER(KIND=MPI_ADDRESS_KIND) where A.1.3 gives TYPE(C_PTR), VALUE -- for as
long as it took someone to write a reduction callback and find that it could not
be passed. Extending this to A.1.3 then found a second divergence at once, in
`MPI_Type_delete_attr_function`'s first argument.

`pdftotext -layout` makes the appendices greppable; what comes out is regular
enough to parse, and the parse checks itself -- every routine's argument list has
to be exactly covered by its declarations, and this exits nonzero if any is not.

Usage:  python3 dev/check-f08-bindings.py [doc/mpi50-report.pdf]

Keep a copy of the standard at doc/mpi50-report.pdf; it is git-ignored.

Exits 0 when the only divergences left are the expected ones, which are named
in EXPECTED below and printed as a reminder rather than an error. An exemption
that stops firing is itself a failure, so that the list cannot go stale.
"""

import collections
import os
import re
import subprocess
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PDF = sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO, "doc", "mpi50-report.pdf")
GEN = os.path.join(REPO, "gen", "mpif_f08_functions.F90")
TYPES = os.path.join(REPO, "src", "mpif_f08_types.F90")
ATTR_FNS = os.path.join(REPO, "src", "mpif_f08_attr_fns.F90")
MPI_F08 = os.path.join(REPO, "src", "mpi_f08.F90")

# Divergences that are known, deliberate and recorded in MISSING.md. Anything
# else is a finding. Each is counted and printed as a reminder, so that one which
# stops happening is noticed rather than silently kept.
EXPECTED = {
    "buffers": """\
Choice buffers. The standard declares an input buffer
`TYPE(*), DIMENSION(..), INTENT(IN)`; mpif declares every choice buffer
`integer :: buf(*)` under `ignore_tkr`/`no_arg_check` and gives it no intent,
which is the `MPI_SUBARRAYS_SUPPORTED == .FALSE.` option the standard offers.
Omitting the intent is what lets the wrapper hand the buffer on to a dummy that
has none; it forbids nothing a conforming program may do. See "Assumed-rank
choice buffers" in MISSING.md.""",
    "MPI_TYPE_NULL_DELETE_FN's ierror": """\
A.4 gives MPI_TYPE_NULL_DELETE_FN's `ierror` INTENT(OUT), where its own abstract
interface MPI_Type_delete_attr_function gives none and where the other twelve
predefined callbacks give none. That is an inconsistency in the standard, and
mpif follows the abstract interface -- it has to, since INTENT is part of a dummy
argument's characteristics and a callback declaring one could not be passed as
the PROCEDURE(MPI_Type_delete_attr_function) dummy a wrapper takes.""",
}

# The intents not to compare, by (routine, argument), each explained in EXPECTED.
INTENT_EXEMPT = {("MPI_TYPE_NULL_DELETE_FN", "ierror"): "MPI_TYPE_NULL_DELETE_FN's ierror"}


def stripped_lines(pdf, _cache={}):
    """Every line of the standard, with the margin line numbers gone."""
    if pdf in _cache:
        return _cache[pdf]
    out = subprocess.run(
        ["pdftotext", "-layout", pdf, "-"], check=True, capture_output=True, text=True
    ).stdout.split("\n")

    stripped = []
    for ln in out:
        ln = re.sub(r"\s{2,}\d+\s*$", "", ln)  # margin numbers, right-hand pages
        ln = re.sub(r"^\s*\d+\s{2,}", "", ln)  # margin numbers, left-hand pages
        stripped.append(ln.strip())
    _cache[pdf] = stripped
    return stripped


def text_of_appendix(pdf):
    """The lines of Appendix A.4, with margin line numbers and running heads gone."""
    stripped = stripped_lines(pdf)

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


def text_of_prototypes(pdf):
    """The lines of A.1.3's `mpi_f08` part, where the callback prototypes live.

    The abstract interfaces are not in A.4 -- A.4 has the routines and the
    predefined callbacks, but not the ABSTRACT INTERFACEs a user writes a
    callback against. Those are in A.1.3, "Prototype Definitions", after the C
    typedefs and before the mpif.h forms, and are the same shape once the prose
    between them is dropped. Eighteen of mpif's twenty are there; the two that
    are not are the MPI-1 forms, which the standard gives for mpif.h alone.
    """
    stripped = stripped_lines(pdf)

    start = end = None
    for n, s in enumerate(stripped):
        if start is None:
            # The heading is unnumbered; the C typedefs come first, so the first
            # occurrence after A.1.3 begins is the one wanted. The table of
            # contents keeps its dot leaders and does not match.
            if s == "Fortran 2008 Bindings with the mpi_f08 Module":
                start = n
        elif s == "Fortran Bindings with mpif.h or the mpi Module":
            end = n
            break
    if start is None or end is None:
        sys.exit(f"{pdf}: could not find the mpi_f08 prototypes in A.1.3")

    clean = []
    for s in stripped[start + 1 : end]:
        if not s or re.fullmatch(r"\d+", s):
            continue
        if "Appendix A Language Bindings Summary" in s:
            continue
        if s.startswith("A.1 Defined Values and Handles"):
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
        # VALUE is compared as well as the type, because it is the difference
        # between a pointer and the address of a pointer: the callbacks that take
        # a TYPE(C_PTR) take it by value, and one declared without VALUE would
        # receive something else entirely while reading the same in the type.
        "value": bool(re.search(r",\s*VALUE\b", lhs, re.I)),
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


def incomplete(s):
    """Whether a line must be continued: an open paren or a trailing comma."""
    return s.count("(") != s.count(")") or s.rstrip().endswith(",")


def parse_bindings(lines, prose=False):
    """{routine: {"args": [...], "params": {name: attrs}}} from appendix lines.

    `prose` for a section that has sentences between the declarations, as
    A.1.3 does and A.4 does not: a continuation is then only accepted after a
    line that demands one, so that "The copy and delete function arguments to
    ... should be declared according to:" is dropped rather than glued to the
    declaration above it.
    """
    # Rejoin declarations the layout has wrapped: a continuation is a line that
    # starts neither a binding nor a declaration.
    logical = []
    for s in lines:
        if SIG.match(s) or DECL.match(s):
            logical.append(s)
        elif logical and (not prose or incomplete(logical[-1])):
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


def parse_standard(pdf):
    """The bindings of Appendix A.4."""
    return parse_bindings(text_of_appendix(pdf))


def parse_standard_prototypes(pdf):
    """The mpi_f08 ABSTRACT INTERFACEs of A.1.3."""
    return parse_bindings(text_of_prototypes(pdf), prose=True)


def parse_abstract_interfaces(path):
    """The same shape, from the ABSTRACT INTERFACE blocks of a hand-written module.

    Their argument list is on the `subroutine` line, continued with `&` where it
    is long, rather than one argument per line as the generated wrappers write
    it; the five-space indent is what tells an abstract interface from a module
    procedure further down the file.
    """
    lines = open(path).read().split("\n")
    routines = {}
    i, n = 0, len(lines)
    while i < n:
        m = re.match(r"^     (?:subroutine|function) (\w+)\(", lines[i])
        if not m:
            i += 1
            continue
        name = m.group(1)
        sig = lines[i].strip()
        while sig.endswith("&") and i + 1 < n:
            i += 1
            sig = sig[:-1].rstrip() + " " + lines[i].strip()
        args = [a.strip().lower() for a in sig[sig.index("(") + 1 : sig.rindex(")")].split(",") if a.strip()]
        params, i = {}, i + 1
        while i < n and not re.match(r"^     end (?:subroutine|function) ", lines[i]):
            s, i = lines[i].strip(), i + 1
            if s.startswith("!") or "::" not in s:
                continue
            lhs, rhs = s.split("::", 1)
            if re.match(r"^(use|implicit|import|interface)\b", lhs.strip(), re.I):
                continue
            for x in split_names(rhs):
                if x in args:
                    params[x] = attributes(lhs)
        routines[name] = {"args": args, "params": params}
    return routines


def parse_predefined_callbacks(attr_fns, mpi_f08):
    """The predefined callbacks, under the names A.4 knows them by.

    They are declared `mpif_f08_comm_null_copy_fn` and so on, because the
    standard's names belong to the mpif.h forms' global symbols, and
    src/mpi_f08.F90 renames each on the way out. The rename is read from there
    rather than hardcoded, so that a name added in one place and not the other
    shows up as a missing binding instead of passing unnoticed.
    """
    renames = {}
    for ln in open(mpi_f08):
        m = re.match(r"\s*(MPI_\w+)\s*=>\s*(mpif_f08_\w+)", ln)
        if m:
            renames[m.group(2).lower()] = m.group(1)

    routines = {}
    for name, r in parse_abstract_interfaces(attr_fns).items():
        routines[renames.get(name.lower(), name)] = r
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


def compare(std, ours, where, what, absent):
    """Compare one set of declarations against the standard's.

    `where` names the appendix section, `what` names what is being checked
    against it, and `absent` explains a name the standard has and mpif does not.
    Returns (problems, a count of the EXPECTED divergences passed over).
    """
    problems, passed_over = 0, collections.Counter()

    # The parse checks itself: in the appendix every argument is declared exactly
    # once, so anything else means the text was misread and no comparison below
    # can be trusted.
    for name, r in sorted(std.items()):
        missing = set(r["args"]) - set(r["params"])
        extra = set(r["params"]) - set(r["args"])
        if missing or extra:
            problems += 1
            print(f"PARSE  {name}: undeclared {sorted(missing)}, not an argument {sorted(extra)}")

    shared = sorted(set(std) & set(ours))
    print(f"{len(std)} in {where}, {len(ours)} {what}, {len(shared)} in both")
    for name in sorted(set(ours) - set(std)):
        print(f"note   {name}: {what}, not in {where}")
    for name in sorted(set(std) - set(ours)):
        print(f"note   {name}: in {where}, {absent}")

    for name in shared:
        s, g = std[name], ours[name]
        if s["args"] != g["args"]:
            problems += 1
            print(f"ARGS   {name}: {where} {s['args']}, {what} {g['args']}")
            continue
        for p in g["args"]:
            sp, gp = s["params"][p], g["params"][p]
            # A choice buffer is `TYPE(*), DIMENSION(..)` in the standard and
            # `integer :: buf(*)` here, deliberately, so neither its type nor its
            # missing intent is a finding. Count them and move on.
            if "DIMENSION(..)" in sp["type"]:
                passed_over["buffers"] += 1
                continue
            exempt = INTENT_EXEMPT.get((name, p))
            if exempt and sp["intent"] != gp["intent"]:
                passed_over[exempt] += 1
            elif sp["intent"] != gp["intent"]:
                problems += 1
                print(
                    f"INTENT {name} / {p}: {where} says {sp['intent'] or 'no intent'}, "
                    f"{what} says {gp['intent'] or 'no intent'}"
                    f"\n         {where}: {sp['type']}"
                    f"\n         mpif:   {gp['type']}"
                )
            if sp["base"] != gp["base"]:
                problems += 1
                print(
                    f"TYPE   {name} / {p}: {where} says {sp['base']}, "
                    f"{what} says {gp['base']}"
                    f"\n         {where}: {sp['type']}"
                    f"\n         mpif:   {gp['type']}"
                )
            if sp["value"] != gp["value"]:
                problems += 1
                print(
                    f"VALUE  {name} / {p}: {where} says "
                    f"{'VALUE' if sp['value'] else 'by reference'}, {what} says "
                    f"{'VALUE' if gp['value'] else 'by reference'}"
                    f"\n         {where}: {sp['type']}"
                    f"\n         mpif:   {gp['type']}"
                )
    return problems, passed_over


def main():
    if not os.path.exists(PDF):
        sys.exit(f"{PDF}: not found. Keep a copy of the MPI-5.0 standard there.")

    standard = parse_standard(PDF)
    predefined = parse_predefined_callbacks(ATTR_FNS, MPI_F08)

    # All three of mpif's f08 declarations, against the appendix that gives each.
    # The generated wrappers are only the first: the abstract interfaces a user
    # writes a callback against are hand-written, and so are the predefined
    # callbacks, and both can drift. `MPI_User_function`'s buffers were
    # INTEGER(KIND=MPI_ADDRESS_KIND) where A.1.3 gives TYPE(C_PTR), VALUE, and
    # that survived precisely because nothing compared the abstract interfaces
    # with anything.
    checks = [
        (standard, parse_generated(GEN), "A.4", "generated",
         "not generated (hand-written or a callback)"),
        (parse_standard_prototypes(PDF), parse_abstract_interfaces(TYPES), "A.1.3",
         "in mpif_f08_types", "not declared here (deprecated, or C-only)"),
        ({k: v for k, v in standard.items() if k in predefined}, predefined, "A.4",
         "in mpif_f08_attr_fns", "not declared here"),
    ]

    problems, passed_over = 0, collections.Counter()
    for n, args in enumerate(checks):
        if n:
            print()
        p, over = compare(*args)
        problems += p
        passed_over += over

    print()
    for kind, count in sorted(passed_over.items()):
        what = "choice-buffer intents omitted" if kind == "buffers" else kind
        print(f"{count} {what}, as expected:\n{EXPECTED[kind]}\n")
    unexplained = set(EXPECTED) - set(passed_over)
    if unexplained:
        # An exemption that no longer fires is a stale exemption, and the next
        # divergence it covers would go unreported.
        problems += len(unexplained)
        print(f"STALE  no longer diverges, so drop from EXPECTED: {sorted(unexplained)}\n")
    if problems:
        print(f"{problems} unexplained divergences")
        return 1
    print("no unexplained divergences")
    return 0


if __name__ == "__main__":
    sys.exit(main())
