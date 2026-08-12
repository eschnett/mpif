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
                  # The null window is MPI_WIN_NULL, not MPI_WINDOW_NULL. The
                  # entry was wrong from the start and harmless until the
                  # out-handle initialisers below became its first user for
                  # windows; nothing root_only or alltoallw-shaped ever names a
                  # window.
                  "WINDOW" => "WIN"])
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

# The routines where the caller says how much room its string has and MPI answers
# with how much it needs. MPI-5.0 gives MPI_INFO_GET_STRING's `buflen` (10.1.2)
# and MPI_SESSION_GET_NTH_PSET's `pset_len` (11.3.2) the same semantics word for
# word -- the string is truncated when the length is too small, "If <len> is set
# to 0, <string> is not changed", "On return, the value of <len> will be set to
# the required buffer size", "In C, <len> includes the required space for the null
# terminator" -- so both need the same three corrections, and none of them is made
# by the generic integer and string paths. The MPI_T_ routines have the same shape
# and are not `f90_expressible`, so these two are all of them.
#
# The pair differ only in MPI_Info_get_string's `flag`: when the key does not
# exist it writes neither `value` nor `buflen`, and neither may we. Nothing tells
# MPI_Session_get_nth_pset apart that way, so its length is written back
# unconditionally, which is also how the standard states it.
string_length_handshake = Dict("MPI_Info_get_string" => (len="buflen", str="value", flag="c_flag"),
                               "MPI_Session_get_nth_pset" => (len="pset_len", str="pset_name", flag=nothing))

# The argument-vector sentinels: how C recognises each one, and the C constant it
# stands for.
#
# Every sentinel needs translating -- mpif's Fortran sentinels are COMMON blocks
# of their own, not objects at the ABI constants' addresses; see
# include/mpif_sentinels.h. These two are the pair that cannot be translated by
# mapping an address, because an argument vector is converted element by element:
# the wrapper has to skip the conversion entirely and substitute the C constant.
# Hence two entries rather than one -- the predicate that recognises the Fortran
# object, and the value C is given in its place. Comparing against the C constant
# would be doubly wrong now: the addresses no longer coincide, and MPI-5.0 only
# says MPI_ARGVS_NULL is "likely to be (char ***)0" in the first place.
argv_null_sentinels = Dict([("MPI_Comm_spawn", "argv") =>
                                ("mpif_is_argv_null", "MPI_ARGV_NULL"),
                            ("MPI_Comm_spawn_multiple", "array_of_argv") =>
                                ("mpif_is_argvs_null", "MPI_ARGVS_NULL")])

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

# The callback prototypes, by the name a `func_type` gives. Keyed on the name
# rather than on `apis`' own key, which is the name lowercased but need not be.
callback_prototypes = Dict(a["name"] => a for a in values(apis) if a["attributes"]["callback"])

# Fortran's .TRUE. and .FALSE. are not necessarily 1 and 0 -- gfortran and flang
# use 1, Intel uses -1 -- so the conversions below go through the helpers in
# src/mpif_logical.c, which ask the MPI library what the representation is.

struct State
    # have_fortran_booleans::Ref{Bool}
    have_comm::Ref{Bool}
    have_at_root::Ref{Bool}
    have_group_size::Ref{Bool}
    have_neighbor_degrees::Ref{Bool}

    # The length arguments a `q_<name>` has already been emitted for; see
    # `root_only_count!`. A set because one routine may have several arrays and
    # they may share a length, as MPI_Comm_spawn_multiple's three do.
    root_counts::Set{String}

    State() = new(Ref(false), Ref(false), Ref(false), Ref(false), Set{String}())
end

# Every probe the helpers below emit calls a `PMPI_` name, in the MPI_ copy of a
# wrapper as well as the PMPI_ one. These are calls the program did not make --
# mpif working out how long an array is -- and a tool counting MPI_Comm_size or
# MPI_Comm_rank must not be shown them. That holds whichever copy is running, so
# the name is fixed here rather than following the wrapper's own prefix; doing
# the latter told a profiler about mpif's bookkeeping every time a Fortran
# program called MPI_BARRIER or a neighbourhood collective. It also keeps the
# older rule that a PMPI_ wrapper never re-enters MPI_, that being a special case
# of this one. src/mpif_cdesc.c says the same thing for the datatypes it builds.
#
# The principal call is the opposite case and stays `MPI_` in the MPI_ copy: that
# one *is* the call the program made, and a profiler has to see it. CODE.md, "The
# PMPI profiling interface", has both halves.

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

# The six routines whose handle arrays are indexed by neighbours rather than by a
# group. MPI-5.0 8.6 gives MPI_NEIGHBOR_ALLTOALLW's `sendtypes` "length
# outdegree" and its `recvtypes` "length indegree", which are properties of the
# topology and unrelated to the size of the communicator: 2*ndims for a Cartesian
# one, and either degree for a distributed graph. Listed rather than matched on
# the name because `MPI_Ineighbor_alltoallw` does not spell "Neighbor" the way the
# other two do.
neighbor_alltoallw = ["MPI_Ineighbor_alltoallw",
                      "MPI_Neighbor_alltoallw",
                      "MPI_Neighbor_alltoallw_init"]

# The number of entries in an alltoallw handle array, for the routines whose
# arrays are indexed by a group.
#
# Not MPI_Comm_size: for an intercommunicator the arrays are indexed over the
# *remote* group, the outcome being "as if each MPI process in group A sends a
# message to each MPI process in group B" (MPI-5.0 6.8), while MPI_COMM_SIZE
# "returns the size of the local group" (7.6). The two differ on every
# intercommunicator whose groups are not the same size.
function ensure_group_size!(state, input_conversions)
    state.have_group_size[] && return
    ensure_comm!(state, input_conversions)
    append!(input_conversions,
            ["int q_group_size = 0;",
             "{",
             "  int q_inter;",
             "  int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);",
             "  if (q_ierror == MPI_SUCCESS)",
             "    q_ierror = q_inter ? PMPI_Comm_remote_size(q_comm, &q_group_size)",
             "                       : PMPI_Comm_size(q_comm, &q_group_size);",
             "  if (q_ierror != MPI_SUCCESS) {",
             "    *ierror = q_ierror;",
             "    return;",
             "  }",
             "}"])
    return state.have_group_size[] = true
end

# The two neighbour counts, for the routines whose arrays are indexed by
# neighbours. MPI-5.0 8.6 defines them per topology, and the queries that report
# them are per topology too -- MPI_DIST_GRAPH_NEIGHBORS_COUNT takes "a
# communicator with associated distributed graph topology" and nothing licenses
# asking it about a Cartesian one -- so this dispatches on MPI_Topo_test.
#
# A communicator with no topology is erroneous here, these routines supporting
# "Cartesian communicators, graph communicators, and distributed graph
# communicators" and no others. Both counts stay zero, so nothing is converted and
# nothing uninitialised is passed, and MPI reports MPI_ERR_TOPOLOGY itself rather
# than mpif inventing an error class on its behalf.
function ensure_neighbor_degrees!(state, input_conversions)
    state.have_neighbor_degrees[] && return
    ensure_comm!(state, input_conversions)
    append!(input_conversions,
            ["int q_indegree = 0, q_outdegree = 0;",
             "{",
             "  int q_topology;",
             "  int q_ierror = PMPI_Topo_test(q_comm, &q_topology);",
             "  if (q_ierror == MPI_SUCCESS) {",
             "    if (q_topology == MPI_CART) {",
             "      int q_ndims;",
             "      q_ierror = PMPI_Cartdim_get(q_comm, &q_ndims);",
             "      if (q_ierror == MPI_SUCCESS)",
             "        q_indegree = q_outdegree = 2 * q_ndims;",
             "    } else if (q_topology == MPI_GRAPH) {",
             "      int q_neighbor_rank;",
             "      int q_nneighbors;",
             "      q_ierror = PMPI_Comm_rank(q_comm, &q_neighbor_rank);",
             "      if (q_ierror == MPI_SUCCESS)",
             "        q_ierror = PMPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);",
             "      if (q_ierror == MPI_SUCCESS)",
             "        q_indegree = q_outdegree = q_nneighbors;",
             "    } else if (q_topology == MPI_DIST_GRAPH) {",
             "      int q_weighted;",
             "      q_ierror = PMPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);",
             "    }",
             "  }",
             "  if (q_ierror != MPI_SUCCESS) {",
             "    *ierror = q_ierror;",
             "    return;",
             "  }",
             "}"])
    return state.have_neighbor_degrees[] = true
end

# The array-size expression for a VLA whose true element count is `count`:
# floored at 1, since a zero-length VLA is not C even where the count it is
# sized from is legally zero -- an indegree, a `count`/`incount`/`ndims`, or
# any other length a caller may pass as zero. Applied unconditionally rather
# than only where a count is known to be sometimes-zero: a count that happens
# to be always positive floors to itself and nothing changes, so there is no
# per-site judgement call to get wrong. The loops that iterate still use
# `count` itself, unfloored, so behaviour for a genuine zero is unchanged;
# only the declared size gains the floor.
vla_size(count) = "$count > 0 ? $count : 1"

# The C variable holding the number of entries in `parname`, an assumed-length
# array of handles.
function handle_array_length!(state, input_conversions, name, parname)
    if name ∈ neighbor_alltoallw
        ensure_neighbor_degrees!(state, input_conversions)
        @assert parname ∈ ["sendtypes", "recvtypes"]
        return parname == "sendtypes" ? "q_outdegree" : "q_indegree"
    end
    ensure_group_size!(state, input_conversions)
    return "q_group_size"
end

# Whether this process is the one at which a `root_only` argument is significant.
#
# Every guard below used to ask `MPI_Comm_rank(comm) == 0`, which is right only
# for a call whose root happens to be rank 0: the significant process is the one
# the routine's own `root` argument names, so a gather to root 1 converted
# `recvtype` on rank 0 and handed MPI MPI_DATATYPE_NULL on rank 1. See
# "Root-only arguments are converted at the root" in CODE.md.
#
# On an intercommunicator the significant process is not identified by a rank in
# `comm` at all. MPI-5.0 6.2.3: "the root uses the special value MPI_ROOT; all
# other MPI processes in the same group as the root use MPI_PROC_NULL. All MPI
# processes in the other group ... pass the same value in argument root, which is
# the rank of the root in group A". So comparing a process's own rank against
# `*root` there would convert at whichever process of the *remote* group happened
# to carry that number, and never at the root. Hence the MPI_Comm_test_inter and
# hence two rules rather than one. Both sentinels are negative -- A.1.1 gives
# MPI_ROOT the ABI value -4 -- so neither collides with a valid rank.
#
# Only the collectives can be given an intercommunicator; MPI_COMM_SPAWN,
# MPI_COMM_ACCEPT and MPI_COMM_CONNECT all take an intracommunicator, and there
# the test is a wasted query rather than a wrong answer. One shape for all of
# them is cheaper than a second rule about which routines get which.
function ensure_at_root!(state, input_conversions, name, parameters)
    state.have_at_root[] && return
    # The argument that names the root. Asserted rather than assumed: the guard
    # is meaningless if a routine spells it anything else, and `parameters` is
    # the only place that could say so.
    roots = [p["name"] for p in parameters if p["kind"] == "RANK" && p["param_direction"] == "in"]
    @assert roots == ["root"] (name, roots)
    ensure_comm!(state, input_conversions)
    append!(input_conversions,
            ["int q_at_root;",
             "{",
             "  int q_inter;",
             "  int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);",
             "  if (q_ierror != MPI_SUCCESS) {",
             "    *ierror = q_ierror;",
             "    return;",
             "  }",
             "  if (q_inter) {",
             "    q_at_root = *root == MPI_ROOT;",
             "  } else {",
             "    int q_comm_rank;",
             "    q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);",
             "    if (q_ierror != MPI_SUCCESS) {",
             "      *ierror = q_ierror;",
             "      return;",
             "    }",
             "    q_at_root = q_comm_rank == *root;",
             "  }",
             "}"])
    return state.have_at_root[] = true
end

# The number of entries to convert in a root-only array whose length argument is
# itself root-only, which is MPI_Comm_spawn_multiple and nothing else: `count`
# there is "significant only at root", so a non-root caller may leave it
# uninitialised, and every use of it away from the root is a wild read.
# `*count` sized three VLAs -- a huge garbage value overflows the stack, and zero
# is not a VLA length C admits at all -- and bounded three conversion loops.
#
# So zero away from the root, and every VLA sized `q_count > 0 ? q_count : 1` and
# filled over that whole extent, so that a legal array of ignored entries is what
# MPI receives rather than a stack overflow or uninitialised memory. `*count`
# itself still goes to MPI unchanged: it is the caller's argument, and MPI is the
# one entitled to ignore it.
function root_only_count!(state, input_conversions, name, parameters, lengthname)
    ensure_at_root!(state, input_conversions, name, parameters)
    lengthpar = only(p for p in parameters if p["name"] == lengthname)
    @assert lengthpar["root_only"] (name, lengthname)
    if lengthname ∉ state.root_counts
        push!(input_conversions, "const int q_$lengthname = q_at_root ? (int)*$lengthname : 0;")
        push!(state.root_counts, lengthname)
    end
    return "q_$lengthname"
end

c_implementations = []
c_prototypes = []
f_interfaces = []
f08_implementations_public = []
f08_generic_interfaces = []

