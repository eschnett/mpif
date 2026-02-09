module mpi_functions
  implicit none
  public
  save

  interface

  subroutine MPI_Abi_get_fortran_booleans( &
    logical_size, &
    logical_true, &
    logical_false, &
    is_set, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: logical_size
    !dir$ ignore_tkr(trk) logical_true
    !gcc$ attributes no_arg_check :: logical_true
    integer :: logical_true(*)
    !dir$ ignore_tkr(trk) logical_false
    !gcc$ attributes no_arg_check :: logical_false
    integer :: logical_false(*)
    logical :: is_set
    integer :: ierror
  end subroutine MPI_Abi_get_fortran_booleans

  subroutine MPI_Abi_get_fortran_info( &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: ierror
  end subroutine MPI_Abi_get_fortran_info

  subroutine MPI_Abi_get_info( &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: ierror
  end subroutine MPI_Abi_get_info

  subroutine MPI_Abi_get_version( &
    abi_major, &
    abi_minor, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: abi_major
    integer :: abi_minor
    integer :: ierror
  end subroutine MPI_Abi_get_version

  subroutine MPI_Abi_set_fortran_booleans( &
    logical_size, &
    logical_true, &
    logical_false, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: logical_size
    !dir$ ignore_tkr(trk) logical_true
    !gcc$ attributes no_arg_check :: logical_true
    integer :: logical_true(*)
    !dir$ ignore_tkr(trk) logical_false
    !gcc$ attributes no_arg_check :: logical_false
    integer :: logical_false(*)
    integer :: ierror
  end subroutine MPI_Abi_set_fortran_booleans

  subroutine MPI_Abi_set_fortran_info( &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: ierror
  end subroutine MPI_Abi_set_fortran_info

  subroutine MPI_Abort( &
    comm, &
    errorcode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: errorcode
    integer :: ierror
  end subroutine MPI_Abort

  subroutine MPI_Accumulate( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer :: target_count
    integer :: target_datatype
    integer :: op
    integer :: win
    integer :: ierror
  end subroutine MPI_Accumulate

  subroutine MPI_Accumulate_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND) :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer(MPI_COUNT_KIND) :: target_count
    integer :: target_datatype
    integer :: op
    integer :: win
    integer :: ierror
  end subroutine MPI_Accumulate_c

  subroutine MPI_Add_error_class( &
    errorclass, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errorclass
    integer :: ierror
  end subroutine MPI_Add_error_class

  subroutine MPI_Add_error_code( &
    errorclass, &
    errorcode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errorclass
    integer :: errorcode
    integer :: ierror
  end subroutine MPI_Add_error_code

  subroutine MPI_Add_error_string( &
    errorcode, &
    string, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errorcode
    character*(*) :: string
    integer :: ierror
  end subroutine MPI_Add_error_string

  function MPI_Aint_add( &
    base, &
    disp &
  ) result(result)
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: result
    integer(MPI_ADDRESS_KIND) :: base
    integer(MPI_ADDRESS_KIND) :: disp
  end function MPI_Aint_add

  function MPI_Aint_diff( &
    addr1, &
    addr2 &
  ) result(result)
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: result
    integer(MPI_ADDRESS_KIND) :: addr1
    integer(MPI_ADDRESS_KIND) :: addr2
  end function MPI_Aint_diff

  subroutine MPI_Allgather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Allgather

  subroutine MPI_Allgather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Allgather_c

  subroutine MPI_Allgather_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Allgather_init

  subroutine MPI_Allgather_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Allgather_init_c

  subroutine MPI_Allgatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Allgatherv

  subroutine MPI_Allgatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Allgatherv_c

  subroutine MPI_Allgatherv_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Allgatherv_init

  subroutine MPI_Allgatherv_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Allgatherv_init_c

  subroutine MPI_Alloc_mem( &
    size, &
    info, &
    baseptr, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: size
    integer :: info
    integer(MPI_ADDRESS_KIND) :: baseptr
    integer :: ierror
  end subroutine MPI_Alloc_mem

  subroutine MPI_Allreduce( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Allreduce

  subroutine MPI_Allreduce_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Allreduce_c

  subroutine MPI_Allreduce_init( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Allreduce_init

  subroutine MPI_Allreduce_init_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Allreduce_init_c

  subroutine MPI_Alltoall( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Alltoall

  subroutine MPI_Alltoall_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Alltoall_c

  subroutine MPI_Alltoall_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Alltoall_init

  subroutine MPI_Alltoall_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Alltoall_init_c

  subroutine MPI_Alltoallv( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Alltoallv

  subroutine MPI_Alltoallv_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Alltoallv_c

  subroutine MPI_Alltoallv_init( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Alltoallv_init

  subroutine MPI_Alltoallv_init_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Alltoallv_init_c

  subroutine MPI_Alltoallw( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: ierror
  end subroutine MPI_Alltoallw

  subroutine MPI_Alltoallw_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: ierror
  end subroutine MPI_Alltoallw_c

  subroutine MPI_Alltoallw_init( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Alltoallw_init

  subroutine MPI_Alltoallw_init_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Alltoallw_init_c

  subroutine MPI_Attr_delete( &
    comm, &
    keyval, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: keyval
    integer :: ierror
  end subroutine MPI_Attr_delete

  subroutine MPI_Attr_get( &
    comm, &
    keyval, &
    attribute_val, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: keyval
    integer :: attribute_val
    logical :: flag
    integer :: ierror
  end subroutine MPI_Attr_get

  subroutine MPI_Attr_put( &
    comm, &
    keyval, &
    attribute_val, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: keyval
    integer :: attribute_val
    integer :: ierror
  end subroutine MPI_Attr_put

  subroutine MPI_Barrier( &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: ierror
  end subroutine MPI_Barrier

  subroutine MPI_Barrier_init( &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Barrier_init

  subroutine MPI_Bcast( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer :: count
    integer :: datatype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Bcast

  subroutine MPI_Bcast_c( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Bcast_c

  subroutine MPI_Bcast_init( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer :: count
    integer :: datatype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Bcast_init

  subroutine MPI_Bcast_init_c( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Bcast_init_c

  subroutine MPI_Bsend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: ierror
  end subroutine MPI_Bsend

  subroutine MPI_Bsend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: ierror
  end subroutine MPI_Bsend_c

  subroutine MPI_Bsend_init( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Bsend_init

  subroutine MPI_Bsend_init_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Bsend_init_c

  subroutine MPI_Buffer_attach( &
    buffer, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer :: size
    integer :: ierror
  end subroutine MPI_Buffer_attach

  subroutine MPI_Buffer_attach_c( &
    buffer, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Buffer_attach_c

  subroutine MPI_Buffer_detach( &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: buffer_addr
    integer :: size
    integer :: ierror
  end subroutine MPI_Buffer_detach

  subroutine MPI_Buffer_detach_c( &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: buffer_addr
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Buffer_detach_c

  subroutine MPI_Buffer_flush( &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: ierror
  end subroutine MPI_Buffer_flush

  subroutine MPI_Buffer_iflush( &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    integer :: ierror
  end subroutine MPI_Buffer_iflush

  subroutine MPI_Cancel( &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    integer :: ierror
  end subroutine MPI_Cancel

  subroutine MPI_Cart_coords( &
    comm, &
    rank, &
    maxdims, &
    coords, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: rank
    integer :: maxdims
    integer :: coords(maxdims)
    integer :: ierror
  end subroutine MPI_Cart_coords

  subroutine MPI_Cart_create( &
    comm_old, &
    ndims, &
    dims, &
    periods, &
    reorder, &
    comm_cart, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm_old
    integer :: ndims
    integer :: dims(ndims)
    logical :: periods(*)
    logical :: reorder
    integer :: comm_cart
    integer :: ierror
  end subroutine MPI_Cart_create

  subroutine MPI_Cart_get( &
    comm, &
    maxdims, &
    dims, &
    periods, &
    coords, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: maxdims
    integer :: dims(maxdims)
    logical :: periods(*)
    integer :: coords(maxdims)
    integer :: ierror
  end subroutine MPI_Cart_get

  subroutine MPI_Cart_map( &
    comm, &
    ndims, &
    dims, &
    periods, &
    newrank, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: ndims
    integer :: dims(ndims)
    logical :: periods(*)
    integer :: newrank
    integer :: ierror
  end subroutine MPI_Cart_map

  subroutine MPI_Cart_rank( &
    comm, &
    coords, &
    rank, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: coords(*)
    integer :: rank
    integer :: ierror
  end subroutine MPI_Cart_rank

  subroutine MPI_Cart_shift( &
    comm, &
    direction, &
    disp, &
    rank_source, &
    rank_dest, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: direction
    integer :: disp
    integer :: rank_source
    integer :: rank_dest
    integer :: ierror
  end subroutine MPI_Cart_shift

  subroutine MPI_Cart_sub( &
    comm, &
    remain_dims, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    logical :: remain_dims(*)
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Cart_sub

  subroutine MPI_Cartdim_get( &
    comm, &
    ndims, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: ndims
    integer :: ierror
  end subroutine MPI_Cartdim_get

  subroutine MPI_Close_port( &
    port_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: port_name
    integer :: ierror
  end subroutine MPI_Close_port

  subroutine MPI_Comm_accept( &
    port_name, &
    info, &
    root, &
    comm, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: port_name
    integer :: info
    integer :: root
    integer :: comm
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_accept

  subroutine MPI_Comm_attach_buffer( &
    comm, &
    buffer, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer :: size
    integer :: ierror
  end subroutine MPI_Comm_attach_buffer

  subroutine MPI_Comm_attach_buffer_c( &
    comm, &
    buffer, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Comm_attach_buffer_c

  subroutine MPI_Comm_call_errhandler( &
    comm, &
    errorcode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: errorcode
    integer :: ierror
  end subroutine MPI_Comm_call_errhandler

  subroutine MPI_Comm_compare( &
    comm1, &
    comm2, &
    result, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm1
    integer :: comm2
    integer :: result
    integer :: ierror
  end subroutine MPI_Comm_compare

  subroutine MPI_Comm_connect( &
    port_name, &
    info, &
    root, &
    comm, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: port_name
    integer :: info
    integer :: root
    integer :: comm
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_connect

  subroutine MPI_Comm_create( &
    comm, &
    group, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: group
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_create

  subroutine MPI_Comm_create_errhandler( &
    comm_errhandler_fn, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: comm_errhandler_fn
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Comm_create_errhandler

  subroutine MPI_Comm_create_from_group( &
    group, &
    stringtag, &
    info, &
    errhandler, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    character*(*) :: stringtag
    integer :: info
    integer :: errhandler
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_create_from_group

  subroutine MPI_Comm_create_group( &
    comm, &
    group, &
    tag, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: group
    integer :: tag
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_create_group

  subroutine MPI_Comm_create_keyval( &
    comm_copy_attr_fn, &
    comm_delete_attr_fn, &
    comm_keyval, &
    extra_state, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: comm_copy_attr_fn
    external :: comm_delete_attr_fn
    integer :: comm_keyval
    integer :: extra_state
    integer :: ierror
  end subroutine MPI_Comm_create_keyval

  subroutine MPI_Comm_delete_attr( &
    comm, &
    comm_keyval, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: comm_keyval
    integer :: ierror
  end subroutine MPI_Comm_delete_attr

  subroutine MPI_Comm_detach_buffer( &
    comm, &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer(MPI_ADDRESS_KIND) :: buffer_addr
    integer :: size
    integer :: ierror
  end subroutine MPI_Comm_detach_buffer

  subroutine MPI_Comm_detach_buffer_c( &
    comm, &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer(MPI_ADDRESS_KIND) :: buffer_addr
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Comm_detach_buffer_c

  subroutine MPI_Comm_disconnect( &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: ierror
  end subroutine MPI_Comm_disconnect

  subroutine MPI_Comm_dup( &
    comm, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_dup

  subroutine MPI_Comm_dup_with_info( &
    comm, &
    info, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: info
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_dup_with_info

  subroutine MPI_Comm_flush_buffer( &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: ierror
  end subroutine MPI_Comm_flush_buffer

  subroutine MPI_Comm_free( &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: ierror
  end subroutine MPI_Comm_free

  subroutine MPI_Comm_free_keyval( &
    comm_keyval, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm_keyval
    integer :: ierror
  end subroutine MPI_Comm_free_keyval

  subroutine MPI_Comm_get_attr( &
    comm, &
    comm_keyval, &
    attribute_val, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: comm_keyval
    integer :: attribute_val
    logical :: flag
    integer :: ierror
  end subroutine MPI_Comm_get_attr

  subroutine MPI_Comm_get_errhandler( &
    comm, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Comm_get_errhandler

  subroutine MPI_Comm_get_info( &
    comm, &
    info_used, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: info_used
    integer :: ierror
  end subroutine MPI_Comm_get_info

  subroutine MPI_Comm_get_name( &
    comm, &
    comm_name, &
    resultlen, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    character*(MPI_MAX_OBJECT_NAME) :: comm_name
    integer :: resultlen
    integer :: ierror
  end subroutine MPI_Comm_get_name

  subroutine MPI_Comm_get_parent( &
    parent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: parent
    integer :: ierror
  end subroutine MPI_Comm_get_parent

  subroutine MPI_Comm_group( &
    comm, &
    group, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: group
    integer :: ierror
  end subroutine MPI_Comm_group

  subroutine MPI_Comm_idup( &
    comm, &
    newcomm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: newcomm
    integer :: request
    integer :: ierror
  end subroutine MPI_Comm_idup

  subroutine MPI_Comm_idup_with_info( &
    comm, &
    info, &
    newcomm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: info
    integer :: newcomm
    integer :: request
    integer :: ierror
  end subroutine MPI_Comm_idup_with_info

  subroutine MPI_Comm_iflush_buffer( &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Comm_iflush_buffer

  subroutine MPI_Comm_join( &
    fd, &
    intercomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fd
    integer :: intercomm
    integer :: ierror
  end subroutine MPI_Comm_join

  subroutine MPI_Comm_rank( &
    comm, &
    rank, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: rank
    integer :: ierror
  end subroutine MPI_Comm_rank

  subroutine MPI_Comm_remote_group( &
    comm, &
    group, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: group
    integer :: ierror
  end subroutine MPI_Comm_remote_group

  subroutine MPI_Comm_remote_size( &
    comm, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: size
    integer :: ierror
  end subroutine MPI_Comm_remote_size

  subroutine MPI_Comm_set_attr( &
    comm, &
    comm_keyval, &
    attribute_val, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: comm_keyval
    integer :: attribute_val
    integer :: ierror
  end subroutine MPI_Comm_set_attr

  subroutine MPI_Comm_set_errhandler( &
    comm, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Comm_set_errhandler

  subroutine MPI_Comm_set_info( &
    comm, &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: info
    integer :: ierror
  end subroutine MPI_Comm_set_info

  subroutine MPI_Comm_set_name( &
    comm, &
    comm_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    character*(*) :: comm_name
    integer :: ierror
  end subroutine MPI_Comm_set_name

  subroutine MPI_Comm_size( &
    comm, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: size
    integer :: ierror
  end subroutine MPI_Comm_size

  subroutine MPI_Comm_spawn( &
    command, &
    argv, &
    maxprocs, &
    info, &
    root, &
    comm, &
    intercomm, &
    array_of_errcodes, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: command
    character*(*) :: argv(*)
    integer :: maxprocs
    integer :: info
    integer :: root
    integer :: comm
    integer :: intercomm
    integer :: array_of_errcodes(*)
    integer :: ierror
  end subroutine MPI_Comm_spawn

  subroutine MPI_Comm_spawn_multiple( &
    count, &
    array_of_commands, &
    array_of_argv, &
    array_of_maxprocs, &
    array_of_info, &
    root, &
    comm, &
    intercomm, &
    array_of_errcodes, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    character*(*) :: array_of_commands(*)
    character*(*) :: array_of_argv(count, *)
    integer :: array_of_maxprocs(count)
    integer :: array_of_info(*)
    integer :: root
    integer :: comm
    integer :: intercomm
    integer :: array_of_errcodes(*)
    integer :: ierror
  end subroutine MPI_Comm_spawn_multiple

  subroutine MPI_Comm_split( &
    comm, &
    color, &
    key, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: color
    integer :: key
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_split

  subroutine MPI_Comm_split_type( &
    comm, &
    split_type, &
    key, &
    info, &
    newcomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: split_type
    integer :: key
    integer :: info
    integer :: newcomm
    integer :: ierror
  end subroutine MPI_Comm_split_type

  subroutine MPI_Comm_test_inter( &
    comm, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    logical :: flag
    integer :: ierror
  end subroutine MPI_Comm_test_inter

  subroutine MPI_Compare_and_swap( &
    origin_addr, &
    compare_addr, &
    result_addr, &
    datatype, &
    target_rank, &
    target_disp, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    !dir$ ignore_tkr(trk) compare_addr
    !gcc$ attributes no_arg_check :: compare_addr
    integer :: compare_addr(*)
    !dir$ ignore_tkr(trk) result_addr
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer :: datatype
    integer :: target_rank
    integer :: target_disp
    integer :: win
    integer :: ierror
  end subroutine MPI_Compare_and_swap

  subroutine MPI_Dims_create( &
    nnodes, &
    ndims, &
    dims, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: nnodes
    integer :: ndims
    integer :: dims(ndims)
    integer :: ierror
  end subroutine MPI_Dims_create

  subroutine MPI_Dist_graph_create( &
    comm_old, &
    n, &
    sources, &
    degrees, &
    destinations, &
    weights, &
    info, &
    reorder, &
    comm_dist_graph, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm_old
    integer :: n
    integer :: sources(n)
    integer :: degrees(n)
    integer :: destinations(*)
    integer :: weights(*)
    integer :: info
    logical :: reorder
    integer :: comm_dist_graph
    integer :: ierror
  end subroutine MPI_Dist_graph_create

  subroutine MPI_Dist_graph_create_adjacent( &
    comm_old, &
    indegree, &
    sources, &
    sourceweights, &
    outdegree, &
    destinations, &
    destweights, &
    info, &
    reorder, &
    comm_dist_graph, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm_old
    integer :: indegree
    integer :: sources(indegree)
    integer :: sourceweights(*)
    integer :: outdegree
    integer :: destinations(outdegree)
    integer :: destweights(*)
    integer :: info
    logical :: reorder
    integer :: comm_dist_graph
    integer :: ierror
  end subroutine MPI_Dist_graph_create_adjacent

  subroutine MPI_Dist_graph_neighbors( &
    comm, &
    maxindegree, &
    sources, &
    sourceweights, &
    maxoutdegree, &
    destinations, &
    destweights, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: maxindegree
    integer :: sources(maxindegree)
    integer :: sourceweights(*)
    integer :: maxoutdegree
    integer :: destinations(maxoutdegree)
    integer :: destweights(*)
    integer :: ierror
  end subroutine MPI_Dist_graph_neighbors

  subroutine MPI_Dist_graph_neighbors_count( &
    comm, &
    indegree, &
    outdegree, &
    weighted, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: indegree
    integer :: outdegree
    logical :: weighted
    integer :: ierror
  end subroutine MPI_Dist_graph_neighbors_count

  subroutine MPI_Errhandler_free( &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Errhandler_free

  subroutine MPI_Error_class( &
    errorcode, &
    errorclass, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errorcode
    integer :: errorclass
    integer :: ierror
  end subroutine MPI_Error_class

  subroutine MPI_Error_string( &
    errorcode, &
    string, &
    resultlen, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errorcode
    character*(MPI_MAX_ERROR_STRING) :: string
    integer :: resultlen
    integer :: ierror
  end subroutine MPI_Error_string

  subroutine MPI_Exscan( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Exscan

  subroutine MPI_Exscan_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Exscan_c

  subroutine MPI_Exscan_init( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Exscan_init

  subroutine MPI_Exscan_init_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Exscan_init_c

  subroutine MPI_F_sync_reg( &
    buf &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
  end subroutine MPI_F_sync_reg

  subroutine MPI_Fetch_and_op( &
    origin_addr, &
    result_addr, &
    datatype, &
    target_rank, &
    target_disp, &
    op, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    !dir$ ignore_tkr(trk) result_addr
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer :: datatype
    integer :: target_rank
    integer :: target_disp
    integer :: op
    integer :: win
    integer :: ierror
  end subroutine MPI_Fetch_and_op

  subroutine MPI_File_call_errhandler( &
    fh, &
    errorcode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: errorcode
    integer :: ierror
  end subroutine MPI_File_call_errhandler

  subroutine MPI_File_close( &
    fh, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: ierror
  end subroutine MPI_File_close

  subroutine MPI_File_create_errhandler( &
    file_errhandler_fn, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: file_errhandler_fn
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_File_create_errhandler

  subroutine MPI_File_delete( &
    filename, &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: filename
    integer :: info
    integer :: ierror
  end subroutine MPI_File_delete

  subroutine MPI_File_get_amode( &
    fh, &
    amode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: amode
    integer :: ierror
  end subroutine MPI_File_get_amode

  subroutine MPI_File_get_atomicity( &
    fh, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    logical :: flag
    integer :: ierror
  end subroutine MPI_File_get_atomicity

  subroutine MPI_File_get_byte_offset( &
    fh, &
    offset, &
    disp, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    integer(MPI_OFFSET_KIND) :: disp
    integer :: ierror
  end subroutine MPI_File_get_byte_offset

  subroutine MPI_File_get_errhandler( &
    file, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: file
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_File_get_errhandler

  subroutine MPI_File_get_group( &
    fh, &
    group, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: group
    integer :: ierror
  end subroutine MPI_File_get_group

  subroutine MPI_File_get_info( &
    fh, &
    info_used, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: info_used
    integer :: ierror
  end subroutine MPI_File_get_info

  subroutine MPI_File_get_position( &
    fh, &
    offset, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    integer :: ierror
  end subroutine MPI_File_get_position

  subroutine MPI_File_get_position_shared( &
    fh, &
    offset, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    integer :: ierror
  end subroutine MPI_File_get_position_shared

  subroutine MPI_File_get_size( &
    fh, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: size
    integer :: ierror
  end subroutine MPI_File_get_size

  subroutine MPI_File_get_type_extent( &
    fh, &
    datatype, &
    extent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: datatype
    integer(MPI_ADDRESS_KIND) :: extent
    integer :: ierror
  end subroutine MPI_File_get_type_extent

  subroutine MPI_File_get_type_extent_c( &
    fh, &
    datatype, &
    extent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: datatype
    integer(MPI_COUNT_KIND) :: extent
    integer :: ierror
  end subroutine MPI_File_get_type_extent_c

  subroutine MPI_File_get_view( &
    fh, &
    disp, &
    etype, &
    filetype, &
    datarep, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: disp
    integer :: etype
    integer :: filetype
    character*(*) :: datarep
    integer :: ierror
  end subroutine MPI_File_get_view

  subroutine MPI_File_iread( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread

  subroutine MPI_File_iread_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_c

  subroutine MPI_File_iread_all( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_all

  subroutine MPI_File_iread_all_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_all_c

  subroutine MPI_File_iread_at( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_at

  subroutine MPI_File_iread_at_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_at_c

  subroutine MPI_File_iread_at_all( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_at_all

  subroutine MPI_File_iread_at_all_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_at_all_c

  subroutine MPI_File_iread_shared( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_shared

  subroutine MPI_File_iread_shared_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iread_shared_c

  subroutine MPI_File_iwrite( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite

  subroutine MPI_File_iwrite_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_c

  subroutine MPI_File_iwrite_all( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_all

  subroutine MPI_File_iwrite_all_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_all_c

  subroutine MPI_File_iwrite_at( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_at

  subroutine MPI_File_iwrite_at_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_at_c

  subroutine MPI_File_iwrite_at_all( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_at_all

  subroutine MPI_File_iwrite_at_all_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_at_all_c

  subroutine MPI_File_iwrite_shared( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_shared

  subroutine MPI_File_iwrite_shared_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: request
    integer :: ierror
  end subroutine MPI_File_iwrite_shared_c

  subroutine MPI_File_open( &
    comm, &
    filename, &
    amode, &
    info, &
    fh, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    character*(*) :: filename
    integer :: amode
    integer :: info
    integer :: fh
    integer :: ierror
  end subroutine MPI_File_open

  subroutine MPI_File_preallocate( &
    fh, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: size
    integer :: ierror
  end subroutine MPI_File_preallocate

  subroutine MPI_File_read( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read

  subroutine MPI_File_read_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_c

  subroutine MPI_File_read_all( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_all

  subroutine MPI_File_read_all_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_all_c

  subroutine MPI_File_read_all_begin( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_read_all_begin

  subroutine MPI_File_read_all_begin_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_read_all_begin_c

  subroutine MPI_File_read_all_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_all_end

  subroutine MPI_File_read_at( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_at

  subroutine MPI_File_read_at_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_at_c

  subroutine MPI_File_read_at_all( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_at_all

  subroutine MPI_File_read_at_all_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_at_all_c

  subroutine MPI_File_read_at_all_begin( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_read_at_all_begin

  subroutine MPI_File_read_at_all_begin_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_read_at_all_begin_c

  subroutine MPI_File_read_at_all_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_at_all_end

  subroutine MPI_File_read_ordered( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_ordered

  subroutine MPI_File_read_ordered_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_ordered_c

  subroutine MPI_File_read_ordered_begin( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_read_ordered_begin

  subroutine MPI_File_read_ordered_begin_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_read_ordered_begin_c

  subroutine MPI_File_read_ordered_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_ordered_end

  subroutine MPI_File_read_shared( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_shared

  subroutine MPI_File_read_shared_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_read_shared_c

  subroutine MPI_File_seek( &
    fh, &
    offset, &
    whence, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    integer :: whence
    integer :: ierror
  end subroutine MPI_File_seek

  subroutine MPI_File_seek_shared( &
    fh, &
    offset, &
    whence, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    integer :: whence
    integer :: ierror
  end subroutine MPI_File_seek_shared

  subroutine MPI_File_set_atomicity( &
    fh, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    logical :: flag
    integer :: ierror
  end subroutine MPI_File_set_atomicity

  subroutine MPI_File_set_errhandler( &
    file, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: file
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_File_set_errhandler

  subroutine MPI_File_set_info( &
    fh, &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: info
    integer :: ierror
  end subroutine MPI_File_set_info

  subroutine MPI_File_set_size( &
    fh, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: size
    integer :: ierror
  end subroutine MPI_File_set_size

  subroutine MPI_File_set_view( &
    fh, &
    disp, &
    etype, &
    filetype, &
    datarep, &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: disp
    integer :: etype
    integer :: filetype
    character*(*) :: datarep
    integer :: info
    integer :: ierror
  end subroutine MPI_File_set_view

  subroutine MPI_File_sync( &
    fh, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer :: ierror
  end subroutine MPI_File_sync

  subroutine MPI_File_write( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write

  subroutine MPI_File_write_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_c

  subroutine MPI_File_write_all( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_all

  subroutine MPI_File_write_all_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_all_c

  subroutine MPI_File_write_all_begin( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_write_all_begin

  subroutine MPI_File_write_all_begin_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_write_all_begin_c

  subroutine MPI_File_write_all_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_all_end

  subroutine MPI_File_write_at( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_at

  subroutine MPI_File_write_at_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_at_c

  subroutine MPI_File_write_at_all( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_at_all

  subroutine MPI_File_write_at_all_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_at_all_c

  subroutine MPI_File_write_at_all_begin( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_write_at_all_begin

  subroutine MPI_File_write_at_all_begin_c( &
    fh, &
    offset, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    integer(MPI_OFFSET_KIND) :: offset
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_write_at_all_begin_c

  subroutine MPI_File_write_at_all_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_at_all_end

  subroutine MPI_File_write_ordered( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_ordered

  subroutine MPI_File_write_ordered_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_ordered_c

  subroutine MPI_File_write_ordered_begin( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_write_ordered_begin

  subroutine MPI_File_write_ordered_begin_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: ierror
  end subroutine MPI_File_write_ordered_begin_c

  subroutine MPI_File_write_ordered_end( &
    fh, &
    buf, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_ordered_end

  subroutine MPI_File_write_shared( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_shared

  subroutine MPI_File_write_shared_c( &
    fh, &
    buf, &
    count, &
    datatype, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: fh
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_File_write_shared_c

  subroutine MPI_Finalize( &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: ierror
  end subroutine MPI_Finalize

  subroutine MPI_Finalized( &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    logical :: flag
    integer :: ierror
  end subroutine MPI_Finalized

  subroutine MPI_Free_mem( &
    base, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) base
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer :: ierror
  end subroutine MPI_Free_mem

  subroutine MPI_Gather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Gather

  subroutine MPI_Gather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Gather_c

  subroutine MPI_Gather_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Gather_init

  subroutine MPI_Gather_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Gather_init_c

  subroutine MPI_Gatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Gatherv

  subroutine MPI_Gatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Gatherv_c

  subroutine MPI_Gatherv_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Gatherv_init

  subroutine MPI_Gatherv_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Gatherv_init_c

  subroutine MPI_Get( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer :: target_count
    integer :: target_datatype
    integer :: win
    integer :: ierror
  end subroutine MPI_Get

  subroutine MPI_Get_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND) :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer(MPI_COUNT_KIND) :: target_count
    integer :: target_datatype
    integer :: win
    integer :: ierror
  end subroutine MPI_Get_c

  subroutine MPI_Get_accumulate( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    result_addr, &
    result_count, &
    result_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer :: origin_count
    integer :: origin_datatype
    !dir$ ignore_tkr(trk) result_addr
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer :: result_count
    integer :: result_datatype
    integer :: target_rank
    integer :: target_disp
    integer :: target_count
    integer :: target_datatype
    integer :: op
    integer :: win
    integer :: ierror
  end subroutine MPI_Get_accumulate

  subroutine MPI_Get_accumulate_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    result_addr, &
    result_count, &
    result_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND) :: origin_count
    integer :: origin_datatype
    !dir$ ignore_tkr(trk) result_addr
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer(MPI_COUNT_KIND) :: result_count
    integer :: result_datatype
    integer :: target_rank
    integer :: target_disp
    integer(MPI_COUNT_KIND) :: target_count
    integer :: target_datatype
    integer :: op
    integer :: win
    integer :: ierror
  end subroutine MPI_Get_accumulate_c

  subroutine MPI_Get_address( &
    location, &
    address, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) location
    !gcc$ attributes no_arg_check :: location
    integer :: location(*)
    integer(MPI_ADDRESS_KIND) :: address
    integer :: ierror
  end subroutine MPI_Get_address

  subroutine MPI_Get_count( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: datatype
    integer :: count
    integer :: ierror
  end subroutine MPI_Get_count

  subroutine MPI_Get_count_c( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: datatype
    integer(MPI_COUNT_KIND) :: count
    integer :: ierror
  end subroutine MPI_Get_count_c

  subroutine MPI_Get_elements( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: datatype
    integer :: count
    integer :: ierror
  end subroutine MPI_Get_elements

  subroutine MPI_Get_elements_c( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: datatype
    integer(MPI_COUNT_KIND) :: count
    integer :: ierror
  end subroutine MPI_Get_elements_c

  subroutine MPI_Get_elements_x( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: datatype
    integer(MPI_COUNT_KIND) :: count
    integer :: ierror
  end subroutine MPI_Get_elements_x

  subroutine MPI_Get_hw_resource_info( &
    hw_info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: hw_info
    integer :: ierror
  end subroutine MPI_Get_hw_resource_info

  subroutine MPI_Get_library_version( &
    version, &
    resultlen, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(MPI_MAX_LIBRARY_VERSION_STRING) :: version
    integer :: resultlen
    integer :: ierror
  end subroutine MPI_Get_library_version

  subroutine MPI_Get_processor_name( &
    name, &
    resultlen, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(MPI_MAX_PROCESSOR_NAME) :: name
    integer :: resultlen
    integer :: ierror
  end subroutine MPI_Get_processor_name

  subroutine MPI_Get_version( &
    version, &
    subversion, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: version
    integer :: subversion
    integer :: ierror
  end subroutine MPI_Get_version

  subroutine MPI_Graph_create( &
    comm_old, &
    nnodes, &
    index, &
    edges, &
    reorder, &
    comm_graph, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm_old
    integer :: nnodes
    integer :: index(nnodes)
    integer :: edges(*)
    logical :: reorder
    integer :: comm_graph
    integer :: ierror
  end subroutine MPI_Graph_create

  subroutine MPI_Graph_get( &
    comm, &
    maxindex, &
    maxedges, &
    index, &
    edges, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: maxindex
    integer :: maxedges
    integer :: index(maxindex)
    integer :: edges(maxedges)
    integer :: ierror
  end subroutine MPI_Graph_get

  subroutine MPI_Graph_map( &
    comm, &
    nnodes, &
    index, &
    edges, &
    newrank, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: nnodes
    integer :: index(nnodes)
    integer :: edges(*)
    integer :: newrank
    integer :: ierror
  end subroutine MPI_Graph_map

  subroutine MPI_Graph_neighbors( &
    comm, &
    rank, &
    maxneighbors, &
    neighbors, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: rank
    integer :: maxneighbors
    integer :: neighbors(maxneighbors)
    integer :: ierror
  end subroutine MPI_Graph_neighbors

  subroutine MPI_Graph_neighbors_count( &
    comm, &
    rank, &
    nneighbors, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: rank
    integer :: nneighbors
    integer :: ierror
  end subroutine MPI_Graph_neighbors_count

  subroutine MPI_Graphdims_get( &
    comm, &
    nnodes, &
    nedges, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: nnodes
    integer :: nedges
    integer :: ierror
  end subroutine MPI_Graphdims_get

  subroutine MPI_Grequest_complete( &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    integer :: ierror
  end subroutine MPI_Grequest_complete

  subroutine MPI_Grequest_start( &
    query_fn, &
    free_fn, &
    cancel_fn, &
    extra_state, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: query_fn
    external :: free_fn
    external :: cancel_fn
    integer :: extra_state
    integer :: request
    integer :: ierror
  end subroutine MPI_Grequest_start

  subroutine MPI_Group_compare( &
    group1, &
    group2, &
    result, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group1
    integer :: group2
    integer :: result
    integer :: ierror
  end subroutine MPI_Group_compare

  subroutine MPI_Group_difference( &
    group1, &
    group2, &
    newgroup, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group1
    integer :: group2
    integer :: newgroup
    integer :: ierror
  end subroutine MPI_Group_difference

  subroutine MPI_Group_excl( &
    group, &
    n, &
    ranks, &
    newgroup, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: n
    integer :: ranks(n)
    integer :: newgroup
    integer :: ierror
  end subroutine MPI_Group_excl

  subroutine MPI_Group_free( &
    group, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: ierror
  end subroutine MPI_Group_free

  subroutine MPI_Group_from_session_pset( &
    session, &
    pset_name, &
    newgroup, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    character*(*) :: pset_name
    integer :: newgroup
    integer :: ierror
  end subroutine MPI_Group_from_session_pset

  subroutine MPI_Group_incl( &
    group, &
    n, &
    ranks, &
    newgroup, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: n
    integer :: ranks(n)
    integer :: newgroup
    integer :: ierror
  end subroutine MPI_Group_incl

  subroutine MPI_Group_intersection( &
    group1, &
    group2, &
    newgroup, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group1
    integer :: group2
    integer :: newgroup
    integer :: ierror
  end subroutine MPI_Group_intersection

  subroutine MPI_Group_range_excl( &
    group, &
    n, &
    ranges, &
    newgroup, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: n
    integer :: ranges(3, n)
    integer :: newgroup
    integer :: ierror
  end subroutine MPI_Group_range_excl

  subroutine MPI_Group_range_incl( &
    group, &
    n, &
    ranges, &
    newgroup, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: n
    integer :: ranges(3, n)
    integer :: newgroup
    integer :: ierror
  end subroutine MPI_Group_range_incl

  subroutine MPI_Group_rank( &
    group, &
    rank, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: rank
    integer :: ierror
  end subroutine MPI_Group_rank

  subroutine MPI_Group_size( &
    group, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: size
    integer :: ierror
  end subroutine MPI_Group_size

  subroutine MPI_Group_translate_ranks( &
    group1, &
    n, &
    ranks1, &
    group2, &
    ranks2, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group1
    integer :: n
    integer :: ranks1(n)
    integer :: group2
    integer :: ranks2(n)
    integer :: ierror
  end subroutine MPI_Group_translate_ranks

  subroutine MPI_Group_union( &
    group1, &
    group2, &
    newgroup, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group1
    integer :: group2
    integer :: newgroup
    integer :: ierror
  end subroutine MPI_Group_union

  subroutine MPI_Iallgather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iallgather

  subroutine MPI_Iallgather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iallgather_c

  subroutine MPI_Iallgatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iallgatherv

  subroutine MPI_Iallgatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iallgatherv_c

  subroutine MPI_Iallreduce( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iallreduce

  subroutine MPI_Iallreduce_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iallreduce_c

  subroutine MPI_Ialltoall( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ialltoall

  subroutine MPI_Ialltoall_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ialltoall_c

  subroutine MPI_Ialltoallv( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ialltoallv

  subroutine MPI_Ialltoallv_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ialltoallv_c

  subroutine MPI_Ialltoallw( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ialltoallw

  subroutine MPI_Ialltoallw_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ialltoallw_c

  subroutine MPI_Ibarrier( &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ibarrier

  subroutine MPI_Ibcast( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer :: count
    integer :: datatype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ibcast

  subroutine MPI_Ibcast_c( &
    buffer, &
    count, &
    datatype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ibcast_c

  subroutine MPI_Ibsend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ibsend

  subroutine MPI_Ibsend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ibsend_c

  subroutine MPI_Iexscan( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iexscan

  subroutine MPI_Iexscan_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iexscan_c

  subroutine MPI_Igather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Igather

  subroutine MPI_Igather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Igather_c

  subroutine MPI_Igatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Igatherv

  subroutine MPI_Igatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Igatherv_c

  subroutine MPI_Improbe( &
    source, &
    tag, &
    comm, &
    flag, &
    message, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: source
    integer :: tag
    integer :: comm
    logical :: flag
    integer :: message
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Improbe

  subroutine MPI_Imrecv( &
    buf, &
    count, &
    datatype, &
    message, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: message
    integer :: request
    integer :: ierror
  end subroutine MPI_Imrecv

  subroutine MPI_Imrecv_c( &
    buf, &
    count, &
    datatype, &
    message, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: message
    integer :: request
    integer :: ierror
  end subroutine MPI_Imrecv_c

  subroutine MPI_Ineighbor_allgather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_allgather

  subroutine MPI_Ineighbor_allgather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_allgather_c

  subroutine MPI_Ineighbor_allgatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_allgatherv

  subroutine MPI_Ineighbor_allgatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_allgatherv_c

  subroutine MPI_Ineighbor_alltoall( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_alltoall

  subroutine MPI_Ineighbor_alltoall_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_alltoall_c

  subroutine MPI_Ineighbor_alltoallv( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_alltoallv

  subroutine MPI_Ineighbor_alltoallv_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_alltoallv_c

  subroutine MPI_Ineighbor_alltoallw( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_alltoallw

  subroutine MPI_Ineighbor_alltoallw_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ineighbor_alltoallw_c

  subroutine MPI_Info_create( &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: ierror
  end subroutine MPI_Info_create

  subroutine MPI_Info_create_env( &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: ierror
  end subroutine MPI_Info_create_env

  subroutine MPI_Info_delete( &
    info, &
    key, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    character*(*) :: key
    integer :: ierror
  end subroutine MPI_Info_delete

  subroutine MPI_Info_dup( &
    info, &
    newinfo, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: newinfo
    integer :: ierror
  end subroutine MPI_Info_dup

  subroutine MPI_Info_free( &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: ierror
  end subroutine MPI_Info_free

  subroutine MPI_Info_get( &
    info, &
    key, &
    valuelen, &
    value, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    character*(*) :: key
    integer :: valuelen
    character*(valuelen) :: value
    logical :: flag
    integer :: ierror
  end subroutine MPI_Info_get

  subroutine MPI_Info_get_nkeys( &
    info, &
    nkeys, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: nkeys
    integer :: ierror
  end subroutine MPI_Info_get_nkeys

  subroutine MPI_Info_get_nthkey( &
    info, &
    n, &
    key, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: n
    character*(*) :: key
    integer :: ierror
  end subroutine MPI_Info_get_nthkey

  subroutine MPI_Info_get_string( &
    info, &
    key, &
    buflen, &
    value, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    character*(*) :: key
    integer :: buflen
    character*(*) :: value
    logical :: flag
    integer :: ierror
  end subroutine MPI_Info_get_string

  subroutine MPI_Info_get_valuelen( &
    info, &
    key, &
    valuelen, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    character*(*) :: key
    integer :: valuelen
    logical :: flag
    integer :: ierror
  end subroutine MPI_Info_get_valuelen

  subroutine MPI_Info_set( &
    info, &
    key, &
    value, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    character*(*) :: key
    character*(*) :: value
    integer :: ierror
  end subroutine MPI_Info_set

  subroutine MPI_Init( &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: ierror
  end subroutine MPI_Init

  subroutine MPI_Init_thread( &
    required, &
    provided, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: required
    integer :: provided
    integer :: ierror
  end subroutine MPI_Init_thread

  subroutine MPI_Initialized( &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    logical :: flag
    integer :: ierror
  end subroutine MPI_Initialized

  subroutine MPI_Intercomm_create( &
    local_comm, &
    local_leader, &
    peer_comm, &
    remote_leader, &
    tag, &
    newintercomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: local_comm
    integer :: local_leader
    integer :: peer_comm
    integer :: remote_leader
    integer :: tag
    integer :: newintercomm
    integer :: ierror
  end subroutine MPI_Intercomm_create

  subroutine MPI_Intercomm_create_from_groups( &
    local_group, &
    local_leader, &
    remote_group, &
    remote_leader, &
    stringtag, &
    info, &
    errhandler, &
    newintercomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: local_group
    integer :: local_leader
    integer :: remote_group
    integer :: remote_leader
    character*(*) :: stringtag
    integer :: info
    integer :: errhandler
    integer :: newintercomm
    integer :: ierror
  end subroutine MPI_Intercomm_create_from_groups

  subroutine MPI_Intercomm_merge( &
    intercomm, &
    high, &
    newintracomm, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: intercomm
    logical :: high
    integer :: newintracomm
    integer :: ierror
  end subroutine MPI_Intercomm_merge

  subroutine MPI_Iprobe( &
    source, &
    tag, &
    comm, &
    flag, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: source
    integer :: tag
    integer :: comm
    logical :: flag
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Iprobe

  subroutine MPI_Irecv( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: source
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Irecv

  subroutine MPI_Irecv_c( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: source
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Irecv_c

  subroutine MPI_Ireduce( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ireduce

  subroutine MPI_Ireduce_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ireduce_c

  subroutine MPI_Ireduce_scatter( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ireduce_scatter

  subroutine MPI_Ireduce_scatter_c( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ireduce_scatter_c

  subroutine MPI_Ireduce_scatter_block( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ireduce_scatter_block

  subroutine MPI_Ireduce_scatter_block_c( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ireduce_scatter_block_c

  subroutine MPI_Irsend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Irsend

  subroutine MPI_Irsend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Irsend_c

  subroutine MPI_Is_thread_main( &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    logical :: flag
    integer :: ierror
  end subroutine MPI_Is_thread_main

  subroutine MPI_Iscan( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iscan

  subroutine MPI_Iscan_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iscan_c

  subroutine MPI_Iscatter( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iscatter

  subroutine MPI_Iscatter_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iscatter_c

  subroutine MPI_Iscatterv( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: displs(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iscatterv

  subroutine MPI_Iscatterv_c( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Iscatterv_c

  subroutine MPI_Isend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Isend

  subroutine MPI_Isend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Isend_c

  subroutine MPI_Isendrecv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    dest, &
    sendtag, &
    recvbuf, &
    recvcount, &
    recvtype, &
    source, &
    recvtag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    integer :: dest
    integer :: sendtag
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: source
    integer :: recvtag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Isendrecv

  subroutine MPI_Isendrecv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    dest, &
    sendtag, &
    recvbuf, &
    recvcount, &
    recvtype, &
    source, &
    recvtag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    integer :: dest
    integer :: sendtag
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: source
    integer :: recvtag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Isendrecv_c

  subroutine MPI_Isendrecv_replace( &
    buf, &
    count, &
    datatype, &
    dest, &
    sendtag, &
    source, &
    recvtag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: sendtag
    integer :: source
    integer :: recvtag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Isendrecv_replace

  subroutine MPI_Isendrecv_replace_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    sendtag, &
    source, &
    recvtag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: sendtag
    integer :: source
    integer :: recvtag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Isendrecv_replace_c

  subroutine MPI_Issend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Issend

  subroutine MPI_Issend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Issend_c

  subroutine MPI_Keyval_create( &
    copy_fn, &
    delete_fn, &
    keyval, &
    extra_state, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: copy_fn
    external :: delete_fn
    integer :: keyval
    integer :: extra_state
    integer :: ierror
  end subroutine MPI_Keyval_create

  subroutine MPI_Keyval_free( &
    keyval, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: keyval
    integer :: ierror
  end subroutine MPI_Keyval_free

  subroutine MPI_Lookup_name( &
    service_name, &
    info, &
    port_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: service_name
    integer :: info
    character*(MPI_MAX_PORT_NAME) :: port_name
    integer :: ierror
  end subroutine MPI_Lookup_name

  subroutine MPI_Mprobe( &
    source, &
    tag, &
    comm, &
    message, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: source
    integer :: tag
    integer :: comm
    integer :: message
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Mprobe

  subroutine MPI_Mrecv( &
    buf, &
    count, &
    datatype, &
    message, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: message
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Mrecv

  subroutine MPI_Mrecv_c( &
    buf, &
    count, &
    datatype, &
    message, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: message
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Mrecv_c

  subroutine MPI_Neighbor_allgather( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_allgather

  subroutine MPI_Neighbor_allgather_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_allgather_c

  subroutine MPI_Neighbor_allgather_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_allgather_init

  subroutine MPI_Neighbor_allgather_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_allgather_init_c

  subroutine MPI_Neighbor_allgatherv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_allgatherv

  subroutine MPI_Neighbor_allgatherv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_allgatherv_c

  subroutine MPI_Neighbor_allgatherv_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_allgatherv_init

  subroutine MPI_Neighbor_allgatherv_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    displs, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_allgatherv_init_c

  subroutine MPI_Neighbor_alltoall( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_alltoall

  subroutine MPI_Neighbor_alltoall_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_alltoall_c

  subroutine MPI_Neighbor_alltoall_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_alltoall_init

  subroutine MPI_Neighbor_alltoall_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_alltoall_init_c

  subroutine MPI_Neighbor_alltoallv( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_alltoallv

  subroutine MPI_Neighbor_alltoallv_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_alltoallv_c

  subroutine MPI_Neighbor_alltoallv_init( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_alltoallv_init

  subroutine MPI_Neighbor_alltoallv_init_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtype, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtype, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtype
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_alltoallv_init_c

  subroutine MPI_Neighbor_alltoallw( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_alltoallw

  subroutine MPI_Neighbor_alltoallw_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: ierror
  end subroutine MPI_Neighbor_alltoallw_c

  subroutine MPI_Neighbor_alltoallw_init( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_alltoallw_init

  subroutine MPI_Neighbor_alltoallw_init_c( &
    sendbuf, &
    sendcounts, &
    sdispls, &
    sendtypes, &
    recvbuf, &
    recvcounts, &
    rdispls, &
    recvtypes, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: sdispls(*)
    integer :: sendtypes(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer(MPI_ADDRESS_KIND) :: rdispls(*)
    integer :: recvtypes(*)
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Neighbor_alltoallw_init_c

  subroutine MPI_Op_commutative( &
    op, &
    commute, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: op
    logical :: commute
    integer :: ierror
  end subroutine MPI_Op_commutative

  subroutine MPI_Op_create( &
    user_fn, &
    commute, &
    op, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: user_fn
    logical :: commute
    integer :: op
    integer :: ierror
  end subroutine MPI_Op_create

  subroutine MPI_Op_create_c( &
    user_fn, &
    commute, &
    op, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: user_fn
    logical :: commute
    integer :: op
    integer :: ierror
  end subroutine MPI_Op_create_c

  subroutine MPI_Op_free( &
    op, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: op
    integer :: ierror
  end subroutine MPI_Op_free

  subroutine MPI_Open_port( &
    info, &
    port_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    character*(MPI_MAX_PORT_NAME) :: port_name
    integer :: ierror
  end subroutine MPI_Open_port

  subroutine MPI_Pack( &
    inbuf, &
    incount, &
    datatype, &
    outbuf, &
    outsize, &
    position, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer :: incount
    integer :: datatype
    !dir$ ignore_tkr(trk) outbuf
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer :: outsize
    integer :: position
    integer :: comm
    integer :: ierror
  end subroutine MPI_Pack

  subroutine MPI_Pack_c( &
    inbuf, &
    incount, &
    datatype, &
    outbuf, &
    outsize, &
    position, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_COUNT_KIND) :: incount
    integer :: datatype
    !dir$ ignore_tkr(trk) outbuf
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_COUNT_KIND) :: outsize
    integer(MPI_COUNT_KIND) :: position
    integer :: comm
    integer :: ierror
  end subroutine MPI_Pack_c

  subroutine MPI_Pack_external( &
    datarep, &
    inbuf, &
    incount, &
    datatype, &
    outbuf, &
    outsize, &
    position, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: datarep
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer :: incount
    integer :: datatype
    !dir$ ignore_tkr(trk) outbuf
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_ADDRESS_KIND) :: outsize
    integer(MPI_ADDRESS_KIND) :: position
    integer :: ierror
  end subroutine MPI_Pack_external

  subroutine MPI_Pack_external_c( &
    datarep, &
    inbuf, &
    incount, &
    datatype, &
    outbuf, &
    outsize, &
    position, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: datarep
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_COUNT_KIND) :: incount
    integer :: datatype
    !dir$ ignore_tkr(trk) outbuf
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_COUNT_KIND) :: outsize
    integer(MPI_COUNT_KIND) :: position
    integer :: ierror
  end subroutine MPI_Pack_external_c

  subroutine MPI_Pack_external_size( &
    datarep, &
    incount, &
    datatype, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: datarep
    integer :: incount
    integer :: datatype
    integer(MPI_ADDRESS_KIND) :: size
    integer :: ierror
  end subroutine MPI_Pack_external_size

  subroutine MPI_Pack_external_size_c( &
    datarep, &
    incount, &
    datatype, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: datarep
    integer(MPI_COUNT_KIND) :: incount
    integer :: datatype
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Pack_external_size_c

  subroutine MPI_Pack_size( &
    incount, &
    datatype, &
    comm, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: incount
    integer :: datatype
    integer :: comm
    integer :: size
    integer :: ierror
  end subroutine MPI_Pack_size

  subroutine MPI_Pack_size_c( &
    incount, &
    datatype, &
    comm, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: incount
    integer :: datatype
    integer :: comm
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Pack_size_c

  subroutine MPI_Parrived( &
    request, &
    partition, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    integer :: partition
    logical :: flag
    integer :: ierror
  end subroutine MPI_Parrived

  subroutine MPI_Pready( &
    partition, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: partition
    integer :: request
    integer :: ierror
  end subroutine MPI_Pready

  subroutine MPI_Pready_list( &
    length, &
    array_of_partitions, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: length
    integer :: array_of_partitions(length)
    integer :: request
    integer :: ierror
  end subroutine MPI_Pready_list

  subroutine MPI_Pready_range( &
    partition_low, &
    partition_high, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: partition_low
    integer :: partition_high
    integer :: request
    integer :: ierror
  end subroutine MPI_Pready_range

  subroutine MPI_Precv_init( &
    buf, &
    partitions, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: partitions
    integer :: count
    integer :: datatype
    integer :: source
    integer :: tag
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Precv_init

  subroutine MPI_Probe( &
    source, &
    tag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: source
    integer :: tag
    integer :: comm
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Probe

  subroutine MPI_Psend_init( &
    buf, &
    partitions, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: partitions
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Psend_init

  subroutine MPI_Publish_name( &
    service_name, &
    info, &
    port_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: service_name
    integer :: info
    character*(*) :: port_name
    integer :: ierror
  end subroutine MPI_Publish_name

  subroutine MPI_Put( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer :: target_count
    integer :: target_datatype
    integer :: win
    integer :: ierror
  end subroutine MPI_Put

  subroutine MPI_Put_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND) :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer(MPI_COUNT_KIND) :: target_count
    integer :: target_datatype
    integer :: win
    integer :: ierror
  end subroutine MPI_Put_c

  subroutine MPI_Query_thread( &
    provided, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: provided
    integer :: ierror
  end subroutine MPI_Query_thread

  subroutine MPI_Raccumulate( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer :: target_count
    integer :: target_datatype
    integer :: op
    integer :: win
    integer :: request
    integer :: ierror
  end subroutine MPI_Raccumulate

  subroutine MPI_Raccumulate_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND) :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer(MPI_COUNT_KIND) :: target_count
    integer :: target_datatype
    integer :: op
    integer :: win
    integer :: request
    integer :: ierror
  end subroutine MPI_Raccumulate_c

  subroutine MPI_Recv( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: source
    integer :: tag
    integer :: comm
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Recv

  subroutine MPI_Recv_c( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: source
    integer :: tag
    integer :: comm
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Recv_c

  subroutine MPI_Recv_init( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: source
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Recv_init

  subroutine MPI_Recv_init_c( &
    buf, &
    count, &
    datatype, &
    source, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: source
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Recv_init_c

  subroutine MPI_Reduce( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Reduce

  subroutine MPI_Reduce_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Reduce_c

  subroutine MPI_Reduce_init( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Reduce_init

  subroutine MPI_Reduce_init_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Reduce_init_c

  subroutine MPI_Reduce_local( &
    inbuf, &
    inoutbuf, &
    count, &
    datatype, &
    op, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    !dir$ ignore_tkr(trk) inoutbuf
    !gcc$ attributes no_arg_check :: inoutbuf
    integer :: inoutbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: ierror
  end subroutine MPI_Reduce_local

  subroutine MPI_Reduce_local_c( &
    inbuf, &
    inoutbuf, &
    count, &
    datatype, &
    op, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    !dir$ ignore_tkr(trk) inoutbuf
    !gcc$ attributes no_arg_check :: inoutbuf
    integer :: inoutbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: ierror
  end subroutine MPI_Reduce_local_c

  subroutine MPI_Reduce_scatter( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Reduce_scatter

  subroutine MPI_Reduce_scatter_c( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Reduce_scatter_c

  subroutine MPI_Reduce_scatter_block( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Reduce_scatter_block

  subroutine MPI_Reduce_scatter_block_c( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Reduce_scatter_block_c

  subroutine MPI_Reduce_scatter_block_init( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Reduce_scatter_block_init

  subroutine MPI_Reduce_scatter_block_init_c( &
    sendbuf, &
    recvbuf, &
    recvcount, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Reduce_scatter_block_init_c

  subroutine MPI_Reduce_scatter_init( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcounts(*)
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Reduce_scatter_init

  subroutine MPI_Reduce_scatter_init_c( &
    sendbuf, &
    recvbuf, &
    recvcounts, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcounts(*)
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Reduce_scatter_init_c

  subroutine MPI_Register_datarep( &
    datarep, &
    read_conversion_fn, &
    write_conversion_fn, &
    dtype_file_extent_fn, &
    extra_state, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: datarep
    external :: read_conversion_fn
    external :: write_conversion_fn
    external :: dtype_file_extent_fn
    integer :: extra_state
    integer :: ierror
  end subroutine MPI_Register_datarep

  subroutine MPI_Register_datarep_c( &
    datarep, &
    read_conversion_fn, &
    write_conversion_fn, &
    dtype_file_extent_fn, &
    extra_state, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: datarep
    external :: read_conversion_fn
    external :: write_conversion_fn
    external :: dtype_file_extent_fn
    integer :: extra_state
    integer :: ierror
  end subroutine MPI_Register_datarep_c

  subroutine MPI_Remove_error_class( &
    errorclass, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errorclass
    integer :: ierror
  end subroutine MPI_Remove_error_class

  subroutine MPI_Remove_error_code( &
    errorcode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errorcode
    integer :: ierror
  end subroutine MPI_Remove_error_code

  subroutine MPI_Remove_error_string( &
    errorcode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: errorcode
    integer :: ierror
  end subroutine MPI_Remove_error_string

  subroutine MPI_Request_free( &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    integer :: ierror
  end subroutine MPI_Request_free

  subroutine MPI_Request_get_status( &
    request, &
    flag, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    logical :: flag
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Request_get_status

  subroutine MPI_Request_get_status_all( &
    count, &
    array_of_requests, &
    flag, &
    array_of_statuses, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_requests(*)
    logical :: flag
    integer :: array_of_statuses(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Request_get_status_all

  subroutine MPI_Request_get_status_any( &
    count, &
    array_of_requests, &
    index, &
    flag, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_requests(*)
    integer :: index
    logical :: flag
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Request_get_status_any

  subroutine MPI_Request_get_status_some( &
    incount, &
    array_of_requests, &
    outcount, &
    array_of_indices, &
    array_of_statuses, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: incount
    integer :: array_of_requests(*)
    integer :: outcount
    integer :: array_of_indices(*)
    integer :: array_of_statuses(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Request_get_status_some

  subroutine MPI_Rget( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer :: target_count
    integer :: target_datatype
    integer :: win
    integer :: request
    integer :: ierror
  end subroutine MPI_Rget

  subroutine MPI_Rget_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND) :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer(MPI_COUNT_KIND) :: target_count
    integer :: target_datatype
    integer :: win
    integer :: request
    integer :: ierror
  end subroutine MPI_Rget_c

  subroutine MPI_Rget_accumulate( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    result_addr, &
    result_count, &
    result_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer :: origin_count
    integer :: origin_datatype
    !dir$ ignore_tkr(trk) result_addr
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer :: result_count
    integer :: result_datatype
    integer :: target_rank
    integer :: target_disp
    integer :: target_count
    integer :: target_datatype
    integer :: op
    integer :: win
    integer :: request
    integer :: ierror
  end subroutine MPI_Rget_accumulate

  subroutine MPI_Rget_accumulate_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    result_addr, &
    result_count, &
    result_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    op, &
    win, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND) :: origin_count
    integer :: origin_datatype
    !dir$ ignore_tkr(trk) result_addr
    !gcc$ attributes no_arg_check :: result_addr
    integer :: result_addr(*)
    integer(MPI_COUNT_KIND) :: result_count
    integer :: result_datatype
    integer :: target_rank
    integer :: target_disp
    integer(MPI_COUNT_KIND) :: target_count
    integer :: target_datatype
    integer :: op
    integer :: win
    integer :: request
    integer :: ierror
  end subroutine MPI_Rget_accumulate_c

  subroutine MPI_Rput( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer :: target_count
    integer :: target_datatype
    integer :: win
    integer :: request
    integer :: ierror
  end subroutine MPI_Rput

  subroutine MPI_Rput_c( &
    origin_addr, &
    origin_count, &
    origin_datatype, &
    target_rank, &
    target_disp, &
    target_count, &
    target_datatype, &
    win, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) origin_addr
    !gcc$ attributes no_arg_check :: origin_addr
    integer :: origin_addr(*)
    integer(MPI_COUNT_KIND) :: origin_count
    integer :: origin_datatype
    integer :: target_rank
    integer :: target_disp
    integer(MPI_COUNT_KIND) :: target_count
    integer :: target_datatype
    integer :: win
    integer :: request
    integer :: ierror
  end subroutine MPI_Rput_c

  subroutine MPI_Rsend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: ierror
  end subroutine MPI_Rsend

  subroutine MPI_Rsend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: ierror
  end subroutine MPI_Rsend_c

  subroutine MPI_Rsend_init( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Rsend_init

  subroutine MPI_Rsend_init_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Rsend_init_c

  subroutine MPI_Scan( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Scan

  subroutine MPI_Scan_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: ierror
  end subroutine MPI_Scan_c

  subroutine MPI_Scan_init( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Scan_init

  subroutine MPI_Scan_init_c( &
    sendbuf, &
    recvbuf, &
    count, &
    datatype, &
    op, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: op
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Scan_init_c

  subroutine MPI_Scatter( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Scatter

  subroutine MPI_Scatter_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Scatter_c

  subroutine MPI_Scatter_init( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Scatter_init

  subroutine MPI_Scatter_init_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Scatter_init_c

  subroutine MPI_Scatterv( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: displs(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Scatterv

  subroutine MPI_Scatterv_c( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: ierror
  end subroutine MPI_Scatterv_c

  subroutine MPI_Scatterv_init( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcounts(*)
    integer :: displs(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Scatterv_init

  subroutine MPI_Scatterv_init_c( &
    sendbuf, &
    sendcounts, &
    displs, &
    sendtype, &
    recvbuf, &
    recvcount, &
    recvtype, &
    root, &
    comm, &
    info, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcounts(*)
    integer(MPI_ADDRESS_KIND) :: displs(*)
    integer :: sendtype
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: root
    integer :: comm
    integer :: info
    integer :: request
    integer :: ierror
  end subroutine MPI_Scatterv_init_c

  subroutine MPI_Send( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: ierror
  end subroutine MPI_Send

  subroutine MPI_Send_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: ierror
  end subroutine MPI_Send_c

  subroutine MPI_Send_init( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Send_init

  subroutine MPI_Send_init_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Send_init_c

  subroutine MPI_Sendrecv( &
    sendbuf, &
    sendcount, &
    sendtype, &
    dest, &
    sendtag, &
    recvbuf, &
    recvcount, &
    recvtype, &
    source, &
    recvtag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer :: sendcount
    integer :: sendtype
    integer :: dest
    integer :: sendtag
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer :: recvcount
    integer :: recvtype
    integer :: source
    integer :: recvtag
    integer :: comm
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Sendrecv

  subroutine MPI_Sendrecv_c( &
    sendbuf, &
    sendcount, &
    sendtype, &
    dest, &
    sendtag, &
    recvbuf, &
    recvcount, &
    recvtype, &
    source, &
    recvtag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) sendbuf
    !gcc$ attributes no_arg_check :: sendbuf
    integer :: sendbuf(*)
    integer(MPI_COUNT_KIND) :: sendcount
    integer :: sendtype
    integer :: dest
    integer :: sendtag
    !dir$ ignore_tkr(trk) recvbuf
    !gcc$ attributes no_arg_check :: recvbuf
    integer :: recvbuf(*)
    integer(MPI_COUNT_KIND) :: recvcount
    integer :: recvtype
    integer :: source
    integer :: recvtag
    integer :: comm
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Sendrecv_c

  subroutine MPI_Sendrecv_replace( &
    buf, &
    count, &
    datatype, &
    dest, &
    sendtag, &
    source, &
    recvtag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: sendtag
    integer :: source
    integer :: recvtag
    integer :: comm
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Sendrecv_replace

  subroutine MPI_Sendrecv_replace_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    sendtag, &
    source, &
    recvtag, &
    comm, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: sendtag
    integer :: source
    integer :: recvtag
    integer :: comm
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Sendrecv_replace_c

  subroutine MPI_Session_attach_buffer( &
    session, &
    buffer, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer :: size
    integer :: ierror
  end subroutine MPI_Session_attach_buffer

  subroutine MPI_Session_attach_buffer_c( &
    session, &
    buffer, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    !dir$ ignore_tkr(trk) buffer
    !gcc$ attributes no_arg_check :: buffer
    integer :: buffer(*)
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Session_attach_buffer_c

  subroutine MPI_Session_call_errhandler( &
    session, &
    errorcode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: errorcode
    integer :: ierror
  end subroutine MPI_Session_call_errhandler

  subroutine MPI_Session_create_errhandler( &
    session_errhandler_fn, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: session_errhandler_fn
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Session_create_errhandler

  subroutine MPI_Session_detach_buffer( &
    session, &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer(MPI_ADDRESS_KIND) :: buffer_addr
    integer :: size
    integer :: ierror
  end subroutine MPI_Session_detach_buffer

  subroutine MPI_Session_detach_buffer_c( &
    session, &
    buffer_addr, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer(MPI_ADDRESS_KIND) :: buffer_addr
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Session_detach_buffer_c

  subroutine MPI_Session_finalize( &
    session, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: ierror
  end subroutine MPI_Session_finalize

  subroutine MPI_Session_flush_buffer( &
    session, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: ierror
  end subroutine MPI_Session_flush_buffer

  subroutine MPI_Session_get_errhandler( &
    session, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Session_get_errhandler

  subroutine MPI_Session_get_info( &
    session, &
    info_used, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: info_used
    integer :: ierror
  end subroutine MPI_Session_get_info

  subroutine MPI_Session_get_nth_pset( &
    session, &
    info, &
    n, &
    pset_len, &
    pset_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: info
    integer :: n
    integer :: pset_len
    character*(*) :: pset_name
    integer :: ierror
  end subroutine MPI_Session_get_nth_pset

  subroutine MPI_Session_get_num_psets( &
    session, &
    info, &
    npset_names, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: info
    integer :: npset_names
    integer :: ierror
  end subroutine MPI_Session_get_num_psets

  subroutine MPI_Session_get_pset_info( &
    session, &
    pset_name, &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    character*(*) :: pset_name
    integer :: info
    integer :: ierror
  end subroutine MPI_Session_get_pset_info

  subroutine MPI_Session_iflush_buffer( &
    session, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: request
    integer :: ierror
  end subroutine MPI_Session_iflush_buffer

  subroutine MPI_Session_init( &
    info, &
    errhandler, &
    session, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: errhandler
    integer :: session
    integer :: ierror
  end subroutine MPI_Session_init

  subroutine MPI_Session_set_errhandler( &
    session, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: session
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Session_set_errhandler

  subroutine MPI_Ssend( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: ierror
  end subroutine MPI_Ssend

  subroutine MPI_Ssend_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: ierror
  end subroutine MPI_Ssend_c

  subroutine MPI_Ssend_init( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ssend_init

  subroutine MPI_Ssend_init_c( &
    buf, &
    count, &
    datatype, &
    dest, &
    tag, &
    comm, &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) buf
    !gcc$ attributes no_arg_check :: buf
    integer :: buf(*)
    integer(MPI_COUNT_KIND) :: count
    integer :: datatype
    integer :: dest
    integer :: tag
    integer :: comm
    integer :: request
    integer :: ierror
  end subroutine MPI_Ssend_init_c

  subroutine MPI_Start( &
    request, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    integer :: ierror
  end subroutine MPI_Start

  subroutine MPI_Startall( &
    count, &
    array_of_requests, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_requests(*)
    integer :: ierror
  end subroutine MPI_Startall

  subroutine MPI_Status_get_error( &
    status, &
    err, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: err
    integer :: ierror
  end subroutine MPI_Status_get_error

  subroutine MPI_Status_get_source( &
    status, &
    source, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: source
    integer :: ierror
  end subroutine MPI_Status_get_source

  subroutine MPI_Status_get_tag( &
    status, &
    tag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: tag
    integer :: ierror
  end subroutine MPI_Status_get_tag

  subroutine MPI_Status_set_cancelled( &
    status, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    logical :: flag
    integer :: ierror
  end subroutine MPI_Status_set_cancelled

  subroutine MPI_Status_set_elements( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: datatype
    integer :: count
    integer :: ierror
  end subroutine MPI_Status_set_elements

  subroutine MPI_Status_set_elements_c( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: datatype
    integer(MPI_COUNT_KIND) :: count
    integer :: ierror
  end subroutine MPI_Status_set_elements_c

  subroutine MPI_Status_set_elements_x( &
    status, &
    datatype, &
    count, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: datatype
    integer(MPI_COUNT_KIND) :: count
    integer :: ierror
  end subroutine MPI_Status_set_elements_x

  subroutine MPI_Status_set_error( &
    status, &
    err, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: err
    integer :: ierror
  end subroutine MPI_Status_set_error

  subroutine MPI_Status_set_source( &
    status, &
    source, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: source
    integer :: ierror
  end subroutine MPI_Status_set_source

  subroutine MPI_Status_set_tag( &
    status, &
    tag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    integer :: tag
    integer :: ierror
  end subroutine MPI_Status_set_tag

  subroutine MPI_Test( &
    request, &
    flag, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    logical :: flag
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Test

  subroutine MPI_Test_cancelled( &
    status, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: status(MPI_STATUS_SIZE)
    logical :: flag
    integer :: ierror
  end subroutine MPI_Test_cancelled

  subroutine MPI_Testall( &
    count, &
    array_of_requests, &
    flag, &
    array_of_statuses, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_requests(*)
    logical :: flag
    integer :: array_of_statuses(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Testall

  subroutine MPI_Testany( &
    count, &
    array_of_requests, &
    index, &
    flag, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_requests(*)
    integer :: index
    logical :: flag
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Testany

  subroutine MPI_Testsome( &
    incount, &
    array_of_requests, &
    outcount, &
    array_of_indices, &
    array_of_statuses, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: incount
    integer :: array_of_requests(*)
    integer :: outcount
    integer :: array_of_indices(*)
    integer :: array_of_statuses(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Testsome

  subroutine MPI_Topo_test( &
    comm, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: comm
    integer :: status
    integer :: ierror
  end subroutine MPI_Topo_test

  subroutine MPI_Type_commit( &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer :: ierror
  end subroutine MPI_Type_commit

  subroutine MPI_Type_contiguous( &
    count, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_contiguous

  subroutine MPI_Type_contiguous_c( &
    count, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: count
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_contiguous_c

  subroutine MPI_Type_create_darray( &
    size, &
    rank, &
    ndims, &
    array_of_gsizes, &
    array_of_distribs, &
    array_of_dargs, &
    array_of_psizes, &
    order, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: size
    integer :: rank
    integer :: ndims
    integer :: array_of_gsizes(ndims)
    integer :: array_of_distribs(ndims)
    integer :: array_of_dargs(ndims)
    integer :: array_of_psizes(ndims)
    integer :: order
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_darray

  subroutine MPI_Type_create_darray_c( &
    size, &
    rank, &
    ndims, &
    array_of_gsizes, &
    array_of_distribs, &
    array_of_dargs, &
    array_of_psizes, &
    order, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: size
    integer :: rank
    integer :: ndims
    integer(MPI_COUNT_KIND) :: array_of_gsizes(ndims)
    integer :: array_of_distribs(ndims)
    integer :: array_of_dargs(ndims)
    integer :: array_of_psizes(ndims)
    integer :: order
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_darray_c

  subroutine MPI_Type_create_f90_complex( &
    p, &
    r, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: p
    integer :: r
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_f90_complex

  subroutine MPI_Type_create_f90_integer( &
    r, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: r
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_f90_integer

  subroutine MPI_Type_create_f90_real( &
    p, &
    r, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: p
    integer :: r
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_f90_real

  subroutine MPI_Type_create_hindexed( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_blocklengths(count)
    integer(MPI_ADDRESS_KIND) :: array_of_displacements(count)
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_hindexed

  subroutine MPI_Type_create_hindexed_c( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: count
    integer(MPI_COUNT_KIND) :: array_of_blocklengths(count)
    integer(MPI_COUNT_KIND) :: array_of_displacements(count)
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_hindexed_c

  subroutine MPI_Type_create_hindexed_block( &
    count, &
    blocklength, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: blocklength
    integer(MPI_ADDRESS_KIND) :: array_of_displacements(count)
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_hindexed_block

  subroutine MPI_Type_create_hindexed_block_c( &
    count, &
    blocklength, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: count
    integer(MPI_COUNT_KIND) :: blocklength
    integer(MPI_COUNT_KIND) :: array_of_displacements(count)
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_hindexed_block_c

  subroutine MPI_Type_create_hvector( &
    count, &
    blocklength, &
    stride, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: blocklength
    integer(MPI_ADDRESS_KIND) :: stride
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_hvector

  subroutine MPI_Type_create_hvector_c( &
    count, &
    blocklength, &
    stride, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: count
    integer(MPI_COUNT_KIND) :: blocklength
    integer(MPI_COUNT_KIND) :: stride
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_hvector_c

  subroutine MPI_Type_create_indexed_block( &
    count, &
    blocklength, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: blocklength
    integer :: array_of_displacements(count)
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_indexed_block

  subroutine MPI_Type_create_indexed_block_c( &
    count, &
    blocklength, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: count
    integer(MPI_COUNT_KIND) :: blocklength
    integer(MPI_COUNT_KIND) :: array_of_displacements(count)
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_indexed_block_c

  subroutine MPI_Type_create_keyval( &
    type_copy_attr_fn, &
    type_delete_attr_fn, &
    type_keyval, &
    extra_state, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: type_copy_attr_fn
    external :: type_delete_attr_fn
    integer :: type_keyval
    integer :: extra_state
    integer :: ierror
  end subroutine MPI_Type_create_keyval

  subroutine MPI_Type_create_resized( &
    oldtype, &
    lb, &
    extent, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: oldtype
    integer(MPI_ADDRESS_KIND) :: lb
    integer(MPI_ADDRESS_KIND) :: extent
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_resized

  subroutine MPI_Type_create_resized_c( &
    oldtype, &
    lb, &
    extent, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: oldtype
    integer(MPI_COUNT_KIND) :: lb
    integer(MPI_COUNT_KIND) :: extent
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_resized_c

  subroutine MPI_Type_create_struct( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    array_of_types, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_blocklengths(count)
    integer(MPI_ADDRESS_KIND) :: array_of_displacements(count)
    integer :: array_of_types(*)
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_struct

  subroutine MPI_Type_create_struct_c( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    array_of_types, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: count
    integer(MPI_COUNT_KIND) :: array_of_blocklengths(count)
    integer(MPI_COUNT_KIND) :: array_of_displacements(count)
    integer :: array_of_types(*)
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_struct_c

  subroutine MPI_Type_create_subarray( &
    ndims, &
    array_of_sizes, &
    array_of_subsizes, &
    array_of_starts, &
    order, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: ndims
    integer :: array_of_sizes(ndims)
    integer :: array_of_subsizes(ndims)
    integer :: array_of_starts(ndims)
    integer :: order
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_subarray

  subroutine MPI_Type_create_subarray_c( &
    ndims, &
    array_of_sizes, &
    array_of_subsizes, &
    array_of_starts, &
    order, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: ndims
    integer(MPI_COUNT_KIND) :: array_of_sizes(ndims)
    integer(MPI_COUNT_KIND) :: array_of_subsizes(ndims)
    integer(MPI_COUNT_KIND) :: array_of_starts(ndims)
    integer :: order
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_create_subarray_c

  subroutine MPI_Type_delete_attr( &
    datatype, &
    type_keyval, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer :: type_keyval
    integer :: ierror
  end subroutine MPI_Type_delete_attr

  subroutine MPI_Type_dup( &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_dup

  subroutine MPI_Type_free( &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer :: ierror
  end subroutine MPI_Type_free

  subroutine MPI_Type_free_keyval( &
    type_keyval, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: type_keyval
    integer :: ierror
  end subroutine MPI_Type_free_keyval

  subroutine MPI_Type_get_attr( &
    datatype, &
    type_keyval, &
    attribute_val, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer :: type_keyval
    integer :: attribute_val
    logical :: flag
    integer :: ierror
  end subroutine MPI_Type_get_attr

  subroutine MPI_Type_get_contents( &
    datatype, &
    max_integers, &
    max_addresses, &
    max_datatypes, &
    array_of_integers, &
    array_of_addresses, &
    array_of_datatypes, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer :: max_integers
    integer :: max_addresses
    integer :: max_datatypes
    integer :: array_of_integers(max_integers)
    integer(MPI_ADDRESS_KIND) :: array_of_addresses(max_addresses)
    integer :: array_of_datatypes(*)
    integer :: ierror
  end subroutine MPI_Type_get_contents

  subroutine MPI_Type_get_contents_c( &
    datatype, &
    max_integers, &
    max_addresses, &
    max_large_counts, &
    max_datatypes, &
    array_of_integers, &
    array_of_addresses, &
    array_of_large_counts, &
    array_of_datatypes, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_COUNT_KIND) :: max_integers
    integer(MPI_COUNT_KIND) :: max_addresses
    integer(MPI_COUNT_KIND) :: max_large_counts
    integer(MPI_COUNT_KIND) :: max_datatypes
    integer :: array_of_integers(max_integers)
    integer(MPI_ADDRESS_KIND) :: array_of_addresses(max_addresses)
    integer(MPI_COUNT_KIND) :: array_of_large_counts(max_large_counts)
    integer :: array_of_datatypes(*)
    integer :: ierror
  end subroutine MPI_Type_get_contents_c

  subroutine MPI_Type_get_envelope( &
    datatype, &
    num_integers, &
    num_addresses, &
    num_datatypes, &
    combiner, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer :: num_integers
    integer :: num_addresses
    integer :: num_datatypes
    integer :: combiner
    integer :: ierror
  end subroutine MPI_Type_get_envelope

  subroutine MPI_Type_get_envelope_c( &
    datatype, &
    num_integers, &
    num_addresses, &
    num_large_counts, &
    num_datatypes, &
    combiner, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_COUNT_KIND) :: num_integers
    integer(MPI_COUNT_KIND) :: num_addresses
    integer(MPI_COUNT_KIND) :: num_large_counts
    integer(MPI_COUNT_KIND) :: num_datatypes
    integer :: combiner
    integer :: ierror
  end subroutine MPI_Type_get_envelope_c

  subroutine MPI_Type_get_extent( &
    datatype, &
    lb, &
    extent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_ADDRESS_KIND) :: lb
    integer(MPI_ADDRESS_KIND) :: extent
    integer :: ierror
  end subroutine MPI_Type_get_extent

  subroutine MPI_Type_get_extent_c( &
    datatype, &
    lb, &
    extent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_COUNT_KIND) :: lb
    integer(MPI_COUNT_KIND) :: extent
    integer :: ierror
  end subroutine MPI_Type_get_extent_c

  subroutine MPI_Type_get_extent_x( &
    datatype, &
    lb, &
    extent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_COUNT_KIND) :: lb
    integer(MPI_COUNT_KIND) :: extent
    integer :: ierror
  end subroutine MPI_Type_get_extent_x

  subroutine MPI_Type_get_name( &
    datatype, &
    type_name, &
    resultlen, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    character*(MPI_MAX_OBJECT_NAME) :: type_name
    integer :: resultlen
    integer :: ierror
  end subroutine MPI_Type_get_name

  subroutine MPI_Type_get_true_extent( &
    datatype, &
    true_lb, &
    true_extent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_ADDRESS_KIND) :: true_lb
    integer(MPI_ADDRESS_KIND) :: true_extent
    integer :: ierror
  end subroutine MPI_Type_get_true_extent

  subroutine MPI_Type_get_true_extent_c( &
    datatype, &
    true_lb, &
    true_extent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_COUNT_KIND) :: true_lb
    integer(MPI_COUNT_KIND) :: true_extent
    integer :: ierror
  end subroutine MPI_Type_get_true_extent_c

  subroutine MPI_Type_get_true_extent_x( &
    datatype, &
    true_lb, &
    true_extent, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_COUNT_KIND) :: true_lb
    integer(MPI_COUNT_KIND) :: true_extent
    integer :: ierror
  end subroutine MPI_Type_get_true_extent_x

  subroutine MPI_Type_get_value_index( &
    value_type, &
    index_type, &
    pair_type, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: value_type
    integer :: index_type
    integer :: pair_type
    integer :: ierror
  end subroutine MPI_Type_get_value_index

  subroutine MPI_Type_indexed( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_blocklengths(count)
    integer :: array_of_displacements(count)
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_indexed

  subroutine MPI_Type_indexed_c( &
    count, &
    array_of_blocklengths, &
    array_of_displacements, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: count
    integer(MPI_COUNT_KIND) :: array_of_blocklengths(count)
    integer(MPI_COUNT_KIND) :: array_of_displacements(count)
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_indexed_c

  subroutine MPI_Type_match_size( &
    typeclass, &
    size, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: typeclass
    integer :: size
    integer :: datatype
    integer :: ierror
  end subroutine MPI_Type_match_size

  subroutine MPI_Type_set_attr( &
    datatype, &
    type_keyval, &
    attribute_val, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer :: type_keyval
    integer :: attribute_val
    integer :: ierror
  end subroutine MPI_Type_set_attr

  subroutine MPI_Type_set_name( &
    datatype, &
    type_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    character*(*) :: type_name
    integer :: ierror
  end subroutine MPI_Type_set_name

  subroutine MPI_Type_size( &
    datatype, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer :: size
    integer :: ierror
  end subroutine MPI_Type_size

  subroutine MPI_Type_size_c( &
    datatype, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Type_size_c

  subroutine MPI_Type_size_x( &
    datatype, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: datatype
    integer(MPI_COUNT_KIND) :: size
    integer :: ierror
  end subroutine MPI_Type_size_x

  subroutine MPI_Type_vector( &
    count, &
    blocklength, &
    stride, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: blocklength
    integer :: stride
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_vector

  subroutine MPI_Type_vector_c( &
    count, &
    blocklength, &
    stride, &
    oldtype, &
    newtype, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_COUNT_KIND) :: count
    integer(MPI_COUNT_KIND) :: blocklength
    integer(MPI_COUNT_KIND) :: stride
    integer :: oldtype
    integer :: newtype
    integer :: ierror
  end subroutine MPI_Type_vector_c

  subroutine MPI_Unpack( &
    inbuf, &
    insize, &
    position, &
    outbuf, &
    outcount, &
    datatype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer :: insize
    integer :: position
    !dir$ ignore_tkr(trk) outbuf
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer :: outcount
    integer :: datatype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Unpack

  subroutine MPI_Unpack_c( &
    inbuf, &
    insize, &
    position, &
    outbuf, &
    outcount, &
    datatype, &
    comm, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_COUNT_KIND) :: insize
    integer(MPI_COUNT_KIND) :: position
    !dir$ ignore_tkr(trk) outbuf
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_COUNT_KIND) :: outcount
    integer :: datatype
    integer :: comm
    integer :: ierror
  end subroutine MPI_Unpack_c

  subroutine MPI_Unpack_external( &
    datarep, &
    inbuf, &
    insize, &
    position, &
    outbuf, &
    outcount, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: datarep
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_ADDRESS_KIND) :: insize
    integer(MPI_ADDRESS_KIND) :: position
    !dir$ ignore_tkr(trk) outbuf
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer :: outcount
    integer :: datatype
    integer :: ierror
  end subroutine MPI_Unpack_external

  subroutine MPI_Unpack_external_c( &
    datarep, &
    inbuf, &
    insize, &
    position, &
    outbuf, &
    outcount, &
    datatype, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: datarep
    !dir$ ignore_tkr(trk) inbuf
    !gcc$ attributes no_arg_check :: inbuf
    integer :: inbuf(*)
    integer(MPI_COUNT_KIND) :: insize
    integer(MPI_COUNT_KIND) :: position
    !dir$ ignore_tkr(trk) outbuf
    !gcc$ attributes no_arg_check :: outbuf
    integer :: outbuf(*)
    integer(MPI_COUNT_KIND) :: outcount
    integer :: datatype
    integer :: ierror
  end subroutine MPI_Unpack_external_c

  subroutine MPI_Unpublish_name( &
    service_name, &
    info, &
    port_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    character*(*) :: service_name
    integer :: info
    character*(*) :: port_name
    integer :: ierror
  end subroutine MPI_Unpublish_name

  subroutine MPI_Wait( &
    request, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: request
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Wait

  subroutine MPI_Waitall( &
    count, &
    array_of_requests, &
    array_of_statuses, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_requests(*)
    integer :: array_of_statuses(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Waitall

  subroutine MPI_Waitany( &
    count, &
    array_of_requests, &
    index, &
    status, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: count
    integer :: array_of_requests(*)
    integer :: index
    integer :: status(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Waitany

  subroutine MPI_Waitsome( &
    incount, &
    array_of_requests, &
    outcount, &
    array_of_indices, &
    array_of_statuses, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: incount
    integer :: array_of_requests(*)
    integer :: outcount
    integer :: array_of_indices(*)
    integer :: array_of_statuses(MPI_STATUS_SIZE)
    integer :: ierror
  end subroutine MPI_Waitsome

  subroutine MPI_Win_allocate( &
    size, &
    disp_unit, &
    info, &
    comm, &
    baseptr, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    integer :: info
    integer :: comm
    integer(MPI_ADDRESS_KIND) :: baseptr
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_allocate

  subroutine MPI_Win_allocate_c( &
    size, &
    disp_unit, &
    info, &
    comm, &
    baseptr, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    integer :: info
    integer :: comm
    integer(MPI_ADDRESS_KIND) :: baseptr
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_allocate_c

  subroutine MPI_Win_allocate_shared( &
    size, &
    disp_unit, &
    info, &
    comm, &
    baseptr, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    integer :: info
    integer :: comm
    integer(MPI_ADDRESS_KIND) :: baseptr
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_allocate_shared

  subroutine MPI_Win_allocate_shared_c( &
    size, &
    disp_unit, &
    info, &
    comm, &
    baseptr, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    integer :: info
    integer :: comm
    integer(MPI_ADDRESS_KIND) :: baseptr
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_allocate_shared_c

  subroutine MPI_Win_attach( &
    win, &
    base, &
    size, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    !dir$ ignore_tkr(trk) base
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer(MPI_ADDRESS_KIND) :: size
    integer :: ierror
  end subroutine MPI_Win_attach

  subroutine MPI_Win_call_errhandler( &
    win, &
    errorcode, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: errorcode
    integer :: ierror
  end subroutine MPI_Win_call_errhandler

  subroutine MPI_Win_complete( &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_complete

  subroutine MPI_Win_create( &
    base, &
    size, &
    disp_unit, &
    info, &
    comm, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) base
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    integer :: info
    integer :: comm
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_create

  subroutine MPI_Win_create_c( &
    base, &
    size, &
    disp_unit, &
    info, &
    comm, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    !dir$ ignore_tkr(trk) base
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    integer :: info
    integer :: comm
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_create_c

  subroutine MPI_Win_create_dynamic( &
    info, &
    comm, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: info
    integer :: comm
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_create_dynamic

  subroutine MPI_Win_create_errhandler( &
    win_errhandler_fn, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: win_errhandler_fn
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Win_create_errhandler

  subroutine MPI_Win_create_keyval( &
    win_copy_attr_fn, &
    win_delete_attr_fn, &
    win_keyval, &
    extra_state, &
    ierror &
  )
    use mpi_constants
    implicit none
    external :: win_copy_attr_fn
    external :: win_delete_attr_fn
    integer :: win_keyval
    integer :: extra_state
    integer :: ierror
  end subroutine MPI_Win_create_keyval

  subroutine MPI_Win_delete_attr( &
    win, &
    win_keyval, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: win_keyval
    integer :: ierror
  end subroutine MPI_Win_delete_attr

  subroutine MPI_Win_detach( &
    win, &
    base, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    !dir$ ignore_tkr(trk) base
    !gcc$ attributes no_arg_check :: base
    integer :: base(*)
    integer :: ierror
  end subroutine MPI_Win_detach

  subroutine MPI_Win_fence( &
    assert, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: assert
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_fence

  subroutine MPI_Win_flush( &
    rank, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: rank
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_flush

  subroutine MPI_Win_flush_all( &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_flush_all

  subroutine MPI_Win_flush_local( &
    rank, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: rank
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_flush_local

  subroutine MPI_Win_flush_local_all( &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_flush_local_all

  subroutine MPI_Win_free( &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_free

  subroutine MPI_Win_free_keyval( &
    win_keyval, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win_keyval
    integer :: ierror
  end subroutine MPI_Win_free_keyval

  subroutine MPI_Win_get_attr( &
    win, &
    win_keyval, &
    attribute_val, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: win_keyval
    integer :: attribute_val
    logical :: flag
    integer :: ierror
  end subroutine MPI_Win_get_attr

  subroutine MPI_Win_get_errhandler( &
    win, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Win_get_errhandler

  subroutine MPI_Win_get_group( &
    win, &
    group, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: group
    integer :: ierror
  end subroutine MPI_Win_get_group

  subroutine MPI_Win_get_info( &
    win, &
    info_used, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: info_used
    integer :: ierror
  end subroutine MPI_Win_get_info

  subroutine MPI_Win_get_name( &
    win, &
    win_name, &
    resultlen, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    character*(MPI_MAX_OBJECT_NAME) :: win_name
    integer :: resultlen
    integer :: ierror
  end subroutine MPI_Win_get_name

  subroutine MPI_Win_lock( &
    lock_type, &
    rank, &
    assert, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: lock_type
    integer :: rank
    integer :: assert
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_lock

  subroutine MPI_Win_lock_all( &
    assert, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: assert
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_lock_all

  subroutine MPI_Win_post( &
    group, &
    assert, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: assert
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_post

  subroutine MPI_Win_set_attr( &
    win, &
    win_keyval, &
    attribute_val, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: win_keyval
    integer :: attribute_val
    integer :: ierror
  end subroutine MPI_Win_set_attr

  subroutine MPI_Win_set_errhandler( &
    win, &
    errhandler, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: errhandler
    integer :: ierror
  end subroutine MPI_Win_set_errhandler

  subroutine MPI_Win_set_info( &
    win, &
    info, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: info
    integer :: ierror
  end subroutine MPI_Win_set_info

  subroutine MPI_Win_set_name( &
    win, &
    win_name, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    character*(*) :: win_name
    integer :: ierror
  end subroutine MPI_Win_set_name

  subroutine MPI_Win_shared_query( &
    win, &
    rank, &
    size, &
    disp_unit, &
    baseptr, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: rank
    integer(MPI_ADDRESS_KIND) :: size
    integer :: disp_unit
    integer(MPI_ADDRESS_KIND) :: baseptr
    integer :: ierror
  end subroutine MPI_Win_shared_query

  subroutine MPI_Win_shared_query_c( &
    win, &
    rank, &
    size, &
    disp_unit, &
    baseptr, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: rank
    integer(MPI_ADDRESS_KIND) :: size
    integer(MPI_ADDRESS_KIND) :: disp_unit
    integer(MPI_ADDRESS_KIND) :: baseptr
    integer :: ierror
  end subroutine MPI_Win_shared_query_c

  subroutine MPI_Win_start( &
    group, &
    assert, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: group
    integer :: assert
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_start

  subroutine MPI_Win_sync( &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_sync

  subroutine MPI_Win_test( &
    win, &
    flag, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    logical :: flag
    integer :: ierror
  end subroutine MPI_Win_test

  subroutine MPI_Win_unlock( &
    rank, &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: rank
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_unlock

  subroutine MPI_Win_unlock_all( &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_unlock_all

  subroutine MPI_Win_wait( &
    win, &
    ierror &
  )
    use mpi_constants
    implicit none
    integer :: win
    integer :: ierror
  end subroutine MPI_Win_wait

  function MPI_Wtick( &
  ) result(result)
    use mpi_constants
    implicit none
    double precision :: result
  end function MPI_Wtick

  function MPI_Wtime( &
  ) result(result)
    use mpi_constants
    implicit none
    double precision :: result
  end function MPI_Wtime

  end interface

end module mpi_functions
