#include <mpif_callbacks.h>

#include <mpi.h>
#include <stddef.h>
#include <mpif_logical.h>

#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

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

// And mpi_f08's, from src/mpif_f08_attr_fns.F90. Separate procedures because a
// handle there is a derived type rather than an INTEGER, so they are separate
// addresses and need their own entries.
//
// Attribute callbacks would survive without them: an address this table does not
// know is treated as user-defined and given a trampoline, and these bodies do
// what the sentinel does, so the observable behaviour is the same. Recognising
// them anyway is what the ABI intends, spends no keyval registry slot on a
// callback MPI already knows, and is the only route that will work for the two
// conversion functions once MPI_Register_datarep forwards callbacks at all.
extern void mpif_f08_comm_null_copy_fn_(void);
extern void mpif_f08_comm_dup_fn_(void);
extern void mpif_f08_comm_null_delete_fn_(void);
extern void mpif_f08_type_null_copy_fn_(void);
extern void mpif_f08_type_dup_fn_(void);
extern void mpif_f08_type_null_delete_fn_(void);
extern void mpif_f08_win_null_copy_fn_(void);
extern void mpif_f08_win_dup_fn_(void);
extern void mpif_f08_win_null_delete_fn_(void);
extern void mpif_f08_conversion_fn_null_(void);
extern void mpif_f08_conversion_fn_null_c_(void);

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

    // mpi_f08's, which stand for the same ABI sentinels
    {mpif_f08_comm_null_copy_fn_, (void *)MPI_COMM_NULL_COPY_FN},
    {mpif_f08_comm_dup_fn_, (void *)MPI_COMM_DUP_FN},
    {mpif_f08_comm_null_delete_fn_, (void *)MPI_COMM_NULL_DELETE_FN},

    {mpif_f08_type_null_copy_fn_, (void *)MPI_TYPE_NULL_COPY_FN},
    {mpif_f08_type_dup_fn_, (void *)MPI_TYPE_DUP_FN},
    {mpif_f08_type_null_delete_fn_, (void *)MPI_TYPE_NULL_DELETE_FN},

    {mpif_f08_win_null_copy_fn_, (void *)MPI_WIN_NULL_COPY_FN},
    {mpif_f08_win_dup_fn_, (void *)MPI_WIN_DUP_FN},
    {mpif_f08_win_null_delete_fn_, (void *)MPI_WIN_NULL_DELETE_FN},

    {mpif_f08_conversion_fn_null_, (void *)MPI_CONVERSION_FN_NULL},
    {mpif_f08_conversion_fn_null_c_, (void *)MPI_CONVERSION_FN_NULL_C},
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
  return call_copy_attr(MPI_Comm_toint(oldcomm), keyval, extra_state,
                        attribute_val_in, attribute_val_out, flag);
}

static int comm_delete_attr(MPI_Comm comm, int keyval, void *attribute_val,
                            void *extra_state) {
  return call_delete_attr(MPI_Comm_toint(comm), keyval, attribute_val, extra_state);
}

static int type_copy_attr(MPI_Datatype oldtype, int keyval, void *extra_state,
                          void *attribute_val_in, void *attribute_val_out,
                          int *flag) {
  return call_copy_attr(MPI_Type_toint(oldtype), keyval, extra_state,
                        attribute_val_in, attribute_val_out, flag);
}

static int type_delete_attr(MPI_Datatype datatype, int keyval,
                            void *attribute_val, void *extra_state) {
  return call_delete_attr(MPI_Type_toint(datatype), keyval, attribute_val,
                          extra_state);
}

static int win_copy_attr(MPI_Win oldwin, int keyval, void *extra_state,
                         void *attribute_val_in, void *attribute_val_out,
                         int *flag) {
  return call_copy_attr(MPI_Win_toint(oldwin), keyval, extra_state,
                        attribute_val_in, attribute_val_out, flag);
}

static int win_delete_attr(MPI_Win win, int keyval, void *attribute_val,
                           void *extra_state) {
  return call_delete_attr(MPI_Win_toint(win), keyval, attribute_val, extra_state);
}

// The MPI-1 forms, whose attribute values and extra state are default integers

static int comm_copy_attr_10(MPI_Comm oldcomm, int keyval, void *extra_state,
                             void *attribute_val_in, void *attribute_val_out,
                             int *flag) {
  const struct attr_entry *const entry = find_attr_entry(keyval);
  if (!entry || !entry->copy_fn)
    return MPI_ERR_OTHER;

  MPI_Fint f_comm = MPI_Comm_toint(oldcomm), f_keyval = keyval;
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

  MPI_Fint f_comm = MPI_Comm_toint(comm), f_keyval = keyval, f_ierr = MPI_SUCCESS;
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
          "at the moment.\n",
          routine, argument);
  return MPI_ERR_OTHER;
}

////////////////////////////////////////////////////////////////////////////////
// User-defined reduction operators
//
// A slot is occupied for the lifetime of the program, and MPI_Op_free does not
// give it back. Freeing an op only marks it for deallocation: MPI 5.0 section
// 2.5.1 has it that "the object itself still persists until any pending
// operations are complete", so a nonblocking reduction started before the free
// may call the trampoline long after. Were the slot reused in the meantime, the
// call would arrive at some other operator's Fortran procedure. There is no way
// to observe when MPI has finished with the op, so the slot is retired instead.

enum { MPIF_OP_SLOTS = 128 };

struct op_slot {
  _Atomic int in_use;
  mpif_fortran_procedure fn;
};

