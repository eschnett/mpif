#include <mpi.h>
#include <string.h>

MPI_Comm PMPI_Comm_f2c(MPI_Fint comm)
{
  return PMPI_Comm_fromint(comm);
}

MPI_Fint PMPI_Comm_c2f(MPI_Comm comm)
{
  return PMPI_Comm_toint(comm);
}

MPI_Errhandler PMPI_Errhandler_f2c(MPI_Fint errhandler)
{
  return PMPI_Errhandler_fromint(errhandler);
}

MPI_Fint PMPI_Errhandler_c2f(MPI_Errhandler errhandler)
{
  return PMPI_Errhandler_toint(errhandler);
}

MPI_File PMPI_File_f2c(MPI_Fint file)
{
  return PMPI_File_fromint(file);
}

MPI_Fint PMPI_File_c2f(MPI_File file)
{
  return PMPI_File_toint(file);
}

MPI_Group PMPI_Group_f2c(MPI_Fint group)
{
  return PMPI_Group_fromint(group);
}

MPI_Fint PMPI_Group_c2f(MPI_Group group)
{
  return PMPI_Group_toint(group);
}

MPI_Info PMPI_Info_f2c(MPI_Fint info)
{
  return PMPI_Info_fromint(info);
}

MPI_Fint PMPI_Info_c2f(MPI_Info info)
{
  return PMPI_Info_toint(info);
}

MPI_Message PMPI_Message_f2c(MPI_Fint message)
{
  return PMPI_Message_fromint(message);
}

MPI_Fint PMPI_Message_c2f(MPI_Message message)
{
  return PMPI_Message_toint(message);
}

MPI_Op PMPI_Op_f2c(MPI_Fint op)
{
  return PMPI_Op_fromint(op);
}

MPI_Fint PMPI_Op_c2f(MPI_Op op)
{
  return PMPI_Op_toint(op);
}

MPI_Request PMPI_Request_f2c(MPI_Fint request)
{
  return PMPI_Request_fromint(request);
}

MPI_Fint PMPI_Request_c2f(MPI_Request request)
{
  return PMPI_Request_toint(request);
}

MPI_Session PMPI_Session_f2c(MPI_Fint session)
{
  return PMPI_Session_fromint(session);
}

MPI_Fint PMPI_Session_c2f(MPI_Session session)
{
  return PMPI_Session_toint(session);
}

MPI_Datatype PMPI_Type_f2c(MPI_Fint datatype)
{
  return PMPI_Type_fromint(datatype);
}

MPI_Fint PMPI_Type_c2f(MPI_Datatype datatype)
{
  return PMPI_Type_toint(datatype);
}

MPI_Win PMPI_Win_f2c(MPI_Fint win)
{
  return PMPI_Win_fromint(win);
}

MPI_Fint PMPI_Win_c2f(MPI_Win win)
{
  return PMPI_Win_toint(win);
}



MPI_Comm MPI_Comm_f2c(MPI_Fint comm)
{
  return PMPI_Comm_f2c(comm);
}

MPI_Fint MPI_Comm_c2f(MPI_Comm comm)
{
  return PMPI_Comm_c2f(comm);
}

MPI_Errhandler MPI_Errhandler_f2c(MPI_Fint errhandler)
{
  return MPI_Errhandler_f2c(errhandler);
}

MPI_Fint MPI_Errhandler_c2f(MPI_Errhandler errhandler)
{
  return PMPI_Errhandler_c2f(errhandler);
}

MPI_File MPI_File_f2c(MPI_Fint file)
{
  return PMPI_File_f2c(file);
}

MPI_Fint MPI_File_c2f(MPI_File file)
{
  return PMPI_File_c2f(file);
}

MPI_Group MPI_Group_f2c(MPI_Fint group)
{
  return PMPI_Group_f2c(group);
}

MPI_Fint MPI_Group_c2f(MPI_Group group)
{
  return PMPI_Group_c2f(group);
}

MPI_Info MPI_Info_f2c(MPI_Fint info)
{
  return PMPI_Info_f2c(info);
}

