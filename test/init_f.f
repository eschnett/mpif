      program init_f
      implicit none
      include('mpif.h')
      call mpi_init()
      call mpi_finalize()
      end