static struct op_slot op_slots[MPIF_OP_SLOTS];

// The Fortran procedure takes the buffers as choice buffers, which pass
// straight through, plus the length and the datatype handle as integers.
typedef void (*fortran_user_fn)(void *invec, void *inoutvec, MPI_Fint *len,
                               MPI_Fint *datatype);
typedef void (*fortran_user_fn_c)(void *invec, void *inoutvec, MPI_Count *len,
                                  MPI_Fint *datatype);

static void call_user_fn(int slot, void *invec, void *inoutvec, int *len,
                         MPI_Datatype *datatype) {
  const mpif_fortran_procedure fn = op_slots[slot].fn;
  if (!fn)
    return;
  MPI_Fint f_len = (MPI_Fint)*len;
  MPI_Fint f_datatype = MPI_Type_toint(*datatype);
  ((fortran_user_fn)fn)(invec, inoutvec, &f_len, &f_datatype);
}

static void call_user_fn_c(int slot, void *invec, void *inoutvec, MPI_Count *len,
                           MPI_Datatype *datatype) {
  const mpif_fortran_procedure fn = op_slots[slot].fn;
  if (!fn)
    return;
  MPI_Count f_len = *len;
  MPI_Fint f_datatype = MPI_Type_toint(*datatype);
  ((fortran_user_fn_c)fn)(invec, inoutvec, &f_len, &f_datatype);
}

// One pair of trampolines per slot, each knowing its slot at compile time
#define MPIF_DEFINE_OP_TRAMPOLINE(slot)                                        \
  static void op_trampoline_##slot(void *invec, void *inoutvec, int *len,      \
                                   MPI_Datatype *datatype) {                   \
    call_user_fn(slot, invec, inoutvec, len, datatype);                        \
  }                                                                            \
  static void op_trampoline_c_##slot(void *invec, void *inoutvec,              \
                                     MPI_Count *len,                           \
                                     MPI_Datatype *datatype) {                 \
    call_user_fn_c(slot, invec, inoutvec, len, datatype);                      \
  }