MPI_Fint MPI_Info_c2f(MPI_Info info)
{
  return PMPI_Info_c2f(info);
}

MPI_Message MPI_Message_f2c(MPI_Fint message)
{
  return PMPI_Message_f2c(message);
}

MPI_Fint MPI_Message_c2f(MPI_Message message)
{
  return PMPI_Message_c2f(message);
}

MPI_Op MPI_Op_f2c(MPI_Fint op)
{
  return PMPI_Op_f2c(op);
}

MPI_Fint MPI_Op_c2f(MPI_Op op)
{
  return PMPI_Op_c2f(op);
}

MPI_Request MPI_Request_f2c(MPI_Fint request)
{
  return PMPI_Request_f2c(request);
}

MPI_Fint MPI_Request_c2f(MPI_Request request)
{
  return PMPI_Request_c2f(request);
}

MPI_Session MPI_Session_f2c(MPI_Fint session)
{
  return PMPI_Session_f2c(session);
}

MPI_Fint MPI_Session_c2f(MPI_Session session)
{
  return PMPI_Session_c2f(session);
}

MPI_Datatype MPI_Type_f2c(MPI_Fint datatype)
{
  return PMPI_Type_f2c(datatype);
}

MPI_Fint MPI_Type_c2f(MPI_Datatype datatype)
{
  return PMPI_Type_c2f(datatype);
}

MPI_Win MPI_Win_f2c(MPI_Fint win)
{
  return PMPI_Win_f2c(win);
}

MPI_Fint MPI_Win_c2f(MPI_Win win)
{
  return PMPI_Win_c2f(win);
}




int PMPI_Status_f2c(const MPI_Fint *f_status, MPI_Status *c_status)
{
  if (f_status == MPI_F_STATUS_IGNORE || f_status == MPI_F_STATUSES_IGNORE ||
      c_status == MPI_STATUS_IGNORE || c_status == MPI_STATUSES_IGNORE)
    return MPI_ERR_ARG;
  memcpy(c_status, f_status, sizeof *c_status);
  return MPI_SUCCESS;
}

int PMPI_Status_c2f(const MPI_Status *c_status, MPI_Fint *f_status)
{
  if (c_status == MPI_STATUS_IGNORE || c_status == MPI_STATUSES_IGNORE ||
      f_status == MPI_F_STATUS_IGNORE || f_status == MPI_F_STATUSES_IGNORE)
    return MPI_ERR_ARG;
  memcpy(f_status, c_status, sizeof *c_status);
  return MPI_SUCCESS;
}

int PMPI_Status_f082c(const MPI_F08_Status *f08_status, MPI_Status *c_status)
{
  if (f08_status == MPI_F08_STATUS_IGNORE || f08_status == MPI_F08_STATUSES_IGNORE ||
      c_status == MPI_STATUS_IGNORE || c_status == MPI_STATUSES_IGNORE)
    return MPI_ERR_ARG;
  memcpy(c_status, f08_status, sizeof *c_status);
  return MPI_SUCCESS;
}

int PMPI_Status_c2f08(const MPI_Status *c_status, MPI_F08_Status *f08_status)
{
  if (c_status == MPI_STATUS_IGNORE || c_status == MPI_STATUSES_IGNORE ||
      f08_status == MPI_F08_STATUS_IGNORE || f08_status == MPI_F08_STATUSES_IGNORE)
    return MPI_ERR_ARG;
  memcpy(f08_status, c_status, sizeof *c_status);
  return MPI_SUCCESS;
}



int MPI_Status_f2c(const MPI_Fint *f_status, MPI_Status *c_status)
{
  return PMPI_Status_f2c(f_status, c_status);
}

int MPI_Status_c2f(const MPI_Status *c_status, MPI_Fint *f_status)
{
  return PMPI_Status_c2f(c_status, f_status);
}

int MPI_Status_f082c(const MPI_F08_Status *f08_status, MPI_Status *c_status)
{
  return PMPI_Status_f082c(f08_status, c_status);
}

int MPI_Status_c2f08(const MPI_Status *c_status, MPI_F08_Status *f08_status)
{
  return PMPI_Status_c2f08(c_status, f08_status);
}
