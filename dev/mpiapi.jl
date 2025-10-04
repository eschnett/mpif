# git clone https://github.com/mpi-forum/pympistandard
# mkdir data
# cp pympistandard/src/pympistandard/data/apis.json data
#
# julia dev/mpiapi.jl

using JSON
apis = JSON.parsefile("data/apis.json")

kind2fun = Dict([
    "COMMUNICATOR" => "Comm",
    "DATATYPE" => "Type",
    "ERRHANDLER" => "Errhandler",
    "FILE" => "File",
    "GROUP" => "Group",
    "INFO" => "Info",
    "MESSAGE" => "Message",
    "OPERATION" => "Op",
    "REQUEST" => "Request",
    "SESSION" => "Session",
    "WINDOW" => "Win",
])
kind2null = Dict([
    "COMMUNICATOR" => "COMM",
    "DATATYPE" => "DATATYPE",
    "ERRHANDLER" => "ERRHANDLER",
    "FILE" => "FILE",
    "GROUP" => "GROUP",
    "INFO" => "INFO",
    "MESSAGE" => "MESSAGE",
    "OPERATION" => "OP",
    "REQUEST" => "REQUEST",
    "SESSION" => "SESSION",
    "WINDOW" => "WINDOW",
])
kind2type = Dict([
    "COMMUNICATOR" => "Comm",
    "DATATYPE" => "Datatype",
    "ERRHANDLER" => "Errhandler",
    "FILE" => "File",
    "GROUP" => "Group",
    "INFO" => "Info",
    "MESSAGE" => "Message",
    "OPERATION" => "Op",
    "REQUEST" => "Request",
    "SESSION" => "Session",
    "WINDOW" => "Win",
])

fortran_false = 0
fortran_true = 1

struct State
    # have_fortran_booleans::Ref{Bool}
    have_comm::Ref{Bool}
    have_comm_rank::Ref{Bool}
    have_comm_size::Ref{Bool}

    State() = new(Ref(false), Ref(false), Ref(false))
end

# function ensure_fortran_booleans!(state, input_conversions)
#     state.have_fortran_booleans[] && return
#     append!(input_conversions, [
#         "MPI_Fint q_logical_true, q_logical_false, q_is_set;",
#         "{",
#         "  const int q_ierror = MPI_Abi_get_fortran_booleans(sizeof(MPI_Fint), &q_logical_true, &q_logical_false, &q_is_set);",
#         "  if (q_ierror != MPI_SUCCESS) {",
#         "    if (ierror) *ierror = q_ierror;",
#         "    return;",
#         "  }",
#         "}",
#         "if (!q_is_set) abort();",
#     ])
#     state.have_fortran_booleans[] = true
# end

function ensure_comm!(state, input_conversions)
    state.have_comm[] && return
    append!(input_conversions, [
        "const MPI_Comm q_comm = MPI_Comm_fromint(*comm);",
    ])
    state.have_comm[] = true
end

function ensure_comm_size!(state, input_conversions)
    state.have_comm_size[] && return
    ensure_comm!(state, input_conversions)
    append!(input_conversions, [
        "int q_comm_size;",
        "{",
        "  const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);",
        "  if (q_ierror != MPI_SUCCESS) {",
        "    if (ierror) *ierror = q_ierror;",
        "    return;",
        "  }",
        "}",
    ])
    state.have_comm_size[] = true
end

function ensure_comm_rank!(state, input_conversions)
    state.have_comm_rank[] && return
    ensure_comm!(state, input_conversions)
    append!(input_conversions, [
        "int q_comm_rank;",
        "{",
        "  const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);",
        "  if (q_ierror != MPI_SUCCESS) {",
        "    if (ierror) *ierror = q_ierror;",
        "    return;",
        "  }",
        "}",
    ])
    state.have_comm_rank[] = true
end

c_implementations = []
c_prototypes = []
f_interfaces = []

