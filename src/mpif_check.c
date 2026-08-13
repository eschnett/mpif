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
// communication. So before MPI_Init or after MPI_Finalize only the version,
// library-name and sentinel checks run, and the rest is skipped silently. (The
// sentinel check is pure address arithmetic and needs no MPI at all; see
// mpif_check_sentinel below for what it catches and why nothing else can.)
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
// Setting either node variable also makes rank 0 print the layout it gathered,
// whether or not the expectation holds; see the printing walk below for why the
// accepting case is the one that needed a witness.
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
// Every MPI call below is to a PMPI_ name. None of them is a call the program
// made -- they are this file verifying the environment -- so a profiling layer
// must not be shown them, or a tool counting collectives reports an
// MPI_Comm_dup, two MPI_Allreduces, an MPI_Bcast, an MPI_Sendrecv, an
// MPI_Reduce and an MPI_Gather that the application never issued, once per call
// to mpif_check_environment. The generated wrappers make the same choice for
// their array-length probes and src/mpif_cdesc.c for the datatypes it builds;
// only a wrapper's principal call goes through MPI_, that being the one the
// program did make. Every PMPI_ name used here was confirmed present in both
// implementations' ABI libraries with `nm`, the two MPI_Abi_* accessors
// included, they being new in MPI-5.0.
//
// Every one of those calls has its return code checked, through
// mpif_check_mpi below. That is not defensive habit: this function is a
// diagnostic, and a diagnostic that keeps going after a failed call reports on
// values no call ever wrote. Which error handler is in force is the
// application's choice, and MPI-5.0 section 9.3 states the one that matters
// here -- "MPI_ERRORS_RETURN: The handler has no effect other than returning
// the error code to the user", set by any program that "may choose to handle
// errors in its main code, by testing the return code of MPI calls". Under it a
// failed PMPI_Allreduce simply returns, leaving the consistency loop below to
// compare two uninitialised arrays and announce whatever it finds as a
// disagreement between the ranks: a misdiagnosis delivered exactly when
// something really is wrong. The same section is why a failure ends the run
// rather than being noted and stepped over -- "[s]ome errors might prevent MPI
// from completing further API calls successfully" -- so there is nothing to be
// gained by asking the remaining questions.
//
// The private communicator gets MPI_ERRORS_RETURN of its own so that the answer
// does not depend on which handler the application chose: a failure inside the
// smoke test is then mpif's message naming the call, rather than the
// implementation's abort text under the default handler and a wrong answer
// under the other.
//
// Fortran calling convention as elsewhere in mpif: lowercase name with a
// trailing underscore, every argument by reference. The C-callable forms exist
// too; no C header is installed for them (nothing needs one yet), so a C
// caller declares `void mpif_check_version(int, int, int)` and
// `void mpif_check_environment(void)` itself.

#include <mpi.h>

#include <mpif_logical.h>
#include <mpif_sentinels.h>

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

// The Fortran side of the sentinel check below: each hands every sentinel it can
// see to mpif_check_sentinel. Two subprograms because the two sets cannot share a
// scoping unit -- mpif.h's MPI_STATUS_IGNORE is an INTEGER array and mpi_f08's a
// TYPE(MPI_Status), under one name -- and in two files because
// src/mpif_check_fns.F90 cannot use mpif_f08_types without a circular file
// dependency (mpif_f08_types uses mpi, which uses mpif_check_fns).
void mpif_check_report_sentinels_(void);
void mpif_check_report_f08_sentinels_(void);

// Print "mpif: <routine>: <message>" and abort -- through PMPI_Abort when that
// can work, so the whole job dies rather than one rank, and through abort()
// otherwise (and as the backstop should PMPI_Abort return).
static void mpif_check_fail(const char *restrict const routine,
                            const char *restrict const fmt, ...) {
  fprintf(stderr, "mpif: %s: ", routine);
  va_list ap;
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fputc('\n', stderr);
  int initialized = 0, finalized = 0;
  // Unchecked on purpose, and the only two calls in this file that are: this
  // is the failure path itself, so there is nothing to hand a diagnosis to,
  // and routing them through mpif_check_mpi below would recurse. A call that
  // fails is taken to have written nothing, which lands on abort() -- the
  // outcome that needs no MPI.
  if (PMPI_Initialized(&initialized) != MPI_SUCCESS)
    initialized = 0;
  if (PMPI_Finalized(&finalized) != MPI_SUCCESS)
    finalized = 1;
  if (initialized && !finalized)
    PMPI_Abort(MPI_COMM_WORLD, 1);
  abort();
}

