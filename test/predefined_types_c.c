// Does this MPI's ABI accept predefined datatype handles the way mpif assumes?
//
// mpif's generated MPIF_Type_fromint and MPIF_Type_toint short-circuit
// predefined handles: rather than calling MPI_Type_fromint, they cast the
// Fortran INTEGER straight to an MPI_Datatype, on the reasoning that the ABI
// *defines* MPI_INTEGER as ((MPI_Datatype)0x00000219), so the Fortran handle and
// the C handle are the same number. That workaround was added for MPICH, whose
// own conversions mishandle predefined handles.
//
// If the reasoning does not hold for some implementation -- if its ABI layer
// expects to translate the value rather than receive it -- then every mpif call
// taking a predefined datatype passes an invalid handle.
//
// No Fortran and no mpif here: this is C against the MPI ABI alone, so a failure
// implicates either the ABI or mpif's assumption about it, and nothing else.
//
// Each datatype is probed four ways, in increasing order of what they assume.
// The first failure locates the problem: if (a) fails the ABI cannot handle its
// own constants; if (a) passes but (d) fails, mpif's short-circuit is invalid
// here and the two implementations need different treatment.
//
// Probes (c) and (d) are the ones mpif depends on, so they run before (b), which
// is known to abort outright on MPICH -- see
// https://github.com/pmodels/mpich/issues/7916. Output is unbuffered so that an
// abort inside MPI does not swallow the results collected so far.

#include <mpi.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int probe(const char *label, MPI_Datatype dt, int predefined,
                 int with_toint) {
  char name[MPI_MAX_OBJECT_NAME];
  int len = -1, failures = 0;

  const int fits_in_fint =
      (uintptr_t)dt == (uintptr_t)(intptr_t)(MPI_Fint)(intptr_t)dt;
  printf("  %-22s value=0x%08lx  %s\n", label, (unsigned long)(uintptr_t)dt,
         fits_in_fint ? "fits in MPI_Fint"
                      : "DOES NOT fit in MPI_Fint (32 bits)");

  // (a) the C constant, used directly, as any C program would
  memset(name, 0, sizeof name);
  if (MPI_Type_get_name(dt, name, &len) != MPI_SUCCESS) {
    printf("      (a) get_name(constant)             FAILED"
           "  <- the ABI rejects its own constant\n");
    ++failures;
  } else {
    printf("      (a) get_name(constant)             '%s' len=%d\n", name, len);
  }

  // (d) what mpif does for *predefined* handles only: cast the Fortran INTEGER,
  // skipping fromint. Doing this to a derived handle would simply truncate it,
  // which is not something mpif does, so do not pretend it is a probe.
  if (!predefined) {
    printf("      (d) skipped: mpif casts only predefined handles\n");
  } else {
  const MPI_Datatype cast = (MPI_Datatype)(intptr_t)(int)(intptr_t)dt;
  memset(name, 0, sizeof name);
  len = -1;
  if (MPI_Type_get_name(cast, name, &len) != MPI_SUCCESS) {
    printf("      (d) get_name(cast, as mpif does)   FAILED"
           "  <- mpif's short-circuit is invalid here\n");
    ++failures;
  } else {
    printf("      (d) get_name(cast, as mpif does)   '%s' len=%d\n", name, len);
  }
  }

  // Probes (b) and (c) are what mpif relies on for derived handles, which cannot
  // be cast, so they must run there. Only the predefined case needs gating:
  // MPI_Type_toint aborts on builtins under MPICH.
  if (predefined && !with_toint)
    return failures;

  // (b) to an integer handle, and (c) back again
  const MPI_Fint as_int = MPI_Type_toint(dt);
  printf("      (b) toint                          %d (0x%x)\n", (int)as_int,
         (unsigned)as_int);
  if (predefined && as_int != (MPI_Fint)(intptr_t)dt) {
    printf("          ^ differs from the constant\n");
    ++failures;
  }

  // This is the round trip every mpif wrapper performs on a derived handle:
  // out through toint into a Fortran INTEGER, back in through fromint.
  const MPI_Datatype round = MPI_Type_fromint(as_int);
  printf("      (c) fromint(toint)                 0x%08lx%s\n",
         (unsigned long)(uintptr_t)round,
         round == dt ? "" : "  <- does not round-trip");
  if (round != dt)
    ++failures;

  // (f) The integer must not look like a predefined handle.
  //
  // mpif's MPIF_Type_fromint short-circuits any integer equal to a predefined
  // ABI value by casting it straight to an MPI_Datatype, instead of calling
  // MPI_Type_fromint. If this implementation numbers derived types with small
  // indices, they land in that same range, and mpif turns a derived type into
  // whichever predefined type shares its number -- without any error.
  if (!predefined) {
    const int collides =
        (uintptr_t)(intptr_t)as_int >= 0x100 && (uintptr_t)(intptr_t)as_int <= 0x2eb;
    printf("      (f) integer handle vs the predefined range 0x100-0x2eb: %s\n",
           collides ? "COLLIDES  <- mpif would mistake this for a predefined type"
                    : "outside it");
    if (collides)
      ++failures;
  }

  // A handle that survives the round trip should still be usable
  char again[MPI_MAX_OBJECT_NAME];
  int againlen = -1;
  memset(again, 0, sizeof again);
  if (MPI_Type_get_name(round, again, &againlen) != MPI_SUCCESS) {
    printf("      (e) get_name(after round trip)     FAILED"
           "  <- the handle does not survive INTEGER conversion\n");
    ++failures;
  } else {
    printf("      (e) get_name(after round trip)     '%s' len=%d\n", again,
           againlen);
  }

  return failures;
}