# The mpi_f08 wrappers are external procedures, declared in the module and
# defined outside it, rather than module procedures. Table 19.1 is why: a Fortran
# call to an MPI routine "shall result in a call to a procedure with one of the
# specific procedure names" it lists, which for mpi_f08 with `ignore_tkr` choice
# buffers -- scheme 1A -- is `MPI_Isend_f08`. A module procedure could carry that
# name but not the point of it: its symbol is the compiler's to mangle, where
# 19.1.5 wants a profiling routine to "provide the same specific Fortran
# procedure names and calling conventions, and therefore ... interpose itself as
# the MPI library routine". Only an external procedure has a name a linker will
# let a tool replace.
#
# So the declarations go in the module and the bodies in a file of their own,
# which is how both implementations arrange it. The two are emitted from one pass
# over the same data and so cannot disagree; `dev/check-f08-bindings.jl` compares
# them anyway, the compiler's own cross-check being only a warning.
f08_specific_interfaces = []
f08_wrapper_bodies = []

# Generic name -> its specifics, in the order they were emitted, and the guard
# that decides whether the second one exists at all. Every base name needs a
# generic now: the plain `MPI_Isend` is no longer a procedure, only the name a
# call is written with.
#
# This is the f08 module's business alone. MPI-4.0 added large counts "via
# separate additional MPI procedures in C (suffixed with `_c`) and via interface
# polymorphism in Fortran when using USE mpi_f08", and the other half of that
# sentence is "No polymorphic support for larger types is provided in Fortran
# when using mpif.h and use mpi" -- so there the two forms stay two names, and
# `gen/mpif_functions.F90` declares `MPI_Send` and `MPI_Send_c` side by side. See
# "The mpi module's `_c` names" in MISSING.md for what is unresolved about that.
# Per generic, the specific names of both preprocessor branches: (fallback,
# MPIF_HAVE_CFI). They differ only for the choice-buffer routines, whose TS
# branch carries Table 19.1's scheme-1B `_f08ts` token.
f08_generic_specifics = Dict{String,Vector{Tuple{String,String}}}()
f08_generic_guards = Dict{String,String}()
f08_generic_order = []

# The two the standard exempts, listing them as "the explicit Fortran procedures
# MPI_Op_create_c and MPI_Register_datarep_c". Both take a user callback whose
# large-count prototype differs from the small one, and, as the text puts it for
# MPI_Op_create, "interface polymorphism cannot be used to differentiate between
# the two different user callback prototypes despite their different type
# signatures".
f08_explicit_large_count = ["MPI_Op_create", "MPI_Register_datarep"]

# The TS 29113 axis: assumed-rank choice buffers for mpi_f08, under
# `#ifdef MPIF_HAVE_CFI` in the committed output, which CMakeLists.txt defines
# where its probe finds a working descriptor path. On that branch every routine
# with a choice buffer gets Table 19.1's scheme-1B specific names -- `_f08ts`,
# `_c_f08ts` -- with the buffers declared `TYPE(*), DIMENSION(..)`, INTENT and
# ASYNCHRONOUS as A.4 gives them, and the wrapper forwards the buffer to a
# bind(C) interface (module `mpif_f08_cdesc`) whose C side, in
# gen/mpif_f08_cdesc.c, receives a CFI descriptor and hands
# src/mpif_cdesc.c's walker anything noncontiguous. The `#else` branch is
# today's ignore_tkr form, byte for byte.
#
# `emit_cfi = false` turns the whole axis off and must regenerate today's
# output exactly -- flip it, regenerate, and `git diff gen/` has to be empty;
# see "A change to the generator that should not alter existing output" in
# CLAUDE.md.
emit_cfi = true

# The sentinel-translation axis. mpif's Fortran sentinels are COMMON blocks with
# addresses of their own, not objects at the ABI constants' addresses, so every
# argument that can carry one has to be translated on the way to C; see
# include/mpif_sentinels.h. This switch exists only to prove the refactor that
# introduced it: with `translate_sentinels = false` neither the hoists nor the
# wraps are emitted, and `git diff gen/` against the commit before the axis must
# be empty, which is what shows the restructuring of `buffer_hoists`,
# `rewrite_buffers` and `argv_null_sentinels` changed nothing on its own. Unlike
# `emit_cfi` this is not a permanent axis -- there is no build in which mpif does
# not translate -- so it goes away once it has done its job.
translate_sentinels = true

# The argument kinds that can carry a Fortran sentinel, and the translator each
# gets. This is the replacement for the invariant mpif used to have for free:
# while the Fortran sentinels sat *at* the C constants' addresses, forwarding one
# was translating it, and nothing could be missed. Now a missed argument is a
# silent wrong pointer, so the emission below asserts per parameter that no
# member of this set reaches `call_arguments` bare -- see
# `assert_sentinel_translated`.
#
# `LOGICAL_VOID` shares the buffer branch and is deliberately absent: it is
# `void*` in C but a plain LOGICAL in both Fortran bindings, so no sentinel can
# appear there. `C_BUFFER3`/`C_BUFFER4` are callback buffers that arrive from
# MPI; nothing generated reaches them. `ERROR_CODE` is in the set only for the
# two `array_of_errcodes` parameters, which is what having a `length` picks out --
# `ierror` has none.
sentinel_kinds = ["BUFFER", "C_BUFFER2", "STATUS", "WEIGHT",
                  "STRING_ARRAY", "STRING_2DARRAY", "ERROR_CODE"]

# How each choice buffer crosses the descriptor boundary. Four answers, and
# the dangerous ones are written down rather than inferred:
#
# - `:walk` -- the buffer owns the scalar (count, datatype) pair that follows
#   it in the argument list. A noncontiguous descriptor becomes a derived
#   datatype built from its strides, passed with count 1 and freed right after
#   the call, which is legal even for a nonblocking one: the request holds its
#   own reference. Detected from the parameter list, and the detection is
#   asserted below.
# - `:contig` -- a data buffer that cannot be walked. Three reasons, and the
#   reduction family is the load-bearing one:
#   - Every buffer of a reduction (MPI_Reduce and its relatives, named in
#     cfi_reduction_routines below): MPI-5.0 6.9.1 says "Predefined operators
#     work only with the MPI types listed in Section 6.9.2 and Section
#     6.9.4", so handing MPI_SUM a walked hvector is erroneous -- MPICH's
#     cdesc layer does exactly that and its own library then aborts with
#     "MPI_Op operation not defined for this datatype", measured here -- and
#     under a user-defined op the walked type would reach the user's
#     function in place of the type they wrote it against. The RMA
#     accumulates are different: 12.3.4 admits derived types whose basic
#     components are one predefined type, so they stay `:walk`.
#   - No scalar pair to walk with: the v/w collectives and
#     MPI_Reduce_scatter, whose counts are arrays; MPI_Pack's `outbuf` and
#     MPI_Unpack's `inbuf`, which are raw bytes.
#   - The partitioned MPI_Psend_init/MPI_Precv_init, whose pair understates
#     the buffer by the `partitions` factor and whose partitioning a walked
#     datatype could not preserve.
#   Sentinels and contiguous descriptors pass through; anything else is
#   MPI_ERR_BUFFER, loudly, where MPICH corrupts or aborts.
# - `:addr` -- address semantics: what matters is where the buffer starts,
#   not its layout. The attach family, MPI_Win_create/attach/detach,
#   MPI_Free_mem, MPI_Get_address, MPI_F_sync_reg, the six read/write `_end`
#   halves (whose data the `_begin` half described), and the single-element
#   RMA routines MPI_Compare_and_swap and MPI_Fetch_and_op.
cfi_addr_buffers = Set([
    ("MPI_Buffer_attach", "buffer"),
    ("MPI_Comm_attach_buffer", "buffer"),
    ("MPI_Session_attach_buffer", "buffer"),
    ("MPI_Free_mem", "base"),
    ("MPI_Win_attach", "base"),
    ("MPI_Win_create", "base"),
    ("MPI_Win_detach", "base"),
    ("MPI_Get_address", "location"),
    ("MPI_F_sync_reg", "buf"),
    ("MPI_File_read_all_end", "buf"),
    ("MPI_File_read_at_all_end", "buf"),
    ("MPI_File_read_ordered_end", "buf"),
    ("MPI_File_write_all_end", "buf"),
    ("MPI_File_write_at_all_end", "buf"),
    ("MPI_File_write_ordered_end", "buf"),
    ("MPI_Compare_and_swap", "origin_addr"),
    ("MPI_Compare_and_swap", "compare_addr"),
    ("MPI_Compare_and_swap", "result_addr"),
    ("MPI_Fetch_and_op", "origin_addr"),
    ("MPI_Fetch_and_op", "result_addr"),
])

# The reduction family whose every buffer is `:contig`, per the 6.9.1 rule
# quoted above. MPI_Reduce_scatter, MPI_Reduce_scatter_block and their
# variants land in the same place without being named: their counts are
# arrays or their sendbuf has no pair, so the no-pair rule already refuses
# to walk them.
cfi_reduction_routines = Set(["MPI_Allreduce", "MPI_Allreduce_init", "MPI_Iallreduce",
                              "MPI_Exscan", "MPI_Exscan_init", "MPI_Iexscan",
                              "MPI_Scan", "MPI_Scan_init", "MPI_Iscan",
                              "MPI_Reduce", "MPI_Reduce_init", "MPI_Ireduce",
                              "MPI_Reduce_local",
                              "MPI_Reduce_scatter_block", "MPI_Reduce_scatter_block_init",
                              "MPI_Ireduce_scatter_block"])

# A.4 declares most `in` buffers INTENT(IN) and these not: their pointer is
# what the routine keeps, so the caller's object is not a pure input. Found by
# holding the generated declarations to A.4 with dev/check-f08-bindings.jl,
# which is also what keeps this set honest -- an entry here that A.4 does not
# support is a reported divergence, in either direction.
cfi_no_intent_buffers = Set([
    ("MPI_Buffer_attach", "buffer"),
    ("MPI_Comm_attach_buffer", "buffer"),
    ("MPI_Session_attach_buffer", "buffer"),
    ("MPI_Win_attach", "base"),
    ("MPI_Win_create", "base"),
    ("MPI_Win_detach", "base"),
    ("MPI_Get_address", "location"),
])

cfi_scalar_count_kinds = [int_count_kinds; count_kinds; aint_count_kinds]

"""
`nothing` for a routine without choice buffers; otherwise a Dict from buffer
name to its crossing, per the taxonomy above.
"""
function cfi_classify(name, parameters)
    buffer_idxs = [i for (i, p) in enumerate(parameters) if p["kind"] == "BUFFER"]
    isempty(buffer_idxs) && return nothing
    classes = Dict{String,Any}()
    for (n, i) in enumerate(buffer_idxs)
        parname = parameters[i]["name"]
        if (name, parname) ∈ cfi_addr_buffers
            classes[parname] = (kind = :addr,)
            continue
        end
        if name ∈ ("MPI_Psend_init", "MPI_Precv_init") || name ∈ cfi_reduction_routines
            classes[parname] = (kind = :contig,)
            continue
        end
        # The region this buffer's pair would live in: strictly between it and
        # the next buffer. Only the first count-kind scalar can be the pair's
        # count, so a region that starts with a byte count and never reaches a
        # datatype -- MPI_Unpack's (insize, position) -- stays pair-less.
        hi = n < length(buffer_idxs) ? buffer_idxs[n+1] - 1 : length(parameters)
        pair = nothing
        for j in i+1:hi
            q = parameters[j]
            (q["kind"] ∈ cfi_scalar_count_kinds && q["length"] == nothing) || continue
            for k in j+1:hi
                r = parameters[k]
                if r["kind"] == "DATATYPE" && r["length"] == nothing
                    pair = (count = q["name"], datatype = r["name"])
                    break
                end
            end
            break
        end
        classes[parname] = pair == nothing ? (kind = :contig,) :
            (kind = :walk, count = pair.count, datatype = pair.datatype)
    end
    return classes
end

# The tally the classification is held to, so that a new apis.json changes it
# loudly rather than silently: counted over the classified routines after the
# main loop and compared against these, which were read off the enumeration of
# 2026-08-09 and checked by hand against the argument lists.
cfi_expected_class_counts = Dict(:walk => 116, :contig => 80, :addr => 20)
cfi_class_counts = Dict{Symbol,Int}()

# Sentinel crossings, counted the same way and for the same reason. The
# per-parameter assertion near `sentinel_kinds` proves each crossing is
# translated; this proves the *set* of crossings has not changed. An apis.json
# that adds a routine with a choice buffer, or reclassifies an argument, moves one
# of these and has to be looked at rather than absorbed.
#
# Counted once per parameter per ordinary entry point, so each figure already
# includes the `_c` and PMPI multiples, and the cdesc entry of the same iteration
# is covered by the same count. Cross-checks against the generated file, where
# each figure is the number of translator calls: 826 buffers is its 840 `void*`
# parameters less `buffer_addr`'s 12 and MPI_F_sync_reg's 2; STATUS is the 122
# `(MPI_Status*)` casts plus 18 const ones; WEIGHT is 5 parameters x {MPI_, PMPI_}
# with no `_c` forms; C_BUFFER2 is 3 routines x {plain, _c} x {MPI_, PMPI_}.
sentinel_expected_sites = Dict("BUFFER" => 826, "STATUS" => 140, "WEIGHT" => 10,
                               "STRING_ARRAY" => 2, "STRING_2DARRAY" => 2,
                               "ERROR_CODE" => 4, "C_BUFFER2" => 12)
