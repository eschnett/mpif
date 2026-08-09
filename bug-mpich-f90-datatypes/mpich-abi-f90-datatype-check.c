// The other half of mpich-abi-f90-datatype-bug.c. That one asks whether
// MPI_Type_create_f90_* return anything usable at all, which is what the defect
// took away -- MPI_SUCCESS with MPI_DATATYPE_NULL, from the stubs an ABI build
// used to compile. This one asks whether what they return is *right*, so that a
// fix is held to more than non-nullness. Fixed on `main` by 66cd5734; both
// halves pass on the commit ci-scripts/install-mpich.sh pins.
//
// The expected values come from MPICH's own generated model,
// src/include/mpif90model.h: an integer map of {range: bytes} = {2:1, 4:2, 9:4,
// 18:8}, a real model {6,37} -> MPIR_REAL_INTERNAL and {15,307} ->
// MPIR_DOUBLE_PRECISION_INTERNAL. So f90_real(15) is double precision, 8 bytes;
// f90_integer(8) fits the range-9 kind, 4 bytes; f90_complex(15) is double
// complex, 16 bytes.
//
// "An unnamed predefined datatype" is MPI-5.0's own term for these, in its
// discussion of MPI_TYPE_GET_CONTENTS, which also requires that "an empty
// array_of_datatypes is returned" for one -- checked below. The envelope has to
// report the combiner and the (p, r) the type was created with, that being what
// MPI_TYPE_GET_CONTENTS on such a type is for.
//
// The last check, that the same request comes back as the same handle, is
// deliberately stronger than the standard: the standard gives a *matching* rule --
// a type "matches a datatype B if and only if B was returned by
// MPI_TYPE_CREATE_F90_REAL called with the same values for p and r or B is a
// duplicate of such a datatype" -- and matching does not oblige an implementation
// to hand back one handle. MPICH does, from the `f90Types` cache in
// create_f90.c, and that cache is part of what the patch restores, so a
// regression in it is worth catching here. Read a failure of that line as "MPICH
// changed", not as "MPICH is now non-conforming".
//
// Pure C, no Fortran involved. Exits nonzero on any disagreement.

#include <mpi.h>
#include <stdio.h>

static int bad = 0;

static void check(const char *what, MPI_Datatype t, MPI_Aint want_extent,
                  int want_combiner, int want_nints, int want_p, int want_r) {
  MPI_Aint lb, extent;
  MPI_Type_get_extent(t, &lb, &extent);

  int nints, nadds, ntypes, combiner;
  MPI_Type_get_envelope(t, &nints, &nadds, &ntypes, &combiner);

  // The integers are (r) for f90_integer and (p, r) for the other two
  int ints[2] = {-1, -1};
  if (nints >= 1 && nints <= 2) {
    MPI_Aint adr[1];
    MPI_Datatype dts[1];
    MPI_Type_get_contents(t, nints, 0, 0, ints, adr, dts);
  }

  int got_p = want_nints == 2 ? ints[0] : -1;
  int got_r = want_nints == 2 ? ints[1] : ints[0];

  printf("  %-18s extent=%2ld/%2ld  combiner=%3d/%3d  nints=%d/%d  p=%d/%d  r=%d/%d"
         "  ntypes=%d/0",
         what, (long)extent, (long)want_extent, combiner, want_combiner, nints,
         want_nints, got_p, want_p, got_r, want_r, ntypes);

  // The standard requires an empty array_of_datatypes for an unnamed predefined
  // datatype, so ntypes has to be zero
  int ok = extent == want_extent && combiner == want_combiner &&
           nints == want_nints && got_p == want_p && got_r == want_r &&
           ntypes == 0;
  printf("  %s\n", ok ? "ok" : "WRONG");
  if (!ok)
    ++bad;
}

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);

  MPI_Datatype r, i, c;
  MPI_Type_create_f90_real(15, MPI_UNDEFINED, &r);
  MPI_Type_create_f90_integer(8, &i);
  MPI_Type_create_f90_complex(15, MPI_UNDEFINED, &c);

  printf("values against MPICH's own mpif90model.h (got/want):\n");
  check("f90_real(15)", r, 8, MPI_COMBINER_F90_REAL, 2, 15, MPI_UNDEFINED);
  check("f90_integer(8)", i, 4, MPI_COMBINER_F90_INTEGER, 1, -1, 8);
  check("f90_complex(15)", c, 16, MPI_COMBINER_F90_COMPLEX, 2, 15, MPI_UNDEFINED);

  // Unnamed predefined, so the same request is the same type
  MPI_Datatype again;
  MPI_Type_create_f90_real(15, MPI_UNDEFINED, &again);
  printf("  the same request returns the same handle: %s\n",
         again == r ? "yes" : "NO");
  if (again != r)
    ++bad;

  MPI_Finalize();
  printf(bad ? "WRONG (%d)\n" : "all ok (%d disagreements)\n", bad);
  return bad != 0;
}
