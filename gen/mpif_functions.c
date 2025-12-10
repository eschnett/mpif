#include <mpif_strings.h>
#include <mpi.h>
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

//TODO typedef MPI_Datarep_extent_function MPI_Datarep_extent_function_c;

// Work around broken MPI implementations

static MPI_Comm MPIF_Comm_fromint(int comm) {
  switch (comm) {
  case (int)(intptr_t)MPI_COMM_NULL:
  case (int)(intptr_t)MPI_COMM_WORLD:
  case (int)(intptr_t)MPI_COMM_SELF:
    return (MPI_Comm)(intptr_t)comm;
  }
  return MPI_Comm_fromint(comm);
}

static int MPIF_Comm_toint(MPI_Comm comm) {
  switch ((intptr_t)comm) {
  case (intptr_t)MPI_COMM_NULL:
  case (intptr_t)MPI_COMM_WORLD:
  case (intptr_t)MPI_COMM_SELF:
    return (int)(intptr_t)comm;
  }
  return MPI_Comm_toint(comm);
}

static MPI_Errhandler MPIF_Errhandler_fromint(int errhandler) {
  switch (errhandler) {
  case (int)(intptr_t)MPI_ERRHANDLER_NULL:
  case (int)(intptr_t)MPI_ERRORS_ARE_FATAL:
  case (int)(intptr_t)MPI_ERRORS_ABORT:
  case (int)(intptr_t)MPI_ERRORS_RETURN:
    return (MPI_Errhandler)(intptr_t)errhandler;
  }
  return MPI_Errhandler_fromint(errhandler);
}

static int MPIF_Errhandler_toint(MPI_Errhandler errhandler) {
  switch ((intptr_t)errhandler) {
  case (intptr_t)MPI_ERRHANDLER_NULL:
  case (intptr_t)MPI_ERRORS_ARE_FATAL:
  case (intptr_t)MPI_ERRORS_ABORT:
  case (intptr_t)MPI_ERRORS_RETURN:
    return (int)(intptr_t)errhandler;
  }
  return MPI_Errhandler_toint(errhandler);
}

static MPI_File MPIF_File_fromint(int file) {
  switch (file) {
  case (int)(intptr_t)MPI_FILE_NULL:
    return (MPI_File)(intptr_t)file;
  }
  return MPI_File_fromint(file);
}

static int MPIF_File_toint(MPI_File file) {
  switch ((intptr_t)file) {
  case (intptr_t)MPI_FILE_NULL:
    return (int)(intptr_t)file;
  }
  return MPI_File_toint(file);
}

static MPI_Group MPIF_Group_fromint(int group) {
  switch (group) {
  case (int)(intptr_t)MPI_GROUP_NULL:
  case (int)(intptr_t)MPI_GROUP_EMPTY:
    return (MPI_Group)(intptr_t)group;
  }
  return MPI_Group_fromint(group);
}

static int MPIF_Group_toint(MPI_Group group) {
  switch ((intptr_t)group) {
  case (intptr_t)MPI_GROUP_NULL:
  case (intptr_t)MPI_GROUP_EMPTY:
    return (int)(intptr_t)group;
  }
  return MPI_Group_toint(group);
}

static MPI_Info MPIF_Info_fromint(int info) {
  switch (info) {
  case (int)(intptr_t)MPI_INFO_NULL:
  case (int)(intptr_t)MPI_INFO_ENV:
    return (MPI_Info)(intptr_t)info;
  }
  return MPI_Info_fromint(info);
}

static int MPIF_Info_toint(MPI_Info info) {
  switch ((intptr_t)info) {
  case (intptr_t)MPI_INFO_NULL:
  case (intptr_t)MPI_INFO_ENV:
    return (int)(intptr_t)info;
  }
  return MPI_Info_toint(info);
}

static MPI_Message MPIF_Message_fromint(int message) {
  switch (message) {
  case (int)(intptr_t)MPI_MESSAGE_NULL:
  case (int)(intptr_t)MPI_MESSAGE_NO_PROC:
    return (MPI_Message)(intptr_t)message;
  }
  return MPI_Message_fromint(message);
}

static int MPIF_Message_toint(MPI_Message message) {
  switch ((intptr_t)message) {
  case (intptr_t)MPI_MESSAGE_NULL:
  case (intptr_t)MPI_MESSAGE_NO_PROC:
    return (int)(intptr_t)message;
  }
  return MPI_Message_toint(message);
}

static MPI_Op MPIF_Op_fromint(int op) {
  switch (op) {
  case (int)(intptr_t)MPI_OP_NULL:
  case (int)(intptr_t)MPI_SUM:
  case (int)(intptr_t)MPI_MIN:
  case (int)(intptr_t)MPI_MAX:
  case (int)(intptr_t)MPI_PROD:
  case (int)(intptr_t)MPI_BAND:
  case (int)(intptr_t)MPI_BOR:
  case (int)(intptr_t)MPI_BXOR:
  case (int)(intptr_t)MPI_LAND:
  case (int)(intptr_t)MPI_LOR:
  case (int)(intptr_t)MPI_LXOR:
  case (int)(intptr_t)MPI_MINLOC:
  case (int)(intptr_t)MPI_MAXLOC:
  case (int)(intptr_t)MPI_REPLACE:
  case (int)(intptr_t)MPI_NO_OP:
    return (MPI_Op)(intptr_t)op;
  }
  return MPI_Op_fromint(op);
}

static int MPIF_Op_toint(MPI_Op op) {
  switch ((intptr_t)op) {
  case (intptr_t)MPI_OP_NULL:
  case (intptr_t)MPI_SUM:
  case (intptr_t)MPI_MIN:
  case (intptr_t)MPI_MAX:
  case (intptr_t)MPI_PROD:
  case (intptr_t)MPI_BAND:
  case (intptr_t)MPI_BOR:
  case (intptr_t)MPI_BXOR:
  case (intptr_t)MPI_LAND:
  case (intptr_t)MPI_LOR:
  case (intptr_t)MPI_LXOR:
  case (intptr_t)MPI_MINLOC:
  case (intptr_t)MPI_MAXLOC:
  case (intptr_t)MPI_REPLACE:
  case (intptr_t)MPI_NO_OP:
    return (int)(intptr_t)op;
  }
  return MPI_Op_toint(op);
}

static MPI_Request MPIF_Request_fromint(int request) {
  switch (request) {
  case (int)(intptr_t)MPI_REQUEST_NULL:
    return (MPI_Request)(intptr_t)request;
  }
  return MPI_Request_fromint(request);
}

static int MPIF_Request_toint(MPI_Request request) {
  switch ((intptr_t)request) {
  case (intptr_t)MPI_REQUEST_NULL:
    return (int)(intptr_t)request;
  }
  return MPI_Request_toint(request);
}

static MPI_Session MPIF_Session_fromint(int session) {
  switch (session) {
  case (int)(intptr_t)MPI_SESSION_NULL:
    return (MPI_Session)(intptr_t)session;
  }
  return MPI_Session_fromint(session);
}

static int MPIF_Session_toint(MPI_Session session) {
  switch ((intptr_t)session) {
  case (intptr_t)MPI_SESSION_NULL:
    return (int)(intptr_t)session;
  }
  return MPI_Session_toint(session);
}

static MPI_Datatype MPIF_Type_fromint(int type) {
  switch (type) {
  case (int)(intptr_t)MPI_DATATYPE_NULL:
  case (int)(intptr_t)MPI_AINT:
  case (int)(intptr_t)MPI_COUNT:
  case (int)(intptr_t)MPI_OFFSET:
  case (int)(intptr_t)MPI_PACKED:
  case (int)(intptr_t)MPI_SHORT:
  case (int)(intptr_t)MPI_INT:
  case (int)(intptr_t)MPI_LONG:
  case (int)(intptr_t)MPI_LONG_LONG:
  case (int)(intptr_t)MPI_UNSIGNED_SHORT:
  case (int)(intptr_t)MPI_UNSIGNED:
  case (int)(intptr_t)MPI_UNSIGNED_LONG:
  case (int)(intptr_t)MPI_UNSIGNED_LONG_LONG:
  case (int)(intptr_t)MPI_FLOAT:
  case (int)(intptr_t)MPI_C_FLOAT_COMPLEX:
  case (int)(intptr_t)MPI_CXX_FLOAT_COMPLEX:
  case (int)(intptr_t)MPI_DOUBLE:
  case (int)(intptr_t)MPI_C_DOUBLE_COMPLEX:
  case (int)(intptr_t)MPI_CXX_DOUBLE_COMPLEX:
  case (int)(intptr_t)MPI_LOGICAL:
  case (int)(intptr_t)MPI_INTEGER:
  case (int)(intptr_t)MPI_REAL:
  case (int)(intptr_t)MPI_COMPLEX:
  case (int)(intptr_t)MPI_DOUBLE_PRECISION:
  case (int)(intptr_t)MPI_DOUBLE_COMPLEX:
  case (int)(intptr_t)MPI_CHARACTER:
  case (int)(intptr_t)MPI_LONG_DOUBLE:
  case (int)(intptr_t)MPI_C_LONG_DOUBLE_COMPLEX:
  case (int)(intptr_t)MPI_CXX_LONG_DOUBLE_COMPLEX:
  case (int)(intptr_t)MPI_FLOAT_INT:
  case (int)(intptr_t)MPI_DOUBLE_INT:
  case (int)(intptr_t)MPI_LONG_INT:
  case (int)(intptr_t)MPI_2INT:
  case (int)(intptr_t)MPI_SHORT_INT:
  case (int)(intptr_t)MPI_LONG_DOUBLE_INT:
  case (int)(intptr_t)MPI_2REAL:
  case (int)(intptr_t)MPI_2DOUBLE_PRECISION:
  case (int)(intptr_t)MPI_2INTEGER:
  case (int)(intptr_t)MPI_C_BOOL:
  case (int)(intptr_t)MPI_CXX_BOOL:
  case (int)(intptr_t)MPI_WCHAR:
  case (int)(intptr_t)MPI_INT8_T:
  case (int)(intptr_t)MPI_UINT8_T:
  case (int)(intptr_t)MPI_CHAR:
  case (int)(intptr_t)MPI_SIGNED_CHAR:
  case (int)(intptr_t)MPI_UNSIGNED_CHAR:
  case (int)(intptr_t)MPI_BYTE:
  case (int)(intptr_t)MPI_INT16_T:
  case (int)(intptr_t)MPI_UINT16_T:
  case (int)(intptr_t)MPI_INT32_T:
  case (int)(intptr_t)MPI_UINT32_T:
  case (int)(intptr_t)MPI_INT64_T:
  case (int)(intptr_t)MPI_UINT64_T:
  case (int)(intptr_t)MPI_LOGICAL1:
  case (int)(intptr_t)MPI_INTEGER1:
  case (int)(intptr_t)MPI_LOGICAL2:
  case (int)(intptr_t)MPI_INTEGER2:
  case (int)(intptr_t)MPI_REAL2:
  case (int)(intptr_t)MPI_LOGICAL4:
  case (int)(intptr_t)MPI_INTEGER4:
  case (int)(intptr_t)MPI_REAL4:
  case (int)(intptr_t)MPI_COMPLEX4:
  case (int)(intptr_t)MPI_LOGICAL8:
  case (int)(intptr_t)MPI_INTEGER8:
  case (int)(intptr_t)MPI_REAL8:
  case (int)(intptr_t)MPI_COMPLEX8:
  case (int)(intptr_t)MPI_LOGICAL16:
  case (int)(intptr_t)MPI_INTEGER16:
  case (int)(intptr_t)MPI_REAL16:
  case (int)(intptr_t)MPI_COMPLEX16:
  case (int)(intptr_t)MPI_COMPLEX32:
    return (MPI_Datatype)(intptr_t)type;
  // case (int)(intptr_t)MPI_INTEGER:           return MPI_INT;
  // case (int)(intptr_t)MPI_REAL:              return MPI_FLOAT;
  // case (int)(intptr_t)MPI_COMPLEX:           return MPI_C_FLOAT_COMPLEX;
  // case (int)(intptr_t)MPI_DOUBLE_PRECISION:  return MPI_DOUBLE;
  // case (int)(intptr_t)MPI_DOUBLE_COMPLEX:    return MPI_C_DOUBLE_COMPLEX;
  // case (int)(intptr_t)MPI_CHARACTER:         return MPI_CHAR;
  // case (int)(intptr_t)MPI_2REAL:             abort();
  // case (int)(intptr_t)MPI_2DOUBLE_PRECISION: abort();
  // case (int)(intptr_t)MPI_2INTEGER:          return MPI_2INT;
  // case (int)(intptr_t)MPI_LOGICAL1:          abort();
  // case (int)(intptr_t)MPI_INTEGER1:          return MPI_INT8_T;
  // case (int)(intptr_t)MPI_LOGICAL2:          abort();
  // case (int)(intptr_t)MPI_INTEGER2:          return MPI_INT16_T;
  // case (int)(intptr_t)MPI_REAL2:             abort();
  // case (int)(intptr_t)MPI_LOGICAL4:          abort();
  // case (int)(intptr_t)MPI_INTEGER4:          return MPI_INT32_T;
  // case (int)(intptr_t)MPI_REAL4:             return MPI_FLOAT;
  // case (int)(intptr_t)MPI_COMPLEX4:          abort();
  // case (int)(intptr_t)MPI_LOGICAL8:          abort();
  // case (int)(intptr_t)MPI_INTEGER8:          return MPI_INT64_T;
  // case (int)(intptr_t)MPI_REAL8:             return MPI_DOUBLE;
  // case (int)(intptr_t)MPI_COMPLEX8:          return MPI_C_FLOAT_COMPLEX;
  // case (int)(intptr_t)MPI_LOGICAL16:         abort();
  // case (int)(intptr_t)MPI_INTEGER16:         abort();
  // case (int)(intptr_t)MPI_REAL16:            abort();
  // case (int)(intptr_t)MPI_COMPLEX16:         return MPI_C_DOUBLE_COMPLEX;
  // case (int)(intptr_t)MPI_COMPLEX32:         abort();
  }
  return MPI_Type_fromint(type);
}

