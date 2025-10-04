#include <mpif_strings.h>
#include <mpi.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>

// // Work around MPICH bug
// static int MPI_Abi_get_fortran_booleans1(int logical_size, void *logical_true, void *logical_false, int *is_set)
// {
//   *is_set = 1;   // pretend
//   return MPI_Abi_get_fortran_booleans(logical_size, logical_true, logical_false);
// }
// #define MPI_Abi_get_fortran_booleans MPI_Abi_get_fortran_booleans1

void mpi_abi_get_fortran_booleans_(
  const MPI_Fint* restrict const logical_size,
  void* restrict const logical_true,
  void* restrict const logical_false,
  MPI_Fint* restrict const is_set,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_is_set;
  const int c_ierror = MPI_Abi_get_fortran_booleans(
    *logical_size,
    logical_true,
    logical_false,
    &c_is_set
  );
  *is_set = c_is_set ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_abi_get_fortran_info_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info;
  const int c_ierror = MPI_Abi_get_fortran_info(
    &c_info
  );
  *info = MPI_Info_toint(c_info);
  if (ierror) *ierror = c_ierror;
}

void mpi_abi_get_info_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info;
  const int c_ierror = MPI_Abi_get_info(
    &c_info
  );
  *info = MPI_Info_toint(c_info);
  if (ierror) *ierror = c_ierror;
}

