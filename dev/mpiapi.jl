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

int_kinds = ["ACCESS_MODE", "ARGUMENT_COUNT", "ARRAY_LENGTH", "ARRAY_LENGTH_NNI", "ARRAY_LENGTH_PI", "ASSERT", "COLOR", "COMBINER",
             "COMM_COMPARISON", "COMM_SIZE", "COMM_SIZE_PI", "COORDINATE", "DEGREE", "DIMENSION", "DISTRIB_ENUM",
             "DTYPE_DISTRIBUTION", "ERROR_CLASS", "ERROR_CODE", "FILE_DESCRIPTOR", "GENERIC_DTYPE_INT", "GROUP_COMPARISON", "INDEX",
             "INFO_VALUE_LENGTH", "KEY", "KEYVAL", "KEY_INDEX", "LOCK_TYPE", "MATH", "NUM_BYTES_SMALL", "NUM_DIMS", "ORDER",
             "PARTITION", "PROCESS_GRID_SIZE", "RANK", "RANK_NNI", "RMA_DISPLACEMENT_NNI", "SPLIT_TYPE", "STRING_LENGTH", "TAG",
             "THREAD_LEVEL", "TOPOLOGY_TYPE", "TYPECLASS", "TYPECLASS_SIZE", "UPDATE_MODE", "VERSION", "WEIGHT",
             "XFER_NUM_ELEM_NNI"]
int_aint_kinds = ["POLYDISPLACEMENT", "POLYRMA_DISPLACEMENT"]
int_count_kinds = ["POLYDISPLACEMENT_COUNT", "POLYDTYPE_NUM_ELEM", "POLYDTYPE_NUM_ELEM_NNI", "POLYDTYPE_NUM_ELEM_PI",
                   "POLYNUM_BYTES", "POLYNUM_BYTES_NNI", "POLYNUM_PARAM_VALUES", "POLYXFER_NUM_ELEM", "POLYXFER_NUM_ELEM_NNI"]

aint_kinds = ["ALLOC_MEM_NUM_BYTES", "C_BUFFER", "C_BUFFER2", "C_BUFFER3", "C_BUFFER4", "DISPLACEMENT", "LOCATION_SMALL",
              "WIN_ATTACH_SIZE", "WINDOW_SIZE"]
aint_count_kinds = ["POLYDISPLACEMENT_AINT_COUNT", "POLYDISPOFFSET", "POLYDTYPE_PACK_SIZE", "POLYDTYPE_STRIDE_BYTES",
                    "POLYLOCATION"]

count_kinds = ["GENERIC_DTYPE_COUNT", "NUM_BYTES", "XFER_NUM_ELEM"]

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
#         "    *ierror = q_ierror;",
#         "    return;",
#         "  }",
#         "}",
#         "if (!q_is_set) abort();",
#     ])
#     state.have_fortran_booleans[] = true
# end

function ensure_comm!(state, input_conversions)
    state.have_comm[] && return
    append!(input_conversions, ["const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);"])
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
f08_implementations_body = []

