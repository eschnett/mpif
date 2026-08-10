! MPI_UNWEIGHTED and MPI_WEIGHTS_EMPTY, in all three interfaces and in both
! directions.
!
! These two are sentinels the wrappers have to translate, and until this test
! existed no Fortran program in test/ passed either one to MPI at all -- they
! appeared only in the C test that inspects mpif's own cells. Two things make
! them worth their own file rather than a line in an existing one:
!
! - the OUT direction is a translation site of its own. MPI_Dist_graph_neighbors
!   takes MPI_UNWEIGHTED for `sourceweights`/`destweights` even though they are
!   OUT arguments; MPI-5.0 8.5.5: "If MPI_UNWEIGHTED is supplied for
!   sourceweights or destweights or both ... then no weight information is
!   returned in that array." A missed translation there is an *overrun* -- MPI
!   would write maxindegree integers into a one-element COMMON block -- so it is
!   the more dangerous of the two.
! - MPI-5.0 8.5.4 explains why only the address carries the meaning: "MPI_UNWEIGHTED
!   and MPI_WEIGHTS_EMPTY are not special weight values; rather they are special
!   values for the total array argument. In Fortran, MPI_UNWEIGHTED and
!   MPI_WEIGHTS_EMPTY are objects like MPI_BOTTOM (not usable for initialization
!   or assignment)." So there is no value to check afterwards; what is checked is
!   that the calls succeed, that an unweighted graph reports itself unweighted,
!   and that mpif's cells are unwritten -- which the cells being const makes a
!   fault rather than a silent corruption, and which the poison in them would
!   otherwise turn into an absurd weight.
!
! MPI_WEIGHTS_EMPTY is the degree-zero case: 8.5.4 requires it rather than
! MPI_UNWEIGHTED where a rank has no edges, "MPI_WEIGHTS_EMPTY ... cannot be used
! if indegree or outdegree is zero" being the reverse constraint on MPI_UNWEIGHTED.
! One rank with a self-edge and the weighted/unweighted pair is enough to reach
! every crossing; a second rank would add nothing and this stays single-rank.
!
! `use mpi` and `use mpi_f08` cannot share a scoping unit, so the f08 half lives
! in a module of its own, as test/buffer_detach.f90 does.

module dist_graph_weights_f08_part
  use mpi_f08
  implicit none
  private
  public :: check_f08
contains

  subroutine check_f08()
    type(MPI_Comm) :: graph, empty
    integer :: sources(1), destinations(1), degrees(1)
    integer :: in_sources(1), in_destinations(1)
    integer :: indegree, outdegree
    logical :: weighted

    sources(1) = 0
    destinations(1) = 0
    degrees(1) = 1

    ! IN, through both constructors
    call MPI_Dist_graph_create(MPI_COMM_SELF, 1, sources, degrees, &
         destinations, MPI_UNWEIGHTED, MPI_INFO_NULL, .false., graph)
    call MPI_Dist_graph_neighbors_count(graph, indegree, outdegree, weighted)
    if (indegree /= 1) stop 21
    if (outdegree /= 1) stop 22
    ! An unweighted graph must report itself so -- 8.5.5 -- which is the one
    ! observable consequence of the sentinel having arrived intact.
    if (weighted) stop 23

    ! OUT: the sentinel says "do not give me weights", and MPI must write none.
    call MPI_Dist_graph_neighbors(graph, 1, in_sources, MPI_UNWEIGHTED, &
         1, in_destinations, MPI_UNWEIGHTED)
    if (in_sources(1) /= 0) stop 24
    if (in_destinations(1) /= 0) stop 25
    call MPI_Comm_free(graph)

    call MPI_Dist_graph_create_adjacent(MPI_COMM_SELF, 1, sources, MPI_UNWEIGHTED, &
         1, destinations, MPI_UNWEIGHTED, MPI_INFO_NULL, .false., graph)
    call MPI_Dist_graph_neighbors(graph, 1, in_sources, MPI_UNWEIGHTED, &
         1, in_destinations, MPI_UNWEIGHTED)
    if (in_sources(1) /= 0) stop 26
    call MPI_Comm_free(graph)

    ! MPI_WEIGHTS_EMPTY, which is what a rank with no edges must pass
    call MPI_Dist_graph_create_adjacent(MPI_COMM_SELF, 0, sources, MPI_WEIGHTS_EMPTY, &
         0, destinations, MPI_WEIGHTS_EMPTY, MPI_INFO_NULL, .false., empty)
    call MPI_Dist_graph_neighbors_count(empty, indegree, outdegree, weighted)
    if (indegree /= 0) stop 27
    if (outdegree /= 0) stop 28
    call MPI_Comm_free(empty)
  end subroutine check_f08

