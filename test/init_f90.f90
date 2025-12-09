program init_f90
  use mpi
  implicit none
  call mpi_init()
  call mpi_finalize()
end program init_f90