int main(int argc, char **argv) {
  setvbuf(stdout, NULL, _IONBF, 0);
  MPI_Init(&argc, &argv);

  // Return errors rather than aborting, so one bad datatype does not hide the
  // rest. An implementation that asserts internally will still abort.
  MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN);

  // MPI_TYPE_TOINT aborts on MPICH for builtins, so ask for it only when
  // MPIF_PROBE_TOINT is set in the environment
  const int with_toint = getenv("MPIF_PROBE_TOINT") != NULL;
  if (!with_toint)
    printf("(probes b and c skipped; set MPIF_PROBE_TOINT=1 to include them,\n"
           " but note they abort on MPICH -- see mpich issue 7916)\n");

  printf("predefined datatypes:\n");
  int failures = 0;
  failures += probe("MPI_INTEGER", MPI_INTEGER, 1, with_toint);
  failures += probe("MPI_REAL", MPI_REAL, 1, with_toint);
  failures += probe("MPI_COMPLEX", MPI_COMPLEX, 1, with_toint);
  failures += probe("MPI_DOUBLE_PRECISION", MPI_DOUBLE_PRECISION, 1, with_toint);
  failures += probe("MPI_INT", MPI_INT, 1, with_toint);

  failures += probe("MPI_LOGICAL", MPI_LOGICAL, 1, with_toint);
  failures += probe("MPI_CHARACTER", MPI_CHARACTER, 1, with_toint);
  failures += probe("MPI_DOUBLE_COMPLEX", MPI_DOUBLE_COMPLEX, 1, with_toint);

  // The pair types, which is where this probe found its bug: Open MPI 5
  // dereferences MPI_2INTEGER's ABI value (0x232) as an internal pointer and
  // crashes, which is what kills f77/datatype/typenamef and allctypesf. That is
  // https://github.com/open-mpi/ompi/issues/14243, and it is a SIGSEGV inside
  // MPI_Type_get_name, so it cannot be caught and reported the way every other
  // result here can -- it takes the whole probe down with it. Off by default so
  // that the suite still reports the results above on Open MPI; set
  // MPIF_PROBE_PAIRTYPES=1 to check whether the upstream fix has landed.
  if (getenv("MPIF_PROBE_PAIRTYPES") == NULL) {
    printf("pair types skipped; set MPIF_PROBE_PAIRTYPES=1 to include them, but\n"
           " note they crash Open MPI 5 -- see ompi issue 14243\n");
  } else {
    failures += probe("MPI_2INTEGER", MPI_2INTEGER, 1, with_toint);
    failures += probe("MPI_2REAL", MPI_2REAL, 1, with_toint);
    failures += probe("MPI_2DOUBLE_PRECISION", MPI_2DOUBLE_PRECISION, 1, with_toint);
  }

  // A derived type, for contrast: its handle is a real one, so no short-circuit
  // applies and this should work whatever the answer above
  MPI_Datatype derived;
  if (MPI_Type_contiguous(4, MPI_INTEGER, &derived) == MPI_SUCCESS) {
    MPI_Type_commit(&derived);
    printf("derived datatype, for contrast:\n");
    failures += probe("contiguous(4)", derived, 0, with_toint);
    MPI_Type_free(&derived);
  }

  printf("\n%d unexpected result(s)\n", failures);
  MPI_Finalize();
  return failures != 0;
}
