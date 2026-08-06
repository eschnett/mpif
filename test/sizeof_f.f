C     MPI_SIZEOF and PMPI_SIZEOF through mpif.h, whose interfaces are
C     external, unlike the mpi module's module procedures in
C     src/mpif_types.F90. An external procedure may appear in only one
C     interface body per scope, which is why mpif.h's two generics get
C     their own bodies from src/mpif_sizeof.c rather than sharing the
C     module's (see the comment there).
C
C     Both generics used to have assumed-size specifics only, so a
C     scalar actual matched nothing under an explicit interface --
C     "There is no specific subroutine for the generic 'mpi_sizeof'".
C     This checks a scalar and a rank-1 array of a couple of types, for
C     both names.
C
C     Fixed form on purpose: mpif.h has to be valid in fixed and free
C     form alike, and so does everything it declares.

      program sizeof_f
      implicit none

      include "mpif.h"

      integer ierror, sz, ref

      integer i1, i1v(5)
      double precision d1, d1v(3)
      character ch1, ch1v(6)

      call MPI_Init(ierror)

      call MPI_Type_size(MPI_INTEGER, ref, ierror)
      call MPI_Sizeof(i1, sz, ierror)
      if (sz .ne. ref) stop 1
      call MPI_Sizeof(i1v, sz, ierror)
      if (sz .ne. ref) stop 2
      call PMPI_Sizeof(i1, sz, ierror)
      if (sz .ne. ref) stop 3
      call PMPI_Sizeof(i1v, sz, ierror)
      if (sz .ne. ref) stop 4

      call MPI_Type_size(MPI_DOUBLE_PRECISION, ref, ierror)
      call MPI_Sizeof(d1, sz, ierror)
      if (sz .ne. ref) stop 5
      call MPI_Sizeof(d1v, sz, ierror)
      if (sz .ne. ref) stop 6
      call PMPI_Sizeof(d1, sz, ierror)
      if (sz .ne. ref) stop 7
      call PMPI_Sizeof(d1v, sz, ierror)
      if (sz .ne. ref) stop 8

C     CHARACTER had no specific at all in mpif.h, scalar or array.
      call MPI_Type_size(MPI_CHARACTER, ref, ierror)
      call MPI_Sizeof(ch1, sz, ierror)
      if (sz .ne. ref) stop 9
      call MPI_Sizeof(ch1v, sz, ierror)
      if (sz .ne. ref) stop 10
      call PMPI_Sizeof(ch1, sz, ierror)
      if (sz .ne. ref) stop 11
      call PMPI_Sizeof(ch1v, sz, ierror)
      if (sz .ne. ref) stop 12

      print *, 'sizeof_f: all ok'

      call MPI_Finalize(ierror)

      end
