// Standalone reproducer: with the MPI standard ABI, MPICH aborts when an
// attribute delete callback fires for a predefined datatype.
//
// Build and run against an ABI-enabled MPICH:
//
//   mpicc -o mpich-abi-attr-bug mpich-abi-attr-bug.c
//   ./mpich-abi-attr-bug
//
// Observed with MPICH 5.0.1 on macOS 15 (arm64), configured
//
//   --enable-mpi-abi --enable-cxx=no --enable-static=no --with-device=ch3
//
// A derived datatype and a communicator are fine; a predefined datatype aborts:
//
//   datatype MPI_Type_dup(MPI_INT)  set set-again(delete) ok (delete called 1 time(s))
//   comm     MPI_COMM_WORLD         set set-again(delete) ok (delete called 1 time(s))
//   datatype MPI_INT                set set-again(delete) Assertion failed in file
//     ../src/binding/abi/mpi_abi_util.h at line 140: 0
//   0  libpmpi_abi.0.dylib  MPL_backtrace_show + 28
//   1  libpmpi_abi.0.dylib  MPIR_Assert_fail + 52
//   2  libpmpi_abi.0.dylib  ABI_Handle_from_mpi + 760
//   3  libpmpi_abi.0.dylib  MPII_Attr_delete_c_proxy + 48
//   4  libpmpi_abi.0.dylib  MPIR_Call_attr_delete + 88
//   5  libpmpi_abi.0.dylib  MPIR_Type_set_attr_impl + 88
//   6  libpmpi_abi.0.dylib  MPII_Type_set_attr + 1000
//
// Expected: all three cases print "ok" and the program exits 0.
//
// MPI_Type_set_attr and MPI_Type_get_attr therefore appear unusable on any
// predefined datatype in an ABI build.
//
// Where it comes from: MPII_Attr_delete_c_proxy (src/mpi/attr/attrutil.c)
// converts the handle back to an ABI handle as it calls the user's callback,
//
//     ret = user_function(ABI_Handle_from_mpi(handle), keyval, attrib_val,
//                         extra_state);
//
// which for a datatype reaches ABI_Datatype_from_mpi
// (src/binding/abi/mpi_abi_util.h). That reverse-searches
// abi_datatype_builtins[] for the internal handle and asserts when it is not
// found. The forward direction, ABI_Datatype_to_mpi, is an indexed lookup in
// the same table and works -- which is how the datatype got in.
//
// Each step is printed before it is attempted, so the last line of output
// identifies where it stopped.
//
// Fixed on `main` by 2eb9a812, and then made unreachable: MPICH grew a
// weak-symbols-without-alias branch, so Darwin no longer builds the second
// library whose second copy of the table was the whole defect. Kept as the
// check, not as an open report -- it passes on the commit
// ci-scripts/install-mpich.sh pins.

#include <mpi.h>

#include <stdint.h>
#include <stdio.h>

static int type_delete_calls;
static int comm_delete_calls;

static int type_copy(MPI_Datatype datatype, int keyval, void *extra_state,
                     void *attribute_val_in, void *attribute_val_out,
                     int *flag) {
  (void)datatype, (void)keyval, (void)extra_state;
  *(void **)attribute_val_out = attribute_val_in;
  *flag = 1;
  return MPI_SUCCESS;
}

static int type_delete(MPI_Datatype datatype, int keyval, void *attribute_val,
                       void *extra_state) {
  (void)datatype, (void)keyval, (void)attribute_val, (void)extra_state;
  ++type_delete_calls;
  return MPI_SUCCESS;
}

static int comm_copy(MPI_Comm comm, int keyval, void *extra_state,
                     void *attribute_val_in, void *attribute_val_out,
                     int *flag) {
  (void)comm, (void)keyval, (void)extra_state;
  *(void **)attribute_val_out = attribute_val_in;
  *flag = 1;
  return MPI_SUCCESS;
}

