# git clone https://github.com/mpi-forum/pympistandard
# mkdir data
# cp pympistandard/src/pympistandard/data/apis.json data
#
# julia dev/mpiapi.jl

using JSON
apis = JSON.parsefile("data/apis.json")

kind2fun = Dict(["COMMUNICATOR" => "Comm",
                 "DATATYPE" => "Type",
                 "ERRHANDLER" => "Errhandler",
                 "FILE" => "File",
                 "GROUP" => "Group",
                 "INFO" => "Info",
                 "MESSAGE" => "Message",
                 "OPERATION" => "Op",
                 "REQUEST" => "Request",
                 "SESSION" => "Session",
                 "WINDOW" => "Win"])
kind2null = Dict(["COMMUNICATOR" => "COMM",
                  "DATATYPE" => "DATATYPE",
                  "ERRHANDLER" => "ERRHANDLER",
                  "FILE" => "FILE",
                  "GROUP" => "GROUP",
                  "INFO" => "INFO",
                  "MESSAGE" => "MESSAGE",
                  "OPERATION" => "OP",
                  "REQUEST" => "REQUEST",
                  "SESSION" => "SESSION",
                  "WINDOW" => "WINDOW"])
kind2type = Dict(["COMMUNICATOR" => "Comm",
                  "DATATYPE" => "Datatype",
                  "ERRHANDLER" => "Errhandler",
                  "FILE" => "File",
                  "GROUP" => "Group",
                  "INFO" => "Info",
                  "MESSAGE" => "Message",
                  "OPERATION" => "Op",
                  "REQUEST" => "Request",
                  "SESSION" => "Session",
                  "WINDOW" => "Win"])

# DISPOFFSET_SMALL

# `XFER_NUM_ELEM_NNI` is deliberately not here; see `count_kinds` below.
#
# `ERROR_CODE_SHOW_INTENT` is a plain INTEGER like `ERROR_CODE`, and belongs to
# one argument in the whole standard: MPI_TYPE_NULL_DELETE_FN's `ierror`, where
# A.4 shows INTENT(OUT) and the abstract interface it has to match,
# MPI_Type_delete_attr_function, shows none. The suffix is about that display and
# not about the type. mpif follows the abstract interface -- see
# `dev/check-f08-bindings.jl`, which exempts exactly this one intent -- so the
# kind carries no intent here either; a callback's arguments get none, which is a
# property of callbacks rather than of this kind.
int_kinds = ["ACCESS_MODE", "ARGUMENT_COUNT", "ARRAY_LENGTH", "ARRAY_LENGTH_NNI", "ARRAY_LENGTH_PI", "ASSERT", "COLOR", "COMBINER",
             "COMM_COMPARISON", "COMM_SIZE", "COMM_SIZE_PI", "COORDINATE", "DEGREE", "DIMENSION", "DISTRIB_ENUM",
             "DTYPE_DISTRIBUTION", "ERROR_CLASS", "ERROR_CODE", "ERROR_CODE_SHOW_INTENT", "FILE_DESCRIPTOR",
             "GENERIC_DTYPE_INT", "GROUP_COMPARISON", "INDEX",
             "INFO_VALUE_LENGTH", "KEY", "KEYVAL", "KEY_INDEX", "LOCK_TYPE", "MATH", "NUM_BYTES_SMALL", "NUM_DIMS", "ORDER",
             "PARTITION", "PROCESS_GRID_SIZE", "PROFILE_LEVEL", "RANK", "RANK_NNI", "SPLIT_TYPE",
             "STRING_LENGTH", "TAG",
             "THREAD_LEVEL", "TOPOLOGY_TYPE", "TYPECLASS", "TYPECLASS_SIZE", "UPDATE_MODE", "VERSION", "WEIGHT"]
int_aint_kinds = ["POLYDISPLACEMENT", "POLYRMA_DISPLACEMENT"]
int_count_kinds = ["POLYDISPLACEMENT_COUNT", "POLYDTYPE_NUM_ELEM", "POLYDTYPE_NUM_ELEM_NNI", "POLYDTYPE_NUM_ELEM_PI",
                   "POLYNUM_BYTES", "POLYNUM_BYTES_NNI", "POLYNUM_PARAM_VALUES", "POLYXFER_NUM_ELEM", "POLYXFER_NUM_ELEM_NNI"]

# RMA_DISPLACEMENT_NNI is the `target_disp` of MPI_Put and the nine other
# one-sided routines. It is address-sized on both sides -- C takes an MPI_Aint
# and the standard's Fortran binding says INTEGER(KIND=MPI_ADDRESS_KIND) -- and
# does not embiggen, the large-count forms taking an MPI_Aint too. Not to be
# confused with POLYRMA_DISPLACEMENT, the `disp_unit` of MPI_Win_create, which
# really is a plain INTEGER in the small form.
#
# Of the four `C_BUFFER*` kinds only `C_BUFFER` belongs here. They are one
# question asked four times -- is this parameter an address or a buffer -- and the
# answer is not the same for all four, so the answer for each is written down here
# rather than rediscovered at each use:
#
# - `C_BUFFER` is `baseptr` of MPI_Alloc_mem and the three MPI_Win_allocate*
#   routines, an address in both bindings: A.5 gives it
#   INTEGER(KIND=MPI_ADDRESS_KIND), paired with a TYPE(C_PTR) overload (see
#   src/mpif_cptr.F90), and A.4 gives it TYPE(C_PTR).
# - `C_BUFFER2` is `buffer_addr` of MPI_Buffer_detach, MPI_Comm_detach_buffer and
#   MPI_Session_detach_buffer. A.4 gives it TYPE(C_PTR) as well, but A.5 gives it
#   `<type> BUFFER_ADDR(*)` -- a choice buffer -- so it is not an integer in
#   either binding.
# - `C_BUFFER3` (the datarep conversion callbacks' `userbuf` and `filebuf`) and
#   `C_BUFFER4` (MPI_User_function's `invec` and `inoutvec`) are choice buffers in
#   A.5 too, and `TYPE(C_PTR), VALUE` in A.1.3 -- the callbacks receive the buffer
#   address itself, which is why VALUE and an assumed-size array's address are the
#   same thing here.
#
# All three of the latter are therefore handled with the `BUFFER` kind below.
aint_kinds = ["ALLOC_MEM_NUM_BYTES", "C_BUFFER", "DISPLACEMENT", "LOCATION_SMALL",
              "RMA_DISPLACEMENT_NNI", "WIN_ATTACH_SIZE", "WINDOW_SIZE"]

# The two whose mpi_f08 declaration is TYPE(C_PTR), whatever the mpi module's is.
# The wrapper passes an address-sized temporary to C either way and converts.
cptr_out_kinds = ["C_BUFFER", "C_BUFFER2"]

# The kinds that are a choice buffer in the mpi module and mpif.h and a
# TYPE(C_PTR) in mpi_f08. `C_BUFFER2` is an ordinary out parameter and gets
# INTENT(OUT); the other two are a callback's buffers and are passed by VALUE.
cptr_buffer_kinds = ["C_BUFFER2", "C_BUFFER3", "C_BUFFER4"]

# The kinds that only ever appear on a callback or a predefined function, both of
# which are dropped below. Asserted where they are dropped, so that "nothing
# generated reaches these" is checked on every run: the entries above and the
# ERROR_CODE_SHOW_INTENT one are right for a callback and would need looking at
# again if `apis.json` ever put one of these kinds on an ordinary routine.
callback_only_kinds = ["C_BUFFER3", "C_BUFFER4", "ERROR_CODE_SHOW_INTENT"]

aint_count_kinds = ["POLYDISPLACEMENT_AINT_COUNT", "POLYDISPOFFSET", "POLYDTYPE_PACK_SIZE", "POLYDTYPE_STRIDE_BYTES",
                    "POLYLOCATION"]

# The kinds that are always a count, as against the `POLY...` ones that are a
# plain INTEGER in the small form and a count in the `_c` form. The `POLY`
# prefix is the whole of the distinction: `POLYXFER_NUM_ELEM_NNI` is the count of
# 147 ordinary transfers, and `XFER_NUM_ELEM_NNI` without it belongs to
# MPI_Psend_init and MPI_Precv_init alone, which have no `_c` form because their
# one form already takes a count. MPI-5.0 gives both
# "INTEGER(KIND=MPI_COUNT_KIND), INTENT(IN) :: count", partitioned communication
# having arrived in MPI-4.0, after large counts. `XFER_NUM_ELEM` is the
# deprecated `_x` routines, which take a count for the same reason.
count_kinds = ["GENERIC_DTYPE_COUNT", "NUM_BYTES", "XFER_NUM_ELEM", "XFER_NUM_ELEM_NNI"]


# Fortran string arguments whose leading blanks have to be stripped along with
# their trailing ones. MPI specifies this per argument rather than uniformly, so
# this is a list and not a rule: MPI-5.0 asks for it for info keys and values
# (section 10, "The Info Object", and MPI_INFO_SET) and for MPI_COMM_SPAWN's
# `command` and `argv`, which MPI_COMM_SPAWN_MULTIPLE inherits by being
# "identical to MPI_COMM_SPAWN except that there are multiple executable
# specifications". Everything else keeps only its trailing blanks stripped:
# MPI_ADD_ERROR_STRING is explicitly trailing-only, and for port names, service
# names, file names and datareps the standard says nothing, so the conservative
# reading applies. See `mpif_strdup_f2c_trim` in src/mpif_strings.c.
strip_leading_blanks = Set([("MPI_Comm_spawn", "argv"),
                            ("MPI_Comm_spawn", "command"),
                            ("MPI_Comm_spawn_multiple", "array_of_argv"),
                            ("MPI_Comm_spawn_multiple", "array_of_commands"),
                            ("MPI_Info_delete", "key"),
                            ("MPI_Info_get", "key"),
                            ("MPI_Info_get_string", "key"),
                            ("MPI_Info_get_valuelen", "key"),
                            ("MPI_Info_set", "key"),
                            ("MPI_Info_set", "value")])

