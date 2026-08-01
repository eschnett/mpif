#include <mpif_callbacks.h>

#include <mpi.h>
#include <stddef.h>
#include <mpif_logical.h>

#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>

// The Fortran side of the predefined callbacks, from src/mpif_attr_fns.F90.
// Only their addresses are used; they are never called through these
// declarations, so the empty argument lists are harmless.
extern void mpi_null_copy_fn_(void);
extern void mpi_dup_fn_(void);
extern void mpi_null_delete_fn_(void);
extern void mpi_comm_null_copy_fn_(void);
extern void mpi_comm_dup_fn_(void);
extern void mpi_comm_null_delete_fn_(void);
extern void mpi_type_null_copy_fn_(void);
extern void mpi_type_dup_fn_(void);
extern void mpi_type_null_delete_fn_(void);
extern void mpi_win_null_copy_fn_(void);
extern void mpi_win_dup_fn_(void);
extern void mpi_win_null_delete_fn_(void);
extern void mpi_conversion_fn_null_(void);
extern void mpi_conversion_fn_null_c_(void);

struct predefined_callback {
  mpif_fortran_procedure fortran;
  void *abi;
};

// Casting a function pointer to void* is not strictly conforming C, but it is
// well defined on every platform mpif targets, and the ABI's own sentinels are
// function pointers holding the addresses 0x0 and 0x1.
static const struct predefined_callback predefined_callbacks[] = {
    // Deprecated in MPI-2.0, still used by MPI_Keyval_create
    {mpi_null_copy_fn_, (void *)MPI_NULL_COPY_FN},
    {mpi_dup_fn_, (void *)MPI_DUP_FN},
    {mpi_null_delete_fn_, (void *)MPI_NULL_DELETE_FN},

    {mpi_comm_null_copy_fn_, (void *)MPI_COMM_NULL_COPY_FN},
    {mpi_comm_dup_fn_, (void *)MPI_COMM_DUP_FN},
    {mpi_comm_null_delete_fn_, (void *)MPI_COMM_NULL_DELETE_FN},

    {mpi_type_null_copy_fn_, (void *)MPI_TYPE_NULL_COPY_FN},
    {mpi_type_dup_fn_, (void *)MPI_TYPE_DUP_FN},
    {mpi_type_null_delete_fn_, (void *)MPI_TYPE_NULL_DELETE_FN},

    {mpi_win_null_copy_fn_, (void *)MPI_WIN_NULL_COPY_FN},
    {mpi_win_dup_fn_, (void *)MPI_WIN_DUP_FN},
    {mpi_win_null_delete_fn_, (void *)MPI_WIN_NULL_DELETE_FN},

    {mpi_conversion_fn_null_, (void *)MPI_CONVERSION_FN_NULL},
    {mpi_conversion_fn_null_c_, (void *)MPI_CONVERSION_FN_NULL_C},
};

int mpif_predefined_callback(mpif_fortran_procedure callback, void **result) {
  const size_t count =
      sizeof predefined_callbacks / sizeof *predefined_callbacks;
  for (size_t i = 0; i < count; ++i) {
    if (predefined_callbacks[i].fortran == callback) {
      *result = predefined_callbacks[i].abi;
      return 1;
    }
  }
  return 0;
}

////////////////////////////////////////////////////////////////////////////////
// User-defined attribute callbacks

// Entries are never removed. MPI_Comm_free_keyval and its siblings only mark a
// keyval for deletion: attributes already set keep it alive, and their delete
// callbacks still have to find their Fortran procedure. A keyval number that
// MPI reuses for a later keyval overwrites its entry, so the table grows only
// to the number of keyvals live at one time.
//
// Access is lock-free. `keyval` is published with release ordering once the
// procedures are in place and read with acquire ordering, so a reader either
// does not see the entry or sees it complete. MPI_KEYVAL_INVALID is 0, which is
// what static storage starts as, so a zeroed slot reads as free.

enum { MPIF_MAX_KEYVALS = 256 };
enum { KEYVAL_RESERVED = -1 };

struct attr_entry {
  _Atomic int keyval;
  mpif_fortran_procedure copy_fn;
  mpif_fortran_procedure delete_fn;
};

static struct attr_entry attr_entries[MPIF_MAX_KEYVALS];

static struct attr_entry *find_attr_entry(int keyval) {
  for (size_t i = 0; i < MPIF_MAX_KEYVALS; ++i)
    if (atomic_load_explicit(&attr_entries[i].keyval, memory_order_acquire) ==
        keyval)
      return &attr_entries[i];
  return NULL;
}

// Handle conversions. These mirror the MPIF_*_toint helpers that the generator
// emits into gen/mpif_functions.c, which work around MPI implementations whose
// own conversions mishandle predefined handles -- and MPI_COMM_SELF in
// particular does carry attributes, so the workaround matters here too.
// TODO: the generator should include a shared header instead of emitting its
// own copies, at which point these go away.

