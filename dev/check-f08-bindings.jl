# Check mpif's mpi_f08 declarations against the MPI-5.0 appendices.
#
# Three sets of declarations, each against the appendix that gives it:
#
#   gen/mpif_f08_functions.F90   the 590 generated wrappers        against A.4
#   src/mpif_f08_types.F90       the 20 callback ABSTRACT INTERFACEs against A.1.3
#   src/mpif_f08_attr_fns.F90    the 11 predefined callbacks       against A.4
#
# The generator derives every f08 INTENT from the parameter's `param_direction`
# in `data/apis.json`, and the standard's own bindings do not always agree. Where
# they disagree the standard has usually omitted an intent deliberately, in a
# place where the direction of the data does not tell the whole story, and a
# generator that reads only the direction cannot know. Two such divergences were
# real defects: INTENT(OUT) on a status destroyed the caller's `status%MPI_ERROR`
# before the call, and INTENT(IN) on a callback's `extra_state` stopped a
# conforming callback from compiling at all.
#
# The declared *type* is checked the same way and for the same reason. Intents
# alone missed `MPI_Buffer_detach`'s `buffer_addr`, which is INTENT(OUT) on both
# sides and TYPE(C_PTR) in the standard against INTEGER(KIND=MPI_ADDRESS_KIND)
# here -- a caller cannot pass what the standard says to pass. Comparing types
# costs nothing extra, both declarations having been parsed already, and VALUE
# comes with them: for a TYPE(C_PTR) it is the difference between a pointer and
# the address of a pointer.
#
# The last two sets are hand-written, which is why they are here. Nothing else
# holds them to the standard, and `MPI_User_function`'s buffers were
# INTEGER(KIND=MPI_ADDRESS_KIND) where A.1.3 gives TYPE(C_PTR), VALUE -- for as
# long as it took someone to write a reduction callback and find that it could not
# be passed. Extending this to A.1.3 then found a second divergence at once, in
# `MPI_Type_delete_attr_function`'s first argument.
#
# `pdftotext -layout` makes the appendices greppable; what comes out is regular
# enough to parse, and the parse checks itself -- every routine's argument list has
# to be exactly covered by its declarations, and this exits nonzero if any is not.
#
# Usage:  julia dev/check-f08-bindings.jl [doc/mpi50-report.pdf]
#
# Keep a copy of the standard at doc/mpi50-report.pdf; it is git-ignored.
#
# Exits 0 when the only divergences left are the expected ones, which are named
# in `expected` below and printed as a reminder rather than an error. An exemption
# that stops firing is itself a failure, so that the list cannot go stale.

const repo = dirname(dirname(abspath(@__FILE__)))
const pdf_path = length(ARGS) ≥ 1 ? ARGS[1] : joinpath(repo, "doc", "mpi50-report.pdf")
const gen_file = joinpath(repo, "gen", "mpif_f08_functions.F90")
const types_file = joinpath(repo, "src", "mpif_f08_types.F90")
const attr_fns_file = joinpath(repo, "src", "mpif_f08_attr_fns.F90")
const mpi_f08_file = joinpath(repo, "src", "mpi_f08.F90")

# Divergences that are known, deliberate and recorded in MISSING.md. Anything
# else is a finding. Each is counted and printed as a reminder, so that one which
# stops happening is noticed rather than silently kept.
const expected = Dict(
    "buffers" => """
        Choice buffers. The standard declares an input buffer
        `TYPE(*), DIMENSION(..), INTENT(IN)`; mpif declares every choice buffer
        `integer :: buf(*)` under `ignore_tkr`/`no_arg_check` and gives it no intent,
        which is the `MPI_SUBARRAYS_SUPPORTED == .FALSE.` option the standard offers.
        Omitting the intent is what lets the wrapper hand the buffer on to a dummy that
        has none; it forbids nothing a conforming program may do. See "Assumed-rank
        choice buffers" in MISSING.md.""",
    "MPI_TYPE_NULL_DELETE_FN's ierror" => """
        A.4 gives MPI_TYPE_NULL_DELETE_FN's `ierror` INTENT(OUT), where its own abstract
        interface MPI_Type_delete_attr_function gives none and where the other twelve
        predefined callbacks give none. That is an inconsistency in the standard, and
        mpif follows the abstract interface -- it has to, since INTENT is part of a dummy
        argument's characteristics and a callback declaring one could not be passed as
        the PROCEDURE(MPI_Type_delete_attr_function) dummy a wrapper takes.""")

