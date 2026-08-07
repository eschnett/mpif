// Runtime consistency checks: mpif_check_version and mpif_check_environment.
//
// mpif is built against the MPI standard ABI, so the MPI library -- and mpif
// itself -- is resolved at run time and may differ from what the caller was
// compiled against. That opens failure modes no build step can catch: an
// mpiexec from a different implementation launching N independent singletons,
// a stale mpif shared library, mismatched ABI versions, one rank resolving a
// different library than the rest. The MPI standard itself frames the ABI
// version macros this way -- MPI-5.0 chapter 20 has them in the header "so
// that applications can check for consistency between the compilation
// environment and the properties of the implementation at runtime" -- and
// these two routines are that check, done once, in the library, instead of
// ad hoc in every application.
//
// mpif_check_version takes the *caller's* compile-time MPIF_VERSION,
// MPIF_SUBVERSION and MPIF_PATCH (include/mpif_constants.h) and compares them
// against the loaded library's own version, which CMake bakes in here as
// MPIF_VERSION_MAJOR/_MINOR/_PATCH from project(mpif VERSION ...). The rule is
// the one CMakeLists.txt already declares for configure time with
// `COMPATIBILITY SameMajorVersion`: the majors must be equal, and the loaded
// library must not be older than the caller in (minor, patch) -- an older
// library may lack entry points and constants the caller's headers already
// name. There is deliberately no mpif_get_version query: a query would invite
// every caller to reimplement this comparison, each slightly differently.
//
// mpif_check_environment checks everything it can about the running setup and
// aborts on the first inconsistency. What it may do depends on MPI's state:
// MPI-5.0 section 11.4.1, Table 11.1, lists the functions callable at any
// time, and of what is needed here that covers MPI_Initialized, MPI_Finalized,
// MPI_Get_version, MPI_Get_library_version and MPI_Abi_get_version -- but not
// MPI_Get_processor_name or MPI_Abi_get_fortran_booleans, and certainly no
// communication. So before MPI_Init or after MPI_Finalize only the version and
// library-name checks run, and the rest is skipped silently.
//
// When MPI is initialized and not finalized, the function is COLLECTIVE over
// MPI_COMM_WORLD: every process must call it, or the smoke test's collectives
// hang. Local checks run before the first collective, so a size mismatch
// aborts rather than hangs. The smoke test itself runs on an MPI_Comm_dup of
// MPI_COMM_WORLD, because a wildcard receive the application posted on
// MPI_COMM_WORLD before calling this would otherwise swallow the ring token.
//
// Optional environment variables, checked when set and ignored when not:
//   MPIF_MPI_LIBRARY  case-insensitive substring that MPI_Get_library_version's
//                     answer must contain, e.g. "MPICH" or "Open MPI"
//   MPIF_SIZE         exact size of MPI_COMM_WORLD
//   MPIF_NUM_NODES    exact number of distinct nodes (MPI_Get_processor_name)
//   MPIF_NODE_SIZE    exact number of processes on every node -- a node count
//                     alone cannot tell an even 4x4 layout from 13+1+1+1
// A malformed value ("MPIF_SIZE=abc") aborts rather than being ignored: a
// typo'd guard that guards nothing would defeat the purpose. The launcher
// variables PMI_SIZE, OMPI_COMM_WORLD_SIZE, SLURM_NTASKS and SLURM_NPROCS are
// read without opting in, but only to catch the wrong-mpiexec failure: when
// MPI_COMM_WORLD has size 1 and one of them says the launcher started more,
// the launched processes came up as independent singletons, which is what an
// mpiexec from a different implementation than the loaded library produces.
// The processes cannot see each other, so no collective can detect this; the
// environment is the only witness.
//
// Fortran calling convention as elsewhere in mpif: lowercase name with a
// trailing underscore, every argument by reference. The C-callable forms exist
// too; no C header is installed for them (nothing needs one yet), so a C
// caller declares `void mpif_check_version(int, int, int)` and
// `void mpif_check_environment(void)` itself.

#include <mpi.h>

#include <mpif_logical.h>

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef MPIF_VERSION_MAJOR
#error "MPIF_VERSION_MAJOR/_MINOR/_PATCH must be defined by the build system"
#endif

