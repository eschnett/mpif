// Standalone reproducer: Open MPI rejects an empty info value.
//
// MPI_Info_set(info, key, "") returns MPI_ERR_INFO_VALUE under Open MPI and
// MPI_SUCCESS under MPICH. The empty string looks like a legal value, and the
// standard gives it a defined meaning on two reserved keys, so a portable
// program cannot set them under Open MPI.
//
// Build and run against either implementation:
//
//   mpicc -o ompi-empty-info-value ompi-empty-info-value.c
//   ./ompi-empty-info-value
//
// Observed with Open MPI v6.1.0a1 (git 090cfce, 2026-07-24) and MPICH 5.0.1 on
// macOS 15 (arm64). No Fortran involved: this is pure C against MPI_Info_set.
//
// Open MPI:
//
//   non-empty value                        MPI_SUCCESS
//   empty value                            MPI_ERR_INFO_VALUE   <- differs
//   empty value, mpi_memory_alloc_kinds    MPI_ERR_INFO_VALUE   <- differs
//   empty value, mpi_assert_memory_alloc_kinds  MPI_ERR_INFO_VALUE  <- differs
//   empty key                              MPI_ERR_INFO_KEY
//
// MPICH:
//
//   non-empty value                        MPI_SUCCESS
//   empty value                            MPI_SUCCESS
//   empty value, mpi_memory_alloc_kinds    MPI_SUCCESS
//   empty value, mpi_assert_memory_alloc_kinds  MPI_SUCCESS
//   empty key                              MPI_ERR_INFO_KEY
//
// Expected: every case except the empty key succeeds, and the program exits 0.
// The empty key is rejected by both and is included only to show that the two
// checks are being told apart.
//
// Why the empty value looks legal, from MPI-5.0:
//
//   - MPI_INFO_SET, section 10: "If either key or value are longer than the
//     respective maximum length, the call raises an error of class
//     MPI_ERR_INFO_KEY or MPI_ERR_INFO_VALUE, respectively." Length is the only
//     stated reason to raise it.
//   - The error class table, section 9: "MPI_ERR_INFO_VALUE  Value longer than
//     MPI_MAX_INFO_VAL."
//   - Section 10 gives the empty value a meaning on two reserved keys. For both
//     "mpi_memory_alloc_kinds" and "mpi_assert_memory_alloc_kinds": "A value
//     corresponding to the empty string represents no memory allocation kinds."
//     Under Open MPI that value cannot be set, so there is no way to say "no
//     memory allocation kinds" through the info object.
//
// Where it comes from: ompi/mpi/c/info_set.c.in rejects a zero-length value
// alongside the over-long and NULL cases,
//
//     value_length = (value) ? (int)strlen (value) : 0;
//     if ((NULL == value) || (0 == value_length) ||
//         (@MPI_MAX_INFO_VAL@ <= value_length)) {
//         return OMPI_ERRHANDLER_INVOKE (MPI_COMM_WORLD, MPI_ERR_INFO_VALUE,
//                                        FUNC_NAME);
//     }
//
// The `(0 == value_length)` clause is the one at issue; dropping it would leave
// the NULL and length checks intact. The doc comment immediately above that
// function describes only the length rule, matching the standard: "If either key
// or value is greater than the allowed maxima, MPI_ERR_INFO_KEY and
// MPI_ERR_INFO_VALUE are raised."
//
// The zero-length *key* check on the preceding lines is a separate question and
// is not what this reports: MPICH rejects an empty key too.

#include <mpi.h>

#include <stdio.h>
#include <string.h>

static int failures = 0;

static void check(MPI_Info info, const char *what, const char *key,
                  const char *value, int expect_success) {
  const int err = MPI_Info_set(info, key, value);

  int class = MPI_SUCCESS;
  MPI_Error_class(err, &class);

  char name[MPI_MAX_ERROR_STRING];
  int len = 0;
  memset(name, 0, sizeof name);
  if (err == MPI_SUCCESS) {
    snprintf(name, sizeof name, "MPI_SUCCESS");
  } else if (class == MPI_ERR_INFO_VALUE) {
    snprintf(name, sizeof name, "MPI_ERR_INFO_VALUE");
  } else if (class == MPI_ERR_INFO_KEY) {
    snprintf(name, sizeof name, "MPI_ERR_INFO_KEY");
  } else {
    MPI_Error_string(err, name, &len);
  }

  const int ok = (err == MPI_SUCCESS) == (expect_success != 0);
  printf("  %-44s %-20s %s\n", what, name, ok ? "" : "<- differs");
  if (!ok)
    ++failures;
}

int main(int argc, char **argv) {
  setvbuf(stdout, NULL, _IONBF, 0);
  MPI_Init(&argc, &argv);

  // Report errors rather than aborting, so every case is exercised
  MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);

  char version[MPI_MAX_LIBRARY_VERSION_STRING];
  int version_len = 0;
  memset(version, 0, sizeof version);
  MPI_Get_library_version(version, &version_len);
  printf("%.*s\n", (int)strcspn(version, "\n"), version);

  MPI_Info info;
  MPI_Info_create(&info);

  printf("MPI_Info_set:\n");
  check(info, "non-empty value", "key", "value", 1);
  check(info, "empty value", "key", "", 1);

  // The two reserved keys whose empty value the standard defines
  check(info, "empty value, mpi_memory_alloc_kinds", "mpi_memory_alloc_kinds",
        "", 1);
  check(info, "empty value, mpi_assert_memory_alloc_kinds",
        "mpi_assert_memory_alloc_kinds", "", 1);

  // Rejected by both implementations; here to keep the two checks apart
  check(info, "empty key (expected to fail)", "", "value", 0);

  MPI_Info_free(&info);

  printf("\n%d unexpected result(s)\n", failures);
  MPI_Finalize();
  return failures != 0;
}
