C     The PMPI names through mpif.h. MPI-5.0 section 15.2 requires every
C     MPI procedure to be reachable under a second name that a profiling
C     tool does not replace, and section 19.1.5 requires it of mpif.h by
C     name.
C
C     mpif.h needs no interfaces for most of this -- its interfaces are
C     implicit, so PMPI_SEND links straight to `pmpi_send_` -- which is
C     exactly why the four function-valued names below are the ones
C     worth a test. They are the only PMPI names mpif.h ever declared,
C     and for a long time they were declared and not defined, so a
C     program that called one got a link error rather than a diagnostic:
C     "Undefined symbols: _pmpi_wtime_". Nothing but a program that
C     calls them can catch that coming back.
C
C     Fixed form on purpose: mpif.h has to be valid in fixed and free
C     form alike, and so does everything it declares.

      program pmpi_f
      implicit none

      include "mpif.h"

      integer ierror, rank, size, sz, extent
      double precision t0, t1, tick
      integer(MPI_ADDRESS_KIND) base, total, diff
      integer keyval, i4v(2)
      logical flag

      call PMPI_Init(ierror)
      if (ierror .ne. MPI_SUCCESS) stop 1

      call PMPI_Comm_rank(MPI_COMM_WORLD, rank, ierror)
      if (ierror .ne. MPI_SUCCESS) stop 2
      call PMPI_Comm_size(MPI_COMM_WORLD, size, ierror)
      if (ierror .ne. MPI_SUCCESS) stop 3
      if (rank .lt. 0 .or. rank .ge. size) stop 4

C     The four that were declared and undefined. PMPI_WTICK is positive
C     and PMPI_WTIME does not go backwards.
      tick = PMPI_Wtick()
      if (tick .le. 0.0d0) stop 5
      t0 = PMPI_Wtime()
      t1 = PMPI_Wtime()
      if (t1 .lt. t0) stop 6

      base = 1024
      total = PMPI_Aint_add(base, 16_MPI_ADDRESS_KIND)
      if (total .ne. 1040) stop 7
      diff = PMPI_Aint_diff(total, base)
      if (diff .ne. 16) stop 8

C     PMPI_SIZEOF, a generic over its own set of specifics: mpif.h
C     declares its procedures EXTERNAL, and an external procedure may
C     appear in only one interface body per scope, so this generic
C     cannot share MPI_SIZEOF's. As there, the specifics are
C     assumed-size, so the argument is an array.
      call PMPI_Sizeof(i4v, sz, ierror)
      if (ierror .ne. MPI_SUCCESS) stop 9
      if (sz .ne. 4) stop 10

C     A predefined callback passed to a PMPI routine. The callback keeps
C     its MPI_ name, there being no PMPI_ form of it and none wanted: the
C     standard lists these in A.1.1 among the defined constants, with an
C     ABI value of 0 or 1, so there is no entry point to name-shift. That
C     makes mixing the prefixes here the supported idiom rather than a
C     compromise, and it is what a program against either implementation
C     has to write. What is asserted is that it works: the address still
C     reaches src/mpif_callbacks.c on the PMPI path, and MPI still gets
C     its sentinel.
      call PMPI_Comm_create_keyval(MPI_COMM_NULL_COPY_FN,
     &     MPI_COMM_NULL_DELETE_FN, keyval, 0_MPI_ADDRESS_KIND,
     &     ierror)
      if (ierror .ne. MPI_SUCCESS) stop 11
      call PMPI_Comm_set_attr(MPI_COMM_WORLD, keyval,
     &     42_MPI_ADDRESS_KIND, ierror)
      if (ierror .ne. MPI_SUCCESS) stop 12
      call PMPI_Comm_get_attr(MPI_COMM_WORLD, keyval, base, flag,
     &     ierror)
      if (ierror .ne. MPI_SUCCESS) stop 13
      if (.not. flag) stop 14
      call PMPI_Comm_free_keyval(keyval, ierror)
      if (ierror .ne. MPI_SUCCESS) stop 15

C     One of the removed MPI-1 routines, which the ABI does not have and
C     mpif provides anyway; its PMPI form goes through
C     PMPI_TYPE_GET_EXTENT.
      call PMPI_Type_extent(MPI_INTEGER, extent, ierror)
      if (ierror .ne. MPI_SUCCESS) stop 16
      if (extent .ne. 4) stop 17

      print *, 'pmpi_f: all ok'

      call PMPI_Finalize(ierror)
      if (ierror .ne. MPI_SUCCESS) stop 18

      end