# The intents not to compare, by (routine, argument), each explained in `expected`.
const intent_exempt = Dict(("MPI_TYPE_NULL_DELETE_FN", "ierror") => "MPI_TYPE_NULL_DELETE_FN's ierror")

const stripped_cache = Dict{String,Vector{String}}()

"""Every line of the standard, with the margin line numbers gone."""
function stripped_lines(pdf)
    get!(stripped_cache, pdf) do
        out = read(`pdftotext -layout $pdf -`, String)
        map(split(out, "\n")) do ln
            ln = replace(ln, r"\s{2,}\d+\s*$" => "")  # margin numbers, right-hand pages
            ln = replace(ln, r"^\s*\d+\s{2,}" => "")  # margin numbers, left-hand pages
            strip(ln)
        end
    end
end

"""The lines of Appendix A.4, with margin line numbers and running heads gone."""
function text_of_appendix(pdf)
    stripped = stripped_lines(pdf)

    # The heading and the running head above it read the same once the page
    # number is off; either will do as the start. The table of contents does
    # not, its dot leaders surviving the strip.
    start = end_ = nothing
    for (n, s) in enumerate(stripped)
        if start === nothing
            if s == "A.4 Fortran 2008 Bindings with the mpi_f08 Module"
                start = n
            end
        elseif startswith(s, "A.5 Fortran Bindings with mpif.h or the mpi Module")
            end_ = n
            break
        end
    end
    if start === nothing || end_ === nothing
        error("$pdf: could not find Appendix A.4")
    end

    clean = String[]
    for s in stripped[start+1:end_-1]
        isempty(s) && continue
        occursin(r"^\d+$", s) && continue
        occursin("Appendix A Language Bindings Summary", s) && continue
        occursin(r"^A\.4(\.\d+)? [A-Z(]", s) && continue
        s == "A.4 Fortran 2008 Bindings with the mpi_f08 Module" && continue
        push!(clean, s)
    end
    return clean
end

"""
The lines of A.1.3's `mpi_f08` part, where the callback prototypes live.

The abstract interfaces are not in A.4 -- A.4 has the routines and the
predefined callbacks, but not the ABSTRACT INTERFACEs a user writes a callback
against. Those are in A.1.3, "Prototype Definitions", after the C typedefs and
before the mpif.h forms, and are the same shape once the prose between them is
dropped. Eighteen of mpif's twenty are there; the two that are not are the MPI-1
forms, which the standard gives for mpif.h alone.
"""
function text_of_prototypes(pdf)
    stripped = stripped_lines(pdf)

    start = end_ = nothing
    for (n, s) in enumerate(stripped)
        if start === nothing
            # The heading is unnumbered; the C typedefs come first, so the first
            # occurrence after A.1.3 begins is the one wanted. The table of
            # contents keeps its dot leaders and does not match.
            if s == "Fortran 2008 Bindings with the mpi_f08 Module"
                start = n
            end
        elseif s == "Fortran Bindings with mpif.h or the mpi Module"
            end_ = n
            break
        end
    end
    if start === nothing || end_ === nothing
        error("$pdf: could not find the mpi_f08 prototypes in A.1.3")
    end

    clean = String[]
    for s in stripped[start+1:end_-1]
        isempty(s) && continue
        occursin(r"^\d+$", s) && continue
        occursin("Appendix A Language Bindings Summary", s) && continue
        startswith(s, "A.1 Defined Values and Handles") && continue
        push!(clean, s)
    end
    return clean
end

const DECL = r"^(TYPE\s*\(|INTEGER|LOGICAL|CHARACTER|REAL|DOUBLE|COMPLEX|PROCEDURE|EXTERNAL|USE\b|ABSTRACT|IMPLICIT|CLASS)"i
# A binding, optionally preceded by its result type: "DOUBLE PRECISION MPI_Wtime()".
const SIG = r"^(?:[A-Z][A-Z_() =]*[A-Z)] +)?(MPI_[A-Za-z0-9_]*)\s*\("

"""The declared names on the right of a `::`, ignoring commas inside ()."""
function split_names(rhs)
    depth = 0
    buf = ""
    names = String[]
    for ch in rhs
        if ch == '('
            depth += 1
        elseif ch == ')'
            depth -= 1
        end
        if ch == ',' && depth == 0
            push!(names, buf)
            buf = ""
        else
            buf *= ch
        end
    end
    push!(names, buf)
    declared = String[]
    for n in names
        m = match(r"^[A-Za-z_]\w*", strip(n))
        m === nothing || push!(declared, lowercase(m.match))
    end
    return declared