# The argument-vector sentinels, and the C constant each one stands for.
#
# Most sentinels need no special handling: MPI_ERRCODES_IGNORE and friends are
# forwarded to C untouched, and mpif.h puts the Fortran symbol at the address of
# the C constant (see include/mpif_constants.h), so passing the Fortran array
# hands C exactly the value it expects. An argument vector is different, because
# it has to be converted element by element, and these two constants are null
# pointers in C -- MPI_ARGV_NULL "is the same as NULL" -- so the conversion would
# read address zero. Compare against the C constant rather than against NULL:
# MPI-5.0 only says MPI_ARGVS_NULL is "likely to be (char ***)0".
argv_null_sentinels = Dict([("MPI_Comm_spawn", "argv") => "MPI_ARGV_NULL",
                            ("MPI_Comm_spawn_multiple", "array_of_argv") => "MPI_ARGVS_NULL"])

# String arrays whose element count is given by another argument rather than by a
# terminator. MPI_COMM_SPAWN's `argv` is "terminated by ... an empty string in
# Fortran", so scanning for one is right there, but MPI_COMM_SPAWN_MULTIPLE's
# `array_of_commands` is "programs to be executed" with `count` giving the "number
# of commands" -- there is no terminator to find, and scanning for one reads past
# the end of the caller's array.
string_array_counts = Dict([("MPI_Comm_spawn_multiple", "array_of_commands") => "*count"])

# The trampoline mpif hands MPI for each of a generalized request's callbacks.
# One apiece is enough, rather than the pools the operators and error handlers
# need, because `extra_state` belongs to mpif here and can carry a box saying
# which Fortran procedures to call. See src/mpif_callbacks.c.
grequest_trampolines = Dict(["MPI_Grequest_query_function" => "mpif_grequest_query_trampoline",
                             "MPI_Grequest_free_function" => "mpif_grequest_free_trampoline",
                             "MPI_Grequest_cancel_function" => "mpif_grequest_cancel_trampoline"])

# The datarep callbacks take the same route, with the box keyed by parameter
# name rather than by type: the two conversion callbacks share a `func_type` and
# differ only in which of them is being registered.
datarep_trampolines = Dict(["read_conversion_fn" => "mpif_datarep_read_trampoline",
                            "write_conversion_fn" => "mpif_datarep_write_trampoline",
                            "dtype_file_extent_fn" => "mpif_datarep_extent_trampoline"])
datarep_func_types = ["MPI_Datarep_conversion_function", "MPI_Datarep_conversion_function_c",
                      "MPI_Datarep_extent_function"]

# Attribute callbacks are the callbacks mpif can forward: every one of them
# receives the keyval, which is enough for a trampoline to find the Fortran
# procedure again. See src/mpif_callbacks.c. The other callback types have
# nothing identifying to go on and are still rejected.
attr_callback_kinds = Dict(["MPI_Comm_copy_attr_function" => "MPIF_ATTR_COMM_COPY",
                            "MPI_Comm_delete_attr_function" => "MPIF_ATTR_COMM_DELETE",
                            "MPI_Type_copy_attr_function" => "MPIF_ATTR_TYPE_COPY",
                            "MPI_Type_delete_attr_function" => "MPIF_ATTR_TYPE_DELETE",
                            "MPI_Win_copy_attr_function" => "MPIF_ATTR_WIN_COPY",
                            "MPI_Win_delete_attr_function" => "MPIF_ATTR_WIN_DELETE",
                            # Deprecated in MPI-2.0, for MPI_Keyval_create
                            "MPI_Copy_function" => "MPIF_ATTR_COMM_COPY_10",
                            "MPI_Delete_function" => "MPIF_ATTR_COMM_DELETE_10"])

# Fortran's .TRUE. and .FALSE. are not necessarily 1 and 0 -- gfortran and flang
# use 1, Intel uses -1 -- so the conversions below go through the helpers in
# src/mpif_logical.c, which ask the MPI library what the representation is.

struct State
    # have_fortran_booleans::Ref{Bool}
    have_comm::Ref{Bool}
    have_comm_rank::Ref{Bool}
    have_comm_size::Ref{Bool}

    State() = new(Ref(false), Ref(false), Ref(false))
end

# Convert an attribute value that MPI returned through a `void**`.
#
# MPI only writes it when there is an attribute to report, so on a false flag --
# or an error -- the pointer is still uninitialised. mpif_attr_value dereferences
# it for the predefined keyvals (MPI_UNIVERSE_SIZE and friends are a pointer to an
# int in C but a value in Fortran), which turns that into a wild read: it crashed
# MPICH's f08 spawn tests, whose MTestSpawnPossible asks MPI_COMM_WORLD for
# MPI_UNIVERSE_SIZE without knowing whether it is set. Zero it instead, which is
# what MPICH's own Fortran binding does.
function attr_value_conversion(parameters, parname, keyval, cast)
    flags = [p["name"] for p in parameters if p["kind"] == "LOGICAL" && p["param_direction"] == "out"]
    length(flags) == 1 || return ["*$parname = $(cast)mpif_attr_value(*$keyval, c_$parname);"]
    flag = only(flags)
    return ["if (*ierror != MPI_SUCCESS || !c_$flag)",
            "  *$parname = 0;",
            "else",
            "  *$parname = $(cast)mpif_attr_value(*$keyval, c_$parname);"]
end

function ensure_comm!(state, input_conversions)
    state.have_comm[] && return
    append!(input_conversions, ["const MPI_Comm q_comm = MPI_Comm_fromint(*comm);"])
    return state.have_comm[] = true
end

function ensure_comm_size!(state, input_conversions)
    state.have_comm_size[] && return
    ensure_comm!(state, input_conversions)
    append!(input_conversions,
            ["int q_comm_size;",
             "{",
             "  const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);",
             "  if (q_ierror != MPI_SUCCESS) {",
             "    *ierror = q_ierror;",
             "    return;",
             "  }",
             "}"])
    return state.have_comm_size[] = true
end

function ensure_comm_rank!(state, input_conversions)
    state.have_comm_rank[] && return
    ensure_comm!(state, input_conversions)
    append!(input_conversions,
            ["int q_comm_rank;",
             "{",
             "  const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);",
             "  if (q_ierror != MPI_SUCCESS) {",
             "    *ierror = q_ierror;",
             "    return;",
             "  }",
             "}"])
    return state.have_comm_rank[] = true
end

c_implementations = []
c_prototypes = []
f_interfaces = []
f08_implementations_useonly = []
f08_implementations_public = []
f08_generic_interfaces = []

# Base names that got a large-count `_c` companion, so that mpi_f08 can overload
# the two under the base name. MPI-4.0 added large counts "via separate
# additional MPI procedures in C (suffixed with `_c`) and via interface
# polymorphism in Fortran when using USE mpi_f08" -- so `MPI_Send` there has to
# accept an INTEGER(KIND=MPI_COUNT_KIND) count, not send the caller to a
# separate `MPI_Send_c`. Note the other half of that sentence: "No polymorphic
# support for larger types is provided in Fortran when using mpif.h and use
# mpi", which is why this list only feeds the f08 module.
f08_large_count_pairs = []

# The two the standard exempts, listing them as "the explicit Fortran procedures
# MPI_Op_create_c and MPI_Register_datarep_c". Both take a user callback whose
# large-count prototype differs from the small one, and, as the text puts it for
# MPI_Op_create, "interface polymorphism cannot be used to differentiate between
# the two different user callback prototypes despite their different type
# signatures".
f08_explicit_large_count = ["MPI_Op_create", "MPI_Register_datarep"]
f08_implementations_body = []

append!(c_implementations,
        ["#include <mpif_attrs.h>",
         "#include <mpif_callbacks.h>",
         "#include <mpif_logical.h>",
         "#include <mpif_strings.h>",
         "#include <mpi.h>",
         "#include <assert.h>",
         "#include <stdint.h>",
         "#include <stdlib.h>",
         "#include <string.h>",
         "",
         "// Avoid deleted MPI-1 functions",
         "",
         "#undef MPI_Attr_delete",
         "#undef MPI_Attr_get",
         "#undef MPI_Attr_put",
         "#undef MPI_Keyval_create",
         "#undef MPI_Keyval_free",
         "#define MPI_Attr_delete MPI_Comm_delete_attr",
         "#define MPI_Attr_get MPI_Comm_get_attr",
         "#define MPI_Attr_put MPI_Comm_set_attr",
         "#define MPI_Keyval_create MPI_Comm_create_keyval",
         "#define MPI_Keyval_free MPI_Comm_free_keyval",
])

append!(f_interfaces,
        ["module mpif_functions",
         "  implicit none",
         "  public",
         "  save",
         "",
         "  interface",
         ])

# A second set of interfaces to the C entry points, for the routines that take a
# status. They differ from the mpi module's only in spelling those eight integers
# TYPE(MPI_Status) rather than INTEGER(MPI_STATUS_SIZE), which is what lets the
# f08 wrappers pass the caller's own status to C instead of converting it into a
# temporary first. Two Fortran views of one C symbol, in two modules: legal,
# since a program uses `mpi` or `mpi_f08` and not both for the same call, and
# free on the C side, whose wrapper takes MPI_Fint* and casts it to MPI_Status*
# either way.
f08_raw_interfaces = ["module mpif_f08_raw",
                      "  use mpif_constants",
                      "  use mpif_f08_types, only: MPI_Status",
                      "  implicit none",
                      "  public",
                      "  save",
                      "",
                      "  interface",
                      ]
f08_raw_uses = []

append!(f08_implementations_useonly,
        ["module mpif_f08_functions",
         "  use mpi, only: &",
         ])
append!(f08_implementations_public,
        ["  implicit none",
         "  private",
         "  save",
         "",
         ])
