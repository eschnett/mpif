// Do the MPI_Type_create_f90_* datatypes survive the ABI's own handle
// conversion? That is what trf90, trf08, createf90, createf08 and createf90types
// need of them, and what they fail on with "Invalid datatype".
//
// Pure C: if the round trip breaks here, no Fortran binding is involved.

#include <mpi.h>
#include <stdio.h>

static int failures = 0;

static void check(const char *what, MPI_Datatype t) {
  int f = MPI_Type_toint(t);
  MPI_Datatype back = MPI_Type_fromint(f);
  printf("  %-34s toint=%-12d round-trips=%s", what, f, back == t ? "yes" : "NO");

  // The use the tests make of it: build a derived type on top.
  MPI_Datatype ctype;
  int err = MPI_Type_contiguous(19, back, &ctype);
  printf("  Type_contiguous=%s", err == MPI_SUCCESS ? "ok" : "FAILED");
  if (err == MPI_SUCCESS)
    MPI_Type_free(&ctype);
  else
    ++failures;

  // And what createf90/createf08 do: ask for the envelope.
  int ni, na, nc, nt, combiner;
  err = MPI_Type_get_envelope(back, &ni, &na, &nt, &combiner);
  (void)nc;
  printf("  get_envelope=%s\n", err == MPI_SUCCESS ? "ok" : "FAILED");
  if (err != MPI_SUCCESS)
    ++failures;

  if (back != t)
    ++failures;
}

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);
  MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);

  MPI_Datatype t;
  int err;

  printf("MPI_Type_create_f90_real:\n");
  err = MPI_Type_create_f90_real(15, MPI_UNDEFINED, &t);
  if (err != MPI_SUCCESS)
    printf("  create failed\n"), ++failures;
  else
    check("f90_real(15, MPI_UNDEFINED)", t);

  printf("MPI_Type_create_f90_integer:\n");
  err = MPI_Type_create_f90_integer(8, &t);
  if (err != MPI_SUCCESS)
    printf("  create failed\n"), ++failures;
  else
    check("f90_integer(8)", t);

  printf("MPI_Type_create_f90_complex:\n");
  err = MPI_Type_create_f90_complex(15, MPI_UNDEFINED, &t);
  if (err != MPI_SUCCESS)
    printf("  create failed\n"), ++failures;
  else
    check("f90_complex(15, MPI_UNDEFINED)", t);

  // For contrast, a plain predefined type and a derived one.
  printf("for contrast:\n");
  check("MPI_DOUBLE_PRECISION", MPI_DOUBLE_PRECISION);
  MPI_Datatype derived;
  MPI_Type_contiguous(4, MPI_INT, &derived);
  MPI_Type_commit(&derived);
  check("a derived contiguous type", derived);

  MPI_Finalize();
  printf(failures ? "BROKEN (%d)\n" : "all ok (%d failures)\n", failures);
  return failures != 0;
}