end

"""
The declaration with the attributes and the spelling differences taken out.

The two sides say the same thing in different words -- `INTEGER(KIND=
MPI_COUNT_KIND)` against `integer(MPI_COUNT_KIND)`, `CHARACTER(LEN=*)` against
`character*(*)` -- so a textual comparison has to be given the vocabulary first.
What is left is the type and its kind, which is what a caller has to match.
"""
function base_type(lhs)
    t = lowercase(lhs)
    # attributes are not part of the type; intent is compared separately
    for attr in ("intent", "optional", "asynchronous", "value", "pointer",
                 "allocatable", "target", "external", "dimension")
        t = replace(t, Regex(",\\s*$attr\\s*(\\([^)]*\\))?") => "")
    end
    t = replace(t, r"^\s*(use|import)\b.*" => "")
    t = replace(t, "kind=" => "", "len=" => "")
    # `character*(*)` and `character(*)` are the same declaration
    t = replace(t, r"character\s*\*\s*\(" => "character(")
    t = replace(t, r"\s+" => "")
    return strip(t, ',')
end

function attributes(lhs)
    m = match(r"INTENT\s*\(\s*(IN\s*OUT|INOUT|IN|OUT)\s*\)"i, lhs)
    return Dict(
        "intent" => m === nothing ? nothing : replace(uppercase(m[1]), " " => ""),
        # VALUE is compared as well as the type, because it is the difference
        # between a pointer and the address of a pointer: the callbacks that take
        # a TYPE(C_PTR) take it by value, and one declared without VALUE would
        # receive something else entirely while reading the same in the type.
        "value" => match(r",\s*VALUE\b"i, lhs) !== nothing,
        "type" => strip(lhs),
        "base" => base_type(lhs))
end

"""Whether a line must be continued: an open paren or a trailing comma."""
incomplete(s) = count(==('('), s) != count(==(')'), s) || endswith(rstrip(s), ",")

"""The text between `open` -- the index of a `(` -- and its matching `)`."""
function paren_contents(s, open)
    depth = 0
    i = open
    while i ≤ lastindex(s)
        c = s[i]
        depth += (c == '(') - (c == ')')
        depth == 0 && return s[nextind(s, open):prevind(s, i)]
        i = nextind(s, i)
    end
    return ""
end

split_args(args) = [lowercase(strip(a)) for a in split(args, ",") if !isempty(strip(a))]

"""
`Dict(routine => Dict("args" => [...], "params" => Dict(name => attrs)))` from
appendix lines.

`prose` for a section that has sentences between the declarations, as A.1.3 does
and A.4 does not: a continuation is then only accepted after a line that demands
one, so that "The copy and delete function arguments to ... should be declared
according to:" is dropped rather than glued to the declaration above it.
"""
function parse_bindings(lines; prose=false)
    # Rejoin declarations the layout has wrapped: a continuation is a line that
    # starts neither a binding nor a declaration.
    logical = String[]
    for s in lines
        if match(SIG, s) !== nothing || match(DECL, s) !== nothing
            push!(logical, s)
        elseif !isempty(logical) && (!prose || incomplete(logical[end]))
            logical[end] *= " " * s
        end
    end

    routines = Dict{String,Any}()
    cur = nothing
    for s in logical
        m = match(SIG, s)
        if m !== nothing
            name = m[1]
            # The large-count variant is flagged "!(_c)" and is sometimes
            # already spelled with the suffix, as MPI_Op_create_c is.
            if occursin("!(_c)", s) && !endswith(lowercase(name), "_c")
                name *= "_c"
            end
            args = paren_contents(s, prevind(s, m.offset + ncodeunits(m.match)))
            cur = Dict{String,Any}("args" => split_args(args), "params" => Dict{String,Any}())
            routines[name] = cur
        elseif cur !== nothing && occursin("::", s) && match(r"^(USE|IMPLICIT|ABSTRACT)"i, s) === nothing
            lhs, rhs = split(s, "::"; limit=2)
            for n in split_names(rhs)
                cur["params"][n] = attributes(lhs)
            end
        end
    end
    return routines
end

"""The bindings of Appendix A.4."""
parse_standard(pdf) = parse_bindings(text_of_appendix(pdf))

"""The mpi_f08 ABSTRACT INTERFACEs of A.1.3."""
parse_standard_prototypes(pdf) = parse_bindings(text_of_prototypes(pdf); prose=true)