MPIF_DEFINE_OP_TRAMPOLINE(0)
MPIF_DEFINE_OP_TRAMPOLINE(1)
MPIF_DEFINE_OP_TRAMPOLINE(2)
MPIF_DEFINE_OP_TRAMPOLINE(3)
MPIF_DEFINE_OP_TRAMPOLINE(4)
MPIF_DEFINE_OP_TRAMPOLINE(5)
MPIF_DEFINE_OP_TRAMPOLINE(6)
MPIF_DEFINE_OP_TRAMPOLINE(7)
MPIF_DEFINE_OP_TRAMPOLINE(8)
MPIF_DEFINE_OP_TRAMPOLINE(9)
MPIF_DEFINE_OP_TRAMPOLINE(10)
MPIF_DEFINE_OP_TRAMPOLINE(11)
MPIF_DEFINE_OP_TRAMPOLINE(12)
MPIF_DEFINE_OP_TRAMPOLINE(13)
MPIF_DEFINE_OP_TRAMPOLINE(14)
MPIF_DEFINE_OP_TRAMPOLINE(15)
MPIF_DEFINE_OP_TRAMPOLINE(16)
MPIF_DEFINE_OP_TRAMPOLINE(17)
MPIF_DEFINE_OP_TRAMPOLINE(18)
MPIF_DEFINE_OP_TRAMPOLINE(19)
MPIF_DEFINE_OP_TRAMPOLINE(20)
MPIF_DEFINE_OP_TRAMPOLINE(21)
MPIF_DEFINE_OP_TRAMPOLINE(22)
MPIF_DEFINE_OP_TRAMPOLINE(23)
MPIF_DEFINE_OP_TRAMPOLINE(24)
MPIF_DEFINE_OP_TRAMPOLINE(25)
MPIF_DEFINE_OP_TRAMPOLINE(26)
MPIF_DEFINE_OP_TRAMPOLINE(27)
MPIF_DEFINE_OP_TRAMPOLINE(28)
MPIF_DEFINE_OP_TRAMPOLINE(29)
MPIF_DEFINE_OP_TRAMPOLINE(30)
MPIF_DEFINE_OP_TRAMPOLINE(31)
MPIF_DEFINE_OP_TRAMPOLINE(32)
MPIF_DEFINE_OP_TRAMPOLINE(33)
MPIF_DEFINE_OP_TRAMPOLINE(34)
MPIF_DEFINE_OP_TRAMPOLINE(35)
MPIF_DEFINE_OP_TRAMPOLINE(36)
MPIF_DEFINE_OP_TRAMPOLINE(37)
MPIF_DEFINE_OP_TRAMPOLINE(38)
MPIF_DEFINE_OP_TRAMPOLINE(39)
MPIF_DEFINE_OP_TRAMPOLINE(40)
MPIF_DEFINE_OP_TRAMPOLINE(41)
MPIF_DEFINE_OP_TRAMPOLINE(42)
MPIF_DEFINE_OP_TRAMPOLINE(43)
MPIF_DEFINE_OP_TRAMPOLINE(44)
MPIF_DEFINE_OP_TRAMPOLINE(45)
MPIF_DEFINE_OP_TRAMPOLINE(46)
MPIF_DEFINE_OP_TRAMPOLINE(47)
MPIF_DEFINE_OP_TRAMPOLINE(48)
MPIF_DEFINE_OP_TRAMPOLINE(49)
MPIF_DEFINE_OP_TRAMPOLINE(50)
MPIF_DEFINE_OP_TRAMPOLINE(51)
MPIF_DEFINE_OP_TRAMPOLINE(52)
MPIF_DEFINE_OP_TRAMPOLINE(53)
MPIF_DEFINE_OP_TRAMPOLINE(54)
MPIF_DEFINE_OP_TRAMPOLINE(55)
MPIF_DEFINE_OP_TRAMPOLINE(56)
MPIF_DEFINE_OP_TRAMPOLINE(57)
MPIF_DEFINE_OP_TRAMPOLINE(58)
MPIF_DEFINE_OP_TRAMPOLINE(59)
MPIF_DEFINE_OP_TRAMPOLINE(60)
MPIF_DEFINE_OP_TRAMPOLINE(61)
MPIF_DEFINE_OP_TRAMPOLINE(62)
MPIF_DEFINE_OP_TRAMPOLINE(63)
MPIF_DEFINE_OP_TRAMPOLINE(64)
MPIF_DEFINE_OP_TRAMPOLINE(65)
MPIF_DEFINE_OP_TRAMPOLINE(66)
MPIF_DEFINE_OP_TRAMPOLINE(67)
MPIF_DEFINE_OP_TRAMPOLINE(68)
MPIF_DEFINE_OP_TRAMPOLINE(69)
MPIF_DEFINE_OP_TRAMPOLINE(70)
MPIF_DEFINE_OP_TRAMPOLINE(71)
MPIF_DEFINE_OP_TRAMPOLINE(72)
MPIF_DEFINE_OP_TRAMPOLINE(73)
MPIF_DEFINE_OP_TRAMPOLINE(74)
MPIF_DEFINE_OP_TRAMPOLINE(75)
MPIF_DEFINE_OP_TRAMPOLINE(76)
MPIF_DEFINE_OP_TRAMPOLINE(77)
MPIF_DEFINE_OP_TRAMPOLINE(78)
MPIF_DEFINE_OP_TRAMPOLINE(79)
MPIF_DEFINE_OP_TRAMPOLINE(80)
MPIF_DEFINE_OP_TRAMPOLINE(81)
MPIF_DEFINE_OP_TRAMPOLINE(82)
MPIF_DEFINE_OP_TRAMPOLINE(83)
MPIF_DEFINE_OP_TRAMPOLINE(84)
MPIF_DEFINE_OP_TRAMPOLINE(85)
MPIF_DEFINE_OP_TRAMPOLINE(86)
MPIF_DEFINE_OP_TRAMPOLINE(87)
MPIF_DEFINE_OP_TRAMPOLINE(88)
MPIF_DEFINE_OP_TRAMPOLINE(89)
MPIF_DEFINE_OP_TRAMPOLINE(90)
MPIF_DEFINE_OP_TRAMPOLINE(91)
MPIF_DEFINE_OP_TRAMPOLINE(92)
MPIF_DEFINE_OP_TRAMPOLINE(93)
MPIF_DEFINE_OP_TRAMPOLINE(94)
MPIF_DEFINE_OP_TRAMPOLINE(95)
MPIF_DEFINE_OP_TRAMPOLINE(96)
MPIF_DEFINE_OP_TRAMPOLINE(97)
MPIF_DEFINE_OP_TRAMPOLINE(98)
MPIF_DEFINE_OP_TRAMPOLINE(99)
MPIF_DEFINE_OP_TRAMPOLINE(100)
MPIF_DEFINE_OP_TRAMPOLINE(101)
MPIF_DEFINE_OP_TRAMPOLINE(102)
MPIF_DEFINE_OP_TRAMPOLINE(103)
MPIF_DEFINE_OP_TRAMPOLINE(104)
MPIF_DEFINE_OP_TRAMPOLINE(105)
MPIF_DEFINE_OP_TRAMPOLINE(106)
MPIF_DEFINE_OP_TRAMPOLINE(107)
MPIF_DEFINE_OP_TRAMPOLINE(108)
MPIF_DEFINE_OP_TRAMPOLINE(109)
MPIF_DEFINE_OP_TRAMPOLINE(110)
MPIF_DEFINE_OP_TRAMPOLINE(111)
MPIF_DEFINE_OP_TRAMPOLINE(112)
MPIF_DEFINE_OP_TRAMPOLINE(113)
MPIF_DEFINE_OP_TRAMPOLINE(114)
MPIF_DEFINE_OP_TRAMPOLINE(115)
MPIF_DEFINE_OP_TRAMPOLINE(116)
MPIF_DEFINE_OP_TRAMPOLINE(117)
MPIF_DEFINE_OP_TRAMPOLINE(118)
MPIF_DEFINE_OP_TRAMPOLINE(119)
MPIF_DEFINE_OP_TRAMPOLINE(120)
MPIF_DEFINE_OP_TRAMPOLINE(121)
MPIF_DEFINE_OP_TRAMPOLINE(122)
MPIF_DEFINE_OP_TRAMPOLINE(123)
MPIF_DEFINE_OP_TRAMPOLINE(124)
MPIF_DEFINE_OP_TRAMPOLINE(125)
MPIF_DEFINE_OP_TRAMPOLINE(126)
MPIF_DEFINE_OP_TRAMPOLINE(127)

