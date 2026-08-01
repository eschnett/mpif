#include <mpif_attrs.h>

#include <mpi.h>

// The MPI ABI numbers the predefined keyvals distinctly across object types --
// communicator attributes are 501 to 507, window attributes 601 to 605 -- so one
// switch covers all of MPI_Comm_get_attr, MPI_Win_get_attr, MPI_Type_get_attr
// and the deprecated MPI_Attr_get, without needing to know which was called.
//
// There are no predefined datatype attributes.

MPI_Aint mpif_attr_value(int keyval, void *value) {
  if (!value)
    return 0;

  switch (keyval) {

  // C returns a pointer to an int, Fortran returns the value
  case MPI_TAG_UB:
  case MPI_IO:
  case MPI_HOST:
  case MPI_WTIME_IS_GLOBAL:
  case MPI_APPNUM:
  case MPI_LASTUSEDCODE:
  case MPI_UNIVERSE_SIZE:
  case MPI_WIN_DISP_UNIT:
  case MPI_WIN_CREATE_FLAVOR:
  case MPI_WIN_MODEL:
    return *(const int *)value;

  // C returns a pointer to an address-sized value
  case MPI_WIN_SIZE:
    return *(const MPI_Aint *)value;

  // C returns the base address itself, not a pointer to it
  case MPI_WIN_BASE:
    return (MPI_Aint)value;

  // User-defined attributes are whatever was stored
  default:
    return (MPI_Aint)value;
  }
}