"""
The same shape, from the ABSTRACT INTERFACE blocks of a hand-written module.

Their argument list is on the `subroutine` line, continued with `&` where it is
long, rather than one argument per line as the generated wrappers write it; the
five-space indent is what tells an abstract interface from a module procedure
further down the file.
"""
function parse_abstract_interfaces(path)
    lines = split(read(path, String), "\n")
    routines = Dict{String,Any}()
    i, n = 1, length(lines)
    while i ≤ n
        m = match(r"^     (?:subroutine|function) (\w+)\(", lines[i])
        if m === nothing
            i += 1
            continue
        end
        name = m[1]
        sig = strip(lines[i])
        while endswith(sig, "&") && i < n
            i += 1
            sig = rstrip(chop(sig)) * " " * strip(lines[i])
        end
        args = split_args(sig[nextind(sig, findfirst('(', sig)):prevind(sig, findlast(')', sig))])
        params = Dict{String,Any}()
        i += 1
        while i ≤ n && match(r"^     end (?:subroutine|function) ", lines[i]) === nothing
            s = strip(lines[i])
            i += 1
            (startswith(s, "!") || !occursin("::", s)) && continue
            lhs, rhs = split(s, "::"; limit=2)
            match(r"^(use|implicit|import|interface)\b"i, strip(lhs)) === nothing || continue
            for x in split_names(rhs)
                x in args && (params[x] = attributes(lhs))
            end
        end
        routines[name] = Dict{String,Any}("args" => args, "params" => params)
    end
    return routines
end

"""
The predefined callbacks, under the names A.4 knows them by.

They are declared `mpif_f08_comm_null_copy_fn` and so on, because the standard's
names belong to the mpif.h forms' global symbols, and src/mpi_f08.F90 renames
each on the way out. The rename is read from there rather than hardcoded, so that
a name added in one place and not the other shows up as a missing binding instead
of passing unnoticed.
"""
function parse_predefined_callbacks(attr_fns, mpi_f08)
    renames = Dict{String,String}()
    for ln in eachline(mpi_f08)
        m = match(r"^\s*(MPI_\w+)\s*=>\s*(mpif_f08_\w+)", ln)
        m === nothing || (renames[lowercase(m[2])] = m[1])
    end

    routines = Dict{String,Any}()
    for (name, r) in parse_abstract_interfaces(attr_fns)
        routines[get(renames, lowercase(name), name)] = r
    end
    return routines
end

"""The same shape, from gen/mpif_f08_functions.F90."""
function parse_generated(path)
    lines = split(read(path, String), "\n")
    routines = Dict{String,Any}()
    i, n = 1, length(lines)
    while i ≤ n
        m = match(r"^  (?:subroutine|function) (\w+)\( *&?\s*$", lines[i])
        if m === nothing
            i += 1
            continue
        end
        name = m[1]
        args = String[]
        i += 1
        while match(r"^  \)", lines[i]) === nothing
            a = strip(rstrip(strip(rstrip(strip(lines[i])), '&')), ',')
            isempty(a) || push!(args, lowercase(a))
            i += 1
        end
        params = Dict{String,Any}()
        while i ≤ n && match(r"^  end (?:subroutine|function) ", lines[i]) === nothing
            s = strip(lines[i])
            i += 1
            (startswith(s, "!") || !occursin("::", s)) && continue
            lhs, rhs = split(s, "::"; limit=2)
            match(r"^(use|implicit|interface)\b"i, strip(lhs)) === nothing || continue
            for x in split_names(rhs)
                x in args && (params[x] = attributes(lhs))
            end
        end
        routines[name] = Dict{String,Any}("args" => args, "params" => params)
    end
    return routines
end

