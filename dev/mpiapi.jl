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

    # "" while the MPI wrappers are being emitted and "P" while the PMPI ones
    # are, so that the probes the helpers below emit call PMPI_Comm_size in the
    # PMPI copy. A tool counting MPI_Comm_size calls should not be shown calls
    # the program never made.
    prefix::String

    State(prefix) = new(Ref(false), Ref(false), Ref(false), Ref(false), Set{String}(), prefix)
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
             "  int q_ierror = $(state.prefix)MPI_Comm_test_inter(q_comm, &q_inter);",
             "  if (q_ierror == MPI_SUCCESS)",
             "    q_ierror = q_inter ? $(state.prefix)MPI_Comm_remote_size(q_comm, &q_group_size)",
             "                       : $(state.prefix)MPI_Comm_size(q_comm, &q_group_size);",
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
             "  int q_ierror = $(state.prefix)MPI_Topo_test(q_comm, &q_topology);",
             "  if (q_ierror == MPI_SUCCESS) {",
             "    if (q_topology == MPI_CART) {",
             "      int q_ndims;",
             "      q_ierror = $(state.prefix)MPI_Cartdim_get(q_comm, &q_ndims);",
             "      if (q_ierror == MPI_SUCCESS)",
             "        q_indegree = q_outdegree = 2 * q_ndims;",
             "    } else if (q_topology == MPI_GRAPH) {",
             "      int q_neighbor_rank;",
             "      int q_nneighbors;",
             "      q_ierror = $(state.prefix)MPI_Comm_rank(q_comm, &q_neighbor_rank);",
             "      if (q_ierror == MPI_SUCCESS)",
             "        q_ierror = $(state.prefix)MPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);",
             "      if (q_ierror == MPI_SUCCESS)",
             "        q_indegree = q_outdegree = q_nneighbors;",
             "    } else if (q_topology == MPI_DIST_GRAPH) {",
             "      int q_weighted;",
             "      q_ierror = $(state.prefix)MPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);",
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
             "  int q_ierror = $(state.prefix)MPI_Comm_test_inter(q_comm, &q_inter);",
             "  if (q_ierror != MPI_SUCCESS) {",
             "    *ierror = q_ierror;",
             "    return;",
             "  }",
             "  if (q_inter) {",
             "    q_at_root = *root == MPI_ROOT;",
             "  } else {",
             "    int q_comm_rank;",
             "    q_ierror = $(state.prefix)MPI_Comm_rank(q_comm, &q_comm_rank);",
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
f08_generic_specifics = Dict{String,Vector{String}}()
f08_generic_guards = Dict{String,String}()
f08_generic_order = []

# The two the standard exempts, listing them as "the explicit Fortran procedures
# MPI_Op_create_c and MPI_Register_datarep_c". Both take a user callback whose
# large-count prototype differs from the small one, and, as the text puts it for
# MPI_Op_create, "interface polymorphism cannot be used to differentiate between
# the two different user callback prototypes despite their different type
# signatures".
f08_explicit_large_count = ["MPI_Op_create", "MPI_Register_datarep"]

