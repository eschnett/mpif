subroutine mpif_init
  use mpi
  implicit none

  logical*1, parameter :: true1                 = .true.
  logical*1, parameter :: false1                = .false.
  logical*2, parameter :: true2                 = .true.
  logical*2, parameter :: false2                = .false.
  logical*4, parameter :: true4                 = .true.
  logical*4, parameter :: false4                = .false.
  logical*8, parameter :: true8                 = .true.
  logical*8, parameter :: false8                = .false.
  logical*16, parameter :: true16               = .true.
  logical*16, parameter :: false16              = .false.

  MPI_BOTTOM_PTR                                = 0
  MPI_IN_PLACE_PTR                              = 1
  MPI_BUFFER_AUTOMATIC_PTR                      = 2

  MPI_ARGV_NULL_PTR                             = 0
  MPI_ARGVS_NULL_PTR                            = 0
  MPI_ERRCODES_IGNORE_PTR                       = 0
  MPI_STATUS_IGNORE_PTR                         = 0
  MPI_STATUSES_IGNORE_PTR                       = 0
  MPI_UNWEIGHTED_PTR                            = 10
  MPI_WEIGHTS_EMPTY_PTR                         = 11

  call MPI_Abi_set_fortran_booleans(1, true1, false1)
  call MPI_Abi_set_fortran_booleans(2, true2, false2)
  call MPI_Abi_set_fortran_booleans(4, true4, false4)
  call MPI_Abi_set_fortran_booleans(8, true8, false8)
  call MPI_Abi_set_fortran_booleans(16, true16, false16)
end subroutine mpif_init
