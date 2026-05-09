#include <mpi.h>

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  int version, subversion;
  MPI_Get_version(&version, &subversion);
  printf("MPI standard version %d.%d\n", version, subversion);

  int abi_major, abi_minor;
  MPI_Abi_get_version(&abi_major, &abi_minor);
  printf("MPI ABI version %d.%d\n", abi_major, abi_minor);

  char library_version[MPI_MAX_LIBRARY_VERSION_STRING];
  int resultlen;
  MPI_Get_library_version(library_version, &resultlen);
  printf("MPI implementation:\n");
  printf("%s\n", library_version);

  printf("MPI ABI info:\n");
  MPI_Info abi_info;
  MPI_Abi_get_info(&abi_info);
  if (abi_info == MPI_INFO_NULL)
    abort();
  int nkeys;
  MPI_Info_get_nkeys(abi_info, &nkeys);
  for (int n = 0; n < nkeys; ++n) {
    char key[MPI_MAX_INFO_KEY];
    MPI_Info_get_nthkey(abi_info, n, key);
    char value[MPI_MAX_INFO_VAL];
    int flag;
    MPI_Info_get(abi_info, key, sizeof value - 1, value, &flag);
    if (!flag)
      abort();
    printf("   %d: %s=%s\n", n, key, value);
  }

  printf("MPI ABI Fortran booleans:\n");
  int logical_true, logical_false, is_set;
  MPI_Abi_get_fortran_booleans(4, &logical_true, &logical_false, &is_set);
  if (is_set) {
    printf("   logical: true=%d, false=%d\n", logical_true, logical_false);
  } else {
    printf("   logical: (not set)\n");
    abort(); // This should not happen
  }

  printf("MPI ABI Fortran info:\n");
  MPI_Info abi_fortran_info;
  MPI_Abi_get_fortran_info(&abi_fortran_info);

  if (abi_fortran_info == MPI_INFO_NULL) {
    printf("   (not set)\n");
    abort(); // This should not happen
  } else {
    int nkeys;
    MPI_Info_get_nkeys(abi_fortran_info, &nkeys);
    for (int n = 0; n < nkeys; ++n) {
      char key[MPI_MAX_INFO_KEY];
      MPI_Info_get_nthkey(abi_fortran_info, n, key);
      char value[MPI_MAX_INFO_VAL];
      int flag;
      MPI_Info_get(abi_fortran_info, key, sizeof value - 1, value, &flag);
      if (!flag)
        abort();
      printf("   %d: %s=%s\n", n, key, value);
    }
  }

  MPI_Finalize();
  return 0;
}