static int comm_delete(MPI_Comm comm, int keyval, void *attribute_val,
                       void *extra_state) {
  (void)comm, (void)keyval, (void)attribute_val, (void)extra_state;
  ++comm_delete_calls;
  return MPI_SUCCESS;
}

// Setting an attribute twice is what makes MPI delete the first value, and so
// what invokes the delete callback.
static int try_datatype(const char *name, MPI_Datatype datatype) {
  printf("  datatype %-24s ", name);
  fflush(stdout);

  int keyval = MPI_KEYVAL_INVALID;
  int err = MPI_Type_create_keyval(type_copy, type_delete, &keyval, NULL);
  if (err != MPI_SUCCESS) {
    printf("MPI_Type_create_keyval failed (%d)\n", err);
    return 1;
  }

  printf("set ");
  fflush(stdout);
  err = MPI_Type_set_attr(datatype, keyval, (void *)(intptr_t)1);
  if (err != MPI_SUCCESS) {
    printf("MPI_Type_set_attr failed (%d)\n", err);
    return 1;
  }

  printf("set-again(delete) ");
  fflush(stdout);
  const int before = type_delete_calls;
  err = MPI_Type_set_attr(datatype, keyval, (void *)(intptr_t)2);
  if (err != MPI_SUCCESS) {
    printf("MPI_Type_set_attr failed (%d)\n", err);
    return 1;
  }

  printf("ok (delete called %d time(s))\n", type_delete_calls - before);
  MPI_Type_free_keyval(&keyval);
  return 0;
}

static int try_comm(const char *name, MPI_Comm comm) {
  printf("  comm     %-24s ", name);
  fflush(stdout);

  int keyval = MPI_KEYVAL_INVALID;
  int err = MPI_Comm_create_keyval(comm_copy, comm_delete, &keyval, NULL);
  if (err != MPI_SUCCESS) {
    printf("MPI_Comm_create_keyval failed (%d)\n", err);
    return 1;
  }

  printf("set ");
  fflush(stdout);
  err = MPI_Comm_set_attr(comm, keyval, (void *)(intptr_t)1);
  if (err != MPI_SUCCESS) {
    printf("MPI_Comm_set_attr failed (%d)\n", err);
    return 1;
  }

  printf("set-again(delete) ");
  fflush(stdout);
  const int before = comm_delete_calls;
  err = MPI_Comm_set_attr(comm, keyval, (void *)(intptr_t)2);
  if (err != MPI_SUCCESS) {
    printf("MPI_Comm_set_attr failed (%d)\n", err);
    return 1;
  }

  printf("ok (delete called %d time(s))\n", comm_delete_calls - before);
  MPI_Comm_free_keyval(&keyval);
  return 0;
}

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);
  MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);

  int abi_major, abi_minor;
  MPI_Abi_get_version(&abi_major, &abi_minor);
  char library[MPI_MAX_LIBRARY_VERSION_STRING];
  int resultlen;
  MPI_Get_library_version(library, &resultlen);
  printf("MPI ABI %d.%d, implementation:\n%s\n", abi_major, abi_minor, library);

  int failures = 0;

  // Not predefined, so ABI_Datatype_from_mpi takes its pointer path rather
  // than the table lookup
  MPI_Datatype derived;
  MPI_Type_dup(MPI_INT, &derived);
  failures += try_datatype("MPI_Type_dup(MPI_INT)", derived);
  MPI_Type_free(&derived);

  // For contrast: ABI_Comm_from_mpi handles the predefined communicators
  // explicitly, and this works
  failures += try_comm("MPI_COMM_WORLD", MPI_COMM_WORLD);

  // A predefined datatype, which aborts
  failures += try_datatype("MPI_INT", MPI_INT);

  printf("\n%d case(s) reported an error; reaching this line at all means the\n"
         "assertion did not fire.\n",
         failures);

  MPI_Finalize();
  return failures != 0;
}
