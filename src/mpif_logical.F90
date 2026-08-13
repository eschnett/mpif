! The bit patterns of Fortran's .TRUE. and .FALSE., published to C.
!
! They are not necessarily 1 and 0: gfortran and flang use 1, Intel uses -1.
! Only the Fortran compiler knows, and it is the compiler that builds mpif whose
! representation matters, since that is the one the user's LOGICAL arguments
! arrive in. TRANSFER hands it over, evaluated at compile time.
!
! This is the same arrangement as MPI_BOTTOM and the other sentinels in
! src/mpif_constants.c, with the direction reversed: there C defines the common
! block and Fortran reads it, here Fortran defines it and C reads it. See
! include/mpif_logical.h for the other half.
!
! A BLOCK DATA is the only way to give a common block an initial value, and it
! needs a reference to drag it out of a static archive. It has one:
! src/mpif_logical.c refers to both symbols, and delete this object from
! libmpif.a and the link fails saying so --
!
!     Undefined symbols: "_mpif_logical_true_", referenced from
!     _mpif_bool2logical in libmpif.a(mpif_logical.c.o)
!
! -- which is the point: nothing outside mpif declares these two common blocks,
! so a member that failed to come out is loud. The sentinels of
! src/mpif_constants.c are the opposite case, every consumer declaring them too,
! and there the same failure is silent; see "Static linking" in CODE.md.

block data mpif_logical_block

  implicit none

  ! TRANSFER is a constant expression here, so these are compile-time values
  integer, parameter :: true_value = transfer(.true., 0)
  integer, parameter :: false_value = transfer(.false., 0)

  integer :: MPIF_LOGICAL_TRUE
  common /MPIF_LOGICAL_TRUE/ MPIF_LOGICAL_TRUE
  data MPIF_LOGICAL_TRUE /true_value/

  integer :: MPIF_LOGICAL_FALSE
  common /MPIF_LOGICAL_FALSE/ MPIF_LOGICAL_FALSE
  data MPIF_LOGICAL_FALSE /false_value/

end block data mpif_logical_block
