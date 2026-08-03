! The PMPI names through mpi_f08, where the calling convention is the interesting
! part: handles are derived types, `ierror` is OPTIONAL, and the base name is a
! generic over a small-count and a large-count specific. All three have to hold
! for the P forms as they do for the MPI ones, MPI-5.0 section 19.1.5 asking for
! "a second procedure with the same calling conventions".
!
! The large-count call is the one that cannot be checked any other way. The 157
! PMPI generics are emitted from the same list as the MPI ones, eight of them
! under the #ifdef guards that say whether a compiler can tell the two specifics
! apart on this platform; a guard that went astray -- and the way it would go
! astray is being renamed along with everything else -- takes its generic with it
! and says nothing. Passing an MPI_COUNT_KIND count through PMPI_Bcast resolves to
! the large-count specific, so it only compiles if that generic is there.
!
! `MPI_Status_f2f08` and its P form are hand-written module procedures in
! src/mpif_f08_types.F90 rather than generated, so they get their own line.

program pmpi_f08
  use mpi_f08
  implicit none

  integer :: rank, size
  integer(MPI_COUNT_KIND) :: bigcount
  integer :: buf(4), rbuf(4), fstatus(MPI_STATUS_SIZE)
  type(MPI_Status) :: status
  type(MPI_Comm) :: dup
  type(MPI_Request) :: request
  integer :: keyval
  integer(MPI_ADDRESS_KIND) :: attr
  logical :: flag

  ! ierror omitted throughout, which is what OPTIONAL is for and what a caller
  ! written against the standard's own bindings does
  call PMPI_Init()
  call PMPI_Comm_rank(MPI_COMM_WORLD, rank)
  call PMPI_Comm_size(MPI_COMM_WORLD, size)
  if (rank < 0 .or. rank >= size) stop 1

  ! A derived-type handle in and out
  call PMPI_Comm_dup(MPI_COMM_WORLD, dup)
  if (dup == MPI_COMM_NULL) stop 2
  call PMPI_Comm_free(dup)
  if (dup /= MPI_COMM_NULL) stop 3

  ! A message to self through the small-count specifics, and a status back.
  ! Sendrecv rather than Send then Recv: a blocking send to self is allowed to
  ! block until the matching receive is posted, and on this MPI it does.
  buf = [11, 22, 33, 44]
  rbuf = 0
  call PMPI_Sendrecv(buf, 4, MPI_INTEGER, 0, 7, &
                     rbuf, 4, MPI_INTEGER, 0, 7, MPI_COMM_SELF, status)
  if (any(rbuf /= [11, 22, 33, 44])) stop 4
  if (status%MPI_TAG /= 7) stop 5
  if (status%MPI_SOURCE /= 0) stop 6

  ! And once more through a nonblocking pair, which is where the request handle
  ! comes back as a derived type
  buf = [1, 2, 3, 4]
  rbuf = 0
  call PMPI_Irecv(rbuf, 4, MPI_INTEGER, 0, 8, MPI_COMM_SELF, request)
  call PMPI_Send(buf, 4, MPI_INTEGER, 0, 8, MPI_COMM_SELF)
  call PMPI_Wait(request, status)
  if (any(rbuf /= [1, 2, 3, 4])) stop 7
  if (request /= MPI_REQUEST_NULL) stop 8

  ! The large-count specific, reached through the generic
  bigcount = 4
  buf = [55, 66, 77, 88]
  call PMPI_Bcast(buf, bigcount, MPI_INTEGER, 0, MPI_COMM_SELF)
  if (any(buf /= [55, 66, 77, 88])) stop 9

  ! The hand-written status conversions, round-tripping the status PMPI_Wait left
  call PMPI_Status_f082f(status, fstatus)
  if (fstatus(MPI_TAG) /= 8) stop 10
  call PMPI_Status_f2f08(fstatus, status)
  if (status%MPI_TAG /= 8) stop 11

  ! A predefined callback passed to a PMPI routine, keeping its MPI_ name -- there
  ! is no PMPI_ form and none wanted, A.1.1 listing these among the defined
  ! constants with an ABI value of 0 or 1, so there is no entry point to
  ! name-shift. This is mpi_f08's own callback, a separate procedure from the
  ! mpif.h one because its handle is a derived type, and the assertion is that its
  ! address is still recognised when the call arrives through PMPI.
  call PMPI_Comm_create_keyval(MPI_COMM_NULL_COPY_FN, &
       MPI_COMM_NULL_DELETE_FN, keyval, 0_MPI_ADDRESS_KIND)
  call PMPI_Comm_set_attr(MPI_COMM_WORLD, keyval, 99_MPI_ADDRESS_KIND)
  call PMPI_Comm_get_attr(MPI_COMM_WORLD, keyval, attr, flag)
  if (.not. flag) stop 12
  if (attr /= 99) stop 13
  call PMPI_Comm_free_keyval(keyval)

  print '("pmpi_f08: all ok")'

  call PMPI_Finalize()

end program pmpi_f08