static MPI_Fint comm_toint(MPI_Comm comm) {
  switch ((intptr_t)comm) {
  case (intptr_t)MPI_COMM_NULL:
  case (intptr_t)MPI_COMM_WORLD:
  case (intptr_t)MPI_COMM_SELF:
    return (MPI_Fint)(intptr_t)comm;
  }
  return MPI_Comm_toint(comm);
}

static MPI_Fint type_toint(MPI_Datatype datatype) {
  return MPI_Type_toint(datatype);
}

static MPI_Fint win_toint(MPI_Win win) { return MPI_Win_toint(win); }

// How the Fortran procedures are called. Handles arrive as default INTEGERs,
// which suits `use mpi` and mpif.h directly and mpi_f08 too, its handle types
// being bind(C) derived types holding one integer.

typedef void (*fortran_copy_attr_fn)(MPI_Fint *oldhandle, MPI_Fint *keyval,
                                     MPI_Aint *extra_state,
                                     MPI_Aint *attribute_val_in,
                                     MPI_Aint *attribute_val_out, MPI_Fint *flag,
                                     MPI_Fint *ierror);
typedef void (*fortran_delete_attr_fn)(MPI_Fint *handle, MPI_Fint *keyval,
                                       MPI_Aint *attribute_val,
                                       MPI_Aint *extra_state, MPI_Fint *ierror);
typedef void (*fortran_copy_fn_10)(MPI_Fint *oldcomm, MPI_Fint *keyval,
                                   MPI_Fint *extra_state,
                                   MPI_Fint *attribute_val_in,
                                   MPI_Fint *attribute_val_out, MPI_Fint *flag,
                                   MPI_Fint *ierr);
typedef void (*fortran_delete_fn_10)(MPI_Fint *comm, MPI_Fint *keyval,
                                     MPI_Fint *attribute_val,
                                     MPI_Fint *extra_state, MPI_Fint *ierr);

static int call_copy_attr(MPI_Fint handle, int keyval, void *extra_state,
                          void *attribute_val_in, void *attribute_val_out,
                          int *flag) {
  const struct attr_entry *const entry = find_attr_entry(keyval);
  if (!entry || !entry->copy_fn)
    return MPI_ERR_OTHER;

  MPI_Fint f_handle = handle, f_keyval = keyval;
  MPI_Fint f_flag = 0, f_ierror = MPI_SUCCESS;
  MPI_Aint f_extra_state = (MPI_Aint)extra_state;
  MPI_Aint f_val_in = (MPI_Aint)attribute_val_in, f_val_out = 0;

  ((fortran_copy_attr_fn)entry->copy_fn)(&f_handle, &f_keyval, &f_extra_state,
                                         &f_val_in, &f_val_out, &f_flag,
                                         &f_ierror);

  *(void **)attribute_val_out = (void *)f_val_out;
  *flag = mpif_logical2bool(f_flag);
  return f_ierror;
}

static int call_delete_attr(MPI_Fint handle, int keyval, void *attribute_val,
                            void *extra_state) {
  const struct attr_entry *const entry = find_attr_entry(keyval);
  if (!entry || !entry->delete_fn)
    return MPI_ERR_OTHER;

  MPI_Fint f_handle = handle, f_keyval = keyval, f_ierror = MPI_SUCCESS;
  MPI_Aint f_val = (MPI_Aint)attribute_val;
  MPI_Aint f_extra_state = (MPI_Aint)extra_state;

  ((fortran_delete_attr_fn)entry->delete_fn)(&f_handle, &f_keyval, &f_val,
                                             &f_extra_state, &f_ierror);
  return f_ierror;
}

static int comm_copy_attr(MPI_Comm oldcomm, int keyval, void *extra_state,
                          void *attribute_val_in, void *attribute_val_out,
                          int *flag) {
  return call_copy_attr(comm_toint(oldcomm), keyval, extra_state,
                        attribute_val_in, attribute_val_out, flag);
}

static int comm_delete_attr(MPI_Comm comm, int keyval, void *attribute_val,
                            void *extra_state) {
  return call_delete_attr(comm_toint(comm), keyval, attribute_val, extra_state);
}

static int type_copy_attr(MPI_Datatype oldtype, int keyval, void *extra_state,
                          void *attribute_val_in, void *attribute_val_out,
                          int *flag) {
  return call_copy_attr(type_toint(oldtype), keyval, extra_state,
                        attribute_val_in, attribute_val_out, flag);
}

static int type_delete_attr(MPI_Datatype datatype, int keyval,
                            void *attribute_val, void *extra_state) {
  return call_delete_attr(type_toint(datatype), keyval, attribute_val,
                          extra_state);
}

static int win_copy_attr(MPI_Win oldwin, int keyval, void *extra_state,
                         void *attribute_val_in, void *attribute_val_out,
                         int *flag) {
  return call_copy_attr(win_toint(oldwin), keyval, extra_state,
                        attribute_val_in, attribute_val_out, flag);
}

static int win_delete_attr(MPI_Win win, int keyval, void *attribute_val,
                           void *extra_state) {
  return call_delete_attr(win_toint(win), keyval, attribute_val, extra_state);
}