static MPI_User_function *const op_trampolines[MPIF_OP_SLOTS] = {
    op_trampoline_0, op_trampoline_1, op_trampoline_2, op_trampoline_3,
    op_trampoline_4, op_trampoline_5, op_trampoline_6, op_trampoline_7,
    op_trampoline_8, op_trampoline_9, op_trampoline_10, op_trampoline_11,
    op_trampoline_12, op_trampoline_13, op_trampoline_14, op_trampoline_15,
    op_trampoline_16, op_trampoline_17, op_trampoline_18, op_trampoline_19,
    op_trampoline_20, op_trampoline_21, op_trampoline_22, op_trampoline_23,
    op_trampoline_24, op_trampoline_25, op_trampoline_26, op_trampoline_27,
    op_trampoline_28, op_trampoline_29, op_trampoline_30, op_trampoline_31,
    op_trampoline_32, op_trampoline_33, op_trampoline_34, op_trampoline_35,
    op_trampoline_36, op_trampoline_37, op_trampoline_38, op_trampoline_39,
    op_trampoline_40, op_trampoline_41, op_trampoline_42, op_trampoline_43,
    op_trampoline_44, op_trampoline_45, op_trampoline_46, op_trampoline_47,
    op_trampoline_48, op_trampoline_49, op_trampoline_50, op_trampoline_51,
    op_trampoline_52, op_trampoline_53, op_trampoline_54, op_trampoline_55,
    op_trampoline_56, op_trampoline_57, op_trampoline_58, op_trampoline_59,
    op_trampoline_60, op_trampoline_61, op_trampoline_62, op_trampoline_63,
    op_trampoline_64, op_trampoline_65, op_trampoline_66, op_trampoline_67,
    op_trampoline_68, op_trampoline_69, op_trampoline_70, op_trampoline_71,
    op_trampoline_72, op_trampoline_73, op_trampoline_74, op_trampoline_75,
    op_trampoline_76, op_trampoline_77, op_trampoline_78, op_trampoline_79,
    op_trampoline_80, op_trampoline_81, op_trampoline_82, op_trampoline_83,
    op_trampoline_84, op_trampoline_85, op_trampoline_86, op_trampoline_87,
    op_trampoline_88, op_trampoline_89, op_trampoline_90, op_trampoline_91,
    op_trampoline_92, op_trampoline_93, op_trampoline_94, op_trampoline_95,
    op_trampoline_96, op_trampoline_97, op_trampoline_98, op_trampoline_99,
    op_trampoline_100, op_trampoline_101, op_trampoline_102, op_trampoline_103,
    op_trampoline_104, op_trampoline_105, op_trampoline_106, op_trampoline_107,
    op_trampoline_108, op_trampoline_109, op_trampoline_110, op_trampoline_111,
    op_trampoline_112, op_trampoline_113, op_trampoline_114, op_trampoline_115,
    op_trampoline_116, op_trampoline_117, op_trampoline_118, op_trampoline_119,
    op_trampoline_120, op_trampoline_121, op_trampoline_122, op_trampoline_123,
    op_trampoline_124, op_trampoline_125, op_trampoline_126, op_trampoline_127,
};

static MPI_User_function_c *const op_trampolines_c[MPIF_OP_SLOTS] = {
    op_trampoline_c_0, op_trampoline_c_1, op_trampoline_c_2, op_trampoline_c_3,
    op_trampoline_c_4, op_trampoline_c_5, op_trampoline_c_6, op_trampoline_c_7,
    op_trampoline_c_8, op_trampoline_c_9, op_trampoline_c_10, op_trampoline_c_11,
    op_trampoline_c_12, op_trampoline_c_13, op_trampoline_c_14, op_trampoline_c_15,
    op_trampoline_c_16, op_trampoline_c_17, op_trampoline_c_18, op_trampoline_c_19,
    op_trampoline_c_20, op_trampoline_c_21, op_trampoline_c_22, op_trampoline_c_23,
    op_trampoline_c_24, op_trampoline_c_25, op_trampoline_c_26, op_trampoline_c_27,
    op_trampoline_c_28, op_trampoline_c_29, op_trampoline_c_30, op_trampoline_c_31,
    op_trampoline_c_32, op_trampoline_c_33, op_trampoline_c_34, op_trampoline_c_35,
    op_trampoline_c_36, op_trampoline_c_37, op_trampoline_c_38, op_trampoline_c_39,
    op_trampoline_c_40, op_trampoline_c_41, op_trampoline_c_42, op_trampoline_c_43,
    op_trampoline_c_44, op_trampoline_c_45, op_trampoline_c_46, op_trampoline_c_47,
    op_trampoline_c_48, op_trampoline_c_49, op_trampoline_c_50, op_trampoline_c_51,
    op_trampoline_c_52, op_trampoline_c_53, op_trampoline_c_54, op_trampoline_c_55,
    op_trampoline_c_56, op_trampoline_c_57, op_trampoline_c_58, op_trampoline_c_59,
    op_trampoline_c_60, op_trampoline_c_61, op_trampoline_c_62, op_trampoline_c_63,
    op_trampoline_c_64, op_trampoline_c_65, op_trampoline_c_66, op_trampoline_c_67,
    op_trampoline_c_68, op_trampoline_c_69, op_trampoline_c_70, op_trampoline_c_71,
    op_trampoline_c_72, op_trampoline_c_73, op_trampoline_c_74, op_trampoline_c_75,
    op_trampoline_c_76, op_trampoline_c_77, op_trampoline_c_78, op_trampoline_c_79,
    op_trampoline_c_80, op_trampoline_c_81, op_trampoline_c_82, op_trampoline_c_83,
    op_trampoline_c_84, op_trampoline_c_85, op_trampoline_c_86, op_trampoline_c_87,
    op_trampoline_c_88, op_trampoline_c_89, op_trampoline_c_90, op_trampoline_c_91,
    op_trampoline_c_92, op_trampoline_c_93, op_trampoline_c_94, op_trampoline_c_95,
    op_trampoline_c_96, op_trampoline_c_97, op_trampoline_c_98, op_trampoline_c_99,
    op_trampoline_c_100, op_trampoline_c_101, op_trampoline_c_102, op_trampoline_c_103,
    op_trampoline_c_104, op_trampoline_c_105, op_trampoline_c_106, op_trampoline_c_107,
    op_trampoline_c_108, op_trampoline_c_109, op_trampoline_c_110, op_trampoline_c_111,
    op_trampoline_c_112, op_trampoline_c_113, op_trampoline_c_114, op_trampoline_c_115,
    op_trampoline_c_116, op_trampoline_c_117, op_trampoline_c_118, op_trampoline_c_119,
    op_trampoline_c_120, op_trampoline_c_121, op_trampoline_c_122, op_trampoline_c_123,
    op_trampoline_c_124, op_trampoline_c_125, op_trampoline_c_126, op_trampoline_c_127,
};