void mpi_abi_get_version_(
  MPI_Fint* restrict const abi_major,
  MPI_Fint* restrict const abi_minor,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Abi_get_version(
    abi_major,
    abi_minor
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_abi_set_fortran_booleans_(
  const MPI_Fint* restrict const logical_size,
  const void* restrict const logical_true,
  const void* restrict const logical_false,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Abi_set_fortran_booleans(
    *logical_size,
    (void*)logical_true,
    (void*)logical_false
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_abi_set_fortran_info_(
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Abi_set_fortran_info(
    MPI_Info_fromint(*info)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_abort_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Abort(
    MPI_Comm_fromint(*comm),
    *errorcode
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Accumulate(
    origin_addr,
    *origin_count,
    MPI_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_add_error_class_(
  MPI_Fint* restrict const errorclass,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Add_error_class(
    errorclass
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_add_error_code_(
  const MPI_Fint* restrict const errorclass,
  MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Add_error_code(
    *errorclass,
    errorcode
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_add_error_string_(
  const MPI_Fint* restrict const errorcode,
  const char* restrict const string,
  MPI_Fint* restrict const ierror,
  const size_t length_string
)
{
  char* const c_string = mpif_strdup_f2c(string, length_string);
  const int c_ierror = MPI_Add_error_string(
    *errorcode,
    c_string
  );
  free(c_string);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Allgather(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Allgather_init(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Allgatherv(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Allgatherv_init(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_alloc_mem_(
  const MPI_Aint* restrict const size,
  const MPI_Fint* restrict const info,
  MPI_Aint* restrict const baseptr,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Alloc_mem(
    *size,
    MPI_Info_fromint(*info),
    baseptr
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Allreduce(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Allreduce_init(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Alltoall(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Alltoall_init(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Alltoallv(
    sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Alltoallv_init(
    sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  const int c_ierror = MPI_Alltoallw(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  const int c_ierror = MPI_Alltoallw_init(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_attr_delete_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const keyval,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Attr_delete(
    MPI_Comm_fromint(*comm),
    *keyval
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Attr_get(
    MPI_Comm_fromint(*comm),
    *keyval,
    c_attribute_val,
    &c_flag
  );
  *attribute_val = (int)(intptr_t)c_attribute_val;
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_attr_put_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const keyval,
  const MPI_Fint* restrict const attribute_val,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Attr_put(
    MPI_Comm_fromint(*comm),
    *keyval,
    (void*)(intptr_t)*attribute_val
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_barrier_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Barrier(
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_barrier_init_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  const int c_ierror = MPI_Barrier_init(
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Bcast(
    buffer,
    *count,
    MPI_Type_fromint(*datatype),
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Bcast_init(
    buffer,
    *count,
    MPI_Type_fromint(*datatype),
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Bsend(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Bsend_init(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_buffer_attach_(
  void* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Buffer_attach(
    buffer,
    *size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_buffer_detach_(
  MPI_Aint* restrict const buffer_addr,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Buffer_detach(
    buffer_addr,
    size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_buffer_flush_(
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Buffer_flush(
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_buffer_iflush_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  const int c_ierror = MPI_Buffer_iflush(
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_cancel_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPI_Request_fromint(*request);
  const int c_ierror = MPI_Cancel(
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_cart_coords_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const maxdims,
  MPI_Fint* restrict const coords,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Cart_coords(
    MPI_Comm_fromint(*comm),
    *rank,
    *maxdims,
    coords
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Cart_create(
    MPI_Comm_fromint(*comm_old),
    *ndims,
    dims,
    c_periods,
    *reorder != 0,
    &c_comm_cart
  );
  *comm_cart = MPI_Comm_toint(c_comm_cart);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Cart_get(
    MPI_Comm_fromint(*comm),
    *maxdims,
    dims,
    c_periods,
    coords
  );
  for (int dim=0; dim<*maxdims; ++dim)
    periods[dim] = c_periods[dim] ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Cart_map(
    MPI_Comm_fromint(*comm),
    *ndims,
    dims,
    c_periods,
    newrank
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_cart_rank_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const coords,
  MPI_Fint* restrict const rank,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Cart_rank(
    MPI_Comm_fromint(*comm),
    coords,
    rank
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Cart_shift(
    MPI_Comm_fromint(*comm),
    *direction,
    *disp,
    rank_source,
    rank_dest
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_cart_sub_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const remain_dims,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int ndims;
  {
    const int q_ierror = MPI_Cartdim_get(q_comm, &ndims);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  int c_remain_dims[ndims];
  for (int dim=0; dim<ndims; ++dim)
    c_remain_dims[dim] = remain_dims[dim] != 0;
  MPI_Comm c_newcomm;
  const int c_ierror = MPI_Cart_sub(
    MPI_Comm_fromint(*comm),
    c_remain_dims,
    &c_newcomm
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_cartdim_get_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ndims,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Cartdim_get(
    MPI_Comm_fromint(*comm),
    ndims
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_close_port_(
  const char* restrict const port_name,
  MPI_Fint* restrict const ierror,
  const size_t length_port_name
)
{
  char* const c_port_name = mpif_strdup_f2c(port_name, length_port_name);
  const int c_ierror = MPI_Close_port(
    c_port_name
  );
  free(c_port_name);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  char* c_port_name = NULL;
  if (q_comm_rank == 0)
    c_port_name = mpif_strdup_f2c(port_name, length_port_name);
  MPI_Comm c_newcomm;
  const int c_ierror = MPI_Comm_accept(
    c_port_name,
    q_comm_rank == 0 ? MPI_Info_fromint(*info) : MPI_INFO_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_newcomm
  );
  if (q_comm_rank == 0)
    free(c_port_name);
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_attach_buffer_(
  const MPI_Fint* restrict const comm,
  void* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_attach_buffer(
    MPI_Comm_fromint(*comm),
    buffer,
    *size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_call_errhandler_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_call_errhandler(
    MPI_Comm_fromint(*comm),
    *errorcode
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_compare_(
  const MPI_Fint* restrict const comm1,
  const MPI_Fint* restrict const comm2,
  MPI_Fint* restrict const result,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_compare(
    MPI_Comm_fromint(*comm1),
    MPI_Comm_fromint(*comm2),
    result
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  char* c_port_name = NULL;
  if (q_comm_rank == 0)
    c_port_name = mpif_strdup_f2c(port_name, length_port_name);
  MPI_Comm c_newcomm;
  const int c_ierror = MPI_Comm_connect(
    c_port_name,
    q_comm_rank == 0 ? MPI_Info_fromint(*info) : MPI_INFO_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_newcomm
  );
  if (q_comm_rank == 0)
    free(c_port_name);
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_create_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const group,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  const int c_ierror = MPI_Comm_create(
    MPI_Comm_fromint(*comm),
    MPI_Group_fromint(*group),
    &c_newcomm
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_create_errhandler_(
  MPI_Comm_errhandler_function* const comm_errhandler_fn,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Errhandler c_errhandler;
  const int c_ierror = MPI_Comm_create_errhandler(
    comm_errhandler_fn,
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_create_from_group(
    MPI_Group_fromint(*group),
    c_stringtag,
    MPI_Info_fromint(*info),
    MPI_Errhandler_fromint(*errhandler),
    &c_newcomm
  );
  free(c_stringtag);
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_create_group(
    MPI_Comm_fromint(*comm),
    MPI_Group_fromint(*group),
    *tag,
    &c_newcomm
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_create_keyval(
    comm_copy_attr_fn,
    comm_delete_attr_fn,
    comm_keyval,
    (void*)*extra_state
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_delete_attr_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const comm_keyval,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_delete_attr(
    MPI_Comm_fromint(*comm),
    *comm_keyval
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_detach_buffer_(
  const MPI_Fint* restrict const comm,
  MPI_Aint* restrict const buffer_addr,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_detach_buffer(
    MPI_Comm_fromint(*comm),
    buffer_addr,
    size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_disconnect_(
  MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_comm = MPI_Comm_fromint(*comm);
  const int c_ierror = MPI_Comm_disconnect(
    &c_comm
  );
  *comm = MPI_Comm_toint(c_comm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_dup_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  const int c_ierror = MPI_Comm_dup(
    MPI_Comm_fromint(*comm),
    &c_newcomm
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_dup_with_info_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const newcomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newcomm;
  const int c_ierror = MPI_Comm_dup_with_info(
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_newcomm
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_flush_buffer_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_flush_buffer(
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_free_(
  MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_comm = MPI_Comm_fromint(*comm);
  const int c_ierror = MPI_Comm_free(
    &c_comm
  );
  *comm = MPI_Comm_toint(c_comm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_free_keyval_(
  MPI_Fint* restrict const comm_keyval,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_free_keyval(
    comm_keyval
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_get_attr(
    MPI_Comm_fromint(*comm),
    *comm_keyval,
    &c_attribute_val,
    &c_flag
  );
  *attribute_val = (MPI_Aint)c_attribute_val;
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_get_errhandler_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler;
  const int c_ierror = MPI_Comm_get_errhandler(
    MPI_Comm_fromint(*comm),
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_get_info_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const info_used,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info_used;
  const int c_ierror = MPI_Comm_get_info(
    MPI_Comm_fromint(*comm),
    &c_info_used
  );
  *info_used = MPI_Info_toint(c_info_used);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_get_name(
    MPI_Comm_fromint(*comm),
    c_comm_name,
    resultlen
  );
  mpif_strcpy_c2f(comm_name, c_comm_name, length_comm_name, strlen(c_comm_name));
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_get_parent_(
  MPI_Fint* restrict const parent,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_parent;
  const int c_ierror = MPI_Comm_get_parent(
    &c_parent
  );
  *parent = MPI_Comm_toint(c_parent);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_group_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group;
  const int c_ierror = MPI_Comm_group(
    MPI_Comm_fromint(*comm),
    &c_group
  );
  *group = MPI_Group_toint(c_group);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_idup(
    MPI_Comm_fromint(*comm),
    &c_newcomm,
    &c_request
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_idup_with_info(
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_newcomm,
    &c_request
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_iflush_buffer_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  const int c_ierror = MPI_Comm_iflush_buffer(
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_join_(
  const MPI_Fint* restrict const fd,
  MPI_Fint* restrict const intercomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_intercomm;
  const int c_ierror = MPI_Comm_join(
    *fd,
    &c_intercomm
  );
  *intercomm = MPI_Comm_toint(c_intercomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_rank_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const rank,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_rank(
    MPI_Comm_fromint(*comm),
    rank
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_remote_group_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group;
  const int c_ierror = MPI_Comm_remote_group(
    MPI_Comm_fromint(*comm),
    &c_group
  );
  *group = MPI_Group_toint(c_group);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_remote_size_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_remote_size(
    MPI_Comm_fromint(*comm),
    size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_set_attr_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const comm_keyval,
  const MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_set_attr(
    MPI_Comm_fromint(*comm),
    *comm_keyval,
    (void*)*attribute_val
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_set_errhandler_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_set_errhandler(
    MPI_Comm_fromint(*comm),
    MPI_Errhandler_fromint(*errhandler)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_set_info_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_set_info(
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_set_name_(
  const MPI_Fint* restrict const comm,
  const char* restrict const comm_name,
  MPI_Fint* restrict const ierror,
  const size_t length_comm_name
)
{
  char* const c_comm_name = mpif_strdup_f2c(comm_name, length_comm_name);
  const int c_ierror = MPI_Comm_set_name(
    MPI_Comm_fromint(*comm),
    c_comm_name
  );
  free(c_comm_name);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_size_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Comm_size(
    MPI_Comm_fromint(*comm),
    size
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
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
  const int c_ierror = MPI_Comm_spawn(
    c_command,
    argv_argv,
    *maxprocs,
    q_comm_rank == 0 ? MPI_Info_fromint(*info) : MPI_INFO_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_intercomm,
    array_of_errcodes
  );
  if (q_comm_rank == 0)
    free(c_command);
  for (size_t n=0; n<count_argv; ++n)
    free(argv_argv[n]);
  *intercomm = MPI_Comm_toint(c_intercomm);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
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
      c_array_of_info[rank] = MPI_Info_fromint(array_of_info[rank]);
  MPI_Comm c_intercomm;
  const int c_ierror = MPI_Comm_spawn_multiple(
    *count,
    argv_array_of_commands,
    argv_array_of_argv,
    array_of_maxprocs,
    c_array_of_info,
    *root,
    MPI_Comm_fromint(*comm),
    &c_intercomm,
    array_of_errcodes
  );
  for (size_t n=0; n<count_array_of_commands; ++n)
    free(argv_array_of_commands[n]);
  for (int i=0; i<*count; ++i) {
    for (size_t n=0; n<count_array_of_argv[i]; ++n)
      free(argv_array_of_argv[i][n]);
  }
  *intercomm = MPI_Comm_toint(c_intercomm);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_split(
    MPI_Comm_fromint(*comm),
    *color,
    *key,
    &c_newcomm
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Comm_split_type(
    MPI_Comm_fromint(*comm),
    *split_type,
    *key,
    MPI_Info_fromint(*info),
    &c_newcomm
  );
  *newcomm = MPI_Comm_toint(c_newcomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_comm_test_inter_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_Comm_test_inter(
    MPI_Comm_fromint(*comm),
    &c_flag
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Compare_and_swap(
    origin_addr,
    compare_addr,
    result_addr,
    MPI_Type_fromint(*datatype),
    *target_rank,
    *target_disp,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_dims_create_(
  const MPI_Fint* restrict const nnodes,
  const MPI_Fint* restrict const ndims,
  MPI_Fint* restrict const dims,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Dims_create(
    *nnodes,
    *ndims,
    dims
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Dist_graph_create(
    MPI_Comm_fromint(*comm_old),
    *n,
    sources,
    degrees,
    destinations,
    weights,
    MPI_Info_fromint(*info),
    *reorder != 0,
    &c_comm_dist_graph
  );
  *comm_dist_graph = MPI_Comm_toint(c_comm_dist_graph);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Dist_graph_create_adjacent(
    MPI_Comm_fromint(*comm_old),
    *indegree,
    sources,
    sourceweights,
    *outdegree,
    destinations,
    destweights,
    MPI_Info_fromint(*info),
    *reorder != 0,
    &c_comm_dist_graph
  );
  *comm_dist_graph = MPI_Comm_toint(c_comm_dist_graph);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Dist_graph_neighbors(
    MPI_Comm_fromint(*comm),
    *maxindegree,
    sources,
    sourceweights,
    *maxoutdegree,
    destinations,
    destweights
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Dist_graph_neighbors_count(
    MPI_Comm_fromint(*comm),
    indegree,
    outdegree,
    &c_weighted
  );
  *weighted = c_weighted ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_errhandler_free_(
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler = MPI_Errhandler_fromint(*errhandler);
  const int c_ierror = MPI_Errhandler_free(
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
}

void mpi_error_class_(
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const errorclass,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Error_class(
    *errorcode,
    errorclass
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Error_string(
    *errorcode,
    c_string,
    resultlen
  );
  mpif_strcpy_c2f(string, c_string, length_string, strlen(c_string));
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Exscan(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Exscan_init(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Fetch_and_op(
    origin_addr,
    result_addr,
    MPI_Type_fromint(*datatype),
    *target_rank,
    *target_disp,
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_call_errhandler_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_call_errhandler(
    MPI_File_fromint(*fh),
    *errorcode
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_close_(
  MPI_Fint* restrict const fh,
  MPI_Fint* restrict const ierror
)
{
  MPI_File c_fh = MPI_File_fromint(*fh);
  const int c_ierror = MPI_File_close(
    &c_fh
  );
  *fh = MPI_File_toint(c_fh);
  if (ierror) *ierror = c_ierror;
}

void mpi_file_create_errhandler_(
  MPI_File_errhandler_function* const file_errhandler_fn,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Errhandler c_errhandler;
  const int c_ierror = MPI_File_create_errhandler(
    file_errhandler_fn,
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
}

void mpi_file_delete_(
  const char* restrict const filename,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror,
  const size_t length_filename
)
{
  char* const c_filename = mpif_strdup_f2c(filename, length_filename);
  const int c_ierror = MPI_File_delete(
    c_filename,
    MPI_Info_fromint(*info)
  );
  free(c_filename);
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_amode_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const amode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_get_amode(
    MPI_File_fromint(*fh),
    amode
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_atomicity_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_File_get_atomicity(
    MPI_File_fromint(*fh),
    &c_flag
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_byte_offset_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  MPI_Offset* restrict const disp,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_get_byte_offset(
    MPI_File_fromint(*fh),
    *offset,
    disp
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_errhandler_(
  const MPI_Fint* restrict const file,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler;
  const int c_ierror = MPI_File_get_errhandler(
    MPI_File_fromint(*file),
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_group_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group;
  const int c_ierror = MPI_File_get_group(
    MPI_File_fromint(*fh),
    &c_group
  );
  *group = MPI_Group_toint(c_group);
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_info_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const info_used,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info_used;
  const int c_ierror = MPI_File_get_info(
    MPI_File_fromint(*fh),
    &c_info_used
  );
  *info_used = MPI_Info_toint(c_info_used);
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_position_(
  const MPI_Fint* restrict const fh,
  MPI_Offset* restrict const offset,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_get_position(
    MPI_File_fromint(*fh),
    offset
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_position_shared_(
  const MPI_Fint* restrict const fh,
  MPI_Offset* restrict const offset,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_get_position_shared(
    MPI_File_fromint(*fh),
    offset
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_size_(
  const MPI_Fint* restrict const fh,
  MPI_Offset* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_get_size(
    MPI_File_fromint(*fh),
    size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_get_type_extent_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const datatype,
  MPI_Aint* restrict const extent,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_get_type_extent(
    MPI_File_fromint(*fh),
    MPI_Type_fromint(*datatype),
    extent
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_get_view(
    MPI_File_fromint(*fh),
    disp,
    &c_etype,
    &c_filetype,
    c_datarep
  );
  *etype = MPI_Type_toint(c_etype);
  *filetype = MPI_Type_toint(c_filetype);
  mpif_strcpy_c2f(datarep, c_datarep, length_datarep, strlen(c_datarep));
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iread(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iread_all(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iread_at(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iread_at_all(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iread_shared(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iwrite(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iwrite_all(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iwrite_at(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iwrite_at_all(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_iwrite_shared(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_open(
    MPI_Comm_fromint(*comm),
    c_filename,
    *amode,
    MPI_Info_fromint(*info),
    &c_fh
  );
  free(c_filename);
  *fh = MPI_File_toint(c_fh);
  if (ierror) *ierror = c_ierror;
}

void mpi_file_preallocate_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_preallocate(
    MPI_File_fromint(*fh),
    *size
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_read(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_read_all(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_read_all_begin_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_read_all_begin(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_read_all_end_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_read_all_end(
    MPI_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_read_at(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_read_at_all(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_read_at_all_begin(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_read_at_all_end_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_read_at_all_end(
    MPI_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_read_ordered(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_read_ordered_begin_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_read_ordered_begin(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_read_ordered_end_(
  const MPI_Fint* restrict const fh,
  void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_read_ordered_end(
    MPI_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_read_shared(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_seek_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const MPI_Fint* restrict const whence,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_seek(
    MPI_File_fromint(*fh),
    *offset,
    *whence
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_seek_shared_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const MPI_Fint* restrict const whence,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_seek_shared(
    MPI_File_fromint(*fh),
    *offset,
    *whence
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_set_atomicity_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_set_atomicity(
    MPI_File_fromint(*fh),
    *flag != 0
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_set_errhandler_(
  const MPI_Fint* restrict const file,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_set_errhandler(
    MPI_File_fromint(*file),
    MPI_Errhandler_fromint(*errhandler)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_set_info_(
  const MPI_Fint* restrict const fh,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_set_info(
    MPI_File_fromint(*fh),
    MPI_Info_fromint(*info)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_set_size_(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_set_size(
    MPI_File_fromint(*fh),
    *size
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_set_view(
    MPI_File_fromint(*fh),
    *disp,
    MPI_Type_fromint(*etype),
    MPI_Type_fromint(*filetype),
    c_datarep,
    MPI_Info_fromint(*info)
  );
  free(c_datarep);
  if (ierror) *ierror = c_ierror;
}

void mpi_file_sync_(
  const MPI_Fint* restrict const fh,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_sync(
    MPI_File_fromint(*fh)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_write(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_write_all(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_write_all_begin_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_write_all_begin(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_write_all_end_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_write_all_end(
    MPI_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_write_at(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_write_at_all(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_write_at_all_begin(
    MPI_File_fromint(*fh),
    *offset,
    buf,
    *count,
    MPI_Type_fromint(*datatype)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_write_at_all_end_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_write_at_all_end(
    MPI_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_write_ordered(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_write_ordered_begin_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_write_ordered_begin(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_file_write_ordered_end_(
  const MPI_Fint* restrict const fh,
  const void* restrict const buf,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_File_write_ordered_end(
    MPI_File_fromint(*fh),
    buf,
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_File_write_shared(
    MPI_File_fromint(*fh),
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_finalize_(
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Finalize(
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_finalized_(
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_Finalized(
    &c_flag
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_free_mem_(
  void* restrict const base,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Free_mem(
    base
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  const int c_ierror = MPI_Gather(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  const int c_ierror = MPI_Gather_init(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  const int c_ierror = MPI_Gatherv(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  const int c_ierror = MPI_Gatherv_init(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Get(
    origin_addr,
    *origin_count,
    MPI_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Get_accumulate(
    origin_addr,
    *origin_count,
    MPI_Type_fromint(*origin_datatype),
    result_addr,
    *result_count,
    MPI_Type_fromint(*result_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_get_address_(
  const void* restrict const location,
  MPI_Aint* restrict const address,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Get_address(
    location,
    address
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_get_count_(
  const MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Get_count(
    (const MPI_Status*)status,
    MPI_Type_fromint(*datatype),
    count
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_get_elements_(
  const MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Get_elements(
    (const MPI_Status*)status,
    MPI_Type_fromint(*datatype),
    count
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_get_elements_x_(
  const MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Get_elements_x(
    (const MPI_Status*)status,
    MPI_Type_fromint(*datatype),
    count
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_get_hw_resource_info_(
  MPI_Fint* restrict const hw_info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_hw_info;
  const int c_ierror = MPI_Get_hw_resource_info(
    &c_hw_info
  );
  *hw_info = MPI_Info_toint(c_hw_info);
  if (ierror) *ierror = c_ierror;
}

void mpi_get_library_version_(
  char* restrict const version,
  MPI_Fint* restrict const resultlen,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_version = MPI_MAX_LIBRARY_VERSION_STRING;
  char c_version[length_version + 1];
  const int c_ierror = MPI_Get_library_version(
    c_version,
    resultlen
  );
  mpif_strcpy_c2f(version, c_version, length_version, strlen(c_version));
  if (ierror) *ierror = c_ierror;
}

void mpi_get_processor_name_(
  char* restrict const name,
  MPI_Fint* restrict const resultlen,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_name = MPI_MAX_PROCESSOR_NAME;
  char c_name[length_name + 1];
  const int c_ierror = MPI_Get_processor_name(
    c_name,
    resultlen
  );
  mpif_strcpy_c2f(name, c_name, length_name, strlen(c_name));
  if (ierror) *ierror = c_ierror;
}

void mpi_get_version_(
  MPI_Fint* restrict const version,
  MPI_Fint* restrict const subversion,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Get_version(
    version,
    subversion
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Graph_create(
    MPI_Comm_fromint(*comm_old),
    *nnodes,
    index,
    edges,
    *reorder != 0,
    &c_comm_graph
  );
  *comm_graph = MPI_Comm_toint(c_comm_graph);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Graph_get(
    MPI_Comm_fromint(*comm),
    *maxindex,
    *maxedges,
    index,
    edges
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Graph_map(
    MPI_Comm_fromint(*comm),
    *nnodes,
    index,
    edges,
    newrank
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_graph_neighbors_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const maxneighbors,
  MPI_Fint* restrict const neighbors,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Graph_neighbors(
    MPI_Comm_fromint(*comm),
    *rank,
    *maxneighbors,
    neighbors
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_graph_neighbors_count_(
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const rank,
  MPI_Fint* restrict const nneighbors,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Graph_neighbors_count(
    MPI_Comm_fromint(*comm),
    *rank,
    nneighbors
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_graphdims_get_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const nnodes,
  MPI_Fint* restrict const nedges,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Graphdims_get(
    MPI_Comm_fromint(*comm),
    nnodes,
    nedges
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_grequest_complete_(
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Grequest_complete(
    MPI_Request_fromint(*request)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Grequest_start(
    query_fn,
    free_fn,
    cancel_fn,
    (void*)*extra_state,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_group_compare_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const result,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Group_compare(
    MPI_Group_fromint(*group1),
    MPI_Group_fromint(*group2),
    result
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_group_difference_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  const int c_ierror = MPI_Group_difference(
    MPI_Group_fromint(*group1),
    MPI_Group_fromint(*group2),
    &c_newgroup
  );
  *newgroup = MPI_Group_toint(c_newgroup);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Group_excl(
    MPI_Group_fromint(*group),
    *n,
    ranks,
    &c_newgroup
  );
  *newgroup = MPI_Group_toint(c_newgroup);
  if (ierror) *ierror = c_ierror;
}

void mpi_group_free_(
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group = MPI_Group_fromint(*group);
  const int c_ierror = MPI_Group_free(
    &c_group
  );
  *group = MPI_Group_toint(c_group);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Group_from_session_pset(
    MPI_Session_fromint(*session),
    c_pset_name,
    &c_newgroup
  );
  free(c_pset_name);
  *newgroup = MPI_Group_toint(c_newgroup);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Group_incl(
    MPI_Group_fromint(*group),
    *n,
    ranks,
    &c_newgroup
  );
  *newgroup = MPI_Group_toint(c_newgroup);
  if (ierror) *ierror = c_ierror;
}

void mpi_group_intersection_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  const int c_ierror = MPI_Group_intersection(
    MPI_Group_fromint(*group1),
    MPI_Group_fromint(*group2),
    &c_newgroup
  );
  *newgroup = MPI_Group_toint(c_newgroup);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Group_range_excl(
    MPI_Group_fromint(*group),
    *n,
    (int(*)[3])ranges,
    &c_newgroup
  );
  *newgroup = MPI_Group_toint(c_newgroup);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Group_range_incl(
    MPI_Group_fromint(*group),
    *n,
    (int(*)[3])ranges,
    &c_newgroup
  );
  *newgroup = MPI_Group_toint(c_newgroup);
  if (ierror) *ierror = c_ierror;
}

void mpi_group_rank_(
  const MPI_Fint* restrict const group,
  MPI_Fint* restrict const rank,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Group_rank(
    MPI_Group_fromint(*group),
    rank
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_group_size_(
  const MPI_Fint* restrict const group,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Group_size(
    MPI_Group_fromint(*group),
    size
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Group_translate_ranks(
    MPI_Group_fromint(*group1),
    *n,
    ranks1,
    MPI_Group_fromint(*group2),
    ranks2
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_group_union_(
  const MPI_Fint* restrict const group1,
  const MPI_Fint* restrict const group2,
  MPI_Fint* restrict const newgroup,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_newgroup;
  const int c_ierror = MPI_Group_union(
    MPI_Group_fromint(*group1),
    MPI_Group_fromint(*group2),
    &c_newgroup
  );
  *newgroup = MPI_Group_toint(c_newgroup);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Iallgather(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Iallgatherv(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Iallreduce(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ialltoall(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ialltoallv(
    sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  const int c_ierror = MPI_Ialltoallw(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_ibarrier_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  const int c_ierror = MPI_Ibarrier(
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ibcast(
    buffer,
    *count,
    MPI_Type_fromint(*datatype),
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ibsend(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Iexscan(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  const int c_ierror = MPI_Igather(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    q_comm_rank == 0 ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  const int c_ierror = MPI_Igatherv(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    q_comm_rank == 0 ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Improbe(
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_flag,
    &c_message,
    (MPI_Status*)status
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  *message = MPI_Message_toint(c_message);
  if (ierror) *ierror = c_ierror;
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
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Request c_request;
  const int c_ierror = MPI_Imrecv(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_message,
    &c_request
  );
  *message = MPI_Message_toint(c_message);
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ineighbor_allgather(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ineighbor_allgatherv(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ineighbor_alltoall(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ineighbor_alltoallv(
    sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  const int c_ierror = MPI_Ineighbor_alltoallw(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_info_create_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info;
  const int c_ierror = MPI_Info_create(
    &c_info
  );
  *info = MPI_Info_toint(c_info);
  if (ierror) *ierror = c_ierror;
}

void mpi_info_create_env_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info;
  const int c_ierror = MPI_Info_create_env(
    0,
    NULL,
    &c_info
  );
  *info = MPI_Info_toint(c_info);
  if (ierror) *ierror = c_ierror;
}

void mpi_info_delete_(
  const MPI_Fint* restrict const info,
  const char* restrict const key,
  MPI_Fint* restrict const ierror,
  const size_t length_key
)
{
  char* const c_key = mpif_strdup_f2c(key, length_key);
  const int c_ierror = MPI_Info_delete(
    MPI_Info_fromint(*info),
    c_key
  );
  free(c_key);
  if (ierror) *ierror = c_ierror;
}

void mpi_info_dup_(
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const newinfo,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_newinfo;
  const int c_ierror = MPI_Info_dup(
    MPI_Info_fromint(*info),
    &c_newinfo
  );
  *newinfo = MPI_Info_toint(c_newinfo);
  if (ierror) *ierror = c_ierror;
}

void mpi_info_free_(
  MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info = MPI_Info_fromint(*info);
  const int c_ierror = MPI_Info_free(
    &c_info
  );
  *info = MPI_Info_toint(c_info);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Info_get(
    MPI_Info_fromint(*info),
    c_key,
    *valuelen,
    c_value,
    &c_flag
  );
  free(c_key);
  mpif_strcpy_c2f(value, c_value, length_value, strlen(c_value));
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_info_get_nkeys_(
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const nkeys,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Info_get_nkeys(
    MPI_Info_fromint(*info),
    nkeys
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Info_get_nthkey(
    MPI_Info_fromint(*info),
    *n,
    c_key
  );
  mpif_strcpy_c2f(key, c_key, length_key, strlen(c_key));
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Info_get_string(
    MPI_Info_fromint(*info),
    c_key,
    buflen,
    c_value,
    &c_flag
  );
  free(c_key);
  mpif_strcpy_c2f(value, c_value, length_value, strlen(c_value));
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Info_get_valuelen(
    MPI_Info_fromint(*info),
    c_key,
    valuelen,
    &c_flag
  );
  free(c_key);
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Info_set(
    MPI_Info_fromint(*info),
    c_key,
    c_value
  );
  free(c_key);
  free(c_value);
  if (ierror) *ierror = c_ierror;
}

void mpi_init_(
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Init(
    NULL,
    NULL
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_init_thread_(
  const MPI_Fint* restrict const required,
  MPI_Fint* restrict const provided,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Init_thread(
    NULL,
    NULL,
    *required,
    provided
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_initialized_(
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_Initialized(
    &c_flag
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Intercomm_create(
    MPI_Comm_fromint(*local_comm),
    *local_leader,
    MPI_Comm_fromint(*peer_comm),
    *remote_leader,
    *tag,
    &c_newintercomm
  );
  *newintercomm = MPI_Comm_toint(c_newintercomm);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Intercomm_create_from_groups(
    MPI_Group_fromint(*local_group),
    *local_leader,
    MPI_Group_fromint(*remote_group),
    *remote_leader,
    c_stringtag,
    MPI_Info_fromint(*info),
    MPI_Errhandler_fromint(*errhandler),
    &c_newintercomm
  );
  free(c_stringtag);
  *newintercomm = MPI_Comm_toint(c_newintercomm);
  if (ierror) *ierror = c_ierror;
}

void mpi_intercomm_merge_(
  const MPI_Fint* restrict const intercomm,
  const MPI_Fint* restrict const high,
  MPI_Fint* restrict const newintracomm,
  MPI_Fint* restrict const ierror
)
{
  MPI_Comm c_newintracomm;
  const int c_ierror = MPI_Intercomm_merge(
    MPI_Comm_fromint(*intercomm),
    *high != 0,
    &c_newintracomm
  );
  *newintracomm = MPI_Comm_toint(c_newintracomm);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Iprobe(
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_flag,
    (MPI_Status*)status
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Irecv(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ireduce(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ireduce_scatter(
    sendbuf,
    recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ireduce_scatter_block(
    sendbuf,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Irsend(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_is_thread_main_(
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_Is_thread_main(
    &c_flag
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Iscan(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  const int c_ierror = MPI_Iscatter(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  const int c_ierror = MPI_Iscatterv(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Isend(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Isendrecv(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    *dest,
    *sendtag,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Isendrecv_replace(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Issend(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Keyval_create(
    copy_fn,
    delete_fn,
    keyval,
    (void*)*extra_state
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_keyval_free_(
  MPI_Fint* restrict const keyval,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Keyval_free(
    keyval
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Lookup_name(
    c_service_name,
    MPI_Info_fromint(*info),
    c_port_name
  );
  free(c_service_name);
  mpif_strcpy_c2f(port_name, c_port_name, length_port_name, strlen(c_port_name));
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Mprobe(
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_message,
    (MPI_Status*)status
  );
  *message = MPI_Message_toint(c_message);
  if (ierror) *ierror = c_ierror;
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
  MPI_Message c_message = MPI_Message_fromint(*message);
  const int c_ierror = MPI_Mrecv(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    &c_message,
    (MPI_Status*)status
  );
  *message = MPI_Message_toint(c_message);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Neighbor_allgather(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Neighbor_allgather_init(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Neighbor_allgatherv(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Neighbor_allgatherv_init(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Neighbor_alltoall(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Neighbor_alltoall_init(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Neighbor_alltoallv(
    sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Neighbor_alltoallv_init(
    sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  const int c_ierror = MPI_Neighbor_alltoallw(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_size;
  {
    const int q_ierror = MPI_Comm_size(q_comm, &q_comm_size);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  MPI_Datatype c_recvtypes[q_comm_size];
  for (int rank=0; rank<q_comm_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request;
  const int c_ierror = MPI_Neighbor_alltoallw_init(
    sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_op_commutative_(
  const MPI_Fint* restrict const op,
  MPI_Fint* restrict const commute,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_commute;
  const int c_ierror = MPI_Op_commutative(
    MPI_Op_fromint(*op),
    &c_commute
  );
  *commute = c_commute ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Op_create(
    user_fn,
    *commute != 0,
    &c_op
  );
  *op = MPI_Op_toint(c_op);
  if (ierror) *ierror = c_ierror;
}

void mpi_op_free_(
  MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  MPI_Op c_op = MPI_Op_fromint(*op);
  const int c_ierror = MPI_Op_free(
    &c_op
  );
  *op = MPI_Op_toint(c_op);
  if (ierror) *ierror = c_ierror;
}

void mpi_open_port_(
  const MPI_Fint* restrict const info,
  char* restrict const port_name,
  MPI_Fint* restrict const ierror
)
{
  const size_t length_port_name = MPI_MAX_PORT_NAME;
  char c_port_name[length_port_name + 1];
  const int c_ierror = MPI_Open_port(
    MPI_Info_fromint(*info),
    c_port_name
  );
  mpif_strcpy_c2f(port_name, c_port_name, length_port_name, strlen(c_port_name));
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Pack(
    inbuf,
    *incount,
    MPI_Type_fromint(*datatype),
    outbuf,
    *outsize,
    position,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Pack_external(
    c_datarep,
    inbuf,
    *incount,
    MPI_Type_fromint(*datatype),
    outbuf,
    *outsize,
    position
  );
  free(c_datarep);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Pack_external_size(
    c_datarep,
    *incount,
    MPI_Type_fromint(*datatype),
    size
  );
  free(c_datarep);
  if (ierror) *ierror = c_ierror;
}

void mpi_pack_size_(
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Pack_size(
    *incount,
    MPI_Type_fromint(*datatype),
    MPI_Comm_fromint(*comm),
    size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_parrived_(
  const MPI_Fint* restrict const request,
  const MPI_Fint* restrict const partition,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_Parrived(
    MPI_Request_fromint(*request),
    *partition,
    &c_flag
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_pready_(
  const MPI_Fint* restrict const partition,
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Pready(
    *partition,
    MPI_Request_fromint(*request)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_pready_list_(
  const MPI_Fint* restrict const length,
  const MPI_Fint* restrict const array_of_partitions,
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Pready_list(
    *length,
    array_of_partitions,
    MPI_Request_fromint(*request)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_pready_range_(
  const MPI_Fint* restrict const partition_low,
  const MPI_Fint* restrict const partition_high,
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Pready_range(
    *partition_low,
    *partition_high,
    MPI_Request_fromint(*request)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Precv_init(
    buf,
    *partitions,
    *count,
    MPI_Type_fromint(*datatype),
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_probe_(
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Probe(
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Psend_init(
    buf,
    *partitions,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Publish_name(
    c_service_name,
    MPI_Info_fromint(*info),
    c_port_name
  );
  free(c_service_name);
  free(c_port_name);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Put(
    origin_addr,
    *origin_count,
    MPI_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_query_thread_(
  MPI_Fint* restrict const provided,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Query_thread(
    provided
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Raccumulate(
    origin_addr,
    *origin_count,
    MPI_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Recv(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Recv_init(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Reduce(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Reduce_init(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Reduce_local(
    inbuf,
    inoutbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Reduce_scatter(
    sendbuf,
    recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Reduce_scatter_block(
    sendbuf,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Reduce_scatter_block_init(
    sendbuf,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Reduce_scatter_init(
    sendbuf,
    recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Register_datarep(
    c_datarep,
    read_conversion_fn,
    write_conversion_fn,
    dtype_file_extent_fn,
    (void*)*extra_state
  );
  free(c_datarep);
  if (ierror) *ierror = c_ierror;
}

void mpi_remove_error_class_(
  const MPI_Fint* restrict const errorclass,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Remove_error_class(
    *errorclass
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_remove_error_code_(
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Remove_error_code(
    *errorcode
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_remove_error_string_(
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Remove_error_string(
    *errorcode
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_request_free_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPI_Request_fromint(*request);
  const int c_ierror = MPI_Request_free(
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_request_get_status_(
  const MPI_Fint* restrict const request,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_Request_get_status(
    MPI_Request_fromint(*request),
    &c_flag,
    (MPI_Status*)status
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
    c_array_of_requests[rank] = MPI_Request_fromint(array_of_requests[rank]);
  MPI_Fint c_flag;
  const int c_ierror = MPI_Request_get_status_all(
    *count,
    c_array_of_requests,
    &c_flag,
    (MPI_Status*)array_of_statuses
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
    c_array_of_requests[rank] = MPI_Request_fromint(array_of_requests[rank]);
  MPI_Fint c_flag;
  const int c_ierror = MPI_Request_get_status_any(
    *count,
    c_array_of_requests,
    index,
    &c_flag,
    (MPI_Status*)status
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
    c_array_of_requests[rank] = MPI_Request_fromint(array_of_requests[rank]);
  const int c_ierror = MPI_Request_get_status_some(
    *incount,
    c_array_of_requests,
    outcount,
    array_of_indices,
    (MPI_Status*)array_of_statuses
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Rget(
    origin_addr,
    *origin_count,
    MPI_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Rget_accumulate(
    origin_addr,
    *origin_count,
    MPI_Type_fromint(*origin_datatype),
    result_addr,
    *result_count,
    MPI_Type_fromint(*result_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Rput(
    origin_addr,
    *origin_count,
    MPI_Type_fromint(*origin_datatype),
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Rsend(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Rsend_init(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Scan(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Scan_init(
    sendbuf,
    recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  const int c_ierror = MPI_Scatter(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  const int c_ierror = MPI_Scatter_init(
    sendbuf,
    *sendcount,
    q_comm_rank == 0 ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  const int c_ierror = MPI_Scatterv(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_comm_rank;
  {
    const int q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
    if (q_ierror != MPI_SUCCESS) {
      if (ierror) *ierror = q_ierror;
      return;
    }
  }
  MPI_Request c_request;
  const int c_ierror = MPI_Scatterv_init(
    sendbuf,
    sendcounts,
    displs,
    q_comm_rank == 0 ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Send(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Send_init(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Sendrecv(
    sendbuf,
    *sendcount,
    MPI_Type_fromint(*sendtype),
    *dest,
    *sendtag,
    recvbuf,
    *recvcount,
    MPI_Type_fromint(*recvtype),
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Sendrecv_replace(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    (MPI_Status*)status
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_session_attach_buffer_(
  const MPI_Fint* restrict const session,
  void* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Session_attach_buffer(
    MPI_Session_fromint(*session),
    buffer,
    *size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_session_call_errhandler_(
  const MPI_Fint* restrict const session,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Session_call_errhandler(
    MPI_Session_fromint(*session),
    *errorcode
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_session_create_errhandler_(
  MPI_Session_errhandler_function* const session_errhandler_fn,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Errhandler c_errhandler;
  const int c_ierror = MPI_Session_create_errhandler(
    session_errhandler_fn,
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
}

void mpi_session_detach_buffer_(
  const MPI_Fint* restrict const session,
  MPI_Aint* restrict const buffer_addr,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Session_detach_buffer(
    MPI_Session_fromint(*session),
    buffer_addr,
    size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_session_finalize_(
  MPI_Fint* restrict const session,
  MPI_Fint* restrict const ierror
)
{
  MPI_Session c_session = MPI_Session_fromint(*session);
  const int c_ierror = MPI_Session_finalize(
    &c_session
  );
  *session = MPI_Session_toint(c_session);
  if (ierror) *ierror = c_ierror;
}

void mpi_session_flush_buffer_(
  const MPI_Fint* restrict const session,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Session_flush_buffer(
    MPI_Session_fromint(*session)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_session_get_errhandler_(
  const MPI_Fint* restrict const session,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler;
  const int c_ierror = MPI_Session_get_errhandler(
    MPI_Session_fromint(*session),
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
}

void mpi_session_get_info_(
  const MPI_Fint* restrict const session,
  MPI_Fint* restrict const info_used,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info_used;
  const int c_ierror = MPI_Session_get_info(
    MPI_Session_fromint(*session),
    &c_info_used
  );
  *info_used = MPI_Info_toint(c_info_used);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Session_get_nth_pset(
    MPI_Session_fromint(*session),
    MPI_Info_fromint(*info),
    *n,
    pset_len,
    c_pset_name
  );
  mpif_strcpy_c2f(pset_name, c_pset_name, length_pset_name, strlen(c_pset_name));
  if (ierror) *ierror = c_ierror;
}

void mpi_session_get_num_psets_(
  const MPI_Fint* restrict const session,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const npset_names,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Session_get_num_psets(
    MPI_Session_fromint(*session),
    MPI_Info_fromint(*info),
    npset_names
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Session_get_pset_info(
    MPI_Session_fromint(*session),
    c_pset_name,
    &c_info
  );
  free(c_pset_name);
  *info = MPI_Info_toint(c_info);
  if (ierror) *ierror = c_ierror;
}

void mpi_session_iflush_buffer_(
  const MPI_Fint* restrict const session,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request;
  const int c_ierror = MPI_Session_iflush_buffer(
    MPI_Session_fromint(*session),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_session_init_(
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const session,
  MPI_Fint* restrict const ierror
)
{
  MPI_Session c_session;
  const int c_ierror = MPI_Session_init(
    MPI_Info_fromint(*info),
    MPI_Errhandler_fromint(*errhandler),
    &c_session
  );
  *session = MPI_Session_toint(c_session);
  if (ierror) *ierror = c_ierror;
}

void mpi_session_set_errhandler_(
  const MPI_Fint* restrict const session,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Session_set_errhandler(
    MPI_Session_fromint(*session),
    MPI_Errhandler_fromint(*errhandler)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ssend(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Ssend_init(
    buf,
    *count,
    MPI_Type_fromint(*datatype),
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_start_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPI_Request_fromint(*request);
  const int c_ierror = MPI_Start(
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_startall_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPI_Request_fromint(*array_of_requests);
  const int c_ierror = MPI_Startall(
    *count,
    &c_array_of_requests
  );
  *array_of_requests = MPI_Request_toint(c_array_of_requests);
  if (ierror) *ierror = c_ierror;
}

void mpi_status_get_error_(
  const MPI_Fint* restrict const status,
  MPI_Fint* restrict const err,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_get_error(
    (const MPI_Status*)status,
    err
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_status_get_source_(
  const MPI_Fint* restrict const status,
  MPI_Fint* restrict const source,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_get_source(
    (const MPI_Status*)status,
    source
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_status_get_tag_(
  const MPI_Fint* restrict const status,
  MPI_Fint* restrict const tag,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_get_tag(
    (const MPI_Status*)status,
    tag
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_status_set_cancelled_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_set_cancelled(
    (MPI_Status*)status,
    *flag != 0
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_status_set_elements_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_set_elements(
    (MPI_Status*)status,
    MPI_Type_fromint(*datatype),
    *count
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_status_set_elements_x_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const datatype,
  const MPI_Count* restrict const count,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_set_elements_x(
    (MPI_Status*)status,
    MPI_Type_fromint(*datatype),
    *count
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_status_set_error_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const err,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_set_error(
    (MPI_Status*)status,
    *err
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_status_set_source_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const source,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_set_source(
    (MPI_Status*)status,
    *source
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_status_set_tag_(
  MPI_Fint* restrict const status,
  const MPI_Fint* restrict const tag,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Status_set_tag(
    (MPI_Status*)status,
    *tag
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_test_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPI_Request_fromint(*request);
  MPI_Fint c_flag;
  const int c_ierror = MPI_Test(
    &c_request,
    &c_flag,
    (MPI_Status*)status
  );
  *request = MPI_Request_toint(c_request);
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_test_cancelled_(
  const MPI_Fint* restrict const status,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_Test_cancelled(
    (const MPI_Status*)status,
    &c_flag
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_testall_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const array_of_statuses,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPI_Request_fromint(*array_of_requests);
  MPI_Fint c_flag;
  const int c_ierror = MPI_Testall(
    *count,
    &c_array_of_requests,
    &c_flag,
    (MPI_Status*)array_of_statuses
  );
  *array_of_requests = MPI_Request_toint(c_array_of_requests);
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  MPI_Request c_array_of_requests = MPI_Request_fromint(*array_of_requests);
  MPI_Fint c_flag;
  const int c_ierror = MPI_Testany(
    *count,
    &c_array_of_requests,
    index,
    &c_flag,
    (MPI_Status*)status
  );
  *array_of_requests = MPI_Request_toint(c_array_of_requests);
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  MPI_Request c_array_of_requests = MPI_Request_fromint(*array_of_requests);
  const int c_ierror = MPI_Testsome(
    *incount,
    &c_array_of_requests,
    outcount,
    array_of_indices,
    (MPI_Status*)array_of_statuses
  );
  *array_of_requests = MPI_Request_toint(c_array_of_requests);
  if (ierror) *ierror = c_ierror;
}

void mpi_topo_test_(
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Topo_test(
    MPI_Comm_fromint(*comm),
    status
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_type_commit_(
  MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_datatype = MPI_Type_fromint(*datatype);
  const int c_ierror = MPI_Type_commit(
    &c_datatype
  );
  *datatype = MPI_Type_toint(c_datatype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_contiguous_(
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  const int c_ierror = MPI_Type_contiguous(
    *count,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_create_darray(
    *size,
    *rank,
    *ndims,
    array_of_gsizes,
    array_of_distribs,
    array_of_dargs,
    array_of_psizes,
    *order,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_create_f90_complex_(
  const MPI_Fint* restrict const p,
  const MPI_Fint* restrict const r,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  const int c_ierror = MPI_Type_create_f90_complex(
    *p,
    *r,
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_create_f90_integer_(
  const MPI_Fint* restrict const r,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  const int c_ierror = MPI_Type_create_f90_integer(
    *r,
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_create_f90_real_(
  const MPI_Fint* restrict const p,
  const MPI_Fint* restrict const r,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  const int c_ierror = MPI_Type_create_f90_real(
    *p,
    *r,
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_create_hindexed(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_create_hindexed_block(
    *count,
    *blocklength,
    array_of_displacements,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_create_hvector(
    *count,
    *blocklength,
    *stride,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_create_indexed_block(
    *count,
    *blocklength,
    array_of_displacements,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_create_keyval(
    type_copy_attr_fn,
    type_delete_attr_fn,
    type_keyval,
    (void*)*extra_state
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_create_resized(
    MPI_Type_fromint(*oldtype),
    *lb,
    *extent,
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
    c_array_of_types[rank] = MPI_Type_fromint(array_of_types[rank]);
  MPI_Datatype c_newtype;
  const int c_ierror = MPI_Type_create_struct(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    c_array_of_types,
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_create_subarray(
    *ndims,
    array_of_sizes,
    array_of_subsizes,
    array_of_starts,
    *order,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_delete_attr_(
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const type_keyval,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_delete_attr(
    MPI_Type_fromint(*datatype),
    *type_keyval
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_type_dup_(
  const MPI_Fint* restrict const oldtype,
  MPI_Fint* restrict const newtype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_newtype;
  const int c_ierror = MPI_Type_dup(
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_free_(
  MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_datatype = MPI_Type_fromint(*datatype);
  const int c_ierror = MPI_Type_free(
    &c_datatype
  );
  *datatype = MPI_Type_toint(c_datatype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_free_keyval_(
  MPI_Fint* restrict const type_keyval,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_free_keyval(
    type_keyval
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_get_attr(
    MPI_Type_fromint(*datatype),
    *type_keyval,
    &c_attribute_val,
    &c_flag
  );
  *attribute_val = (MPI_Aint)c_attribute_val;
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_get_contents(
    MPI_Type_fromint(*datatype),
    *max_integers,
    *max_addresses,
    *max_datatypes,
    array_of_integers,
    array_of_addresses,
    &c_array_of_datatypes
  );
  *array_of_datatypes = MPI_Type_toint(c_array_of_datatypes);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_get_envelope(
    MPI_Type_fromint(*datatype),
    num_integers,
    num_addresses,
    num_datatypes,
    combiner
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_type_get_extent_(
  const MPI_Fint* restrict const datatype,
  MPI_Aint* restrict const lb,
  MPI_Aint* restrict const extent,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_get_extent(
    MPI_Type_fromint(*datatype),
    lb,
    extent
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_type_get_extent_x_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const lb,
  MPI_Count* restrict const extent,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_get_extent_x(
    MPI_Type_fromint(*datatype),
    lb,
    extent
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_get_name(
    MPI_Type_fromint(*datatype),
    c_type_name,
    resultlen
  );
  mpif_strcpy_c2f(type_name, c_type_name, length_type_name, strlen(c_type_name));
  if (ierror) *ierror = c_ierror;
}

void mpi_type_get_true_extent_(
  const MPI_Fint* restrict const datatype,
  MPI_Aint* restrict const true_lb,
  MPI_Aint* restrict const true_extent,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_get_true_extent(
    MPI_Type_fromint(*datatype),
    true_lb,
    true_extent
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_type_get_true_extent_x_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const true_lb,
  MPI_Count* restrict const true_extent,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_get_true_extent_x(
    MPI_Type_fromint(*datatype),
    true_lb,
    true_extent
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_type_get_value_index_(
  const MPI_Fint* restrict const value_type,
  const MPI_Fint* restrict const index_type,
  MPI_Fint* restrict const pair_type,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_pair_type;
  const int c_ierror = MPI_Type_get_value_index(
    MPI_Type_fromint(*value_type),
    MPI_Type_fromint(*index_type),
    &c_pair_type
  );
  *pair_type = MPI_Type_toint(c_pair_type);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_indexed(
    *count,
    array_of_blocklengths,
    array_of_displacements,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_match_size_(
  const MPI_Fint* restrict const typeclass,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  MPI_Datatype c_datatype;
  const int c_ierror = MPI_Type_match_size(
    *typeclass,
    *size,
    &c_datatype
  );
  *datatype = MPI_Type_toint(c_datatype);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_set_attr_(
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const type_keyval,
  const MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_set_attr(
    MPI_Type_fromint(*datatype),
    *type_keyval,
    (void*)*attribute_val
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_type_set_name_(
  const MPI_Fint* restrict const datatype,
  const char* restrict const type_name,
  MPI_Fint* restrict const ierror,
  const size_t length_type_name
)
{
  char* const c_type_name = mpif_strdup_f2c(type_name, length_type_name);
  const int c_ierror = MPI_Type_set_name(
    MPI_Type_fromint(*datatype),
    c_type_name
  );
  free(c_type_name);
  if (ierror) *ierror = c_ierror;
}

void mpi_type_size_(
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_size(
    MPI_Type_fromint(*datatype),
    size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_type_size_x_(
  const MPI_Fint* restrict const datatype,
  MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Type_size_x(
    MPI_Type_fromint(*datatype),
    size
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Type_vector(
    *count,
    *blocklength,
    *stride,
    MPI_Type_fromint(*oldtype),
    &c_newtype
  );
  *newtype = MPI_Type_toint(c_newtype);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Unpack(
    inbuf,
    *insize,
    position,
    outbuf,
    *outcount,
    MPI_Type_fromint(*datatype),
    MPI_Comm_fromint(*comm)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Unpack_external(
    c_datarep,
    inbuf,
    *insize,
    position,
    outbuf,
    *outcount,
    MPI_Type_fromint(*datatype)
  );
  free(c_datarep);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Unpublish_name(
    c_service_name,
    MPI_Info_fromint(*info),
    c_port_name
  );
  free(c_service_name);
  free(c_port_name);
  if (ierror) *ierror = c_ierror;
}

void mpi_wait_(
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_request = MPI_Request_fromint(*request);
  const int c_ierror = MPI_Wait(
    &c_request,
    (MPI_Status*)status
  );
  *request = MPI_Request_toint(c_request);
  if (ierror) *ierror = c_ierror;
}

void mpi_waitall_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const array_of_statuses,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPI_Request_fromint(*array_of_requests);
  const int c_ierror = MPI_Waitall(
    *count,
    &c_array_of_requests,
    (MPI_Status*)array_of_statuses
  );
  *array_of_requests = MPI_Request_toint(c_array_of_requests);
  if (ierror) *ierror = c_ierror;
}

void mpi_waitany_(
  const MPI_Fint* restrict const count,
  MPI_Fint* restrict const array_of_requests,
  MPI_Fint* restrict const index,
  MPI_Fint* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  MPI_Request c_array_of_requests = MPI_Request_fromint(*array_of_requests);
  const int c_ierror = MPI_Waitany(
    *count,
    &c_array_of_requests,
    index,
    (MPI_Status*)status
  );
  *array_of_requests = MPI_Request_toint(c_array_of_requests);
  if (ierror) *ierror = c_ierror;
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
  MPI_Request c_array_of_requests = MPI_Request_fromint(*array_of_requests);
  const int c_ierror = MPI_Waitsome(
    *incount,
    &c_array_of_requests,
    outcount,
    array_of_indices,
    (MPI_Status*)array_of_statuses
  );
  *array_of_requests = MPI_Request_toint(c_array_of_requests);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Win_allocate(
    *size,
    *disp_unit,
    MPI_Info_fromint(*info),
    MPI_Comm_fromint(*comm),
    baseptr,
    &c_win
  );
  *win = MPI_Win_toint(c_win);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Win_allocate_shared(
    *size,
    *disp_unit,
    MPI_Info_fromint(*info),
    MPI_Comm_fromint(*comm),
    baseptr,
    &c_win
  );
  *win = MPI_Win_toint(c_win);
  if (ierror) *ierror = c_ierror;
}

void mpi_win_attach_(
  const MPI_Fint* restrict const win,
  void* restrict const base,
  const MPI_Aint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_attach(
    MPI_Win_fromint(*win),
    base,
    *size
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_call_errhandler_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const errorcode,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_call_errhandler(
    MPI_Win_fromint(*win),
    *errorcode
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_complete_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_complete(
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Win_create(
    base,
    *size,
    *disp_unit,
    MPI_Info_fromint(*info),
    MPI_Comm_fromint(*comm),
    &c_win
  );
  *win = MPI_Win_toint(c_win);
  if (ierror) *ierror = c_ierror;
}

void mpi_win_create_dynamic_(
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win;
  const int c_ierror = MPI_Win_create_dynamic(
    MPI_Info_fromint(*info),
    MPI_Comm_fromint(*comm),
    &c_win
  );
  *win = MPI_Win_toint(c_win);
  if (ierror) *ierror = c_ierror;
}

void mpi_win_create_errhandler_(
  MPI_Win_errhandler_function* const win_errhandler_fn,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  abort();
  MPI_Errhandler c_errhandler;
  const int c_ierror = MPI_Win_create_errhandler(
    win_errhandler_fn,
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Win_create_keyval(
    win_copy_attr_fn,
    win_delete_attr_fn,
    win_keyval,
    (void*)*extra_state
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_delete_attr_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const win_keyval,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_delete_attr(
    MPI_Win_fromint(*win),
    *win_keyval
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_detach_(
  const MPI_Fint* restrict const win,
  const void* restrict const base,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_detach(
    MPI_Win_fromint(*win),
    base
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_fence_(
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_fence(
    *assert,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_flush_(
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_flush(
    *rank,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_flush_all_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_flush_all(
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_flush_local_(
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_flush_local(
    *rank,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_flush_local_all_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_flush_local_all(
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_free_(
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  MPI_Win c_win = MPI_Win_fromint(*win);
  const int c_ierror = MPI_Win_free(
    &c_win
  );
  *win = MPI_Win_toint(c_win);
  if (ierror) *ierror = c_ierror;
}

void mpi_win_free_keyval_(
  MPI_Fint* restrict const win_keyval,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_free_keyval(
    win_keyval
  );
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Win_get_attr(
    MPI_Win_fromint(*win),
    *win_keyval,
    &c_attribute_val,
    &c_flag
  );
  *attribute_val = (MPI_Aint)c_attribute_val;
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_win_get_errhandler_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  MPI_Errhandler c_errhandler;
  const int c_ierror = MPI_Win_get_errhandler(
    MPI_Win_fromint(*win),
    &c_errhandler
  );
  *errhandler = MPI_Errhandler_toint(c_errhandler);
  if (ierror) *ierror = c_ierror;
}

void mpi_win_get_group_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const group,
  MPI_Fint* restrict const ierror
)
{
  MPI_Group c_group;
  const int c_ierror = MPI_Win_get_group(
    MPI_Win_fromint(*win),
    &c_group
  );
  *group = MPI_Group_toint(c_group);
  if (ierror) *ierror = c_ierror;
}

void mpi_win_get_info_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const info_used,
  MPI_Fint* restrict const ierror
)
{
  MPI_Info c_info_used;
  const int c_ierror = MPI_Win_get_info(
    MPI_Win_fromint(*win),
    &c_info_used
  );
  *info_used = MPI_Info_toint(c_info_used);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Win_get_name(
    MPI_Win_fromint(*win),
    c_win_name,
    resultlen
  );
  mpif_strcpy_c2f(win_name, c_win_name, length_win_name, strlen(c_win_name));
  if (ierror) *ierror = c_ierror;
}

void mpi_win_lock_(
  const MPI_Fint* restrict const lock_type,
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_lock(
    *lock_type,
    *rank,
    *assert,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_lock_all_(
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_lock_all(
    *assert,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_post_(
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_post(
    MPI_Group_fromint(*group),
    *assert,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_set_attr_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const win_keyval,
  const MPI_Aint* restrict const attribute_val,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_set_attr(
    MPI_Win_fromint(*win),
    *win_keyval,
    (void*)*attribute_val
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_set_errhandler_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const errhandler,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_set_errhandler(
    MPI_Win_fromint(*win),
    MPI_Errhandler_fromint(*errhandler)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_set_info_(
  const MPI_Fint* restrict const win,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_set_info(
    MPI_Win_fromint(*win),
    MPI_Info_fromint(*info)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_set_name_(
  const MPI_Fint* restrict const win,
  const char* restrict const win_name,
  MPI_Fint* restrict const ierror,
  const size_t length_win_name
)
{
  char* const c_win_name = mpif_strdup_f2c(win_name, length_win_name);
  const int c_ierror = MPI_Win_set_name(
    MPI_Win_fromint(*win),
    c_win_name
  );
  free(c_win_name);
  if (ierror) *ierror = c_ierror;
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
  const int c_ierror = MPI_Win_shared_query(
    MPI_Win_fromint(*win),
    *rank,
    size,
    disp_unit,
    baseptr
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_start_(
  const MPI_Fint* restrict const group,
  const MPI_Fint* restrict const assert,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_start(
    MPI_Group_fromint(*group),
    *assert,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_sync_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_sync(
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_test_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const flag,
  MPI_Fint* restrict const ierror
)
{
  MPI_Fint c_flag;
  const int c_ierror = MPI_Win_test(
    MPI_Win_fromint(*win),
    &c_flag
  );
  *flag = c_flag ? q_logical_true : q_logical_false;
  if (ierror) *ierror = c_ierror;
}

void mpi_win_unlock_(
  const MPI_Fint* restrict const rank,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_unlock(
    *rank,
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_unlock_all_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_unlock_all(
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
}

void mpi_win_wait_(
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  const int c_ierror = MPI_Win_wait(
    MPI_Win_fromint(*win)
  );
  if (ierror) *ierror = c_ierror;
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
