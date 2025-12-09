program init_f08
  use mpi_f08
  implicit none
  call mpi_init()
  call mpi_finalize()
end program init_f08