void *mpif_op_reserve(mpif_fortran_procedure callback, int large, int *slot) {
  for (int i = 0; i < MPIF_OP_SLOTS; ++i) {
    int expected = 0;
    if (atomic_compare_exchange_strong_explicit(&op_slots[i].in_use, &expected,
                                                1, memory_order_acq_rel,
                                                memory_order_relaxed)) {
      op_slots[i].fn = callback;
      *slot = i;
      return large ? (void *)op_trampolines_c[i] : (void *)op_trampolines[i];
    }
  }
  fprintf(stderr,
          "mpif: no room for another user-defined reduction operator; at most "
          "%d can be created over the lifetime of the program\n",
          (int)MPIF_OP_SLOTS);
  *slot = -1;
  return NULL;
}

void mpif_op_cancel(int slot) {
  if (slot < 0 || slot >= MPIF_OP_SLOTS)
    return;
  op_slots[slot].fn = NULL;
  atomic_store_explicit(&op_slots[slot].in_use, 0, memory_order_release);
}


////////////////////////////////////////////////////////////////////////////////
// User-defined error handlers
//
// An error handler is called with the object that raised the error and the
// error code, and nothing that says which handler is running -- the same
// problem as reduction operators, and the same solution: a pool of
// pre-generated trampolines, one per created handler.
//
// Slots are never released. MPI_Errhandler_free only marks a handler for
// deallocation, and it stays in use by every communicator, window, file and
// session it is still attached to -- and, unlike an operator, an error handler
// is most likely to be called long after the program stopped thinking about it.
// A handler is not something a program creates in a loop, so a fixed budget for
// the lifetime of the program is not a real restriction.

enum { MPIF_ERRHANDLER_SLOTS = 64 };

struct errhandler_slot {
  _Atomic int in_use;
  mpif_fortran_procedure fn;
};

static struct errhandler_slot errhandler_slots[MPIF_ERRHANDLER_SLOTS];

// The Fortran procedure takes the handle and the error code as INTEGERs. The
// error code is copied back: the C prototype passes it by pointer, so a handler
// is free to change it.
typedef void (*fortran_errhandler_fn)(MPI_Fint *handle, MPI_Fint *error_code);

static void call_comm_errhandler(int slot, MPI_Comm *handle,
                                  int *error_code) {
  const mpif_fortran_procedure fn = errhandler_slots[slot].fn;
  if (!fn)
    return;
  MPI_Fint f_handle = MPI_Comm_toint(*handle), f_error_code = *error_code;
  ((fortran_errhandler_fn)fn)(&f_handle, &f_error_code);
  *error_code = f_error_code;
}

static void call_win_errhandler(int slot, MPI_Win *handle,
                                  int *error_code) {
  const mpif_fortran_procedure fn = errhandler_slots[slot].fn;
  if (!fn)
    return;
  MPI_Fint f_handle = MPI_Win_toint(*handle), f_error_code = *error_code;
  ((fortran_errhandler_fn)fn)(&f_handle, &f_error_code);
  *error_code = f_error_code;
}

static void call_file_errhandler(int slot, MPI_File *handle,
                                  int *error_code) {
  const mpif_fortran_procedure fn = errhandler_slots[slot].fn;
  if (!fn)
    return;
  MPI_Fint f_handle = MPI_File_toint(*handle), f_error_code = *error_code;
  ((fortran_errhandler_fn)fn)(&f_handle, &f_error_code);
  *error_code = f_error_code;
}

static void call_session_errhandler(int slot, MPI_Session *handle,
                                  int *error_code) {
  const mpif_fortran_procedure fn = errhandler_slots[slot].fn;
  if (!fn)
    return;
  MPI_Fint f_handle = MPI_Session_toint(*handle), f_error_code = *error_code;
  ((fortran_errhandler_fn)fn)(&f_handle, &f_error_code);
  *error_code = f_error_code;
}

