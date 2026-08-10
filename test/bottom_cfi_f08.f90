! MPI_BOTTOM through an assumed-rank dummy. The Fortran sentinel is a COMMON
! block of mpif's own, so the descriptor a compiler builds for it carries that
! block's address, and the cdesc entry has to translate it into the ABI's
! (void*)0 -- one hoist, `q_buf = mpif_c_buffer(buf->base_addr)` -- before the
! walk guard can recognise it and skip the walk. MPI_Get_address exercises the
! address-semantics buffer crossing on the way. test/bottom.f90 does the same
! from mpif.h and the mpi module, which reach different entry points.

program bottom_cfi_f08
  use mpi_f08
  implicit none

  integer, target :: x, y
  integer(MPI_ADDRESS_KIND) :: addr_x(1), addr_y(1)
  type(MPI_Datatype) :: tx, ty

  call MPI_Init()

  call MPI_Get_address(x, addr_x(1))
  call MPI_Get_address(y, addr_y(1))
  call MPI_Type_create_hindexed_block(1, 1, addr_x, MPI_INT, tx)
  call MPI_Type_create_hindexed_block(1, 1, addr_y, MPI_INT, ty)
  call MPI_Type_commit(tx)
  call MPI_Type_commit(ty)

  x = 42
  y = 0
  call MPI_Sendrecv(MPI_BOTTOM, 1, tx, 0, 7, &
                    MPI_BOTTOM, 1, ty, 0, 7, &
                    MPI_COMM_SELF, MPI_STATUS_IGNORE)
  if (y /= 42) stop 1

  call MPI_Type_free(tx)
  call MPI_Type_free(ty)
  call MPI_Finalize()
end program bottom_cfi_f08
