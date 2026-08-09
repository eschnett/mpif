! MPI_BOTTOM through an assumed-rank dummy. The Fortran sentinel lives at the
! C constant's address -- address zero in the standard ABI -- and the
! descriptor a compiler builds for an actual argument at that address must
! carry it intact to the cdesc layer, which recognises it and skips the walk.
! MPI_Get_address exercises the address-semantics buffer crossing on the way.

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