#define MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(slot)                               \
  static void comm_errhandler_trampoline_##slot(MPI_Comm *handle,             \
                                                int *error_code, ...) {        \
    call_comm_errhandler(slot, handle, error_code);                           \
  }                                                                             \
  static void win_errhandler_trampoline_##slot(MPI_Win *handle,             \
                                                int *error_code, ...) {        \
    call_win_errhandler(slot, handle, error_code);                           \
  }                                                                             \
  static void file_errhandler_trampoline_##slot(MPI_File *handle,             \
                                                int *error_code, ...) {        \
    call_file_errhandler(slot, handle, error_code);                           \
  }                                                                             \
  static void session_errhandler_trampoline_##slot(MPI_Session *handle,             \
                                                int *error_code, ...) {        \
    call_session_errhandler(slot, handle, error_code);                           \
  }

MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(0)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(1)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(2)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(3)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(4)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(5)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(6)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(7)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(8)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(9)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(10)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(11)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(12)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(13)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(14)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(15)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(16)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(17)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(18)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(19)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(20)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(21)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(22)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(23)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(24)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(25)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(26)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(27)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(28)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(29)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(30)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(31)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(32)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(33)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(34)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(35)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(36)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(37)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(38)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(39)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(40)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(41)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(42)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(43)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(44)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(45)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(46)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(47)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(48)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(49)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(50)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(51)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(52)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(53)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(54)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(55)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(56)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(57)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(58)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(59)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(60)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(61)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(62)
MPIF_DEFINE_ERRHANDLER_TRAMPOLINES(63)

static MPI_Comm_errhandler_function *const comm_errhandler_trampolines[MPIF_ERRHANDLER_SLOTS] = {
    comm_errhandler_trampoline_0, comm_errhandler_trampoline_1, comm_errhandler_trampoline_2, comm_errhandler_trampoline_3,
    comm_errhandler_trampoline_4, comm_errhandler_trampoline_5, comm_errhandler_trampoline_6, comm_errhandler_trampoline_7,
    comm_errhandler_trampoline_8, comm_errhandler_trampoline_9, comm_errhandler_trampoline_10, comm_errhandler_trampoline_11,
    comm_errhandler_trampoline_12, comm_errhandler_trampoline_13, comm_errhandler_trampoline_14, comm_errhandler_trampoline_15,
    comm_errhandler_trampoline_16, comm_errhandler_trampoline_17, comm_errhandler_trampoline_18, comm_errhandler_trampoline_19,
    comm_errhandler_trampoline_20, comm_errhandler_trampoline_21, comm_errhandler_trampoline_22, comm_errhandler_trampoline_23,
    comm_errhandler_trampoline_24, comm_errhandler_trampoline_25, comm_errhandler_trampoline_26, comm_errhandler_trampoline_27,
    comm_errhandler_trampoline_28, comm_errhandler_trampoline_29, comm_errhandler_trampoline_30, comm_errhandler_trampoline_31,
    comm_errhandler_trampoline_32, comm_errhandler_trampoline_33, comm_errhandler_trampoline_34, comm_errhandler_trampoline_35,
    comm_errhandler_trampoline_36, comm_errhandler_trampoline_37, comm_errhandler_trampoline_38, comm_errhandler_trampoline_39,
    comm_errhandler_trampoline_40, comm_errhandler_trampoline_41, comm_errhandler_trampoline_42, comm_errhandler_trampoline_43,
    comm_errhandler_trampoline_44, comm_errhandler_trampoline_45, comm_errhandler_trampoline_46, comm_errhandler_trampoline_47,
    comm_errhandler_trampoline_48, comm_errhandler_trampoline_49, comm_errhandler_trampoline_50, comm_errhandler_trampoline_51,
    comm_errhandler_trampoline_52, comm_errhandler_trampoline_53, comm_errhandler_trampoline_54, comm_errhandler_trampoline_55,
    comm_errhandler_trampoline_56, comm_errhandler_trampoline_57, comm_errhandler_trampoline_58, comm_errhandler_trampoline_59,
    comm_errhandler_trampoline_60, comm_errhandler_trampoline_61, comm_errhandler_trampoline_62, comm_errhandler_trampoline_63,
};

static MPI_Win_errhandler_function *const win_errhandler_trampolines[MPIF_ERRHANDLER_SLOTS] = {
    win_errhandler_trampoline_0, win_errhandler_trampoline_1, win_errhandler_trampoline_2, win_errhandler_trampoline_3,
    win_errhandler_trampoline_4, win_errhandler_trampoline_5, win_errhandler_trampoline_6, win_errhandler_trampoline_7,
    win_errhandler_trampoline_8, win_errhandler_trampoline_9, win_errhandler_trampoline_10, win_errhandler_trampoline_11,
    win_errhandler_trampoline_12, win_errhandler_trampoline_13, win_errhandler_trampoline_14, win_errhandler_trampoline_15,
    win_errhandler_trampoline_16, win_errhandler_trampoline_17, win_errhandler_trampoline_18, win_errhandler_trampoline_19,
    win_errhandler_trampoline_20, win_errhandler_trampoline_21, win_errhandler_trampoline_22, win_errhandler_trampoline_23,
    win_errhandler_trampoline_24, win_errhandler_trampoline_25, win_errhandler_trampoline_26, win_errhandler_trampoline_27,
    win_errhandler_trampoline_28, win_errhandler_trampoline_29, win_errhandler_trampoline_30, win_errhandler_trampoline_31,
    win_errhandler_trampoline_32, win_errhandler_trampoline_33, win_errhandler_trampoline_34, win_errhandler_trampoline_35,
    win_errhandler_trampoline_36, win_errhandler_trampoline_37, win_errhandler_trampoline_38, win_errhandler_trampoline_39,
    win_errhandler_trampoline_40, win_errhandler_trampoline_41, win_errhandler_trampoline_42, win_errhandler_trampoline_43,
    win_errhandler_trampoline_44, win_errhandler_trampoline_45, win_errhandler_trampoline_46, win_errhandler_trampoline_47,
    win_errhandler_trampoline_48, win_errhandler_trampoline_49, win_errhandler_trampoline_50, win_errhandler_trampoline_51,
    win_errhandler_trampoline_52, win_errhandler_trampoline_53, win_errhandler_trampoline_54, win_errhandler_trampoline_55,
    win_errhandler_trampoline_56, win_errhandler_trampoline_57, win_errhandler_trampoline_58, win_errhandler_trampoline_59,
    win_errhandler_trampoline_60, win_errhandler_trampoline_61, win_errhandler_trampoline_62, win_errhandler_trampoline_63,
};