// The Fortran side of the internal version check, in src/mpif_check_fns.F90:
// reports the MPIF_VERSION/MPIF_SUBVERSION/MPIF_PATCH parameters of
// include/mpif_constants.h, which are hand-written and can drift from the
// project(... VERSION) that defined the macros above.
void mpif_check_header_version_(MPI_Fint *major, MPI_Fint *minor,
                                MPI_Fint *patch);

// Print "mpif: <routine>: <message>" and abort -- through MPI_Abort when that
// can work, so the whole job dies rather than one rank, and through abort()
// otherwise (and as the backstop should MPI_Abort return).
static void mpif_check_fail(const char *restrict const routine,
                            const char *restrict const fmt, ...) {
  fprintf(stderr, "mpif: %s: ", routine);
  va_list ap;
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fputc('\n', stderr);
  int initialized = 0, finalized = 0;
  MPI_Initialized(&initialized);
  MPI_Finalized(&finalized);
  if (initialized && !finalized)
    MPI_Abort(MPI_COMM_WORLD, 1);
  abort();
}

// Read a numeric environment variable. Returns 0 when unset or empty; aborts
// on a value that is not entirely a number.
static int mpif_check_getenv_long(const char *restrict const routine,
                                  const char *restrict const name,
                                  long *restrict const value) {
  const char *const str = getenv(name);
  if (!str || !*str)
    return 0;
  char *end;
  const long val = strtol(str, &end, 10);
  if (end == str || *end != '\0')
    mpif_check_fail(routine, "%s is set to \"%s\", which is not a number",
                    name, str);
  *value = val;
  return 1;
}

// Order the fixed-size, zero-padded processor-name records the node check
// gathers. memcmp over the whole record: the padding is zeroed, so equal
// names compare equal.
static int mpif_check_name_cmp(const void *a, const void *b) {
  return memcmp(a, b, MPI_MAX_PROCESSOR_NAME);
}

// Case-insensitive substring search. Hand-rolled: strcasestr is a GNU
// extension and C11 has nothing.
static int mpif_check_contains(const char *restrict const haystack,
                               const char *restrict const needle) {
  const size_t hlen = strlen(haystack);
  const size_t nlen = strlen(needle);
  for (size_t i = 0; i + nlen <= hlen; ++i) {
    size_t j = 0;
    while (j < nlen && tolower((unsigned char)haystack[i + j]) ==
                           tolower((unsigned char)needle[j]))
      ++j;
    if (j == nlen)
      return 1;
  }
  return 0;
}

void mpif_check_version(int major, int minor, int patch) {
  static const char routine[] = "mpif_check_version";
  if (major != MPIF_VERSION_MAJOR)
    mpif_check_fail(routine,
                    "caller compiled against mpif %d.%d.%d but the loaded "
                    "library is mpif %d.%d.%d: major versions differ and are "
                    "incompatible",
                    major, minor, patch, MPIF_VERSION_MAJOR,
                    MPIF_VERSION_MINOR, MPIF_VERSION_PATCH);
  if (MPIF_VERSION_MINOR < minor ||
      (MPIF_VERSION_MINOR == minor && MPIF_VERSION_PATCH < patch))
    mpif_check_fail(routine,
                    "caller compiled against mpif %d.%d.%d but the loaded "
                    "library is mpif %d.%d.%d: the loaded library is older "
                    "than the caller was compiled against",
                    major, minor, patch, MPIF_VERSION_MAJOR,
                    MPIF_VERSION_MINOR, MPIF_VERSION_PATCH);
}

void mpif_check_version_(const MPI_Fint *restrict const major,
                         const MPI_Fint *restrict const minor,
                         const MPI_Fint *restrict const patch) {
  mpif_check_version(*major, *minor, *patch);
}