append!(c_implementations,
        ["#include <mpif_strings.h>",
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
         "#undef MPI_Keyval_free",
         "#define MPI_Attr_delete MPI_Comm_delete_attr",
         "#define MPI_Attr_get MPI_Comm_get_attr",
         "#define MPI_Attr_put MPI_Comm_set_attr",
         "#define MPI_Keyval_free MPI_Comm_free_keyval",
         "",
         "// Work around broken MPI implementations [only MPICH]",
         "",
         # "#define MPIF_Comm_fromint MPI_Comm_fromint",
         # "#define MPIF_Comm_toint MPI_Comm_toint",
         # "#define MPIF_Errhandler_fromint MPI_Errhandler_fromint",
         # "#define MPIF_Errhandler_toint MPI_Errhandler_toint",
         # "#define MPIF_File_fromint MPI_File_fromint",
         # "#define MPIF_File_toint MPI_File_toint",
         # "#define MPIF_Group_fromint MPI_Group_fromint",
         # "#define MPIF_Group_toint MPI_Group_toint",
         # "#define MPIF_Info_fromint MPI_Info_fromint",
         # "#define MPIF_Info_toint MPI_Info_toint",
         # "#define MPIF_Message_fromint MPI_Message_fromint",
         # "#define MPIF_Message_toint MPI_Message_toint",
         # "#define MPIF_Op_fromint MPI_Op_fromint",
         # "#define MPIF_Op_toint MPI_Op_toint",
         # "#define MPIF_Request_fromint MPI_Request_fromint",
         # "#define MPIF_Request_toint MPI_Request_toint",
         # "#define MPIF_Session_fromint MPI_Session_fromint",
         # "#define MPIF_Session_toint MPI_Session_toint",
         # "#define MPIF_Type_fromint MPI_Type_fromint",
         # "#define MPIF_Type_toint MPI_Type_toint",
         # "#define MPIF_Win_fromint MPI_Win_fromint",
         # "#define MPIF_Win_toint MPI_Win_toint",
         #
         "static MPI_Comm MPIF_Comm_fromint(int comm) {",
         "  switch (comm) {",
         "  case (int)(intptr_t)MPI_COMM_NULL:",
         "  case (int)(intptr_t)MPI_COMM_WORLD:",
         "  case (int)(intptr_t)MPI_COMM_SELF:",
         "    return (MPI_Comm)(intptr_t)comm;",
         "  }",
         "  return MPI_Comm_fromint(comm);",
         "}",
         "",
         "static int MPIF_Comm_toint(MPI_Comm comm) {",
         "  switch ((intptr_t)comm) {",
         "  case (intptr_t)MPI_COMM_NULL:",
         "  case (intptr_t)MPI_COMM_WORLD:",
         "  case (intptr_t)MPI_COMM_SELF:",
         "    return (int)(intptr_t)comm;",
         "  }",
         "  return MPI_Comm_toint(comm);",
         "}",
         "",
         "static MPI_Errhandler MPIF_Errhandler_fromint(int errhandler) {",
         "  switch (errhandler) {",
         "  case (int)(intptr_t)MPI_ERRHANDLER_NULL:",
         "  case (int)(intptr_t)MPI_ERRORS_ARE_FATAL:",
         "  case (int)(intptr_t)MPI_ERRORS_ABORT:",
         "  case (int)(intptr_t)MPI_ERRORS_RETURN:",
         "    return (MPI_Errhandler)(intptr_t)errhandler;",
         "  }",
         "  return MPI_Errhandler_fromint(errhandler);",
         "}",
         "",
         "static int MPIF_Errhandler_toint(MPI_Errhandler errhandler) {",
         "  switch ((intptr_t)errhandler) {",
         "  case (intptr_t)MPI_ERRHANDLER_NULL:",
         "  case (intptr_t)MPI_ERRORS_ARE_FATAL:",
         "  case (intptr_t)MPI_ERRORS_ABORT:",
         "  case (intptr_t)MPI_ERRORS_RETURN:",
         "    return (int)(intptr_t)errhandler;",
         "  }",
         "  return MPI_Errhandler_toint(errhandler);",
         "}",
         "",
         "static MPI_File MPIF_File_fromint(int file) {",
         "  switch (file) {",
         "  case (int)(intptr_t)MPI_FILE_NULL:",
         "    return (MPI_File)(intptr_t)file;",
         "  }",
         "  return MPI_File_fromint(file);",
         "}",
         "",
         "static int MPIF_File_toint(MPI_File file) {",
         "  switch ((intptr_t)file) {",
         "  case (intptr_t)MPI_FILE_NULL:",
         "    return (int)(intptr_t)file;",
         "  }",
         "  return MPI_File_toint(file);",
         "}",
         "",
         "static MPI_Group MPIF_Group_fromint(int group) {",
         "  switch (group) {",
         "  case (int)(intptr_t)MPI_GROUP_NULL:",
         "  case (int)(intptr_t)MPI_GROUP_EMPTY:",
         "    return (MPI_Group)(intptr_t)group;",
         "  }",
         "  return MPI_Group_fromint(group);",
         "}",
         "",
         "static int MPIF_Group_toint(MPI_Group group) {",
         "  switch ((intptr_t)group) {",
         "  case (intptr_t)MPI_GROUP_NULL:",
         "  case (intptr_t)MPI_GROUP_EMPTY:",
         "    return (int)(intptr_t)group;",
         "  }",
         "  return MPI_Group_toint(group);",
         "}",
         "",
         "static MPI_Info MPIF_Info_fromint(int info) {",
         "  switch (info) {",
         "  case (int)(intptr_t)MPI_INFO_NULL:",
         "  case (int)(intptr_t)MPI_INFO_ENV:",
         "    return (MPI_Info)(intptr_t)info;",
         "  }",
         "  return MPI_Info_fromint(info);",
         "}",
         "",
         "static int MPIF_Info_toint(MPI_Info info) {",
         "  switch ((intptr_t)info) {",
         "  case (intptr_t)MPI_INFO_NULL:",
         "  case (intptr_t)MPI_INFO_ENV:",
         "    return (int)(intptr_t)info;",
         "  }",
         "  return MPI_Info_toint(info);",
         "}",
         "",
         "static MPI_Message MPIF_Message_fromint(int message) {",
         "  switch (message) {",
         "  case (int)(intptr_t)MPI_MESSAGE_NULL:",
         "  case (int)(intptr_t)MPI_MESSAGE_NO_PROC:",
         "    return (MPI_Message)(intptr_t)message;",
         "  }",
         "  return MPI_Message_fromint(message);",
         "}",
         "",
         "static int MPIF_Message_toint(MPI_Message message) {",
         "  switch ((intptr_t)message) {",
         "  case (intptr_t)MPI_MESSAGE_NULL:",
         "  case (intptr_t)MPI_MESSAGE_NO_PROC:",
         "    return (int)(intptr_t)message;",
         "  }",
         "  return MPI_Message_toint(message);",
         "}",
         "",
         "static MPI_Op MPIF_Op_fromint(int op) {",
         "  switch (op) {",
         "  case (int)(intptr_t)MPI_OP_NULL:",
         "  case (int)(intptr_t)MPI_SUM:",
         "  case (int)(intptr_t)MPI_MIN:",
         "  case (int)(intptr_t)MPI_MAX:",
         "  case (int)(intptr_t)MPI_PROD:",
         "  case (int)(intptr_t)MPI_BAND:",
         "  case (int)(intptr_t)MPI_BOR:",
         "  case (int)(intptr_t)MPI_BXOR:",
         "  case (int)(intptr_t)MPI_LAND:",
         "  case (int)(intptr_t)MPI_LOR:",
         "  case (int)(intptr_t)MPI_LXOR:",
         "  case (int)(intptr_t)MPI_MINLOC:",
         "  case (int)(intptr_t)MPI_MAXLOC:",
         "  case (int)(intptr_t)MPI_REPLACE:",
         "  case (int)(intptr_t)MPI_NO_OP:",
         "    return (MPI_Op)(intptr_t)op;",
         "  }",
         "  return MPI_Op_fromint(op);",
         "}",
         "",
         "static int MPIF_Op_toint(MPI_Op op) {",
         "  switch ((intptr_t)op) {",
         "  case (intptr_t)MPI_OP_NULL:",
         "  case (intptr_t)MPI_SUM:",
         "  case (intptr_t)MPI_MIN:",
         "  case (intptr_t)MPI_MAX:",
         "  case (intptr_t)MPI_PROD:",
         "  case (intptr_t)MPI_BAND:",
         "  case (intptr_t)MPI_BOR:",
         "  case (intptr_t)MPI_BXOR:",
         "  case (intptr_t)MPI_LAND:",
         "  case (intptr_t)MPI_LOR:",
         "  case (intptr_t)MPI_LXOR:",
         "  case (intptr_t)MPI_MINLOC:",
         "  case (intptr_t)MPI_MAXLOC:",
         "  case (intptr_t)MPI_REPLACE:",
         "  case (intptr_t)MPI_NO_OP:",
         "    return (int)(intptr_t)op;",
         "  }",
         "  return MPI_Op_toint(op);",
         "}",
         "",
         "static MPI_Request MPIF_Request_fromint(int request) {",
         "  switch (request) {",
         "  case (int)(intptr_t)MPI_REQUEST_NULL:",
         "    return (MPI_Request)(intptr_t)request;",
         "  }",
         "  return MPI_Request_fromint(request);",
         "}",
         "",
         "static int MPIF_Request_toint(MPI_Request request) {",
         "  switch ((intptr_t)request) {",
         "  case (intptr_t)MPI_REQUEST_NULL:",
         "    return (int)(intptr_t)request;",
         "  }",
         "  return MPI_Request_toint(request);",
         "}",
         "",
         "static MPI_Session MPIF_Session_fromint(int session) {",
         "  switch (session) {",
         "  case (int)(intptr_t)MPI_SESSION_NULL:",
         "    return (MPI_Session)(intptr_t)session;",
         "  }",
         "  return MPI_Session_fromint(session);",
         "}",
         "",
         "static int MPIF_Session_toint(MPI_Session session) {",
         "  switch ((intptr_t)session) {",
         "  case (intptr_t)MPI_SESSION_NULL:",
         "    return (int)(intptr_t)session;",
         "  }",
         "  return MPI_Session_toint(session);",
         "}",
         "",
         "static MPI_Datatype MPIF_Type_fromint(int type) {",
         "  switch (type) {",
         "  case (int)(intptr_t)MPI_DATATYPE_NULL:",
         "  case (int)(intptr_t)MPI_AINT:",
         "  case (int)(intptr_t)MPI_COUNT:",
         "  case (int)(intptr_t)MPI_OFFSET:",
         "  case (int)(intptr_t)MPI_PACKED:",
         "  case (int)(intptr_t)MPI_SHORT:",
         "  case (int)(intptr_t)MPI_INT:",
         "  case (int)(intptr_t)MPI_LONG:",
         "  case (int)(intptr_t)MPI_LONG_LONG:",
         "  case (int)(intptr_t)MPI_UNSIGNED_SHORT:",
         "  case (int)(intptr_t)MPI_UNSIGNED:",
         "  case (int)(intptr_t)MPI_UNSIGNED_LONG:",
         "  case (int)(intptr_t)MPI_UNSIGNED_LONG_LONG:",
         "  case (int)(intptr_t)MPI_FLOAT:",
         "  case (int)(intptr_t)MPI_C_FLOAT_COMPLEX:",
         "  case (int)(intptr_t)MPI_CXX_FLOAT_COMPLEX:",
         "  case (int)(intptr_t)MPI_DOUBLE:",
         "  case (int)(intptr_t)MPI_C_DOUBLE_COMPLEX:",
         "  case (int)(intptr_t)MPI_CXX_DOUBLE_COMPLEX:",
         "  case (int)(intptr_t)MPI_LOGICAL:",
         "  case (int)(intptr_t)MPI_INTEGER:",
         "  case (int)(intptr_t)MPI_REAL:",
         "  case (int)(intptr_t)MPI_COMPLEX:",
         "  case (int)(intptr_t)MPI_DOUBLE_PRECISION:",
         "  case (int)(intptr_t)MPI_DOUBLE_COMPLEX:",
         "  case (int)(intptr_t)MPI_CHARACTER:",
         "  case (int)(intptr_t)MPI_LONG_DOUBLE:",
         "  case (int)(intptr_t)MPI_C_LONG_DOUBLE_COMPLEX:",
         "  case (int)(intptr_t)MPI_CXX_LONG_DOUBLE_COMPLEX:",
         "  case (int)(intptr_t)MPI_FLOAT_INT:",
         "  case (int)(intptr_t)MPI_DOUBLE_INT:",
         "  case (int)(intptr_t)MPI_LONG_INT:",
         "  case (int)(intptr_t)MPI_2INT:",
         "  case (int)(intptr_t)MPI_SHORT_INT:",
         "  case (int)(intptr_t)MPI_LONG_DOUBLE_INT:",
         "  case (int)(intptr_t)MPI_2REAL:",
         "  case (int)(intptr_t)MPI_2DOUBLE_PRECISION:",
         "  case (int)(intptr_t)MPI_2INTEGER:",
         "  case (int)(intptr_t)MPI_C_BOOL:",
         "  case (int)(intptr_t)MPI_CXX_BOOL:",
         "  case (int)(intptr_t)MPI_WCHAR:",
         "  case (int)(intptr_t)MPI_INT8_T:",
         "  case (int)(intptr_t)MPI_UINT8_T:",
         "  case (int)(intptr_t)MPI_CHAR:",
         "  case (int)(intptr_t)MPI_SIGNED_CHAR:",
         "  case (int)(intptr_t)MPI_UNSIGNED_CHAR:",
         "  case (int)(intptr_t)MPI_BYTE:",
         "  case (int)(intptr_t)MPI_INT16_T:",
         "  case (int)(intptr_t)MPI_UINT16_T:",
         "  case (int)(intptr_t)MPI_INT32_T:",
         "  case (int)(intptr_t)MPI_UINT32_T:",
         "  case (int)(intptr_t)MPI_INT64_T:",
         "  case (int)(intptr_t)MPI_UINT64_T:",
         "  case (int)(intptr_t)MPI_LOGICAL1:",
         "  case (int)(intptr_t)MPI_INTEGER1:",
         "  case (int)(intptr_t)MPI_LOGICAL2:",
         "  case (int)(intptr_t)MPI_INTEGER2:",
         "  case (int)(intptr_t)MPI_REAL2:",
         "  case (int)(intptr_t)MPI_LOGICAL4:",
         "  case (int)(intptr_t)MPI_INTEGER4:",
         "  case (int)(intptr_t)MPI_REAL4:",
         "  case (int)(intptr_t)MPI_COMPLEX4:",
         "  case (int)(intptr_t)MPI_LOGICAL8:",
         "  case (int)(intptr_t)MPI_INTEGER8:",
         "  case (int)(intptr_t)MPI_REAL8:",
         "  case (int)(intptr_t)MPI_COMPLEX8:",
         "  case (int)(intptr_t)MPI_LOGICAL16:",
         "  case (int)(intptr_t)MPI_INTEGER16:",
         "  case (int)(intptr_t)MPI_REAL16:",
         "  case (int)(intptr_t)MPI_COMPLEX16:",
         "  case (int)(intptr_t)MPI_COMPLEX32:",
         "    return (MPI_Datatype)(intptr_t)type;",
         "  }",
         "  return MPI_Type_fromint(type);",
         "}",
         "",
         "static int MPIF_Type_toint(MPI_Datatype type) {",
         "  switch ((intptr_t)type) {",
         "  case (intptr_t)MPI_DATATYPE_NULL:",
         "  case (intptr_t)MPI_AINT:",
         "  case (intptr_t)MPI_COUNT:",
         "  case (intptr_t)MPI_OFFSET:",
         "  case (intptr_t)MPI_PACKED:",
         "  case (intptr_t)MPI_SHORT:",
         "  case (intptr_t)MPI_INT:",
         "  case (intptr_t)MPI_LONG:",
         "  case (intptr_t)MPI_LONG_LONG:",
         "  case (intptr_t)MPI_UNSIGNED_SHORT:",
         "  case (intptr_t)MPI_UNSIGNED:",
         "  case (intptr_t)MPI_UNSIGNED_LONG:",
         "  case (intptr_t)MPI_UNSIGNED_LONG_LONG:",
         "  case (intptr_t)MPI_FLOAT:",
         "  case (intptr_t)MPI_C_FLOAT_COMPLEX:",
         "  case (intptr_t)MPI_CXX_FLOAT_COMPLEX:",
         "  case (intptr_t)MPI_DOUBLE:",
         "  case (intptr_t)MPI_C_DOUBLE_COMPLEX:",
         "  case (intptr_t)MPI_CXX_DOUBLE_COMPLEX:",
         "  case (intptr_t)MPI_LOGICAL:",
         "  case (intptr_t)MPI_INTEGER:",
         "  case (intptr_t)MPI_REAL:",
         "  case (intptr_t)MPI_COMPLEX:",
         "  case (intptr_t)MPI_DOUBLE_PRECISION:",
         "  case (intptr_t)MPI_DOUBLE_COMPLEX:",
         "  case (intptr_t)MPI_CHARACTER:",
         "  case (intptr_t)MPI_LONG_DOUBLE:",
         "  case (intptr_t)MPI_C_LONG_DOUBLE_COMPLEX:",
         "  case (intptr_t)MPI_CXX_LONG_DOUBLE_COMPLEX:",
         "  case (intptr_t)MPI_FLOAT_INT:",
         "  case (intptr_t)MPI_DOUBLE_INT:",
         "  case (intptr_t)MPI_LONG_INT:",
         "  case (intptr_t)MPI_2INT:",
         "  case (intptr_t)MPI_SHORT_INT:",
         "  case (intptr_t)MPI_LONG_DOUBLE_INT:",
         "  case (intptr_t)MPI_2REAL:",
         "  case (intptr_t)MPI_2DOUBLE_PRECISION:",
         "  case (intptr_t)MPI_2INTEGER:",
         "  case (intptr_t)MPI_C_BOOL:",
         "  case (intptr_t)MPI_CXX_BOOL:",
         "  case (intptr_t)MPI_WCHAR:",
         "  case (intptr_t)MPI_INT8_T:",
         "  case (intptr_t)MPI_UINT8_T:",
         "  case (intptr_t)MPI_CHAR:",
         "  case (intptr_t)MPI_SIGNED_CHAR:",
         "  case (intptr_t)MPI_UNSIGNED_CHAR:",
         "  case (intptr_t)MPI_BYTE:",
         "  case (intptr_t)MPI_INT16_T:",
         "  case (intptr_t)MPI_UINT16_T:",
         "  case (intptr_t)MPI_INT32_T:",
         "  case (intptr_t)MPI_UINT32_T:",
         "  case (intptr_t)MPI_INT64_T:",
         "  case (intptr_t)MPI_UINT64_T:",
         "  case (intptr_t)MPI_LOGICAL1:",
         "  case (intptr_t)MPI_INTEGER1:",
         "  case (intptr_t)MPI_LOGICAL2:",
         "  case (intptr_t)MPI_INTEGER2:",
         "  case (intptr_t)MPI_REAL2:",
         "  case (intptr_t)MPI_LOGICAL4:",
         "  case (intptr_t)MPI_INTEGER4:",
         "  case (intptr_t)MPI_REAL4:",
         "  case (intptr_t)MPI_COMPLEX4:",
         "  case (intptr_t)MPI_LOGICAL8:",
         "  case (intptr_t)MPI_INTEGER8:",
         "  case (intptr_t)MPI_REAL8:",
         "  case (intptr_t)MPI_COMPLEX8:",
         "  case (intptr_t)MPI_LOGICAL16:",
         "  case (intptr_t)MPI_INTEGER16:",
         "  case (intptr_t)MPI_REAL16:",
         "  case (intptr_t)MPI_COMPLEX16:",
         "  case (intptr_t)MPI_COMPLEX32:",
         "    return (int)(intptr_t)type;",
         "  }",
         "  return MPI_Type_toint(type);",
         "}",
         "",
         "static MPI_Win MPIF_Win_fromint(int win) {",
         "  switch (win) {",
         "  case (int)(intptr_t)MPI_WIN_NULL:",
         "    return (MPI_Win)(intptr_t)win;",
         "  }",
         "  return MPI_Win_fromint(win);",
         "}",
         "",
         "static int MPIF_Win_toint(MPI_Win win) {",
         "  switch ((intptr_t)win) {",
         "  case (intptr_t)MPI_WIN_NULL:",
         "    return (int)(intptr_t)win;",
         "  }",
         "  return MPI_Win_toint(win);",
         "}",
])

