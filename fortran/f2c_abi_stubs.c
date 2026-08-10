// For the MPI ABI stubs

// The MPI Forum's stub implementation (github.com/mpi-forum/mpi-abi-stubs) is
// the whole standard ABI as entry points that abort();
// ci-scripts/install-mpi-stubs.sh builds a libmpi_abi out of it so that the
// compile-only CI stage can configure and build mpif without an MPI. Its
// header says nothing about Fortran -- fortran/mpi.h.patch is what adds the
// handle conversions to it -- so its library defines none of them either, and
// this file is that implementation's half of the toolbox, the same role
// f2c_abi_mpich.c and f2c_abi_openmpi.c play for the two real ones.
//
// Every body aborts, like everything else in that library. Nothing here is
// ever called: mpif's own library and mpif_info name none of these symbols,
// and the only reason they must exist is that test/c2f.c and
// test/interlanguage.c link against them. Correct definitions would need the
// handle tables the stub implementation does not have.
//
// `#pragma weak` on each MPI_* forwarder, with the PMPI_* twin carrying the
// definition, is mpilib.c's own idiom rather than the Darwin-only export
// question f2c_abi_mpich.c argues: this becomes part of that library, so it is
// built the way the rest of it is. Each PMPI_* comes first because the header
// compiled against declares neither.

#include <stdlib.h>

#include "mpi.h"

// The header this is compiled against is the stub repository's own, before
// fortran/mpi.h.patch goes on -- the patch cannot be applied first, for the
// reason ci-scripts/install-mpi-stubs.sh gives -- so the two Fortran types it
// would have introduced are declared here. Identical to what the patch adds,
// and a repeated typedef is legal C should this ever meet a patched header.
typedef int MPI_Fint;

typedef MPI_Status MPI_F08_Status;

int PMPI_Status_f2c(const MPI_Fint *f_status, MPI_Status *c_status) { abort(); return 0; }
#pragma weak MPI_Status_f2c
int MPI_Status_f2c(const MPI_Fint *f_status, MPI_Status *c_status) { return PMPI_Status_f2c(f_status, c_status); }

int PMPI_Status_c2f(const MPI_Status *c_status, MPI_Fint *f_status) { abort(); return 0; }
#pragma weak MPI_Status_c2f
int MPI_Status_c2f(const MPI_Status *c_status, MPI_Fint *f_status) { return PMPI_Status_c2f(c_status, f_status); }

int PMPI_Status_f082c(const MPI_F08_Status *f08_status, MPI_Status *c_status) { abort(); return 0; }
#pragma weak MPI_Status_f082c
int MPI_Status_f082c(const MPI_F08_Status *f08_status, MPI_Status *c_status) { return PMPI_Status_f082c(f08_status, c_status); }

int PMPI_Status_c2f08(const MPI_Status *c_status, MPI_F08_Status *f08_status) { abort(); return 0; }
#pragma weak MPI_Status_c2f08
int MPI_Status_c2f08(const MPI_Status *c_status, MPI_F08_Status *f08_status) { return PMPI_Status_c2f08(c_status, f08_status); }

MPI_Comm PMPI_Comm_f2c(MPI_Fint comm) { abort(); return MPI_COMM_NULL; }
#pragma weak MPI_Comm_f2c
MPI_Comm MPI_Comm_f2c(MPI_Fint comm) { return PMPI_Comm_f2c(comm); }

MPI_Fint PMPI_Comm_c2f(MPI_Comm comm) { abort(); return 0; }
#pragma weak MPI_Comm_c2f
MPI_Fint MPI_Comm_c2f(MPI_Comm comm) { return PMPI_Comm_c2f(comm); }

MPI_Errhandler PMPI_Errhandler_f2c(MPI_Fint errhandler) { abort(); return MPI_ERRHANDLER_NULL; }
#pragma weak MPI_Errhandler_f2c
MPI_Errhandler MPI_Errhandler_f2c(MPI_Fint errhandler) { return PMPI_Errhandler_f2c(errhandler); }

MPI_Fint PMPI_Errhandler_c2f(MPI_Errhandler errhandler) { abort(); return 0; }
#pragma weak MPI_Errhandler_c2f
MPI_Fint MPI_Errhandler_c2f(MPI_Errhandler errhandler) { return PMPI_Errhandler_c2f(errhandler); }

MPI_File PMPI_File_f2c(MPI_Fint file) { abort(); return MPI_FILE_NULL; }
#pragma weak MPI_File_f2c
MPI_File MPI_File_f2c(MPI_Fint file) { return PMPI_File_f2c(file); }

