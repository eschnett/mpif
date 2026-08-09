// The cdesc entry points: Fortran-callable through the bind(C)
// interfaces of module mpif_f08_cdesc, taking each choice buffer as a
// CFI descriptor. Contiguous descriptors and the sentinels pass their
// base address through; anything else goes to src/mpif_cdesc.c's
// walker or is refused. See dev/mpiapi.jl; do not edit.

#ifdef MPIF_HAVE_CFI

#include <mpif_cdesc.h>
#include <mpif_strings.h>
#include <stdlib.h>
#include <string.h>

void mpi_accumulate_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Accumulate(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_accumulate_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Accumulate_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_accumulate_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Accumulate(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_accumulate_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Accumulate_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_allgather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allgather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_allgather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allgather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_allgather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allgather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_allgather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allgather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_allgather_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allgather_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_allgather_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allgather_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_allgather_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allgather_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_allgather_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allgather_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_allgatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allgatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_allgatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allgatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_allgatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allgatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_allgatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allgatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_allgatherv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allgatherv_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_allgatherv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allgatherv_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_allgatherv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allgatherv_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_allgatherv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allgatherv_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_allreduce_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allreduce(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_allreduce_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allreduce_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_allreduce_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allreduce(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_allreduce_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allreduce_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_allreduce_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allreduce_init(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_allreduce_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Allreduce_init_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_allreduce_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allreduce_init(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_allreduce_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Allreduce_init_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_alltoall_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoall(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_alltoall_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoall_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_alltoall_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoall(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_alltoall_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoall_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_alltoall_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoall_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_alltoall_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoall_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_alltoall_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoall_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_alltoall_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoall_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_alltoallv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoallv(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_alltoallv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoallv_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_alltoallv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoallv(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_alltoallv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoallv_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_alltoallv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoallv_init(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_alltoallv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoallv_init_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_alltoallv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoallv_init(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_alltoallv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoallv_init_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_alltoallw_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? MPI_Comm_remote_size(q_comm, &q_group_size)
                         : MPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoallw(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
}

void mpi_alltoallw_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? MPI_Comm_remote_size(q_comm, &q_group_size)
                         : MPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoallw_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_alltoallw_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? PMPI_Comm_remote_size(q_comm, &q_group_size)
                         : PMPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoallw(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_alltoallw_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? PMPI_Comm_remote_size(q_comm, &q_group_size)
                         : PMPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoallw_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
}

void mpi_alltoallw_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? MPI_Comm_remote_size(q_comm, &q_group_size)
                         : MPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoallw_init(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_alltoallw_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? MPI_Comm_remote_size(q_comm, &q_group_size)
                         : MPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Alltoallw_init_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_alltoallw_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? PMPI_Comm_remote_size(q_comm, &q_group_size)
                         : PMPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoallw_init(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_alltoallw_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? PMPI_Comm_remote_size(q_comm, &q_group_size)
                         : PMPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Alltoallw_init_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_bcast_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Bcast(
    q_buffer,
    (int)q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void mpi_bcast_c_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Bcast_c(
    q_buffer,
    q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void pmpi_bcast_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Bcast(
    q_buffer,
    (int)q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void pmpi_bcast_c_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Bcast_c(
    q_buffer,
    q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void mpi_bcast_init_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Bcast_init(
    q_buffer,
    (int)q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void mpi_bcast_init_c_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Bcast_init_c(
    q_buffer,
    q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void pmpi_bcast_init_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Bcast_init(
    q_buffer,
    (int)q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void pmpi_bcast_init_c_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Bcast_init_c(
    q_buffer,
    q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void mpi_bsend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Bsend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_bsend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Bsend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_bsend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Bsend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_bsend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Bsend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_bsend_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Bsend_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_bsend_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Bsend_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_bsend_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Bsend_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_bsend_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Bsend_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_buffer_attach_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = MPI_Buffer_attach(
    q_buffer,
    *size
  );
}

void mpi_buffer_attach_c_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = MPI_Buffer_attach_c(
    q_buffer,
    *size
  );
}

void pmpi_buffer_attach_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = PMPI_Buffer_attach(
    q_buffer,
    *size
  );
}

void pmpi_buffer_attach_c_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = PMPI_Buffer_attach_c(
    q_buffer,
    *size
  );
}

void mpi_comm_attach_buffer_cdesc(
  const MPI_Fint* restrict const comm,
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = MPI_Comm_attach_buffer(
    MPI_Comm_fromint(*comm),
    q_buffer,
    *size
  );
}

void mpi_comm_attach_buffer_c_cdesc(
  const MPI_Fint* restrict const comm,
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = MPI_Comm_attach_buffer_c(
    MPI_Comm_fromint(*comm),
    q_buffer,
    *size
  );
}

void pmpi_comm_attach_buffer_cdesc(
  const MPI_Fint* restrict const comm,
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = PMPI_Comm_attach_buffer(
    MPI_Comm_fromint(*comm),
    q_buffer,
    *size
  );
}

void pmpi_comm_attach_buffer_c_cdesc(
  const MPI_Fint* restrict const comm,
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = PMPI_Comm_attach_buffer_c(
    MPI_Comm_fromint(*comm),
    q_buffer,
    *size
  );
}

void mpi_compare_and_swap_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const CFI_cdesc_t* restrict const compare_addr,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_compare_addr = compare_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  *ierror = MPI_Compare_and_swap(
    q_origin_addr,
    q_compare_addr,
    q_result_addr,
    MPI_Type_fromint(*datatype),
    *target_rank,
    *target_disp,
    MPI_Win_fromint(*win)
  );
}

void pmpi_compare_and_swap_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const CFI_cdesc_t* restrict const compare_addr,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_compare_addr = compare_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  *ierror = PMPI_Compare_and_swap(
    q_origin_addr,
    q_compare_addr,
    q_result_addr,
    MPI_Type_fromint(*datatype),
    *target_rank,
    *target_disp,
    MPI_Win_fromint(*win)
  );
}

void mpi_exscan_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Exscan(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_exscan_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Exscan_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_exscan_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Exscan(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_exscan_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Exscan_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_exscan_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Exscan_init(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_exscan_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Exscan_init_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_exscan_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Exscan_init(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_exscan_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Exscan_init_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_f_sync_reg_cdesc(
  const CFI_cdesc_t* restrict const buf
)
{
}

void pmpi_f_sync_reg_cdesc(
  const CFI_cdesc_t* restrict const buf
)
{
}

void mpi_fetch_and_op_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  *ierror = MPI_Fetch_and_op(
    q_origin_addr,
    q_result_addr,
    MPI_Type_fromint(*datatype),
    *target_rank,
    *target_disp,
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
}

void pmpi_fetch_and_op_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  *ierror = PMPI_Fetch_and_op(
    q_origin_addr,
    q_result_addr,
    MPI_Type_fromint(*datatype),
    *target_rank,
    *target_disp,
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
}

void mpi_file_iread_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_all_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_all(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_all_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_all_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_all(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_all_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_at_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_at(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_at_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_at_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_at_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_at(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_at_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_at_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_at_all_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_at_all(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_at_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_at_all_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_at_all_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_at_all(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_at_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_at_all_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_shared_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_shared(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iread_shared_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iread_shared_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_shared_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_shared(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iread_shared_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iread_shared_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_all_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_all(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_all_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_all_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_all(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_all_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_at_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_at(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_at_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_at_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_at_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_at(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_at_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_at_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_at_all_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_at_all(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_at_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_at_all_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_at_all_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_at_all(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_at_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_at_all_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_shared_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_shared(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_iwrite_shared_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_iwrite_shared_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_shared_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_shared(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_iwrite_shared_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_iwrite_shared_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_all_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_all(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_all_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_all_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_all(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_all_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_all_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_all_begin(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_all_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_all_begin_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_all_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_all_begin(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_all_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_all_begin_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_all_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = MPI_File_read_all_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void pmpi_file_read_all_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = PMPI_File_read_all_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void mpi_file_read_at_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_at(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_at_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_at_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_at_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_at(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_at_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_at_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_at_all_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_at_all(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_at_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_at_all_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_at_all_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_at_all(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_at_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_at_all_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_at_all_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_at_all_begin(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_at_all_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_at_all_begin_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_at_all_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_at_all_begin(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_at_all_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_at_all_begin_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_at_all_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = MPI_File_read_at_all_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void pmpi_file_read_at_all_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = PMPI_File_read_at_all_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void mpi_file_read_ordered_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_ordered(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_ordered_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_ordered_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_ordered_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_ordered(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_ordered_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_ordered_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_ordered_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_ordered_begin(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_ordered_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_ordered_begin_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_ordered_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_ordered_begin(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_ordered_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_ordered_begin_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_ordered_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = MPI_File_read_ordered_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void pmpi_file_read_ordered_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = PMPI_File_read_ordered_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void mpi_file_read_shared_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_shared(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_read_shared_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_read_shared_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_shared_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_shared(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_read_shared_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_read_shared_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_all_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_all(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_all_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_all_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_all(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_all_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_all_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_all_begin(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_all_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_all_begin_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_all_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_all_begin(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_all_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_all_begin_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_all_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = MPI_File_write_all_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void pmpi_file_write_all_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = PMPI_File_write_all_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void mpi_file_write_at_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_at(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_at_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_at_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_at_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_at(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_at_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_at_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_at_all_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_at_all(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_at_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_at_all_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_at_all_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_at_all(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_at_all_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_at_all_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_at_all_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_at_all_begin(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_at_all_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_at_all_begin_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_at_all_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_at_all_begin(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_at_all_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const MPI_Offset* restrict const offset,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_at_all_begin_c(
    MPI_File_fromint(*fh),
    *offset,
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_at_all_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = MPI_File_write_at_all_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void pmpi_file_write_at_all_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = PMPI_File_write_at_all_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void mpi_file_write_ordered_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_ordered(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_ordered_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_ordered_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_ordered_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_ordered(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_ordered_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_ordered_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_ordered_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_ordered_begin(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_ordered_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_ordered_begin_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_ordered_begin_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_ordered_begin(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_ordered_begin_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_ordered_begin_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_ordered_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = MPI_File_write_ordered_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void pmpi_file_write_ordered_end_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buf = buf->base_addr;
  *ierror = PMPI_File_write_ordered_end(
    MPI_File_fromint(*fh),
    q_buf,
    status
  );
}

void mpi_file_write_shared_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_shared(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_file_write_shared_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_File_write_shared_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_shared_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_shared(
    MPI_File_fromint(*fh),
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_file_write_shared_c_cdesc(
  const MPI_Fint* restrict const fh,
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_File_write_shared_c(
    MPI_File_fromint(*fh),
    q_buf,
    q_buf_count,
    q_buf_type,
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_free_mem_cdesc(
  const CFI_cdesc_t* restrict const base,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  *ierror = MPI_Free_mem(
    q_base
  );
}

void pmpi_free_mem_cdesc(
  const CFI_cdesc_t* restrict const base,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  *ierror = PMPI_Free_mem(
    q_base
  );
}

void mpi_gather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Gather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_gather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Gather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_gather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Gather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_gather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Gather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_gather_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Gather_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_gather_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Gather_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_gather_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Gather_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_gather_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Gather_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_gatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Gatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_gatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Gatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_gatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Gatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_gatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Gatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_gatherv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Gatherv_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_gatherv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Gatherv_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_gatherv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Gatherv_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_gatherv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Gatherv_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_get_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Get(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_get_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Get_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_get_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Get(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_get_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Get_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_get_accumulate_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Fint* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  MPI_Datatype q_result_addr_type = MPI_Type_fromint(*result_datatype);
  MPI_Count q_result_addr_count = *result_count;
  int q_result_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_result_addr) && result_addr->rank != 0 && !CFI_is_contiguous(result_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(result_addr, q_result_addr_count, q_result_addr_type, &q_result_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_result_addr_count = 1;
      q_result_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    if (q_result_addr_owned)
      PMPI_Type_free(&q_result_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Get_accumulate(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    q_result_addr,
    (int)q_result_addr_count,
    q_result_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
  if (q_result_addr_owned)
    PMPI_Type_free(&q_result_addr_type);
}

void mpi_get_accumulate_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Count* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  MPI_Datatype q_result_addr_type = MPI_Type_fromint(*result_datatype);
  MPI_Count q_result_addr_count = *result_count;
  int q_result_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_result_addr) && result_addr->rank != 0 && !CFI_is_contiguous(result_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(result_addr, q_result_addr_count, q_result_addr_type, &q_result_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_result_addr_count = 1;
      q_result_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    if (q_result_addr_owned)
      PMPI_Type_free(&q_result_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Get_accumulate_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    q_result_addr,
    q_result_addr_count,
    q_result_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
  if (q_result_addr_owned)
    PMPI_Type_free(&q_result_addr_type);
}

void pmpi_get_accumulate_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Fint* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  MPI_Datatype q_result_addr_type = MPI_Type_fromint(*result_datatype);
  MPI_Count q_result_addr_count = *result_count;
  int q_result_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_result_addr) && result_addr->rank != 0 && !CFI_is_contiguous(result_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(result_addr, q_result_addr_count, q_result_addr_type, &q_result_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_result_addr_count = 1;
      q_result_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    if (q_result_addr_owned)
      PMPI_Type_free(&q_result_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Get_accumulate(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    q_result_addr,
    (int)q_result_addr_count,
    q_result_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
  if (q_result_addr_owned)
    PMPI_Type_free(&q_result_addr_type);
}

void pmpi_get_accumulate_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Count* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  MPI_Datatype q_result_addr_type = MPI_Type_fromint(*result_datatype);
  MPI_Count q_result_addr_count = *result_count;
  int q_result_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_result_addr) && result_addr->rank != 0 && !CFI_is_contiguous(result_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(result_addr, q_result_addr_count, q_result_addr_type, &q_result_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_result_addr_count = 1;
      q_result_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    if (q_result_addr_owned)
      PMPI_Type_free(&q_result_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Get_accumulate_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    q_result_addr,
    q_result_addr_count,
    q_result_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
  if (q_result_addr_owned)
    PMPI_Type_free(&q_result_addr_type);
}

void mpi_get_address_cdesc(
  const CFI_cdesc_t* restrict const location,
  MPI_Aint* restrict const address,
  MPI_Fint* restrict const ierror
)
{
  void* const q_location = location->base_addr;
  *ierror = MPI_Get_address(
    q_location,
    address
  );
}

void pmpi_get_address_cdesc(
  const CFI_cdesc_t* restrict const location,
  MPI_Aint* restrict const address,
  MPI_Fint* restrict const ierror
)
{
  void* const q_location = location->base_addr;
  *ierror = PMPI_Get_address(
    q_location,
    address
  );
}

void mpi_iallgather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iallgather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_iallgather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iallgather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_iallgather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iallgather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_iallgather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iallgather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_iallgatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iallgatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_iallgatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iallgatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_iallgatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iallgatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_iallgatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iallgatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_iallreduce_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iallreduce(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_iallreduce_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iallreduce_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_iallreduce_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iallreduce(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_iallreduce_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iallreduce_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ialltoall_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ialltoall(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_ialltoall_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ialltoall_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_ialltoall_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ialltoall(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_ialltoall_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ialltoall_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_ialltoallv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ialltoallv(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ialltoallv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ialltoallv_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ialltoallv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ialltoallv(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ialltoallv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ialltoallv_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ialltoallw_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? MPI_Comm_remote_size(q_comm, &q_group_size)
                         : MPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ialltoallw(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ialltoallw_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? MPI_Comm_remote_size(q_comm, &q_group_size)
                         : MPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ialltoallw_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ialltoallw_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? PMPI_Comm_remote_size(q_comm, &q_group_size)
                         : PMPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ialltoallw(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ialltoallw_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_group_size = 0;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror == MPI_SUCCESS)
      q_ierror = q_inter ? PMPI_Comm_remote_size(q_comm, &q_group_size)
                         : PMPI_Comm_size(q_comm, &q_group_size);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_group_size > 0 ? q_group_size : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_group_size; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_group_size > 0 ? q_group_size : 1];
  for (int rank=0; rank<q_group_size; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ialltoallw_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ibcast_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ibcast(
    q_buffer,
    (int)q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void mpi_ibcast_c_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ibcast_c(
    q_buffer,
    q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void pmpi_ibcast_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ibcast(
    q_buffer,
    (int)q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void pmpi_ibcast_c_cdesc(
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buffer = buffer->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buffer_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buffer_count = *count;
  int q_buffer_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buffer) && buffer->rank != 0 && !CFI_is_contiguous(buffer)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buffer, q_buffer_count, q_buffer_type, &q_buffer_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buffer_count = 1;
      q_buffer_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buffer_owned)
      PMPI_Type_free(&q_buffer_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ibcast_c(
    q_buffer,
    q_buffer_count,
    q_buffer_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buffer_owned)
    PMPI_Type_free(&q_buffer_type);
}

void mpi_ibsend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ibsend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_ibsend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ibsend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_ibsend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ibsend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_ibsend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ibsend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_iexscan_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iexscan(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_iexscan_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iexscan_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_iexscan_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iexscan(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_iexscan_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iexscan_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_igather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Igather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_igather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Igather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_igather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Igather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_igather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL;
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Igather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_igatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Igatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_igatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Igatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_igatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Igatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_igatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Igatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*recvtype) : MPI_DATATYPE_NULL,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_imrecv_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Imrecv(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_message,
    &c_request
  );
  *message = MPI_Message_toint(c_message);
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_imrecv_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Imrecv_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_message,
    &c_request
  );
  *message = MPI_Message_toint(c_message);
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_imrecv_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Imrecv(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_message,
    &c_request
  );
  *message = MPI_Message_toint(c_message);
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_imrecv_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Imrecv_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_message,
    &c_request
  );
  *message = MPI_Message_toint(c_message);
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_ineighbor_allgather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_allgather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_ineighbor_allgather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_allgather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_ineighbor_allgather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_allgather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_ineighbor_allgather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_allgather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_ineighbor_allgatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_allgatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_ineighbor_allgatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_allgatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_ineighbor_allgatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_allgatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_ineighbor_allgatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_allgatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_ineighbor_alltoall_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_alltoall(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_ineighbor_alltoall_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_alltoall_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_ineighbor_alltoall_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_alltoall(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_ineighbor_alltoall_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_alltoall_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_ineighbor_alltoallv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_alltoallv(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ineighbor_alltoallv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_alltoallv_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ineighbor_alltoallv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_alltoallv(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ineighbor_alltoallv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_alltoallv_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ineighbor_alltoallw_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = MPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = MPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = MPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = MPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = MPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_alltoallw(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ineighbor_alltoallw_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = MPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = MPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = MPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = MPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = MPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ineighbor_alltoallw_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ineighbor_alltoallw_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = PMPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = PMPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = PMPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = PMPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = PMPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_alltoallw(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ineighbor_alltoallw_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = PMPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = PMPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = PMPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = PMPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = PMPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ineighbor_alltoallw_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_irecv_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Irecv(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_irecv_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Irecv_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_irecv_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Irecv(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_irecv_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Irecv_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_ireduce_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ireduce(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ireduce_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ireduce_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ireduce_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ireduce(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ireduce_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ireduce_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ireduce_scatter_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ireduce_scatter(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ireduce_scatter_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ireduce_scatter_c(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ireduce_scatter_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ireduce_scatter(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ireduce_scatter_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ireduce_scatter_c(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ireduce_scatter_block_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ireduce_scatter_block(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_ireduce_scatter_block_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ireduce_scatter_block_c(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ireduce_scatter_block_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ireduce_scatter_block(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_ireduce_scatter_block_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ireduce_scatter_block_c(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_irsend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Irsend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_irsend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Irsend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_irsend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Irsend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_irsend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Irsend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_iscan_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iscan(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_iscan_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iscan_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_iscan_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iscan(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_iscan_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iscan_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_iscatter_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iscatter(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_iscatter_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iscatter_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_iscatter_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iscatter(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_iscatter_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iscatter_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_iscatterv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iscatterv(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_iscatterv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Iscatterv_c(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_iscatterv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iscatterv(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_iscatterv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Iscatterv_c(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_isend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Isend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_isend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Isend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_isend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Isend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_isend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Isend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_isendrecv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Isendrecv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    *dest,
    *sendtag,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_isendrecv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Isendrecv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    *dest,
    *sendtag,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_isendrecv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Isendrecv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    *dest,
    *sendtag,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_isendrecv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Isendrecv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    *dest,
    *sendtag,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_isendrecv_replace_cdesc(
  const CFI_cdesc_t* restrict const buf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Isendrecv_replace(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_isendrecv_replace_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Isendrecv_replace_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_isendrecv_replace_cdesc(
  const CFI_cdesc_t* restrict const buf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Isendrecv_replace(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_isendrecv_replace_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Isendrecv_replace_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_issend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Issend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_issend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Issend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_issend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Issend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_issend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Issend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_mrecv_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Mrecv(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_message,
    status
  );
  *message = MPI_Message_toint(c_message);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_mrecv_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Mrecv_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_message,
    status
  );
  *message = MPI_Message_toint(c_message);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_mrecv_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Mrecv(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    &c_message,
    status
  );
  *message = MPI_Message_toint(c_message);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_mrecv_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const message,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Message c_message = MPI_Message_fromint(*message);
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Mrecv_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    &c_message,
    status
  );
  *message = MPI_Message_toint(c_message);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_neighbor_allgather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_allgather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_neighbor_allgather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_allgather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_neighbor_allgather_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_allgather(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_neighbor_allgather_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_allgather_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_neighbor_allgather_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_allgather_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_neighbor_allgather_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_allgather_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_neighbor_allgather_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_allgather_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_neighbor_allgather_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_allgather_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_neighbor_allgatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_allgatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_neighbor_allgatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_allgatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_neighbor_allgatherv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_allgatherv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_neighbor_allgatherv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_allgatherv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_neighbor_allgatherv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_allgatherv_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_neighbor_allgatherv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_allgatherv_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_neighbor_allgatherv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_allgatherv_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void pmpi_neighbor_allgatherv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_allgatherv_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    recvcounts,
    displs,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
}

void mpi_neighbor_alltoall_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoall(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_neighbor_alltoall_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoall_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_neighbor_alltoall_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoall(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_neighbor_alltoall_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoall_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_neighbor_alltoall_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoall_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_neighbor_alltoall_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoall_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_neighbor_alltoall_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoall_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_neighbor_alltoall_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoall_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_neighbor_alltoallv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoallv(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoallv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoallv_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_neighbor_alltoallv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoallv(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_neighbor_alltoallv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoallv_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoallv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoallv_init(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_neighbor_alltoallv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoallv_init_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_neighbor_alltoallv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoallv_init(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_neighbor_alltoallv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoallv_init_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    MPI_Type_fromint(*sendtype),
    q_recvbuf,
    recvcounts,
    rdispls,
    MPI_Type_fromint(*recvtype),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_neighbor_alltoallw_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = MPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = MPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = MPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = MPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = MPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoallw(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoallw_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = MPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = MPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = MPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = MPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = MPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoallw_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_neighbor_alltoallw_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = PMPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = PMPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = PMPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = PMPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = PMPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoallw(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_neighbor_alltoallw_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = PMPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = PMPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = PMPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = PMPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = PMPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoallw_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm)
  );
}

void mpi_neighbor_alltoallw_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = MPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = MPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = MPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = MPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = MPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoallw_init(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_neighbor_alltoallw_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = MPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = MPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = MPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = MPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = MPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Neighbor_alltoallw_init_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_neighbor_alltoallw_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = PMPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = PMPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = PMPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = PMPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = PMPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoallw_init(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_neighbor_alltoallw_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const sdispls,
  const MPI_Fint* restrict const sendtypes,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Aint* restrict const rdispls,
  const MPI_Fint* restrict const recvtypes,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_indegree = 0, q_outdegree = 0;
  {
    int q_topology;
    int q_ierror = PMPI_Topo_test(q_comm, &q_topology);
    if (q_ierror == MPI_SUCCESS) {
      if (q_topology == MPI_CART) {
        int q_ndims;
        q_ierror = PMPI_Cartdim_get(q_comm, &q_ndims);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = 2 * q_ndims;
      } else if (q_topology == MPI_GRAPH) {
        int q_neighbor_rank;
        int q_nneighbors;
        q_ierror = PMPI_Comm_rank(q_comm, &q_neighbor_rank);
        if (q_ierror == MPI_SUCCESS)
          q_ierror = PMPI_Graph_neighbors_count(q_comm, q_neighbor_rank, &q_nneighbors);
        if (q_ierror == MPI_SUCCESS)
          q_indegree = q_outdegree = q_nneighbors;
      } else if (q_topology == MPI_DIST_GRAPH) {
        int q_weighted;
        q_ierror = PMPI_Dist_graph_neighbors_count(q_comm, &q_indegree, &q_outdegree, &q_weighted);
      }
    }
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
  }
  MPI_Datatype c_sendtypes[q_outdegree > 0 ? q_outdegree : 1];
  if (q_sendbuf != MPI_IN_PLACE) {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_Type_fromint(sendtypes[rank]);
  } else {
    for (int rank=0; rank<q_outdegree; ++rank)
      c_sendtypes[rank] = MPI_DATATYPE_NULL;
  }
  MPI_Datatype c_recvtypes[q_indegree > 0 ? q_indegree : 1];
  for (int rank=0; rank<q_indegree; ++rank)
    c_recvtypes[rank] = MPI_Type_fromint(recvtypes[rank]);
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Neighbor_alltoallw_init_c(
    q_sendbuf,
    sendcounts,
    sdispls,
    c_sendtypes,
    q_recvbuf,
    recvcounts,
    rdispls,
    c_recvtypes,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_pack_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Fint* restrict const outsize,
  MPI_Fint* restrict const position,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  MPI_Datatype q_inbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_inbuf_count = *incount;
  int q_inbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(inbuf, q_inbuf_count, q_inbuf_type, &q_inbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_inbuf_count = 1;
      q_inbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_inbuf_owned)
      PMPI_Type_free(&q_inbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Pack(
    q_inbuf,
    (int)q_inbuf_count,
    q_inbuf_type,
    q_outbuf,
    *outsize,
    position,
    MPI_Comm_fromint(*comm)
  );
  if (q_inbuf_owned)
    PMPI_Type_free(&q_inbuf_type);
}

void mpi_pack_c_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Count* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Count* restrict const outsize,
  MPI_Count* restrict const position,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  MPI_Datatype q_inbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_inbuf_count = *incount;
  int q_inbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(inbuf, q_inbuf_count, q_inbuf_type, &q_inbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_inbuf_count = 1;
      q_inbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_inbuf_owned)
      PMPI_Type_free(&q_inbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Pack_c(
    q_inbuf,
    q_inbuf_count,
    q_inbuf_type,
    q_outbuf,
    *outsize,
    position,
    MPI_Comm_fromint(*comm)
  );
  if (q_inbuf_owned)
    PMPI_Type_free(&q_inbuf_type);
}

void pmpi_pack_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Fint* restrict const outsize,
  MPI_Fint* restrict const position,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  MPI_Datatype q_inbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_inbuf_count = *incount;
  int q_inbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(inbuf, q_inbuf_count, q_inbuf_type, &q_inbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_inbuf_count = 1;
      q_inbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_inbuf_owned)
      PMPI_Type_free(&q_inbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Pack(
    q_inbuf,
    (int)q_inbuf_count,
    q_inbuf_type,
    q_outbuf,
    *outsize,
    position,
    MPI_Comm_fromint(*comm)
  );
  if (q_inbuf_owned)
    PMPI_Type_free(&q_inbuf_type);
}

void pmpi_pack_c_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Count* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Count* restrict const outsize,
  MPI_Count* restrict const position,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  MPI_Datatype q_inbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_inbuf_count = *incount;
  int q_inbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(inbuf, q_inbuf_count, q_inbuf_type, &q_inbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_inbuf_count = 1;
      q_inbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_inbuf_owned)
      PMPI_Type_free(&q_inbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Pack_c(
    q_inbuf,
    q_inbuf_count,
    q_inbuf_type,
    q_outbuf,
    *outsize,
    position,
    MPI_Comm_fromint(*comm)
  );
  if (q_inbuf_owned)
    PMPI_Type_free(&q_inbuf_type);
}

void mpi_pack_external_cdesc(
  const char* restrict const datarep,
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Aint* restrict const outsize,
  MPI_Aint* restrict const position,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  MPI_Datatype q_inbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_inbuf_count = *incount;
  int q_inbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(inbuf, q_inbuf_count, q_inbuf_type, &q_inbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_inbuf_count = 1;
      q_inbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_inbuf_owned)
      PMPI_Type_free(&q_inbuf_type);
    free(c_datarep);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Pack_external(
    c_datarep,
    q_inbuf,
    (int)q_inbuf_count,
    q_inbuf_type,
    q_outbuf,
    *outsize,
    position
  );
  free(c_datarep);
  if (q_inbuf_owned)
    PMPI_Type_free(&q_inbuf_type);
}

void mpi_pack_external_c_cdesc(
  const char* restrict const datarep,
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Count* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Count* restrict const outsize,
  MPI_Count* restrict const position,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  MPI_Datatype q_inbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_inbuf_count = *incount;
  int q_inbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(inbuf, q_inbuf_count, q_inbuf_type, &q_inbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_inbuf_count = 1;
      q_inbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_inbuf_owned)
      PMPI_Type_free(&q_inbuf_type);
    free(c_datarep);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Pack_external_c(
    c_datarep,
    q_inbuf,
    q_inbuf_count,
    q_inbuf_type,
    q_outbuf,
    *outsize,
    position
  );
  free(c_datarep);
  if (q_inbuf_owned)
    PMPI_Type_free(&q_inbuf_type);
}

void pmpi_pack_external_cdesc(
  const char* restrict const datarep,
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Fint* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Aint* restrict const outsize,
  MPI_Aint* restrict const position,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  MPI_Datatype q_inbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_inbuf_count = *incount;
  int q_inbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(inbuf, q_inbuf_count, q_inbuf_type, &q_inbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_inbuf_count = 1;
      q_inbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_inbuf_owned)
      PMPI_Type_free(&q_inbuf_type);
    free(c_datarep);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Pack_external(
    c_datarep,
    q_inbuf,
    (int)q_inbuf_count,
    q_inbuf_type,
    q_outbuf,
    *outsize,
    position
  );
  free(c_datarep);
  if (q_inbuf_owned)
    PMPI_Type_free(&q_inbuf_type);
}

void pmpi_pack_external_c_cdesc(
  const char* restrict const datarep,
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Count* restrict const incount,
  const MPI_Fint* restrict const datatype,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Count* restrict const outsize,
  MPI_Count* restrict const position,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  MPI_Datatype q_inbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_inbuf_count = *incount;
  int q_inbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(inbuf, q_inbuf_count, q_inbuf_type, &q_inbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_inbuf_count = 1;
      q_inbuf_owned = 1;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_inbuf_owned)
      PMPI_Type_free(&q_inbuf_type);
    free(c_datarep);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Pack_external_c(
    c_datarep,
    q_inbuf,
    q_inbuf_count,
    q_inbuf_type,
    q_outbuf,
    *outsize,
    position
  );
  free(c_datarep);
  if (q_inbuf_owned)
    PMPI_Type_free(&q_inbuf_type);
}

void mpi_precv_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const partitions,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Precv_init(
    q_buf,
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
}

void pmpi_precv_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const partitions,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Precv_init(
    q_buf,
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
}

void mpi_psend_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const partitions,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Psend_init(
    q_buf,
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
}

void pmpi_psend_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const partitions,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Psend_init(
    q_buf,
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
}

void mpi_put_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Put(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_put_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Put_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_put_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Put(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_put_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Put_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win)
  );
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_raccumulate_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Raccumulate(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_raccumulate_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Raccumulate_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_raccumulate_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Raccumulate(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_raccumulate_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Raccumulate_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_recv_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Recv(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_recv_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Recv_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_recv_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Recv(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_recv_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Recv_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_recv_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Recv_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_recv_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Recv_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_recv_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Recv_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_recv_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Recv_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *source,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_reduce_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm)
  );
}

void mpi_reduce_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_reduce_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_reduce_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm)
  );
}

void mpi_reduce_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_init(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_reduce_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_init_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_reduce_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_init(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_reduce_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
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
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_init_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_reduce_local_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const CFI_cdesc_t* restrict const inoutbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_inoutbuf = inoutbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_inoutbuf) && inoutbuf->rank != 0 && !CFI_is_contiguous(inoutbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_local(
    q_inbuf,
    q_inoutbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op)
  );
}

void mpi_reduce_local_c_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const CFI_cdesc_t* restrict const inoutbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_inoutbuf = inoutbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_inoutbuf) && inoutbuf->rank != 0 && !CFI_is_contiguous(inoutbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_local_c(
    q_inbuf,
    q_inoutbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op)
  );
}

void pmpi_reduce_local_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const CFI_cdesc_t* restrict const inoutbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_inoutbuf = inoutbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_inoutbuf) && inoutbuf->rank != 0 && !CFI_is_contiguous(inoutbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_local(
    q_inbuf,
    q_inoutbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op)
  );
}

void pmpi_reduce_local_c_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const CFI_cdesc_t* restrict const inoutbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_inoutbuf = inoutbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_inoutbuf) && inoutbuf->rank != 0 && !CFI_is_contiguous(inoutbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_local_c(
    q_inbuf,
    q_inoutbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op)
  );
}

void mpi_reduce_scatter_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_scatter(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_reduce_scatter_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_scatter_c(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_reduce_scatter_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_scatter(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_reduce_scatter_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_scatter_c(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_reduce_scatter_block_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_scatter_block(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_reduce_scatter_block_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_scatter_block_c(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_reduce_scatter_block_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_scatter_block(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_reduce_scatter_block_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_scatter_block_c(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_reduce_scatter_block_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_scatter_block_init(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_reduce_scatter_block_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_scatter_block_init_c(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_reduce_scatter_block_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_scatter_block_init(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_reduce_scatter_block_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_scatter_block_init_c(
    q_sendbuf,
    q_recvbuf,
    *recvcount,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_reduce_scatter_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_scatter_init(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_reduce_scatter_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Reduce_scatter_init_c(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_reduce_scatter_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_scatter_init(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_reduce_scatter_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcounts,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Reduce_scatter_init_c(
    q_sendbuf,
    q_recvbuf,
    recvcounts,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_rget_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rget(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_rget_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rget_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_rget_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rget(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_rget_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rget_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_rget_accumulate_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Fint* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  MPI_Datatype q_result_addr_type = MPI_Type_fromint(*result_datatype);
  MPI_Count q_result_addr_count = *result_count;
  int q_result_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_result_addr) && result_addr->rank != 0 && !CFI_is_contiguous(result_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(result_addr, q_result_addr_count, q_result_addr_type, &q_result_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_result_addr_count = 1;
      q_result_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    if (q_result_addr_owned)
      PMPI_Type_free(&q_result_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rget_accumulate(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    q_result_addr,
    (int)q_result_addr_count,
    q_result_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
  if (q_result_addr_owned)
    PMPI_Type_free(&q_result_addr_type);
}

void mpi_rget_accumulate_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Count* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  MPI_Datatype q_result_addr_type = MPI_Type_fromint(*result_datatype);
  MPI_Count q_result_addr_count = *result_count;
  int q_result_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_result_addr) && result_addr->rank != 0 && !CFI_is_contiguous(result_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(result_addr, q_result_addr_count, q_result_addr_type, &q_result_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_result_addr_count = 1;
      q_result_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    if (q_result_addr_owned)
      PMPI_Type_free(&q_result_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rget_accumulate_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    q_result_addr,
    q_result_addr_count,
    q_result_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
  if (q_result_addr_owned)
    PMPI_Type_free(&q_result_addr_type);
}

void pmpi_rget_accumulate_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Fint* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  MPI_Datatype q_result_addr_type = MPI_Type_fromint(*result_datatype);
  MPI_Count q_result_addr_count = *result_count;
  int q_result_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_result_addr) && result_addr->rank != 0 && !CFI_is_contiguous(result_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(result_addr, q_result_addr_count, q_result_addr_type, &q_result_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_result_addr_count = 1;
      q_result_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    if (q_result_addr_owned)
      PMPI_Type_free(&q_result_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rget_accumulate(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    q_result_addr,
    (int)q_result_addr_count,
    q_result_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
  if (q_result_addr_owned)
    PMPI_Type_free(&q_result_addr_type);
}

void pmpi_rget_accumulate_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const CFI_cdesc_t* restrict const result_addr,
  const MPI_Count* restrict const result_count,
  const MPI_Fint* restrict const result_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  void* const q_result_addr = result_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  MPI_Datatype q_result_addr_type = MPI_Type_fromint(*result_datatype);
  MPI_Count q_result_addr_count = *result_count;
  int q_result_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_result_addr) && result_addr->rank != 0 && !CFI_is_contiguous(result_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(result_addr, q_result_addr_count, q_result_addr_type, &q_result_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_result_addr_count = 1;
      q_result_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    if (q_result_addr_owned)
      PMPI_Type_free(&q_result_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rget_accumulate_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    q_result_addr,
    q_result_addr_count,
    q_result_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Op_fromint(*op),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
  if (q_result_addr_owned)
    PMPI_Type_free(&q_result_addr_type);
}

void mpi_rput_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rput(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_rput_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rput_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_rput_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Fint* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Fint* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rput(
    q_origin_addr,
    (int)q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void pmpi_rput_c_cdesc(
  const CFI_cdesc_t* restrict const origin_addr,
  const MPI_Count* restrict const origin_count,
  const MPI_Fint* restrict const origin_datatype,
  const MPI_Fint* restrict const target_rank,
  const MPI_Aint* restrict const target_disp,
  const MPI_Count* restrict const target_count,
  const MPI_Fint* restrict const target_datatype,
  const MPI_Fint* restrict const win,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_origin_addr = origin_addr->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_origin_addr_type = MPI_Type_fromint(*origin_datatype);
  MPI_Count q_origin_addr_count = *origin_count;
  int q_origin_addr_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_origin_addr) && origin_addr->rank != 0 && !CFI_is_contiguous(origin_addr)) {
    q_cdesc_err = mpif_cdesc_create_datatype(origin_addr, q_origin_addr_count, q_origin_addr_type, &q_origin_addr_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_origin_addr_count = 1;
      q_origin_addr_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_origin_addr_owned)
      PMPI_Type_free(&q_origin_addr_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rput_c(
    q_origin_addr,
    q_origin_addr_count,
    q_origin_addr_type,
    *target_rank,
    *target_disp,
    *target_count,
    MPI_Type_fromint(*target_datatype),
    MPI_Win_fromint(*win),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_origin_addr_owned)
    PMPI_Type_free(&q_origin_addr_type);
}

void mpi_rsend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rsend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_rsend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rsend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_rsend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rsend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_rsend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rsend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_rsend_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rsend_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_rsend_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Rsend_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_rsend_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rsend_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_rsend_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Rsend_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_scan_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scan(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_scan_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scan_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_scan_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scan(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void pmpi_scan_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scan_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm)
  );
}

void mpi_scan_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scan_init(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_scan_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scan_init_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_scan_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scan_init(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void pmpi_scan_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const op,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  if (!mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (!mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err != MPI_SUCCESS) {
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scan_init_c(
    q_sendbuf,
    q_recvbuf,
    *count,
    MPI_Type_fromint(*datatype),
    MPI_Op_fromint(*op),
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
}

void mpi_scatter_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scatter(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_scatter_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scatter_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_scatter_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scatter(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_scatter_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scatter_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_scatter_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scatter_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_scatter_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scatter_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_scatter_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scatter_init(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_scatter_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_sendbuf_type = q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL;
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scatter_init_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_scatterv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scatterv(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_scatterv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scatterv_c(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_scatterv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scatterv(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_scatterv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scatterv_c(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm)
  );
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_scatterv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scatterv_init(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_scatterv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = MPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = MPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Scatterv_init_c(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_scatterv_init_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcounts,
  const MPI_Fint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scatterv_init(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_scatterv_init_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcounts,
  const MPI_Aint* restrict const displs,
  const MPI_Fint* restrict const sendtype,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const root,
  const MPI_Fint* restrict const comm,
  const MPI_Fint* restrict const info,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  const MPI_Comm q_comm = MPI_Comm_fromint(*comm);
  int q_at_root;
  {
    int q_inter;
    int q_ierror = PMPI_Comm_test_inter(q_comm, &q_inter);
    if (q_ierror != MPI_SUCCESS) {
      *ierror = q_ierror;
      return;
    }
    if (q_inter) {
      q_at_root = *root == MPI_ROOT;
    } else {
      int q_comm_rank;
      q_ierror = PMPI_Comm_rank(q_comm, &q_comm_rank);
      if (q_ierror != MPI_SUCCESS) {
        *ierror = q_ierror;
        return;
      }
      q_at_root = q_comm_rank == *root;
    }
  }
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_at_root && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && q_at_root && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Scatterv_init_c(
    q_sendbuf,
    sendcounts,
    displs,
    q_at_root ? MPI_Type_fromint(*sendtype) : MPI_DATATYPE_NULL,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *root,
    MPI_Comm_fromint(*comm),
    MPI_Info_fromint(*info),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_send_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Send(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_send_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Send_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_send_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Send(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_send_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Send_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_send_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Send_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_send_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Send_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_send_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Send_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_send_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Send_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_sendrecv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Sendrecv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    *dest,
    *sendtag,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_sendrecv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Sendrecv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    *dest,
    *sendtag,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_sendrecv_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Fint* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Fint* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Sendrecv(
    q_sendbuf,
    (int)q_sendbuf_count,
    q_sendbuf_type,
    *dest,
    *sendtag,
    q_recvbuf,
    (int)q_recvbuf_count,
    q_recvbuf_type,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void pmpi_sendrecv_c_cdesc(
  const CFI_cdesc_t* restrict const sendbuf,
  const MPI_Count* restrict const sendcount,
  const MPI_Fint* restrict const sendtype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const CFI_cdesc_t* restrict const recvbuf,
  const MPI_Count* restrict const recvcount,
  const MPI_Fint* restrict const recvtype,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_sendbuf = sendbuf->base_addr;
  void* const q_recvbuf = recvbuf->base_addr;
  MPI_Datatype q_sendbuf_type = MPI_Type_fromint(*sendtype);
  MPI_Count q_sendbuf_count = *sendcount;
  int q_sendbuf_owned = 0;
  MPI_Datatype q_recvbuf_type = MPI_Type_fromint(*recvtype);
  MPI_Count q_recvbuf_count = *recvcount;
  int q_recvbuf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_sendbuf) && sendbuf->rank != 0 && !CFI_is_contiguous(sendbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(sendbuf, q_sendbuf_count, q_sendbuf_type, &q_sendbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_sendbuf_count = 1;
      q_sendbuf_owned = 1;
    }
  }
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_recvbuf) && recvbuf->rank != 0 && !CFI_is_contiguous(recvbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(recvbuf, q_recvbuf_count, q_recvbuf_type, &q_recvbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_recvbuf_count = 1;
      q_recvbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_sendbuf_owned)
      PMPI_Type_free(&q_sendbuf_type);
    if (q_recvbuf_owned)
      PMPI_Type_free(&q_recvbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Sendrecv_c(
    q_sendbuf,
    q_sendbuf_count,
    q_sendbuf_type,
    *dest,
    *sendtag,
    q_recvbuf,
    q_recvbuf_count,
    q_recvbuf_type,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_sendbuf_owned)
    PMPI_Type_free(&q_sendbuf_type);
  if (q_recvbuf_owned)
    PMPI_Type_free(&q_recvbuf_type);
}

void mpi_sendrecv_replace_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Sendrecv_replace(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_sendrecv_replace_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Sendrecv_replace_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_sendrecv_replace_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Sendrecv_replace(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_sendrecv_replace_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const sendtag,
  const MPI_Fint* restrict const source,
  const MPI_Fint* restrict const recvtag,
  const MPI_Fint* restrict const comm,
  MPI_Status* restrict const status,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Sendrecv_replace_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *sendtag,
    *source,
    *recvtag,
    MPI_Comm_fromint(*comm),
    status
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_session_attach_buffer_cdesc(
  const MPI_Fint* restrict const session,
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = MPI_Session_attach_buffer(
    MPI_Session_fromint(*session),
    q_buffer,
    *size
  );
}

void mpi_session_attach_buffer_c_cdesc(
  const MPI_Fint* restrict const session,
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = MPI_Session_attach_buffer_c(
    MPI_Session_fromint(*session),
    q_buffer,
    *size
  );
}

void pmpi_session_attach_buffer_cdesc(
  const MPI_Fint* restrict const session,
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Fint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = PMPI_Session_attach_buffer(
    MPI_Session_fromint(*session),
    q_buffer,
    *size
  );
}

void pmpi_session_attach_buffer_c_cdesc(
  const MPI_Fint* restrict const session,
  const CFI_cdesc_t* restrict const buffer,
  const MPI_Count* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_buffer = buffer->base_addr;
  *ierror = PMPI_Session_attach_buffer_c(
    MPI_Session_fromint(*session),
    q_buffer,
    *size
  );
}

void mpi_ssend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ssend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_ssend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ssend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_ssend_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ssend(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_ssend_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ssend_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm)
  );
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_ssend_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ssend_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_ssend_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Ssend_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_ssend_init_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Fint* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ssend_init(
    q_buf,
    (int)q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void pmpi_ssend_init_c_cdesc(
  const CFI_cdesc_t* restrict const buf,
  const MPI_Count* restrict const count,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const dest,
  const MPI_Fint* restrict const tag,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const request,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_buf = buf->base_addr;
  MPI_Request c_request = MPI_REQUEST_NULL;
  MPI_Datatype q_buf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_buf_count = *count;
  int q_buf_owned = 0;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_buf) && buf->rank != 0 && !CFI_is_contiguous(buf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(buf, q_buf_count, q_buf_type, &q_buf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_buf_count = 1;
      q_buf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_buf_owned)
      PMPI_Type_free(&q_buf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Ssend_init_c(
    q_buf,
    q_buf_count,
    q_buf_type,
    *dest,
    *tag,
    MPI_Comm_fromint(*comm),
    &c_request
  );
  *request = MPI_Request_toint(c_request);
  if (q_buf_owned)
    PMPI_Type_free(&q_buf_type);
}

void mpi_unpack_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Fint* restrict const insize,
  MPI_Fint* restrict const position,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Fint* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  MPI_Datatype q_outbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_outbuf_count = *outcount;
  int q_outbuf_owned = 0;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(outbuf, q_outbuf_count, q_outbuf_type, &q_outbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_outbuf_count = 1;
      q_outbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_outbuf_owned)
      PMPI_Type_free(&q_outbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Unpack(
    q_inbuf,
    *insize,
    position,
    q_outbuf,
    (int)q_outbuf_count,
    q_outbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_outbuf_owned)
    PMPI_Type_free(&q_outbuf_type);
}

void mpi_unpack_c_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Count* restrict const insize,
  MPI_Count* restrict const position,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Count* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  MPI_Datatype q_outbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_outbuf_count = *outcount;
  int q_outbuf_owned = 0;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(outbuf, q_outbuf_count, q_outbuf_type, &q_outbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_outbuf_count = 1;
      q_outbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_outbuf_owned)
      PMPI_Type_free(&q_outbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Unpack_c(
    q_inbuf,
    *insize,
    position,
    q_outbuf,
    q_outbuf_count,
    q_outbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_outbuf_owned)
    PMPI_Type_free(&q_outbuf_type);
}

void pmpi_unpack_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Fint* restrict const insize,
  MPI_Fint* restrict const position,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Fint* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  MPI_Datatype q_outbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_outbuf_count = *outcount;
  int q_outbuf_owned = 0;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(outbuf, q_outbuf_count, q_outbuf_type, &q_outbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_outbuf_count = 1;
      q_outbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_outbuf_owned)
      PMPI_Type_free(&q_outbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Unpack(
    q_inbuf,
    *insize,
    position,
    q_outbuf,
    (int)q_outbuf_count,
    q_outbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_outbuf_owned)
    PMPI_Type_free(&q_outbuf_type);
}

void pmpi_unpack_c_cdesc(
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Count* restrict const insize,
  MPI_Count* restrict const position,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Count* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const ierror
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  MPI_Datatype q_outbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_outbuf_count = *outcount;
  int q_outbuf_owned = 0;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(outbuf, q_outbuf_count, q_outbuf_type, &q_outbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_outbuf_count = 1;
      q_outbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_outbuf_owned)
      PMPI_Type_free(&q_outbuf_type);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Unpack_c(
    q_inbuf,
    *insize,
    position,
    q_outbuf,
    q_outbuf_count,
    q_outbuf_type,
    MPI_Comm_fromint(*comm)
  );
  if (q_outbuf_owned)
    PMPI_Type_free(&q_outbuf_type);
}

void mpi_unpack_external_cdesc(
  const char* restrict const datarep,
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Aint* restrict const insize,
  MPI_Aint* restrict const position,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Fint* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  MPI_Datatype q_outbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_outbuf_count = *outcount;
  int q_outbuf_owned = 0;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(outbuf, q_outbuf_count, q_outbuf_type, &q_outbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_outbuf_count = 1;
      q_outbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_outbuf_owned)
      PMPI_Type_free(&q_outbuf_type);
    free(c_datarep);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Unpack_external(
    c_datarep,
    q_inbuf,
    *insize,
    position,
    q_outbuf,
    (int)q_outbuf_count,
    q_outbuf_type
  );
  free(c_datarep);
  if (q_outbuf_owned)
    PMPI_Type_free(&q_outbuf_type);
}

void mpi_unpack_external_c_cdesc(
  const char* restrict const datarep,
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Count* restrict const insize,
  MPI_Count* restrict const position,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Count* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  MPI_Datatype q_outbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_outbuf_count = *outcount;
  int q_outbuf_owned = 0;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(outbuf, q_outbuf_count, q_outbuf_type, &q_outbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_outbuf_count = 1;
      q_outbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_outbuf_owned)
      PMPI_Type_free(&q_outbuf_type);
    free(c_datarep);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = MPI_Unpack_external_c(
    c_datarep,
    q_inbuf,
    *insize,
    position,
    q_outbuf,
    q_outbuf_count,
    q_outbuf_type
  );
  free(c_datarep);
  if (q_outbuf_owned)
    PMPI_Type_free(&q_outbuf_type);
}

void pmpi_unpack_external_cdesc(
  const char* restrict const datarep,
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Aint* restrict const insize,
  MPI_Aint* restrict const position,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Fint* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  MPI_Datatype q_outbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_outbuf_count = *outcount;
  int q_outbuf_owned = 0;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(outbuf, q_outbuf_count, q_outbuf_type, &q_outbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_outbuf_count = 1;
      q_outbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_outbuf_owned)
      PMPI_Type_free(&q_outbuf_type);
    free(c_datarep);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Unpack_external(
    c_datarep,
    q_inbuf,
    *insize,
    position,
    q_outbuf,
    (int)q_outbuf_count,
    q_outbuf_type
  );
  free(c_datarep);
  if (q_outbuf_owned)
    PMPI_Type_free(&q_outbuf_type);
}

void pmpi_unpack_external_c_cdesc(
  const char* restrict const datarep,
  const CFI_cdesc_t* restrict const inbuf,
  const MPI_Count* restrict const insize,
  MPI_Count* restrict const position,
  const CFI_cdesc_t* restrict const outbuf,
  const MPI_Count* restrict const outcount,
  const MPI_Fint* restrict const datatype,
  MPI_Fint* restrict const ierror,
  const size_t length_datarep
)
{
  int q_cdesc_err = MPI_SUCCESS;
  void* const q_inbuf = inbuf->base_addr;
  void* const q_outbuf = outbuf->base_addr;
  char* const c_datarep = mpif_strdup_f2c(datarep, length_datarep);
  MPI_Datatype q_outbuf_type = MPI_Type_fromint(*datatype);
  MPI_Count q_outbuf_count = *outcount;
  int q_outbuf_owned = 0;
  if (!mpif_cdesc_is_sentinel(q_inbuf) && inbuf->rank != 0 && !CFI_is_contiguous(inbuf))
    q_cdesc_err = MPI_ERR_BUFFER;
  if (q_cdesc_err == MPI_SUCCESS && !mpif_cdesc_is_sentinel(q_outbuf) && outbuf->rank != 0 && !CFI_is_contiguous(outbuf)) {
    q_cdesc_err = mpif_cdesc_create_datatype(outbuf, q_outbuf_count, q_outbuf_type, &q_outbuf_type);
    if (q_cdesc_err == MPI_SUCCESS) {
      q_outbuf_count = 1;
      q_outbuf_owned = 1;
    }
  }
  if (q_cdesc_err != MPI_SUCCESS) {
    if (q_outbuf_owned)
      PMPI_Type_free(&q_outbuf_type);
    free(c_datarep);
    *ierror = q_cdesc_err;
    return;
  }
  *ierror = PMPI_Unpack_external_c(
    c_datarep,
    q_inbuf,
    *insize,
    position,
    q_outbuf,
    q_outbuf_count,
    q_outbuf_type
  );
  free(c_datarep);
  if (q_outbuf_owned)
    PMPI_Type_free(&q_outbuf_type);
}

void mpi_win_attach_cdesc(
  const MPI_Fint* restrict const win,
  const CFI_cdesc_t* restrict const base,
  const MPI_Aint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  *ierror = MPI_Win_attach(
    MPI_Win_fromint(*win),
    q_base,
    *size
  );
}

void pmpi_win_attach_cdesc(
  const MPI_Fint* restrict const win,
  const CFI_cdesc_t* restrict const base,
  const MPI_Aint* restrict const size,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  *ierror = PMPI_Win_attach(
    MPI_Win_fromint(*win),
    q_base,
    *size
  );
}

void mpi_win_create_cdesc(
  const CFI_cdesc_t* restrict const base,
  const MPI_Aint* restrict const size,
  const MPI_Fint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  MPI_Win c_win = MPI_WIN_NULL;
  *ierror = MPI_Win_create(
    q_base,
    *size,
    *disp_unit,
    MPI_Info_fromint(*info),
    MPI_Comm_fromint(*comm),
    &c_win
  );
  *win = MPI_Win_toint(c_win);
}

void mpi_win_create_c_cdesc(
  const CFI_cdesc_t* restrict const base,
  const MPI_Aint* restrict const size,
  const MPI_Aint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  MPI_Win c_win = MPI_WIN_NULL;
  *ierror = MPI_Win_create_c(
    q_base,
    *size,
    *disp_unit,
    MPI_Info_fromint(*info),
    MPI_Comm_fromint(*comm),
    &c_win
  );
  *win = MPI_Win_toint(c_win);
}

void pmpi_win_create_cdesc(
  const CFI_cdesc_t* restrict const base,
  const MPI_Aint* restrict const size,
  const MPI_Fint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  MPI_Win c_win = MPI_WIN_NULL;
  *ierror = PMPI_Win_create(
    q_base,
    *size,
    *disp_unit,
    MPI_Info_fromint(*info),
    MPI_Comm_fromint(*comm),
    &c_win
  );
  *win = MPI_Win_toint(c_win);
}

void pmpi_win_create_c_cdesc(
  const CFI_cdesc_t* restrict const base,
  const MPI_Aint* restrict const size,
  const MPI_Aint* restrict const disp_unit,
  const MPI_Fint* restrict const info,
  const MPI_Fint* restrict const comm,
  MPI_Fint* restrict const win,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  MPI_Win c_win = MPI_WIN_NULL;
  *ierror = PMPI_Win_create_c(
    q_base,
    *size,
    *disp_unit,
    MPI_Info_fromint(*info),
    MPI_Comm_fromint(*comm),
    &c_win
  );
  *win = MPI_Win_toint(c_win);
}

void mpi_win_detach_cdesc(
  const MPI_Fint* restrict const win,
  const CFI_cdesc_t* restrict const base,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  *ierror = MPI_Win_detach(
    MPI_Win_fromint(*win),
    q_base
  );
}

void pmpi_win_detach_cdesc(
  const MPI_Fint* restrict const win,
  const CFI_cdesc_t* restrict const base,
  MPI_Fint* restrict const ierror
)
{
  void* const q_base = base->base_addr;
  *ierror = PMPI_Win_detach(
    MPI_Win_fromint(*win),
    q_base
  );
}

#else

// ISO C requires something in a translation unit.
typedef int mpif_f08_cdesc_unused;

#endif