"""
Compare one set of declarations against the standard's.

`where` names the appendix section, `what` names what is being checked against
it, and `absent` explains a name the standard has and mpif does not. Returns
(problems, a count of the `expected` divergences passed over).
"""
function compare(std, ours, where, what, absent)
    problems = 0
    passed_over = Dict{String,Int}()
    over!(kind) = passed_over[kind] = get(passed_over, kind, 0) + 1

    # The parse checks itself: in the appendix every argument is declared exactly
    # once, so anything else means the text was misread and no comparison below
    # can be trusted.
    for name in sort(collect(keys(std)))
        r = std[name]
        missing_ = sort(collect(setdiff(r["args"], keys(r["params"]))))
        extra = sort(collect(setdiff(keys(r["params"]), r["args"])))
        if !isempty(missing_) || !isempty(extra)
            problems += 1
            println("PARSE  $name: undeclared $missing_, not an argument $extra")
        end
    end

    shared = sort(collect(intersect(keys(std), keys(ours))))
    println("$(length(std)) in $where, $(length(ours)) $what, $(length(shared)) in both")
    for name in sort(collect(setdiff(keys(ours), keys(std))))
        println("note   $name: $what, not in $where")
    end
    for name in sort(collect(setdiff(keys(std), keys(ours))))
        println("note   $name: in $where, $absent")
    end

    for name in shared
        s, g = std[name], ours[name]
        if s["args"] != g["args"]
            problems += 1
            println("ARGS   $name: $where $(s["args"]), $what $(g["args"])")
            continue
        end
        for p in g["args"]
            sp, gp = s["params"][p], g["params"][p]
            # A choice buffer is `TYPE(*), DIMENSION(..)` in the standard and
            # `integer :: buf(*)` here, deliberately, so neither its type nor its
            # missing intent is a finding. Count them and move on.
            if occursin("DIMENSION(..)", sp["type"])
                over!("buffers")
                continue
            end
            exempt = get(intent_exempt, (name, p), nothing)
            if sp["intent"] != gp["intent"]
                if exempt !== nothing
                    over!(exempt)
                else
                    problems += 1
                    println("INTENT $name / $p: $where says $(something(sp["intent"], "no intent")), " *
                            "$what says $(something(gp["intent"], "no intent"))" *
                            "\n         $where: $(sp["type"])" *
                            "\n         mpif:   $(gp["type"])")
                end
            end
            if sp["base"] != gp["base"]
                problems += 1
                println("TYPE   $name / $p: $where says $(sp["base"]), $what says $(gp["base"])" *
                        "\n         $where: $(sp["type"])" *
                        "\n         mpif:   $(gp["type"])")
            end
            if sp["value"] != gp["value"]
                problems += 1
                println("VALUE  $name / $p: $where says $(sp["value"] ? "VALUE" : "by reference"), " *
                        "$what says $(gp["value"] ? "VALUE" : "by reference")" *
                        "\n         $where: $(sp["type"])" *
                        "\n         mpif:   $(gp["type"])")
            end
        end
    end
    return problems, passed_over
end

function main()
    isfile(pdf_path) ||
        error("$pdf_path: not found. Keep a copy of the MPI-5.0 standard there.")

    standard = parse_standard(pdf_path)
    predefined = parse_predefined_callbacks(attr_fns_file, mpi_f08_file)

    # All three of mpif's f08 declarations, against the appendix that gives each.
    # The generated wrappers are only the first: the abstract interfaces a user
    # writes a callback against are hand-written, and so are the predefined
    # callbacks, and both can drift. `MPI_User_function`'s buffers were
    # INTEGER(KIND=MPI_ADDRESS_KIND) where A.1.3 gives TYPE(C_PTR), VALUE, and
    # that survived precisely because nothing compared the abstract interfaces
    # with anything.
    checks = [
        (standard, parse_generated(gen_file), "A.4", "generated",
         "not generated (hand-written or a callback)"),
        (parse_standard_prototypes(pdf_path), parse_abstract_interfaces(types_file), "A.1.3",
         "in mpif_f08_types", "not declared here (deprecated, or C-only)"),
        (filter(kv -> haskey(predefined, kv[1]), standard), predefined, "A.4",
         "in mpif_f08_attr_fns", "not declared here"),
    ]

    problems = 0
    passed_over = Dict{String,Int}()
    for (n, args) in enumerate(checks)
        n == 1 || println()
        p, over = compare(args...)
        problems += p
        mergewith!(+, passed_over, over)
    end

    println()
    for kind in sort(collect(keys(passed_over)))
        what = kind == "buffers" ? "choice-buffer intents omitted" : kind
        println("$(passed_over[kind]) $what, as expected:\n$(expected[kind])\n")
    end
    unexplained = sort(collect(setdiff(keys(expected), keys(passed_over))))
    if !isempty(unexplained)
        # An exemption that no longer fires is a stale exemption, and the next
        # divergence it covers would go unreported.
        problems += length(unexplained)
        println("STALE  no longer diverges, so drop from `expected`: $unexplained\n")
    end
    if problems > 0
        println("$problems unexplained divergences")
        return 1
    end
    println("no unexplained divergences")
    return 0
end

exit(main())