// Every other MPI call in this file goes through this. `call` names the
// function, so the message says which one failed rather than only that
// something did; the code itself is implementation-defined, so MPI_Error_string
// is what turns it into text. That one is usable wherever this file is:
// MPI-5.0 section 9.4 makes it "one of the few routines that may be called
// before MPI is initialized or after MPI is finalized", which is the window the
// version and sentinel checks run in.
static void mpif_check_mpi(const char *restrict const routine,
                           const char *restrict const call, const int ierr) {
  if (ierr == MPI_SUCCESS)
    return;
  // MPI_Error_string may itself fail -- an invalid error code is the obvious
  // way -- and the standard says nothing about what it leaves in the buffer
  // then, so the fallback text has to be here rather than in what it wrote.
  char text[MPI_MAX_ERROR_STRING];
  memset(text, 0, sizeof text);
  int textlen = 0;
  if (PMPI_Error_string(ierr, text, &textlen) != MPI_SUCCESS || !text[0])
    snprintf(text, sizeof text, "no description available");
  text[MPI_MAX_ERROR_STRING - 1] = '\0';
  mpif_check_fail(routine,
                  "%s failed with error code %d (%.*s). The check itself "
                  "cannot run against an MPI whose own calls fail, so nothing "
                  "below it has been judged",
                  call, ierr, (int)strcspn(text, "\n"), text);
}

// The sentinel arrangement, checked at run time because nothing else can see
// both halves of it.
//
// A sentinel is identified by its address: Fortran declares a COMMON block, C
// defines the storage in src/mpif_constants.c, the linker merges the two, and
// every wrapper compares the address it was handed against the cell. If those
// two ever stop being the same object the comparisons quietly stop matching, and
// a real caller's buffer goes to MPI as a sentinel or the reverse. Three ways
// that can happen, none of them visible to a compile-time check:
//
// - a `common /X/ Y` renamed without renaming the cell in src/mpif_constants.c,
//   or the reverse. ci-scripts/check-headers.sh catches this statically for
//   include/mpif_constants.h; this catches it for both declaration sites.
// - a consumer linked without `-Wl,-commons,use_dylibs` on macOS, which gives
//   the executable its own copy of each block instead of resolving to the
//   library's definition. The installed mpifort wrapper passes it; a hand-rolled
//   link may not.
// - a Fortran sentinel whose size stops matching its cell. Too large and MPI can
//   write past the end of it; too small and GNU ld warns "size of symbol changed"
//   once per sentinel in every consumer's link. The _Static_asserts in
//   include/mpif_sentinels.h cannot see the Fortran side's size at all, so the
//   comparison has to happen here.
//
// The check exercises the very mechanism it is checking: the Fortran side takes
// c_loc of each sentinel and passes it down, which is also the only test that
// MPI-5.0 section 3.6's "the implementation of MPI_BUFFER_AUTOMATIC must allow
// the intrinsic c_loc to be applied to it" holds.
//
// This order is shared with src/mpif_check_fns.F90 and src/mpif_check_f08.F90,
// which pass the indices. Keep the three in step; a sentinel dropped from a
// reporter is caught by the count, and a misordering by the address comparison.
enum { MPIF_SENTINEL_COUNT = 12 };

#define MPIF_SENTINEL_INT_BYTES (int)(MPIF_SENTINEL_INT_WORDS * sizeof(MPI_Fint))
#define MPIF_SENTINEL_STATUS_BYTES \
  (int)(MPIF_SENTINEL_STATUS_WORDS * sizeof(MPI_Fint))

