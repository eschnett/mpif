#ifndef MPIF_ATTRS_H
#define MPIF_ATTRS_H

#include <mpi.h>

// Convert an attribute value from what the C binding returns to what the
// Fortran binding has to return.
//
// For the predefined attributes the two bindings differ: C hands back the
// address of the value -- "the C versions of the attributes return the address
// of a *COPY* of the value", as MPICH's attr_impl.c puts it -- while Fortran
// returns the value itself. MPI_WIN_BASE is the exception among the exceptions,
// being the address itself rather than a pointer to it.
//
// User-defined attributes are stored and returned verbatim and need no
// conversion.

#ifdef __cplusplus
extern "C" {
#endif

// The Fortran value of the attribute `value` that MPI returned for `keyval`
MPI_Aint mpif_attr_value(int keyval, void *value);

#ifdef __cplusplus
}
#endif

#endif // #ifndef MPIF_ATTRS_H