sentinel_sites = Dict{String,Int}()

# The two routines with ASYNCHRONOUS arguments and no choice buffer --
# MPI_Comm_idup and MPI_Comm_idup_with_info, whose `newcomm` A.4 marks. They
# keep their `_f08` names, and only that one declaration is branched.
cfi_async_only_routines = Set{String}()

f08_cdesc_interfaces = []
f08_cdesc_types = Set{String}()
c_cdesc_implementations = []

# `filter(!isnothing, ...)`: the sentinel include is switched, and the switch is
# temporary; see `translate_sentinels`.
append!(c_implementations,
        filter(!isnothing,
        ["// Fortran-callable entry points, MPI_ and PMPI_ alike. See",
         "// dev/mpiapi.jl; do not edit.",
         "",
         "#include <mpif_attrs.h>",
         "#include <mpif_callbacks.h>",
         "#include <mpif_logical.h>",
         translate_sentinels ? "#include <mpif_sentinels.h>" : nothing,
         "#include <mpif_strings.h>",
         "#include <mpi.h>",
         "#include <assert.h>",
         "#include <stdint.h>",
         "#include <stdio.h>",
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
         "",
         "// And again for the PMPI wrappers: the defines above say nothing about",
         "// the token PMPI_Attr_delete. The ABI header declares all five PMPI_",
         "// names, and Open MPI defines none of them, so the redirection is as",
         "// necessary here as it is above.",
         "",
         "#undef PMPI_Attr_delete",
         "#undef PMPI_Attr_get",
         "#undef PMPI_Attr_put",
         "#undef PMPI_Keyval_create",
         "#undef PMPI_Keyval_free",
         "#define PMPI_Attr_delete PMPI_Comm_delete_attr",
         "#define PMPI_Attr_get PMPI_Comm_get_attr",
         "#define PMPI_Attr_put PMPI_Comm_set_attr",
         "#define PMPI_Keyval_create PMPI_Comm_create_keyval",
         "#define PMPI_Keyval_free PMPI_Comm_free_keyval",
]))

# The PMPI interfaces sit in this module beside the MPI ones, so `use mpi` sees
# both and mpif.h's `external :: PMPI_Wtime` finally has something to link to.
# They are not renames of their neighbours: MPI_Send and PMPI_Send are two
# Fortran names for two different C symbols, `mpi_send_` and `pmpi_send_`, and an
# interface block's own name is what the linker sees, none of these being
# BIND(C). A `PMPI_Send => MPI_Send` rename would call the wrong one, silently.
append!(f_interfaces,
        ["! Interfaces to the Fortran-callable C entry points, MPI_ and PMPI_ alike.",
         "! See dev/mpiapi.jl; do not edit.",
         "",
         "module mpif_functions",
         "  implicit none",
         "  public",
         "  save",
         "",
         "  interface",
         ])

# A second set of interfaces to the C entry points, for the routines that take a
# status or an assumed-size array of handles. They differ from the mpi module's
# only in how they spell one argument -- TYPE(MPI_Status) rather than
# INTEGER(MPI_STATUS_SIZE), TYPE(MPI_Datatype) rather than INTEGER -- which is
# what lets the f08 wrappers pass the caller's own storage to C instead of
# converting it into a temporary first. Two Fortran views of one C symbol, in two
# modules: legal, since a program uses `mpi` or `mpi_f08` and not both for the
# same call, and free on the C side, whose wrapper takes MPI_Fint* and casts it
# to MPI_Status* either way.
#
# The derived types the interfaces below name are collected as they are emitted
# and the module's `use` list written from that, so a routine that stops needing
# one stops importing it.
f08_raw_types = Set{String}()
f08_raw_interfaces = []
append!(f08_implementations_public,
        ["module mpif_f08_functions",
         "  implicit none",
         "  private",
         "  save",
         "",
         ])