static const struct {
  const char *name;
  const void *cell;
  int bytes;
} mpif_sentinel_cells[MPIF_SENTINEL_COUNT] = {
    {"MPI_BOTTOM", mpif_bottom_, MPIF_SENTINEL_INT_BYTES},
    {"MPI_IN_PLACE", mpif_in_place_, MPIF_SENTINEL_INT_BYTES},
    {"MPI_BUFFER_AUTOMATIC", mpif_buffer_automatic_, MPIF_SENTINEL_INT_BYTES},
    {"MPI_ARGV_NULL", mpif_argv_null_, MPIF_SENTINEL_CHAR_BYTES},
    {"MPI_ARGVS_NULL", mpif_argvs_null_, MPIF_SENTINEL_CHAR_BYTES},
    {"MPI_ERRCODES_IGNORE", mpif_errcodes_ignore_, MPIF_SENTINEL_INT_BYTES},
    {"MPI_STATUS_IGNORE", mpif_status_ignore_, MPIF_SENTINEL_STATUS_BYTES},
    {"MPI_STATUSES_IGNORE", mpif_statuses_ignore_, MPIF_SENTINEL_STATUS_BYTES},
    {"MPI_UNWEIGHTED", mpif_unweighted_, MPIF_SENTINEL_INT_BYTES},
    {"MPI_WEIGHTS_EMPTY", mpif_weights_empty_, MPIF_SENTINEL_INT_BYTES},
    {"MPI_STATUS_IGNORE (mpi_f08)", mpif_f08_status_ignore_,
     MPIF_SENTINEL_STATUS_BYTES},
    {"MPI_STATUSES_IGNORE (mpi_f08)", mpif_f08_statuses_ignore_,
     MPIF_SENTINEL_STATUS_BYTES},
};

// Thread-local, because mpif_check_environment resets this and then compares it
// against MPIF_SENTINEL_COUNT: two threads calling that function at overlapping
// times would each reset the other's count part-built and report a spurious
// disagreement. A plain `static int` is also an unsynchronised read-modify-write
// shared between them, which is a data race whatever the arithmetic comes to.
// One count per thread costs nothing here -- the reporters run entirely within
// one call -- and the sentinel check is the one part of mpif_check_environment
// that runs before MPI_Init, where no MPI thread-level guarantee is in effect
// yet and nothing else would serialise the callers.
static _Thread_local int mpif_sentinel_reported;