// The MPI-1 forms, whose attribute values and extra state are default integers

static int comm_copy_attr_10(MPI_Comm oldcomm, int keyval, void *extra_state,
                             void *attribute_val_in, void *attribute_val_out,
                             int *flag) {
  const struct attr_entry *const entry = find_attr_entry(keyval);
  if (!entry || !entry->copy_fn)
    return MPI_ERR_OTHER;

  MPI_Fint f_comm = comm_toint(oldcomm), f_keyval = keyval;
  MPI_Fint f_flag = 0, f_ierr = MPI_SUCCESS;
  MPI_Fint f_extra_state = (MPI_Fint)(intptr_t)extra_state;
  MPI_Fint f_val_in = (MPI_Fint)(intptr_t)attribute_val_in, f_val_out = 0;

  ((fortran_copy_fn_10)entry->copy_fn)(&f_comm, &f_keyval, &f_extra_state,
                                       &f_val_in, &f_val_out, &f_flag, &f_ierr);

  *(void **)attribute_val_out = (void *)(intptr_t)f_val_out;
  *flag = mpif_logical2bool(f_flag);
  return f_ierr;
}

static int comm_delete_attr_10(MPI_Comm comm, int keyval, void *attribute_val,
                               void *extra_state) {
  const struct attr_entry *const entry = find_attr_entry(keyval);
  if (!entry || !entry->delete_fn)
    return MPI_ERR_OTHER;

  MPI_Fint f_comm = comm_toint(comm), f_keyval = keyval, f_ierr = MPI_SUCCESS;
  MPI_Fint f_val = (MPI_Fint)(intptr_t)attribute_val;
  MPI_Fint f_extra_state = (MPI_Fint)(intptr_t)extra_state;

  ((fortran_delete_fn_10)entry->delete_fn)(&f_comm, &f_keyval, &f_val,
                                           &f_extra_state, &f_ierr);
  return f_ierr;
}

void *mpif_attr_trampoline(enum mpif_attr_callback_kind kind) {
  switch (kind) {
  case MPIF_ATTR_COMM_COPY:      return (void *)comm_copy_attr;
  case MPIF_ATTR_COMM_DELETE:    return (void *)comm_delete_attr;
  case MPIF_ATTR_TYPE_COPY:      return (void *)type_copy_attr;
  case MPIF_ATTR_TYPE_DELETE:    return (void *)type_delete_attr;
  case MPIF_ATTR_WIN_COPY:       return (void *)win_copy_attr;
  case MPIF_ATTR_WIN_DELETE:     return (void *)win_delete_attr;
  case MPIF_ATTR_COMM_COPY_10:   return (void *)comm_copy_attr_10;
  case MPIF_ATTR_COMM_DELETE_10: return (void *)comm_delete_attr_10;
  }
  return NULL;
}

int mpif_register_attr_callback(int keyval, enum mpif_attr_callback_kind kind,
                                mpif_fortran_procedure callback) {
  void *predefined;
  if (mpif_predefined_callback(callback, &predefined))
    return MPI_SUCCESS; // MPI was handed its own sentinel, nothing to record

  struct attr_entry *entry = find_attr_entry(keyval);
  if (!entry) {
    for (size_t i = 0; i < MPIF_MAX_KEYVALS; ++i) {
      int expected = MPI_KEYVAL_INVALID;
      if (atomic_compare_exchange_strong_explicit(
              &attr_entries[i].keyval, &expected, KEYVAL_RESERVED,
              memory_order_acq_rel, memory_order_relaxed)) {
        entry = &attr_entries[i];
        break;
      }
    }
    if (!entry) {
      fprintf(stderr,
              "mpif: no room to record the Fortran attribute callbacks for "
              "keyval %d; at most %d keyvals with user-defined callbacks can "
              "exist at a time\n",
              keyval, (int)MPIF_MAX_KEYVALS);
      return MPI_ERR_OTHER;
    }
    entry->copy_fn = NULL;
    entry->delete_fn = NULL;
    atomic_store_explicit(&entry->keyval, keyval, memory_order_release);
  }

  switch (kind) {
  case MPIF_ATTR_COMM_COPY:
  case MPIF_ATTR_TYPE_COPY:
  case MPIF_ATTR_WIN_COPY:
  case MPIF_ATTR_COMM_COPY_10:
    entry->copy_fn = callback;
    break;
  default:
    entry->delete_fn = callback;
    break;
  }
  // Make the procedure visible to a thread that later finds this entry
  atomic_thread_fence(memory_order_release);
  return MPI_SUCCESS;
}

int mpif_unsupported_callback(const char *routine, const char *argument) {
  fprintf(stderr,
          "mpif: %s: a user-defined Fortran procedure was passed as %s, "
          "which mpif cannot forward to MPI yet; returning MPI_ERR_OTHER. "
          "Only the predefined callbacks such as MPI_COMM_NULL_COPY_FN work "
          "at the moment; see MISSING.md.\n",
          routine, argument);
  return MPI_ERR_OTHER;
}