static int MPIF_Type_toint(MPI_Datatype type) {
  switch ((intptr_t)type) {
  case (intptr_t)MPI_DATATYPE_NULL:
  case (intptr_t)MPI_AINT:
  case (intptr_t)MPI_COUNT:
  case (intptr_t)MPI_OFFSET:
  case (intptr_t)MPI_PACKED:
  case (intptr_t)MPI_SHORT:
  case (intptr_t)MPI_INT:
  case (intptr_t)MPI_LONG:
  case (intptr_t)MPI_LONG_LONG:
  case (intptr_t)MPI_UNSIGNED_SHORT:
  case (intptr_t)MPI_UNSIGNED:
  case (intptr_t)MPI_UNSIGNED_LONG:
  case (intptr_t)MPI_UNSIGNED_LONG_LONG:
  case (intptr_t)MPI_FLOAT:
  case (intptr_t)MPI_C_FLOAT_COMPLEX:
  case (intptr_t)MPI_CXX_FLOAT_COMPLEX:
  case (intptr_t)MPI_DOUBLE:
  case (intptr_t)MPI_C_DOUBLE_COMPLEX:
  case (intptr_t)MPI_CXX_DOUBLE_COMPLEX:
  case (intptr_t)MPI_LOGICAL:
  case (intptr_t)MPI_INTEGER:
  case (intptr_t)MPI_REAL:
  case (intptr_t)MPI_COMPLEX:
  case (intptr_t)MPI_DOUBLE_PRECISION:
  case (intptr_t)MPI_DOUBLE_COMPLEX:
  case (intptr_t)MPI_CHARACTER:
  case (intptr_t)MPI_LONG_DOUBLE:
  case (intptr_t)MPI_C_LONG_DOUBLE_COMPLEX:
  case (intptr_t)MPI_CXX_LONG_DOUBLE_COMPLEX:
  case (intptr_t)MPI_FLOAT_INT:
  case (intptr_t)MPI_DOUBLE_INT:
  case (intptr_t)MPI_LONG_INT:
  case (intptr_t)MPI_2INT:
  case (intptr_t)MPI_SHORT_INT:
  case (intptr_t)MPI_LONG_DOUBLE_INT:
  case (intptr_t)MPI_2REAL:
  case (intptr_t)MPI_2DOUBLE_PRECISION:
  case (intptr_t)MPI_2INTEGER:
  case (intptr_t)MPI_C_BOOL:
  case (intptr_t)MPI_CXX_BOOL:
  case (intptr_t)MPI_WCHAR:
  case (intptr_t)MPI_INT8_T:
  case (intptr_t)MPI_UINT8_T:
  case (intptr_t)MPI_CHAR:
  case (intptr_t)MPI_SIGNED_CHAR:
  case (intptr_t)MPI_UNSIGNED_CHAR:
  case (intptr_t)MPI_BYTE:
  case (intptr_t)MPI_INT16_T:
  case (intptr_t)MPI_UINT16_T:
  case (intptr_t)MPI_INT32_T:
  case (intptr_t)MPI_UINT32_T:
  case (intptr_t)MPI_INT64_T:
  case (intptr_t)MPI_UINT64_T:
  case (intptr_t)MPI_LOGICAL1:
  case (intptr_t)MPI_INTEGER1:
  case (intptr_t)MPI_LOGICAL2:
  case (intptr_t)MPI_INTEGER2:
  case (intptr_t)MPI_REAL2:
  case (intptr_t)MPI_LOGICAL4:
  case (intptr_t)MPI_INTEGER4:
  case (intptr_t)MPI_REAL4:
  case (intptr_t)MPI_COMPLEX4:
  case (intptr_t)MPI_LOGICAL8:
  case (intptr_t)MPI_INTEGER8:
  case (intptr_t)MPI_REAL8:
  case (intptr_t)MPI_COMPLEX8:
  case (intptr_t)MPI_LOGICAL16:
  case (intptr_t)MPI_INTEGER16:
  case (intptr_t)MPI_REAL16:
  case (intptr_t)MPI_COMPLEX16:
  case (intptr_t)MPI_COMPLEX32:
    return (int)(intptr_t)type;
  }
  return MPI_Type_toint(type);
}

static MPI_Win MPIF_Win_fromint(int win) {
  switch (win) {
  case (int)(intptr_t)MPI_WIN_NULL:
    return (MPI_Win)(intptr_t)win;
  }
  return MPI_Win_fromint(win);
}

static int MPIF_Win_toint(MPI_Win win) {
  switch ((intptr_t)win) {
  case (intptr_t)MPI_WIN_NULL:
    return (int)(intptr_t)win;
  }
  return MPI_Win_toint(win);
}

void mpi_abi_get_fortran_booleans_(
  const MPI_Fint* restrict const logical_size,
  void* restrict const logical_true,
  void* restrict const logical_false,
  MPI_Fint* restrict const is_set,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_is_set;
  *ierror = MPI_Abi_get_fortran_booleans(
    *logical_size,
    logical_true,
    logical_false,
    &c_is_set
  );
  *is_set = c_is_set ? 1 : 0;
}

void mpi_abi_get_fortran_info_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info;
  *ierror = MPI_Abi_get_fortran_info(
    &c_info
  );
  *info = MPIF_Info_toint(c_info);
}

void mpi_abi_get_info_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info;
  *ierror = MPI_Abi_get_info(
    &c_info
  );
  *info = MPIF_Info_toint(c_info);
}

void mpi_abi_get_version_(
  MPI_Fint* restrict const abi_major,
  MPI_Fint* restrict const abi_minor,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Abi_get_version(
    abi_major,
    abi_minor
  );
}

void mpi_abi_set_fortran_booleans_(
  const MPI_Fint* restrict const logical_size,
  const void* restrict const logical_true,
  const void* restrict const logical_false,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Abi_set_fortran_booleans(
    *logical_size,
    (void*)logical_true,
    (void*)logical_false
  );
}

void mpi_abi_set_fortran_info_(
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Abi_set_fortran_info(
    MPIF_Info_fromint(*info)
  );
}

void mpi_abort_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Abort(
    MPIF_Comm_fromint(*comm),
    *errorcode
  );
}

void mpi_accumulate_(
  const void* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Accumulate(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win)
  );
}

void mpi_accumulate_c_(
  const void* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Accumulate_c(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win)
  );
}

void mpi_add_error_class_(
  MPI_Fint* restrict const errorclass,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Add_error_class(
    errorclass
  );
}

void mpi_add_error_code_(
  const MPI_Fint* restrict const errorclass,
  MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Add_error_code(
    *errorclass,
    errorcode
  );
}

void mpi_add_error_string_(
  const MPI_Fint* restrict const errorcode,
  const char* restrict const string,
  MPI_Fint* restrict const ierror,
  const size_t length_string
)
{
  char* const c_string = mpif_strdup_f2c(string, length_string);
  *ierror = MPI_Add_error_string(
    *errorcode,
    c_string
  );
  free(c_string);
}

MPI_Aint mpi_aint_add_(
  const MPI_Aint* restrict const base,
  const MPI_Aint* restrict const disp
)
{
  const MPI_Aint result = MPI_Aint_add(
    *base,
    *disp
  );
  return result;
}

MPI_Aint mpi_aint_diff_(
  const MPI_Aint* restrict const addr1,
  const MPI_Aint* restrict const addr2
)
{
  const MPI_Aint result = MPI_Aint_diff(
    *addr1,
    *addr2
  );
  return result;
}