// Called once per sentinel by the two Fortran reporters. Aborts on the first
// disagreement rather than counting: any one of them means every wrapper's
// sentinel comparison is unreliable, so there is nothing to be gained by going
// on.
void mpif_check_sentinel(int index, const void *address, int bytes) {
  static const char routine[] = "mpif_check_environment";
  if (index < 1 || index > MPIF_SENTINEL_COUNT)
    mpif_check_fail(routine, "sentinel index %d is out of range 1..%d", index,
                    MPIF_SENTINEL_COUNT);
  const char *const name = mpif_sentinel_cells[index - 1].name;
  const void *const cell = mpif_sentinel_cells[index - 1].cell;
  if (address != cell)
    mpif_check_fail(routine,
                    "Fortran's %s is at %p but mpif's cell for it is at %p. "
                    "Every wrapper recognises a sentinel by comparing against "
                    "the cell, so none of them will recognise this one. On "
                    "macOS the usual cause is linking without "
                    "-Wl,-commons,use_dylibs, which the installed mpifort "
                    "wrapper passes; otherwise a COMMON block name and its "
                    "definition in src/mpif_constants.c have diverged",
                    name, address, cell);
  // Equality, not a fit. A cell bigger than its COMMON works, but GNU ld then
  // warns "size of symbol changed" once per sentinel in every consumer's link;
  // a cell smaller means MPI can write past the end of it. Both are avoided by
  // the two sides agreeing exactly, which is what the three sizes in
  // include/mpif_sentinels.h exist to keep true.
  const int expected = mpif_sentinel_cells[index - 1].bytes;
  if (bytes != expected)
    mpif_check_fail(routine,
                    "Fortran's %s occupies %d bytes but mpif's cell for it is "
                    "%d. The two must agree exactly: a larger cell makes GNU ld "
                    "warn once per sentinel on every link, a smaller one lets "
                    "MPI write past its end. Adjust the matching size in "
                    "include/mpif_sentinels.h",
                    name, bytes, expected);
  ++mpif_sentinel_reported;
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

  // The sentinel arrangement; see mpif_check_sentinel above. Pure address
  // arithmetic, so it can run here among the checks that need no MPI.
  mpif_sentinel_reported = 0;
  mpif_check_report_sentinels_();
  mpif_check_report_f08_sentinels_();
  if (mpif_sentinel_reported != MPIF_SENTINEL_COUNT)
    mpif_check_fail(routine,
                    "%d of %d sentinels were reported for checking; a "
                    "reporter in src/mpif_check_fns.F90 or "
                    "src/mpif_check_f08.F90 has fallen out of step with the "
                    "table in src/mpif_check.c",
                    mpif_sentinel_reported, MPIF_SENTINEL_COUNT);

  // The ABI version. MPI-5.0 chapter 20: MPI_Abi_get_version reports -1/-1
  // when the library does not implement the standard ABI at all; minor bumps
  // are backwards compatible, major bumps are not. So the runtime major must
  // equal the header's, and the runtime minor must not be smaller -- the
  // header may name handle types and constants an older minor lacks.
  int abi_major = -1, abi_minor = -1;
  mpif_check_mpi(routine, "MPI_Abi_get_version",
                 PMPI_Abi_get_version(&abi_major, &abi_minor));
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
  int mpi_version = 0, mpi_subversion = 0;
  mpif_check_mpi(routine, "MPI_Get_version",
                 PMPI_Get_version(&mpi_version, &mpi_subversion));
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
  int libverlen = 0;
  mpif_check_mpi(routine, "MPI_Get_library_version",
                 PMPI_Get_library_version(libver, &libverlen));
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
  mpif_check_mpi(routine, "MPI_Initialized", PMPI_Initialized(&initialized));
  mpif_check_mpi(routine, "MPI_Finalized", PMPI_Finalized(&finalized));
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
  mpif_check_mpi(routine, "MPI_Abi_get_fortran_booleans",
                 PMPI_Abi_get_fortran_booleans((int)sizeof(MPI_Fint), &lib_true,
                                               &lib_false, &booleans_set));
  if (booleans_set && (lib_true != mpif_bool2logical(1) ||
                       lib_false != mpif_bool2logical(0)))
    mpif_check_fail(routine,
                    "the loaded MPI library holds Fortran booleans "
                    ".TRUE.=%d/.FALSE.=%d but mpif's compiler uses %d/%d: a "
                    "different Fortran layer registered its representation, "
                    "and MPI_LOGICAL operations would use the wrong values",
                    (int)lib_true, (int)lib_false, (int)mpif_bool2logical(1),
                    (int)mpif_bool2logical(0));

  int size = 0, rank = 0;
  mpif_check_mpi(routine, "MPI_Comm_size",
                 PMPI_Comm_size(MPI_COMM_WORLD, &size));
  mpif_check_mpi(routine, "MPI_Comm_rank",
                 PMPI_Comm_rank(MPI_COMM_WORLD, &rank));

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
  MPI_Comm comm = MPI_COMM_NULL;
  mpif_check_mpi(routine, "MPI_Comm_dup",
                 PMPI_Comm_dup(MPI_COMM_WORLD, &comm));

  // The duplicate inherits MPI_COMM_WORLD's error handler, which belongs to
  // the application; MPI_ERRORS_RETURN here makes every call below answer to
  // mpif_check_mpi instead, whichever handler that was. Under the default
  // MPI_ERRORS_ARE_FATAL the failure would otherwise be the implementation's
  // abort message, which names neither this function nor what it was checking;
  // under MPI_ERRORS_RETURN it would be no message at all, the checks reading
  // buffers the failed call never wrote. Setting it on the private duplicate
  // and not on MPI_COMM_WORLD is what keeps this invisible to the application.
  mpif_check_mpi(routine, "MPI_Comm_set_errhandler",
                 PMPI_Comm_set_errhandler(comm, MPI_ERRORS_RETURN));

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
  mpif_check_mpi(
      routine, "MPI_Allreduce (MPI_MIN)",
      PMPI_Allreduce(local, vmin, nfields, MPI_INT, MPI_MIN, comm));
  mpif_check_mpi(
      routine, "MPI_Allreduce (MPI_MAX)",
      PMPI_Allreduce(local, vmax, nfields, MPI_INT, MPI_MAX, comm));
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
  mpif_check_mpi(routine, "MPI_Bcast",
                 PMPI_Bcast(rootver, MPI_MAX_LIBRARY_VERSION_STRING, MPI_CHAR,
                            0, comm));
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
  mpif_check_mpi(routine, "MPI_Sendrecv",
                 PMPI_Sendrecv(&token, 1, MPI_INT, right, 0, &received, 1,
                               MPI_INT, left, 0, comm, MPI_STATUS_IGNORE));
  if (received != left)
    mpif_check_fail(routine,
                    "rank %d: the token ring delivered %d where rank %d was "
                    "expected: point-to-point communication is broken",
                    rank, received, left);

  // The head count: everyone contributes 1, the root checks the sum.
  const int one = 1;
  int count = -1;
  mpif_check_mpi(routine, "MPI_Reduce",
                 PMPI_Reduce(&one, &count, 1, MPI_INT, MPI_SUM, 0, comm));
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
    int namelen = 0;
    mpif_check_mpi(routine, "MPI_Get_processor_name",
                   PMPI_Get_processor_name(name, &namelen));
    // Re-zero the padding: the records are compared with memcmp, and the
    // library may have used the buffer past the NUL as scratch.
    name[MPI_MAX_PROCESSOR_NAME - 1] = '\0';
    memset(name + strlen(name), 0, sizeof name - strlen(name));
    char *const names =
        rank == 0 ? malloc((size_t)size * MPI_MAX_PROCESSOR_NAME) : NULL;
    if (rank == 0 && !names)
      mpif_check_fail(routine, "out of memory gathering %d processor names",
                      size);
    mpif_check_mpi(routine, "MPI_Gather",
                   PMPI_Gather(name, MPI_MAX_PROCESSOR_NAME, MPI_CHAR, names,
                               MPI_MAX_PROCESSOR_NAME, MPI_CHAR, 0, comm));
    if (rank == 0) {
      qsort(names, size, MPI_MAX_PROCESSOR_NAME, mpif_check_name_cmp);
      // What the gather found, printed whether or not the expectation holds.
      // The case that needed a witness is the one where the layout is
      // *accepted*: a rank whose name differs from the others' turns two
      // processes on one node into two nodes of one, which is what
      // MPIF_NUM_NODES=2 and MPIF_NODE_SIZE=1 each claim, so a run that should
      // have been refused passes in silence. Printing only on mismatch cannot
      // see that; printing here can. See MISSING.md "The `check_env*_fail`
      // tests flake, on CI runners and not here".
      //
      // The prefix is deliberately NOT "mpif: mpif_check_environment: ", which
      // is what every check_env*_fail test in test/CMakeLists.txt passes on: a
      // line carrying that prefix would satisfy those tests with no check
      // having failed, which is exactly the silence this is here to break.
      //
      // Printed before the checks below, and complete before any of them can
      // abort. The counts trail the names because num_nodes is not known until
      // the walk ends; at most eight names are listed, so a large job still
      // prints one bounded line, with the true totals.
      {
        enum { max_listed = 8 };
        int listed = 0, printed_nodes = 0;
        fprintf(stderr, "mpif: node layout:");
        for (int i = 0; i < size;) {
          const char *const node = names + (size_t)i * MPI_MAX_PROCESSOR_NAME;
          int node_size = 0;
          while (i < size &&
                 strcmp(names + (size_t)i * MPI_MAX_PROCESSOR_NAME, node) ==
                     0) {
            ++node_size;
            ++i;
          }
          if (listed < max_listed) {
            fprintf(stderr, "%s \"%s\" x%d", listed == 0 ? "" : ",", node,
                    node_size);
            ++listed;
          }
          ++printed_nodes;
        }
        if (printed_nodes > listed)
          fprintf(stderr, ", ... (%d more)", printed_nodes - listed);
        fprintf(stderr, ": %d process%s on %d node%s\n", size,
                size == 1 ? "" : "es", printed_nodes,
                printed_nodes == 1 ? "" : "s");
      }
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

  mpif_check_mpi(routine, "MPI_Comm_free", PMPI_Comm_free(&comm));
}

void mpif_check_environment_(void) { mpif_check_environment(); }