static MPI_File_errhandler_function *const file_errhandler_trampolines[MPIF_ERRHANDLER_SLOTS] = {
    file_errhandler_trampoline_0, file_errhandler_trampoline_1, file_errhandler_trampoline_2, file_errhandler_trampoline_3,
    file_errhandler_trampoline_4, file_errhandler_trampoline_5, file_errhandler_trampoline_6, file_errhandler_trampoline_7,
    file_errhandler_trampoline_8, file_errhandler_trampoline_9, file_errhandler_trampoline_10, file_errhandler_trampoline_11,
    file_errhandler_trampoline_12, file_errhandler_trampoline_13, file_errhandler_trampoline_14, file_errhandler_trampoline_15,
    file_errhandler_trampoline_16, file_errhandler_trampoline_17, file_errhandler_trampoline_18, file_errhandler_trampoline_19,
    file_errhandler_trampoline_20, file_errhandler_trampoline_21, file_errhandler_trampoline_22, file_errhandler_trampoline_23,
    file_errhandler_trampoline_24, file_errhandler_trampoline_25, file_errhandler_trampoline_26, file_errhandler_trampoline_27,
    file_errhandler_trampoline_28, file_errhandler_trampoline_29, file_errhandler_trampoline_30, file_errhandler_trampoline_31,
    file_errhandler_trampoline_32, file_errhandler_trampoline_33, file_errhandler_trampoline_34, file_errhandler_trampoline_35,
    file_errhandler_trampoline_36, file_errhandler_trampoline_37, file_errhandler_trampoline_38, file_errhandler_trampoline_39,
    file_errhandler_trampoline_40, file_errhandler_trampoline_41, file_errhandler_trampoline_42, file_errhandler_trampoline_43,
    file_errhandler_trampoline_44, file_errhandler_trampoline_45, file_errhandler_trampoline_46, file_errhandler_trampoline_47,
    file_errhandler_trampoline_48, file_errhandler_trampoline_49, file_errhandler_trampoline_50, file_errhandler_trampoline_51,
    file_errhandler_trampoline_52, file_errhandler_trampoline_53, file_errhandler_trampoline_54, file_errhandler_trampoline_55,
    file_errhandler_trampoline_56, file_errhandler_trampoline_57, file_errhandler_trampoline_58, file_errhandler_trampoline_59,
    file_errhandler_trampoline_60, file_errhandler_trampoline_61, file_errhandler_trampoline_62, file_errhandler_trampoline_63,
};

static MPI_Session_errhandler_function *const session_errhandler_trampolines[MPIF_ERRHANDLER_SLOTS] = {
    session_errhandler_trampoline_0, session_errhandler_trampoline_1, session_errhandler_trampoline_2, session_errhandler_trampoline_3,
    session_errhandler_trampoline_4, session_errhandler_trampoline_5, session_errhandler_trampoline_6, session_errhandler_trampoline_7,
    session_errhandler_trampoline_8, session_errhandler_trampoline_9, session_errhandler_trampoline_10, session_errhandler_trampoline_11,
    session_errhandler_trampoline_12, session_errhandler_trampoline_13, session_errhandler_trampoline_14, session_errhandler_trampoline_15,
    session_errhandler_trampoline_16, session_errhandler_trampoline_17, session_errhandler_trampoline_18, session_errhandler_trampoline_19,
    session_errhandler_trampoline_20, session_errhandler_trampoline_21, session_errhandler_trampoline_22, session_errhandler_trampoline_23,
    session_errhandler_trampoline_24, session_errhandler_trampoline_25, session_errhandler_trampoline_26, session_errhandler_trampoline_27,
    session_errhandler_trampoline_28, session_errhandler_trampoline_29, session_errhandler_trampoline_30, session_errhandler_trampoline_31,
    session_errhandler_trampoline_32, session_errhandler_trampoline_33, session_errhandler_trampoline_34, session_errhandler_trampoline_35,
    session_errhandler_trampoline_36, session_errhandler_trampoline_37, session_errhandler_trampoline_38, session_errhandler_trampoline_39,
    session_errhandler_trampoline_40, session_errhandler_trampoline_41, session_errhandler_trampoline_42, session_errhandler_trampoline_43,
    session_errhandler_trampoline_44, session_errhandler_trampoline_45, session_errhandler_trampoline_46, session_errhandler_trampoline_47,
    session_errhandler_trampoline_48, session_errhandler_trampoline_49, session_errhandler_trampoline_50, session_errhandler_trampoline_51,
    session_errhandler_trampoline_52, session_errhandler_trampoline_53, session_errhandler_trampoline_54, session_errhandler_trampoline_55,
    session_errhandler_trampoline_56, session_errhandler_trampoline_57, session_errhandler_trampoline_58, session_errhandler_trampoline_59,
    session_errhandler_trampoline_60, session_errhandler_trampoline_61, session_errhandler_trampoline_62, session_errhandler_trampoline_63,
};

