      include "mpif_attr_fns.h"

      double precision, external :: MPI_Wtick, PMPI_Wtick
      double precision, external :: MPI_Wtime, PMPI_Wtime

      integer(MPI_ADDRESS_KIND), external :: MPI_Aint_add, PMPI_Aint_add
      integer(MPI_ADDRESS_KIND), external :: MPI_Aint_diff,             &
     &     PMPI_Aint_diff

      interface mpi_sizeof

      subroutine mpif_sizeof_logical1(x, size, ierror)
      implicit none
      logical*1                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_logical1

      subroutine mpif_sizeof_logical2(x, size, ierror)
      implicit none
      logical*2                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_logical2

      subroutine mpif_sizeof_logical4(x, size, ierror)
      implicit none
      logical*4                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_logical4

      subroutine mpif_sizeof_logical8(x, size, ierror)
      implicit none
      logical*8                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_logical8

!     subroutine mpif_sizeof_logical16(x, size, ierror)
!     implicit none
!     logical*16                     :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_sizeof_logical16

      subroutine mpif_sizeof_integer1(x, size, ierror)
      implicit none
      integer*1                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_integer1

      subroutine mpif_sizeof_integer2(x, size, ierror)
      implicit none
      integer*2                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_integer2

      subroutine mpif_sizeof_integer4(x, size, ierror)
      implicit none
      integer*4                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_integer4

      subroutine mpif_sizeof_integer8(x, size, ierror)
      implicit none
      integer*8                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_integer8

!     subroutine mpif_sizeof_integer16(x, size, ierror)
!     implicit none
!     integer*16                     :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_sizeof_integer16

!     subroutine mpif_sizeof_real2(x, size, ierror)
!     implicit none
!     real*2                         :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_sizeof_real2

      subroutine mpif_sizeof_real4(x, size, ierror)
      implicit none
      real*4                         :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_real4

      subroutine mpif_sizeof_real8(x, size, ierror)
      implicit none
      real*8                         :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_real8

!     subroutine mpif_sizeof_real16(x, size, ierror)
!     implicit none
!     real*16                        :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_sizeof_real16

!     subroutine mpif_sizeof_complex4(x, size, ierror)
!     implicit none
!     complex*4                      :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_sizeof_complex4

      subroutine mpif_sizeof_complex8(x, size, ierror)
      implicit none
      complex*8                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_complex8

      subroutine mpif_sizeof_complex16(x, size, ierror)
      implicit none
      complex*16                     :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_sizeof_complex16

!     subroutine mpif_sizeof_complex32(x, size, ierror)
!     implicit none
!     complex*32                     :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_sizeof_complex32

      end interface mpi_sizeof

!     The same generic under the name MPI-5.0 section 15.2 asks for. It cannot
!     share the specifics above: these are external procedures, and an external
!     procedure may appear in only one interface body per scope, so PMPI_SIZEOF
!     gets a second set of bodies from src/mpif_sizeof.c. The mpi module, whose
!     specifics are module procedures, does reuse them -- see src/mpif_types.F90.

      interface pmpi_sizeof

      subroutine mpif_psizeof_logical1(x, size, ierror)
      implicit none
      logical*1                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_logical1

      subroutine mpif_psizeof_logical2(x, size, ierror)
      implicit none
      logical*2                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_logical2

      subroutine mpif_psizeof_logical4(x, size, ierror)
      implicit none
      logical*4                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_logical4

      subroutine mpif_psizeof_logical8(x, size, ierror)
      implicit none
      logical*8                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_logical8

!     subroutine mpif_psizeof_logical16(x, size, ierror)
!     implicit none
!     logical*16                     :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_psizeof_logical16

      subroutine mpif_psizeof_integer1(x, size, ierror)
      implicit none
      integer*1                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_integer1

      subroutine mpif_psizeof_integer2(x, size, ierror)
      implicit none
      integer*2                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_integer2

      subroutine mpif_psizeof_integer4(x, size, ierror)
      implicit none
      integer*4                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_integer4

      subroutine mpif_psizeof_integer8(x, size, ierror)
      implicit none
      integer*8                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_integer8

!     subroutine mpif_psizeof_integer16(x, size, ierror)
!     implicit none
!     integer*16                     :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_psizeof_integer16

!     subroutine mpif_psizeof_real2(x, size, ierror)
!     implicit none
!     real*2                         :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_psizeof_real2

      subroutine mpif_psizeof_real4(x, size, ierror)
      implicit none
      real*4                         :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_real4

      subroutine mpif_psizeof_real8(x, size, ierror)
      implicit none
      real*8                         :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_real8

!     subroutine mpif_psizeof_real16(x, size, ierror)
!     implicit none
!     real*16                        :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_psizeof_real16

!     subroutine mpif_psizeof_complex4(x, size, ierror)
!     implicit none
!     complex*4                      :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_psizeof_complex4

      subroutine mpif_psizeof_complex8(x, size, ierror)
      implicit none
      complex*8                      :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_complex8

      subroutine mpif_psizeof_complex16(x, size, ierror)
      implicit none
      complex*16                     :: x(*)
      integer, intent(out)           :: size
      integer, intent(out), optional :: ierror
      end subroutine mpif_psizeof_complex16

!     subroutine mpif_psizeof_complex32(x, size, ierror)
!     implicit none
!     complex*32                     :: x(*)
!     integer, intent(out)           :: size
!     integer, intent(out), optional :: ierror
!     end subroutine mpif_psizeof_complex32

      end interface pmpi_sizeof
