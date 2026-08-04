! MPI-4.0 added large counts "via separate additional MPI procedures in C
! (suffixed with `_c`) and via interface polymorphism in Fortran when using USE
! mpi_f08". So in mpi_f08 the base name has to accept an
! INTEGER(KIND=MPI_COUNT_KIND) count as well as a default INTEGER one, and the
! caller cannot reach for MPI_Send_c: section 19.1.4 makes invoking a `_c`
! specific erroneous but for MPI_Op_create_c and MPI_Register_datarep_c, and no
! such name exists here. mpif generated the two as separate names with no generic
! tying them together, so passing a count-kind count failed to compile -- "Type
! mismatch in argument 'count'; passed INTEGER(8) to INTEGER(4)", which is what
! stopped f08/pt2pt/pt2pt_largef08.
!
! The counts here are small; what is being tested is which specific the generic
! resolves to, not actually moving more than 2^31 elements.

program large_count_f08
  use mpi_f08
  implicit none

  integer, parameter :: n = 4
  integer :: sbuf(n), rbuf(n), i, small_count
  integer(MPI_COUNT_KIND) :: big_count
  integer(MPI_COUNT_KIND) :: got_count
  integer(MPI_COUNT_KIND) :: big_lb, big_extent
  type(MPI_Status) :: status
  type(MPI_Datatype) :: dt

  call MPI_Init()

  do i = 1, n
     sbuf(i) = i * 5
  end do

  ! The default-INTEGER specific, which always worked
  small_count = n
  rbuf = 0
  call MPI_Sendrecv(sbuf, small_count, MPI_INTEGER, 0, 0, &
                    rbuf, small_count, MPI_INTEGER, 0, 0, MPI_COMM_SELF, status)
  do i = 1, n
     if (rbuf(i) /= i * 5) stop 1
  end do
  print '("default INTEGER count: ok")'

  ! The large-count specific, reached through the same generic name
  big_count = n
  rbuf = 0
  call MPI_Sendrecv(sbuf, big_count, MPI_INTEGER, 0, 0, &
                    rbuf, big_count, MPI_INTEGER, 0, 0, MPI_COMM_SELF, status)
  do i = 1, n
     if (rbuf(i) /= i * 5) stop 2
  end do
  print '("INTEGER(MPI_COUNT_KIND) count: ok")'

  ! An out argument of count kind, so the generic has to pick on that too
  call MPI_Get_count(status, MPI_INTEGER, got_count)
  if (got_count /= n) stop 3
  print '("MPI_Get_count with a count-kind result: ", i0)', got_count

  ! And a datatype constructor, where the large form takes count-kind extents
  call MPI_Type_contiguous(big_count, MPI_INTEGER, dt)
  call MPI_Type_commit(dt)
  call MPI_Type_free(dt)
  print '("MPI_Type_contiguous with a count-kind count: ok")'

  ! MPI_Type_get_extent's extents are MPI_Aint in the small form and MPI_Count in
  ! the large one, so its two specifics differ in kind only where those two types
  ! do -- on a 32-bit platform and not on a 64-bit one, MPI_Aint being intptr_t
  ! and MPI_Count int64_t. Count-kind extents have to be accepted either way:
  ! through the generic where it exists, and through the small specific where the
  ! two kinds are the same kind. See "MPI_Count is int64_t where MPI_Aint is a
  ! pointer" in MISSING.md; before that, this line did not compile on 32 bits.
  call MPI_Type_get_extent(MPI_INTEGER, big_lb, big_extent)
  if (big_lb /= 0) stop 4
  if (big_extent /= 4) stop 5
  print '("MPI_Type_get_extent with count-kind extents: ok")'

  print '("large_count_f08: all ok")'

  call MPI_Finalize()

end program large_count_f08
