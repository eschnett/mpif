! MPI_Neighbor_alltoallw over a 3-D periodic Cartesian communicator, where
! MPI-5.0 8.6 fixes the array length at "2*ndims with ndims defined in
! MPI_CART_CREATE" -- six here, whatever the size of the communicator.
!
! mpif sized both arrays by MPI_Comm_size instead, which is unrelated to the
! number of neighbours and, at any size below six, smaller: the wrapper converted
! two handles, declared a two-element array, and handed it to an implementation
! that reads six. Three dimensions rather than one so that the gap is four
! elements rather than one, and periodic so that every neighbour exists and the
! data can be checked. No Fortran test in MPICH's suite calls this routine, which
! is why nothing had reported it.

program neighbor_alltoallw_f08
  use mpi_f08
  implicit none

  integer, parameter :: ndims = 3
  integer, parameter :: nneighbors = 2 * ndims
  integer :: rank, size, intsize, d, k
  integer :: dims(ndims)
  logical :: periods(ndims)
  type(MPI_Comm) :: cart
  integer :: scounts(nneighbors), rcounts(nneighbors)
  integer(MPI_ADDRESS_KIND) :: sdispls(nneighbors), rdispls(nneighbors)
  type(MPI_Datatype) :: stypes(nneighbors), rtypes(nneighbors)
  integer :: sbuf(nneighbors), rbuf(nneighbors)
  integer :: neighbors(nneighbors)
  integer :: cart_rank, source, dest

  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, rank)
  call MPI_Comm_size(MPI_COMM_WORLD, size)
  call MPI_Type_size(MPI_INTEGER, intsize)

  dims = 0
  call MPI_Dims_create(size, ndims, dims)
  periods = .true.
  call MPI_Cart_create(MPI_COMM_WORLD, ndims, dims, periods, .false., cart)
  call MPI_Comm_rank(cart, cart_rank)

  ! 8.6: "first the neighbor in the negative direction and then in the positive
  ! direction with displacement 1", per dimension in order. MPI_Cart_shift with
  ! disp = 1 reports the negative-direction neighbour as the source and the
  ! positive-direction one as the destination.
  do d = 1, ndims
     call MPI_Cart_shift(cart, d - 1, 1, source, dest)
     neighbors(2 * d - 1) = source
     neighbors(2 * d) = dest
  end do

  do k = 1, nneighbors
     scounts(k) = 1
     sdispls(k) = (k - 1) * intsize
     stypes(k) = MPI_INTEGER
     ! Just the rank. Tagging each block with its own index and checking where it
     ! lands was tried and is not something the standard promises: with `dims`
     ! from MPI_Dims_create most dimensions here have extent one, so both of their
     ! neighbours are this process itself, and several edges then join the same
     ! pair. 8.6's model is a loop of MPI_Isend to dsts[k] and MPI_Irecv from
     ! srcs[i], and its matching rule constrains the type signatures, not which
     ! send satisfies which receive. Sending block 6 arrived in receive block 3
     ! accordingly, which is the implementation's business and not a defect.
     sbuf(k) = cart_rank
     rcounts(k) = 1
     rdispls(k) = (k - 1) * intsize
     rtypes(k) = MPI_INTEGER
     rbuf(k) = -1
  end do

  call MPI_Neighbor_alltoallw(sbuf, scounts, sdispls, stypes, &
                              rbuf, rcounts, rdispls, rtypes, cart)

  ! Block i is what source i sent, and every source sent its own rank, so block k
  ! holds neighbour k's rank -- which does pin down that the block came from the
  ! right *process*, whatever the implementation did about the order.
  do k = 1, nneighbors
     if (rbuf(k) /= neighbors(k)) then
        print *, "rank ", cart_rank, ": rbuf(", k, ") = ", rbuf(k), &
             ", expected ", neighbors(k)
        call MPI_Abort(MPI_COMM_WORLD, 1)
     end if
  end do

  call MPI_Comm_free(cart)
  call MPI_Finalize()
end program neighbor_alltoallw_f08
