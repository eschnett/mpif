module mpif_types
  use mpif_constants

  implicit none
  public
  save

  ! MPI_SIZEOF takes an argument "of any type", which a Fortran generic can only
  ! approximate: it needs one specific procedure per type, kind and rank. There
  ! are two per type here, one taking a scalar and one taking an assumed-size
  ! array, which between them cover rank 0 and rank 1. An actual argument of rank
  ! two or more still resolves to nothing -- MPICH's own binding stops in exactly
  ! the same place, and MPI_SIZEOF is deprecated in MPI-4.0, its `mpi_f08` form
  ! removed and Fortran's own storage_size() the replacement.
  !
  ! `size` and `ierror` are INTEGER for every specific, whatever the type of `x`.

  interface MPI_Sizeof
     module procedure mpif_sizeof_logical1
     module procedure mpif_sizeof_logical1_v
     module procedure mpif_sizeof_logical2
     module procedure mpif_sizeof_logical2_v
     module procedure mpif_sizeof_logical4
     module procedure mpif_sizeof_logical4_v
     module procedure mpif_sizeof_logical8
     module procedure mpif_sizeof_logical8_v
#ifdef MPIF_HAVE_LOGICAL16
     module procedure mpif_sizeof_logical16
     module procedure mpif_sizeof_logical16_v
#endif
     module procedure mpif_sizeof_integer1
     module procedure mpif_sizeof_integer1_v
     module procedure mpif_sizeof_integer2
     module procedure mpif_sizeof_integer2_v
     module procedure mpif_sizeof_integer4
     module procedure mpif_sizeof_integer4_v
     module procedure mpif_sizeof_integer8
     module procedure mpif_sizeof_integer8_v
#ifdef MPIF_HAVE_INTEGER16
     module procedure mpif_sizeof_integer16
     module procedure mpif_sizeof_integer16_v
#endif
#ifdef MPIF_HAVE_REAL2
     module procedure mpif_sizeof_real2
     module procedure mpif_sizeof_real2_v
#endif
     module procedure mpif_sizeof_real4
     module procedure mpif_sizeof_real4_v
     module procedure mpif_sizeof_real8
     module procedure mpif_sizeof_real8_v
#ifdef MPIF_HAVE_REAL16
     module procedure mpif_sizeof_real16
     module procedure mpif_sizeof_real16_v
#endif
#ifdef MPIF_HAVE_COMPLEX4
     module procedure mpif_sizeof_complex4
     module procedure mpif_sizeof_complex4_v
#endif
     module procedure mpif_sizeof_complex8
     module procedure mpif_sizeof_complex8_v
     module procedure mpif_sizeof_complex16
     module procedure mpif_sizeof_complex16_v
#ifdef MPIF_HAVE_COMPLEX32
     module procedure mpif_sizeof_complex32
     module procedure mpif_sizeof_complex32_v
#endif
     module procedure mpif_sizeof_character
     module procedure mpif_sizeof_character_v
  end interface MPI_Sizeof

  ! MPI_SIZEOF again under the name MPI-5.0 section 15.2 asks for. It costs
  ! nothing but this block: a module procedure may be a specific of more than one
  ! generic, so the same bodies serve both names. Neither implementation provides
  ! a PMPI_SIZEOF -- `nm` finds no pmpi_sizeof in MPICH's libmpifort in any
  ! spelling -- but the standard makes no exception for it, and here the exception
  ! would cost more to argue than to close.
  !
  ! mpif.h cannot borrow the specifics this way. There they are external
  ! procedures, and an external procedure may appear in only one interface body
  ! per scope, so include/mpif_functions.h declares a second set of names over the
  ! mpif_psizeof_* bodies in src/mpif_sizeof.c.
  interface PMPI_Sizeof
     module procedure mpif_sizeof_logical1
     module procedure mpif_sizeof_logical1_v
     module procedure mpif_sizeof_logical2
     module procedure mpif_sizeof_logical2_v
     module procedure mpif_sizeof_logical4
     module procedure mpif_sizeof_logical4_v
     module procedure mpif_sizeof_logical8
     module procedure mpif_sizeof_logical8_v
#ifdef MPIF_HAVE_LOGICAL16
     module procedure mpif_sizeof_logical16
     module procedure mpif_sizeof_logical16_v
#endif
     module procedure mpif_sizeof_integer1
     module procedure mpif_sizeof_integer1_v
     module procedure mpif_sizeof_integer2
     module procedure mpif_sizeof_integer2_v
     module procedure mpif_sizeof_integer4
     module procedure mpif_sizeof_integer4_v
     module procedure mpif_sizeof_integer8
     module procedure mpif_sizeof_integer8_v
#ifdef MPIF_HAVE_INTEGER16
     module procedure mpif_sizeof_integer16
     module procedure mpif_sizeof_integer16_v
#endif
#ifdef MPIF_HAVE_REAL2
     module procedure mpif_sizeof_real2
     module procedure mpif_sizeof_real2_v
#endif
     module procedure mpif_sizeof_real4
     module procedure mpif_sizeof_real4_v
     module procedure mpif_sizeof_real8
     module procedure mpif_sizeof_real8_v
#ifdef MPIF_HAVE_REAL16
     module procedure mpif_sizeof_real16
     module procedure mpif_sizeof_real16_v
