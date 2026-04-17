program type_create_struct_f08
  use mpi_f08
  implicit none

  integer :: count
  integer :: array_of_blocklengths(2)
  integer(MPI_ADDRESS_KIND) :: array_of_displacements(2)
  type(MPI_Datatype) :: array_of_types(2)
  type(MPI_Datatype) :: newtype

  call MPI_Init()

  count = 2
  array_of_blocklengths = [1, 1]
  array_of_displacements = [0, 8]
  array_of_types = [MPI_DOUBLE_PRECISION, MPI_DOUBLE_PRECISION]
  print *, count
  print *, array_of_blocklengths
  print *, array_of_displacements
  print *, array_of_types
  call MPI_Type_create_struct(count, array_of_blocklengths, array_of_displacements, array_of_types, newtype)
  print *, newtype

  call MPI_Type_commit(newtype)
  print *, newtype

  call MPI_Type_free(newtype)
  print *, newtype

  call MPI_Finalize()
end program type_create_struct_f08