void mpif_check_environment(void) {
  static const char routine[] = "mpif_check_environment";

  // mpif's own version, in its two independent spellings: the Fortran
  // parameters of include/mpif_constants.h against the CMake project version.
  // ci-scripts/check-headers.sh compares the same two statically; this
  // catches an install whose pieces come from different builds.
  MPI_Fint hdr_major, hdr_minor, hdr_patch;
  mpif_check_header_version_(&hdr_major, &hdr_minor, &hdr_patch);
  if (hdr_major != MPIF_VERSION_MAJOR || hdr_minor != MPIF_VERSION_MINOR ||
      hdr_patch != MPIF_VERSION_PATCH)
    mpif_check_fail(routine,
                    "mpif's own version is inconsistent: "
                    "include/mpif_constants.h says %d.%d.%d but the library "
                    "was built as %d.%d.%d",
                    (int)hdr_major, (int)hdr_minor, (int)hdr_patch,
                    MPIF_VERSION_MAJOR, MPIF_VERSION_MINOR,
                    MPIF_VERSION_PATCH);

  // The ABI version. MPI-5.0 chapter 20: MPI_Abi_get_version reports -1/-1
  // when the library does not implement the standard ABI at all; minor bumps
  // are backwards compatible, major bumps are not. So the runtime major must
  // equal the header's, and the runtime minor must not be smaller -- the
  // header may name handle types and constants an older minor lacks.
  int abi_major, abi_minor;
  MPI_Abi_get_version(&abi_major, &abi_minor);
  if (abi_major == -1)
    mpif_check_fail(routine,
                    "the loaded MPI library does not implement the MPI "
                    "standard ABI (MPI_Abi_get_version reports -1)");
  if (abi_major != MPI_ABI_VERSION ||
      (abi_major == MPI_ABI_VERSION && abi_minor < MPI_ABI_SUBVERSION))
    mpif_check_fail(routine,
                    "mpif was built against MPI ABI %d.%d but the loaded MPI "
                    "library implements ABI %d.%d, which is incompatible",
                    MPI_ABI_VERSION, MPI_ABI_SUBVERSION, abi_major, abi_minor);

  // The MPI version. Section 9.1.1 promises no ordering between the header's
  // MPI_VERSION and what MPI_Get_version reports; the ABI header pins 5.0. A
  // runtime reporting less implements an older API level, so entry points the
  // header declares may be missing and would fail only when first called; a
  // newer runtime is fine, additions being backwards compatible.
  int mpi_version, mpi_subversion;
  MPI_Get_version(&mpi_version, &mpi_subversion);
  if (mpi_version < MPI_VERSION ||
      (mpi_version == MPI_VERSION && mpi_subversion < MPI_SUBVERSION))
    mpif_check_fail(routine,
                    "mpif was built against MPI %d.%d but the loaded MPI "
                    "library implements MPI %d.%d, which is older",
                    MPI_VERSION, MPI_SUBVERSION, mpi_version, mpi_subversion);

  // The implementation, when the caller named the one it expects. The library
  // version string is free-form but starts with the implementation's name in
  // both MPICH and Open MPI; substring matching keeps "mpich", "MPICH 5.0.1"
  // and "Open MPI" all usable. Only the first line is echoed on failure --
  // MPICH's string is its entire configure line.
  char libver[MPI_MAX_LIBRARY_VERSION_STRING];
  memset(libver, 0, sizeof libver);
  int libverlen;
  MPI_Get_library_version(libver, &libverlen);
  libver[MPI_MAX_LIBRARY_VERSION_STRING - 1] = '\0';
  const char *const expected_library = getenv("MPIF_MPI_LIBRARY");
  if (expected_library && *expected_library &&
      !mpif_check_contains(libver, expected_library))
    mpif_check_fail(routine,
                    "MPIF_MPI_LIBRARY expects \"%s\" but the loaded MPI "
                    "library reports \"%.*s\"",
                    expected_library, (int)strcspn(libver, "\n"), libver);

  // Everything below needs more than Table 11.1 allows outside the
  // initialized-and-not-finalized window, so outside it the check ends here.
  int initialized = 0, finalized = 0;
  MPI_Initialized(&initialized);
  MPI_Finalized(&finalized);
  if (!initialized || finalized)
    return;

  // Fortran booleans. mpif reads .TRUE. and .FALSE. from the compiler that
  // built it (src/mpif_logical.F90) rather than from the library, because the
  // library reports whatever Fortran layer published its values -- see
  // src/mpif_logical.c for the reasoning. When the library *has* published
  // values and they differ, MPI_LOGICAL reductions are computed against the
  // wrong bit patterns, which is exactly the cross-compiler skew this
  // function exists to catch. Unset values pass: nothing has registered, and
  // registering here would be a behavioral change, not a check.
  MPI_Fint lib_true = 0, lib_false = 0;
  int booleans_set = 0;
  MPI_Abi_get_fortran_booleans((int)sizeof(MPI_Fint), &lib_true, &lib_false,
                               &booleans_set);
  if (booleans_set && (lib_true != mpif_bool2logical(1) ||
                       lib_false != mpif_bool2logical(0)))
    mpif_check_fail(routine,
                    "the loaded MPI library holds Fortran booleans "
                    ".TRUE.=%d/.FALSE.=%d but mpif's compiler uses %d/%d: a "
                    "different Fortran layer registered its representation, "
                    "and MPI_LOGICAL operations would use the wrong values",
                    (int)lib_true, (int)lib_false, (int)mpif_bool2logical(1),
                    (int)mpif_bool2logical(0));

  int size, rank;
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  // The wrong-mpiexec failure: an mpiexec from a different implementation
  // than the loaded library starts N processes that each initialize as an
  // independent singleton. They cannot see each other, so no MPI call can
  // detect it -- but the launcher's own environment can. Checked before any
  // collective, necessarily: each singleton would pass a size-1 smoke test.
  if (size == 1) {
    static const char *const launcher_vars[] = {
        "PMI_SIZE", "OMPI_COMM_WORLD_SIZE", "SLURM_NTASKS", "SLURM_NPROCS"};
    for (size_t i = 0; i < sizeof launcher_vars / sizeof *launcher_vars; ++i) {
      long launched;
      if (mpif_check_getenv_long(routine, launcher_vars[i], &launched) &&
          launched > 1)
        mpif_check_fail(routine,
                        "the launcher started %ld processes (%s=%ld) but "
                        "MPI_COMM_WORLD has size 1: this process initialized "
                        "as a singleton, which is what an mpiexec belonging "
                        "to a different MPI implementation than the loaded "
                        "library produces",
                        launched, launcher_vars[i], launched);
    }
  }

  // The expected size, when the caller stated one.
  long expected_size;
  if (mpif_check_getenv_long(routine, "MPIF_SIZE", &expected_size) &&
      size != expected_size)
    mpif_check_fail(routine,
                    "rank %d: MPIF_SIZE expects %ld processes but "
                    "MPI_COMM_WORLD has size %d",
                    rank, expected_size, size);

  // The smoke test, on a duplicate of MPI_COMM_WORLD (see the header comment
  // for why). From here on the function is collective.
  MPI_Comm comm;
  MPI_Comm_dup(MPI_COMM_WORLD, &comm);

  // Every rank must have resolved the same mpif and the same MPI library.
  // The last two entries carry MPIF_NUM_NODES and MPIF_NODE_SIZE (0 when
  // unset) rather than a version: whether the node check below runs must be
  // agreed collectively, or a variable exported to only some ranks would
  // leave the others out of the gather and hang it. Ranks that state an
  // expectation must agree on it; ranks where the variable is unset defer.
  long expected_nodes = 0, expected_node_size = 0;
  mpif_check_getenv_long(routine, "MPIF_NUM_NODES", &expected_nodes);
  mpif_check_getenv_long(routine, "MPIF_NODE_SIZE", &expected_node_size);
  static const char *const field_names[] = {
      "mpif major version", "mpif minor version", "mpif patch version",
      "MPI version",        "MPI subversion",     "MPI ABI version",
      "MPI ABI subversion", "MPIF_NUM_NODES",     "MPIF_NODE_SIZE"};
  enum { nfields = sizeof field_names / sizeof *field_names };
  const int local[nfields] = {MPIF_VERSION_MAJOR,
                              MPIF_VERSION_MINOR,
                              MPIF_VERSION_PATCH,
                              mpi_version,
                              mpi_subversion,
                              abi_major,
                              abi_minor,
                              (int)expected_nodes,
                              (int)expected_node_size};
  int vmin[nfields], vmax[nfields];
  MPI_Allreduce(local, vmin, nfields, MPI_INT, MPI_MIN, comm);
  MPI_Allreduce(local, vmax, nfields, MPI_INT, MPI_MAX, comm);
  for (int i = 0; i < nfields; ++i) {
    // The env-var fields tolerate unset (0); the version fields tolerate
    // nothing.
    const int is_env_field = i >= nfields - 2;
    const int consistent = is_env_field
                               ? local[i] == 0 || local[i] == vmax[i]
                               : vmin[i] == vmax[i];
    if (!consistent)
      mpif_check_fail(routine,
                      "rank %d: %s is %d here but %d..%d across "
                      "MPI_COMM_WORLD: the processes did not load the same "
                      "libraries or environment",
                      rank, field_names[i], local[i], vmin[i], vmax[i]);
  }

  // Same library, byte for byte. Bcast rather than a hash so that a failing
  // rank can print both strings. libver was zero-filled before
  // MPI_Get_library_version wrote it, but re-terminate defensively so the
  // comparison is between well-formed strings.
  char rootver[MPI_MAX_LIBRARY_VERSION_STRING];
  memcpy(rootver, libver, sizeof rootver);
  MPI_Bcast(rootver, MPI_MAX_LIBRARY_VERSION_STRING, MPI_CHAR, 0, comm);
  rootver[MPI_MAX_LIBRARY_VERSION_STRING - 1] = '\0';
  if (strcmp(libver, rootver) != 0)
    mpif_check_fail(routine,
                    "rank %d: the loaded MPI library reports \"%.*s\" here "
                    "but \"%.*s\" on rank 0: the processes did not load the "
                    "same MPI library",
                    rank, (int)strcspn(libver, "\n"), libver,
                    (int)strcspn(rootver, "\n"), rootver);

  // The token ring: every rank sends its rank one step around and must
  // receive its predecessor's. Legal and meaningful at size 1 too, where the
  // self-sendrecv still exercises the matching path.
  const int right = (rank + 1) % size;
  const int left = (rank + size - 1) % size;
  int token = rank, received = -1;
  MPI_Sendrecv(&token, 1, MPI_INT, right, 0, &received, 1, MPI_INT, left, 0,
               comm, MPI_STATUS_IGNORE);
  if (received != left)
    mpif_check_fail(routine,
                    "rank %d: the token ring delivered %d where rank %d was "
                    "expected: point-to-point communication is broken",
                    rank, received, left);

  // The head count: everyone contributes 1, the root checks the sum.
  const int one = 1;
  int count = -1;
  MPI_Reduce(&one, &count, 1, MPI_INT, MPI_SUM, 0, comm);
  if (rank == 0 && count != size)
    mpif_check_fail(routine,
                    "rank 0: MPI_Reduce counted %d processes where "
                    "MPI_COMM_WORLD has size %d: collective communication is "
                    "broken",
                    count, size);

  // The node layout, when some rank stated an expectation (vmax carries it
  // everywhere, so all ranks agree to gather). Gather rather than Allgather:
  // only the root needs the names.
  if (vmax[nfields - 2] > 0 || vmax[nfields - 1] > 0) {
    char name[MPI_MAX_PROCESSOR_NAME];
    memset(name, 0, sizeof name);
    int namelen;
    MPI_Get_processor_name(name, &namelen);
    // Re-zero the padding: the records are compared with memcmp, and the
    // library may have used the buffer past the NUL as scratch.
    name[MPI_MAX_PROCESSOR_NAME - 1] = '\0';
    memset(name + strlen(name), 0, sizeof name - strlen(name));
    char *const names =
        rank == 0 ? malloc((size_t)size * MPI_MAX_PROCESSOR_NAME) : NULL;
    if (rank == 0 && !names)
      mpif_check_fail(routine, "out of memory gathering %d processor names",
                      size);
    MPI_Gather(name, MPI_MAX_PROCESSOR_NAME, MPI_CHAR, names,
               MPI_MAX_PROCESSOR_NAME, MPI_CHAR, 0, comm);
    if (rank == 0) {
      qsort(names, size, MPI_MAX_PROCESSOR_NAME, mpif_check_name_cmp);
      int num_nodes = 0;
      for (int i = 0; i < size;) {
        const char *const node = names + (size_t)i * MPI_MAX_PROCESSOR_NAME;
        int node_size = 0;
        while (i < size &&
               strcmp(names + (size_t)i * MPI_MAX_PROCESSOR_NAME, node) == 0) {
          ++node_size;
          ++i;
        }
        ++num_nodes;
        if (vmax[nfields - 1] > 0 && node_size != vmax[nfields - 1])
          mpif_check_fail(routine,
                          "MPIF_NODE_SIZE expects %d processes per node but "
                          "node \"%s\" has %d",
                          vmax[nfields - 1], node, node_size);
      }
      if (vmax[nfields - 2] > 0 && num_nodes != vmax[nfields - 2])
        mpif_check_fail(routine,
                        "MPIF_NUM_NODES expects %d nodes but the %d "
                        "processes run on %d",
                        vmax[nfields - 2], size, num_nodes);
      free(names);
    }
  }

  MPI_Comm_free(&comm);
}

void mpif_check_environment_(void) { mpif_check_environment(); }