MPI_Fint PMPI_File_c2f(MPI_File file) { abort(); return 0; }
#pragma weak MPI_File_c2f
MPI_Fint MPI_File_c2f(MPI_File file) { return PMPI_File_c2f(file); }

MPI_Group PMPI_Group_f2c(MPI_Fint group) { abort(); return MPI_GROUP_NULL; }
#pragma weak MPI_Group_f2c
MPI_Group MPI_Group_f2c(MPI_Fint group) { return PMPI_Group_f2c(group); }

MPI_Fint PMPI_Group_c2f(MPI_Group group) { abort(); return 0; }
#pragma weak MPI_Group_c2f
MPI_Fint MPI_Group_c2f(MPI_Group group) { return PMPI_Group_c2f(group); }

MPI_Info PMPI_Info_f2c(MPI_Fint info) { abort(); return MPI_INFO_NULL; }
#pragma weak MPI_Info_f2c
MPI_Info MPI_Info_f2c(MPI_Fint info) { return PMPI_Info_f2c(info); }

MPI_Fint PMPI_Info_c2f(MPI_Info info) { abort(); return 0; }
#pragma weak MPI_Info_c2f
MPI_Fint MPI_Info_c2f(MPI_Info info) { return PMPI_Info_c2f(info); }

MPI_Message PMPI_Message_f2c(MPI_Fint message) { abort(); return MPI_MESSAGE_NULL; }
#pragma weak MPI_Message_f2c
MPI_Message MPI_Message_f2c(MPI_Fint message) { return PMPI_Message_f2c(message); }

MPI_Fint PMPI_Message_c2f(MPI_Message message) { abort(); return 0; }
#pragma weak MPI_Message_c2f
MPI_Fint MPI_Message_c2f(MPI_Message message) { return PMPI_Message_c2f(message); }

MPI_Op PMPI_Op_f2c(MPI_Fint op) { abort(); return MPI_OP_NULL; }
#pragma weak MPI_Op_f2c
MPI_Op MPI_Op_f2c(MPI_Fint op) { return PMPI_Op_f2c(op); }

MPI_Fint PMPI_Op_c2f(MPI_Op op) { abort(); return 0; }
#pragma weak MPI_Op_c2f
MPI_Fint MPI_Op_c2f(MPI_Op op) { return PMPI_Op_c2f(op); }

MPI_Request PMPI_Request_f2c(MPI_Fint request) { abort(); return MPI_REQUEST_NULL; }
#pragma weak MPI_Request_f2c
MPI_Request MPI_Request_f2c(MPI_Fint request) { return PMPI_Request_f2c(request); }

MPI_Fint PMPI_Request_c2f(MPI_Request request) { abort(); return 0; }
#pragma weak MPI_Request_c2f
MPI_Fint MPI_Request_c2f(MPI_Request request) { return PMPI_Request_c2f(request); }

MPI_Session PMPI_Session_f2c(MPI_Fint session) { abort(); return MPI_SESSION_NULL; }
#pragma weak MPI_Session_f2c
MPI_Session MPI_Session_f2c(MPI_Fint session) { return PMPI_Session_f2c(session); }

MPI_Fint PMPI_Session_c2f(MPI_Session session) { abort(); return 0; }
#pragma weak MPI_Session_c2f
MPI_Fint MPI_Session_c2f(MPI_Session session) { return PMPI_Session_c2f(session); }

MPI_Datatype PMPI_Type_f2c(MPI_Fint datatype) { abort(); return MPI_DATATYPE_NULL; }
#pragma weak MPI_Type_f2c
MPI_Datatype MPI_Type_f2c(MPI_Fint datatype) { return PMPI_Type_f2c(datatype); }

MPI_Fint PMPI_Type_c2f(MPI_Datatype datatype) { abort(); return 0; }
#pragma weak MPI_Type_c2f
MPI_Fint MPI_Type_c2f(MPI_Datatype datatype) { return PMPI_Type_c2f(datatype); }

MPI_Win PMPI_Win_f2c(MPI_Fint win) { abort(); return MPI_WIN_NULL; }
#pragma weak MPI_Win_f2c
MPI_Win MPI_Win_f2c(MPI_Fint win) { return PMPI_Win_f2c(win); }

MPI_Fint PMPI_Win_c2f(MPI_Win win) { abort(); return 0; }
#pragma weak MPI_Win_c2f
MPI_Fint MPI_Win_c2f(MPI_Win win) { return PMPI_Win_c2f(win); }