# The bodies, in their own file. Each reaches C the way it always did, through
# the `mpi` module's interface to the Fortran-callable C symbol -- or through
# `mpif_f08_raw`'s, where a status is involved. As module procedures they got
# those aliases from one `use` list at module scope; as external procedures each
# names the one alias it calls, which is narrower and says what it is for.
append!(f08_wrapper_bodies,
        ["! The mpi_f08 wrappers themselves, MPI_ and PMPI_ alike, as external",
         "! procedures under the specific names of Table 19.1. Declared in",
         "! mpif_f08_functions, defined here, so that the name a call resolves to is",
         "! one a profiling layer can interpose. See dev/mpiapi.jl; do not edit.",
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

    # The TS 29113 crossing of every choice buffer here, or `nothing` for a
    # routine without one; see cfi_classify above. Classified once per routine
    # -- the answer does not depend on pmpi or embiggen -- and tallied for the
    # frozen-count check after the loop.
    cfi_classes = emit_cfi ? cfi_classify(name, parameters) : nothing
    if cfi_classes !== nothing
        for c in values(cfi_classes)
            cfi_class_counts[c.kind] = get(cfi_class_counts, c.kind, 0) + 1
        end
    elseif emit_cfi && any(get(p, "asynchronous", false) for p in parameters)
        push!(cfi_async_only_routines, name)
    end

    # Every routine is emitted twice, once under its MPI name and once under its
    # PMPI one. MPI-5.0 section 15.2 requires every MPI procedure to be reachable
    # under a second name that a profiling tool does not replace, and section
    # 19.1.5 says it again for Fortran: "for all MPI procedures, a second
    # procedure with the same calling conventions shall be supplied, except that
    # the name is modified by prefixing with the letter 'P'". The specific
    # procedure names behind those "are not specified by this standard", so the
    # only rule the two copies have to obey is that they differ.
    #
    # A second turn of the same loop rather than a second pass or a rewrite of
    # the first copy's text: the two differ in their names and in nothing else,
    # and here the name and the code that carries it are the same expression, so
    # they cannot drift.
    #
    # `name` itself is never prefixed. It is what every special case below is
    # keyed on -- the MPI_ARGV_NULL sentinels, the parameters whose leading
    # blanks are kept, MPI_Cancel's request, the string-length handshakes,
    # `f08_explicit_large_count` -- and prefixing it would make all of them
    # quietly stop matching. `P` goes on the emitted names only.
    for pmpi in [false, true], embiggen in (need_embiggen ? [false, true] : [false])
        P = pmpi ? "P" : ""
        # The C entry point called and the Fortran-callable symbol defined.
        # `pmpi_send_` calling `PMPI_Send` is the whole point: one that called
        # `MPI_Send` would not be the way past a tool that has replaced it, but a
        # second way into it.
        name_c = P * name * (embiggen ? "_c" : "")
        name_f = lowercase(name_c * "_")
        f_name = name_c
        # The `replace` is global, and safe only because no MPI routine name
        # contains "MPI" twice. It runs on the unprefixed name for that reason:
        # applied to "PMPI_Send" it would be relying on the same accident twice.
        f08_name_f = P * replace(name * (embiggen ? "_c" : ""), "MPI" => "MPIF")

        # The specific procedure name, and the generic a program writes.
        #
        # Scheme 1A of Table 19.1 puts `_f08` on the end. Section 19.1.4 gives
        # the large-count one "the same name followed by `_c`, and then suffixed
        # by the token specified in Table 19.1", hence `_c_f08` in that order --
        # which the standard's own longest-name example,
        # PMPI_Reduce_scatter_block_init_c_f08ts, spells out.
        f08_name = name_c * "_f08"
        # 19.1.4 again: the two specifics live behind one polymorphic interface,
        # so the generic is the base name. The exception is the two routines
        # whose large-count form cannot be told apart by interface polymorphism;
        # for those the standard says the large-count variant "shall be called
        # explicitly as MPI_Op_create_c (i.e., with suffix `_c`)", so the `_c`
        # name is a generic of its own. For every other routine invoking a `_c`
        # name is erroneous, and mpif does not provide one.
        f08_generic = embiggen && name ∈ f08_explicit_large_count ?
            P * name * "_c" : P * name

        state = State()
        input_arguments = []
        final_input_arguments = []
        # Each choice buffer's translated address, `q_<name>`. A list of its own
        # rather than the head of `input_conversions`, because the cdesc entry
        # rewrites every buffer reference in that list to `q_<name>` and would
        # turn the hoist into `q_buf = mpif_c_buffer(q_buf)`. The cdesc entry
        # builds its own hoists from the descriptors' base addresses and drops
        # these; see `cdesc_addresses`.
        buffer_hoists = []
        input_conversions = []
        call_arguments = []
        output_conversions = []
        f_arguments = []
        f_declarations = []
        # The same declarations as the mpi module's interface, except that a
        # status is TYPE(MPI_Status) and an assumed-size array of handles is
        # TYPE(MPI_Datatype). See `mpif_f08_raw` below.
        f_raw_declarations = []
        # Keyed on the argument name: the declaration `mpif_f08_raw` gives an
        # argument whose two spellings differ, where the difference is not the
        # textual substitution `f_raw_declarations` can make on its own.
        f_raw_overrides = Dict{String,String}()
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
                        elseif length == "*"
                            # An assumed-size array of handles goes straight
                            # through, under a TYPE(MPI_Datatype) declaration in
                            # `mpif_f08_raw`, because `$parname%MPI_VAL` on one is
                            # a component reference whose extent the compiler does
                            # not know. gfortran repacks it anyway and copies the
                            # trip count the descriptor gives -- `ubound = -1`, so
                            # zero elements -- leaving the C wrapper reading
                            # whatever is eight bytes below the incoming stack
                            # arguments. That was `tmp_ierror` and the two halves
                            # of the saved `comm` pointer, so MPI_Type_fromint was
                            # handed a stack address and MPICH's
                            # ABI_Datatype_from_mpi asserted on it.
                            #
                            # An explicit-shape array of handles has no such
                            # problem: the compiler knows `count` and copies in
                            # and out correctly, so MPI_Waitall and the seven
                            # others keep the component reference.
                            f_raw_overrides[parname] = "type(MPI_$(kind2type[kind])) :: $parname(*)"
                            push!(f08_call_arguments, "$f_argname")
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
                # A buffer arrives as the address of whatever the caller passed,
                # which may be one of mpif's three buffer sentinels. Hoist the
                # translated address into `q_<name>` rather than wrapping the
                # call argument in place: the vw collectives guard the conversion
                # of `sendtypes` on `sendbuf != MPI_IN_PLACE`, and that
                # comparison has to see the translated value too.
                nonconst_buffer = name ∈ ["MPI_Buffer_attach", "MPI_Comm_attach_buffer", "MPI_Free_mem",
                                          "MPI_Precv_init", "MPI_Session_attach_buffer", "MPI_Win_attach",
                                          "MPI_Win_create"]
                translate_buffer = translate_sentinels && kind == "BUFFER"
                buffer_arg = translate_buffer ? "q_$parname" : "$parname"
                if param_direction == "in"
                    if nonconst_buffer
                        # The buffer is declared as `in` argument, but this refers to the pointer (not the buffer data)
                        push!(input_arguments, "void* restrict const $parname")
                        translate_buffer &&
                            push!(buffer_hoists, "void* const q_$parname = mpif_c_buffer($parname);")
                    else
                        push!(input_arguments, "const void* restrict const $parname")
                        translate_buffer &&
                            push!(buffer_hoists, "const void* const q_$parname = mpif_c_cbuffer($parname);")
                    end
                    if name == "MPI_Abi_set_fortran_booleans"
                        # `mpi.h` header file lacks const qualifiers
                        push!(call_arguments, "(void*)$buffer_arg")
                    else
                        push!(call_arguments, "$buffer_arg")
                    end
                elseif param_direction ∈ ["inout", "out"]
                    push!(input_arguments, "void* restrict const $parname")
                    translate_buffer &&
                        push!(buffer_hoists, "void* const q_$parname = mpif_c_buffer($parname);")
                    push!(call_arguments, "$buffer_arg")
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
                    if translate_sentinels && kind == "C_BUFFER2"
                        # The one place a sentinel travels C to Fortran. MPI-5.0
                        # 3.6 on MPI_Buffer_detach and its two siblings: "If
                        # MPI_BUFFER_AUTOMATIC was used in the corresponding
                        # attach procedure, then MPI_BUFFER_AUTOMATIC is also
                        # returned in the detach procedure ... When using Fortran
                        # mpi_f08, the returned value is identical to
                        # c_loc(MPI_BUFFER_AUTOMATIC)." So the ABI value MPI wrote
                        # has to become the address of mpif's own object before the
                        # caller sees it. Done here rather than in the f08 wrapper,
                        # which would leave mpif.h and the mpi module disagreeing
                        # with mpi_f08 about the same routine.
                        #
                        # memcpy in both directions: A.5's binding is a choice
                        # buffer, and test/buffer_detach.f90 passes a CHARACTER
                        # array, so the storage is not necessarily aligned for a
                        # pointer. Only on success -- a failed call leaves the
                        # caller's variable alone, which it could not do if this
                        # wrote unconditionally.
                        append!(output_conversions,
                                ["if (*ierror == MPI_SUCCESS) {",
                                 "  const void* q_$parname;",
                                 "  memcpy(&q_$parname, $parname, sizeof q_$parname);",
                                 "  q_$parname = mpif_f_buffer_addr(q_$parname);",
                                 "  memcpy($parname, &q_$parname, sizeof q_$parname);",
                                 "}"])
                    end
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
                    # Three spellings of "skip TKR checking on this dummy", each
                    # a comment to the compilers that use the others:
                    # `!dir$ ignore_tkr` for flang, Cray and NVIDIA (Cray/SGI
                    # lineage, despite what the next sentinel suggests), `!gcc$`
                    # for gfortran, and `!dec$ attributes no_arg_check` for
                    # ifort and ifx, which implement neither of the first two --
                    # Intel's directive reference has no IGNORE_TKR, and MPICH's
                    # confdb/aclocal_fc.m4 keeps `dec` and `dir` as separate
                    # flavors for the same reason.
                    push!(f_declarations, "!dir\$ ignore_tkr(trk) $parname")
                    push!(f_declarations, "!gcc\$ attributes no_arg_check :: $parname")
                    push!(f_declarations, "!dec\$ attributes no_arg_check :: $parname")
                    push!(f_declarations, "integer :: $parname(*)")
                    f08_cptr = kind == "C_BUFFER2" ? "type(C_PTR), intent($f08_param_direction)" : "type(C_PTR), value"
                    push!(f08_declarations, "$f08_cptr :: $parname")
                else
                    push!(f_declarations, "!dir\$ ignore_tkr(trk) $parname")
                    push!(f_declarations, "!gcc\$ attributes no_arg_check :: $parname")
                    push!(f_declarations, "!dec\$ attributes no_arg_check :: $parname")
                    push!(f_declarations, "integer :: $parname(*)")
                    push!(f08_declarations, "!dir\$ ignore_tkr(tkr) $parname")
                    push!(f08_declarations, "!gcc\$ attributes no_arg_check :: $parname")
                    push!(f08_declarations, "!dec\$ attributes no_arg_check :: $parname")
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
                            ensure_at_root!(state, input_conversions, name, parameters)
                            push!(call_arguments,
                                  "q_at_root ? MPI_$(kind2fun[kind])_fromint(*$parname) : MPI_$(kind2null[kind])_NULL")
                        else
                            push!(call_arguments, "MPI_$(kind2fun[kind])_fromint(*$parname)")
                        end
                    elseif length == "*"
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        count = handle_array_length!(state, input_conversions, name, parname)
                        push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[$(vla_size(count))];")
                        # `sendtypes` is not read at all under MPI_IN_PLACE.
                        # MPI-5.0 6.8 on MPI_ALLTOALLW: "In such a case,
                        # sendcounts, sdispls and sendtypes are ignored." A
                        # caller who takes the standard at its word passes a
                        # one-element array, or an uninitialised one, and
                        # converting `q_group_size` of them reads past it --
                        # which is what MPICH's own vw_inplacef, vw_inplacef90,
                        # nonblocking_inpf and nonblocking_inpf90 do, the last
                        # two flakily enough to have been blamed on a defect in
                        # MPI_Type_get_contents that they never call.
                        #
                        # The neighbour forms are guarded too, 8.6 saying the
                        # option "is not meaningful for this operation" there, so
                        # a caller who passes it anyway is erroneous either way
                        # and this is one rule rather than two.
                        in_place = parname == "sendtypes" &&
                            "sendbuf" ∈ [p["name"] for p in parameters]
                        guards = String[]
                        root_only && (ensure_at_root!(state, input_conversions, name, parameters);
                                      push!(guards, "q_at_root"))
                        # Against the *translated* address: `sendbuf` is whatever
                        # Fortran handed over, `q_sendbuf` is the ABI value, and
                        # only the latter can equal MPI_IN_PLACE.
                        in_place && push!(guards,
                                          translate_sentinels ? "q_sendbuf != MPI_IN_PLACE"
                                                              : "sendbuf != MPI_IN_PLACE")
                        if isempty(guards)
                            append!(input_conversions,
                                    ["for (int rank=0; rank<$count; ++rank)",
                                     "  c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);"])
                        else
                            # Filled rather than left alone when the guard fails:
                            # MPI ignores the array, but handing it uninitialised
                            # memory is the habit that produced this defect.
                            append!(input_conversions,
                                    ["if ($(join(guards, " && "))) {",
                                     "  for (int rank=0; rank<$count; ++rank)",
                                     "    c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);",
                                     "} else {",
                                     "  for (int rank=0; rank<$count; ++rank)",
                                     "    c_$parname[rank] = MPI_$(kind2null[kind])_NULL;",
                                     "}"])
                        end
                        push!(call_arguments, "c_$parname")
                    elseif length ∈ ["count", "incount"]
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        if root_only
                            # `q_count` is zero away from the root, so the
                            # conversion loop needs no guard of its own -- and
                            # the NULL fill runs over the array's whole extent,
                            # the padding element of an otherwise zero-length VLA
                            # included, so that nothing uninitialised is handed
                            # to MPI even where MPI ignores it.
                            count = root_only_count!(state, input_conversions, name, parameters, length)
                            vla = vla_size(count)
                            append!(input_conversions,
                                    ["MPI_$(kind2type[kind]) c_$parname[$vla];",
                                     "for (int rank=0; rank<($vla); ++rank)",
                                     "  c_$parname[rank] = MPI_$(kind2null[kind])_NULL;",
                                     "for (int rank=0; rank<$count; ++rank)",
                                     "  c_$parname[rank] = MPI_$(kind2fun[kind])_fromint($parname[rank]);"])
                        else
                            push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[$(vla_size("*$length"))];")
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
                            # Initialised to the null handle: MPI leaves this
                            # unwritten on failure, and the conversion below runs
                            # unconditionally, so an uninitialised temporary would
                            # reach MPI_*_toint -- which is entitled to look a
                            # garbage handle up and abort, exactly what
                            # mpif_removed.c's MPIF_NEWTYPE_ON_SUCCESS exists to
                            # avoid. The caller's out argument is undefined on
                            # error either way; the null handle just makes it a
                            # value toint is defined on.
                            push!(input_conversions,
                                  "MPI_$(kind2type[kind]) c_$parname = MPI_$(kind2null[kind])_NULL;")
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
                            count = handle_array_length!(state, input_conversions, name, parname)
                        else
                            count = "*$length"
                        end
                        push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[$(vla_size(count))];")
                        if param_direction == "inout"
                            append!(input_conversions,
                                    ["for (int i=0; i<$count; ++i)",
                                     "  c_$parname[i] = MPI_$(kind2fun[kind])_fromint($parname[i]);"])
                        else
                            # Pre-filled with the null handle, for the same
                            # reason the scalar above is initialised -- and here
                            # the read is not confined to the failure path. The
                            # one pure-out handle array in the standard is
                            # MPI_Type_get_contents' array_of_datatypes, whose
                            # caller passes the envelope's count *or more*, and
                            # MPI writes only what the datatype has: the surplus
                            # is legitimately unwritten even on success, and the
                            # conversion below walks all of it. MPICH had the
                            # very same defect one level down, in its own ABI
                            # wrapper (pmodels/mpich#7930, fixed on `main` by
                            # 31d79547ba); relying on an implementation's fix to
                            # null the surplus would tie mpif to that
                            # implementation.
                            append!(input_conversions,
                                    ["for (int i=0; i<$count; ++i)",
                                     "  c_$parname[i] = MPI_$(kind2null[kind])_NULL;"])
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
                # A cast where the Fortran and C sentinels coincided, a
                # translation now: `status` may be MPI_STATUS_IGNORE or
                # MPI_STATUSES_IGNORE, from mpif.h or from mpi_f08 -- four
                # objects reaching this one parameter, since the f08 wrappers
                # come through `mpif_f08_raw` to the same entry point. All four
                # are null in the ABI, so one translator covers them; see
                # include/mpif_sentinels.h.
                if param_direction == "in"
                    @assert length == nothing
                    push!(input_arguments, "const MPI_Fint* restrict const $parname")
                    push!(call_arguments,
                          translate_sentinels ? "mpif_c_cstatus($parname)"
                                              : "(const MPI_Status*)$parname")
                elseif param_direction ∈ ["inout", "out"]
                    @assert length == nothing || length == "*"
                    push!(input_arguments, "MPI_Fint* restrict const $parname")
                    push!(call_arguments,
                          translate_sentinels ? "mpif_c_status($parname)"
                                              : "(MPI_Status*)$parname")
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
                                if haskey(string_length_handshake, name) && parname == string_length_handshake[name].len
                                    # The length describes the caller's string, and cannot
                                    # be passed straight through: in Fortran it counts
                                    # characters, in C it counts characters plus the
                                    # terminating NUL. It also has to be clamped. A
                                    # Fortran caller may pass a length larger than the
                                    # string it passes with it -- MPICH's own test suite
                                    # does, in f90/info/infogetstrf90.f90 -- and MPI would
                                    # then write past the end of the buffer we hand it.
                                    # `length_<str>` is the hidden length argument for the
                                    # string, and the clamp is what keeps the length we
                                    # hand MPI within the `c_<str>` allocated below.
                                    handshake = string_length_handshake[name]
                                    append!(input_conversions,
                                            ["const MPI_Fint f_$parname = *$parname;",
                                             "int c_$parname = 0;",
                                             "if (f_$parname > 0)",
                                             "  c_$parname = (size_t)f_$parname <= length_$(handshake.str)",
                                             "                  ? (int)f_$parname + 1",
                                             "                  : (int)length_$(handshake.str) + 1;"])
                                    push!(call_arguments, "&c_$parname")
                                    # MPI reports the length it needs including the NUL,
                                    # Fortran wants it without.
                                    assign = "*$parname = c_$parname > 0 ? (MPI_Fint)(c_$parname - 1) : 0;"
                                    if handshake.flag == nothing
                                        # Unconditional, as the standard states it. Not
                                        # guarded on `*ierror` either: a failed call
                                        # leaves the value undefined either way.
                                        push!(output_conversions, assign)
                                    else
                                        # MPI leaves the length alone when the key does not
                                        # exist, and so must we: after the clamp above the
                                        # value we hold is not necessarily the one the
                                        # caller passed in.
                                        append!(output_conversions,
                                                ["if ($(handshake.flag))", "  $assign"])
                                    end
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
                                                ["const int q_count = *$reported_count < *$request_count",
                                                 "                        ? *$reported_count",
                                                 "                        : *$request_count;",
                                                 "for (int i=0; i<q_count; ++i)",
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
                                ["int c_$parname[$(vla_size("*ndims"))];",
                                 "for (int dim=0; dim<*ndims; ++dim)",
                                 "  c_$parname[dim] = mpif_logical2bool($parname[dim]);"])
                        push!(call_arguments, "c_$parname")
                    elseif name == "MPI_Cart_sub" && length == "*"
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        ensure_comm!(state, input_conversions)
                        append!(input_conversions,
                                ["int ndims;",
                                 "{",
                                 "  const int q_ierror = PMPI_Cartdim_get(q_comm, &ndims);",
                                 "  if (q_ierror != MPI_SUCCESS) {",
                                 "    *ierror = q_ierror;",
                                 "    return;",
                                 "  }",
                                 "}",
                                 "int c_$parname[$(vla_size("ndims"))];",
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
                        # Initialised: MPI leaves this unwritten on failure, and
                        # an uninitialised read here is exactly what a stricter
                        # compiler or MSan flags, even though no defined
                        # behaviour changes since the caller must not look at
                        # `$parname` after a failing call either.
                        push!(input_conversions, "MPI_Fint c_$parname = 0;")
                        push!(call_arguments, "&c_$parname")
                        push!(output_conversions, "*$parname = mpif_bool2logical(c_$parname);")
                    elseif length == "maxdims"
                        # MPI_CART_GET is the only routine here: its `periods` is
                        # the one out-LOGICAL array in the standard, and so the
                        # one that needs a C temporary and a conversion back
                        # (`dims` and `coords` are INTEGER and reach MPI
                        # directly). The bound below is that routine's, so say so
                        # rather than let a later arrival inherit it silently.
                        @assert name == "MPI_Cart_get"
                        push!(input_arguments, "MPI_Fint* restrict const $parname")
                        append!(input_conversions, ["int c_$parname[$(vla_size("*maxdims"))];"])
                        # Pre-filled over the whole extent, like the handle
                        # arrays: nothing below reads an entry MPI did not write,
                        # but that argument rests on the dimensionality read back
                        # agreeing with what MPI wrote, and mpif does not depend
                        # on an implementation for that kind of thing.
                        append!(input_conversions,
                                ["for (int dim=0; dim<*maxdims; ++dim)",
                                 "  c_$parname[dim] = 0;"])
                        push!(call_arguments, "c_$parname")
                        # Only the entries MPI wrote are converted back, so the
                        # caller's surplus is left exactly as it was passed.
                        # MPI-5.0 section 8.5 requires that: "If comm is
                        # associated with a zero-dimensional Cartesian topology,
                        # MPI_CARTDIM_GET returns ndims = 0 and MPI_CART_GET will
                        # keep all output arguments unchanged", and `maxdims` may
                        # exceed the dimensionality generally, not just at zero.
                        # How many that is only the topology knows, hence the
                        # second call, and like every other probe here it goes
                        # through PMPI_ in both copies, not being a call the
                        # program made -- see the note above the helpers. Clamped
                        # to `*maxdims` because passing fewer than the topology
                        # has is "unspecified" rather than forbidden and the
                        # temporary is only that long; zero when either call
                        # failed, so a failure converts nothing at all.
                        append!(output_conversions,
                                ["int ndims_$parname = 0;",
                                 "if (*ierror == MPI_SUCCESS)",
                                 "  if (PMPI_Cartdim_get(MPI_Comm_fromint(*comm), &ndims_$parname) != MPI_SUCCESS)",
                                 "    ndims_$parname = 0;",
                                 "if (ndims_$parname > *maxdims)",
                                 "  ndims_$parname = *maxdims;",
                                 "for (int dim=0; dim<ndims_$parname; ++dim)",
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
                            ensure_at_root!(state, input_conversions, name, parameters)
                            append!(input_conversions,
                                    ["char* c_$parname = NULL;",
                                     "if (q_at_root)",
                                     "  c_$parname = $strdup_f2c($parname, length_$parname);"])
                            append!(output_conversions, ["if (q_at_root)",
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
                    # One byte more than MPI is ever told the buffer holds, set to
                    # NUL before the call, so that the `strlen` below stops inside
                    # the array whatever MPI wrote. The standard has MPI return a
                    # terminated string, but Open MPI's MPI_SESSION_GET_NTH_PSET
                    # truncates with `strncpy` and leaves none
                    # (ompi/instance/instance.c `ompi_instance_get_nth_pset`), and
                    # reading past our own array is mpif's defect then, not its
                    # excuse. Measured: AddressSanitizer reports a
                    # dynamic-stack-buffer-overflow in `strlen` without this byte.
                    #
                    # The *first* byte is NUL for a different reason: the copy-back
                    # below runs whatever the call returned, and a failing call
                    # writes no string at all, so without this `strlen` reads an
                    # uninitialised array to decide how much to hand back. This is
                    # CODE.md's "out-temporaries are initialised" applied to
                    # strings. It goes at every declaration site, including the
                    # three whose copy-back is guarded, so there is no judgement
                    # call to get wrong -- and MPI_SESSION_GET_NTH_PSET's guard
                    # tests the length the caller passed in, not whether the call
                    # succeeded, so that site needs it as much as the unguarded
                    # ones. The caller's CHARACTER is then blank-padded on
                    # failure, which it may not inspect anyway.
                    push!(input_conversions, "char c_$parname[buflen_$parname + 2];")
                    push!(input_conversions, "c_$parname[0] = '\\0';")
                    push!(input_conversions, "c_$parname[buflen_$parname + 1] = '\\0';")
                    push!(call_arguments, "c_$parname")
                    # Pad or truncate to the caller's length, never to buflen
                    copy_c2f = "mpif_strcpy_c2f($parname, c_$parname, length_$parname, strlen(c_$parname));"
                    # The routines whose string output is conditional. MPI_INFO_GET
                    # writes nothing at all when the key does not exist -- it "sets
                    # flag to false and leaves value unchanged" -- and each routine
                    # with a length handshake writes nothing when the length passed in
                    # is zero, that being the standard's own way of asking for the
                    # length alone. The caller's string has to be left untouched in
                    # those cases: `c_<str>` is still uninitialised, so copying it out
                    # would hand back garbage, and `strlen` would read uninitialised
                    # memory to decide how much of it.
                    if name == "MPI_Info_get" && parname == "value"
                        append!(output_conversions, ["if (c_flag)", "  $copy_c2f"])
                    elseif haskey(string_length_handshake, name) && parname == string_length_handshake[name].str
                        handshake = string_length_handshake[name]
                        guard = "f_$(handshake.len) > 0"
                        if handshake.flag != nothing
                            guard = "$(handshake.flag) && $guard"
                        end
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
                    ensure_at_root!(state, input_conversions, name, parameters)
                    strdup_f2c = (name, parname) ∈ strip_leading_blanks ? "mpif_strdup_f2c_trim" : "mpif_strdup_f2c"
                    sentinel = get(argv_null_sentinels, (name, parname), nothing)
                    guard = sentinel == nothing ? "q_at_root" : "q_at_root && !null_$parname"
                    if sentinel != nothing
                        push!(input_conversions,
                              translate_sentinels ?
                              "const int null_$parname = $(sentinel[1])($parname);" :
                              "const int null_$parname = (const void*)$parname == (const void*)$(sentinel[2]);")
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
                          sentinel == nothing ? "argv_$parname" : "null_$parname ? $(sentinel[2]) : argv_$parname")
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
                strdup_f2c = (name, parname) ∈ strip_leading_blanks ? "mpif_strdup_f2c_trim" : "mpif_strdup_f2c"
                sentinel = get(argv_null_sentinels, (name, parname), nothing)
                if sentinel != nothing
                    push!(input_conversions,
                          translate_sentinels ?
                              "const int null_$parname = $(sentinel[1])($parname);" :
                              "const int null_$parname = (const void*)$parname == (const void*)$(sentinel[2]);")
                end
                # The root's own count, zero elsewhere, which is what makes the
                # two VLAs and all three loops safe away from the root; the
                # rootness of the argument is in the bound rather than in a guard
                # for that reason, leaving the sentinel as the only thing left to
                # test.
                count = root_only_count!(state, input_conversions, name, parameters, length)
                vla = vla_size(count)
                # `malloc` here gets the same checked-and-abort policy as
                # `mpif_strdup_f2c`/`_trim`, which every row's strings already
                # go through: this call has the same generated-code caller with
                # no cleanup path for a mid-conversion failure, so returning
                # NULL through it would only move the crash from here into the
                # `argv_$parname[i][n] = ...` write two lines down.
                body = ["count_$parname[i] = mpif_fcount2d($parname, $count, i, length_$parname);",
                        "argv_$parname[i] = malloc((count_$parname[i] + 1) * sizeof(char*));",
                        "if (!argv_$parname[i]) {",
                        "  fprintf(stderr, \"mpif: $name: out of memory allocating %zu bytes\\n\", (count_$parname[i] + 1) * sizeof(char*));",
                        "  abort();",
                        "}",
                        "for (size_t n=0; n<count_$parname[i]; ++n)",
                        "  argv_$parname[i][n] = $strdup_f2c($parname + i * length_$parname + n * $count * length_$parname, length_$parname);",
                        "argv_$parname[i][count_$parname[i]] = NULL;"]
                append!(input_conversions,
                        ["size_t count_$parname[$vla];",
                         "char **argv_$parname[$vla];",
                         "for (int i=0; i<($vla); ++i) {",
                         "  count_$parname[i] = 0;",
                         "  argv_$parname[i] = NULL;",
                         "}"])
                if sentinel == nothing
                    append!(input_conversions,
                            ["for (int i=0; i<$count; ++i) {";
                             "  " .* body;
                             "}"])
                else
                    append!(input_conversions,
                            ["for (int i=0; i<$count; ++i) {";
                             "  if (!null_$parname) {";
                             "    " .* body;
                             "  }";
                             "}"])
                end
                push!(call_arguments,
                      sentinel == nothing ? "argv_$parname" : "null_$parname ? $(sentinel[2]) : argv_$parname")
                append!(output_conversions,
                        ["for (int i=0; i<$count; ++i) {",
                         "  for (size_t n=0; n<count_$parname[i]; ++n)",
                         "    free(argv_$parname[i][n]);",
                         "  free(argv_$parname[i]);",
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
                # Whether the callback type gains the `_c` suffix in the large form
                # is what `POLYFUNCTION` against `FUNCTION` says, the `POLY` prefix
                # meaning "plain in the small form, large in the `_c` form"
                # throughout this file. MPI_Register_datarep is where the
                # distinction does visible work: its two conversion functions are
                # POLYFUNCTION and its extent function is FUNCTION, so
                # MPI_Register_datarep_c takes MPI_Datarep_conversion_function_c
                # twice and MPI_Datarep_extent_function unchanged, which is what
                # A.4 gives it. MPI_Op_create_c is the only other case, and its
                # user_fn is POLYFUNCTION.
                #
                # Cross-checked against the prototype's own parameters, since that
                # is where a second form comes from at all: a callback has a `_c`
                # form exactly when one of its arguments embiggens, by the same
                # test `need_embiggen` applies to a routine. This replaces a
                # hardcoded exception for MPI_Datarep_extent_function, which was
                # the one FUNCTION among them and so was really this rule written
                # out for a single case.
                prototype = callback_prototypes[parameter["func_type"]]
                @assert (kind == "POLYFUNCTION") ==
                        any(startswith(p["kind"], "POLY") for p in prototype["parameters"])
                embiggen_func = embiggen && kind == "POLYFUNCTION"
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

        # Sentinel translation, in one place, for the two kinds whose emission
        # above is spread over the integer-array paths -- and the assertion, for
        # every kind in `sentinel_kinds`, that nothing reaches MPI bare.
        #
        # This is what replaces the invariant that used to hold by construction.
        # While the Fortran sentinels sat at the C constants' addresses,
        # forwarding one *was* translating it; now a parameter that slips through
        # untranslated hands MPI the address of a COMMON block full of poison, and
        # no test of the routine itself would necessarily notice. So the rule is
        # checked here rather than hoped for: a new kind in apis.json, a new
        # special case, or a refactor that drops a wrap fails the generator run.
        if translate_sentinels
            for parameter in parameters
                kind = parameter["kind"]
                parname = parameter["name"]
                kind ∈ sentinel_kinds || continue
                # `ierror` and `errorcode` are ERROR_CODE too; the array of
                # error codes MPI_Comm_spawn writes is the one with a length.
                kind == "ERROR_CODE" && parameter["length"] === nothing && continue
                # A parameter the C entry point does not take at all -- the
                # generator pushes a literal 0 or NULL for these -- has no
                # crossing to translate.
                "f90_parameter" ∈ split(parameter["suppress"]) && continue
                # Nor has a routine with no C body: MPI_F_sync_reg is a memory
                # barrier whose entry point is deliberately empty, so its buffer
                # never reaches MPI and there is nothing to translate or count.
                attributes["c_expressible"] || continue
                # A string array carries a sentinel only where one exists.
                # MPI_Comm_spawn_multiple's `array_of_commands` is a STRING_ARRAY
                # like `argv` and has none: 11.8 gives no MPI_COMMANDS_NULL.
                kind ∈ ["STRING_ARRAY", "STRING_2DARRAY"] &&
                    !haskey(argv_null_sentinels, (name, parname)) && continue

                # The two kinds whose emission is spread across the
                # integer-array paths get their wrap here.
                wrapper = kind == "WEIGHT" ? (parameter["param_direction"] == "in" ?
                                              "mpif_c_cweights" : "mpif_c_weights") :
                          kind == "ERROR_CODE" ? "mpif_c_errcodes" : nothing
                if wrapper !== nothing
                    idxs = findall(==(parname), call_arguments)
                    @assert Base.length(idxs) == 1 (name, parname, kind, call_arguments)
                    call_arguments[idxs[1]] = "$wrapper($parname)"
                end

                # And every crossing is checked, positively: the argument MPI
                # receives has to be the *translated* form for this kind, not the
                # bare name. Each kind travels its own way -- a buffer as the
                # hoisted `q_<name>`, a status and the two int-array kinds inside
                # a translator, an argument vector as the
                # `null_<name> ? <C constant> : ...` conditional that skips the
                # element-by-element conversion -- and `buffer_addr` alone crosses
                # bare, being translated after the call instead.
                expected = kind == "BUFFER" ? Regex("\\bq_$parname\\b") :
                           kind == "STATUS" ? Regex("\\bmpif_c_c?status\\($parname\\)") :
                           kind == "WEIGHT" ? Regex("\\bmpif_c_c?weights\\($parname\\)") :
                           kind == "ERROR_CODE" ? Regex("\\bmpif_c_errcodes\\($parname\\)") :
                           kind ∈ ["STRING_ARRAY", "STRING_2DARRAY"] ? Regex("\\bnull_$parname \\?") :
                           nothing
                if expected === nothing
                    @assert kind == "C_BUFFER2" (name, parname, kind)
                    @assert parname ∈ call_arguments (name, parname, call_arguments)
                    @assert any(l -> occursin("mpif_f_buffer_addr(q_$parname)", l),
                                output_conversions) (name, parname)
                else
                    @assert count(a -> occursin(expected, a), call_arguments) == 1 (name, parname, kind, call_arguments)
                    @assert parname ∉ call_arguments (name, parname, kind)
                end
                sentinel_sites[kind] = get(sentinel_sites, kind, 0) + 1
            end
        end

        # A status is eight default INTEGERs either way -- the ABI fixes
        # MPI_Status as three named ints followed by five more, and mpif fixes
        # MPI_STATUS_SIZE at 8 with MPI_SOURCE, MPI_TAG and MPI_ERROR at 1, 2 and
        # 3 -- so the f08 layer can hand the caller's own status to C instead of
        # converting into an INTEGER array first. An assumed-size array of
        # handles is the same story in one component: TYPE(MPI_Datatype) is
        # BIND(C) around one default INTEGER, so an array of them is an
        # MPI_Fint[] and the C wrapper can be handed the caller's own. What
        # neither can do is go through the mpi module's interface, which says
        # INTEGER. So those routines get a second interface to the same C entry
        # point, in `mpif_f08_raw`, differing only in how it spells that one
        # argument, and the f08 wrappers call that.
        #
        # Without it every f08 status went through a temporary, which cost three
        # defects: a one-status temporary that arrays overran, an MPI_ERROR
        # copied back from uninitialised stack, and a `loc()` comparison per call
        # to keep MPI_STATUS_IGNORE out of the conversion. The handle arrays cost
        # a fourth, above: gfortran's repack of an assumed-size component
        # reference copies nothing at all.
        f_raw_declarations = map(f_declarations) do decl
            m = match(r"^integer :: (\w+)\(MPI_STATUS_SIZE\)$", decl)
            m !== nothing && return "type(MPI_Status) :: $(m[1])"
            m = match(r"^integer :: (\w+)\(MPI_STATUS_SIZE, \*\)$", decl)
            m !== nothing && return "type(MPI_Status) :: $(m[1])(*)"
            m = match(r"^integer :: (\w+)\(", decl)
            m !== nothing && haskey(f_raw_overrides, m[1]) && return f_raw_overrides[m[1]]
            return decl
        end
        needs_raw = f_raw_declarations != f_declarations

        push!(c_implementations, "")
        push!(f_interfaces, "")

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

        # Where one entry point begins and ends, for
        # ci-scripts/split-wrappers.sh: a static build compiles each MPI_ entry
        # point as a translation unit of its own, so that a profiling wrapper can
        # replace one without clashing with the member the link needs for the
        # rest (MPI-5.0 section 15.2.1(2) and (4)). Every entry point is marked,
        # PMPI_ ones included, because the splitter's rule is that whatever lies
        # *outside* a marked region is shared prologue that every part gets a
        # copy of -- an unmarked body would be duplicated into every part after
        # it.
        push!(c_implementations, "// MPIF-SPLIT-BEGIN $name_f")
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
        if needs_raw
            # The derived types it names, which is what it has to import from the
            # host and what the module has to `use`. Read off the declarations
            # rather than tracked alongside them, so the two cannot disagree.
            imports = sort(unique([m[1] for m in
                                   (match(r"^type\((MPI_\w+)\)", decl) for decl in f_raw_declarations)
                                   if m !== nothing]))
            union!(f08_raw_types, imports)
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
            push!(f08_raw_interfaces, "       import :: $(join(imports, ", "))")
            push!(f08_raw_interfaces, "       implicit none")
            if f_unit == "function"
                push!(f08_raw_interfaces, "       $f_return_type :: result")
            end
            for decl in f_raw_declarations
                push!(f08_raw_interfaces, "       $decl")
            end
            push!(f08_raw_interfaces, "     end $f_unit $f_name")
        end

        # The one alias this wrapper's body imports, from whichever of the three
        # views of the C symbol it needs.
        #
        # `mpi` for almost every routine, because that is where the mpi module's
        # interfaces are re-exported from. But the seven `C_BUFFER` routines --
        # MPI_Alloc_mem, the three MPI_Win_allocate* and MPI_Win_shared_query,
        # with their `_c` forms -- are the only names for which `mpi` holds a
        # *generic*: src/mpif_cptr.F90 adds a TYPE(C_PTR) overload beside the
        # INTEGER(MPI_ADDRESS_KIND) one, and src/mpi.F90 puts both in an
        # interface block that carries the same name as the integer specific.
        # This wrapper wants that specific and nothing else -- it passes an
        # address-sized temporary and does the `transfer` itself -- so it takes
        # it from `mpif_functions`, where the name is a plain specific and no
        # resolution is involved.
        #
        # Which also gets it past nvfortran 26.5, which cannot resolve a call to
        # such a generic reached through a rename on `use`:
        # "NVFORTRAN-S-0155-Could not resolve generic procedure
        # 'pmpi_alloc_mem'", 14 of them, one per name. The same rename against
        # the plain specific compiles there -- src/mpif_cptr.F90 has been doing
        # it all along -- which is what says the generic is the part it cannot
        # do. See MISSING.md.
        has_c_buffer = any(p -> p["kind"] == "C_BUFFER", parameters)
        f08_use_line = if needs_raw
            "  use mpif_f08_raw, only: $f08_name_f => $f_name"
        elseif has_c_buffer
            "  use mpif_functions, only: $f08_name_f => $f_name"
        else
            "  use mpi, only: $f08_name_f => $f_name"
        end

        # ------------------------------------------------------------------
        # The TS 29113 branch of this routine: the `_f08ts` declarations, the
        # bind(C) interface and the cdesc C entry point. Everything here feeds
        # the `#ifdef MPIF_HAVE_CFI` arms emitted further down; the `#else`
        # arms are the untouched fallback.
        emit_ts = cfi_classes !== nothing
        f08_ts_name = name_c * "_f08ts"
        f08_ts_declarations = nothing
        ts_use_lines = nothing
        ts_call_arguments = nothing
        if emit_ts
            # A choice-buffer routine is a subroutine with an `ierror`, except
            # MPI_F_sync_reg, whose whole binding is `(buf)` and whose body is
            # deliberately empty. Everything below leans on that shape.
            @assert f_unit == "subroutine" name
            @assert !any(p["kind"] ∈ cptr_out_kinds && p["param_direction"] == "out"
                         for p in parameters) name
            buffer_names = Set(keys(cfi_classes))
            buffer_direction = Dict(p["name"] => p["param_direction"]
                                    for p in parameters if p["kind"] == "BUFFER")
            async_names = Set(p["name"] for p in parameters
                              if get(p, "asynchronous", false))
            root_only_of = Dict(p["name"] => p["root_only"]
                                for p in parameters if p["kind"] == "BUFFER")
            status_names = Set(p["name"] for p in parameters if p["kind"] == "STATUS")
            @assert all(p["length"] == nothing
                        for p in parameters if p["kind"] == "STATUS") name
            @assert !any(p["kind"] ∈ ["STRING_ARRAY", "STRING_2DARRAY"]
                         for p in parameters) name
            @assert all(p["param_direction"] == "in" && !p["root_only"]
                        for p in parameters
                        if p["kind"] ∈ ["ARGUMENT_LIST", "STRING"]) name
            in_strings = [p["name"] for p in parameters
                          if p["kind"] ∈ ["ARGUMENT_LIST", "STRING"]]

            # The A.4 declaration of a choice buffer: assumed type and rank,
            # INTENT(IN) where the data is a pure input, ASYNCHRONOUS where
            # apis.json marks it (which the checker holds to A.4).
            ts_buffer_decl(parname) = begin
                intent = buffer_direction[parname] == "in" &&
                    (name, parname) ∉ cfi_no_intent_buffers ? ", intent(in)" : ""
                async = parname ∈ async_names ? ", asynchronous" : ""
                "type(*), dimension(..)$intent$async :: $parname"
            end
            # A non-buffer argument A.4 marks ASYNCHRONOUS -- the persistent
            # collectives' metadata arrays -- gets the attribute spliced into
            # its fallback declaration.
            ts_async_decl(decl) = replace(decl, " :: " => ", asynchronous :: ")

            f08_ts_declarations = String[]
            replaced_buffers = 0
            for decl in f08_declarations
                if startswith(decl, "!dir\$") || startswith(decl, "!gcc\$") ||
                   startswith(decl, "!dec\$")
                    continue
                end
                m = match(r"^integer :: (\w+)\(\*\)$", decl)
                if m !== nothing && m[1] ∈ buffer_names
                    push!(f08_ts_declarations, ts_buffer_decl(m[1]))
                    replaced_buffers += 1
                    continue
                end
                m = match(r" :: (\w+)", decl)
                if m !== nothing && m[1] ∈ async_names && m[1] ∉ buffer_names
                    push!(f08_ts_declarations, ts_async_decl(decl))
                    continue
                end
                push!(f08_ts_declarations, decl)
            end
            @assert replaced_buffers == length(buffer_names) name

            # The bind(C) interface: the mpi module's view of the arguments --
            # handles as INTEGER, via f_raw_declarations so a status is
            # TYPE(MPI_Status) and a handle array TYPE(MPI_Datatype) -- with
            # the buffers assumed-rank and the strings' hidden lengths made
            # explicit, bind(C) passing none.
            cdesc_declarations = String[]
            replaced_buffers = 0
            for decl in f_raw_declarations
                if startswith(decl, "!dir\$") || startswith(decl, "!gcc\$") ||
                   startswith(decl, "!dec\$")
                    continue
                end
                m = match(r"^integer :: (\w+)\(\*\)$", decl)
                if m !== nothing && m[1] ∈ buffer_names
                    push!(cdesc_declarations, ts_buffer_decl(m[1]))
                    replaced_buffers += 1
                    continue
                end
                m = match(r"^character\*\((.*)\) :: (\w+)$", decl)
                if m !== nothing
                    @assert m[1] == "*" (name, decl)
                    @assert m[2] ∈ in_strings (name, decl)
                    push!(cdesc_declarations, "character(kind=c_char), intent(in) :: $(m[2])(*)")
                    continue
                end
                push!(cdesc_declarations, decl)
            end
            @assert replaced_buffers == length(buffer_names) name
            for s in in_strings
                push!(cdesc_declarations, "integer(c_size_t), value :: length_$s")
            end
            cdesc_args = [f_arguments; ["length_$s" for s in in_strings]]

            cdesc_name_f = "$(f08_name_f)_cdesc"
            cdesc_name_c = lowercase(name_c) * "_cdesc"
            imports = sort(unique([m[1] for m in
                                   (match(r"^type\((MPI_\w+)\)", decl) for decl in cdesc_declarations)
                                   if m !== nothing]))
            union!(f08_cdesc_types, imports)
            push!(f08_cdesc_interfaces, "")
            push!(f08_cdesc_interfaces, "     subroutine $cdesc_name_f( &")
            for (n, arg) in enumerate(cdesc_args)
                comma = n < length(cdesc_args) ? "," : ""
                push!(f08_cdesc_interfaces, "       $arg$comma &")
            end
            push!(f08_cdesc_interfaces, "     ) bind(c, name=\"$cdesc_name_c\")")
            push!(f08_cdesc_interfaces, "       use mpif_constants")
            isempty(in_strings) ||
                push!(f08_cdesc_interfaces, "       use, intrinsic :: iso_c_binding, only: c_char, c_size_t")
            isempty(imports) ||
                push!(f08_cdesc_interfaces, "       import :: $(join(imports, ", "))")
            push!(f08_cdesc_interfaces, "       implicit none")
            for decl in cdesc_declarations
                push!(f08_cdesc_interfaces, "       $decl")
            end
            push!(f08_cdesc_interfaces, "     end subroutine $cdesc_name_f")

            # What the TS wrapper body imports and passes: the cdesc alias
            # under the same local name, so the call statement is unchanged,
            # and one explicit length per string.
            ts_use_lines = ["  use mpif_f08_cdesc, only: $f08_name_f => $cdesc_name_f"]
            isempty(in_strings) ||
                push!(ts_use_lines, "  use, intrinsic :: iso_c_binding, only: c_size_t")
            ts_call_arguments = [f08_call_arguments;
                                 ["int(len($s), c_size_t)" for s in in_strings]]

            # ---- the cdesc C entry point ----
            if attributes["c_expressible"]
                cdesc_input_arguments = map(input_arguments) do arg
                    m = match(r"^(const )?void\* restrict const (\w+)$", arg)
                    if m !== nothing && m[2] ∈ buffer_names
                        return "const CFI_cdesc_t* restrict const $(m[2])"
                    end
                    m = match(r"^(const )?MPI_Fint\* restrict const (\w+)$", arg)
                    if m !== nothing && m[2] ∈ status_names
                        return "$(m[1] === nothing ? "" : m[1])MPI_Status* restrict const $(m[2])"
                    end
                    return arg
                end

                cdesc_state = deepcopy(state)
                # In this entry a buffer's name is a descriptor pointer, so
                # every reference the ordinary entry makes to the buffer --
                # the vw collectives' `sendbuf != MPI_IN_PLACE` guard on
                # converting `sendtypes` is the one that exists -- has to move
                # to the base address, `q_<name>`, declared before the
                # conversions run.
                rewrite_buffers(line) = begin
                    for p in parameters
                        p["kind"] == "BUFFER" || continue
                        line = replace(line, Regex("\\b$(p["name"])\\b") => "q_$(p["name"])")
                    end
                    line
                end
                cdesc_conversions = [rewrite_buffers(l) for l in input_conversions]
                cdesc_output_conversions = [rewrite_buffers(l) for l in output_conversions]
                cdesc_addresses = String[]
                cdesc_prologue = String[]
                cdesc_checks = String[]
                cdesc_frees = String[]
                cdesc_call_arguments = copy(call_arguments)
                walk_names = String[]

                replace_call_arg!(args, from, to) = begin
                    idxs = findall(==(from), args)
                    @assert Base.length(idxs) == 1 (name, from)
                    args[idxs[1]] = to
                end

                # Every buffer's address, and the descriptor in its place in
                # the argument list.
                # One line per buffer, and the only place this entry translates a
                # sentinel: every use downstream -- the walk and contig guards
                # below, the vw collectives' `q_sendbuf != MPI_IN_PLACE`, the
                # call argument -- reads `q_<name>`, so `mpif_cdesc_is_sentinel`
                # keeps comparing against the C constants and is once again
                # exactly right. The walker still gets the descriptor itself.
                for p in parameters
                    p["kind"] == "BUFFER" || continue
                    b = p["name"]
                    base = translate_sentinels ? "mpif_c_buffer($b->base_addr)" : "$b->base_addr"
                    push!(cdesc_addresses, "void* const q_$b = $base;")
                    # With translation on the ordinary entry already passes
                    # `q_<name>`, so there is nothing left to replace.
                    translate_sentinels || replace_call_arg!(cdesc_call_arguments, b, "q_$b")
                end
                # A status crosses this boundary as an MPI_Status* already, so
                # the ordinary entry's cast is redundant here. Its *translation*
                # is not: an f08 caller can pass either status sentinel through a
                # cdesc entry as readily as through mpif_f08_raw, so
                # mpif_c_status stays and only a bare cast is stripped -- which
                # is why this loop matches nothing once translation is on.
                for st in status_names
                    for (i, a) in enumerate(cdesc_call_arguments)
                        a == "(MPI_Status*)$st" && (cdesc_call_arguments[i] = st)
                        a == "(const MPI_Status*)$st" && (cdesc_call_arguments[i] = st)
                    end
                end

                need_err = any(c.kind != :addr for c in values(cfi_classes))
                if need_err
                    @assert any(p["name"] == "ierror" for p in parameters) name
                    pushfirst!(cdesc_addresses, "int q_cdesc_err = MPI_SUCCESS;")
                end

                # `q_at_root`, for the buffers that are significant only at
                # the root. Reuses the block the ordinary conversions already
                # emit for a root_only count or datatype, and emits it (into
                # the cdesc copy alone) where none of those exists --
                # MPI_Reduce's recvbuf is root_only while its count and
                # datatype are not.
                at_root_guard!() = begin
                    ensure_at_root!(cdesc_state, cdesc_conversions, name, parameters)
                    "q_at_root && "
                end

                for p in parameters
                    p["kind"] == "BUFFER" || continue
                    b = p["name"]
                    cls = cfi_classes[b]
                    if cls.kind == :addr
                        # Address semantics: the base address, whatever the
                        # layout.
                        continue
                    elseif cls.kind == :contig
                        guard = root_only_of[b] ? at_root_guard!() : ""
                        append!(cdesc_checks, [
                            "if ($(guard)!mpif_cdesc_is_sentinel(q_$b) && $b->rank != 0 && !CFI_is_contiguous($b))",
                            "  q_cdesc_err = MPI_ERR_BUFFER;"])
                        continue
                    end
                    @assert cls.kind == :walk
                    cnt, dt = cls.count, cls.datatype
                    dt_idxs = findall(a -> occursin("_fromint(*$dt)", a), cdesc_call_arguments)
                    @assert Base.length(dt_idxs) == 1 (name, dt)
                    dt_expr = cdesc_call_arguments[dt_idxs[1]]
                    cdesc_call_arguments[dt_idxs[1]] = "q_$(b)_type"
                    replace_call_arg!(cdesc_call_arguments, "*$cnt",
                                      embiggen ? "q_$(b)_count" : "(int)q_$(b)_count")
                    append!(cdesc_prologue, [
                        "MPI_Datatype q_$(b)_type = $dt_expr;",
                        "MPI_Count q_$(b)_count = *$cnt;",
                        "int q_$(b)_owned = 0;"])
                    push!(walk_names, b)
                    guard = root_only_of[b] ? at_root_guard!() : ""
                    append!(cdesc_checks, [
                        "if (q_cdesc_err == MPI_SUCCESS && $(guard)!mpif_cdesc_is_sentinel(q_$b) && $b->rank != 0 && !CFI_is_contiguous($b)) {",
                        "  q_cdesc_err = mpif_cdesc_create_datatype($b, q_$(b)_count, q_$(b)_type, &q_$(b)_type);",
                        "  if (q_cdesc_err == MPI_SUCCESS) {",
                        "    q_$(b)_count = 1;",
                        "    q_$(b)_owned = 1;",
                        "  }",
                        "}"])
                end

                cdesc_err_block = String[]
                if need_err
                    # The error return frees whatever the walks above created
                    # and whatever the string conversions strdup'd; the
                    # ordinary output conversions never run on this path.
                    string_frees = [l for l in output_conversions
                                    if match(r"^free\(c_\w+\);$", l) !== nothing]
                    @assert !any(occursin("q_at_root", l) for l in output_conversions if occursin("free(", l)) name
                    push!(cdesc_err_block, "if (q_cdesc_err != MPI_SUCCESS) {")
                    for b in walk_names
                        append!(cdesc_err_block, [
                            "  if (q_$(b)_owned)",
                            "    PMPI_Type_free(&q_$(b)_type);"])
                    end
                    for l in string_frees
                        push!(cdesc_err_block, "  $l")
                    end
                    append!(cdesc_err_block, ["  *ierror = q_cdesc_err;", "  return;", "}"])
                end
                for b in walk_names
                    append!(cdesc_frees, [
                        "if (q_$(b)_owned)",
                        "  PMPI_Type_free(&q_$(b)_type);"])
                end

                push!(c_cdesc_implementations, "")
                push!(c_cdesc_implementations, "void $cdesc_name_c(")
                for (n, arg) in enumerate(cdesc_input_arguments)
                    comma = n < Base.length(cdesc_input_arguments) ? "," : ""
                    push!(c_cdesc_implementations, "  $arg$comma")
                end
                push!(c_cdesc_implementations, ")")
                push!(c_cdesc_implementations, "{")
                for l in cdesc_addresses
                    push!(c_cdesc_implementations, "  $l")
                end
                for l in cdesc_conversions
                    push!(c_cdesc_implementations, "  $l")
                end
                for l in cdesc_prologue
                    push!(c_cdesc_implementations, "  $l")
                end
                for l in cdesc_checks
                    push!(c_cdesc_implementations, "  $l")
                end
                for l in cdesc_err_block
                    push!(c_cdesc_implementations, "  $l")
                end
                if any(p["name"] == "ierror" for p in parameters)
                    push!(c_cdesc_implementations, "  *ierror = $name_c(")
                else
                    push!(c_cdesc_implementations, "  $name_c(")
                end
                for (n, arg) in enumerate(cdesc_call_arguments)
                    comma = n < Base.length(cdesc_call_arguments) ? "," : ""
                    push!(c_cdesc_implementations, "    $arg$comma")
                end
                push!(c_cdesc_implementations, "  );")
                for l in cdesc_output_conversions
                    push!(c_cdesc_implementations, "  $l")
                end
                for l in cdesc_frees
                    push!(c_cdesc_implementations, "  $l")
                end
                push!(c_cdesc_implementations, "}")
            else
                # MPI_F_sync_reg: no C call to make, and the empty body is the
                # point -- an opaque call boundary the optimiser cannot see
                # through.
                push!(c_cdesc_implementations, "")
                push!(c_cdesc_implementations, "void $cdesc_name_c(")
                for (n, arg) in enumerate(input_arguments)
                    comma = n < Base.length(input_arguments) ? "," : ""
                    arg2 = replace(arg, r"^void\* restrict const" => "const CFI_cdesc_t* restrict const")
                    push!(c_cdesc_implementations, "  $arg2$comma")
                end
                push!(c_cdesc_implementations, ")")
                push!(c_cdesc_implementations, "{")
                push!(c_cdesc_implementations, "}")
            end
        end
        # ------------------------------------------------------------------
        # Only overload when Fortran can actually tell the two apart, which is a
        # question about kinds and therefore about the platform. MPICH's
        # generator applies the same test, comparing the two kinds' sizes; it
        # runs at build time and can simply look, where `gen/` is one committed
        # file compiled everywhere, so what cannot be settled here is emitted
        # under a preprocessor guard instead.
        #
        # A POLY kind that goes from default INTEGER to a count settles it: the
        # ABI's MPI_Count is int64_t whatever a pointer is. The other two kinds
        # of widening depend on the platform, and in opposite directions:
        #
        # - default INTEGER to MPI_Aint distinguishes the two only where
        #   MPI_Aint is wider than a default INTEGER, so on a 64-bit platform
        #   and not on a 32-bit one. This is `disp_unit` of MPI_Win_create,
        #   MPI_Win_allocate, MPI_Win_allocate_shared and MPI_Win_shared_query,
        #   whose only POLY parameter it is.
        # - MPI_Aint to MPI_Count distinguishes them only where MPI_Aint is
        #   narrower than MPI_Count, so on a 32-bit platform and not on a
        #   64-bit one. This is the extents of MPI_Type_get_extent,
        #   MPI_Type_get_true_extent, MPI_Type_create_resized and
        #   MPI_File_get_type_extent.
        #
        # A pointer being four bytes or eight, exactly one of those two holds on
        # any given platform, and a generic declared where it does not is
        # rejected: "Ambiguous interfaces in generic interface". A routine with
        # widenings of both sorts needs no guard, since one or the other always
        # holds.
        #
        # The guard covers the whole `_c` specific now, not just the generic that
        # would pair it: 19.1.4 says that where "the type signatures of the two
        # specific procedures are identical ... the implementation shall not
        # provide the `_c` specific procedure". Before, the specific was emitted
        # either way and only the pairing was guarded, which left a procedure
        # behind on the platform that is meant not to have one -- reachable then,
        # under the name `MPI_Type_get_extent_c`, and unreachable now, there being
        # no such generic. Emitting it would be dead code as well as non-
        # conforming.
        specific_guard = ""
        if embiggen
            kinds = [p["kind"] for p in parameters]
            widens_int_to_count = any(k -> k ∈ int_count_kinds, kinds)
            widens_int_to_aint = any(k -> k ∈ int_aint_kinds, kinds)
            widens_aint_to_count = any(k -> k ∈ aint_count_kinds, kinds)
            guard = if widens_int_to_count || (widens_int_to_aint && widens_aint_to_count)
                ""
            elseif widens_int_to_aint
                "MPIF_ADDRESS_KIND_DIFFERS_FROM_INTEGER_KIND"
            elseif widens_aint_to_count
                "MPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND"
            else
                nothing
            end
            if guard ≡ nothing
                # No parameter widens at all, so nothing could tell the two
                # apart on any platform. That is exactly the two the standard
                # exempts by name, MPI_Op_create and MPI_Register_datarep, whose
                # only POLY parameter is the callback: "interface polymorphism
                # cannot be used to differentiate between the two different user
                # callback prototypes despite their different type signatures".
                @assert name ∈ f08_explicit_large_count
            else
                @assert name ∉ f08_explicit_large_count
                # Not prefixed, and it must not be: the guard is a macro
                # CMakeLists.txt defines, and a
                # PMPIF_ADDRESS_KIND_DIFFERS_FROM_COUNT_KIND would simply never
                # be true, taking eight specifics with it without a word.
                specific_guard = guard
            end
        end

        # Register the specific under the generic a program calls it by. The
        # order matters only for reading: the small-count specific is emitted
        # first, so it comes first in the interface.
        if !haskey(f08_generic_specifics, f08_generic)
            f08_generic_specifics[f08_generic] = Tuple{String,String}[]
            push!(f08_generic_order, f08_generic)
        end
        push!(f08_generic_specifics[f08_generic], (f08_name, emit_ts ? f08_ts_name : f08_name))
        isempty(specific_guard) || (f08_generic_guards[f08_generic] = specific_guard)

        # The declaration, twice over: once as an interface body inside the
        # module and once heading the external procedure. They are the same text
        # down to the indentation, which is what the two loops below emit -- the
        # body then carries on with its locals and its call, where the interface
        # stops at the dummy arguments.
        needs_cptr = any(p -> p["kind"] ∈ cptr_out_kinds && p["param_direction"] == "out",
                         parameters)

        # The two routines with ASYNCHRONOUS arguments and no choice buffer
        # keep their `_f08` names, and only the marked declarations are
        # branched, in the interface and the body alike.
        async_only = emit_cfi && cfi_classes === nothing &&
            any(get(p, "asynchronous", false) for p in parameters)
        async_only_names = async_only ?
            Set(p["name"] for p in parameters if get(p, "asynchronous", false)) :
            Set{String}()
        emit_f08_decl!(out, indent, decl) = begin
            m = async_only ? match(r" :: (\w+)", decl) : nothing
            if m !== nothing && m[1] ∈ async_only_names
                push!(out, "#ifdef MPIF_HAVE_CFI")
                push!(out, "$indent$(replace(decl, " :: " => ", asynchronous :: "))")
                push!(out, "#else")
                push!(out, "$indent$decl")
                push!(out, "#endif")
            else
                push!(out, "$indent$decl")
            end
        end

        isempty(specific_guard) || push!(f08_specific_interfaces, "#ifdef $specific_guard")
        if emit_ts
            push!(f08_specific_interfaces, "#ifdef MPIF_HAVE_CFI")
            push!(f08_specific_interfaces, "     subroutine $f08_ts_name( &")
            for (n, arg) in enumerate(f08_arguments)
                comma = n < length(f08_arguments) ? "," : ""
                push!(f08_specific_interfaces, "       $arg$comma &")
            end
            push!(f08_specific_interfaces, "     )")
            push!(f08_specific_interfaces, "       use mpif_f08_constants")
            push!(f08_specific_interfaces, "       use mpif_f08_types")
            push!(f08_specific_interfaces, "       implicit none")
            for decl in f08_ts_declarations
                push!(f08_specific_interfaces, "       $decl")
            end
            push!(f08_specific_interfaces, "     end subroutine $f08_ts_name")
            push!(f08_specific_interfaces, "#else")
        end
        push!(f08_specific_interfaces, "     $f_unit $f08_name( &")
        for (n, arg) in enumerate(f08_arguments)
            comma = n < length(f08_arguments) ? "," : ""
            push!(f08_specific_interfaces, "       $arg$comma &")
        end
        push!(f08_specific_interfaces,
              f_unit == "function" ? "     ) result(result)" : "     )")
        push!(f08_specific_interfaces, "       use mpif_f08_constants")
        push!(f08_specific_interfaces, "       use mpif_f08_types")
        needs_cptr &&
            push!(f08_specific_interfaces, "       use, intrinsic :: iso_c_binding, only: C_PTR")
        push!(f08_specific_interfaces, "       implicit none")
        if f_unit == "function"
            push!(f08_specific_interfaces, "       $f_return_type :: result")
        end
        for decl in f08_declarations
            emit_f08_decl!(f08_specific_interfaces, "       ", decl)
        end
        push!(f08_specific_interfaces, "     end $f_unit $f08_name")
        emit_ts && push!(f08_specific_interfaces, "#endif")
        isempty(specific_guard) || push!(f08_specific_interfaces, "#endif")
        push!(f08_specific_interfaces, "")

        # The same markers as the C entry points get, and outside both #ifdefs:
        # one region holds the two spellings of one specific -- the assumed-rank
        # MPI_Send_f08ts and the ignore_tkr MPI_Send_f08 -- of which the
        # preprocessor keeps one. The region is labelled with the scheme-1A name,
        # which is the one that exists on both branches.
        push!(f08_wrapper_bodies, "! MPIF-SPLIT-BEGIN $f08_name")
        isempty(specific_guard) || push!(f08_wrapper_bodies, "#ifdef $specific_guard")
        if emit_ts
            push!(f08_wrapper_bodies, "#ifdef MPIF_HAVE_CFI")
            push!(f08_wrapper_bodies, "subroutine $f08_ts_name( &")
            for (n, arg) in enumerate(f08_arguments)
                comma = n < length(f08_arguments) ? "," : ""
                push!(f08_wrapper_bodies, "  $arg$comma &")
            end
            push!(f08_wrapper_bodies, ")")
            push!(f08_wrapper_bodies, "  use mpif_f08_constants")
            push!(f08_wrapper_bodies, "  use mpif_f08_types")
            for u in ts_use_lines
                push!(f08_wrapper_bodies, u)
            end
            push!(f08_wrapper_bodies, "  implicit none")
            # The TS declarations carry no directives, and INTENT and
            # ASYNCHRONOUS are characteristics, so the body's declarations are
            # the interface's, verbatim -- which dev/check-f08-bindings.jl
            # holds them to.
            for decl in f08_ts_declarations
                push!(f08_wrapper_bodies, "  $decl")
            end
            for decl in f08_call_temp_declarations
                push!(f08_wrapper_bodies, "  $decl")
            end
            for stmt in f08_call_temp_copyins
                push!(f08_wrapper_bodies, "  $stmt")
            end
            push!(f08_wrapper_bodies, "  call $f08_name_f( &")
            for (n, arg) in enumerate(ts_call_arguments)
                comma = n < length(ts_call_arguments) ? "," : ""
                push!(f08_wrapper_bodies, "    $arg$comma &")
            end
            push!(f08_wrapper_bodies, "  )")
            for stmt in f08_call_temp_copyouts
                push!(f08_wrapper_bodies, "  $stmt")
            end
            push!(f08_wrapper_bodies, "end subroutine $f08_ts_name")
            push!(f08_wrapper_bodies, "#else")
        end
        push!(f08_wrapper_bodies, "$f_unit $f08_name( &")
        for (n, arg) in enumerate(f08_arguments)
            comma = n < length(f08_arguments) ? "," : ""
            push!(f08_wrapper_bodies, "  $arg$comma &")
        end
        push!(f08_wrapper_bodies,
              f_unit == "function" ? ") result(result)" : ")")
        push!(f08_wrapper_bodies, "  use mpif_f08_constants")
        push!(f08_wrapper_bodies, "  use mpif_f08_types")
        push!(f08_wrapper_bodies, f08_use_line)
        needs_cptr &&
            push!(f08_wrapper_bodies, "  use, intrinsic :: iso_c_binding, only: C_PTR, C_NULL_PTR")
        push!(f08_wrapper_bodies, "  implicit none")
        if f_unit == "function"
            push!(f08_wrapper_bodies, "  $f_return_type :: result")
        end
        for decl in f08_declarations
            # The choice-buffer directives stay behind in the interface, which is
            # the only place they mean anything and, for flang, the only place
            # they are allowed: "!DIR$ IGNORE_TKR may apply only in an interface
            # or a module procedure". Both directives relax the checking a
            # *caller* gets, and a caller sees the interface; the body below just
            # forwards the address to a dummy declared the same way. While these
            # wrappers were module procedures the two were one declaration, so the
            # question did not arise.
            startswith(decl, "!dir\$") || startswith(decl, "!gcc\$") ||
                startswith(decl, "!dec\$") ||
                emit_f08_decl!(f08_wrapper_bodies, "  ", decl)
        end
        for decl in f08_call_temp_declarations
            push!(f08_wrapper_bodies, "  $decl")
        end
        for stmt in f08_call_temp_copyins
            push!(f08_wrapper_bodies, "  $stmt")
        end
        push!(f08_wrapper_bodies,
              f_unit == "function" ? "  result = $f08_name_f( &" : "  call $f08_name_f( &")
        for (n, arg) in enumerate(f08_call_arguments)
            comma = n < length(f08_call_arguments) ? "," : ""
            push!(f08_wrapper_bodies, "    $arg$comma &")
        end
        push!(f08_wrapper_bodies, "  )")
        for stmt in f08_call_temp_copyouts
            push!(f08_wrapper_bodies, "  $stmt")
        end
        push!(f08_wrapper_bodies, "end $f_unit $f08_name")
        emit_ts && push!(f08_wrapper_bodies, "#endif")
        isempty(specific_guard) || push!(f08_wrapper_bodies, "#endif")
        push!(f08_wrapper_bodies, "! MPIF-SPLIT-END")
        push!(f08_wrapper_bodies, "")

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
            # The buffer hoists come first: an input conversion may compare
            # against a translated buffer, as the vw collectives' `sendtypes`
            # guard does.
            foreach(buffer_hoists) do bh
                return push!(c_implementations, "  $bh")
            end
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
        push!(c_implementations, "// MPIF-SPLIT-END")
        push!(f_interfaces, "  end $f_unit $f_name")

    end                         # for pmpi, embiggen
end                             # for api

if emit_cfi
    # The frozen tallies, so a new apis.json reclassifies loudly; see
    # cfi_expected_class_counts above.
    @assert cfi_class_counts == cfi_expected_class_counts cfi_class_counts
    @assert cfi_async_only_routines == Set(["MPI_Comm_idup", "MPI_Comm_idup_with_info"]) cfi_async_only_routines
end

if translate_sentinels
    # Likewise for the sentinel crossings; see sentinel_expected_sites above.
    @assert sentinel_sites == sentinel_expected_sites sentinel_sites
end

append!(f_interfaces,
        ["",
         "  end interface",
         "",
         "end module mpif_functions",
         ])

# One generic per base name -- every base name, not just the overloaded ones,
# since `MPI_Isend` is no longer a procedure but only the name a call is written
# with. Where a routine has a large-count companion the generic gathers both, and
# a guarded companion makes the generic itself conditional: on the platform where
# the two signatures coincide there is one specific to gather, which is all a
# program there could pass anyway.
# One arm of a generic's interface block, for one branch's specific names. The
# choice-buffer routines have different names on the two branches, and their
# whole block is emitted once per branch under #ifdef MPIF_HAVE_CFI; everything
# else gets the one unbranched block it always had.
function emit_generic_block!(out, generic, names, guard)
    if isempty(guard)
        push!(out, "  interface $generic")
        for s in names
            push!(out, "     procedure $s")
        end
        push!(out, "  end interface $generic")
    else
        @assert length(names) == 2
        append!(out,
                ["#ifdef $guard",
                 "  interface $generic",
                 "     procedure $(names[1])",
                 "     procedure $(names[2])",
                 "  end interface $generic",
                 "#else",
                 "  interface $generic",
                 "     procedure $(names[1])",
                 "  end interface $generic",
                 "#endif"])
    end
end

for generic in sort(f08_generic_order)
    specifics = f08_generic_specifics[generic]
    guard = get(f08_generic_guards, generic, "")
    names_fallback = [s[1] for s in specifics]
    names_ts = [s[2] for s in specifics]
    if names_ts != names_fallback
        push!(f08_generic_interfaces, "#ifdef MPIF_HAVE_CFI")
        emit_generic_block!(f08_generic_interfaces, generic, names_ts, guard)
        push!(f08_generic_interfaces, "#else")
        emit_generic_block!(f08_generic_interfaces, generic, names_fallback, guard)
        push!(f08_generic_interfaces, "#endif")
    else
        emit_generic_block!(f08_generic_interfaces, generic, names_fallback, guard)
    end
    push!(f08_generic_interfaces, "")
end

# The generic is what a program calls; the specifics are public so that a
# profiling layer can name one, which is the whole point of their having the
# names Table 19.1 gives. A guarded specific is public only where it exists.
for generic in sort(f08_generic_order)
    guard = get(f08_generic_guards, generic, "")
    push!(f08_implementations_public, "  public :: $generic")
    for (n, s) in enumerate(f08_generic_specifics[generic])
        guarded = !isempty(guard) && n == 2
        guarded && push!(f08_implementations_public, "#ifdef $guard")
        if s[1] != s[2]
            push!(f08_implementations_public, "#ifdef MPIF_HAVE_CFI")
            push!(f08_implementations_public, "  public :: $(s[2])")
            push!(f08_implementations_public, "#else")
            push!(f08_implementations_public, "  public :: $(s[1])")
            push!(f08_implementations_public, "#endif")
        else
            push!(f08_implementations_public, "  public :: $(s[1])")
        end
        guarded && push!(f08_implementations_public, "#endif")
    end
end
push!(f08_implementations_public, "")

f08_raw_interfaces = [["! The mpi_f08 wrappers, MPI_ and PMPI_ alike, over a second set of interfaces",
                       "! to the same C entry points. See dev/mpiapi.jl; do not edit.",
                       "",
                       "module mpif_f08_raw",
                       "  use mpif_constants",
                       "  use mpif_f08_types, only: $(join(sort(collect(f08_raw_types)), ", "))",
                       "  implicit none",
                       "  public",
                       "  save",
                       "",
                       "  interface",
                       ];
                      f08_raw_interfaces;
                      ["",
                       "  end interface",
                       "",
                       "end module mpif_f08_raw",
                       "",
                       ]]

# The bind(C) interfaces to the cdesc entry points of gen/mpif_f08_cdesc.c,
# which the TS wrapper bodies call. The module exists only on the
# MPIF_HAVE_CFI branch, like everything that names it.
f08_cdesc_module = !emit_cfi ? [] :
    [["#ifdef MPIF_HAVE_CFI",
      "! The bind(C) interfaces to the cdesc entry points of",
      "! gen/mpif_f08_cdesc.c, which receive the choice buffers as C",
      "! descriptors. See dev/mpiapi.jl; do not edit.",
      "",
      "module mpif_f08_cdesc",
      "  use mpif_constants",
      "  use mpif_f08_types, only: $(join(sort(collect(f08_cdesc_types)), ", "))",
      "  implicit none",
      "  public",
      "  save",
      "",
      "  interface",
      ];
     f08_cdesc_interfaces;
     ["",
      "  end interface",
      "",
      "end module mpif_f08_cdesc",
      "#endif",
      "",
      ]]

# The raw interfaces come first in the file: the wrapper bodies use them.
f08_implementations = [f08_raw_interfaces;
                       f08_cdesc_module;
                       f08_implementations_public;
                       f08_generic_interfaces;
                       ["  interface"];
                       f08_specific_interfaces;
                       ["  end interface";
                        "";
                        "end module mpif_f08_functions"]]

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

println("Writing \"gen/mpif_f08_wrappers.F90\"...")
open("gen/mpif_f08_wrappers.F90", "w") do f
    for body in f08_wrapper_bodies
        println(f, body)
    end
end

# Not written at all with the axis off: the committed file then stays as it
# is, which is what lets `emit_cfi = false` plus `git diff gen/` prove the
# fallback untouched.
if emit_cfi
    println("Writing \"gen/mpif_f08_cdesc.c\"...")
    open("gen/mpif_f08_cdesc.c", "w") do f
        for line in filter(!isnothing,
                    ["// The cdesc entry points: Fortran-callable through the bind(C)",
                     "// interfaces of module mpif_f08_cdesc, taking each choice buffer as a",
                     translate_sentinels ?
                         "// CFI descriptor. Each descriptor's base address is translated once, into" :
                         "// CFI descriptor. Contiguous descriptors and the sentinels pass their",
                     translate_sentinels ?
                         "// q_<name>; a sentinel and a contiguous descriptor then pass through, and" :
                         "// base address through; anything else goes to src/mpif_cdesc.c's",
                     translate_sentinels ?
                         "// anything else goes to src/mpif_cdesc.c's walker or is refused. See" :
                         "// walker or is refused. See dev/mpiapi.jl; do not edit.",
                     translate_sentinels ? "// dev/mpiapi.jl; do not edit." : nothing,
                     "",
                     "#ifdef MPIF_HAVE_CFI",
                     "",
                     "#include <mpif_cdesc.h>",
                     translate_sentinels ? "#include <mpif_sentinels.h>" : nothing,
                     "#include <mpif_strings.h>",
                     "#include <stdlib.h>",
                     "#include <string.h>"])
            println(f, line)
        end
        for impl in c_cdesc_implementations
            println(f, impl)
        end
        for line in ["",
                     "#else",
                     "",
                     "// ISO C requires something in a translation unit.",
                     "typedef int mpif_f08_cdesc_unused;",
                     "",
                     "#endif"]
            println(f, line)
        end
    end
end

println("Done.")
