// Two of MPICH's Fortran suite tests fail under Open MPI on what looks like one
// question: what name does an object have before anyone sets one?
//
//   f77/rma/winnamef and its f90/f08 copies:  "Did not get empty name from new
//   window", from MPI_Win_get_name on a window straight out of MPI_Win_create.
//
//   f77/datatype/typesnamef and its copies:   "(type2) Expected length 0, got
//   17", from MPI_Type_get_name on the result of MPI_Type_dup, the original
//   having been named.
//
// MPI-5.0 section 7.8 gives MPI_WIN_GET_NAME "the name previously stored on the
// window, or an empty string if no such name exists", and the same sentence for
// datatypes; only "named predefined datatypes have the default names of the
// datatype name". So a fresh window has no name, and a derived datatype has none
// until one is set. What the standard does not say is whether MPI_TYPE_DUP
// carries the name over.
//
// No Fortran is involved either way, which is what this is here to show. Prints
// what it finds and exits 1 if anything disagrees with the paragraph above.
//
//   mpicc -o ompi-object-names ompi-object-names.c && mpiexec -n 1 ./ompi-object-names

#include <mpi.h>
#include <stdio.h>
#include <string.h>

static int errs = 0;

static void report(const char *what, const char *name, int len) {
  printf("  %-34s len=%2d name=\"%s\"\n", what, len, name);
}

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  char name[MPI_MAX_OBJECT_NAME];
  int len;

  // A window nobody has named
  int buf[10];
  MPI_Win win;
  MPI_Win_create(buf, sizeof buf, sizeof buf[0], MPI_INFO_NULL, MPI_COMM_SELF,
                 &win);
  memset(name, 'X', sizeof name);
  len = -1;
  MPI_Win_get_name(win, name, &len);
  report("fresh window", name, len);
  if (len != 0) {
    printf("    ERROR: MPI-5.0 requires an empty string here\n");
    ++errs;
  }

  // The same for a window that has been named, which must work
  MPI_Win_set_name(win, "MyName");
  memset(name, 'X', sizeof name);
  len = -1;
  MPI_Win_get_name(win, name, &len);
  report("window named MyName", name, len);
  if (len != 6 || strcmp(name, "MyName") != 0) {
    printf("    ERROR: expected len=6 name=\"MyName\"\n");
    ++errs;
  }
  MPI_Win_free(&win);

  // A derived datatype nobody has named
  MPI_Datatype vec, dup;
  MPI_Type_vector(10, 1, 100, MPI_INT, &vec);
  memset(name, 'X', sizeof name);
  len = -1;
  MPI_Type_get_name(vec, name, &len);
  report("fresh derived datatype", name, len);
  if (len != 0) {
    printf("    ERROR: MPI-5.0 requires an empty string here\n");
    ++errs;
  }

  // A predefined datatype, which the standard says does have a name
  memset(name, 'X', sizeof name);
  len = -1;
  MPI_Type_get_name(MPI_INT, name, &len);
  report("MPI_INT", name, len);
  if (len == 0) {
    printf("    ERROR: predefined datatypes have default names\n");
    ++errs;
  }

  // The dup of a named datatype. MPI-5.0 does not say whether the name comes
  // with it, so this one is reported and not judged.
  MPI_Type_set_name(vec, "a vector type");
  MPI_Type_dup(vec, &dup);
  memset(name, 'X', sizeof name);
  len = -1;
  MPI_Type_get_name(dup, name, &len);
  report("dup of a named datatype", name, len);
  printf("    (not judged: MPI-5.0 says nothing about the name on MPI_TYPE_DUP)\n");
  MPI_Type_free(&dup);
  MPI_Type_free(&vec);

  printf("%s: %d error%s against MPI-5.0 section 7.8\n", argv[0], errs,
         errs == 1 ? "" : "s");
  MPI_Finalize();
  return errs != 0;
}