void *mpif_errhandler_reserve(mpif_fortran_procedure callback,
                              enum mpif_errhandler_kind kind, int *slot) {
  for (int i = 0; i < MPIF_ERRHANDLER_SLOTS; ++i) {
    int expected = 0;
    if (atomic_compare_exchange_strong_explicit(&errhandler_slots[i].in_use,
                                                &expected, 1,
                                                memory_order_acq_rel,
                                                memory_order_relaxed)) {
      errhandler_slots[i].fn = callback;
      *slot = i;
      switch (kind) {
      case MPIF_ERRHANDLER_COMM:
        return (void *)comm_errhandler_trampolines[i];
      case MPIF_ERRHANDLER_WIN:
        return (void *)win_errhandler_trampolines[i];
      case MPIF_ERRHANDLER_FILE:
        return (void *)file_errhandler_trampolines[i];
      case MPIF_ERRHANDLER_SESSION:
        return (void *)session_errhandler_trampolines[i];
      }
      // An out-of-range kind is a bug in the generated code, not user error
      mpif_errhandler_cancel(i);
      return NULL;
    }
  }
  fprintf(stderr,
          "mpif: no room for another user-defined error handler; at most %d can "
          "be created over the lifetime of the program\n",
          (int)MPIF_ERRHANDLER_SLOTS);
  *slot = -1;
  return NULL;
}

void mpif_errhandler_cancel(int slot) {
  if (slot < 0 || slot >= MPIF_ERRHANDLER_SLOTS)
    return;
  errhandler_slots[slot].fn = NULL;
  atomic_store_explicit(&errhandler_slots[slot].in_use, 0,
                        memory_order_release);
}

////////////////////////////////////////////////////////////////////////////////
// User-defined generalized request callbacks
//
// Like a reduction operator, a generalized request's callbacks are told nothing
// that identifies which request is being served, so there is nothing to look up
// when one fires. Unlike a reduction operator, no pool of trampolines is needed:
// `extra_state` is mpif's to choose, so one trampoline per callback suffices and
// the box it receives says which Fortran procedures to call. See
// include/mpif_callbacks.h for the lifetime argument.

struct grequest_box {
  mpif_fortran_procedure query_fn;
  mpif_fortran_procedure free_fn;
  mpif_fortran_procedure cancel_fn;
  // The caller's Fortran variable, aliased rather than copied; see the header
  MPI_Aint *extra_state;
};

// The Fortran callbacks, as declared in MPI-5.0 section 13.2. `status` is passed
// through untouched: the C MPI_Status is three ints followed by five more and
// MPI_STATUS_SIZE is 8, so one address serves the `INTEGER
// STATUS(MPI_STATUS_SIZE)` of mpif.h and the `bind(C)` TYPE(MPI_Status) of
// mpi_f08 alike. That is the same assumption the generated wrappers make when
// they cast a Fortran status array to MPI_Status*.
typedef void (*fortran_grequest_query_fn)(MPI_Aint *extra_state,
                                          MPI_Status *status, MPI_Fint *ierror);
typedef void (*fortran_grequest_free_fn)(MPI_Aint *extra_state,
                                         MPI_Fint *ierror);
typedef void (*fortran_grequest_cancel_fn)(MPI_Aint *extra_state,
                                           MPI_Fint *complete,
                                           MPI_Fint *ierror);

void *mpif_grequest_reserve(mpif_fortran_procedure query_fn,
                            mpif_fortran_procedure free_fn,
                            mpif_fortran_procedure cancel_fn,
                            MPI_Aint *extra_state) {
  struct grequest_box *const box = malloc(sizeof *box);
  if (!box) {
    fprintf(stderr, "mpif: MPI_Grequest_start: out of memory allocating the "
                    "callback state; returning MPI_ERR_OTHER\n");
    return NULL;
  }
  box->query_fn = query_fn;
  box->free_fn = free_fn;
  box->cancel_fn = cancel_fn;
  box->extra_state = extra_state;
  return box;
}

void mpif_grequest_cancel(void *box) { free(box); }

int mpif_grequest_query_trampoline(void *extra_state, MPI_Status *status) {
  const struct grequest_box *const box = extra_state;
  MPI_Fint f_ierror = MPI_SUCCESS;
  ((fortran_grequest_query_fn)box->query_fn)(box->extra_state, status,
                                             &f_ierror);
  return f_ierror;
}

int mpif_grequest_free_trampoline(void *extra_state) {
  struct grequest_box *const box = extra_state;
  MPI_Fint f_ierror = MPI_SUCCESS;
  ((fortran_grequest_free_fn)box->free_fn)(box->extra_state, &f_ierror);
  // The last callback this request will make, so the box goes with it
  free(box);
  return f_ierror;
}

int mpif_grequest_cancel_trampoline(void *extra_state, int complete) {
  const struct grequest_box *const box = extra_state;
  MPI_Fint f_complete = mpif_bool2logical(complete);
  MPI_Fint f_ierror = MPI_SUCCESS;
  ((fortran_grequest_cancel_fn)box->cancel_fn)(box->extra_state, &f_complete,
                                               &f_ierror);
  return f_ierror;
}
