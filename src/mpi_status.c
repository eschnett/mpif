#include <mpi.h>
#include <string.h>

int MPI_Status_f2c(const MPI_Fint *f_status, MPI_Status *c_status)
{
  if (f_status == MPI_F_STATUS_IGNORE || f_status == MPI_F_STATUSES_IGNORE ||
      c_status == MPI_STATUS_IGNORE || c_status == MPI_STATUSES_IGNORE)
    return MPI_ERR_ARG;
  memcpy(c_status, f_status, sizeof *c_status);
  return MPI_SUCCESS;
}

int MPI_Status_c2f(const MPI_Status *c_status, MPI_Fint *f_status)
{
  if (c_status == MPI_STATUS_IGNORE || c_status == MPI_STATUSES_IGNORE ||
      f_status == MPI_F_STATUS_IGNORE || f_status == MPI_F_STATUSES_IGNORE)
    return MPI_ERR_ARG;
  memcpy(f_status, c_status, sizeof *c_status);
  return MPI_SUCCESS;
}

int MPI_Status_f082c(const MPI_F08_Status *f08_status, MPI_Status *c_status)
{
  if (f08_status == MPI_F08_STATUS_IGNORE || f08_status == MPI_F08_STATUSES_IGNORE ||
      c_status == MPI_STATUS_IGNORE || c_status == MPI_STATUSES_IGNORE)
    return MPI_ERR_ARG;
  memcpy(c_status, f08_status, sizeof *c_status);
  return MPI_SUCCESS;
}

int MPI_Status_c2f08(const MPI_Status *c_status, MPI_F08_Status *f08_status)
{
  if (c_status == MPI_STATUS_IGNORE || c_status == MPI_STATUSES_IGNORE ||
      f08_status == MPI_F08_STATUS_IGNORE || f08_status == MPI_F08_STATUSES_IGNORE)
    return MPI_ERR_ARG;
  memcpy(f08_status, c_status, sizeof *c_status);
  return MPI_SUCCESS;
}
