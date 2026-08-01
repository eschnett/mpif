#ifndef MPIF_CALLBACKS_H
#define MPIF_CALLBACKS_H

#include <mpi.h>

// Translate Fortran's predefined attribute and conversion callbacks into the
// values the MPI ABI expects.
//
// The ABI defines MPI_COMM_NULL_COPY_FN and friends as sentinel addresses --
// `((MPI_Comm_copy_attr_function*)0x0)`, `0x1`, and so on -- not as callable
// functions. Fortran, in contrast, has to name procedures, so mpif defines them
// in src/mpif_attr_fns.F90. Passing one of those procedures through to MPI
// would be wrong: the library compares against its sentinels and would treat it
// as a user-defined callback. Recognise them here and hand over the sentinel
// instead.
//
// See include/mpif_logical.h for the analogous problem with LOGICAL.

#ifdef __cplusplus
extern "C" {
#endif

// Any Fortran procedure, for comparison purposes only. Fortran passes
// procedures by address, and all that matters here is which address it is.
typedef void (*mpif_fortran_procedure)(void);

// If `callback` is one of Fortran's predefined callbacks, store the ABI value
// that stands for it in `*result` and return 1. Return 0 for anything else,
// which is a user-defined callback and not supported yet -- that would need a
// trampoline converting handles and calling conventions; see MISSING.md.
int mpif_predefined_callback(mpif_fortran_procedure callback, void **result);

// Complain about a user-defined callback that cannot be forwarded, and return
// the error code to report. Returning an error is not enough on its own: mpif
// synthesises it without going through MPI, so no error handler runs and the
// program carries on, typically to fail later and elsewhere -- with an
// uninitialised keyval, say.
int mpif_unsupported_callback(const char *routine, const char *argument);

// User-defined attribute callbacks
//
// MPI is given a C trampoline instead of the user's Fortran procedure, and the
// procedure is recorded against the keyval, which is the one piece of
// identifying information every attribute callback receives. The trampoline
// looks it up and converts arguments in both directions.
//
// The deprecated MPI-1 forms, used by MPI_Keyval_create, differ only in that
// attribute values and extra state are default INTEGERs rather than
// address-sized.

enum mpif_attr_callback_kind {
  MPIF_ATTR_COMM_COPY,
  MPIF_ATTR_COMM_DELETE,
  MPIF_ATTR_TYPE_COPY,
  MPIF_ATTR_TYPE_DELETE,
  MPIF_ATTR_WIN_COPY,
  MPIF_ATTR_WIN_DELETE,
  MPIF_ATTR_COMM_COPY_10,
  MPIF_ATTR_COMM_DELETE_10
};

// The C trampoline to hand MPI in place of a user-defined Fortran procedure
void *mpif_attr_trampoline(enum mpif_attr_callback_kind kind);

// Record which Fortran procedure the trampoline should call for `keyval`.
// Predefined callbacks are ignored, MPI having been given its own sentinel for
// those. Returns an MPI error code.
int mpif_register_attr_callback(int keyval, enum mpif_attr_callback_kind kind,
                                mpif_fortran_procedure callback);

#ifdef __cplusplus
}
#endif

#endif // #ifndef MPIF_CALLBACKS_H