append!(c_implementations, [
    "#include <mpif_strings.h>",
    "#include <mpi.h>",
    "#include <assert.h>",
    "#include <stdlib.h>",
    "#include <string.h>",
    # "",
    # "// Work around MPICH bug",
    # "static int MPI_Abi_get_fortran_booleans1(int logical_size, void *logical_true, void *logical_false, int *is_set)",
    # "{",
    # "  *is_set = 1;   // pretend",
    # "  return MPI_Abi_get_fortran_booleans(logical_size, logical_true, logical_false);",
    # "}",
    # "#define MPI_Abi_get_fortran_booleans MPI_Abi_get_fortran_booleans1",
])

for key in sort(collect(keys(apis)))
    api = apis[key]
    # key in ["mpi_recv", "mpi_send"] || continue

    name = api["name"]
    attributes = api["attributes"]
    parameters = api["parameters"]

    not_with_mpif = attributes["not_with_mpif"]
    not_with_mpif && continue
    f90_expressible = attributes["f90_expressible"]
    !f90_expressible && continue

    # Callbacks are just prototypes, not functions
    callback = attributes["callback"]
    callback && continue
    # Predefined functions are constants
    predefined_function = attributes["predefined_function"]
    predefined_function != nothing && continue

    # Varargs cannot be forwarded
    any(p -> p["kind"] == "VARARGS", parameters) && continue

    # MPI_Sizeof needs to be implemented in Fortran
    name == "MPI_Sizeof" && continue

    name_c = name
    name_f = lowercase(name) * "_"

    state = State()
    input_arguments = []
    final_input_arguments = []
    input_conversions = []
    call_arguments = []
    output_conversions = []
    for parameter in parameters
        kind = parameter["kind"]
        length = parameter["length"]
        large_only = parameter["large_only"]
        parname = parameter["name"]
        param_direction = parameter["param_direction"]
        root_only = parameter["root_only"]
        suppress = split(parameter["suppress"])

        if kind ∈ ["BUFFER", "LOGICAL_VOID"]
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
            @assert length == nothing
            if param_direction == "in"
                if name ∈ ["MPI_Buffer_attach", "MPI_Comm_attach_buffer", "MPI_Free_mem", "MPI_Precv_init", "MPI_Session_attach_buffer", "MPI_Win_attach", "MPI_Win_create"]
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
        elseif kind ∈ keys(kind2type)
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
            if name == "MPI_Cancel" && parname == "request"
                @assert kind == "REQUEST"
                @assert param_direction == "in"
                # `MPI_Cancel` modifies the request
                param_direction = "inout"
            end
            if param_direction == "in"
                if length == nothing
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    if root_only
                        ensure_comm_rank!(state, input_conversions)
                        push!(call_arguments, "q_comm_rank == 0 ? MPI_$(kind2fun[kind])_fromint(*$parname) : MPI_$(kind2null[kind])_NULL")
                    else
                        push!(call_arguments, "MPI_$(kind2fun[kind])_fromint(*$parname)")
                    end
                elseif length == "*"
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    ensure_comm_size!(state, input_conversions)
                    push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[q_comm_size];")
                    if root_only
                        ensure_comm_rank!(state, input_conversions)
                        append!(input_conversions, [
                            "if (q_comm_rank == 0)",
                            "  for (int rank=0; rank<q_comm_size; ++rank)",
                            "    c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);",
                        ])
                    else
                        append!(input_conversions, [
                            "for (int rank=0; rank<q_comm_size; ++rank)",
                            "  c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);",
                        ])
                    end
                    push!(call_arguments, "c_$parname")
                elseif length ∈ ["count", "incount"]
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[*$length];")
                    if root_only
                        ensure_comm_rank!(state, input_conversions)
                        append!(input_conversions, [
                            "if (q_comm_rank == 0)",
                            "  for (int rank=0; rank<*$length; ++rank)",
                            "    c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);",
                        ])
                    else
                        append!(input_conversions, [
                            "for (int rank=0; rank<*$length; ++rank)",
                            "  c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);",
                        ])
                    end
                    push!(call_arguments, "c_$parname")
                else
                    @show name parname length
                    @assert false
                end
            elseif param_direction == "out"
                @assert !root_only
                push!(input_arguments, "MPI_Fint* restrict const $parname")
                push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname;")
                push!(call_arguments, "&c_$(parname)")
                push!(output_conversions, "*$parname = MPI_$(kind2fun[kind])_toint(c_$parname);")
            elseif param_direction == "inout"
                @assert !root_only
                @assert !root_only
                push!(input_arguments, "MPI_Fint* restrict const $parname")
                push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname = MPI_$(kind2fun[kind])_fromint(*$parname);")
                push!(call_arguments, "&c_$(parname)")
                push!(output_conversions, "*$parname = MPI_$(kind2fun[kind])_toint(c_$parname);")
            else
                @assert false
            end
        elseif kind == "STATUS"
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
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
        elseif kind in ["ACCESS_MODE", "ARGUMENT_COUNT", "ARRAY_LENGTH", "ARRAY_LENGTH_NNI", "ARRAY_LENGTH_PI", "ASSERT", "COLOR", "COMBINER", "COMM_COMPARISON", "COMM_SIZE", "COMM_SIZE_PI", "COORDINATE", "DEGREE", "DIMENSION", "DISTRIB_ENUM", "DTYPE_DISTRIBUTION", "ERROR_CLASS", "ERROR_CODE", "FILE_DESCRIPTOR", "GENERIC_DTYPE_INT", "GROUP_COMPARISON", "INDEX", "INFO_VALUE_LENGTH", "KEY", "KEYVAL", "KEY_INDEX", "LOCK_TYPE", "MATH", "NUM_BYTES_SMALL", "NUM_DIMS", "ORDER",  "PARTITION", "POLYDISPLACEMENT", "POLYDISPLACEMENT_COUNT", "POLYDTYPE_NUM_ELEM", "POLYDTYPE_NUM_ELEM_NNI", "POLYDTYPE_NUM_ELEM_PI", "POLYNUM_BYTES", "POLYNUM_BYTES_NNI", "POLYNUM_PARAM_VALUES", "POLYRMA_DISPLACEMENT", "POLYXFER_NUM_ELEM", "POLYXFER_NUM_ELEM_NNI", "PROCESS_GRID_SIZE", "RANK", "RANK_NNI", "RMA_DISPLACEMENT_NNI", "SPLIT_TYPE", "STRING_LENGTH", "TAG", "THREAD_LEVEL", "TOPOLOGY_TYPE", "TYPECLASS", "TYPECLASS_SIZE", "UPDATE_MODE", "VERSION", "WEIGHT", "XFER_NUM_ELEM_NNI"]
            if !large_only
                if name == "MPI_Info_create_env" && parname == "argc"
                    @assert param_direction == "inout"
                    # `MPI_Info_create_env` does not modify the argument count
                    param_direction = "in"
                end
                if param_direction == "in"
                    @assert "c_parameter" ∉ suppress
                    if length == nothing
                        if "f90_parameter" ∉ suppress
                            push!(input_arguments, "const MPI_Fint* restrict const $parname")
                            push!(call_arguments, "*$parname")
                        else
                            push!(call_arguments, "0")
                        end
                    elseif length ∈ ["*", "count", "n", "ndims", "indegree", "length", "nnodes", "outdegree"]
                        @assert "f90_parameter" ∉ suppress
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        push!(call_arguments, "$parname")
                    elseif length ∈ [["n", "3"]]
                        @assert "f90_parameter" ∉ suppress
                        push!(input_arguments, "const MPI_Fint(* restrict const $parname)[3]")
                        if name ∈ ["MPI_Group_range_excl", "MPI_Group_range_incl"]
                            # `mpi.h` header file lacks const qualifiers
                            push!(call_arguments, "(int(*)[3])$parname")
                        else
                            push!(call_arguments, "$parname")
                        end
                    else
                        @show name parname length
                        @assert false
                    end
                elseif param_direction ∈ ["inout", "out"]
                    if "f90_parameter" ∉ suppress
                        push!(input_arguments, "MPI_Fint* restrict const $parname")
                        if "c_parameter" ∉ suppress
                            push!(call_arguments, "$parname")
                        end
                    else
                        @assert "c_parameter" ∉ suppress
                        push!(call_arguments, "NULL")
                    end
                else
                    @assert false
                end
            end
        elseif kind in ["ATTRIBUTE_VAL_10"]
            @assert "f90_parameter" ∉ suppress
            @assert "c_parameter" ∉ suppress
            @assert !large_only
            @assert length == nothing
            @assert !root_only
            # This is an integer in Fortran but a pointer in C
            if param_direction == "in"
                push!(input_arguments, "const MPI_Fint* restrict const $parname")
                push!(call_arguments, "(void*)(intptr_t)*$parname")
            elseif param_direction ∈ ["inout", "out"]
                push!(input_arguments, "MPI_Fint* restrict const $parname")
                push!(input_conversions, "void *c_$parname;")
                push!(call_arguments, "c_$parname")
                push!(output_conversions, "*$parname = (int)(intptr_t)c_$parname;")
            else
                @assert false
            end
        elseif kind in ["ALLOC_MEM_NUM_BYTES", "C_BUFFER", "C_BUFFER2", "DISPLACEMENT", "LOCATION_SMALL", "POLYDISPLACEMENT_AINT_COUNT", "POLYDISPOFFSET", "POLYDTYPE_PACK_SIZE", "POLYDTYPE_STRIDE_BYTES", "POLYLOCATION", "WIN_ATTACH_SIZE", "WINDOW_SIZE"]
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
            @assert !root_only
            if param_direction == "in"
                if length == nothing
                    push!(input_arguments, "const MPI_Aint* restrict const $parname")
                    push!(call_arguments, "*$parname")
                elseif length ∈ ["*", "count"]
                    push!(input_arguments, "const MPI_Aint* restrict const $parname")
                    push!(call_arguments, "$parname")
                else
                    @show name parname length
                    @assert false
                end
            elseif param_direction ∈ ["inout", "out"]
                @assert length == nothing || length ∈ ["max_addresses"]
                push!(input_arguments, "MPI_Aint* restrict const $parname")
                push!(call_arguments, "$parname")
            else
                @assert false
            end
        elseif kind in ["ATTRIBUTE_VAL", "EXTRA_STATE", "EXTRA_STATE2"]
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
            @assert length == nothing
            @assert !root_only
            if param_direction == "in"
                push!(input_arguments, "const MPI_Aint* restrict const $parname")
                push!(call_arguments, "(void*)*$parname")
            elseif param_direction == "out"
                push!(input_arguments, "MPI_Aint* restrict const $parname")
                push!(input_conversions, "void *c_$parname;")
                push!(call_arguments, "&c_$parname")
                push!(output_conversions, "*$parname = (MPI_Aint)c_$parname;")
            else
                @assert false
            end
        elseif kind in ["GENERIC_DTYPE_COUNT", "NUM_BYTES", "XFER_NUM_ELEM"]
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            if !large_only
                @assert !root_only
                if param_direction == "in"
                    @assert length == nothing
                    push!(input_arguments, "const MPI_Count* restrict const $parname")
                    push!(call_arguments, "*$parname")
                elseif param_direction ∈ ["inout", "out"]
                    @assert length == nothing || length ∈ ["max_addresses", "max_datatypes", "max_integers", "max_large_counts"]
                    push!(input_arguments, "MPI_Count* restrict const $parname")
                    push!(call_arguments, "$parname")
                else
                    @assert false
                end
            end
        elseif kind in ["OFFSET"]
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
            @assert length == nothing
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
        elseif kind == "LOGICAL"
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
            @assert !root_only
            if param_direction == "in"
                if length == nothing
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    push!(call_arguments, "*$parname != $fortran_false")
                elseif length == "ndims"
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    append!(input_conversions, [
                        "int c_$parname[*ndims];",
                        "for (int dim=0; dim<*ndims; ++dim)",
                        "  c_$parname[dim] = $parname[dim] != $fortran_false;",
                    ])
                    push!(call_arguments, "c_$parname")
                elseif name == "MPI_Cart_sub" && length == "*"
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    ensure_comm!(state, input_conversions)
                    append!(input_conversions, [
                        "int ndims;",
                        "{",
                        "  const int q_ierror = MPI_Cartdim_get(q_comm, &ndims);",
                        "  if (q_ierror != MPI_SUCCESS) {",
                        "    if (ierror) *ierror = q_ierror;",
                        "    return;",
                        "  }",
                        "}",
                        "int c_$parname[ndims];",
                        "for (int dim=0; dim<ndims; ++dim)",
                        "  c_$parname[dim] = $parname[dim] != $fortran_false;",
                    ])
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
                    push!(output_conversions, "*$parname = c_$parname ? $fortran_true : $fortran_false;")
                elseif length == "maxdims"
                    push!(input_arguments, "MPI_Fint* restrict const $parname")
                    append!(input_conversions, [
                        "int c_$parname[*maxdims];",
                    ])
                    push!(call_arguments, "c_$parname")
                    append!(output_conversions, [
                        "for (int dim=0; dim<*maxdims; ++dim)",
                        "  $parname[dim] = c_$parname[dim] ? $fortran_true : $fortran_false;",
                    ])
                else
                    @show name length
                    @assert false
                end
            else
                @assert false
            end
        elseif kind ∈ ["ARGUMENT_LIST", "STRING"]
            @assert "c_parameter" ∉ suppress
            @assert !large_only
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
                    if root_only
                        ensure_comm_rank!(state, input_conversions)
                        append!(input_conversions, [
                            "char* c_$parname = NULL;",
                            "if (q_comm_rank == 0)",
                            "  c_$parname = mpif_strdup_f2c($parname, length_$parname);",
                        ])
                        append!(output_conversions, [
                            "if (q_comm_rank == 0)",
                            "  free(c_$parname);",
                        ])
                    else
                        push!(input_conversions, "char* const c_$parname = mpif_strdup_f2c($parname, length_$parname);")
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
                if length == nothing
                    push!(final_input_arguments, "const size_t length_$parname")
                elseif length ∈ ["MPI_MAX_ERROR_STRING", "MPI_MAX_LIBRARY_VERSION_STRING", "MPI_MAX_OBJECT_NAME", "MPI_MAX_PORT_NAME", "MPI_MAX_PROCESSOR_NAME"]
                    push!(input_conversions, "const size_t length_$parname = $length;")
                elseif length ∈ ["valuelen"]
                    push!(input_conversions, "const size_t length_$parname = *$length;")
                else
                    @show name parname length
                    @assert false
                end
                push!(input_conversions, "char c_$parname[length_$parname + 1];")
                push!(call_arguments, "c_$parname")
                push!(output_conversions, "mpif_strcpy_c2f($parname, c_$parname, length_$parname, strlen(c_$parname));")
            elseif param_direction == "inout"
                @assert "f90_parameter" ∈ suppress
                push!(call_arguments, "NULL")
            else
                @assert false
            end
        elseif kind ∈ ["STRING_ARRAY"]
            @assert "c_parameter" ∉ suppress
            @assert !large_only
            @assert length == nothing
            @assert root_only
            @assert param_direction == "in"
            if "f90_parameter" ∉ suppress
                push!(input_arguments, "const char* restrict const $parname")
                push!(final_input_arguments, "const size_t length_$parname")
                ensure_comm_rank!(state, input_conversions)
                append!(input_conversions, [
                    "size_t count_$parname = 0;",
                    "if (q_comm_rank == 0)",
                    "  count_$parname = mpif_fcount($parname, length_$parname);",
                    "char *argv_$parname[count_$parname + 1];",
                    "for (size_t n=0; n<count_$parname; ++n)",
                    "  argv_$parname[n] = mpif_strdup_f2c($parname + n * length_$parname, length_$parname);",
                    "argv_$parname[count_$parname] = NULL;",
                ])
                push!(call_arguments, "argv_$parname")
                append!(output_conversions, [
                    "for (size_t n=0; n<count_$parname; ++n)",
                    "  free(argv_$parname[n]);",
                ])
            else
                push!(call_arguments, "NULL")
            end
        elseif kind == "STRING_2DARRAY"
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
            @assert length == "count"
            @assert root_only
            @assert param_direction == "in"
            push!(input_arguments, "const char* restrict const $parname")
            push!(final_input_arguments, "const size_t length_$parname")
            ensure_comm_rank!(state, input_conversions)
            append!(input_conversions, [
                "size_t count_$parname[*count];",
                "char **argv_$parname[*count];",
                "for (int i=0; i<*count; ++i) {",
                "  if (q_comm_rank == 0) {",
                "    count_$parname[i] = mpif_fcount2d($parname, *count, i, length_$parname);",
                "    argv_$parname[i] = malloc((count_$parname[i] + 1) * sizeof(char*));",
                "    for (size_t n=0; n<count_$parname[i]; ++n)",
                "      argv_$parname[i][n] = mpif_strdup_f2c($parname + i * length_$parname + n * *count * length_$parname, length_$parname);",
                "    argv_$parname[i][count_$parname[i]] = NULL;",
                "  } else {",
                "    count_$parname[i] = 0;",
                "    argv_$parname[i] = NULL;",
                "  }",
                "}",
            ])
            push!(call_arguments, "argv_$parname")
            append!(output_conversions, [
                "for (int i=0; i<*count; ++i) {",
                "  for (size_t n=0; n<count_$parname[i]; ++n)",
                "    free(argv_$parname[i][n]);",
                "}",
            ])
        elseif kind ∈ ["FUNCTION", "POLYFUNCTION"]
            @assert "c_parameter" ∉ suppress
            @assert "f90_parameter" ∉ suppress
            @assert !large_only
            @assert length == nothing
            @assert !root_only
            @assert param_direction == "in"
            func_type = parameter["func_type"]
            push!(input_arguments, "$func_type* const $parname")
            push!(input_conversions, "abort();")
            push!(call_arguments, "$parname")
        else
            @show name parname kind
            @assert false
        end

    end

    input_arguments = [input_arguments; final_input_arguments]



    push!(c_implementations, "")

    return_kind = api["return_kind"]
    if return_kind == "ERROR_CODE"
        return_type = "void"
    elseif return_kind ∈ ["DISPLACEMENT", "LOCATION_SMALL"]
        return_type = "MPI_Aint"
    elseif return_kind ∈ ["TICK_RESOLUTION", "WALL_TIME"]
        return_type = "double"
    else
        @assert false
    end
    
    push!(c_implementations, "$return_type $name_f(")
    for (n, arg) in enumerate(input_arguments)
        comma = n < length(input_arguments) ? "," : ""
        push!(c_implementations, "  $arg$comma")
    end
    push!(c_implementations, ")")

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
            push!(c_implementations, "  $ic")
        end

        if return_type == "void"
            push!(c_implementations, "  const int c_ierror = $name_c(")
        else
            push!(c_implementations, "  const $return_type result = $name_c(")
        end
        for (n, arg) in enumerate(call_arguments)
            comma = n < length(call_arguments) ? "," : ""
            push!(c_implementations, "    $arg$comma")
        end
        push!(c_implementations, "  );")

        foreach(output_conversions) do oc
            push!(c_implementations, "  $oc")
        end

        if return_type == "void"
            push!(c_implementations, "  if (ierror) *ierror = c_ierror;")
        else
            push!(c_implementations, "  return result;")
        end

    end

    push!(c_implementations, "}")
end

println("Writing \"gen/mpif_functions.c\"...")
open("gen/mpif_functions.c", "w") do f
    for impl in c_implementations
        println(f, impl)
    end
end

println("Done.")
