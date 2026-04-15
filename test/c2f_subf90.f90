subroutine subf90(comm_null, comm_self, comm_world, &
     datatype_c_bool, datatype_c_complex, datatype_complex, datatype_double, datatype_double_precision, datatype_float, &
     datatype_int, datatype_integer, datatype_logical, datatype_null, datatype_real,&
     errhandler_null, errors_abort, errors_are_fatal, errors_return,&
     file_null, &
     group_null, group_empty, &
     info_env, info_null, &
     message_no_proc, message_null, &
     op_max, op_maxloc, op_min, op_minloc, op_no_op, op_null, op_prod, op_replace, op_sum, &
     request_null, &
     session_null, &
     win_null)
  use mpi
  implicit none
  integer comm_null, comm_self, comm_world
  integer datatype_c_bool, datatype_c_complex, datatype_complex, datatype_double, datatype_double_precision, datatype_float, &
       datatype_int, datatype_integer, datatype_logical, datatype_null, datatype_real
  integer errhandler_null, errors_abort, errors_are_fatal, errors_return
  integer file_null
  integer group_null, group_empty
  integer info_env, info_null
  integer message_no_proc, message_null
  integer op_max, op_maxloc, op_min, op_minloc, op_no_op, op_null, op_prod, op_replace, op_sum
  integer request_null
  integer session_null
  integer win_null

  if (comm_null /= MPI_COMM_NULL) stop 1
  if (comm_self /= MPI_COMM_SELF) stop 1
  if (comm_world /= MPI_COMM_WORLD) stop 1

  if (datatype_c_bool /= MPI_C_BOOL) stop 1
  if (datatype_c_complex /= MPI_C_COMPLEX) stop 1
  if (datatype_complex /= MPI_COMPLEX) stop 1
  if (datatype_double /= MPI_DOUBLE) stop 1
  if (datatype_double_precision /= MPI_DOUBLE_PRECISION) stop 1
  if (datatype_float /= MPI_FLOAT) stop 1
  if (datatype_int /= MPI_INT) stop 1
  if (datatype_integer /= MPI_INTEGER) stop 1
  if (datatype_logical /= MPI_LOGICAL) stop 1
  if (datatype_null /= MPI_DATATYPE_NULL) stop 1
  if (datatype_real /= MPI_REAL) stop 1

  if (errhandler_null /= MPI_ERRHANDLER_NULL) stop 1
  if (errors_abort /= MPI_ERRORS_ABORT) stop 1
  if (errors_are_fatal /= MPI_ERRORS_ARE_FATAL) stop 1
  if (errors_return /= MPI_ERRORS_RETURN) stop 1

  if (file_null /= MPI_FILE_NULL) stop 1

  if (group_null /= MPI_GROUP_NULL) stop 1
  if (group_empty /= MPI_GROUP_EMPTY) stop 1

  if (info_env /= MPI_INFO_ENV) stop 1
  if (info_null /= MPI_INFO_NULL) stop 1

  if (message_no_proc /= MPI_MESSAGE_NO_PROC) stop 1
  if (message_null /= MPI_MESSAGE_NULL) stop 1

  if (op_max /= MPI_MAX) stop 1
  if (op_maxloc /= MPI_MAXLOC) stop 1
  if (op_min /= MPI_MIN) stop 1
  if (op_minloc /= MPI_MINLOC) stop 1
  if (op_no_op /= MPI_NO_OP) stop 1
  if (op_null /= MPI_OP_NULL) stop 1
  if (op_prod /= MPI_PROD) stop 1
  if (op_replace /= MPI_REPLACE) stop 1
  if (op_sum /= MPI_SUM) stop 1

  if (request_null /= MPI_REQUEST_NULL) stop 1

  if (session_null /= MPI_SESSION_NULL) stop 1

  if (win_null /= MPI_WIN_NULL) stop 1
end subroutine subf90