append!(f_interfaces,
        ["module mpi_functions",
         "  implicit none",
         "  public",
         "  save",
         "",
         "  interface",
         ])

append!(f08_implementations_useonly,
        ["module mpi_f08_functions",
         "  use mpi, only: &",
         ])
append!(f08_implementations_public,
        ["    MPI_VERSION",
         "  implicit none",
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
    callback && continue
    # Predefined functions are constants
    predefined_function = attributes["predefined_function"]
    predefined_function != nothing && continue

    # Varargs cannot be forwarded
    any(p -> p["kind"] == "VARARGS", parameters) && continue

    # MPI_Sizeof needs to be implemented in Fortran
    name == "MPI_Sizeof" && continue

    need_embiggen = any(startswith(p["kind"], "POLY") for p in parameters)

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
                        push!(f08_call_arguments, "$f_argname%MPI_VAL")
                    elseif kind == "STATUS"
                        push!(f08_call_temp_declarations, "integer :: tmp_$f_argname(MPI_STATUS_SIZE)")
                        if param_direction in ["in", "inout"]
                            push!(f08_call_temp_copyins, "if (loc($f_argname) /= loc(MPI_STATUS_IGNORE)) then")
                            push!(f08_call_temp_copyins, "  call MPI_Status_f082f($f_argname, tmp_$f_argname)")
                            push!(f08_call_temp_copyins, "endif")
                        end
                        push!(f08_call_arguments, "tmp_$f_argname")
                        if param_direction in ["out", "inout"]
                            push!(f08_call_temp_copyouts, "if (loc($f_argname) /= loc(MPI_STATUS_IGNORE)) then")
                            push!(f08_call_temp_copyouts, "  call MPI_Status_f2f08(tmp_$f_argname, $f_argname)")
                            push!(f08_call_temp_copyouts, "endif")
                        end
                    else
                        push!(f08_call_arguments, "$f_argname")
                    end
                end
            end

            if kind ∈ ["BUFFER", "LOGICAL_VOID"]
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert length == nothing
                @assert !optional
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
                if false && kind == "LOGICAL_VOID"
                    push!(f_declarations, "logical :: $parname")
                    push!(f08_declarations, "logical, intent($param_direction) :: $parname")
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
                            push!(call_arguments,
                                  "q_comm_rank == 0 ? MPIF_$(kind2fun[kind])_fromint(*$parname) : MPI_$(kind2null[kind])_NULL")
                        else
                            push!(call_arguments, "MPIF_$(kind2fun[kind])_fromint(*$parname)")
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
                                     "    c_$parname[rank] = MPIF_$(kind2fun[kind])_fromint($parname[rank]);"])
                        else
                            append!(input_conversions,
                                    ["for (int rank=0; rank<q_comm_size; ++rank)",
                                     "  c_$parname[rank] = MPIF_$(kind2fun[kind])_fromint($parname[rank]);"])
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
                                     "    c_$parname[rank] = MPIF_$(kind2fun[kind])_fromint($parname[rank]);"])
                        else
                            append!(input_conversions,
                                    ["for (int rank=0; rank<*$length; ++rank)",
                                     "  c_$parname[rank] = MPIF_$(kind2fun[kind])_fromint($parname[rank]);"])
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
                    push!(output_conversions, "*$parname = MPIF_$(kind2fun[kind])_toint(c_$parname);")
                elseif param_direction == "inout"
                    @assert !root_only
                    @assert !root_only
                    push!(input_arguments, "MPI_Fint* restrict const $parname")
                    push!(input_conversions, "MPI_$(kind2type[kind]) c_$parname = MPIF_$(kind2fun[kind])_fromint(*$parname);")
                    push!(call_arguments, "&c_$(parname)")
                    push!(output_conversions, "*$parname = MPIF_$(kind2fun[kind])_toint(c_$parname);")
                else
                    @assert false
                end
                f_length = length == nothing ? "" : "(*)"
                push!(f_declarations, "integer :: $parname$f_length")
                push!(f08_declarations, "type(MPI_$(kind2type[kind])), intent($param_direction) :: $parname$f_length")
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
                push!(f_declarations, "integer :: $parname(MPI_STATUS_SIZE)")
                push!(f08_declarations, "type(MPI_Status), intent($param_direction) :: $parname")
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
                                push!(call_arguments, "$parname")
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
                        push!(f08_declarations, "$f_type$f_intent$f_optional :: $parname$f_length")
                    end
                end
            elseif kind in ["ATTRIBUTE_VAL_10"]
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
                    push!(call_arguments, "c_$parname")
                    push!(output_conversions, "*$parname = (int)(intptr_t)c_$parname;")
                else
                    @assert false
                end
                push!(f_declarations, "integer :: $parname")
                push!(f08_declarations, "integer, intent($param_direction) :: $parname")
            elseif kind in ["ATTRIBUTE_VAL", "EXTRA_STATE", "EXTRA_STATE2"]
                @assert "c_parameter" ∉ suppress
                @assert "f90_parameter" ∉ suppress
                @assert !large_only
                @assert length == nothing
                @assert !optional
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
                push!(f_declarations, "integer :: $parname")
                push!(f08_declarations, "integer, intent($param_direction) :: $parname")
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
                        push!(call_arguments, "*$parname != $fortran_false")
                    elseif length == "ndims"
                        push!(input_arguments, "const MPI_Fint* restrict const $parname")
                        append!(input_conversions,
                                ["int c_$parname[*ndims];",
                                 "for (int dim=0; dim<*ndims; ++dim)",
                                 "  c_$parname[dim] = $parname[dim] != $fortran_false;"])
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
                                 "  c_$parname[dim] = $parname[dim] != $fortran_false;"])
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
                        append!(input_conversions, ["int c_$parname[*maxdims];"])
                        push!(call_arguments, "c_$parname")
                        append!(output_conversions,
                                ["for (int dim=0; dim<*maxdims; ++dim)",
                                 "  $parname[dim] = c_$parname[dim] ? $fortran_true : $fortran_false;"])
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
                        if root_only
                            ensure_comm_rank!(state, input_conversions)
                            append!(input_conversions,
                                    ["char* c_$parname = NULL;",
                                     "if (q_comm_rank == 0)",
                                     "  c_$parname = mpif_strdup_f2c($parname, length_$parname);"])
                            append!(output_conversions, ["if (q_comm_rank == 0)",
                                                         "  free(c_$parname);"])
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
                    elseif length ∈
                           ["MPI_MAX_ERROR_STRING", "MPI_MAX_LIBRARY_VERSION_STRING", "MPI_MAX_OBJECT_NAME", "MPI_MAX_PORT_NAME",
                            "MPI_MAX_PROCESSOR_NAME"]
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
                    append!(input_conversions,
                            ["size_t count_$parname = 0;",
                             "if (q_comm_rank == 0)",
                             "  count_$parname = mpif_fcount($parname, length_$parname);",
                             "char *argv_$parname[count_$parname + 1];",
                             "for (size_t n=0; n<count_$parname; ++n)",
                             "  argv_$parname[n] = mpif_strdup_f2c($parname + n * length_$parname, length_$parname);",
                             "argv_$parname[count_$parname] = NULL;"])
                    push!(call_arguments, "argv_$parname")
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
                append!(input_conversions,
                        ["size_t count_$parname[*count];",
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
                         "}"])
                push!(call_arguments, "argv_$parname")
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
                push!(input_conversions, "abort();")
                push!(call_arguments, "$parname")
                push!(f_declarations, "external :: $parname")
                push!(f08_declarations, "procedure($func_type) :: $parname")
            else
                @show name parname kind
                @assert false
            end
        end

        input_arguments = [input_arguments; final_input_arguments]

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
        push!(f_interfaces, "    use mpi_constants")
        push!(f_interfaces, "    implicit none")
        if f_unit == "function"
            push!(f_interfaces, "    $f_return_type :: result")
        end
        for decl in f_declarations
            push!(f_interfaces, "    $decl")
        end

        push!(f08_implementations_useonly, "    $f08_name_f => $f08_name, &")
        push!(f08_implementations_public, "  public :: $f08_name")

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
        push!(f08_implementations_body, "    use mpi_f08_constants")
        push!(f08_implementations_body, "    use mpi_f08_types")
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
                push!(c_implementations, "  *ierror = $name_c(")
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
         "end module mpi_functions",
         ])

append!(f08_implementations_body,
        ["",
         "end module mpi_f08_functions",
         ])

f08_implementations = [f08_implementations_useonly; f08_implementations_public; f08_implementations_body]

println("Writing \"gen/mpif_functions.c\"...")
open("gen/mpif_functions.c", "w") do f
    for impl in c_implementations
        println(f, impl)
    end
end

println("Writing \"gen/mpi_functions.F90\"...")
open("gen/mpi_functions.F90", "w") do f
    for ifc in f_interfaces
        println(f, ifc)
    end
end

println("Writing \"gen/mpi_f08_functions.F90\"...")
open("gen/mpi_f08_functions.F90", "w") do f
    for impl in f08_implementations
        println(f, impl)
    end
end

println("Done.")