append!(f08_implementations_body,
        ["",
         "contains",
         ])

for key in sort(collect(keys(apis)))
    api = apis[key]
    # key in ["mpi_init"] || continue

    name = api["name"]
    attributes = api["attributes"]
    parameters = api["parameters"]

    not_with_mpif = attributes["not_with_mpif"]
    not_with_mpif && continue
    f90_expressible = attributes["f90_expressible"]
    !f90_expressible && continue

    # Callbacks are just prototypes, not functions
    callback = attributes["callback"]
    # Predefined functions are constants
    predefined_function = attributes["predefined_function"]
    if callback || predefined_function != nothing
        continue
    end

    # Three kinds belong to callbacks and predefined functions alone, and the
    # answers recorded for them at the top of this file are the answers for a
    # callback: `C_BUFFER3` and `C_BUFFER4` are buffers rather than addresses, and
    # `ERROR_CODE_SHOW_INTENT` is an INTEGER whose displayed INTENT mpif does not
    # follow. Nothing generated reaches any of them, and this is where that is
    # checked -- an ordinary routine acquiring one would need those answers looked
    # at again, not applied quietly.
    for p in parameters
        @assert p["kind"] ∉ callback_only_kinds
    end

    # Varargs cannot be forwarded from Fortran, and the standard's Fortran
    # bindings do not have them either -- MPI_Pcontrol is the only function
    # concerned, and its Fortran binding takes just the level. Drop the varargs
    # rather than the whole function.
    parameters = filter(p -> p["kind"] != "VARARGS", parameters)

    # MPI_Sizeof needs to be implemented in Fortran
    name == "MPI_Sizeof" && continue

    need_embiggen = any(startswith(p["kind"], "POLY") for p in parameters)

    # `_c` is generated for the `POLY...` kinds and only those, which is why
    # MPI_Psend_init and MPI_Precv_init get one form and not two: their count is
    # `XFER_NUM_ELEM_NNI`, already a count, so there is nothing for a large form
    # to add. The ABI header declares an `MPI_Psend_init_c` all the same, which is
    # a bug in the header -- MPI-5.0 defines no such name, in any language -- so
    # nothing here may generate a wrapper for it or call it. Asserted rather than
    # left to be noticed, since the header makes it look as though it exists.
    @assert !(name ∈ ["MPI_Psend_init", "MPI_Precv_init"] && need_embiggen)

    # The routines that operate on an array of requests -- MPI_Waitall,
    # MPI_Waitsome and the rest -- report per-request results that the parameters
    # themselves do not say how to size or bound. Two names cover it: how many
    # requests there are, and how many entries MPI actually filled in, which for
    # the `some` routines is `outcount` and otherwise is all of them.
    #
    # `request_count` sizes the f08 status temporary and `reported_count` bounds
    # both the copy back out of it and the renumbering of the request indices
    # from C's zero-based to Fortran's one-based. `request_count` being set is
    # also the test for whether this routine deals in requests at all:
    # MPI_Graph_get's `index` has the same INDEX kind as MPI_Waitsome's and must
    # not be renumbered.
    request_count = nothing
    reported_count = nothing
    for p in parameters
        if p["kind"] == "REQUEST" && p["length"] != nothing
            request_count = p["length"]
        elseif p["kind"] == "ARRAY_LENGTH" && p["param_direction"] == "out"
            reported_count = p["name"]
        end
    end
    if reported_count == nothing
        reported_count = request_count
    end

    for embiggen in (need_embiggen ? [false, true] : [false])
        name_c = name * (embiggen ? "_c" : "")
        name_f = lowercase(name * (embiggen ? "_c" : "") * "_")
        f_name = name * (embiggen ? "_c" : "")
        f08_name = f_name
        f08_name_f = replace(f08_name, "MPI" => "MPIF")

        state = State()
        input_arguments = []
        final_input_arguments = []
        input_conversions = []
        call_arguments = []
        output_conversions = []
        f_arguments = []
        f_declarations = []
        # The same declarations as the mpi module's interface, except that a
        # status is TYPE(MPI_Status). See `mpif_f08_raw` below.
        f_raw_declarations = []
        has_status = false
        f08_arguments = []
        f08_declarations = []
        f08_call_temp_declarations = []
        f08_call_temp_copyins = []
        f08_call_arguments = []
        f08_call_temp_copyouts = []
        for parameter in parameters
            kind = parameter["kind"]
            length = parameter["length"]
            large_only = parameter["large_only"]
            optional = parameter["optional"]
            parname = parameter["name"]
            param_direction = parameter["param_direction"]
            root_only = parameter["root_only"]
            suppress = split(parameter["suppress"])

            # The f08 declaration follows the standard's own binding, which is
            # not always what the direction alone would give. `MPI_Cancel` is
            # the one place where the two part company; see below.
            f08_param_direction = param_direction
            cancel_request = name == "MPI_Cancel" && parname == "request"

            if "f90_parameter" ∉ suppress
                if !large_only || embiggen
                    push!(f_arguments, "$parname")
                    push!(f08_arguments, "$parname")

                    if optional
                        @assert param_direction == "out"
                        f_argname = "tmp_$parname"
                        if kind == "LOGICAL"
                            f_type = "logical"
                        elseif  kind == "ERROR_CODE"
                            f_type = "integer"
                        else
                            @show kind
                            @assert false
                        end
                        push!(f08_call_temp_declarations, "$f_type :: $f_argname")
                        push!(f08_call_temp_copyouts, "if (present($parname)) $parname = $f_argname")
                    else
                        f_argname = parname
                    end
                    if kind ∈ keys(kind2type)
                        if cancel_request
                            # A copy, because the C wrapper writes the handle
                            # back and `request` is INTENT(IN) here: a component
                            # of an INTENT(IN) dummy is not definable.
                            push!(f08_call_temp_declarations, "integer :: tmp_$f_argname")
                            push!(f08_call_temp_copyins, "tmp_$f_argname = $f_argname%MPI_VAL")
                            push!(f08_call_arguments, "tmp_$f_argname")
                        else
                            push!(f08_call_arguments, "$f_argname%MPI_VAL")
                        end
                    elseif kind ∈ cptr_out_kinds && param_direction == "out"
                        # The C wrapper writes the address into an address-sized
                        # integer; a TYPE(C_PTR) is the same bits, so `transfer`
                        # is the conversion. `C_BUFFER2`'s dummy in the mpi
                        # module's interface is a choice buffer rather than an
                        # integer, which `ignore_tkr` makes this temporary an
                        # acceptable actual argument for -- the C entry point
                        # writes an address through whatever it is handed.
                        push!(f08_call_temp_declarations, "integer(MPI_ADDRESS_KIND) :: tmp_$f_argname")
                        push!(f08_call_arguments, "tmp_$f_argname")
                        push!(f08_call_temp_copyouts, "$f_argname = transfer(tmp_$f_argname, C_NULL_PTR)")
                    elseif kind == "STATUS"
                        # Straight through: no temporary, no conversion, and no
                        # loc() to keep MPI_STATUS_IGNORE out of one. The
                        # sentinel is a TYPE(MPI_Status) at the C constant's
                        # address, so forwarding it hands C the pointer it
                        # already recognises.
                        push!(f08_call_arguments, "$f_argname")
                    else
                        push!(f08_call_arguments, "$f_argname")
                    end
                end
            end

            if kind ∈ ["BUFFER"; cptr_buffer_kinds; "LOGICAL_VOID"]
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert length == nothing
                @assert !optional
                @assert kind != "C_BUFFER2" || param_direction == "out"
                if param_direction == "in"
                    if name ∈ ["MPI_Buffer_attach", "MPI_Comm_attach_buffer", "MPI_Free_mem", "MPI_Precv_init",
                               "MPI_Session_attach_buffer", "MPI_Win_attach", "MPI_Win_create"]
                        # The buffer is declared as `in` argument, but this refers to the pointer (not the buffer data)
                        push!(input_arguments, "void* restrict const $parname")
                    else
                        push!(input_arguments, "const void* restrict const $parname")
                    end
                    if name == "MPI_Abi_set_fortran_booleans"
                        # `mpi.h` header file lacks const qualifiers
                        push!(call_arguments, "(void*)$parname")
                    else
                        push!(call_arguments, "$parname")
                    end
                elseif param_direction ∈ ["inout", "out"]
                    push!(input_arguments, "void* restrict const $parname")
                    push!(call_arguments, "$parname")
                else
                    @assert false
                end
                if kind == "LOGICAL_VOID"
                    # `void*` in C, but a plain LOGICAL in both Fortran
                    # bindings: MPI-5.0 gives `MPI_Abi_get_fortran_booleans` and
                    # `MPI_Abi_set_fortran_booleans` "LOGICAL, INTENT(OUT) ::
                    # logical_true, logical_false" in A.4.14 and "LOGICAL
                    # LOGICAL_TRUE, LOGICAL_FALSE" in A.5.14. These are the two
                    # routines by which Fortran and MPI agree on what a LOGICAL
                    # looks like, so a choice buffer would be the wrong shape
                    # for them -- the value really is one default LOGICAL.
                    push!(f_declarations, "logical :: $parname")
                    push!(f08_declarations, "logical, intent($f08_param_direction) :: $parname")
                elseif kind ∈ cptr_buffer_kinds
                    # A choice buffer in the mpi module and mpif.h, a TYPE(C_PTR)
                    # in mpi_f08. `C_BUFFER2` is `buffer_addr`, where the two
                    # bindings disagree and neither is an integer: A.5 gives
                    # `<type> BUFFER_ADDR(*)` and A.4 gives
                    # `TYPE(C_PTR), INTENT(OUT)`. One C entry point serves both,
                    # because it writes the detached address through the pointer
                    # Fortran hands it either way: the mpi module's caller gets it
                    # written into the variable it passed, and the f08 wrapper
                    # passes an address-sized temporary and converts it with
                    # `transfer` above.
                    #
                    # `C_BUFFER3` and `C_BUFFER4` are a callback's buffers, which
                    # A.1.3 declares `TYPE(C_PTR), VALUE`: there the address is
                    # the argument rather than something written through it, and
                    # by value it lands in the same register as the address of the
                    # assumed-size array A.5 asks for. Nothing generated reaches
                    # these two, callbacks being dropped above, which is asserted
                    # there rather than assumed here.
                    push!(f_declarations, "!dir\$ ignore_tkr(trk) $parname")
                    push!(f_declarations, "!gcc\$ attributes no_arg_check :: $parname")
                    push!(f_declarations, "integer :: $parname(*)")
                    f08_cptr = kind == "C_BUFFER2" ? "type(C_PTR), intent($f08_param_direction)" : "type(C_PTR), value"
                    push!(f08_declarations, "$f08_cptr :: $parname")
                else
                    push!(f_declarations, "!dir\$ ignore_tkr(trk) $parname")
                    push!(f_declarations, "!gcc\$ attributes no_arg_check :: $parname")
                    push!(f_declarations, "integer :: $parname(*)")
                    push!(f08_declarations, "!dir\$ ignore_tkr(tkr) $parname")
                    push!(f08_declarations, "!gcc\$ attributes no_arg_check :: $parname")
                    push!(f08_declarations, "integer :: $parname(*)")
                end
            elseif kind ∈ keys(kind2type)
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert !optional
                if cancel_request
                    @assert kind == "REQUEST"
                    @assert param_direction == "in"
                    # `MPI_Cancel` takes `MPI_Request*` in C, so the C wrapper
                    # needs the inout treatment -- a temporary, converted in and
                    # written back. That is a property of the C entry point and
                    # not of the argument: MPI_Cancel marks a request, it does
                    # not replace the handle, and MPI-5.0 A.4.1 accordingly
                    # gives the f08 binding "TYPE(MPI_Request), INTENT(IN) ::
                    # request". `f08_param_direction` stays `in` so that a
                    # caller may pass a request it holds INTENT(IN) itself.
                    param_direction = "inout"
                end
                if param_direction == "in"
                    if length == nothing
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        if root_only
                            ensure_comm_rank!(state, input_conversions)
                            push!(call_arguments,
                                  "q_comm_rank == 0 ? MPI_$(kind2fun[kind])_fromint(*$parname) : MPI_$(kind2null[kind])_NULL")
                        else
                            push!(call_arguments, "MPI_$(kind2fun[kind])_fromint(*$parname)")
                        end
                    elseif length == "*"
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        ensure_comm_size!(state, input_conversions)
                        push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[q_comm_size];")
                        if root_only
                            ensure_comm_rank!(state, input_conversions)
                            append!(input_conversions,
                                    ["if (q_comm_rank == 0)",
                                     "  for (int rank=0; rank<q_comm_size; ++rank)",
                                     "    c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);"])
                        else
                            append!(input_conversions,
                                    ["for (int rank=0; rank<q_comm_size; ++rank)",
                                     "  c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);"])
                        end
                        push!(call_arguments, "c_$parname")
                    elseif length ∈ ["count", "incount"]
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[*$length];")
                        if root_only
                            ensure_comm_rank!(state, input_conversions)
                            append!(input_conversions,
                                    ["if (q_comm_rank == 0)",
                                     "  for (int rank=0; rank<*$length; ++rank)",
                                     "    c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);"])
                        else
                            append!(input_conversions,
                                    ["for (int rank=0; rank<*$length; ++rank)",
                                     "  c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);"])
                        end
                        push!(call_arguments, "c_$parname")
                    else
                        @show name parname length
                        @assert false
                    end
                elseif param_direction ∈ ["out", "inout"]
                    @assert !root_only
                    push!(input_arguments, "MPI_Fint* restrict const $parname")
                    if length == nothing
                        if param_direction == "inout"
                            push!(input_conversions,
                                  "MPI_$(kind2type[kind]) c_$parname = MPI_$(kind2fun[kind])_fromint(*$parname);")
                        else
                            push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname;")
                        end
                        push!(call_arguments, "&c_$(parname)")
                        push!(output_conversions,
                              "*$parname = MPI_$(kind2fun[kind])_toint(c_$parname);")
                    else
                        # An array of handles, which needs an array of
                        # temporaries. A scalar temporary would be catastrophic
                        # rather than merely wrong: MPI writes through the whole
                        # array -- MPI_Waitall sets every request to
                        # MPI_REQUEST_NULL -- and so would write past the
                        # temporary and into this function's frame.
                        @assert length ∈ ["*", "count", "incount", "max_datatypes", "num_elements"]
                        if length == "*"
                            ensure_comm_size!(state, input_conversions)
                            count = "q_comm_size"
                        else
                            count = "*$length"
                        end
                        push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[$count];")
                        if param_direction == "inout"
                            append!(input_conversions,
                                    ["for (int i=0; i<$count; ++i)",
                                     "  c_$parname[i] = MPI_$(kind2fun[kind])_fromint($parname[i]);"])
                        end
                        push!(call_arguments, "c_$parname")
                        # Every element is converted back, not just the ones MPI
                        # changed: for MPI_Waitany the rest round-trip unchanged.
                        append!(output_conversions,
                                ["for (int i=0; i<$count; ++i)",
                                 "  $parname[i] = MPI_$(kind2fun[kind])_toint(c_$parname[i]);"])
                    end
                else
                    @assert false
                end
                f_length = length == nothing ? "" : "($length)"
                push!(f_declarations, "integer :: $parname$f_length")
                push!(f08_declarations, "type(MPI_$(kind2type[kind])), intent($f08_param_direction) :: $parname$f_length")
            elseif kind == "STATUS"
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert !optional
                @assert !root_only
                if param_direction == "in"
                    @assert length == nothing
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    push!(call_arguments, "(const MPI_Status*)$parname")
                elseif param_direction ∈ ["inout", "out"]
                    @assert length == nothing || length == "*"
                    push!(input_arguments, "MPI_Fint* restrict const $parname")
                    push!(call_arguments, "(MPI_Status*)$parname")
                else
                    @show name parname param_direction
                    @assert false
                end
                # No INTENT on a status MPI fills in, which is what the
                # standard's own binding says: "TYPE(MPI_Status) :: status", and
                # "TYPE(MPI_Status) :: array_of_statuses(*)". INTENT(IN) and
                # INTENT(INOUT) it does give, to the query and set routines, so
                # only the `out` direction loses its intent here.
                #
                # INTENT(OUT) is not a harmless embellishment. It tells the
                # compiler the incoming value is dead, and a caller that sets
                # status%MPI_ERROR before the call -- which is exactly what the
                # standard lets it do, MPI not being allowed to touch that field
                # -- has that store deleted at -O2. MPICH's mprobef08 does it and
                # failed on it; at -O0 the same program passes, which is why
                # mpif's own tests did not catch this.
                f08_status_intent = param_direction == "out" ? "" : ", intent($param_direction)"
                if length == nothing
                    push!(f_declarations, "integer :: $parname(MPI_STATUS_SIZE)")
                    push!(f08_declarations, "type(MPI_Status)$f08_status_intent :: $parname")
                else
                    # An array of statuses, whose length is the caller's to know:
                    # assumed-size in both interfaces. Declaring it as a scalar
                    # made the six routines that take one unusable from mpi_f08,
                    # where passing the array the standard asks for is a compile
                    # error -- "Rank mismatch in argument 'array_of_statuses'
                    # (scalar and rank-1)".
                    @assert length == "*"
                    push!(f_declarations, "integer :: $parname(MPI_STATUS_SIZE, *)")
                    push!(f08_declarations, "type(MPI_Status)$f08_status_intent :: $parname(*)")
                end
            elseif kind in [int_kinds; int_aint_kinds; int_count_kinds; aint_kinds; aint_count_kinds; count_kinds]
                if kind in int_kinds || (!embiggen && kind in int_aint_kinds) || (!embiggen && kind in int_count_kinds)
                    type = "MPI_Fint"
                    f_type = "integer"
                elseif kind in aint_kinds || (!embiggen && kind in aint_count_kinds) || (embiggen && kind in int_aint_kinds)
                    type = "MPI_Aint"
                    f_type = "integer(MPI_ADDRESS_KIND)"
                elseif kind in count_kinds || (embiggen && kind in int_count_kinds) || (embiggen && kind in aint_count_kinds)
                    type = "MPI_Count"
                    f_type = "integer(MPI_COUNT_KIND)"
                else
                    @assert false
                end

                if !large_only || embiggen
                    if name == "MPI_Info_create_env" && parname == "argc"
                        @assert param_direction == "inout"
                        # `MPI_Info_create_env` does not modify the argument count
                        param_direction = "in"
                    end
                    if param_direction == "in"
                        @assert !optional
                        @assert "c_parameter" ∉ suppress
                        if length == nothing
                            if "f90_parameter" ∉ suppress
                                push!(input_arguments, "const $type* restrict const $parname")
                                push!(call_arguments, "*$parname")
                            else
                                push!(call_arguments, "0")
                            end
                        elseif length ∈ ["*", "count", "n", "ndims", "indegree", "length", "nnodes", "outdegree"]
                            @assert "f90_parameter" ∉ suppress
                            push!(input_arguments, "const $type* restrict const $parname")
                            push!(call_arguments, "$parname")
                        elseif length ∈ [["n", "3"]]
                            @assert "f90_parameter" ∉ suppress
                            push!(input_arguments, "const $type(* restrict const $parname)[3]")
                            if name ∈ ["MPI_Group_range_excl", "MPI_Group_range_incl"]
                                # `mpi.h` header file lacks const qualifiers
                                push!(call_arguments, "($type(*)[3])$parname")
                            else
                                push!(call_arguments, "$parname")
                            end
                        else
                            @show name parname length
                            @assert false
                        end
                    elseif param_direction ∈ ["inout", "out"]
                        @assert length == nothing ||
                                length ∈ ["", "*", "max_addresses", "max_datatypes", "max_integers", "max_large_counts", "maxdims",
                                          "maxedges", "maxindegree", "maxindex", "maxneighbors", "maxoutdegree", "n", "ndims"]
                        if "f90_parameter" ∉ suppress
                            push!(input_arguments, "$type* restrict const $parname")
                            if "c_parameter" ∉ suppress
                                @assert !optional
                                if name == "MPI_Info_get_string" && parname == "buflen"
                                    # `buflen` describes the caller's `value`, and cannot
                                    # be passed straight through: in Fortran it counts
                                    # characters, in C it counts characters plus the
                                    # terminating NUL. It also has to be clamped. A
                                    # Fortran caller may pass a `buflen` larger than
                                    # `len(value)` -- MPICH's own test suite does, in
                                    # f90/info/infogetstrf90.f90 -- and MPI would then
                                    # write past the end of the buffer we hand it.
                                    # `length_value` is the hidden length argument for
                                    # `value`, and `c_value` is one byte longer than that.
                                    append!(input_conversions,
                                            ["const MPI_Fint f_$parname = *$parname;",
                                             "int c_$parname = 0;",
                                             "if (f_$parname > 0)",
                                             "  c_$parname = (size_t)f_$parname <= length_value",
                                             "                  ? (int)f_$parname + 1",
                                             "                  : (int)length_value + 1;"])
                                    push!(call_arguments, "&c_$parname")
                                    # MPI reports the length it needs including the NUL,
                                    # Fortran wants it without. MPI leaves `buflen` alone
                                    # when the key does not exist, and so must we: after
                                    # the clamp above the value we hold is not necessarily
                                    # the one the caller passed in.
                                    append!(output_conversions,
                                            ["if (c_flag)",
                                             "  *$parname = c_$parname > 0 ? (MPI_Fint)(c_$parname - 1) : 0;"])
                                elseif kind == "INDEX" && request_count != nothing
                                    # An index into the array of requests. C
                                    # numbers those from zero and Fortran from
                                    # one -- MPI-5.0 says so for each of these
                                    # routines, "in the range 0...count-1 in C,
                                    # and in the range 1...count in Fortran" --
                                    # so the value cannot be passed through.
                                    #
                                    # The INDEX kind alone does not mean this:
                                    # MPI_Graph_get's `index` and
                                    # MPI_Cart_shift's `direction` carry it too
                                    # and are numbered alike in both languages.
                                    # Taking an array of requests is what these
                                    # have in common, which is what
                                    # `request_count` records.
                                    @assert length == nothing || length == "*"
                                    push!(call_arguments, "$parname")
                                    if length == nothing
                                        # MPI_UNDEFINED means no request
                                        # completed, and is not an index
                                        append!(output_conversions,
                                                ["if (*$parname >= 0)",
                                                 "  ++*$parname;"])
                                    else
                                        # Only the entries MPI reported are its
                                        # to renumber. MPI_UNDEFINED is negative
                                        # here, so a call that completed nothing
                                        # renumbers nothing; the bound is also
                                        # clamped to the number of requests, so
                                        # that an `outcount` left unset by a
                                        # failed call cannot turn this into a
                                        # wild write.
                                        append!(output_conversions,
                                                ["const int count = *$reported_count < *$request_count",
                                                 "                      ? *$reported_count",
                                                 "                      : *$request_count;",
                                                 "for (int i=0; i<count; ++i)",
                                                 "  ++$parname[i];"])
                                    end
                                else
                                    push!(call_arguments, "$parname")
                                end
                            end
                        else
                            @assert !optional
                            @assert "c_parameter" ∉ suppress
                            push!(call_arguments, "NULL")
                        end
                    else
                        @assert false
                    end
                    f_intent = "f08_intent" ∉ suppress ? ", intent($param_direction)" : ""
                    f_optional = optional ? ", optional" : ""
                    if length == nothing
                        f_length = ""
                    elseif length == ""
                        f_length = "(*)"
                    elseif length == ["n", "3"]
                        f_length = "(3, n)"
                    else
                        f_length = "($length)"
                    end
                    if "f90_parameter" ∉ suppress
                        push!(f_declarations, "$f_type :: $parname$f_length")
                    end
                    if "f08_parameter" ∉ suppress
                        # mpi_f08 has only the TYPE(C_PTR) form of the base
                        # address that MPI_Alloc_mem and the window allocators
                        # hand back; the INTEGER(KIND=MPI_ADDRESS_KIND) one is the
                        # mpi module's and mpif.h's, where it is paired with a
                        # TYPE(C_PTR) overload (see src/mpif_cptr.F90).
                        f08_type = kind == "C_BUFFER" && param_direction == "out" ? "type(C_PTR)" : f_type
                        push!(f08_declarations, "$f08_type$f_intent$f_optional :: $parname$f_length")
                    end
                end
            elseif kind in ["ATTRIBUTE_VAL_10", "EXTRA_STATE2"]
                @assert "f90_parameter" ∉ suppress
                @assert "c_parameter" ∉ suppress
                @assert !large_only
                @assert length == nothing
                @assert !optional
                @assert !root_only
                # This is an integer in Fortran but a pointer in C
                if param_direction == "in"
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    push!(call_arguments, "(void*)(intptr_t)*$parname")
                elseif param_direction ∈ ["inout", "out"]
                    push!(input_arguments, "MPI_Fint* restrict const $parname")
                    push!(input_conversions, "void *c_$parname;")
                    # `&`: MPI takes a void** here, and passing the value of an
                    # uninitialised pointer had it writing through whatever that
                    # happened to be
                    push!(call_arguments, "&c_$parname")
                    # `only` rather than a length check: `length` is shadowed
                    # here by the parameter's own length field
                    keyval = only(p["name"] for p in parameters if p["kind"] == "KEYVAL")
                    append!(output_conversions,
                            attr_value_conversion(parameters, parname, keyval, "(MPI_Fint)"))
                else
                    @assert false
                end
                push!(f_declarations, "integer :: $parname")
                push!(f08_declarations, "integer, intent($param_direction) :: $parname")
            elseif kind in ["ATTRIBUTE_VAL", "EXTRA_STATE"]
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert length == nothing
                @assert !optional
                @assert !root_only
                if param_direction == "in"
                    if name ∈ ["MPI_Grequest_start", "MPI_Register_datarep", "MPI_Register_datarep_c"]
                        # MPI carries mpif's box here rather than the caller's
                        # value, so that the trampolines can find the Fortran
                        # procedures. The caller's value is copied into the box,
                        # which is what the standard describes -- `extra_state`
                        # is IN, and the callbacks are passed the argument that
                        # was registered rather than the variable it came from.
                        push!(input_arguments, "const MPI_Aint* restrict const $parname")
                        push!(call_arguments, "box")
                    else
                        push!(input_arguments, "const MPI_Aint* restrict const $parname")
                        push!(call_arguments, "(void*)*$parname")
                    end
                elseif param_direction == "out"
                    push!(input_arguments, "MPI_Aint* restrict const $parname")
                    push!(input_conversions, "void *c_$parname;")
                    push!(call_arguments, "&c_$parname")
                    keyval = only(p["name"] for p in parameters if p["kind"] == "KEYVAL")
                    append!(output_conversions,
                            attr_value_conversion(parameters, parname, keyval, ""))
                else
                    @assert false
                end
                # Address-sized, matching the MPI_Aint the C side uses. A plain
                # `integer` here would have C writing eight bytes into a
                # four-byte variable.
                push!(f_declarations, "integer(MPI_ADDRESS_KIND) :: $parname")
                push!(f08_declarations, "integer(MPI_ADDRESS_KIND), intent($param_direction) :: $parname")
            elseif kind in ["OFFSET"]
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert length == nothing
                @assert !optional
                @assert !root_only
                if param_direction == "in"
                    push!(input_arguments, "const MPI_Offset* restrict const $parname")
                    push!(call_arguments, "*$parname")
                elseif param_direction ∈ ["inout", "out"]
                    push!(input_arguments, "MPI_Offset* restrict const $parname")
                    push!(call_arguments, "$parname")
                else
                    @assert false
                end
                f_length = length == nothing ? "" : length == "" ? "(*)" : "ERROR"
                push!(f_declarations, "integer(MPI_OFFSET_KIND) :: $parname$f_length")
                push!(f08_declarations, "integer(MPI_OFFSET_KIND), intent($param_direction) :: $parname$f_length")
            elseif kind == "LOGICAL"
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert !optional
                @assert !root_only
                if param_direction == "in"
                    if length == nothing
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        push!(call_arguments, "mpif_logical2bool(*$parname)")
                    elseif length == "ndims"
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        append!(input_conversions,
                                ["int c_$parname[*ndims];",
                                 "for (int dim=0; dim<*ndims; ++dim)",
                                 "  c_$parname[dim] = mpif_logical2bool($parname[dim]);"])
                        push!(call_arguments, "c_$parname")
                    elseif name == "MPI_Cart_sub" && length == "*"
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        ensure_comm!(state, input_conversions)
                        append!(input_conversions,
                                ["int ndims;",
                                 "{",
                                 "  const int q_ierror = MPI_Cartdim_get(q_comm, &ndims);",
                                 "  if (q_ierror != MPI_SUCCESS) {",
                                 "    *ierror = q_ierror;",
                                 "    return;",
                                 "  }",
                                 "}",
                                 "int c_$parname[ndims];",
                                 "for (int dim=0; dim<ndims; ++dim)",
                                 "  c_$parname[dim] = mpif_logical2bool($parname[dim]);"])
                        push!(call_arguments, "c_$parname")
                    else
                        @show name length
                        @assert false
                    end
                elseif param_direction ∈ ["inout", "out"]
                    if length == nothing
                        push!(input_arguments, "MPI_Fint* restrict const $parname")
                        push!(input_conversions, "MPI_Fint c_$parname;")
                        push!(call_arguments, "&c_$parname")
                        push!(output_conversions, "*$parname = mpif_bool2logical(c_$parname);")
                    elseif length == "maxdims"
                        push!(input_arguments, "MPI_Fint* restrict const $parname")
                        append!(input_conversions, ["int c_$parname[*maxdims];"])
                        push!(call_arguments, "c_$parname")
                        append!(output_conversions,
                                ["for (int dim=0; dim<*maxdims; ++dim)",
                                 "  $parname[dim] = mpif_bool2logical(c_$parname[dim]);"])
                    else
                        @show name length
                        @assert false
                    end
                else
                    @assert false
                end
                f_length = length == nothing ? "" : "(*)"
                push!(f_declarations, "logical :: $parname$f_length")
                push!(f08_declarations, "logical, intent($param_direction) :: $parname$f_length")
            elseif kind ∈ ["ARGUMENT_LIST", "STRING"]
                @assert "c_parameter" ∉ suppress
                @assert !large_only
                @assert !optional
                if name == "MPI_Info_create_env" && parname == "argv"
                    @assert param_direction == "inout"
                    # `MPI_Info_create_env` does not modify the argument count
                    param_direction = "in"
                end
                if name ∈ ["MPI_Pack_external", "MPI_Pack_external_size", "MPI_Unpack_external"] && parname == "datarep"
                    @assert length == "*"
                    # `MPI_Pack_external` accepts a scalar `datarep` argument
                    length = nothing
                end
                if param_direction == "in"
                    if "f90_parameter" ∉ suppress
                        push!(input_arguments, "const char* restrict const $parname")
                        if length == nothing
                            push!(final_input_arguments, "const size_t length_$parname")
                        elseif length == "MPI_MAX_OBJECT_NAME"
                            push!(input_conversions, "const size_t length_$parname = MPI_MAX_OBJECT_NAME;")
                        else
                            @show name parname length
                            @assert false
                        end
                        strdup_f2c = (name, parname) ∈ strip_leading_blanks ? "mpif_strdup_f2c_trim" : "mpif_strdup_f2c"
                        if root_only
                            ensure_comm_rank!(state, input_conversions)
                            append!(input_conversions,
                                    ["char* c_$parname = NULL;",
                                     "if (q_comm_rank == 0)",
                                     "  c_$parname = $strdup_f2c($parname, length_$parname);"])
                            append!(output_conversions, ["if (q_comm_rank == 0)",
                                                         "  free(c_$parname);"])
                        else
                            push!(input_conversions, "char* const c_$parname = $strdup_f2c($parname, length_$parname);")
                            push!(output_conversions, "free(c_$parname);")
                        end
                        push!(call_arguments, "c_$parname")
                    else
                        push!(call_arguments, "NULL")
                    end
                elseif param_direction == "out"
                    @assert "f90_parameter" ∉ suppress
                    @assert !root_only
                    push!(input_arguments, "char* restrict const $parname")
                    # Two different lengths, and conflating them overruns the
                    # caller's string. `buflen` is how much room MPI needs to
                    # write its answer. `length` is how long the caller's
                    # CHARACTER is, which is what the result must be padded or
                    # truncated to.
                    if length == nothing
                        # The Fortran binding is CHARACTER*(*), so Fortran passes
                        # the length as a hidden trailing argument, and the
                        # caller's string is all we have to size the buffer with
                        push!(final_input_arguments, "const size_t length_$parname")
                        push!(input_conversions, "const size_t buflen_$parname = length_$parname;")
                    elseif length ∈
                           ["MPI_MAX_ERROR_STRING", "MPI_MAX_LIBRARY_VERSION_STRING", "MPI_MAX_OBJECT_NAME", "MPI_MAX_PORT_NAME",
                            "MPI_MAX_PROCESSOR_NAME"]
                        # The binding fixes the length -- CHARACTER*($length) --
                        # so the caller must supply exactly that and no hidden
                        # argument is needed. Note the minus one: the Fortran
                        # constant is one less than the C one, a Fortran
                        # CHARACTER having no room for a terminating NUL, so
                        # padding to the C value writes a byte past the caller's
                        # string.
                        push!(input_conversions, "const size_t buflen_$parname = $length;")
                        push!(input_conversions, "const size_t length_$parname = $length - 1;")
                    elseif length ∈ ["valuelen"]
                        push!(input_conversions, "const size_t buflen_$parname = *$length;")
                        push!(input_conversions, "const size_t length_$parname = *$length;")
                    else
                        @show name parname length
                        @assert false
                    end
                    push!(input_conversions, "char c_$parname[buflen_$parname + 1];")
                    push!(call_arguments, "c_$parname")
                    # Pad or truncate to the caller's length, never to buflen
                    copy_c2f = "mpif_strcpy_c2f($parname, c_$parname, length_$parname, strlen(c_$parname));"
                    # The only two routines whose string output is conditional. Both
                    # write nothing at all when the key does not exist -- MPI_INFO_GET
                    # "sets flag to false and leaves value unchanged" -- and
                    # MPI_INFO_GET_STRING additionally writes nothing when `buflen` is
                    # zero. The caller's string has to be left untouched in those
                    # cases: `c_value` is still uninitialised, so copying it out would
                    # hand back garbage, and `strlen` would read uninitialised memory to
                    # decide how much of it.
                    if name ∈ ["MPI_Info_get", "MPI_Info_get_string"] && parname == "value"
                        guard = name == "MPI_Info_get_string" ? "c_flag && f_buflen > 0" : "c_flag"
                        append!(output_conversions, ["if ($guard)", "  $copy_c2f"])
                    else
                        push!(output_conversions, copy_c2f)
                    end
                elseif param_direction == "inout"
                    @assert "f90_parameter" ∈ suppress
                    push!(call_arguments, "NULL")
                else
                    @assert false
                end
                if "f90_parameter" ∉ suppress
                    f_length = length == nothing ? "*" : "$length"
                    push!(f_declarations, "character*($f_length) :: $parname")
                    push!(f08_declarations, "character*($f_length), intent($param_direction) :: $parname")
                end
            elseif kind ∈ ["STRING_ARRAY"]
                @assert "c_parameter" ∉ suppress
                @assert !large_only
                @assert length == nothing
                @assert !optional
                @assert root_only
                @assert param_direction == "in"
                if "f90_parameter" ∉ suppress
                    push!(input_arguments, "const char* restrict const $parname")
                    push!(final_input_arguments, "const size_t length_$parname")
                    ensure_comm_rank!(state, input_conversions)
                    strdup_f2c = (name, parname) ∈ strip_leading_blanks ? "mpif_strdup_f2c_trim" : "mpif_strdup_f2c"
                    sentinel = get(argv_null_sentinels, (name, parname), nothing)
                    guard = sentinel == nothing ? "q_comm_rank == 0" : "q_comm_rank == 0 && !null_$parname"
                    if sentinel != nothing
                        push!(input_conversions,
                              "const int null_$parname = (const void*)$parname == (const void*)$sentinel;")
                    end
                    counted = get(string_array_counts, (name, parname), nothing)
                    if counted == nothing
                        append!(input_conversions,
                                ["size_t count_$parname = 0;",
                                 "if ($guard)",
                                 "  count_$parname = mpif_fcount($parname, length_$parname);"])
                    else
                        # Still zero away from the root, where the array is not
                        # significant and must not be read
                        push!(input_conversions,
                              "const size_t count_$parname = $guard ? (size_t)$counted : 0;")
                    end
                    append!(input_conversions,
                            ["char *argv_$parname[count_$parname + 1];",
                             "for (size_t n=0; n<count_$parname; ++n)",
                             "  argv_$parname[n] = $strdup_f2c($parname + n * length_$parname, length_$parname);",
                             "argv_$parname[count_$parname] = NULL;"])
                    push!(call_arguments,
                          sentinel == nothing ? "argv_$parname" : "null_$parname ? $sentinel : argv_$parname")
                    append!(output_conversions, ["for (size_t n=0; n<count_$parname; ++n)",
                                                 "  free(argv_$parname[n]);"])
                else
                    push!(call_arguments, "NULL")
                end
                if "f90_parameter" ∉ suppress
                    push!(f_declarations, "character*(*) :: $parname(*)")
                end
                if "f08_parameter" ∉ suppress
                    push!(f08_declarations, "character*(*), intent($param_direction) :: $parname(*)")
                end
            elseif kind == "STRING_2DARRAY"
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert length == "count"
                @assert !optional
                @assert root_only
                @assert param_direction == "in"
                push!(input_arguments, "const char* restrict const $parname")
                push!(final_input_arguments, "const size_t length_$parname")
                ensure_comm_rank!(state, input_conversions)
                strdup_f2c = (name, parname) ∈ strip_leading_blanks ? "mpif_strdup_f2c_trim" : "mpif_strdup_f2c"
                sentinel = get(argv_null_sentinels, (name, parname), nothing)
                guard = sentinel == nothing ? "q_comm_rank == 0" : "q_comm_rank == 0 && !null_$parname"
                if sentinel != nothing
                    push!(input_conversions,
                          "const int null_$parname = (const void*)$parname == (const void*)$sentinel;")
                end
                append!(input_conversions,
                        ["size_t count_$parname[*count];",
                         "char **argv_$parname[*count];",
                         "for (int i=0; i<*count; ++i) {",
                         "  if ($guard) {",
                         "    count_$parname[i] = mpif_fcount2d($parname, *count, i, length_$parname);",
                         "    argv_$parname[i] = malloc((count_$parname[i] + 1) * sizeof(char*));",
                         "    for (size_t n=0; n<count_$parname[i]; ++n)",
                         "      argv_$parname[i][n] = $strdup_f2c($parname + i * length_$parname + n * *count * length_$parname, length_$parname);",
                         "    argv_$parname[i][count_$parname[i]] = NULL;",
                         "  } else {",
                         "    count_$parname[i] = 0;",
                         "    argv_$parname[i] = NULL;",
                         "  }",
                         "}"])
                push!(call_arguments,
                      sentinel == nothing ? "argv_$parname" : "null_$parname ? $sentinel : argv_$parname")
                append!(output_conversions,
                        ["for (int i=0; i<*count; ++i) {",
                         "  for (size_t n=0; n<count_$parname[i]; ++n)",
                         "    free(argv_$parname[i][n]);",
                         "}"])
                push!(f_declarations, "character*(*) :: $parname($length, *)")
                push!(f08_declarations, "character*(*), intent($param_direction) :: $parname($length, *)")
            elseif kind ∈ ["FUNCTION", "POLYFUNCTION"]
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert length == nothing
                @assert !optional
                @assert !root_only
                @assert param_direction == "in"
                # TODO: Check properly whether the function parameter needs embiggening
                embiggen_func = embiggen && parameter["func_type"] ∉ ["MPI_Datarep_extent_function"]
                func_type = parameter["func_type"] * (embiggen_func ? "_c" : "")
                push!(input_arguments, "$func_type* const $parname")
                if func_type ∈ keys(attr_callback_kinds)
                    # Predefined callbacks become the ABI's sentinel; a
                    # user-defined procedure becomes a trampoline, which finds
                    # it again through the keyval registered below.
                    attr_kind = attr_callback_kinds[func_type]
                    append!(input_conversions,
                            ["void *c_$parname;",
                             "if (!mpif_predefined_callback((mpif_fortran_procedure)$parname, &c_$parname))",
                             "  c_$parname = mpif_attr_trampoline($attr_kind);"])
                    push!(call_arguments, "($func_type*)c_$parname")
                    # Only once MPI has produced the keyval to register against
                    keyval = only(p["name"] for p in parameters if p["kind"] == "KEYVAL")
                    append!(output_conversions,
                            ["if (*ierror == MPI_SUCCESS)",
                             "  *ierror = mpif_register_attr_callback(*$keyval, $attr_kind, (mpif_fortran_procedure)$parname);"])
                elseif func_type ∈ ["MPI_User_function", "MPI_User_function_c"]
                    # A reduction callback is told nothing about which operator
                    # is being applied, so it cannot be looked up when it fires.
                    # Take a slot from the pool of trampolines instead, each of
                    # which knows its own slot. The slot is occupied for good;
                    # see include/mpif_callbacks.h for why MPI_Op_free cannot
                    # give it back.
                    large = func_type == "MPI_User_function_c" ? 1 : 0
                    op = only(p["name"] for p in parameters if p["kind"] == "OPERATION")
                    # Set the handle even though the call failed. MPI leaves
                    # output arguments undefined on error, but a program that
                    # ignores ierror would then pass uninitialised memory to the
                    # next reduction; MPI_OP_NULL at least fails predictably,
                    # and at the point where the mistake is visible.
                    append!(input_conversions,
                            ["int slot_$parname;",
                             "void *const c_$parname = mpif_op_reserve((mpif_fortran_procedure)$parname, $large, &slot_$parname);",
                             "if (!c_$parname) {",
                             "  *$op = MPI_Op_toint(MPI_OP_NULL);",
                             "  *ierror = MPI_ERR_OTHER;",
                             "  return;",
                             "}"])
                    push!(call_arguments, "($func_type*)c_$parname")
                    append!(output_conversions,
                            ["if (*ierror != MPI_SUCCESS)",
                             "  mpif_op_cancel(slot_$parname);"])
                elseif func_type ∈ ["MPI_Comm_errhandler_function",
                                    "MPI_Win_errhandler_function",
                                    "MPI_File_errhandler_function",
                                    "MPI_Session_errhandler_function"]
                    # An error handler is told which object raised the error but
                    # not which handler is running, so, as for reduction
                    # operators, it needs a trampoline that knows its own slot.
                    # The slot is occupied for good: MPI_Errhandler_free only
                    # marks the handler for deallocation and it stays attached to
                    # its objects, so there is no point at which releasing is
                    # safe.
                    errhandler_kind = uppercase(split(func_type, "_")[2])
                    append!(input_conversions,
                            ["int slot_$parname;",
                             "void *const c_$parname = mpif_errhandler_reserve((mpif_fortran_procedure)$parname, MPIF_ERRHANDLER_$errhandler_kind, &slot_$parname);",
                             "if (!c_$parname) {",
                             "  *ierror = MPI_ERR_OTHER;",
                             "  return;",
                             "}"])
                    push!(call_arguments, "($func_type*)c_$parname")
                    append!(output_conversions,
                            ["if (*ierror != MPI_SUCCESS)",
                             "  mpif_errhandler_cancel(slot_$parname);"])
                elseif func_type ∈ keys(grequest_trampolines)
                    # A generalized request's callbacks are told nothing that
                    # says which request is being served, as for reduction
                    # operators -- but here `extra_state` is mpif's to choose, so
                    # a box carrying the three Fortran procedures goes in its
                    # place and one trampoline per callback is enough. No pool
                    # and no limit: the box belongs to one request, and the free
                    # callback releases it.
                    #
                    # The box is emitted once, with the first of the three, since
                    # the three procedures and the box are one unit. All three
                    # are parameters of this wrapper, so naming them here is
                    # fine, and `extra_state` is a later parameter that picks the
                    # box up from `call_arguments`.
                    if func_type == "MPI_Grequest_query_function"
                        fns = [p["name"] for p in parameters if p["kind"] == "FUNCTION"]
                        extra_state = only(p["name"] for p in parameters if p["kind"] == "EXTRA_STATE")
                        procedures = join(["(mpif_fortran_procedure)$f" for f in fns], ", ")
                        append!(input_conversions,
                                ["void *const box = mpif_grequest_reserve($procedures, *$extra_state);",
                                 "if (!box) {",
                                 "  *ierror = MPI_ERR_OTHER;",
                                 "  return;",
                                 "}"])
                        append!(output_conversions,
                                ["if (*ierror != MPI_SUCCESS)",
                                 "  mpif_grequest_cancel(box);"])
                    end
                    push!(call_arguments, grequest_trampolines[func_type])
                elseif func_type ∈ datarep_func_types
                    # The generalized request route again: `extra_state` is
                    # mpif's to choose, so a box carrying the three Fortran
                    # procedures goes in its place and one trampoline apiece
                    # finds them. The box is emitted once, with the first of the
                    # three, since the procedures and the box are one unit.
                    #
                    # The differences from a generalized request are in
                    # src/mpif_callbacks.c: the box is never freed, a datarep
                    # being registered for the duration of the program, and
                    # `extra_state` is copied into it rather than aliased.
                    if parname == "read_conversion_fn"
                        fns = [p["name"] for p in parameters if p["kind"] ∈ ["FUNCTION", "POLYFUNCTION"]]
                        extra_state = only(p["name"] for p in parameters if p["kind"] == "EXTRA_STATE")
                        procedures = join(["(mpif_fortran_procedure)$f" for f in fns], ", ")
                        append!(input_conversions,
                                ["void *const box = mpif_datarep_reserve($procedures, *$extra_state);",
                                 "if (!box) {",
                                 "  *ierror = MPI_ERR_OTHER;",
                                 "  return;",
                                 "}"])
                        append!(output_conversions,
                                ["if (*ierror != MPI_SUCCESS)",
                                 "  mpif_datarep_cancel(box);"])
                    end
                    # MPI_CONVERSION_FN_NULL has to reach MPI as the sentinel it
                    # is rather than as a trampoline: the standard gives it the
                    # meaning "no conversion is needed", which only MPI can act
                    # on. Anything else is user-defined and gets the trampoline.
                    trampoline = datarep_trampolines[parname]
                    embiggened = endswith(func_type, "_c")
                    append!(input_conversions,
                            ["void *c_$parname;",
                             "if (!mpif_predefined_callback((mpif_fortran_procedure)$parname, &c_$parname))",
                             "  c_$parname = (void*)$(embiggened ? trampoline * "_c" : trampoline);"])
                    push!(call_arguments, "($func_type*)c_$parname")
                else
                    # Nothing reaches this any more: every callback family in
                    # `apis.json` is handled above, and `mpif_unsupported_callback`
                    # appears nowhere in the generated output. It stays as the
                    # landing place for a callback type a later version of the
                    # JSON might add, which gets a diagnostic naming the routine
                    # and the argument rather than a wrong call, and works
                    # already if the procedure passed is a predefined one.
                    append!(input_conversions,
                            ["void *c_$parname;",
                             "if (!mpif_predefined_callback((mpif_fortran_procedure)$parname, &c_$parname)) {",
                             "  *ierror = mpif_unsupported_callback(\"$name_c\", \"$parname\");",
                             "  return;",
                             "}"])
                    push!(call_arguments, "($func_type*)c_$parname")
                end
                push!(f_declarations, "external :: $parname")
                push!(f08_declarations, "procedure($func_type) :: $parname")
            else
                @show name parname kind
                @assert false
            end
        end

        input_arguments = [input_arguments; final_input_arguments]

        # A status is eight default INTEGERs either way -- the ABI fixes
        # MPI_Status as three named ints followed by five more, and mpif fixes
        # MPI_STATUS_SIZE at 8 with MPI_SOURCE, MPI_TAG and MPI_ERROR at 1, 2 and
        # 3 -- so the f08 layer can hand the caller's own status to C instead of
        # converting into an INTEGER array first. What it cannot do is pass one
        # through the mpi module's interface, which says INTEGER. So the
        # status-taking routines get a second interface to the same C entry
        # point, in `mpif_f08_raw`, differing only in how it spells those eight
        # integers, and the f08 wrappers call that.
        #
        # Without it every f08 status went through a temporary, which cost three
        # defects: a one-status temporary that arrays overran, an MPI_ERROR
        # copied back from uninitialised stack, and a `loc()` comparison per call
        # to keep MPI_STATUS_IGNORE out of the conversion.
        f_raw_declarations = map(f_declarations) do decl
            m = match(r"^integer :: (\w+)\(MPI_STATUS_SIZE\)$", decl)
            m !== nothing && return "type(MPI_Status) :: $(m[1])"
            m = match(r"^integer :: (\w+)\(MPI_STATUS_SIZE, \*\)$", decl)
            m !== nothing && return "type(MPI_Status) :: $(m[1])(*)"
            return decl
        end
        has_status = f_raw_declarations != f_declarations

        push!(c_implementations, "")
        push!(f_interfaces, "")
        push!(f08_implementations_body, "")

        return_kind = api["return_kind"]
        if return_kind == "ERROR_CODE"
            return_type = "void"
            f_unit = "subroutine"
            f_return_type = ""
        elseif return_kind ∈ ["DISPLACEMENT", "LOCATION_SMALL"]
            return_type = "MPI_Aint"
            f_unit = "function"
            f_return_type = "integer(MPI_ADDRESS_KIND)"
        elseif return_kind ∈ ["TICK_RESOLUTION", "WALL_TIME"]
            return_type = "double"
            f_unit = "function"
            f_return_type = "double precision"
        else
            @assert false
        end

        push!(c_implementations, "$return_type $name_f(")
        for (n, arg) in enumerate(input_arguments)
            comma = n < length(input_arguments) ? "," : ""
            push!(c_implementations, "  $arg$comma")
        end
        push!(c_implementations, ")")

        push!(f_interfaces, "  $f_unit $f_name( &")
        for (n, arg) in enumerate(f_arguments)
            comma = n < length(f_arguments) ? "," : ""
            push!(f_interfaces, "    $arg$comma &")
        end
        if f_unit == "function"
            push!(f_interfaces, "  ) result(result)")
        else
            push!(f_interfaces, "  )")
        end
        push!(f_interfaces, "    use mpif_constants")
        push!(f_interfaces, "    implicit none")
        if f_unit == "function"
            push!(f_interfaces, "    $f_return_type :: result")
        end
        for decl in f_declarations
            push!(f_interfaces, "    $decl")
        end

        # The second interface to the same C entry point, for the f08 layer
        if has_status
            push!(f08_raw_interfaces, "")
            push!(f08_raw_interfaces, "     $f_unit $f_name( &")
            for (n, arg) in enumerate(f_arguments)
                comma = n < length(f_arguments) ? "," : ""
                push!(f08_raw_interfaces, "       $arg$comma &")
            end
            if f_unit == "function"
                push!(f08_raw_interfaces, "     ) result(result)")
            else
                push!(f08_raw_interfaces, "     )")
            end
            push!(f08_raw_interfaces, "       use mpif_constants")
            push!(f08_raw_interfaces, "       import :: MPI_Status")
            push!(f08_raw_interfaces, "       implicit none")
            if f_unit == "function"
                push!(f08_raw_interfaces, "       $f_return_type :: result")
            end
            for decl in f_raw_declarations
                push!(f08_raw_interfaces, "       $decl")
            end
            push!(f08_raw_interfaces, "     end $f_unit $f_name")
            push!(f08_raw_uses, "    $f08_name_f => $f08_name, &")
        else
            push!(f08_implementations_useonly, "    $f08_name_f => $f08_name, &")
        end
        push!(f08_implementations_public, "  public :: $f08_name")
        # Only overload when Fortran can actually tell the two apart. A POLY kind
        # that goes from default INTEGER to an address- or count-sized one does
        # that; one that goes from MPI_ADDRESS_KIND to MPI_COUNT_KIND does not,
        # because mpif defines MPI_COUNT_KIND as MPI_ADDRESS_KIND, leaving the
        # large form with a signature identical to the small one. MPI_Type_get_extent
        # and MPI_Type_create_resized are of that sort, and declaring a generic
        # over them is rejected: "Ambiguous interfaces in generic interface".
        # MPICH's generator applies the same test, comparing the two kinds' sizes.
        #
        # This also excludes the two the standard exempts by name, MPI_Op_create
        # and MPI_Register_datarep, whose only POLY parameter is the callback:
        # "interface polymorphism cannot be used to differentiate between the two
        # different user callback prototypes despite their different type
        # signatures".
        if embiggen && any(p -> p["kind"] ∈ [int_aint_kinds; int_count_kinds], parameters)
            @assert name ∉ f08_explicit_large_count
            push!(f08_large_count_pairs, name)
        end

        push!(f08_implementations_body, "  $f_unit $f08_name( &")
        for (n, arg) in enumerate(f08_arguments)
            comma = n < length(f08_arguments) ? "," : ""
            push!(f08_implementations_body, "    $arg$comma &")
        end
        if f_unit == "function"
            push!(f08_implementations_body, "  ) result(result)")
        else
            push!(f08_implementations_body, "  )")
        end
        push!(f08_implementations_body, "    use mpif_f08_constants")
        push!(f08_implementations_body, "    use mpif_f08_types")
        if any(p -> p["kind"] ∈ cptr_out_kinds && p["param_direction"] == "out", parameters)
            push!(f08_implementations_body, "    use, intrinsic :: iso_c_binding, only: C_PTR, C_NULL_PTR")
        end
        push!(f08_implementations_body, "    implicit none")
        if f_unit == "function"
            push!(f08_implementations_body, "    $f_return_type :: result")
        end
        for decl in f08_declarations
            push!(f08_implementations_body, "    $decl")
        end
        for decl in f08_call_temp_declarations
            push!(f08_implementations_body, "    $decl")
        end
        for stmt in f08_call_temp_copyins
            push!(f08_implementations_body, "    $stmt")
        end
        if f_unit == "function"        
            push!(f08_implementations_body, "    result = $f08_name_f( &")
        else
            push!(f08_implementations_body, "    call $f08_name_f( &")
        end
        for (n, arg) in enumerate(f08_call_arguments)
            comma = n < length(f08_call_arguments) ? "," : ""
            push!(f08_implementations_body, "      $arg$comma &")
        end
        push!(f08_implementations_body, "    )")
        for stmt in f08_call_temp_copyouts
            push!(f08_implementations_body, "    $stmt")
        end
        push!(f08_implementations_body, "  end $f_unit $f08_name")

        push!(c_implementations, "{")

        c_expressible = attributes["c_expressible"]
        if !c_expressible
            if name == "MPI_F_sync_reg"
                # do nothing
            elseif name == "MPI_Sizeof"
                # we should not be here
            else
                @assert false
            end
        end
        if c_expressible
            foreach(input_conversions) do ic
                return push!(c_implementations, "  $ic")
            end

            if return_type == "void"
                # Almost every routine returning an error code has an `ierror`
                # argument to put it in, but not quite all: MPI_Pcontrol's
                # Fortran binding is just MPI_PCONTROL(LEVEL), so there is
                # nowhere to store the result and it is discarded.
                if any(p -> p["name"] == "ierror", parameters)
                    push!(c_implementations, "  *ierror = $name_c(")
                else
                    push!(c_implementations, "  $name_c(")
                end
            else
                push!(c_implementations, "  const $return_type result = $name_c(")
            end
            for (n, arg) in enumerate(call_arguments)
                comma = n < length(call_arguments) ? "," : ""
                push!(c_implementations, "    $arg$comma")
            end
            push!(c_implementations, "  );")

            foreach(output_conversions) do oc
                return push!(c_implementations, "  $oc")
            end

            if return_type != "void"
                push!(c_implementations, "  return result;")
            end
        end

        push!(c_implementations, "}")
        push!(f_interfaces, "  end $f_unit $f_name")

    end                         # for embiggen
