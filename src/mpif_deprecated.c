// Deprecated MPI-1 attribute routines, for MPI libraries that do not have them.
//
// MPI-2.0 deprecated MPI_Keyval_create, MPI_Keyval_free, MPI_Attr_put,
// MPI_Attr_get and MPI_Attr_delete, and MPI-4.0 removed them. The ABI header
// still declares them, but an implementation is free not to provide them:
// MPICH's libmpi_abi exports all five, Open MPI's exports none.
//
// mpif cannot simply drop the Fortran bindings, because MPI_KEYVAL_CREATE and
// friends are what `use mpi` and mpif.h are expected to offer, and the MPICH
// test suite exercises them. So define them here when the MPI library does not.
// CMake compiles this file only in that case, so on MPICH the library's own
// implementations are used unchanged.
//
// Each is a direct forward to its MPI-2 replacement. The C signatures are
// identical apart from the callback pointer types, and the predefined callback
// sentinels agree in value -- MPI_NULL_COPY_FN and MPI_COMM_NULL_COPY_FN are
// both 0x0, MPI_DUP_FN and MPI_COMM_DUP_FN are both 0x1 -- so the casts below
// preserve them, and a keyval created here behaves like one from
// MPI_Comm_create_keyval. That is what MPICH does internally too.
//
// The Fortran-visible difference between the MPI-1 and MPI-2 forms is the width
// of attribute values and extra state: default INTEGER rather than
// INTEGER(KIND=MPI_ADDRESS_KIND). That is handled in the generated wrappers and
// in src/mpif_callbacks.c, not here.

#include <mpi.h>

int MPI_Keyval_create(MPI_Copy_function *copy_fn, MPI_Delete_function *delete_fn,
                      int *keyval, void *extra_state) {
  return MPI_Comm_create_keyval((MPI_Comm_copy_attr_function *)copy_fn,
                                (MPI_Comm_delete_attr_function *)delete_fn,
                                keyval, extra_state);
}

int MPI_Keyval_free(int *keyval) { return MPI_Comm_free_keyval(keyval); }

int MPI_Attr_put(MPI_Comm comm, int keyval, void *attribute_val) {
  return MPI_Comm_set_attr(comm, keyval, attribute_val);
}

int MPI_Attr_get(MPI_Comm comm, int keyval, void *attribute_val, int *flag) {
  return MPI_Comm_get_attr(comm, keyval, attribute_val, flag);
}

int MPI_Attr_delete(MPI_Comm comm, int keyval) {
  return MPI_Comm_delete_attr(comm, keyval);
}
