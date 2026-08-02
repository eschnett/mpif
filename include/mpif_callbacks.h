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
// trampoline converting handles and calling conventions.
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

// User-defined reduction operators
//
// `MPI_User_function` receives only the buffers, the length and the datatype --
// nothing that says which operator is being applied -- so the Fortran procedure
// cannot be looked up when the callback fires. A fixed pool of trampolines is
// pre-generated instead, each knowing its own slot, and one is handed out per
// MPI_Op_create.
//
// A slot is never given back, not even by MPI_Op_free; see the comment in
// src/mpif_callbacks.c. A program may therefore create at most MPIF_OP_SLOTS
// user-defined operators over its lifetime, rather than at any one time.

// Reserve a slot for `callback` and return the trampoline to give MPI, or NULL
// if the pool is exhausted, in which case a diagnostic has been printed.
// `large` selects the MPI_Count form. The slot is stored in *slot.
void *mpif_op_reserve(mpif_fortran_procedure callback, int large, int *slot);

// Give a reserved slot back, MPI_Op_create having failed. Safe only because MPI
// never received the trampoline, so it can never call it.
void mpif_op_cancel(int slot);

// User-defined error handlers
//
// An error handler is told which object raised the error and which error code,
// but not which handler is running, so it needs a trampoline pool of its own.
// Slots are never given back: MPI_Errhandler_free only marks a handler for
// deallocation, and it stays in use by everything it is attached to.

enum mpif_errhandler_kind {
  MPIF_ERRHANDLER_COMM,
  MPIF_ERRHANDLER_WIN,
  MPIF_ERRHANDLER_FILE,
  MPIF_ERRHANDLER_SESSION
};

// Reserve a slot for `callback` and return the trampoline to give MPI, or NULL
// if the pool is exhausted, in which case a diagnostic has been printed. The
// slot is stored in *slot.
void *mpif_errhandler_reserve(mpif_fortran_procedure callback,
                              enum mpif_errhandler_kind kind, int *slot);

// Give a reserved slot back, MPI_*_create_errhandler having failed
void mpif_errhandler_cancel(int slot);

// User-defined generalized request callbacks
//
// A generalized request's three callbacks are told only `extra_state`, so there
// is nothing to look up when one fires -- the same problem reduction operators
// have. No pool is needed here, though: `extra_state` is mpif's to choose, so it
// gives MPI a box holding the three Fortran procedures and passes the caller's
// own extra state on from there. There is therefore no limit on how many
// generalized requests a program may have.
//
// The box belongs to one request and is released by the free trampoline. MPI-5.0
// section 13.2 has it that "free_fn will be invoked only once per request by a
// correct program", and that "the request is not deallocated until after free_fn
// completes", so nothing can reach the box afterwards.

// Allocate the box to hand MPI as `extra_state`, or return NULL if out of
// memory, in which case a diagnostic has been printed.
//
// `extra_state` is the address of the caller's Fortran variable rather than a
// copy of its value, so that the callbacks alias it. The standard declares
// `extra_state` without an INTENT in all three grequest callback interfaces --
// unlike the attribute callbacks, where it is INTENT(IN) and mpif passes a copy
// -- and a `free_fn` that updates it is expected to be seen by the caller.
void *mpif_grequest_reserve(mpif_fortran_procedure query_fn,
                            mpif_fortran_procedure free_fn,
                            mpif_fortran_procedure cancel_fn,
                            MPI_Aint *extra_state);

// Release the box again, MPI_Grequest_start having failed. Safe only because MPI
// never received it, so no callback can fire.
void mpif_grequest_cancel(void *box);

// The trampolines to hand MPI in place of the Fortran procedures
int mpif_grequest_query_trampoline(void *extra_state, MPI_Status *status);
int mpif_grequest_free_trampoline(void *extra_state);
int mpif_grequest_cancel_trampoline(void *extra_state, int complete);

// User-defined datarep conversion and extent callbacks
//
// The same arrangement as the generalized request callbacks, and for the same
// reason: a datarep's callbacks are told only `extra_state`, which is mpif's to
// choose, so MPI gets a box holding the Fortran procedures and one trampoline
// apiece is enough. The two conversion callbacks share a signature, so they get
// a trampoline each rather than one that has to guess which it is serving.
//
// Two things differ from the grequest box. The datarep is registered for the
// duration of the program -- MPI-5.0 has no call that undoes
// MPI_Register_datarep -- so the box is never freed. That is not a leak to be
// fixed later: there is no point at which freeing it would be safe, and the
// number of boxes is the number of datareps a program registers.
//
// And `extra_state` is copied into the box rather than aliased, where the
// grequest box holds the address of the caller's variable. Aliasing is what
// lets a grequest `free_fn` be seen by the caller, but it would be a dangling
// pointer here, the box outliving any scope the caller registered from.
// MPI-5.0 gives MPI_Register_datarep's own `extra_state` INTENT(IN), so there
// is nothing to report back: the callbacks get the value that was registered.
void *mpif_datarep_reserve(mpif_fortran_procedure read_fn,
                           mpif_fortran_procedure write_fn,
                           mpif_fortran_procedure extent_fn,
                           MPI_Aint extra_state);

// Release the box again, MPI_Register_datarep having failed. Safe only because
// MPI never received it, so no callback can fire.
void mpif_datarep_cancel(void *box);

int mpif_datarep_read_trampoline(void *userbuf, MPI_Datatype datatype,
                                 int count, void *filebuf, MPI_Offset position,
                                 void *extra_state);
int mpif_datarep_write_trampoline(void *userbuf, MPI_Datatype datatype,
                                  int count, void *filebuf, MPI_Offset position,
                                  void *extra_state);
int mpif_datarep_read_trampoline_c(void *userbuf, MPI_Datatype datatype,
                                   MPI_Count count, void *filebuf,
                                   MPI_Offset position, void *extra_state);
int mpif_datarep_write_trampoline_c(void *userbuf, MPI_Datatype datatype,
                                    MPI_Count count, void *filebuf,
                                    MPI_Offset position, void *extra_state);
int mpif_datarep_extent_trampoline(MPI_Datatype datatype, MPI_Aint *extent,
                                   void *extra_state);

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