end                             # for api

append!(f_interfaces,
        ["",
         "  end interface",
         "",
         "end module mpif_functions",
         ])

append!(f08_implementations_body,
        ["",
         "end module mpif_f08_functions",
         ])

# One generic per base name, gathering the small-count procedure and its
# large-count companion. Naming the generic after one of its own specifics is
# what the standard's own interface blocks do, and the two are distinguishable
# because a default INTEGER count and an INTEGER(KIND=MPI_COUNT_KIND) one are
# different kinds.
for name in sort(f08_large_count_pairs)
    append!(f08_generic_interfaces,
            ["  interface $name",
             "     procedure $name",
             "     procedure $(name)_c",
             "  end interface $name",
             ""])
end

append!(f08_raw_interfaces,
        ["",
         "  end interface",
         "",
         "end module mpif_f08_raw",
         "",
         ])

# `MPI_VERSION` closes the `use mpi` list, having no trailing continuation; the
# last of the raw renames closes its own the same way.
f08_raw_use_block = []
if !isempty(f08_raw_uses)
    f08_raw_uses[end] = replace(f08_raw_uses[end], r", &$" => "")
    f08_raw_use_block = ["  use mpif_f08_raw, only: &"; f08_raw_uses]
end

# The raw interfaces come first in the file: mpif_f08_functions uses them.
f08_implementations = [f08_raw_interfaces;
                       f08_implementations_useonly;
                       ["    MPI_VERSION"];
                       f08_raw_use_block;
                       f08_implementations_public;
                       f08_generic_interfaces; f08_implementations_body]

println("Writing \"gen/mpif_functions.c\"...")
open("gen/mpif_functions.c", "w") do f
    for impl in c_implementations
        println(f, impl)
    end
end

println("Writing \"gen/mpif_functions.F90\"...")
open("gen/mpif_functions.F90", "w") do f
    for ifc in f_interfaces
        println(f, ifc)
    end
end

println("Writing \"gen/mpif_f08_functions.F90\"...")
open("gen/mpif_f08_functions.F90", "w") do f
    for impl in f08_implementations
        println(f, impl)
    end
end

println("Done.")