end module dist_graph_weights_f08_part

module dist_graph_weights_f90_part
  use mpi
  implicit none
  private
  public :: check_f90
contains

  subroutine check_f90()
    integer :: graph, empty
    integer :: sources(1), destinations(1), degrees(1)
    integer :: in_sources(1), in_destinations(1)
    integer :: indegree, outdegree
    logical :: weighted
    integer :: ierror

    sources(1) = 0
    destinations(1) = 0
    degrees(1) = 1

    call MPI_Dist_graph_create(MPI_COMM_SELF, 1, sources, degrees, &
         destinations, MPI_UNWEIGHTED, MPI_INFO_NULL, .false., graph, ierror)
    if (ierror /= MPI_SUCCESS) stop 11
    call MPI_Dist_graph_neighbors_count(graph, indegree, outdegree, weighted, ierror)
    if (indegree /= 1 .or. outdegree /= 1) stop 12
    if (weighted) stop 13
    call MPI_Dist_graph_neighbors(graph, 1, in_sources, MPI_UNWEIGHTED, &
         1, in_destinations, MPI_UNWEIGHTED, ierror)
    if (ierror /= MPI_SUCCESS) stop 14
    if (in_sources(1) /= 0 .or. in_destinations(1) /= 0) stop 15
    call MPI_Comm_free(graph, ierror)

    call MPI_Dist_graph_create_adjacent(MPI_COMM_SELF, 0, sources, MPI_WEIGHTS_EMPTY, &
         0, destinations, MPI_WEIGHTS_EMPTY, MPI_INFO_NULL, .false., empty, ierror)
    if (ierror /= MPI_SUCCESS) stop 16
    call MPI_Comm_free(empty, ierror)
  end subroutine check_f90

end module dist_graph_weights_f90_part

program dist_graph_weights
  use dist_graph_weights_f90_part, only: check_f90
  use dist_graph_weights_f08_part, only: check_f08
  implicit none
  integer :: ierror

  call check_mpif_h()
  call MPI_Init(ierror)
  call check_f90()
  call check_f08()
  call check_mpif_h_calls()
  call MPI_Finalize(ierror)

contains

  ! Nothing to do before MPI_Init; the subroutine exists so that mpif.h's own
  ! declarations are compiled in a scoping unit of their own, neither module
  ! having exported them.
  subroutine check_mpif_h()
  end subroutine check_mpif_h

  subroutine check_mpif_h_calls()
    implicit none
    include 'mpif.h'
    integer :: graph
    integer :: sources(1), destinations(1)
    integer :: in_sources(1), in_destinations(1)
    integer :: indegree, outdegree
    logical :: weighted
    integer :: ierr

    sources(1) = 0
    destinations(1) = 0

    call MPI_Dist_graph_create_adjacent(MPI_COMM_SELF, 1, sources, MPI_UNWEIGHTED, &
         1, destinations, MPI_UNWEIGHTED, MPI_INFO_NULL, .false., graph, ierr)
    if (ierr /= MPI_SUCCESS) stop 31
    call MPI_Dist_graph_neighbors_count(graph, indegree, outdegree, weighted, ierr)
    if (indegree /= 1 .or. outdegree /= 1) stop 32
    if (weighted) stop 33
    call MPI_Dist_graph_neighbors(graph, 1, in_sources, MPI_UNWEIGHTED, &
         1, in_destinations, MPI_UNWEIGHTED, ierr)
    if (ierr /= MPI_SUCCESS) stop 34
    if (in_sources(1) /= 0 .or. in_destinations(1) /= 0) stop 35
    call MPI_Comm_free(graph, ierr)
  end subroutine check_mpif_h_calls

end program dist_graph_weights
