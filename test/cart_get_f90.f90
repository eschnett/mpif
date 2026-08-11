! MPI_CART_GET's `periods` is the only out-LOGICAL *array* in data/apis.json, and
! so the only argument of its kind that needs a C temporary and a per-element
! conversion back. `dims` and `coords` are INTEGER and reach MPI directly, which
! is why only `periods` ever had a question here.
!
! MPI writes only as many entries as the topology has dimensions, and `maxdims`
! may be larger. MPI-5.0 section 8.5 states the extreme case: "If comm is
! associated with a zero-dimensional Cartesian topology, MPI_CARTDIM_GET returns
! ndims = 0 and MPI_CART_GET will keep all output arguments unchanged." mpif
! therefore converts back only the entries MPI wrote, reading the count from
! MPI_CARTDIM_GET, and leaves the caller's surplus exactly as passed.
!
! It once converted the whole `*maxdims` extent from an uninitialised temporary,
! which both read uninitialised memory and overwrote elements MPI never touched.
! Both halves are checked below, in the two-dimensional case and in the
! zero-dimensional one the sentence above names.

program cart_get_f90
  use mpi
  implicit none

  integer, parameter :: ndims = 2, maxdims = 4

  integer :: ierr, cart, cart0, nprocs, i, dimget
  integer :: dims(ndims)
  logical :: periods_in(ndims)
  integer :: gdims(maxdims), gcoords(maxdims)
  logical :: gperiods(maxdims)

  call MPI_Init(ierr)

  ! Let MPI pick a factorisation, so this works at any process count
  call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)
  dims = 0
  call MPI_Dims_create(nprocs, ndims, dims, ierr)
  if (ierr /= MPI_SUCCESS) stop 1

  periods_in = [.true., .false.]
  call MPI_Cart_create(MPI_COMM_WORLD, ndims, dims, periods_in, .false., cart, &
       ierr)
  if (ierr /= MPI_SUCCESS) stop 2

  ! Every out element starts at a value the call must be seen to change or to
  ! leave alone, so that a conversion doing nothing is as visible as one doing
  ! too much. `.true.` for periods is the telling one: MPI_CART_GET reports the
  ! second dimension as non-periodic, so an entry that stays `.true.` past the
  ! second is mpif having left it, not MPI having written it.
  gdims = -1
  gcoords = -1
  gperiods = .true.

  call MPI_Cart_get(cart, maxdims, gdims, gperiods, gcoords, ierr)
  if (ierr /= MPI_SUCCESS) stop 3

  ! What MPI wrote: the first `ndims` entries of each
  do i = 1, ndims
     if (gdims(i) /= dims(i)) stop 4
     if (gperiods(i) .neqv. periods_in(i)) stop 5
     if (gcoords(i) < 0 .or. gcoords(i) >= dims(i)) stop 6
  end do

  ! The surplus, for all three arguments alike: untouched. `periods` is the one
  ! that has to be arranged for, the other two being untouched by construction.
  do i = ndims + 1, maxdims
     if (.not. gperiods(i)) stop 7
     if (gdims(i) /= -1) stop 8
     if (gcoords(i) /= -1) stop 9
  end do

  ! MPI_CARTDIM_GET is what mpif reads the bound from, so check it says what the
  ! loops above assumed
  call MPI_Cartdim_get(cart, dimget, ierr)
  if (ierr /= MPI_SUCCESS) stop 10
  if (dimget /= ndims) stop 11

  print '("cart_get_f90: 2-D topology, surplus of all three left as passed")'

  ! The zero-dimensional topology of section 8.5, where MPI writes nothing at all
  ! and every one of the four entries must come back as it was passed. Only one
  ! process can be in a zero-dimensional topology, so the rest get MPI_COMM_NULL
  ! and sit this part out.
  call MPI_Cart_create(MPI_COMM_WORLD, 0, dims, periods_in, .false., cart0, ierr)
  if (ierr /= MPI_SUCCESS) stop 12

  if (cart0 /= MPI_COMM_NULL) then
     call MPI_Cartdim_get(cart0, dimget, ierr)
     if (ierr /= MPI_SUCCESS) stop 13
     if (dimget /= 0) stop 14

     gdims = -1
     gcoords = -1
     gperiods = .true.

     call MPI_Cart_get(cart0, maxdims, gdims, gperiods, gcoords, ierr)
     if (ierr /= MPI_SUCCESS) stop 15

     do i = 1, maxdims
        if (.not. gperiods(i)) stop 16
        if (gdims(i) /= -1) stop 17
        if (gcoords(i) /= -1) stop 18
     end do

     print '("cart_get_f90: 0-D topology, all output arguments unchanged")'
     call MPI_Comm_free(cart0, ierr)
  end if

  print '("cart_get_f90: all ok")'

  call MPI_Comm_free(cart, ierr)
  call MPI_Finalize(ierr)

end program cart_get_f90
