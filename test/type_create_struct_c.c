#include <mpi.h>

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  int count = 2;
  int array_of_blocklengths[2] = {1, 1};
  MPI_Aint array_of_displacements[2] = {0, 8};
  MPI_Datatype array_of_types[2] = {MPI_DOUBLE, MPI_DOUBLE};
  MPI_Datatype newtype;
  MPI_Type_create_struct(count, array_of_blocklengths, array_of_displacements,
                         array_of_types, &newtype);

  MPI_Type_commit(&newtype);

  MPI_Type_free(&newtype);

  MPI_Finalize();
  return 0;
}