append!(c_implementations,
        ["// Fortran-callable entry points, MPI_ and PMPI_ alike. See",
         "// dev/mpiapi.jl; do not edit.",
         "",
         "#include <mpif_attrs.h>",
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
])

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
    # blanks are kept, MPI_Cancel's request, MPI_Info_get_string's buflen,
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

        state = State(P)
        input_arguments = []
        final_input_arguments = []
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
                        in_place && push!(guards, "sendbuf != MPI_IN_PLACE")
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
                            count = handle_array_length!(state, input_conversions, name, parname)
                        else
                            count = "*$length"
                        end
                        push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname[$(vla_size(count))];")
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
                                 "  const int q_ierror = $(P)MPI_Cartdim_get(q_comm, &ndims);",
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
                        push!(input_arguments, "MPI_Fint* restrict const $parname")
                        append!(input_conversions, ["int c_$parname[$(vla_size("*maxdims"))];"])
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
                    ensure_at_root!(state, input_conversions, name, parameters)
                    strdup_f2c = (name, parname) ∈ strip_leading_blanks ? "mpif_strdup_f2c_trim" : "mpif_strdup_f2c"
                    sentinel = get(argv_null_sentinels, (name, parname), nothing)
                    guard = sentinel == nothing ? "q_at_root" : "q_at_root && !null_$parname"
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
                strdup_f2c = (name, parname) ∈ strip_leading_blanks ? "mpif_strdup_f2c_trim" : "mpif_strdup_f2c"
                sentinel = get(argv_null_sentinels, (name, parname), nothing)
                if sentinel != nothing
                    push!(input_conversions,
                          "const int null_$parname = (const void*)$parname == (const void*)$sentinel;")
                end
                # The root's own count, zero elsewhere, which is what makes the
                # two VLAs and all three loops safe away from the root; the
                # rootness of the argument is in the bound rather than in a guard
                # for that reason, leaving the sentinel as the only thing left to
                # test.
                count = root_only_count!(state, input_conversions, name, parameters, length)
                vla = vla_size(count)
                body = ["count_$parname[i] = mpif_fcount2d($parname, $count, i, length_$parname);",
                        "argv_$parname[i] = malloc((count_$parname[i] + 1) * sizeof(char*));",
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
                      sentinel == nothing ? "argv_$parname" : "null_$parname ? $sentinel : argv_$parname")
                append!(output_conversions,
                        ["for (int i=0; i<$count; ++i) {",
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

        # The one alias this wrapper's body imports, from whichever of the two
        # views of the C symbol it needs.
        f08_use_line = needs_raw ?
            "  use mpif_f08_raw, only: $f08_name_f => $f_name" :
            "  use mpi, only: $f08_name_f => $f_name"
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
            f08_generic_specifics[f08_generic] = String[]
            push!(f08_generic_order, f08_generic)
        end
        push!(f08_generic_specifics[f08_generic], f08_name)
        isempty(specific_guard) || (f08_generic_guards[f08_generic] = specific_guard)

        # The declaration, twice over: once as an interface body inside the
        # module and once heading the external procedure. They are the same text
        # down to the indentation, which is what the two loops below emit -- the
        # body then carries on with its locals and its call, where the interface
        # stops at the dummy arguments.
        needs_cptr = any(p -> p["kind"] ∈ cptr_out_kinds && p["param_direction"] == "out",
                         parameters)

        isempty(specific_guard) || push!(f08_specific_interfaces, "#ifdef $specific_guard")
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
            push!(f08_specific_interfaces, "       $decl")
        end
        push!(f08_specific_interfaces, "     end $f_unit $f08_name")
        isempty(specific_guard) || push!(f08_specific_interfaces, "#endif")
        push!(f08_specific_interfaces, "")

        isempty(specific_guard) || push!(f08_wrapper_bodies, "#ifdef $specific_guard")
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
                push!(f08_wrapper_bodies, "  $decl")
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
        isempty(specific_guard) || push!(f08_wrapper_bodies, "#endif")
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

    end                         # for pmpi, embiggen
end                             # for api

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
for generic in sort(f08_generic_order)
    specifics = f08_generic_specifics[generic]
    guard = get(f08_generic_guards, generic, "")
    if isempty(guard)
        append!(f08_generic_interfaces, ["  interface $generic"])
        for s in specifics
            push!(f08_generic_interfaces, "     procedure $s")
        end
        push!(f08_generic_interfaces, "  end interface $generic")
    else
        @assert length(specifics) == 2
        append!(f08_generic_interfaces,
                ["#ifdef $guard",
                 "  interface $generic",
                 "     procedure $(specifics[1])",
                 "     procedure $(specifics[2])",
                 "  end interface $generic",
                 "#else",
                 "  interface $generic",
                 "     procedure $(specifics[1])",
                 "  end interface $generic",
                 "#endif"])
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
        push!(f08_implementations_public, "  public :: $s")
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

# The raw interfaces come first in the file: the wrapper bodies use them.
f08_implementations = [f08_raw_interfaces;
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

println("Done.")
