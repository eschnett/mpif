#include <mpi.h>

#include <stdlib.h>

void subf90_(const MPI_Fint *comm_null, const MPI_Fint *comm_self,
             const MPI_Fint *comm_world,

             const MPI_Fint *datatype_c_bool,
             const MPI_Fint *datatype_c_complex,
             const MPI_Fint *datatype_complex, const MPI_Fint *datatype_double,
             const MPI_Fint *datatype_double_precision,
             const MPI_Fint *datatype_float, const MPI_Fint *datatype_int,
             const MPI_Fint *datatype_integer, const MPI_Fint *datatype_logical,
             const MPI_Fint *datatype_null, const MPI_Fint *datatype_real,

             const MPI_Fint *errhandler_null, const MPI_Fint *errors_abort,
             const MPI_Fint *errors_are_fatal, const MPI_Fint *errors_return,

             const MPI_Fint *file_null,

             const MPI_Fint *group_null, const MPI_Fint *group_empty,

             const MPI_Fint *info_env, const MPI_Fint *info_null,

             const MPI_Fint *message_no_proc, const MPI_Fint *message_null,

             const MPI_Fint *op_max, const MPI_Fint *op_maxloc,
             const MPI_Fint *op_min, const MPI_Fint *op_minloc,
             const MPI_Fint *op_no_op, const MPI_Fint *op_null,
             const MPI_Fint *op_prod, const MPI_Fint *op_replace,
             const MPI_Fint *op_sum,

             const MPI_Fint *request_null,

             const MPI_Fint *session_null,

             const MPI_Fint *win_null);

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  const MPI_Fint comm_null = MPI_Comm_c2f(MPI_COMM_NULL);
  const MPI_Fint comm_self = MPI_Comm_c2f(MPI_COMM_SELF);
  const MPI_Fint comm_world = MPI_Comm_c2f(MPI_COMM_WORLD);

  const MPI_Fint datatype_c_bool = MPI_Type_c2f(MPI_C_BOOL);
  const MPI_Fint datatype_c_complex = MPI_Type_c2f(MPI_C_COMPLEX);
  const MPI_Fint datatype_complex = MPI_Type_c2f(MPI_COMPLEX);
  const MPI_Fint datatype_double = MPI_Type_c2f(MPI_DOUBLE);
  const MPI_Fint datatype_double_precision = MPI_Type_c2f(MPI_DOUBLE_PRECISION);
  const MPI_Fint datatype_float = MPI_Type_c2f(MPI_FLOAT);
  const MPI_Fint datatype_int = MPI_Type_c2f(MPI_INT);
  const MPI_Fint datatype_integer = MPI_Type_c2f(MPI_INTEGER);
  const MPI_Fint datatype_logical = MPI_Type_c2f(MPI_LOGICAL);
  const MPI_Fint datatype_null = MPI_Type_c2f(MPI_DATATYPE_NULL);
  const MPI_Fint datatype_real = MPI_Type_c2f(MPI_REAL);

  const MPI_Fint errhandler_null = MPI_Errhandler_c2f(MPI_ERRHANDLER_NULL);
  const MPI_Fint errors_abort = MPI_Errhandler_c2f(MPI_ERRORS_ABORT);
  const MPI_Fint errors_are_fatal = MPI_Errhandler_c2f(MPI_ERRORS_ARE_FATAL);
  const MPI_Fint errors_return = MPI_Errhandler_c2f(MPI_ERRORS_RETURN);

  const MPI_Fint file_null = MPI_File_c2f(MPI_FILE_NULL);

  const MPI_Fint group_null = MPI_Group_c2f(MPI_GROUP_NULL);
  const MPI_Fint group_empty = MPI_Group_c2f(MPI_GROUP_EMPTY);

  const MPI_Fint info_env = MPI_Info_c2f(MPI_INFO_ENV);
  const MPI_Fint info_null = MPI_Info_c2f(MPI_INFO_NULL);

  const MPI_Fint message_no_proc = MPI_Message_c2f(MPI_MESSAGE_NO_PROC);
  const MPI_Fint message_null = MPI_Message_c2f(MPI_MESSAGE_NULL);

  const MPI_Fint op_max = MPI_Op_c2f(MPI_MAX);
  const MPI_Fint op_maxloc = MPI_Op_c2f(MPI_MAXLOC);
  const MPI_Fint op_min = MPI_Op_c2f(MPI_MIN);
  const MPI_Fint op_minloc = MPI_Op_c2f(MPI_MINLOC);
  const MPI_Fint op_no_op = MPI_Op_c2f(MPI_NO_OP);
  const MPI_Fint op_null = MPI_Op_c2f(MPI_OP_NULL);
  const MPI_Fint op_prod = MPI_Op_c2f(MPI_PROD);
  const MPI_Fint op_replace = MPI_Op_c2f(MPI_REPLACE);
  const MPI_Fint op_sum = MPI_Op_c2f(MPI_SUM);

  const MPI_Fint request_null = MPI_Request_c2f(MPI_REQUEST_NULL);

  const MPI_Fint session_null = MPI_Session_c2f(MPI_SESSION_NULL);

  const MPI_Fint win_null = MPI_Win_c2f(MPI_WIN_NULL);

  if (MPI_Comm_f2c(comm_null) != MPI_COMM_NULL)
    abort();
  if (MPI_Comm_f2c(comm_self) != MPI_COMM_SELF)
    abort();
  if (MPI_Comm_f2c(comm_world) != MPI_COMM_WORLD)
    abort();

  if (MPI_Type_f2c(datatype_c_bool) != MPI_C_BOOL)
    abort();
  if (MPI_Type_f2c(datatype_c_complex) != MPI_C_COMPLEX)
    abort();
  if (MPI_Type_f2c(datatype_complex) != MPI_COMPLEX)
    abort();
  if (MPI_Type_f2c(datatype_double) != MPI_DOUBLE)
    abort();
  if (MPI_Type_f2c(datatype_double_precision) != MPI_DOUBLE_PRECISION)
    abort();
  if (MPI_Type_f2c(datatype_float) != MPI_FLOAT)
    abort();
  if (MPI_Type_f2c(datatype_int) != MPI_INT)
    abort();
  if (MPI_Type_f2c(datatype_integer) != MPI_INTEGER)
    abort();
  if (MPI_Type_f2c(datatype_logical) != MPI_LOGICAL)
    abort();
  if (MPI_Type_f2c(datatype_null) != MPI_DATATYPE_NULL)
    abort();
  if (MPI_Type_f2c(datatype_real) != MPI_REAL)
    abort();

  if (MPI_Errhandler_f2c(errhandler_null) != MPI_ERRHANDLER_NULL)
    abort();
  if (MPI_Errhandler_f2c(errors_abort) != MPI_ERRORS_ABORT)
    abort();
  if (MPI_Errhandler_f2c(errors_are_fatal) != MPI_ERRORS_ARE_FATAL)
    abort();
  if (MPI_Errhandler_f2c(errors_return) != MPI_ERRORS_RETURN)
    abort();

  if (MPI_File_f2c(file_null) != MPI_FILE_NULL)
    abort();

  if (MPI_Group_f2c(group_null) != MPI_GROUP_NULL)
    abort();
  if (MPI_Group_f2c(group_empty) != MPI_GROUP_EMPTY)
    abort();

  if (MPI_Info_f2c(info_env) != MPI_INFO_ENV)
    abort();
  if (MPI_Info_f2c(info_null) != MPI_INFO_NULL)
    abort();

  if (MPI_Message_f2c(message_no_proc) != MPI_MESSAGE_NO_PROC)
    abort();
  if (MPI_Message_f2c(message_null) != MPI_MESSAGE_NULL)
    abort();

  if (MPI_Op_f2c(op_max) != MPI_MAX)
    abort();
  if (MPI_Op_f2c(op_maxloc) != MPI_MAXLOC)
    abort();
  if (MPI_Op_f2c(op_min) != MPI_MIN)
    abort();
  if (MPI_Op_f2c(op_minloc) != MPI_MINLOC)
    abort();
  if (MPI_Op_f2c(op_no_op) != MPI_NO_OP)
    abort();
  if (MPI_Op_f2c(op_null) != MPI_OP_NULL)
    abort();
  if (MPI_Op_f2c(op_prod) != MPI_PROD)
    abort();
  if (MPI_Op_f2c(op_replace) != MPI_REPLACE)
    abort();
  if (MPI_Op_f2c(op_sum) != MPI_SUM)
    abort();

  if (MPI_Request_f2c(request_null) != MPI_REQUEST_NULL)
    abort();

  if (MPI_Session_f2c(session_null) != MPI_SESSION_NULL)
    abort();

  if (MPI_Win_f2c(win_null) != MPI_WIN_NULL)
    abort();

  subf90_(&comm_null, &comm_self, &comm_world,

          &datatype_c_bool, &datatype_c_complex, &datatype_complex,
          &datatype_double, &datatype_double_precision, &datatype_float,
          &datatype_int, &datatype_integer, &datatype_logical, &datatype_null,
          &datatype_real,

          &errhandler_null, &errors_abort, &errors_are_fatal, &errors_return,

          &file_null,

          &group_null, &group_empty,

          &info_env, &info_null,

          &message_no_proc, &message_null,

          &op_max, &op_maxloc, &op_min, &op_minloc, &op_no_op, &op_null,
          &op_prod, &op_replace, &op_sum,

          &request_null,

          &session_null,

          &win_null);

  MPI_Finalize();
}