#endif
#ifdef MPIF_HAVE_COMPLEX4
     module procedure mpif_sizeof_complex4
     module procedure mpif_sizeof_complex4_v
#endif
     module procedure mpif_sizeof_complex8
     module procedure mpif_sizeof_complex8_v
     module procedure mpif_sizeof_complex16
     module procedure mpif_sizeof_complex16_v
#ifdef MPIF_HAVE_COMPLEX32
     module procedure mpif_sizeof_complex32
     module procedure mpif_sizeof_complex32_v
#endif
     module procedure mpif_sizeof_character
     module procedure mpif_sizeof_character_v
  end interface PMPI_Sizeof

contains

  subroutine mpif_sizeof_logical1(x, size, ierror)
    logical*1 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 1
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical1

  subroutine mpif_sizeof_logical1_v(x, size, ierror)
    logical*1 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 1
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical1_v

  subroutine mpif_sizeof_logical2(x, size, ierror)
    logical*2 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 2
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical2

  subroutine mpif_sizeof_logical2_v(x, size, ierror)
    logical*2 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 2
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical2_v

  subroutine mpif_sizeof_logical4(x, size, ierror)
    logical*4 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 4
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical4

  subroutine mpif_sizeof_logical4_v(x, size, ierror)
    logical*4 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 4
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical4_v

  subroutine mpif_sizeof_logical8(x, size, ierror)
    logical*8 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 8
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical8

  subroutine mpif_sizeof_logical8_v(x, size, ierror)
    logical*8 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 8
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical8_v

#ifdef MPIF_HAVE_LOGICAL16

  subroutine mpif_sizeof_logical16(x, size, ierror)
    logical*16 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 16
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical16

  subroutine mpif_sizeof_logical16_v(x, size, ierror)
    logical*16 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 16
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_logical16_v
#endif

  subroutine mpif_sizeof_integer1(x, size, ierror)
    integer*1 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 1
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer1

  subroutine mpif_sizeof_integer1_v(x, size, ierror)
    integer*1 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 1
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer1_v

  subroutine mpif_sizeof_integer2(x, size, ierror)
    integer*2 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 2
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer2

  subroutine mpif_sizeof_integer2_v(x, size, ierror)
    integer*2 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 2
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer2_v

  subroutine mpif_sizeof_integer4(x, size, ierror)
    integer*4 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 4
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer4

  subroutine mpif_sizeof_integer4_v(x, size, ierror)
    integer*4 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 4
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer4_v

  subroutine mpif_sizeof_integer8(x, size, ierror)
    integer*8 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 8
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer8

  subroutine mpif_sizeof_integer8_v(x, size, ierror)
    integer*8 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 8
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer8_v

#ifdef MPIF_HAVE_INTEGER16

  subroutine mpif_sizeof_integer16(x, size, ierror)
    integer*16 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 16
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer16

  subroutine mpif_sizeof_integer16_v(x, size, ierror)
    integer*16 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 16
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_integer16_v
#endif

#ifdef MPIF_HAVE_REAL2

  subroutine mpif_sizeof_real2(x, size, ierror)
    real*2 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 2
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_real2

  subroutine mpif_sizeof_real2_v(x, size, ierror)
    real*2 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 2
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_real2_v
#endif

  subroutine mpif_sizeof_real4(x, size, ierror)
    real*4 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 4
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_real4

  subroutine mpif_sizeof_real4_v(x, size, ierror)
    real*4 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 4
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_real4_v

  subroutine mpif_sizeof_real8(x, size, ierror)
    real*8 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 8
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_real8

  subroutine mpif_sizeof_real8_v(x, size, ierror)
    real*8 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 8
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_real8_v

#ifdef MPIF_HAVE_REAL16

  subroutine mpif_sizeof_real16(x, size, ierror)
    real*16 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 16
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_real16

  subroutine mpif_sizeof_real16_v(x, size, ierror)
    real*16 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 16
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_real16_v
#endif

#ifdef MPIF_HAVE_COMPLEX4

  subroutine mpif_sizeof_complex4(x, size, ierror)
    complex*4 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 4
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_complex4

  subroutine mpif_sizeof_complex4_v(x, size, ierror)
    complex*4 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 4
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_complex4_v
#endif

  subroutine mpif_sizeof_complex8(x, size, ierror)
    complex*8 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 8
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_complex8

  subroutine mpif_sizeof_complex8_v(x, size, ierror)
    complex*8 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 8
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_complex8_v

  subroutine mpif_sizeof_complex16(x, size, ierror)
    complex*16 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 16
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_complex16

  subroutine mpif_sizeof_complex16_v(x, size, ierror)
    complex*16 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 16
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_complex16_v

#ifdef MPIF_HAVE_COMPLEX32

  subroutine mpif_sizeof_complex32(x, size, ierror)
    complex*32 :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 32
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_complex32

  subroutine mpif_sizeof_complex32_v(x, size, ierror)
    complex*32 :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 32
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_complex32_v
#endif

  subroutine mpif_sizeof_character(x, size, ierror)
    character :: x
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 1
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_character

  subroutine mpif_sizeof_character_v(x, size, ierror)
    character :: x(*)
    integer, intent(out)           :: size
    integer, intent(out)           :: ierror
    size = 1
    ierror = MPI_SUCCESS
  end subroutine mpif_sizeof_character_v

end module mpif_types
