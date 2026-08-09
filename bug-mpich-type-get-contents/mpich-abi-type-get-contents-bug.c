// MPI_Type_get_contents converts entries the implementation never filled.
//
// The standard-ABI wrapper allocates a temporary with MPL_malloc, calls the
// implementation, and then converts `max_datatypes` entries -- the caller's
// maximum, not the number the datatype actually has:
//
//     if (max_datatypes > 0)
//         array_of_datatypes = MPL_malloc(sizeof(MPI_Datatype) * max_datatypes, ...);
//     int ret = internal_Type_get_contents(...);
//     for (int i = 0; i < max_datatypes; i++)
//         array_of_datatypes_abi[i] = ABI_Datatype_from_mpi(array_of_datatypes[i]);
//
// MPL_malloc does not initialise, so the surplus is converted from whatever was on
// the heap. ABI_Datatype_from_mpi either finds a builtin handle that is not in
// abi_datatype_builtins[] and aborts -- "Assertion failed in file
// src/binding/abi/mpi_abi_util.h at line 140" -- or decides the garbage is not
// builtin and hands back a pointer derived from it.
//
// This probe is written to show the *read* rather than the abort, because whether
// it aborts depends on what the heap held: MPICH's own createf90types aborts on
// Linux and passes on macOS for that reason, and the same assert is why typecntsf,
// typecntsf90 and typecntsf08 are carried as `flaky`. A contiguous type has exactly
// one entry; ask for four and the other three should be MPI_DATATYPE_NULL.
//
// Not a caller error: MPI-5.0 requires an empty array_of_datatypes for a datatype
// from MPI_TYPE_CREATE_F90_*, so asking for more entries than exist is something a
// conforming program does. MPICH's createf90types passes max_datatypes = 1 for a
// type whose envelope reports 0.
//
// Pure C, no Fortran involved. Exits nonzero when a surplus entry was written.
//
// Fixed upstream on `main` by 31d79547ba, which callocs the temporary and skips
// the zero entries when converting back -- so the surplus is now left exactly as
// the caller passed it in, rather than set to the null handle. The check below
// therefore asks whether the entries were *touched*, seeded with a sentinel: a
// probe that insisted on MPI_DATATYPE_NULL would report a fixed MPICH as broken,
// which it did before this was rewritten. The standard requires nothing of the
// surplus; the defect was the conversion, not the value.

#include <mpi.h>
#include <stdint.h>
#include <stdio.h>

enum { MAXD = 4 };

// Seeded into the surplus entries and expected back unchanged. Never printed
// through MPI_Type_toint, which would dereference it.
#define SENTINEL ((MPI_Datatype)(uintptr_t)0xDEADBEEF)

int main(int argc, char **argv) {
  MPI_Init(&argc, &argv);
  MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);

  // Dirty the heap first, so that a fresh page of zeros is less likely to hide
  // the read behind a value that happens to look like a null handle
  for (int i = 0; i < 64; i++) {
    MPI_Datatype scratch;
    MPI_Type_contiguous(3, MPI_INT, &scratch);
    MPI_Type_commit(&scratch);
    MPI_Type_free(&scratch);
  }

  MPI_Datatype dt;
  MPI_Type_contiguous(7, MPI_DOUBLE, &dt);
  MPI_Type_commit(&dt);

  int nints, nadds, ntypes, combiner;
  MPI_Type_get_envelope(dt, &nints, &nadds, &ntypes, &combiner);
  printf("a contiguous type: envelope reports ntypes=%d\n", ntypes);

  int ints[MAXD];
  MPI_Aint adds[MAXD];
  MPI_Datatype dts[MAXD];
  for (int i = 0; i < MAXD; i++)
    dts[i] = SENTINEL;

  int err = MPI_Type_get_contents(dt, MAXD, MAXD, MAXD, ints, adds, dts);
  printf("MPI_Type_get_contents with max_datatypes=%d: err=%d\n", MAXD, err);

  int bad = 0;
  for (int i = 0; i < MAXD; i++) {
    if (i < ntypes) {
      printf("  dts[%d] = %-14d filled by the implementation\n", i, MPI_Type_toint(dts[i]));
      continue;
    }
    // Either answer is fine: untouched is what a fixed wrapper leaves, and the
    // null handle is what a wrapper that pre-fills the surplus leaves. What is
    // not fine is anything else, which can only have come from the conversion.
    int ok = dts[i] == SENTINEL || dts[i] == MPI_DATATYPE_NULL;
    printf("  dts[%d] = %-14p %s\n", i, (void *)dts[i],
           ok ? "untouched or null, as it should be"
              : "WRITTEN -- converted from uninitialised memory");
    if (!ok)
      ++bad;
  }

  MPI_Type_free(&dt);
  MPI_Finalize();
  printf(bad ? "BROKEN (%d surplus entries were written)\n" : "all ok (%d)\n", bad);
  return bad != 0;
}
