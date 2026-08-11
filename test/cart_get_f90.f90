! MPI_CART_GET's `periods` is the only out-LOGICAL *array* in data/apis.json, and
! so the only argument of its kind that needs a C temporary and a per-element
! conversion back. `dims` and `coords` are INTEGER and reach MPI directly.
!
! MPI writes only as many entries as the topology has dimensions, and `maxdims`
! may be larger than that. mpif pre-fills its temporary with `false` and converts
! the whole extent, so the surplus comes back `.false.` rather than untouched --
! deliberately, and at odds with what MPI-5.0 section 8.5 says for the
! zero-dimensional case; MISSING.md has the reasoning under "MPI_CART_GET writes
! the surplus of periods rather than leaving it alone". Without the pre-fill those
! entries were converted from uninitialised stack memory instead.
!
! This pins both halves: the entries MPI writes, and what the surplus becomes.
! The surplus assertions are about mpif's own choice, not about the standard, so
! they are the ones to change if that decision is ever revisited.

program cart_get_f90
  use mpi
  implicit none

  integer, parameter :: ndims = 2, maxdims = 4

  integer :: ierr, cart, nprocs, i
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

  ! Every out element starts at a value the call must be seen to change or leave,
  ! so that a conversion doing nothing is as visible as one doing the wrong thing
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

  ! The surplus of `periods`: mpif converts its whole temporary, so `.false.`
  do i = ndims + 1, maxdims
     if (gperiods(i)) stop 7
  end do

  ! The surplus of `dims` and `coords`, which have no temporary and so are left
  ! exactly as passed. This is the contrast that shows why only `periods` has the
  ! question at all.
  do i = ndims + 1, maxdims
     if (gdims(i) /= -1) stop 8
     if (gcoords(i) /= -1) stop 9
  end do

  print '("cart_get_f90: surplus periods are .false., dims and coords untouched")'
  print '("cart_get_f90: all ok")'

  call MPI_Comm_free(cart, ierr)
  call MPI_Finalize(ierr)

end program cart_get_f90