void mpi_allgather_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Allgather(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_allgather_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Allgather_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_allgather_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Allgather_init(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_allgather_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Allgather_init_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_allgatherv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Allgatherv(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_allgatherv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Allgatherv_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_allgatherv_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Allgatherv_init(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_allgatherv_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Allgatherv_init_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_alloc_mem_(
  const MPI_Aint* restrict const size,
  const MPI_Fint* restrict const info,
  MPI_Aint* restrict const baseptr,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Alloc_mem(
    *size,
    MPIF_Info_fromint(*info),
    baseptr
  );
}

void mpi_allreduce_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Allreduce(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_allreduce_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Allreduce_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_allreduce_init_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Allreduce_init(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_allreduce_init_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Allreduce_init_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_alltoall_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Alltoall(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_alltoall_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Alltoall_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_alltoall_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Alltoall_init(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_alltoall_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Alltoall_init_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_alltoallv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Alltoallv(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_alltoallv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Alltoallv_c(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_alltoallv_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Alltoallv_init(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_alltoallv_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Alltoallv_init_c(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_alltoallw_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  *ierror = MPI_Alltoallw(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_alltoallw_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  *ierror = MPI_Alltoallw_c(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_alltoallw_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  *ierror = MPI_Alltoallw_init(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_alltoallw_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  *ierror = MPI_Alltoallw_init_c(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_attr_delete_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const keyval,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Attr_delete(
    MPIF_Comm_fromint(*comm),
    *keyval
  );
}

void mpi_attr_get_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const keyval,
  MPI_Fint* restrict const attribute_val,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  void *c_attribute_val;
  MPI_Fint c_flag;
  *ierror = MPI_Attr_get(
    MPIF_Comm_fromint(*comm),
    *keyval,
    c_attribute_val,
    &c_flag
  );
  *attribute_val = (int)(intptr_t)c_attribute_val;
  *flag = c_flag ? 1 : 0;
}

void mpi_attr_put_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const keyval,
  const MPI_Fint* restrict const attribute_val,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Attr_put(
    MPIF_Comm_fromint(*comm),
    *keyval,
    (void*)(intptr_t)*attribute_val
  );
}

void mpi_barrier_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Barrier(
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_barrier_init_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Barrier_init(
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_bcast_(
  void* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Bcast(
    buffer,
    *count,
    MPIF_Type_fromint(*datatype),
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_bcast_c_(
  void* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Bcast_c(
    buffer,
    *count,
    MPIF_Type_fromint(*datatype),
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_bcast_init_(
  void* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Bcast_init(
    buffer,
    *count,
    MPIF_Type_fromint(*datatype),
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_bcast_init_c_(
  void* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Bcast_init_c(
    buffer,
    *count,
    MPIF_Type_fromint(*datatype),
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_bsend_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Bsend(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_bsend_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Bsend_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_bsend_init_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Bsend_init(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_bsend_init_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Bsend_init_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_buffer_attach_(
  void* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Buffer_attach(
    buffer,
    *size
  );
}

void mpi_buffer_attach_c_(
  void* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Buffer_attach_c(
    buffer,
    *size
  );
}

void mpi_buffer_detach_(
  MPI_Aint* restrict const buffer_addr,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Buffer_detach(
    buffer_addr,
    size
  );
}

void mpi_buffer_detach_c_(
  MPI_Aint* restrict const buffer_addr,
  MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Buffer_detach_c(
    buffer_addr,
    size
  );
}

void mpi_buffer_flush_(
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Buffer_flush(
  );
}

void mpi_buffer_iflush_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Buffer_iflush(
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_cancel_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPIF_Request_fromint(*request);
  *ierror = MPI_Cancel(
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_cart_coords_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const maxdims,
  MPI_Fint* restrict const coords,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Cart_coords(
    MPIF_Comm_fromint(*comm),
    *rank,
    *maxdims,
    coords
  );
}

void mpi_cart_create_(
  const MPI_Fint* restrict const comm_old,
  const MPI_Fint* restrict const ndims,
  const MPI_Fint* restrict const dims,
  const MPI_Fint* restrict const periods,
  const MPI_Fint* restrict const reorder,
  MPI_Fint* restrict const comm_cart,
  MPI_Fint* restrict const ierror
)
{
  int c_periods[*ndims];
  for (int dim=0; dim<*ndims; ++dim)
    c_periods[dim] = periods[dim] != 0;
  MPI_Comm c_comm_cart;
  *ierror = MPI_Cart_create(
    MPIF_Comm_fromint(*comm_old),
    *ndims,
    dims,
    c_periods,
    *reorder != 0,
    &c_comm_cart
  );
  *comm_cart = MPIF_Comm_toint(c_comm_cart);
}

void mpi_cart_get_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const maxdims,
  MPI_Fint* restrict const dims,
  MPI_Fint* restrict const periods,
  MPI_Fint* restrict const coords,
  MPI_Fint* restrict const ierror
)
{
  int c_periods[*maxdims];
  *ierror = MPI_Cart_get(
    MPIF_Comm_fromint(*comm),
    *maxdims,
    dims,
    c_periods,
    coords
  );
  for (int dim=0; dim<*maxdims; ++dim)
    periods[dim] = c_periods[dim] ? 1 : 0;
}

void mpi_cart_map_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const ndims,
  const MPI_Fint* restrict const dims,
  const MPI_Fint* restrict const periods,
  MPI_Fint* restrict const newrank,
  MPI_Fint* restrict const ierror
)
{
  int c_periods[*ndims];
  for (int dim=0; dim<*ndims; ++dim)
    c_periods[dim] = periods[dim] != 0;
  *ierror = MPI_Cart_map(
    MPIF_Comm_fromint(*comm),
    *ndims,
    dims,
    c_periods,
    newrank
  );
}

void mpi_cart_rank_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const coords,
  MPI_Fint* restrict const rank,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Cart_rank(
    MPIF_Comm_fromint(*comm),
    coords,
    rank
  );
}

void mpi_cart_shift_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const direction,
  const MPI_Fint* restrict const disp,
  MPI_Fint* restrict const rank_source,
  MPI_Fint* restrict const rank_dest,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Cart_shift(
    MPIF_Comm_fromint(*comm),
    *direction,
    *disp,
    rank_source,
    rank_dest
  );
}

void mpi_cart_sub_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const remain_dims,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int ndims;
  {
    const int q_ierror = MPI_Cartdim_get(q_comm, &ndims);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  int c_remain_dims[ndims];
  for (int dim=0; dim<ndims; ++dim)
    c_remain_dims[dim] = remain_dims[dim] != 0;
  MPI_Comm c_newcomm;
  *ierror = MPI_Cart_sub(
    MPIF_Comm_fromint(*comm),
    c_remain_dims,
    &c_newcomm
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_cartdim_get_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ndims,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Cartdim_get(
    MPIF_Comm_fromint(*comm),
    ndims
  );
}

void mpi_close_port_(
  const char* restrict const port_name,
  MPI_Fint* restrict const ierror,
  const size_t length_port_name
)
{
  char* const c_port_name = mpif_strdup_f2c(port_name, length_port_name);
  *ierror = MPI_Close_port(
    c_port_name
  );
  free(c_port_name);
}

void mpi_comm_accept_(
  const char* restrict const port_name,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror,
  const size_t length_port_name
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  char* c_port_name = NULL;
  if (q_comm_rank == 0)
    c_port_name = mpif_strdup_f2c(port_name, length_port_name);
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_accept(
    c_port_name,
    q_comm_rank == 0 ? MPIF_Info_fromint(*info) : MPI_INFO_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    &c_newcomm
  );
  if (q_comm_rank == 0)
    free(c_port_name);
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_attach_buffer_(
  const MPI_Fint* restrict const comm,
  void* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_attach_buffer(
    MPIF_Comm_fromint(*comm),
    buffer,
    *size
  );
}

void mpi_comm_attach_buffer_c_(
  const MPI_Fint* restrict const comm,
  void* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_attach_buffer_c(
    MPIF_Comm_fromint(*comm),
    buffer,
    *size
  );
}

void mpi_comm_call_errhandler_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_call_errhandler(
    MPIF_Comm_fromint(*comm),
    *errorcode
  );
}

void mpi_comm_compare_(
  const MPI_Fint* restrict const comm1,
  const MPI_Fint* restrict const comm2,
  MPI_Fint* restrict const result,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_compare(
    MPIF_Comm_fromint(*comm1),
    MPIF_Comm_fromint(*comm2),
    result
  );
}

void mpi_comm_connect_(
  const char* restrict const port_name,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror,
  const size_t length_port_name
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  char* c_port_name = NULL;
  if (q_comm_rank == 0)
    c_port_name = mpif_strdup_f2c(port_name, length_port_name);
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_connect(
    c_port_name,
    q_comm_rank == 0 ? MPIF_Info_fromint(*info) : MPI_INFO_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    &c_newcomm
  );
  if (q_comm_rank == 0)
    free(c_port_name);
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_create_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const group,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_create(
    MPIF_Comm_fromint(*comm),
    MPIF_Group_fromint(*group),
    &c_newcomm
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_create_errhandler_(
  MPI_Comm_errhandler_function* const comm_errhandler_fn,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Errhandler c_errhandler;
  *ierror = MPI_Comm_create_errhandler(
    comm_errhandler_fn,
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_comm_create_from_group_(
  const MPI_Fint* restrict const group,
  const char* restrict const stringtag,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror,
  const size_t length_stringtag
)
{
  char* const c_stringtag = mpif_strdup_f2c(stringtag, length_stringtag);
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_create_from_group(
    MPIF_Group_fromint(*group),
    c_stringtag,
    MPIF_Info_fromint(*info),
    MPIF_Errhandler_fromint(*errhandler),
    &c_newcomm
  );
  free(c_stringtag);
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_create_group_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const tag,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_create_group(
    MPIF_Comm_fromint(*comm),
    MPIF_Group_fromint(*group),
    *tag,
    &c_newcomm
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_create_keyval_(
  MPI_Comm_copy_attr_function* const comm_copy_attr_fn,
  MPI_Comm_delete_attr_function* const comm_delete_attr_fn,
  MPI_Fint* restrict const comm_keyval,
  const MPI_Aint* restrict const extra_state,
  MPI_Fint* restrict const ierror
)
{
  abort();
  abort();
  *ierror = MPI_Comm_create_keyval(
    comm_copy_attr_fn,
    comm_delete_attr_fn,
    comm_keyval,
    (void*)*extra_state
  );
}

void mpi_comm_delete_attr_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const comm_keyval,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_delete_attr(
    MPIF_Comm_fromint(*comm),
    *comm_keyval
  );
}

void mpi_comm_detach_buffer_(
  const MPI_Fint* restrict const comm,
  MPI_Aint* restrict const buffer_addr,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_detach_buffer(
    MPIF_Comm_fromint(*comm),
    buffer_addr,
    size
  );
}

void mpi_comm_detach_buffer_c_(
  const MPI_Fint* restrict const comm,
  MPI_Aint* restrict const buffer_addr,
  MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_detach_buffer_c(
    MPIF_Comm_fromint(*comm),
    buffer_addr,
    size
  );
}

void mpi_comm_disconnect_(
  MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_comm = MPIF_Comm_fromint(*comm);
  *ierror = MPI_Comm_disconnect(
    &c_comm
  );
  *comm = MPIF_Comm_toint(c_comm);
}

void mpi_comm_dup_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_dup(
    MPIF_Comm_fromint(*comm),
    &c_newcomm
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_dup_with_info_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_dup_with_info(
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_newcomm
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_flush_buffer_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_flush_buffer(
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_comm_free_(
  MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_comm = MPIF_Comm_fromint(*comm);
  *ierror = MPI_Comm_free(
    &c_comm
  );
  *comm = MPIF_Comm_toint(c_comm);
}

void mpi_comm_free_keyval_(
  MPI_Fint* restrict const comm_keyval,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_free_keyval(
    comm_keyval
  );
}

void mpi_comm_get_attr_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const comm_keyval,
  MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  void *c_attribute_val;
  MPI_Fint c_flag;
  *ierror = MPI_Comm_get_attr(
    MPIF_Comm_fromint(*comm),
    *comm_keyval,
    &c_attribute_val,
    &c_flag
  );
  *attribute_val = (MPI_Aint)c_attribute_val;
  *flag = c_flag ? 1 : 0;
}

void mpi_comm_get_errhandler_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler;
  *ierror = MPI_Comm_get_errhandler(
    MPIF_Comm_fromint(*comm),
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_comm_get_info_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const info_used,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info_used;
  *ierror = MPI_Comm_get_info(
    MPIF_Comm_fromint(*comm),
    &c_info_used
  );
  *info_used = MPIF_Info_toint(c_info_used);
}

void mpi_comm_get_name_(
  const MPI_Fint* restrict const comm,
  char* restrict const comm_name,
  MPI_Fint* restrict const resultlen,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_comm_name = MPI_MAX_OBJECT_NAME;
  char c_comm_name[length_comm_name + 1];
  *ierror = MPI_Comm_get_name(
    MPIF_Comm_fromint(*comm),
    c_comm_name,
    resultlen
  );
  mpif_strcpy_c2f(comm_name, c_comm_name, length_comm_name, strlen(c_comm_name));
}

void mpi_comm_get_parent_(
  MPI_Fint* restrict const parent,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_parent;
  *ierror = MPI_Comm_get_parent(
    &c_parent
  );
  *parent = MPIF_Comm_toint(c_parent);
}

void mpi_comm_group_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group;
  *ierror = MPI_Comm_group(
    MPIF_Comm_fromint(*comm),
    &c_group
  );
  *group = MPIF_Group_toint(c_group);
}

void mpi_comm_idup_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  MPI_Request c_request;
  *ierror = MPI_Comm_idup(
    MPIF_Comm_fromint(*comm),
    &c_newcomm,
    &c_request
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
  *request = MPIF_Request_toint(c_request);
}

void mpi_comm_idup_with_info_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  MPI_Request c_request;
  *ierror = MPI_Comm_idup_with_info(
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_newcomm,
    &c_request
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
  *request = MPIF_Request_toint(c_request);
}

void mpi_comm_iflush_buffer_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Comm_iflush_buffer(
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_comm_join_(
  const MPI_Fint* restrict const fd,
  MPI_Fint* restrict const intercomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_intercomm;
  *ierror = MPI_Comm_join(
    *fd,
    &c_intercomm
  );
  *intercomm = MPIF_Comm_toint(c_intercomm);
}

void mpi_comm_rank_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const rank,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_rank(
    MPIF_Comm_fromint(*comm),
    rank
  );
}

void mpi_comm_remote_group_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group;
  *ierror = MPI_Comm_remote_group(
    MPIF_Comm_fromint(*comm),
    &c_group
  );
  *group = MPIF_Group_toint(c_group);
}

void mpi_comm_remote_size_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_remote_size(
    MPIF_Comm_fromint(*comm),
    size
  );
}

void mpi_comm_set_attr_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const comm_keyval,
  const MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_set_attr(
    MPIF_Comm_fromint(*comm),
    *comm_keyval,
    (void*)*attribute_val
  );
}

void mpi_comm_set_errhandler_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_set_errhandler(
    MPIF_Comm_fromint(*comm),
    MPIF_Errhandler_fromint(*errhandler)
  );
}

void mpi_comm_set_info_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_set_info(
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info)
  );
}

void mpi_comm_set_name_(
  const MPI_Fint* restrict const comm,
  const char* restrict const comm_name,
  MPI_Fint* restrict const ierror,
  const size_t length_comm_name
)
{
  char* const c_comm_name = mpif_strdup_f2c(comm_name, length_comm_name);
  *ierror = MPI_Comm_set_name(
    MPIF_Comm_fromint(*comm),
    c_comm_name
  );
  free(c_comm_name);
}

void mpi_comm_size_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Comm_size(
    MPIF_Comm_fromint(*comm),
    size
  );
}

void mpi_comm_spawn_(
  const char* restrict const command,
  const char* restrict const argv,
  const MPI_Fint* restrict const maxprocs,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const intercomm,
  MPI_Fint* restrict const array_of_errcodes,
  MPI_Fint* restrict const ierror,
  const size_t length_command,
  const size_t length_argv
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  char* c_command = NULL;
  if (q_comm_rank == 0)
    c_command = mpif_strdup_f2c(command, length_command);
  size_t count_argv = 0;
  if (q_comm_rank == 0)
    count_argv = mpif_fcount(argv, length_argv);
  char *argv_argv[count_argv + 1];
  for (size_t n=0; n<count_argv; ++n)
    argv_argv[n] = mpif_strdup_f2c(argv + n * length_argv, length_argv);
  argv_argv[count_argv] = NULL;
  MPI_Comm c_intercomm;
  *ierror = MPI_Comm_spawn(
    c_command,
    argv_argv,
    *maxprocs,
    q_comm_rank == 0 ? MPIF_Info_fromint(*info) : MPI_INFO_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    &c_intercomm,
    array_of_errcodes
  );
  if (q_comm_rank == 0)
    free(c_command);
  for (size_t n=0; n<count_argv; ++n)
    free(argv_argv[n]);
  *intercomm = MPIF_Comm_toint(c_intercomm);
}

void mpi_comm_spawn_multiple_(
  const MPI_Fint* restrict const count,
  const char* restrict const array_of_commands,
  const char* restrict const array_of_argv,
  const MPI_Fint* restrict const array_of_maxprocs,
  const MPI_Fint* restrict const array_of_info,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const intercomm,
  MPI_Fint* restrict const array_of_errcodes,
  MPI_Fint* restrict const ierror,
  const size_t length_array_of_commands,
  const size_t length_array_of_argv
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  size_t count_array_of_commands = 0;
  if (q_comm_rank == 0)
    count_array_of_commands = mpif_fcount(array_of_commands, length_array_of_commands);
  char *argv_array_of_commands[count_array_of_commands + 1];
  for (size_t n=0; n<count_array_of_commands; ++n)
    argv_array_of_commands[n] = mpif_strdup_f2c(array_of_commands + n * length_array_of_commands, length_array_of_commands);
  argv_array_of_commands[count_array_of_commands] = NULL;
  size_t count_array_of_argv[*count];
  char **argv_array_of_argv[*count];
  for (int i=0; i<*count; ++i) {
    if (q_comm_rank == 0) {
      count_array_of_argv[i] = mpif_fcount2d(array_of_argv, *count, i, length_array_of_argv);
      argv_array_of_argv[i] = malloc((count_array_of_argv[i] + 1) * sizeof(char*));
      for (size_t n=0; n<count_array_of_argv[i]; ++n)
        argv_array_of_argv[i][n] = mpif_strdup_f2c(array_of_argv + i * length_array_of_argv + n * *count * length_array_of_argv, length_array_of_argv);
      argv_array_of_argv[i][count_array_of_argv[i]] = NULL;
    } else {
      count_array_of_argv[i] = 0;
      argv_array_of_argv[i] = NULL;
    }
  }
  MPI_Info c_array_of_info[*count];
  if (q_comm_rank == 0)
    for (int rank=0; rank<*count; ++rank)
      c_array_of_info[rank] = MPIF_Info_fromint(array_of_info[rank]);
  MPI_Comm c_intercomm;
  *ierror = MPI_Comm_spawn_multiple(
    *count,
    argv_array_of_commands,
    argv_array_of_argv,
    array_of_maxprocs,
    c_array_of_info,
    *root,
    MPIF_Comm_fromint(*comm),
    &c_intercomm,
    array_of_errcodes
  );
  for (size_t n=0; n<count_array_of_commands; ++n)
    free(argv_array_of_commands[n]);
  for (int i=0; i<*count; ++i) {
    for (size_t n=0; n<count_array_of_argv[i]; ++n)
      free(argv_array_of_argv[i][n]);
  }
  *intercomm = MPIF_Comm_toint(c_intercomm);
}

void mpi_comm_split_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const color,
  const MPI_Fint* restrict const key,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_split(
    MPIF_Comm_fromint(*comm),
    *color,
    *key,
    &c_newcomm
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_split_type_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const split_type,
  const MPI_Fint* restrict const key,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  *ierror = MPI_Comm_split_type(
    MPIF_Comm_fromint(*comm),
    *split_type,
    *key,
    MPIF_Info_fromint(*info),
    &c_newcomm
  );
  *newcomm = MPIF_Comm_toint(c_newcomm);
}

void mpi_comm_test_inter_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Comm_test_inter(
    MPIF_Comm_fromint(*comm),
    &c_flag
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_compare_and_swap_(
  const void* restrict const origin_addr,
  const void* restrict const compare_addr,
  void* restrict const result_addr,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Compare_and_swap(
    origin_addr,
    compare_addr,
    result_addr,
    MPIF_Type_fromint(*datatype),
    *target_rank,
    *target_disp,
    MPIF_Win_fromint(*win)
  );
}

void mpi_dims_create_(
  const MPI_Fint* restrict const nnodes,
  const MPI_Fint* restrict const ndims,
  MPI_Fint* restrict const dims,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Dims_create(
    *nnodes,
    *ndims,
    dims
  );
}

void mpi_dist_graph_create_(
  const MPI_Fint* restrict const comm_old,
  const MPI_Fint* restrict const n,
  const MPI_Fint* restrict const sources,
  const MPI_Fint* restrict const degrees,
  const MPI_Fint* restrict const destinations,
  const MPI_Fint* restrict const weights,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const reorder,
  MPI_Fint* restrict const comm_dist_graph,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_comm_dist_graph;
  *ierror = MPI_Dist_graph_create(
    MPIF_Comm_fromint(*comm_old),
    *n,
    sources,
    degrees,
    destinations,
    weights,
    MPIF_Info_fromint(*info),
    *reorder != 0,
    &c_comm_dist_graph
  );
  *comm_dist_graph = MPIF_Comm_toint(c_comm_dist_graph);
}

void mpi_dist_graph_create_adjacent_(
  const MPI_Fint* restrict const comm_old,
  const MPI_Fint* restrict const indegree,
  const MPI_Fint* restrict const sources,
  const MPI_Fint* restrict const sourceweights,
  const MPI_Fint* restrict const outdegree,
  const MPI_Fint* restrict const destinations,
  const MPI_Fint* restrict const destweights,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const reorder,
  MPI_Fint* restrict const comm_dist_graph,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_comm_dist_graph;
  *ierror = MPI_Dist_graph_create_adjacent(
    MPIF_Comm_fromint(*comm_old),
    *indegree,
    sources,
    sourceweights,
    *outdegree,
    destinations,
    destweights,
    MPIF_Info_fromint(*info),
    *reorder != 0,
    &c_comm_dist_graph
  );
  *comm_dist_graph = MPIF_Comm_toint(c_comm_dist_graph);
}

void mpi_dist_graph_neighbors_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const maxindegree,
  MPI_Fint* restrict const sources,
  MPI_Fint* restrict const sourceweights,
  const MPI_Fint* restrict const maxoutdegree,
  MPI_Fint* restrict const destinations,
  MPI_Fint* restrict const destweights,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Dist_graph_neighbors(
    MPIF_Comm_fromint(*comm),
    *maxindegree,
    sources,
    sourceweights,
    *maxoutdegree,
    destinations,
    destweights
  );
}

void mpi_dist_graph_neighbors_count_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const indegree,
  MPI_Fint* restrict const outdegree,
  MPI_Fint* restrict const weighted,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_weighted;
  *ierror = MPI_Dist_graph_neighbors_count(
    MPIF_Comm_fromint(*comm),
    indegree,
    outdegree,
    &c_weighted
  );
  *weighted = c_weighted ? 1 : 0;
}

void mpi_errhandler_free_(
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler = MPIF_Errhandler_fromint(*errhandler);
  *ierror = MPI_Errhandler_free(
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_error_class_(
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const errorclass,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Error_class(
    *errorcode,
    errorclass
  );
}

void mpi_error_string_(
  const MPI_Fint* restrict const errorcode,
  char* restrict const string,
  MPI_Fint* restrict const resultlen,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_string = MPI_MAX_ERROR_STRING;
  char c_string[length_string + 1];
  *ierror = MPI_Error_string(
    *errorcode,
    c_string,
    resultlen
  );
  mpif_strcpy_c2f(string, c_string, length_string, strlen(c_string));
}

void mpi_exscan_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Exscan(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_exscan_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Exscan_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_exscan_init_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Exscan_init(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_exscan_init_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Exscan_init_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_f_sync_reg_(
  void* restrict const buf
)
{
}

void mpi_fetch_and_op_(
  const void* restrict const origin_addr,
  void* restrict const result_addr,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Fetch_and_op(
    origin_addr,
    result_addr,
    MPIF_Type_fromint(*datatype),
    *target_rank,
    *target_disp,
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win)
  );
}

void mpi_file_call_errhandler_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_call_errhandler(
    MPIF_File_fromint(*fh),
    *errorcode
  );
}

void mpi_file_close_(
  MPI_Fint* restrict const fh,
  MPI_Fint* restrict const ierror
)
{
  MPI_File c_fh = MPIF_File_fromint(*fh);
  *ierror = MPI_File_close(
    &c_fh
  );
  *fh = MPIF_File_toint(c_fh);
}

void mpi_file_create_errhandler_(
  MPI_File_errhandler_function* const file_errhandler_fn,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Errhandler c_errhandler;
  *ierror = MPI_File_create_errhandler(
    file_errhandler_fn,
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_file_delete_(
  const char* restrict const filename,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror,
  const size_t length_filename
)
{
  char* const c_filename = mpif_strdup_f2c(filename, length_filename);
  *ierror = MPI_File_delete(
    c_filename,
    MPIF_Info_fromint(*info)
  );
  free(c_filename);
}

void mpi_file_get_amode_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const amode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_get_amode(
    MPIF_File_fromint(*fh),
    amode
  );
}

void mpi_file_get_atomicity_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_File_get_atomicity(
    MPIF_File_fromint(*fh),
    &c_flag
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_file_get_byte_offset_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  MPI_Offset* restrict const disp,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_get_byte_offset(
    MPIF_File_fromint(*fh),
    *offset,
    disp
  );
}

void mpi_file_get_errhandler_(
  const MPI_Fint* restrict const file,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler;
  *ierror = MPI_File_get_errhandler(
    MPIF_File_fromint(*file),
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_file_get_group_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group;
  *ierror = MPI_File_get_group(
    MPIF_File_fromint(*fh),
    &c_group
  );
  *group = MPIF_Group_toint(c_group);
}

void mpi_file_get_info_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const info_used,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info_used;
  *ierror = MPI_File_get_info(
    MPIF_File_fromint(*fh),
    &c_info_used
  );
  *info_used = MPIF_Info_toint(c_info_used);
}

void mpi_file_get_position_(
  const MPI_Fint* restrict const fh,
  MPI_Offset* restrict const offset,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_get_position(
    MPIF_File_fromint(*fh),
    offset
  );
}

void mpi_file_get_position_shared_(
  const MPI_Fint* restrict const fh,
  MPI_Offset* restrict const offset,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_get_position_shared(
    MPIF_File_fromint(*fh),
    offset
  );
}

void mpi_file_get_size_(
  const MPI_Fint* restrict const fh,
  MPI_Offset* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_get_size(
    MPIF_File_fromint(*fh),
    size
  );
}

void mpi_file_get_type_extent_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const datatype,
  MPI_Aint* restrict const extent,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_get_type_extent(
    MPIF_File_fromint(*fh),
    MPIF_Type_fromint(*datatype),
    extent
  );
}

void mpi_file_get_type_extent_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const extent,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_get_type_extent_c(
    MPIF_File_fromint(*fh),
    MPIF_Type_fromint(*datatype),
    extent
  );
}

void mpi_file_get_view_(
  const MPI_Fint* restrict const fh,
  MPI_Offset* restrict const disp,
  MPI_Fint* restrict const etype,
  MPI_Fint* restrict const filetype,
  char* restrict const datarep,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  MPI_Datatype c_etype;
  MPI_Datatype c_filetype;
  char c_datarep[length_datarep + 1];
  *ierror = MPI_File_get_view(
    MPIF_File_fromint(*fh),
    disp,
    &c_etype,
    &c_filetype,
    c_datarep
  );
  *etype = MPIF_Type_toint(c_etype);
  *filetype = MPIF_Type_toint(c_filetype);
  mpif_strcpy_c2f(datarep, c_datarep, length_datarep, strlen(c_datarep));
}

void mpi_file_iread_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_all_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_all(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_all_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_all_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_at_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_at(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_at_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_at_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_at_all_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_at_all(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_at_all_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_at_all_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_shared_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_shared(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iread_shared_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iread_shared_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_all_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_all(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_all_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_all_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_at_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_at(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_at_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_at_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_at_all_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_at_all(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_at_all_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_at_all_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_shared_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_shared(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_iwrite_shared_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_File_iwrite_shared_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_file_open_(
  const MPI_Fint* restrict const comm,
  const char* restrict const filename,
  const MPI_Fint* restrict const amode,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const fh,
  MPI_Fint* restrict const ierror,
  const size_t length_filename
)
{
  char* const c_filename = mpif_strdup_f2c(filename, length_filename);
  MPI_File c_fh;
  *ierror = MPI_File_open(
    MPIF_Comm_fromint(*comm),
    c_filename,
    *amode,
    MPIF_Info_fromint(*info),
    &c_fh
  );
  free(c_filename);
  *fh = MPIF_File_toint(c_fh);
}

void mpi_file_preallocate_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_preallocate(
    MPIF_File_fromint(*fh),
    *size
  );
}

void mpi_file_read_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_all_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_all(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_all_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_all_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_all_begin_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_all_begin(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_read_all_begin_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_all_begin_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_read_all_end_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_all_end(
    MPIF_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
}

void mpi_file_read_at_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_at(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_at_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_at_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_at_all_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_at_all(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_at_all_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_at_all_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_at_all_begin_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_at_all_begin(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_read_at_all_begin_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_at_all_begin_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_read_at_all_end_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_at_all_end(
    MPIF_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
}

void mpi_file_read_ordered_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_ordered(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_ordered_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_ordered_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_ordered_begin_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_ordered_begin(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_read_ordered_begin_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_ordered_begin_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_read_ordered_end_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_ordered_end(
    MPIF_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
}

void mpi_file_read_shared_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_shared(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_read_shared_c_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_read_shared_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_seek_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const MPI_Fint* restrict const whence,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_seek(
    MPIF_File_fromint(*fh),
    *offset,
    *whence
  );
}

void mpi_file_seek_shared_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const MPI_Fint* restrict const whence,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_seek_shared(
    MPIF_File_fromint(*fh),
    *offset,
    *whence
  );
}

void mpi_file_set_atomicity_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_set_atomicity(
    MPIF_File_fromint(*fh),
    *flag != 0
  );
}

void mpi_file_set_errhandler_(
  const MPI_Fint* restrict const file,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_set_errhandler(
    MPIF_File_fromint(*file),
    MPIF_Errhandler_fromint(*errhandler)
  );
}

void mpi_file_set_info_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_set_info(
    MPIF_File_fromint(*fh),
    MPIF_Info_fromint(*info)
  );
}

void mpi_file_set_size_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_set_size(
    MPIF_File_fromint(*fh),
    *size
  );
}

void mpi_file_set_view_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const disp,
  const MPI_Fint* restrict const etype,
  const MPI_Fint* restrict const filetype,
  const char* restrict const datarep,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  *ierror = MPI_File_set_view(
    MPIF_File_fromint(*fh),
    *disp,
    MPIF_Type_fromint(*etype),
    MPIF_Type_fromint(*filetype),
    c_datarep,
    MPIF_Info_fromint(*info)
  );
  free(c_datarep);
}

void mpi_file_sync_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_sync(
    MPIF_File_fromint(*fh)
  );
}

void mpi_file_write_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_all_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_all(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_all_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_all_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_all_begin_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_all_begin(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_write_all_begin_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_all_begin_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_write_all_end_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_all_end(
    MPIF_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
}

void mpi_file_write_at_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_at(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_at_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_at_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_at_all_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_at_all(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_at_all_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_at_all_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_at_all_begin_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_at_all_begin(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_write_at_all_begin_c_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_at_all_begin_c(
    MPIF_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_write_at_all_end_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_at_all_end(
    MPIF_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
}

void mpi_file_write_ordered_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_ordered(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_ordered_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_ordered_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_ordered_begin_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_ordered_begin(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_write_ordered_begin_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_ordered_begin_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype)
  );
}

void mpi_file_write_ordered_end_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_ordered_end(
    MPIF_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
}

void mpi_file_write_shared_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_shared(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_file_write_shared_c_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_File_write_shared_c(
    MPIF_File_fromint(*fh),
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    (MPI_Status*)status
  );
}

void mpi_finalize_(
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Finalize(
  );
}

void mpi_finalized_(
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Finalized(
    &c_flag
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_free_mem_(
  void* restrict const base,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Free_mem(
    base
  );
}

void mpi_gather_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  *ierror = MPI_Gather(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_gather_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  *ierror = MPI_Gather_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_gather_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Gather_init(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_gather_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Gather_init_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_gatherv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  *ierror = MPI_Gatherv(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_gatherv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  *ierror = MPI_Gatherv_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_gatherv_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Gatherv_init(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_gatherv_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Gatherv_init_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_get_(
  void* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Win_fromint(*win)
  );
}

void mpi_get_c_(
  void* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_c(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Win_fromint(*win)
  );
}

void mpi_get_accumulate_(
  const void* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  void* restrict const result_addr,
  const MPI_Fint* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_accumulate(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    result_addr,
    *result_count,
    MPIF_Type_fromint(*result_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win)
  );
}

void mpi_get_accumulate_c_(
  const void* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  void* restrict const result_addr,
  const MPI_Count* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_accumulate_c(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    result_addr,
    *result_count,
    MPIF_Type_fromint(*result_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win)
  );
}

void mpi_get_address_(
  const void* restrict const location,
  MPI_Aint* restrict const address,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_address(
    location,
    address
  );
}

void mpi_get_count_(
  const MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_count(
    (const MPI_Status*)status,
    MPIF_Type_fromint(*datatype),
    count
  );
}

void mpi_get_count_c_(
  const MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_count_c(
    (const MPI_Status*)status,
    MPIF_Type_fromint(*datatype),
    count
  );
}

void mpi_get_elements_(
  const MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_elements(
    (const MPI_Status*)status,
    MPIF_Type_fromint(*datatype),
    count
  );
}

void mpi_get_elements_c_(
  const MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_elements_c(
    (const MPI_Status*)status,
    MPIF_Type_fromint(*datatype),
    count
  );
}

void mpi_get_elements_x_(
  const MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_elements_x(
    (const MPI_Status*)status,
    MPIF_Type_fromint(*datatype),
    count
  );
}

void mpi_get_hw_resource_info_(
  MPI_Fint* restrict const hw_info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_hw_info;
  *ierror = MPI_Get_hw_resource_info(
    &c_hw_info
  );
  *hw_info = MPIF_Info_toint(c_hw_info);
}

void mpi_get_library_version_(
  char* restrict const version,
  MPI_Fint* restrict const resultlen,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_version = MPI_MAX_LIBRARY_VERSION_STRING;
  char c_version[length_version + 1];
  *ierror = MPI_Get_library_version(
    c_version,
    resultlen
  );
  mpif_strcpy_c2f(version, c_version, length_version, strlen(c_version));
}

void mpi_get_processor_name_(
  char* restrict const name,
  MPI_Fint* restrict const resultlen,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_name = MPI_MAX_PROCESSOR_NAME;
  char c_name[length_name + 1];
  *ierror = MPI_Get_processor_name(
    c_name,
    resultlen
  );
  mpif_strcpy_c2f(name, c_name, length_name, strlen(c_name));
}

void mpi_get_version_(
  MPI_Fint* restrict const version,
  MPI_Fint* restrict const subversion,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Get_version(
    version,
    subversion
  );
}

void mpi_graph_create_(
  const MPI_Fint* restrict const comm_old,
  const MPI_Fint* restrict const nnodes,
  const MPI_Fint* restrict const index,
  const MPI_Fint* restrict const edges,
  const MPI_Fint* restrict const reorder,
  MPI_Fint* restrict const comm_graph,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_comm_graph;
  *ierror = MPI_Graph_create(
    MPIF_Comm_fromint(*comm_old),
    *nnodes,
    index,
    edges,
    *reorder != 0,
    &c_comm_graph
  );
  *comm_graph = MPIF_Comm_toint(c_comm_graph);
}

void mpi_graph_get_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const maxindex,
  const MPI_Fint* restrict const maxedges,
  MPI_Fint* restrict const index,
  MPI_Fint* restrict const edges,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Graph_get(
    MPIF_Comm_fromint(*comm),
    *maxindex,
    *maxedges,
    index,
    edges
  );
}

void mpi_graph_map_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const nnodes,
  const MPI_Fint* restrict const index,
  const MPI_Fint* restrict const edges,
  MPI_Fint* restrict const newrank,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Graph_map(
    MPIF_Comm_fromint(*comm),
    *nnodes,
    index,
    edges,
    newrank
  );
}

void mpi_graph_neighbors_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const maxneighbors,
  MPI_Fint* restrict const neighbors,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Graph_neighbors(
    MPIF_Comm_fromint(*comm),
    *rank,
    *maxneighbors,
    neighbors
  );
}

void mpi_graph_neighbors_count_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const rank,
  MPI_Fint* restrict const nneighbors,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Graph_neighbors_count(
    MPIF_Comm_fromint(*comm),
    *rank,
    nneighbors
  );
}

void mpi_graphdims_get_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const nnodes,
  MPI_Fint* restrict const nedges,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Graphdims_get(
    MPIF_Comm_fromint(*comm),
    nnodes,
    nedges
  );
}

void mpi_grequest_complete_(
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Grequest_complete(
    MPIF_Request_fromint(*request)
  );
}

void mpi_grequest_start_(
  MPI_Grequest_query_function* const query_fn,
  MPI_Grequest_free_function* const free_fn,
  MPI_Grequest_cancel_function* const cancel_fn,
  const MPI_Aint* restrict const extra_state,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  abort();
  abort();
  abort();
  MPI_Request c_request;
  *ierror = MPI_Grequest_start(
    query_fn,
    free_fn,
    cancel_fn,
    (void*)*extra_state,
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_group_compare_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const result,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Group_compare(
    MPIF_Group_fromint(*group1),
    MPIF_Group_fromint(*group2),
    result
  );
}

void mpi_group_difference_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  *ierror = MPI_Group_difference(
    MPIF_Group_fromint(*group1),
    MPIF_Group_fromint(*group2),
    &c_newgroup
  );
  *newgroup = MPIF_Group_toint(c_newgroup);
}

void mpi_group_excl_(
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const n,
  const MPI_Fint* restrict const ranks,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  *ierror = MPI_Group_excl(
    MPIF_Group_fromint(*group),
    *n,
    ranks,
    &c_newgroup
  );
  *newgroup = MPIF_Group_toint(c_newgroup);
}

void mpi_group_free_(
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group = MPIF_Group_fromint(*group);
  *ierror = MPI_Group_free(
    &c_group
  );
  *group = MPIF_Group_toint(c_group);
}

void mpi_group_from_session_pset_(
  const MPI_Fint* restrict const session,
  const char* restrict const pset_name,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror,
  const size_t length_pset_name
)
{
  char* const c_pset_name = mpif_strdup_f2c(pset_name, length_pset_name);
  MPI_Group c_newgroup;
  *ierror = MPI_Group_from_session_pset(
    MPIF_Session_fromint(*session),
    c_pset_name,
    &c_newgroup
  );
  free(c_pset_name);
  *newgroup = MPIF_Group_toint(c_newgroup);
}

void mpi_group_incl_(
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const n,
  const MPI_Fint* restrict const ranks,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  *ierror = MPI_Group_incl(
    MPIF_Group_fromint(*group),
    *n,
    ranks,
    &c_newgroup
  );
  *newgroup = MPIF_Group_toint(c_newgroup);
}

void mpi_group_intersection_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  *ierror = MPI_Group_intersection(
    MPIF_Group_fromint(*group1),
    MPIF_Group_fromint(*group2),
    &c_newgroup
  );
  *newgroup = MPIF_Group_toint(c_newgroup);
}

void mpi_group_range_excl_(
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const n,
  const MPI_Fint(* restrict const ranges)[3],
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  *ierror = MPI_Group_range_excl(
    MPIF_Group_fromint(*group),
    *n,
    (MPI_Fint(*)[3])ranges,
    &c_newgroup
  );
  *newgroup = MPIF_Group_toint(c_newgroup);
}

void mpi_group_range_incl_(
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const n,
  const MPI_Fint(* restrict const ranges)[3],
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  *ierror = MPI_Group_range_incl(
    MPIF_Group_fromint(*group),
    *n,
    (MPI_Fint(*)[3])ranges,
    &c_newgroup
  );
  *newgroup = MPIF_Group_toint(c_newgroup);
}

void mpi_group_rank_(
  const MPI_Fint* restrict const group,
  MPI_Fint* restrict const rank,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Group_rank(
    MPIF_Group_fromint(*group),
    rank
  );
}

void mpi_group_size_(
  const MPI_Fint* restrict const group,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Group_size(
    MPIF_Group_fromint(*group),
    size
  );
}

void mpi_group_translate_ranks_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const n,
  const MPI_Fint* restrict const ranks1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const ranks2,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Group_translate_ranks(
    MPIF_Group_fromint(*group1),
    *n,
    ranks1,
    MPIF_Group_fromint(*group2),
    ranks2
  );
}

void mpi_group_union_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  *ierror = MPI_Group_union(
    MPIF_Group_fromint(*group1),
    MPIF_Group_fromint(*group2),
    &c_newgroup
  );
  *newgroup = MPIF_Group_toint(c_newgroup);
}

void mpi_iallgather_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iallgather(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iallgather_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iallgather_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iallgatherv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iallgatherv(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iallgatherv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iallgatherv_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iallreduce_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iallreduce(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iallreduce_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iallreduce_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ialltoall_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ialltoall(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ialltoall_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ialltoall_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ialltoallv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ialltoallv(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ialltoallv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ialltoallv_c(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ialltoallw_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  *ierror = MPI_Ialltoallw(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ialltoallw_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  *ierror = MPI_Ialltoallw_c(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ibarrier_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ibarrier(
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ibcast_(
  void* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ibcast(
    buffer,
    *count,
    MPIF_Type_fromint(*datatype),
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ibcast_c_(
  void* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ibcast_c(
    buffer,
    *count,
    MPIF_Type_fromint(*datatype),
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ibsend_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ibsend(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ibsend_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ibsend_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iexscan_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iexscan(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iexscan_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iexscan_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_igather_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Igather(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_igather_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Igather_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_igatherv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Igatherv(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_igatherv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Igatherv_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_improbe_(
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  MPI_Message c_message;
  *ierror = MPI_Improbe(
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_flag,
    &c_message,
    (MPI_Status*)status
  );
  *flag = c_flag ? 1 : 0;
  *message = MPIF_Message_toint(c_message);
}

void mpi_imrecv_(
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Message c_message = MPIF_Message_fromint(*message);
  MPI_Request c_request;
  *ierror = MPI_Imrecv(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_message,
    &c_request
  );
  *message = MPIF_Message_toint(c_message);
  *request = MPIF_Request_toint(c_request);
}

void mpi_imrecv_c_(
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Message c_message = MPIF_Message_fromint(*message);
  MPI_Request c_request;
  *ierror = MPI_Imrecv_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_message,
    &c_request
  );
  *message = MPIF_Message_toint(c_message);
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_allgather_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_allgather(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_allgather_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_allgather_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_allgatherv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_allgatherv(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_allgatherv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_allgatherv_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_alltoall_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_alltoall(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_alltoall_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_alltoall_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_alltoallv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_alltoallv(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_alltoallv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_alltoallv_c(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_alltoallw_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_alltoallw(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ineighbor_alltoallw_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  *ierror = MPI_Ineighbor_alltoallw_c(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_info_create_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info;
  *ierror = MPI_Info_create(
    &c_info
  );
  *info = MPIF_Info_toint(c_info);
}

void mpi_info_create_env_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info;
  *ierror = MPI_Info_create_env(
    0,
    NULL,
    &c_info
  );
  *info = MPIF_Info_toint(c_info);
}

void mpi_info_delete_(
  const MPI_Fint* restrict const info,
  const char* restrict const key,
  MPI_Fint* restrict const ierror,
  const size_t length_key
)
{
  char* const c_key = mpif_strdup_f2c(key, length_key);
  *ierror = MPI_Info_delete(
    MPIF_Info_fromint(*info),
    c_key
  );
  free(c_key);
}

void mpi_info_dup_(
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const newinfo,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_newinfo;
  *ierror = MPI_Info_dup(
    MPIF_Info_fromint(*info),
    &c_newinfo
  );
  *newinfo = MPIF_Info_toint(c_newinfo);
}

void mpi_info_free_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info = MPIF_Info_fromint(*info);
  *ierror = MPI_Info_free(
    &c_info
  );
  *info = MPIF_Info_toint(c_info);
}

void mpi_info_get_(
  const MPI_Fint* restrict const info,
  const char* restrict const key,
  const MPI_Fint* restrict const valuelen,
  char* restrict const value,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror,
  const size_t length_key
)
{
  char* const c_key = mpif_strdup_f2c(key, length_key);
  const size_t length_value = *valuelen;
  char c_value[length_value + 1];
  MPI_Fint c_flag;
  *ierror = MPI_Info_get(
    MPIF_Info_fromint(*info),
    c_key,
    *valuelen,
    c_value,
    &c_flag
  );
  free(c_key);
  mpif_strcpy_c2f(value, c_value, length_value, strlen(c_value));
  *flag = c_flag ? 1 : 0;
}

void mpi_info_get_nkeys_(
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const nkeys,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Info_get_nkeys(
    MPIF_Info_fromint(*info),
    nkeys
  );
}

void mpi_info_get_nthkey_(
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const n,
  char* restrict const key,
  MPI_Fint* restrict const ierror,
  const size_t length_key
)
{
  char c_key[length_key + 1];
  *ierror = MPI_Info_get_nthkey(
    MPIF_Info_fromint(*info),
    *n,
    c_key
  );
  mpif_strcpy_c2f(key, c_key, length_key, strlen(c_key));
}

void mpi_info_get_string_(
  const MPI_Fint* restrict const info,
  const char* restrict const key,
  MPI_Fint* restrict const buflen,
  char* restrict const value,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror,
  const size_t length_key,
  const size_t length_value
)
{
  char* const c_key = mpif_strdup_f2c(key, length_key);
  char c_value[length_value + 1];
  MPI_Fint c_flag;
  *ierror = MPI_Info_get_string(
    MPIF_Info_fromint(*info),
    c_key,
    buflen,
    c_value,
    &c_flag
  );
  free(c_key);
  mpif_strcpy_c2f(value, c_value, length_value, strlen(c_value));
  *flag = c_flag ? 1 : 0;
}

void mpi_info_get_valuelen_(
  const MPI_Fint* restrict const info,
  const char* restrict const key,
  MPI_Fint* restrict const valuelen,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror,
  const size_t length_key
)
{
  char* const c_key = mpif_strdup_f2c(key, length_key);
  MPI_Fint c_flag;
  *ierror = MPI_Info_get_valuelen(
    MPIF_Info_fromint(*info),
    c_key,
    valuelen,
    &c_flag
  );
  free(c_key);
  *flag = c_flag ? 1 : 0;
}

void mpi_info_set_(
  const MPI_Fint* restrict const info,
  const char* restrict const key,
  const char* restrict const value,
  MPI_Fint* restrict const ierror,
  const size_t length_key,
  const size_t length_value
)
{
  char* const c_key = mpif_strdup_f2c(key, length_key);
  char* const c_value = mpif_strdup_f2c(value, length_value);
  *ierror = MPI_Info_set(
    MPIF_Info_fromint(*info),
    c_key,
    c_value
  );
  free(c_key);
  free(c_value);
}

void mpi_init_(
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Init(
    NULL,
    NULL
  );
}

void mpi_init_thread_(
  const MPI_Fint* restrict const required,
  MPI_Fint* restrict const provided,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Init_thread(
    NULL,
    NULL,
    *required,
    provided
  );
}

void mpi_initialized_(
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Initialized(
    &c_flag
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_intercomm_create_(
  const MPI_Fint* restrict const local_comm,
  const MPI_Fint* restrict const local_leader,
  const MPI_Fint* restrict const peer_comm,
  const MPI_Fint* restrict const remote_leader,
  const MPI_Fint* restrict const tag,
  MPI_Fint* restrict const newintercomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newintercomm;
  *ierror = MPI_Intercomm_create(
    MPIF_Comm_fromint(*local_comm),
    *local_leader,
    MPIF_Comm_fromint(*peer_comm),
    *remote_leader,
    *tag,
    &c_newintercomm
  );
  *newintercomm = MPIF_Comm_toint(c_newintercomm);
}

void mpi_intercomm_create_from_groups_(
  const MPI_Fint* restrict const local_group,
  const MPI_Fint* restrict const local_leader,
  const MPI_Fint* restrict const remote_group,
  const MPI_Fint* restrict const remote_leader,
  const char* restrict const stringtag,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const newintercomm,
  MPI_Fint* restrict const ierror,
  const size_t length_stringtag
)
{
  char* const c_stringtag = mpif_strdup_f2c(stringtag, length_stringtag);
  MPI_Comm c_newintercomm;
  *ierror = MPI_Intercomm_create_from_groups(
    MPIF_Group_fromint(*local_group),
    *local_leader,
    MPIF_Group_fromint(*remote_group),
    *remote_leader,
    c_stringtag,
    MPIF_Info_fromint(*info),
    MPIF_Errhandler_fromint(*errhandler),
    &c_newintercomm
  );
  free(c_stringtag);
  *newintercomm = MPIF_Comm_toint(c_newintercomm);
}

void mpi_intercomm_merge_(
  const MPI_Fint* restrict const intercomm,
  const MPI_Fint* restrict const high,
  MPI_Fint* restrict const newintracomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newintracomm;
  *ierror = MPI_Intercomm_merge(
    MPIF_Comm_fromint(*intercomm),
    *high != 0,
    &c_newintracomm
  );
  *newintracomm = MPIF_Comm_toint(c_newintracomm);
}

void mpi_iprobe_(
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Iprobe(
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_flag,
    (MPI_Status*)status
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_irecv_(
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Irecv(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_irecv_c_(
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Irecv_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ireduce_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ireduce(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ireduce_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ireduce_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ireduce_scatter_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ireduce_scatter(
    sendbuf,
    recvbuf,
    recvcounts,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ireduce_scatter_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ireduce_scatter_c(
    sendbuf,
    recvbuf,
    recvcounts,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ireduce_scatter_block_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ireduce_scatter_block(
    sendbuf,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ireduce_scatter_block_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ireduce_scatter_block_c(
    sendbuf,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_irsend_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Irsend(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_irsend_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Irsend_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_is_thread_main_(
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Is_thread_main(
    &c_flag
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_iscan_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iscan(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iscan_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Iscan_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iscatter_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Iscatter(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iscatter_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Iscatter_c(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iscatterv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Iscatterv(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_iscatterv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Iscatterv_c(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_isend_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Isend(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_isend_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Isend_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_isendrecv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Isendrecv(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    *dest,
    *sendtag,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *source,
    *recvtag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_isendrecv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Isendrecv_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    *dest,
    *sendtag,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *source,
    *recvtag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_isendrecv_replace_(
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Isendrecv_replace(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_isendrecv_replace_c_(
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Isendrecv_replace_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_issend_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Issend(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_issend_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Issend_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_keyval_create_(
  MPI_Copy_function* const copy_fn,
  MPI_Delete_function* const delete_fn,
  MPI_Fint* restrict const keyval,
  const MPI_Aint* restrict const extra_state,
  MPI_Fint* restrict const ierror
)
{
  abort();
  abort();
  *ierror = MPI_Keyval_create(
    copy_fn,
    delete_fn,
    keyval,
    (void*)*extra_state
  );
}

void mpi_keyval_free_(
  MPI_Fint* restrict const keyval,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Keyval_free(
    keyval
  );
}

void mpi_lookup_name_(
  const char* restrict const service_name,
  const MPI_Fint* restrict const info,
  char* restrict const port_name,
  MPI_Fint* restrict const ierror,
  const size_t length_service_name
)
{
  char* const c_service_name = mpif_strdup_f2c(service_name, length_service_name);
  const size_t length_port_name = MPI_MAX_PORT_NAME;
  char c_port_name[length_port_name + 1];
  *ierror = MPI_Lookup_name(
    c_service_name,
    MPIF_Info_fromint(*info),
    c_port_name
  );
  free(c_service_name);
  mpif_strcpy_c2f(port_name, c_port_name, length_port_name, strlen(c_port_name));
}

void mpi_mprobe_(
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Message c_message;
  *ierror = MPI_Mprobe(
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_message,
    (MPI_Status*)status
  );
  *message = MPIF_Message_toint(c_message);
}

void mpi_mrecv_(
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Message c_message = MPIF_Message_fromint(*message);
  *ierror = MPI_Mrecv(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_message,
    (MPI_Status*)status
  );
  *message = MPIF_Message_toint(c_message);
}

void mpi_mrecv_c_(
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Message c_message = MPIF_Message_fromint(*message);
  *ierror = MPI_Mrecv_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    &c_message,
    (MPI_Status*)status
  );
  *message = MPIF_Message_toint(c_message);
}

void mpi_neighbor_allgather_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Neighbor_allgather(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_allgather_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Neighbor_allgather_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_allgather_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Neighbor_allgather_init(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_allgather_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Neighbor_allgather_init_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_allgatherv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Neighbor_allgatherv(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_allgatherv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Neighbor_allgatherv_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_allgatherv_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Neighbor_allgatherv_init(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_allgatherv_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Neighbor_allgatherv_init_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_alltoall_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Neighbor_alltoall(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoall_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Neighbor_alltoall_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoall_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Neighbor_alltoall_init(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_alltoall_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Neighbor_alltoall_init_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_alltoallv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Neighbor_alltoallv(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoallv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Neighbor_alltoallv_c(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoallv_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Neighbor_alltoallv_init(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_alltoallv_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Neighbor_alltoallv_init_c(
    sendbuf,
    sendcounts,
    sdispls,
    MPIF_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPIF_Type_fromint(*recvtype),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_alltoallw_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  *ierror = MPI_Neighbor_alltoallw(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoallw_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  *ierror = MPI_Neighbor_alltoallw_c(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoallw_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  *ierror = MPI_Neighbor_alltoallw_init(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_neighbor_alltoallw_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPIF_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPIF_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  *ierror = MPI_Neighbor_alltoallw_init_c(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_op_commutative_(
  const MPI_Fint* restrict const op,
  MPI_Fint* restrict const commute,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_commute;
  *ierror = MPI_Op_commutative(
    MPIF_Op_fromint(*op),
    &c_commute
  );
  *commute = c_commute ? 1 : 0;
}

void mpi_op_create_(
  MPI_User_function* const user_fn,
  const MPI_Fint* restrict const commute,
  MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Op c_op;
  *ierror = MPI_Op_create(
    user_fn,
    *commute != 0,
    &c_op
  );
  *op = MPIF_Op_toint(c_op);
}

void mpi_op_create_c_(
  MPI_User_function_c* const user_fn,
  const MPI_Fint* restrict const commute,
  MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Op c_op;
  *ierror = MPI_Op_create_c(
    user_fn,
    *commute != 0,
    &c_op
  );
  *op = MPIF_Op_toint(c_op);
}

void mpi_op_free_(
  MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  MPI_Op c_op = MPIF_Op_fromint(*op);
  *ierror = MPI_Op_free(
    &c_op
  );
  *op = MPIF_Op_toint(c_op);
}

void mpi_open_port_(
  const MPI_Fint* restrict const info,
  char* restrict const port_name,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_port_name = MPI_MAX_PORT_NAME;
  char c_port_name[length_port_name + 1];
  *ierror = MPI_Open_port(
    MPIF_Info_fromint(*info),
    c_port_name
  );
  mpif_strcpy_c2f(port_name, c_port_name, length_port_name, strlen(c_port_name));
}

void mpi_pack_(
  const void* restrict const inbuf,
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  void* restrict const outbuf,
  const MPI_Fint* restrict const outsize,
  MPI_Fint* restrict const position,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Pack(
    inbuf,
    *incount,
    MPIF_Type_fromint(*datatype),
    outbuf,
    *outsize,
    position,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_pack_c_(
  const void* restrict const inbuf,
  const MPI_Count* restrict const incount,
  const MPI_Fint* restrict const datatype,
  void* restrict const outbuf,
  const MPI_Count* restrict const outsize,
  MPI_Count* restrict const position,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Pack_c(
    inbuf,
    *incount,
    MPIF_Type_fromint(*datatype),
    outbuf,
    *outsize,
    position,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_pack_external_(
  const char* restrict const datarep,
  const void* restrict const inbuf,
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  void* restrict const outbuf,
  const MPI_Aint* restrict const outsize,
  MPI_Aint* restrict const position,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  *ierror = MPI_Pack_external(
    c_datarep,
    inbuf,
    *incount,
    MPIF_Type_fromint(*datatype),
    outbuf,
    *outsize,
    position
  );
  free(c_datarep);
}

void mpi_pack_external_c_(
  const char* restrict const datarep,
  const void* restrict const inbuf,
  const MPI_Count* restrict const incount,
  const MPI_Fint* restrict const datatype,
  void* restrict const outbuf,
  const MPI_Count* restrict const outsize,
  MPI_Count* restrict const position,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  *ierror = MPI_Pack_external_c(
    c_datarep,
    inbuf,
    *incount,
    MPIF_Type_fromint(*datatype),
    outbuf,
    *outsize,
    position
  );
  free(c_datarep);
}

void mpi_pack_external_size_(
  const char* restrict const datarep,
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  MPI_Aint* restrict const size,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  *ierror = MPI_Pack_external_size(
    c_datarep,
    *incount,
    MPIF_Type_fromint(*datatype),
    size
  );
  free(c_datarep);
}

void mpi_pack_external_size_c_(
  const char* restrict const datarep,
  const MPI_Count* restrict const incount,
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  *ierror = MPI_Pack_external_size_c(
    c_datarep,
    *incount,
    MPIF_Type_fromint(*datatype),
    size
  );
  free(c_datarep);
}

void mpi_pack_size_(
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Pack_size(
    *incount,
    MPIF_Type_fromint(*datatype),
    MPIF_Comm_fromint(*comm),
    size
  );
}

void mpi_pack_size_c_(
  const MPI_Count* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Pack_size_c(
    *incount,
    MPIF_Type_fromint(*datatype),
    MPIF_Comm_fromint(*comm),
    size
  );
}

void mpi_parrived_(
  const MPI_Fint* restrict const request,
  const MPI_Fint* restrict const partition,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Parrived(
    MPIF_Request_fromint(*request),
    *partition,
    &c_flag
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_pready_(
  const MPI_Fint* restrict const partition,
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Pready(
    *partition,
    MPIF_Request_fromint(*request)
  );
}

void mpi_pready_list_(
  const MPI_Fint* restrict const length,
  const MPI_Fint* restrict const array_of_partitions,
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Pready_list(
    *length,
    array_of_partitions,
    MPIF_Request_fromint(*request)
  );
}

void mpi_pready_range_(
  const MPI_Fint* restrict const partition_low,
  const MPI_Fint* restrict const partition_high,
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Pready_range(
    *partition_low,
    *partition_high,
    MPIF_Request_fromint(*request)
  );
}

void mpi_precv_init_(
  void* restrict const buf,
  const MPI_Fint* restrict const partitions,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Precv_init(
    buf,
    *partitions,
    *count,
    MPIF_Type_fromint(*datatype),
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_probe_(
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Probe(
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    (MPI_Status*)status
  );
}

void mpi_psend_init_(
  const void* restrict const buf,
  const MPI_Fint* restrict const partitions,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Psend_init(
    buf,
    *partitions,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_publish_name_(
  const char* restrict const service_name,
  const MPI_Fint* restrict const info,
  const char* restrict const port_name,
  MPI_Fint* restrict const ierror,
  const size_t length_service_name,
  const size_t length_port_name
)
{
  char* const c_service_name = mpif_strdup_f2c(service_name, length_service_name);
  char* const c_port_name = mpif_strdup_f2c(port_name, length_port_name);
  *ierror = MPI_Publish_name(
    c_service_name,
    MPIF_Info_fromint(*info),
    c_port_name
  );
  free(c_service_name);
  free(c_port_name);
}

void mpi_put_(
  const void* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Put(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Win_fromint(*win)
  );
}

void mpi_put_c_(
  const void* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Put_c(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Win_fromint(*win)
  );
}

void mpi_query_thread_(
  MPI_Fint* restrict const provided,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Query_thread(
    provided
  );
}

void mpi_raccumulate_(
  const void* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Raccumulate(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_raccumulate_c_(
  const void* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Raccumulate_c(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_recv_(
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Recv(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    (MPI_Status*)status
  );
}

void mpi_recv_c_(
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Recv_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    (MPI_Status*)status
  );
}

void mpi_recv_init_(
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Recv_init(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_recv_init_c_(
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Recv_init_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *source,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_reduce_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Reduce(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_reduce_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Reduce_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_reduce_init_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Reduce_init(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_reduce_init_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Reduce_init_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_reduce_local_(
  const void* restrict const inbuf,
  void* restrict const inoutbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Reduce_local(
    inbuf,
    inoutbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op)
  );
}

void mpi_reduce_local_c_(
  const void* restrict const inbuf,
  void* restrict const inoutbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Reduce_local_c(
    inbuf,
    inoutbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op)
  );
}

void mpi_reduce_scatter_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Reduce_scatter(
    sendbuf,
    recvbuf,
    recvcounts,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_reduce_scatter_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Reduce_scatter_c(
    sendbuf,
    recvbuf,
    recvcounts,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_reduce_scatter_block_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Reduce_scatter_block(
    sendbuf,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_reduce_scatter_block_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Reduce_scatter_block_c(
    sendbuf,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_reduce_scatter_block_init_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Reduce_scatter_block_init(
    sendbuf,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_reduce_scatter_block_init_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Reduce_scatter_block_init_c(
    sendbuf,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_reduce_scatter_init_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Reduce_scatter_init(
    sendbuf,
    recvbuf,
    recvcounts,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_reduce_scatter_init_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Reduce_scatter_init_c(
    sendbuf,
    recvbuf,
    recvcounts,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_register_datarep_(
  const char* restrict const datarep,
  MPI_Datarep_conversion_function* const read_conversion_fn,
  MPI_Datarep_conversion_function* const write_conversion_fn,
  MPI_Datarep_extent_function* const dtype_file_extent_fn,
  const MPI_Aint* restrict const extra_state,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  abort();
  abort();
  abort();
  *ierror = MPI_Register_datarep(
    c_datarep,
    read_conversion_fn,
    write_conversion_fn,
    dtype_file_extent_fn,
    (void*)*extra_state
  );
  free(c_datarep);
}

void mpi_register_datarep_c_(
  const char* restrict const datarep,
  MPI_Datarep_conversion_function_c* const read_conversion_fn,
  MPI_Datarep_conversion_function_c* const write_conversion_fn,
  MPI_Datarep_extent_function* const dtype_file_extent_fn,
  const MPI_Aint* restrict const extra_state,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  abort();
  abort();
  abort();
  *ierror = MPI_Register_datarep_c(
    c_datarep,
    read_conversion_fn,
    write_conversion_fn,
    dtype_file_extent_fn,
    (void*)*extra_state
  );
  free(c_datarep);
}

void mpi_remove_error_class_(
  const MPI_Fint* restrict const errorclass,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Remove_error_class(
    *errorclass
  );
}

void mpi_remove_error_code_(
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Remove_error_code(
    *errorcode
  );
}

void mpi_remove_error_string_(
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Remove_error_string(
    *errorcode
  );
}

void mpi_request_free_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPIF_Request_fromint(*request);
  *ierror = MPI_Request_free(
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_request_get_status_(
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Request_get_status(
    MPIF_Request_fromint(*request),
    &c_flag,
    (MPI_Status*)status
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_request_get_status_all_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const array_of_statuses,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests[*count];
  for (int rank=0; rank<*count; ++rank)
    c_array_of_requests[rank] = MPIF_Request_fromint(array_of_requests[rank]);
  MPI_Fint c_flag;
  *ierror = MPI_Request_get_status_all(
    *count,
    c_array_of_requests,
    &c_flag,
    (MPI_Status*)array_of_statuses
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_request_get_status_any_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const index,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests[*count];
  for (int rank=0; rank<*count; ++rank)
    c_array_of_requests[rank] = MPIF_Request_fromint(array_of_requests[rank]);
  MPI_Fint c_flag;
  *ierror = MPI_Request_get_status_any(
    *count,
    c_array_of_requests,
    index,
    &c_flag,
    (MPI_Status*)status
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_request_get_status_some_(
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const outcount,
  MPI_Fint* restrict const array_of_indices,
  MPI_Fint* restrict const array_of_statuses,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests[*incount];
  for (int rank=0; rank<*incount; ++rank)
    c_array_of_requests[rank] = MPIF_Request_fromint(array_of_requests[rank]);
  *ierror = MPI_Request_get_status_some(
    *incount,
    c_array_of_requests,
    outcount,
    array_of_indices,
    (MPI_Status*)array_of_statuses
  );
}

void mpi_rget_(
  void* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Rget(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Win_fromint(*win),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_rget_c_(
  void* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Rget_c(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Win_fromint(*win),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_rget_accumulate_(
  const void* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  void* restrict const result_addr,
  const MPI_Fint* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Rget_accumulate(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    result_addr,
    *result_count,
    MPIF_Type_fromint(*result_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_rget_accumulate_c_(
  const void* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  void* restrict const result_addr,
  const MPI_Count* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Rget_accumulate_c(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    result_addr,
    *result_count,
    MPIF_Type_fromint(*result_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Op_fromint(*op),
    MPIF_Win_fromint(*win),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_rput_(
  const void* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Rput(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Win_fromint(*win),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_rput_c_(
  const void* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Fint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Rput_c(
    origin_addr,
    *origin_count,
    MPIF_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPIF_Type_fromint(*target_datatype),
    MPIF_Win_fromint(*win),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_rsend_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Rsend(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_rsend_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Rsend_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_rsend_init_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Rsend_init(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_rsend_init_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Rsend_init_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_scan_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Scan(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_scan_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Scan_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_scan_init_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Scan_init(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_scan_init_c_(
  const void* restrict const sendbuf,
  void* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Scan_init_c(
    sendbuf,
    recvbuf,
    *count,
    MPIF_Type_fromint(*datatype),
    MPIF_Op_fromint(*op),
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_scatter_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  *ierror = MPI_Scatter(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_scatter_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  *ierror = MPI_Scatter_c(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_scatter_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Scatter_init(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_scatter_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Scatter_init_c(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_scatterv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  *ierror = MPI_Scatterv(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_scatterv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  *ierror = MPI_Scatterv_c(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_scatterv_init_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Scatterv_init(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_scatterv_init_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPIF_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  *ierror = MPI_Scatterv_init_c(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPIF_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *root,
    MPIF_Comm_fromint(*comm),
    MPIF_Info_fromint(*info),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_send_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Send(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_send_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Send_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_send_init_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Send_init(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_send_init_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Send_init_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_sendrecv_(
  const void* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  void* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Sendrecv(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    *dest,
    *sendtag,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *source,
    *recvtag,
    MPIF_Comm_fromint(*comm),
    (MPI_Status*)status
  );
}

void mpi_sendrecv_c_(
  const void* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  void* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Sendrecv_c(
    sendbuf,
    *sendcount,
    MPIF_Type_fromint(*sendtype),
    *dest,
    *sendtag,
    recvbuf,
    *recvcount,
    MPIF_Type_fromint(*recvtype),
    *source,
    *recvtag,
    MPIF_Comm_fromint(*comm),
    (MPI_Status*)status
  );
}

void mpi_sendrecv_replace_(
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Sendrecv_replace(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPIF_Comm_fromint(*comm),
    (MPI_Status*)status
  );
}

void mpi_sendrecv_replace_c_(
  void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Sendrecv_replace_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPIF_Comm_fromint(*comm),
    (MPI_Status*)status
  );
}

void mpi_session_attach_buffer_(
  const MPI_Fint* restrict const session,
  void* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Session_attach_buffer(
    MPIF_Session_fromint(*session),
    buffer,
    *size
  );
}

void mpi_session_attach_buffer_c_(
  const MPI_Fint* restrict const session,
  void* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Session_attach_buffer_c(
    MPIF_Session_fromint(*session),
    buffer,
    *size
  );
}

void mpi_session_call_errhandler_(
  const MPI_Fint* restrict const session,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Session_call_errhandler(
    MPIF_Session_fromint(*session),
    *errorcode
  );
}

void mpi_session_create_errhandler_(
  MPI_Session_errhandler_function* const session_errhandler_fn,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Errhandler c_errhandler;
  *ierror = MPI_Session_create_errhandler(
    session_errhandler_fn,
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_session_detach_buffer_(
  const MPI_Fint* restrict const session,
  MPI_Aint* restrict const buffer_addr,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Session_detach_buffer(
    MPIF_Session_fromint(*session),
    buffer_addr,
    size
  );
}

void mpi_session_detach_buffer_c_(
  const MPI_Fint* restrict const session,
  MPI_Aint* restrict const buffer_addr,
  MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Session_detach_buffer_c(
    MPIF_Session_fromint(*session),
    buffer_addr,
    size
  );
}

void mpi_session_finalize_(
  MPI_Fint* restrict const session,
  MPI_Fint* restrict const ierror
)
{
  MPI_Session c_session = MPIF_Session_fromint(*session);
  *ierror = MPI_Session_finalize(
    &c_session
  );
  *session = MPIF_Session_toint(c_session);
}

void mpi_session_flush_buffer_(
  const MPI_Fint* restrict const session,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Session_flush_buffer(
    MPIF_Session_fromint(*session)
  );
}

void mpi_session_get_errhandler_(
  const MPI_Fint* restrict const session,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler;
  *ierror = MPI_Session_get_errhandler(
    MPIF_Session_fromint(*session),
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_session_get_info_(
  const MPI_Fint* restrict const session,
  MPI_Fint* restrict const info_used,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info_used;
  *ierror = MPI_Session_get_info(
    MPIF_Session_fromint(*session),
    &c_info_used
  );
  *info_used = MPIF_Info_toint(c_info_used);
}

void mpi_session_get_nth_pset_(
  const MPI_Fint* restrict const session,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const n,
  MPI_Fint* restrict const pset_len,
  char* restrict const pset_name,
  MPI_Fint* restrict const ierror,
  const size_t length_pset_name
)
{
  char c_pset_name[length_pset_name + 1];
  *ierror = MPI_Session_get_nth_pset(
    MPIF_Session_fromint(*session),
    MPIF_Info_fromint(*info),
    *n,
    pset_len,
    c_pset_name
  );
  mpif_strcpy_c2f(pset_name, c_pset_name, length_pset_name, strlen(c_pset_name));
}

void mpi_session_get_num_psets_(
  const MPI_Fint* restrict const session,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const npset_names,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Session_get_num_psets(
    MPIF_Session_fromint(*session),
    MPIF_Info_fromint(*info),
    npset_names
  );
}

void mpi_session_get_pset_info_(
  const MPI_Fint* restrict const session,
  const char* restrict const pset_name,
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror,
  const size_t length_pset_name
)
{
  char* const c_pset_name = mpif_strdup_f2c(pset_name, length_pset_name);
  MPI_Info c_info;
  *ierror = MPI_Session_get_pset_info(
    MPIF_Session_fromint(*session),
    c_pset_name,
    &c_info
  );
  free(c_pset_name);
  *info = MPIF_Info_toint(c_info);
}

void mpi_session_iflush_buffer_(
  const MPI_Fint* restrict const session,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Session_iflush_buffer(
    MPIF_Session_fromint(*session),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_session_init_(
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const session,
  MPI_Fint* restrict const ierror
)
{
  MPI_Session c_session;
  *ierror = MPI_Session_init(
    MPIF_Info_fromint(*info),
    MPIF_Errhandler_fromint(*errhandler),
    &c_session
  );
  *session = MPIF_Session_toint(c_session);
}

void mpi_session_set_errhandler_(
  const MPI_Fint* restrict const session,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Session_set_errhandler(
    MPIF_Session_fromint(*session),
    MPIF_Errhandler_fromint(*errhandler)
  );
}

void mpi_ssend_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Ssend(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_ssend_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Ssend_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_ssend_init_(
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ssend_init(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_ssend_init_c_(
  const void* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  *ierror = MPI_Ssend_init_c(
    buf,
    *count,
    MPIF_Type_fromint(*datatype),
    *dest,
    *tag,
    MPIF_Comm_fromint(*comm),
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_start_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPIF_Request_fromint(*request);
  *ierror = MPI_Start(
    &c_request
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_startall_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPIF_Request_fromint(*array_of_requests);
  *ierror = MPI_Startall(
    *count,
    &c_array_of_requests
  );
  *array_of_requests = MPIF_Request_toint(c_array_of_requests);
}

void mpi_status_get_error_(
  const MPI_Fint* restrict const status,
  MPI_Fint* restrict const err,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_get_error(
    (const MPI_Status*)status,
    err
  );
}

void mpi_status_get_source_(
  const MPI_Fint* restrict const status,
  MPI_Fint* restrict const source,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_get_source(
    (const MPI_Status*)status,
    source
  );
}

void mpi_status_get_tag_(
  const MPI_Fint* restrict const status,
  MPI_Fint* restrict const tag,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_get_tag(
    (const MPI_Status*)status,
    tag
  );
}

void mpi_status_set_cancelled_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_set_cancelled(
    (MPI_Status*)status,
    *flag != 0
  );
}

void mpi_status_set_elements_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_set_elements(
    (MPI_Status*)status,
    MPIF_Type_fromint(*datatype),
    *count
  );
}

void mpi_status_set_elements_c_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  const MPI_Count* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_set_elements_c(
    (MPI_Status*)status,
    MPIF_Type_fromint(*datatype),
    *count
  );
}

void mpi_status_set_elements_x_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  const MPI_Count* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_set_elements_x(
    (MPI_Status*)status,
    MPIF_Type_fromint(*datatype),
    *count
  );
}

void mpi_status_set_error_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const err,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_set_error(
    (MPI_Status*)status,
    *err
  );
}

void mpi_status_set_source_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const source,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_set_source(
    (MPI_Status*)status,
    *source
  );
}

void mpi_status_set_tag_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const tag,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Status_set_tag(
    (MPI_Status*)status,
    *tag
  );
}

void mpi_test_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPIF_Request_fromint(*request);
  MPI_Fint c_flag;
  *ierror = MPI_Test(
    &c_request,
    &c_flag,
    (MPI_Status*)status
  );
  *request = MPIF_Request_toint(c_request);
  *flag = c_flag ? 1 : 0;
}

void mpi_test_cancelled_(
  const MPI_Fint* restrict const status,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Test_cancelled(
    (const MPI_Status*)status,
    &c_flag
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_testall_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const array_of_statuses,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPIF_Request_fromint(*array_of_requests);
  MPI_Fint c_flag;
  *ierror = MPI_Testall(
    *count,
    &c_array_of_requests,
    &c_flag,
    (MPI_Status*)array_of_statuses
  );
  *array_of_requests = MPIF_Request_toint(c_array_of_requests);
  *flag = c_flag ? 1 : 0;
}

void mpi_testany_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const index,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPIF_Request_fromint(*array_of_requests);
  MPI_Fint c_flag;
  *ierror = MPI_Testany(
    *count,
    &c_array_of_requests,
    index,
    &c_flag,
    (MPI_Status*)status
  );
  *array_of_requests = MPIF_Request_toint(c_array_of_requests);
  *flag = c_flag ? 1 : 0;
}

void mpi_testsome_(
  const MPI_Fint* restrict const incount,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const outcount,
  MPI_Fint* restrict const array_of_indices,
  MPI_Fint* restrict const array_of_statuses,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPIF_Request_fromint(*array_of_requests);
  *ierror = MPI_Testsome(
    *incount,
    &c_array_of_requests,
    outcount,
    array_of_indices,
    (MPI_Status*)array_of_statuses
  );
  *array_of_requests = MPIF_Request_toint(c_array_of_requests);
}

void mpi_topo_test_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Topo_test(
    MPIF_Comm_fromint(*comm),
    status
  );
}

void mpi_type_commit_(
  MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_datatype = MPIF_Type_fromint(*datatype);
  *ierror = MPI_Type_commit(
    &c_datatype
  );
  *datatype = MPIF_Type_toint(c_datatype);
}

void mpi_type_contiguous_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_contiguous(
    *count,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_contiguous_c_(
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_contiguous_c(
    *count,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_darray_(
  const MPI_Fint* restrict const size,
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const ndims,
  const MPI_Fint* restrict const array_of_gsizes,
  const MPI_Fint* restrict const array_of_distribs,
  const MPI_Fint* restrict const array_of_dargs,
  const MPI_Fint* restrict const array_of_psizes,
  const MPI_Fint* restrict const order,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_darray(
    *size,
    *rank,
    *ndims,
    array_of_gsizes,
    array_of_distribs,
    array_of_dargs,
    array_of_psizes,
    *order,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_darray_c_(
  const MPI_Fint* restrict const size,
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const ndims,
  const MPI_Count* restrict const array_of_gsizes,
  const MPI_Fint* restrict const array_of_distribs,
  const MPI_Fint* restrict const array_of_dargs,
  const MPI_Fint* restrict const array_of_psizes,
  const MPI_Fint* restrict const order,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_darray_c(
    *size,
    *rank,
    *ndims,
    array_of_gsizes,
    array_of_distribs,
    array_of_dargs,
    array_of_psizes,
    *order,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_f90_complex_(
  const MPI_Fint* restrict const p,
  const MPI_Fint* restrict const r,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_f90_complex(
    *p,
    *r,
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_f90_integer_(
  const MPI_Fint* restrict const r,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_f90_integer(
    *r,
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_f90_real_(
  const MPI_Fint* restrict const p,
  const MPI_Fint* restrict const r,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_f90_real(
    *p,
    *r,
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_hindexed_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const array_of_blocklengths,
  const MPI_Aint* restrict const array_of_displacements,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_hindexed(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_hindexed_c_(
  const MPI_Count* restrict const count,
  const MPI_Count* restrict const array_of_blocklengths,
  const MPI_Count* restrict const array_of_displacements,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_hindexed_c(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_hindexed_block_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const blocklength,
  const MPI_Aint* restrict const array_of_displacements,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_hindexed_block(
    *count,
    *blocklength,
    array_of_displacements,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_hindexed_block_c_(
  const MPI_Count* restrict const count,
  const MPI_Count* restrict const blocklength,
  const MPI_Count* restrict const array_of_displacements,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_hindexed_block_c(
    *count,
    *blocklength,
    array_of_displacements,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_hvector_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const blocklength,
  const MPI_Aint* restrict const stride,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_hvector(
    *count,
    *blocklength,
    *stride,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_hvector_c_(
  const MPI_Count* restrict const count,
  const MPI_Count* restrict const blocklength,
  const MPI_Count* restrict const stride,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_hvector_c(
    *count,
    *blocklength,
    *stride,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_indexed_block_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const blocklength,
  const MPI_Fint* restrict const array_of_displacements,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_indexed_block(
    *count,
    *blocklength,
    array_of_displacements,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_indexed_block_c_(
  const MPI_Count* restrict const count,
  const MPI_Count* restrict const blocklength,
  const MPI_Count* restrict const array_of_displacements,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_indexed_block_c(
    *count,
    *blocklength,
    array_of_displacements,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_keyval_(
  MPI_Type_copy_attr_function* const type_copy_attr_fn,
  MPI_Type_delete_attr_function* const type_delete_attr_fn,
  MPI_Fint* restrict const type_keyval,
  const MPI_Aint* restrict const extra_state,
  MPI_Fint* restrict const ierror
)
{
  abort();
  abort();
  *ierror = MPI_Type_create_keyval(
    type_copy_attr_fn,
    type_delete_attr_fn,
    type_keyval,
    (void*)*extra_state
  );
}

void mpi_type_create_resized_(
  const MPI_Fint* restrict const oldtype,
  const MPI_Aint* restrict const lb,
  const MPI_Aint* restrict const extent,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_resized(
    MPIF_Type_fromint(*oldtype),
    *lb,
    *extent,
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_resized_c_(
  const MPI_Fint* restrict const oldtype,
  const MPI_Count* restrict const lb,
  const MPI_Count* restrict const extent,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_resized_c(
    MPIF_Type_fromint(*oldtype),
    *lb,
    *extent,
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_struct_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const array_of_blocklengths,
  const MPI_Aint* restrict const array_of_displacements,
  const MPI_Fint* restrict const array_of_types,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_array_of_types[*count];
  for (int rank=0; rank<*count; ++rank)
    c_array_of_types[rank] = MPIF_Type_fromint(array_of_types[rank]);
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_struct(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    c_array_of_types,
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_struct_c_(
  const MPI_Count* restrict const count,
  const MPI_Count* restrict const array_of_blocklengths,
  const MPI_Count* restrict const array_of_displacements,
  const MPI_Fint* restrict const array_of_types,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_array_of_types[*count];
  for (int rank=0; rank<*count; ++rank)
    c_array_of_types[rank] = MPIF_Type_fromint(array_of_types[rank]);
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_struct_c(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    c_array_of_types,
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_subarray_(
  const MPI_Fint* restrict const ndims,
  const MPI_Fint* restrict const array_of_sizes,
  const MPI_Fint* restrict const array_of_subsizes,
  const MPI_Fint* restrict const array_of_starts,
  const MPI_Fint* restrict const order,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_subarray(
    *ndims,
    array_of_sizes,
    array_of_subsizes,
    array_of_starts,
    *order,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_create_subarray_c_(
  const MPI_Fint* restrict const ndims,
  const MPI_Count* restrict const array_of_sizes,
  const MPI_Count* restrict const array_of_subsizes,
  const MPI_Count* restrict const array_of_starts,
  const MPI_Fint* restrict const order,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_create_subarray_c(
    *ndims,
    array_of_sizes,
    array_of_subsizes,
    array_of_starts,
    *order,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_delete_attr_(
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const type_keyval,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_delete_attr(
    MPIF_Type_fromint(*datatype),
    *type_keyval
  );
}

void mpi_type_dup_(
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_dup(
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_free_(
  MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_datatype = MPIF_Type_fromint(*datatype);
  *ierror = MPI_Type_free(
    &c_datatype
  );
  *datatype = MPIF_Type_toint(c_datatype);
}

void mpi_type_free_keyval_(
  MPI_Fint* restrict const type_keyval,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_free_keyval(
    type_keyval
  );
}

void mpi_type_get_attr_(
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const type_keyval,
  MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  void *c_attribute_val;
  MPI_Fint c_flag;
  *ierror = MPI_Type_get_attr(
    MPIF_Type_fromint(*datatype),
    *type_keyval,
    &c_attribute_val,
    &c_flag
  );
  *attribute_val = (MPI_Aint)c_attribute_val;
  *flag = c_flag ? 1 : 0;
}

void mpi_type_get_contents_(
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const max_integers,
  const MPI_Fint* restrict const max_addresses,
  const MPI_Fint* restrict const max_datatypes,
  MPI_Fint* restrict const array_of_integers,
  MPI_Aint* restrict const array_of_addresses,
  MPI_Fint* restrict const array_of_datatypes,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_array_of_datatypes;
  *ierror = MPI_Type_get_contents(
    MPIF_Type_fromint(*datatype),
    *max_integers,
    *max_addresses,
    *max_datatypes,
    array_of_integers,
    array_of_addresses,
    &c_array_of_datatypes
  );
  *array_of_datatypes = MPIF_Type_toint(c_array_of_datatypes);
}

void mpi_type_get_contents_c_(
  const MPI_Fint* restrict const datatype,
  const MPI_Count* restrict const max_integers,
  const MPI_Count* restrict const max_addresses,
  const MPI_Count* restrict const max_large_counts,
  const MPI_Count* restrict const max_datatypes,
  MPI_Fint* restrict const array_of_integers,
  MPI_Aint* restrict const array_of_addresses,
  MPI_Count* restrict const array_of_large_counts,
  MPI_Fint* restrict const array_of_datatypes,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_array_of_datatypes;
  *ierror = MPI_Type_get_contents_c(
    MPIF_Type_fromint(*datatype),
    *max_integers,
    *max_addresses,
    *max_large_counts,
    *max_datatypes,
    array_of_integers,
    array_of_addresses,
    array_of_large_counts,
    &c_array_of_datatypes
  );
  *array_of_datatypes = MPIF_Type_toint(c_array_of_datatypes);
}

void mpi_type_get_envelope_(
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const num_integers,
  MPI_Fint* restrict const num_addresses,
  MPI_Fint* restrict const num_datatypes,
  MPI_Fint* restrict const combiner,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_get_envelope(
    MPIF_Type_fromint(*datatype),
    num_integers,
    num_addresses,
    num_datatypes,
    combiner
  );
}

void mpi_type_get_envelope_c_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const num_integers,
  MPI_Count* restrict const num_addresses,
  MPI_Count* restrict const num_large_counts,
  MPI_Count* restrict const num_datatypes,
  MPI_Fint* restrict const combiner,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_get_envelope_c(
    MPIF_Type_fromint(*datatype),
    num_integers,
    num_addresses,
    num_large_counts,
    num_datatypes,
    combiner
  );
}

void mpi_type_get_extent_(
  const MPI_Fint* restrict const datatype,
  MPI_Aint* restrict const lb,
  MPI_Aint* restrict const extent,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_get_extent(
    MPIF_Type_fromint(*datatype),
    lb,
    extent
  );
}

void mpi_type_get_extent_c_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const lb,
  MPI_Count* restrict const extent,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_get_extent_c(
    MPIF_Type_fromint(*datatype),
    lb,
    extent
  );
}

void mpi_type_get_extent_x_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const lb,
  MPI_Count* restrict const extent,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_get_extent_x(
    MPIF_Type_fromint(*datatype),
    lb,
    extent
  );
}

void mpi_type_get_name_(
  const MPI_Fint* restrict const datatype,
  char* restrict const type_name,
  MPI_Fint* restrict const resultlen,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_type_name = MPI_MAX_OBJECT_NAME;
  char c_type_name[length_type_name + 1];
  *ierror = MPI_Type_get_name(
    MPIF_Type_fromint(*datatype),
    c_type_name,
    resultlen
  );
  mpif_strcpy_c2f(type_name, c_type_name, length_type_name, strlen(c_type_name));
}

void mpi_type_get_true_extent_(
  const MPI_Fint* restrict const datatype,
  MPI_Aint* restrict const true_lb,
  MPI_Aint* restrict const true_extent,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_get_true_extent(
    MPIF_Type_fromint(*datatype),
    true_lb,
    true_extent
  );
}

void mpi_type_get_true_extent_c_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const true_lb,
  MPI_Count* restrict const true_extent,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_get_true_extent_c(
    MPIF_Type_fromint(*datatype),
    true_lb,
    true_extent
  );
}

void mpi_type_get_true_extent_x_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const true_lb,
  MPI_Count* restrict const true_extent,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_get_true_extent_x(
    MPIF_Type_fromint(*datatype),
    true_lb,
    true_extent
  );
}

void mpi_type_get_value_index_(
  const MPI_Fint* restrict const value_type,
  const MPI_Fint* restrict const index_type,
  MPI_Fint* restrict const pair_type,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_pair_type;
  *ierror = MPI_Type_get_value_index(
    MPIF_Type_fromint(*value_type),
    MPIF_Type_fromint(*index_type),
    &c_pair_type
  );
  *pair_type = MPIF_Type_toint(c_pair_type);
}

void mpi_type_indexed_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const array_of_blocklengths,
  const MPI_Fint* restrict const array_of_displacements,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_indexed(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_indexed_c_(
  const MPI_Count* restrict const count,
  const MPI_Count* restrict const array_of_blocklengths,
  const MPI_Count* restrict const array_of_displacements,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_indexed_c(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_match_size_(
  const MPI_Fint* restrict const typeclass,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_datatype;
  *ierror = MPI_Type_match_size(
    *typeclass,
    *size,
    &c_datatype
  );
  *datatype = MPIF_Type_toint(c_datatype);
}

void mpi_type_set_attr_(
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const type_keyval,
  const MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_set_attr(
    MPIF_Type_fromint(*datatype),
    *type_keyval,
    (void*)*attribute_val
  );
}

void mpi_type_set_name_(
  const MPI_Fint* restrict const datatype,
  const char* restrict const type_name,
  MPI_Fint* restrict const ierror,
  const size_t length_type_name
)
{
  char* const c_type_name = mpif_strdup_f2c(type_name, length_type_name);
  *ierror = MPI_Type_set_name(
    MPIF_Type_fromint(*datatype),
    c_type_name
  );
  free(c_type_name);
}

void mpi_type_size_(
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_size(
    MPIF_Type_fromint(*datatype),
    size
  );
}

void mpi_type_size_c_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_size_c(
    MPIF_Type_fromint(*datatype),
    size
  );
}

void mpi_type_size_x_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Type_size_x(
    MPIF_Type_fromint(*datatype),
    size
  );
}

void mpi_type_vector_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const blocklength,
  const MPI_Fint* restrict const stride,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_vector(
    *count,
    *blocklength,
    *stride,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_type_vector_c_(
  const MPI_Count* restrict const count,
  const MPI_Count* restrict const blocklength,
  const MPI_Count* restrict const stride,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  *ierror = MPI_Type_vector_c(
    *count,
    *blocklength,
    *stride,
    MPIF_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPIF_Type_toint(c_newtype);
}

void mpi_unpack_(
  const void* restrict const inbuf,
  const MPI_Fint* restrict const insize,
  MPI_Fint* restrict const position,
  void* restrict const outbuf,
  const MPI_Fint* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Unpack(
    inbuf,
    *insize,
    position,
    outbuf,
    *outcount,
    MPIF_Type_fromint(*datatype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_unpack_c_(
  const void* restrict const inbuf,
  const MPI_Count* restrict const insize,
  MPI_Count* restrict const position,
  void* restrict const outbuf,
  const MPI_Count* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Unpack_c(
    inbuf,
    *insize,
    position,
    outbuf,
    *outcount,
    MPIF_Type_fromint(*datatype),
    MPIF_Comm_fromint(*comm)
  );
}

void mpi_unpack_external_(
  const char* restrict const datarep,
  const void* restrict const inbuf,
  const MPI_Aint* restrict const insize,
  MPI_Aint* restrict const position,
  void* restrict const outbuf,
  const MPI_Fint* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  *ierror = MPI_Unpack_external(
    c_datarep,
    inbuf,
    *insize,
    position,
    outbuf,
    *outcount,
    MPIF_Type_fromint(*datatype)
  );
  free(c_datarep);
}

void mpi_unpack_external_c_(
  const char* restrict const datarep,
  const void* restrict const inbuf,
  const MPI_Count* restrict const insize,
  MPI_Count* restrict const position,
  void* restrict const outbuf,
  const MPI_Count* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  *ierror = MPI_Unpack_external_c(
    c_datarep,
    inbuf,
    *insize,
    position,
    outbuf,
    *outcount,
    MPIF_Type_fromint(*datatype)
  );
  free(c_datarep);
}

void mpi_unpublish_name_(
  const char* restrict const service_name,
  const MPI_Fint* restrict const info,
  const char* restrict const port_name,
  MPI_Fint* restrict const ierror,
  const size_t length_service_name,
  const size_t length_port_name
)
{
  char* const c_service_name = mpif_strdup_f2c(service_name, length_service_name);
  char* const c_port_name = mpif_strdup_f2c(port_name, length_port_name);
  *ierror = MPI_Unpublish_name(
    c_service_name,
    MPIF_Info_fromint(*info),
    c_port_name
  );
  free(c_service_name);
  free(c_port_name);
}

void mpi_wait_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPIF_Request_fromint(*request);
  *ierror = MPI_Wait(
    &c_request,
    (MPI_Status*)status
  );
  *request = MPIF_Request_toint(c_request);
}

void mpi_waitall_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const array_of_statuses,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPIF_Request_fromint(*array_of_requests);
  *ierror = MPI_Waitall(
    *count,
    &c_array_of_requests,
    (MPI_Status*)array_of_statuses
  );
  *array_of_requests = MPIF_Request_toint(c_array_of_requests);
}

void mpi_waitany_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const index,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPIF_Request_fromint(*array_of_requests);
  *ierror = MPI_Waitany(
    *count,
    &c_array_of_requests,
    index,
    (MPI_Status*)status
  );
  *array_of_requests = MPIF_Request_toint(c_array_of_requests);
}

void mpi_waitsome_(
  const MPI_Fint* restrict const incount,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const outcount,
  MPI_Fint* restrict const array_of_indices,
  MPI_Fint* restrict const array_of_statuses,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPIF_Request_fromint(*array_of_requests);
  *ierror = MPI_Waitsome(
    *incount,
    &c_array_of_requests,
    outcount,
    array_of_indices,
    (MPI_Status*)array_of_statuses
  );
  *array_of_requests = MPIF_Request_toint(c_array_of_requests);
}

void mpi_win_allocate_(
  const MPI_Aint* restrict const size,
  const MPI_Fint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Aint* restrict const baseptr,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win;
  *ierror = MPI_Win_allocate(
    *size,
    *disp_unit,
    MPIF_Info_fromint(*info),
    MPIF_Comm_fromint(*comm),
    baseptr,
    &c_win
  );
  *win = MPIF_Win_toint(c_win);
}

void mpi_win_allocate_c_(
  const MPI_Aint* restrict const size,
  const MPI_Aint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Aint* restrict const baseptr,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win;
  *ierror = MPI_Win_allocate_c(
    *size,
    *disp_unit,
    MPIF_Info_fromint(*info),
    MPIF_Comm_fromint(*comm),
    baseptr,
    &c_win
  );
  *win = MPIF_Win_toint(c_win);
}

void mpi_win_allocate_shared_(
  const MPI_Aint* restrict const size,
  const MPI_Fint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Aint* restrict const baseptr,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win;
  *ierror = MPI_Win_allocate_shared(
    *size,
    *disp_unit,
    MPIF_Info_fromint(*info),
    MPIF_Comm_fromint(*comm),
    baseptr,
    &c_win
  );
  *win = MPIF_Win_toint(c_win);
}

void mpi_win_allocate_shared_c_(
  const MPI_Aint* restrict const size,
  const MPI_Aint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Aint* restrict const baseptr,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win;
  *ierror = MPI_Win_allocate_shared_c(
    *size,
    *disp_unit,
    MPIF_Info_fromint(*info),
    MPIF_Comm_fromint(*comm),
    baseptr,
    &c_win
  );
  *win = MPIF_Win_toint(c_win);
}

void mpi_win_attach_(
  const MPI_Fint* restrict const win,
  void* restrict const base,
  const MPI_Aint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_attach(
    MPIF_Win_fromint(*win),
    base,
    *size
  );
}

void mpi_win_call_errhandler_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_call_errhandler(
    MPIF_Win_fromint(*win),
    *errorcode
  );
}

void mpi_win_complete_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_complete(
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_create_(
  void* restrict const base,
  const MPI_Aint* restrict const size,
  const MPI_Fint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win;
  *ierror = MPI_Win_create(
    base,
    *size,
    *disp_unit,
    MPIF_Info_fromint(*info),
    MPIF_Comm_fromint(*comm),
    &c_win
  );
  *win = MPIF_Win_toint(c_win);
}

void mpi_win_create_c_(
  void* restrict const base,
  const MPI_Aint* restrict const size,
  const MPI_Aint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win;
  *ierror = MPI_Win_create_c(
    base,
    *size,
    *disp_unit,
    MPIF_Info_fromint(*info),
    MPIF_Comm_fromint(*comm),
    &c_win
  );
  *win = MPIF_Win_toint(c_win);
}

void mpi_win_create_dynamic_(
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win;
  *ierror = MPI_Win_create_dynamic(
    MPIF_Info_fromint(*info),
    MPIF_Comm_fromint(*comm),
    &c_win
  );
  *win = MPIF_Win_toint(c_win);
}

void mpi_win_create_errhandler_(
  MPI_Win_errhandler_function* const win_errhandler_fn,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Errhandler c_errhandler;
  *ierror = MPI_Win_create_errhandler(
    win_errhandler_fn,
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_win_create_keyval_(
  MPI_Win_copy_attr_function* const win_copy_attr_fn,
  MPI_Win_delete_attr_function* const win_delete_attr_fn,
  MPI_Fint* restrict const win_keyval,
  const MPI_Aint* restrict const extra_state,
  MPI_Fint* restrict const ierror
)
{
  abort();
  abort();
  *ierror = MPI_Win_create_keyval(
    win_copy_attr_fn,
    win_delete_attr_fn,
    win_keyval,
    (void*)*extra_state
  );
}

void mpi_win_delete_attr_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const win_keyval,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_delete_attr(
    MPIF_Win_fromint(*win),
    *win_keyval
  );
}

void mpi_win_detach_(
  const MPI_Fint* restrict const win,
  const void* restrict const base,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_detach(
    MPIF_Win_fromint(*win),
    base
  );
}

void mpi_win_fence_(
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_fence(
    *assert,
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_flush_(
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_flush(
    *rank,
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_flush_all_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_flush_all(
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_flush_local_(
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_flush_local(
    *rank,
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_flush_local_all_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_flush_local_all(
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_free_(
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win = MPIF_Win_fromint(*win);
  *ierror = MPI_Win_free(
    &c_win
  );
  *win = MPIF_Win_toint(c_win);
}

void mpi_win_free_keyval_(
  MPI_Fint* restrict const win_keyval,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_free_keyval(
    win_keyval
  );
}

void mpi_win_get_attr_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const win_keyval,
  MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  void *c_attribute_val;
  MPI_Fint c_flag;
  *ierror = MPI_Win_get_attr(
    MPIF_Win_fromint(*win),
    *win_keyval,
    &c_attribute_val,
    &c_flag
  );
  *attribute_val = (MPI_Aint)c_attribute_val;
  *flag = c_flag ? 1 : 0;
}

void mpi_win_get_errhandler_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler;
  *ierror = MPI_Win_get_errhandler(
    MPIF_Win_fromint(*win),
    &c_errhandler
  );
  *errhandler = MPIF_Errhandler_toint(c_errhandler);
}

void mpi_win_get_group_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group;
  *ierror = MPI_Win_get_group(
    MPIF_Win_fromint(*win),
    &c_group
  );
  *group = MPIF_Group_toint(c_group);
}

void mpi_win_get_info_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const info_used,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info_used;
  *ierror = MPI_Win_get_info(
    MPIF_Win_fromint(*win),
    &c_info_used
  );
  *info_used = MPIF_Info_toint(c_info_used);
}

void mpi_win_get_name_(
  const MPI_Fint* restrict const win,
  char* restrict const win_name,
  MPI_Fint* restrict const resultlen,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_win_name = MPI_MAX_OBJECT_NAME;
  char c_win_name[length_win_name + 1];
  *ierror = MPI_Win_get_name(
    MPIF_Win_fromint(*win),
    c_win_name,
    resultlen
  );
  mpif_strcpy_c2f(win_name, c_win_name, length_win_name, strlen(c_win_name));
}

void mpi_win_lock_(
  const MPI_Fint* restrict const lock_type,
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_lock(
    *lock_type,
    *rank,
    *assert,
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_lock_all_(
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_lock_all(
    *assert,
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_post_(
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_post(
    MPIF_Group_fromint(*group),
    *assert,
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_set_attr_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const win_keyval,
  const MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_set_attr(
    MPIF_Win_fromint(*win),
    *win_keyval,
    (void*)*attribute_val
  );
}

void mpi_win_set_errhandler_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_set_errhandler(
    MPIF_Win_fromint(*win),
    MPIF_Errhandler_fromint(*errhandler)
  );
}

void mpi_win_set_info_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_set_info(
    MPIF_Win_fromint(*win),
    MPIF_Info_fromint(*info)
  );
}

void mpi_win_set_name_(
  const MPI_Fint* restrict const win,
  const char* restrict const win_name,
  MPI_Fint* restrict const ierror,
  const size_t length_win_name
)
{
  char* const c_win_name = mpif_strdup_f2c(win_name, length_win_name);
  *ierror = MPI_Win_set_name(
    MPIF_Win_fromint(*win),
    c_win_name
  );
  free(c_win_name);
}

void mpi_win_shared_query_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const rank,
  MPI_Aint* restrict const size,
  MPI_Fint* restrict const disp_unit,
  MPI_Aint* restrict const baseptr,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_shared_query(
    MPIF_Win_fromint(*win),
    *rank,
    size,
    disp_unit,
    baseptr
  );
}

void mpi_win_shared_query_c_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const rank,
  MPI_Aint* restrict const size,
  MPI_Aint* restrict const disp_unit,
  MPI_Aint* restrict const baseptr,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_shared_query_c(
    MPIF_Win_fromint(*win),
    *rank,
    size,
    disp_unit,
    baseptr
  );
}

void mpi_win_start_(
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_start(
    MPIF_Group_fromint(*group),
    *assert,
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_sync_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_sync(
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_test_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  *ierror = MPI_Win_test(
    MPIF_Win_fromint(*win),
    &c_flag
  );
  *flag = c_flag ? 1 : 0;
}

void mpi_win_unlock_(
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_unlock(
    *rank,
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_unlock_all_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_unlock_all(
    MPIF_Win_fromint(*win)
  );
}

void mpi_win_wait_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  *ierror = MPI_Win_wait(
    MPIF_Win_fromint(*win)
  );
}

double mpi_wtick_(
)
{
  const double result = MPI_Wtick(
  );
  return result;
}

double mpi_wtime_(
)
{
  const double result = MPI_Wtime(
  );
  return result;
}
