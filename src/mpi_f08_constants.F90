module mpi_f08_constants
  use mpi, only: &
       MPI_VERSION, &
       MPI_SUBVERSION, &
       MPI_ABI_VERSION, &
       MPI_ABI_SUBVERSION, &
       MPIF_VERSION, &
       MPIF_SUBVERSION, &
       MPIF_PATCH, &
       !
       MPI_ADDRESS_KIND, &
       MPI_OFFSET_KIND, &
       MPI_COUNT_KIND, &
       MPI_INTEGER_KIND, &
       ! Fortran 77 Status Size and Indices
       MPI_STATUS_SIZE, &
       MPI_SOURCE, &
       MPI_TAG, &
       MPI_ERROR, &
       ! Error Classes
       MPI_SUCCESS, &
       MPI_ERR_BUFFER, &
       MPI_ERR_COUNT, &
       MPI_ERR_TYPE, &
       MPI_ERR_TAG, &
       MPI_ERR_COMM, &
       MPI_ERR_RANK, &
       MPI_ERR_REQUEST, &
       MPI_ERR_ROOT, &
       MPI_ERR_GROUP, &
       MPI_ERR_OP, &
       MPI_ERR_TOPOLOGY, &
       MPI_ERR_DIMS, &
       MPI_ERR_ARG, &
       MPI_ERR_UNKNOWN, &
       MPI_ERR_TRUNCATE, &
       MPI_ERR_OTHER, &
       MPI_ERR_INTERN, &
       MPI_ERR_PENDING, &
       MPI_ERR_IN_STATUS, &
       MPI_ERR_ACCESS, &
       MPI_ERR_AMODE, &
       MPI_ERR_ASSERT, &
       MPI_ERR_BAD_FILE, &
       MPI_ERR_BASE, &
       MPI_ERR_CONVERSION, &
       MPI_ERR_DISP, &
       MPI_ERR_DUP_DATAREP, &
       MPI_ERR_FILE_EXISTS, &
       MPI_ERR_FILE_IN_USE, &
       MPI_ERR_FILE, &
       MPI_ERR_INFO_KEY, &
       MPI_ERR_INFO_NOKEY, &
       MPI_ERR_INFO_VALUE, &
       MPI_ERR_INFO, &
       MPI_ERR_IO, &
       MPI_ERR_KEYVAL, &
       MPI_ERR_LOCKTYPE, &
       MPI_ERR_NAME, &
       MPI_ERR_NO_MEM, &
       MPI_ERR_NOT_SAME, &
       MPI_ERR_NO_SPACE, &
       MPI_ERR_NO_SUCH_FILE, &
       MPI_ERR_PORT, &
       MPI_ERR_QUOTA, &
       MPI_ERR_READ_ONLY, &
       MPI_ERR_RMA_ATTACH, &
       MPI_ERR_RMA_CONFLICT, &
       MPI_ERR_RMA_RANGE, &
       MPI_ERR_RMA_SHARED, &
       MPI_ERR_RMA_SYNC, &
       MPI_ERR_SERVICE, &
       MPI_ERR_SIZE, &
       MPI_ERR_SPAWN, &
       MPI_ERR_UNSUPPORTED_DATAREP, &
       MPI_ERR_UNSUPPORTED_OPERATION, &
       MPI_ERR_WIN, &
       MPI_ERR_RMA_FLAVOR, &
       MPI_ERR_PROC_ABORTED, &
       MPI_ERR_VALUE_TOO_LARGE, &
       MPI_ERR_SESSION, &
       MPI_ERR_ERRHANDLER, &
       MPI_ERR_ABI, &
       !
       MPI_T_ERR_CANNOT_INIT, &
       MPI_T_ERR_NOT_ACCESSIBLE, &
       MPI_T_ERR_NOT_INITIALIZED, &
       MPI_T_ERR_NOT_SUPPORTED, &
       MPI_T_ERR_MEMORY, &
       MPI_T_ERR_INVALID, &
       MPI_T_ERR_INVALID_INDEX, &
       MPI_T_ERR_INVALID_ITEM, &
       MPI_T_ERR_INVALID_SESSION, &
       MPI_T_ERR_INVALID_HANDLE, &
       MPI_T_ERR_INVALID_NAME, &
       MPI_T_ERR_OUT_OF_HANDLES, &
       MPI_T_ERR_OUT_OF_SESSIONS, &
       MPI_T_ERR_CVAR_SET_NOT_NOW, &
       MPI_T_ERR_PVAR_NO_WRITE, &
       MPI_T_ERR_PVAR_NO_STARTSTOP, &
       MPI_T_ERR_PVAR_NO_ATOMIC, &
       MPI_ERR_LASTCODE, &
       ! Maximum Sizes for Strings
       MPI_MAX_DATAREP_STRING, &
       MPI_MAX_ERROR_STRING, & 
       MPI_MAX_INFO_KEY, & 
       MPI_MAX_INFO_VAL, & 
       MPI_MAX_LIBRARY_VERSION_STRING, & 
       MPI_MAX_OBJECT_NAME, & 
       MPI_MAX_PORT_NAME, & 
       MPI_MAX_PROCESSOR_NAME, & 
       MPI_MAX_STRINGTAG_LEN, & 
       MPI_MAX_PSET_NAME_LEN, & 
       ! Assorted Constants
       MPI_BSEND_OVERHEAD, & 
       ! Mode Constants - must be powers-of-2 to support OR-ing
       ! File Open Modes
       MPI_MODE_APPEND, & 
       MPI_MODE_CREATE, & 
       MPI_MODE_DELETE_ON_CLOSE, & 
       MPI_MODE_EXCL, & 
       MPI_MODE_RDONLY, & 
       MPI_MODE_RDWR, & 
       MPI_MODE_SEQUENTIAL, & 
       MPI_MODE_UNIQUE_OPEN, & 
       MPI_MODE_WRONLY, & 
       ! Window Assertion Modes
       MPI_MODE_NOCHECK, & 
       MPI_MODE_NOPRECEDE, & 
       MPI_MODE_NOPUT, & 
       MPI_MODE_NOSTORE, & 
       MPI_MODE_NOSUCCEED, & 
       ! Wildcard values - must be negative
       MPI_ANY_SOURCE, & 
       MPI_ANY_TAG, & 
       ! Rank sentinels - must be negative
       MPI_PROC_NULL, & 
       MPI_ROOT, & 
       ! Multi-purpose sentinel - must be negative
       MPI_UNDEFINED, & 
       ! Thread Support - monotonic values, SINGLE < FUNNELED < SERIALIZED < MULTIPLE.
       MPI_THREAD_SINGLE, & 
       MPI_THREAD_FUNNELED, & 
       MPI_THREAD_SERIALIZED, & 
       MPI_THREAD_MULTIPLE, & 
       ! Array Datatype Order
       MPI_ORDER_C, & 
       MPI_ORDER_FORTRAN, & 
       ! Array Datatype Distribution
       MPI_DISTRIBUTE_NONE, & 
       MPI_DISTRIBUTE_BLOCK, & 
       MPI_DISTRIBUTE_CYCLIC, & 
       MPI_DISTRIBUTE_DFLT_DARG, & 
       ! Datatype Decoding Combiners
       MPI_COMBINER_NAMED, & 
       MPI_COMBINER_DUP, & 
       MPI_COMBINER_CONTIGUOUS, & 
       MPI_COMBINER_VECTOR, & 
       MPI_COMBINER_HVECTOR, & 
       MPI_COMBINER_INDEXED, & 
       MPI_COMBINER_HINDEXED, & 
       MPI_COMBINER_INDEXED_BLOCK, & 
       MPI_COMBINER_HINDEXED_BLOCK, & 
       MPI_COMBINER_STRUCT, & 
       MPI_COMBINER_SUBARRAY, & 
       MPI_COMBINER_DARRAY, & 
       MPI_COMBINER_F90_INTEGER, & 
       MPI_COMBINER_F90_REAL, & 
       MPI_COMBINER_F90_COMPLEX, & 
       MPI_COMBINER_RESIZED, & 
       MPI_COMBINER_VALUE_INDEX, & 
       ! Fortran Datatype Matching
       MPIX_TYPECLASS_LOGICAL, & 
       MPI_TYPECLASS_INTEGER, & 
       MPI_TYPECLASS_REAL, & 
       MPI_TYPECLASS_COMPLEX, & 
       ! Communicator and Group Comparisons
       MPI_IDENT, & 
       MPI_CONGRUENT, & 
       MPI_SIMILAR, & 
       MPI_UNEQUAL, & 
       ! Communicator Virtual Topology Types
       MPI_CART, & 
       MPI_GRAPH, & 
       MPI_DIST_GRAPH, & 
       ! Communicator Split Types
       MPI_COMM_TYPE_SHARED, & 
       MPI_COMM_TYPE_HW_UNGUIDED, & 
       MPI_COMM_TYPE_HW_GUIDED, & 
       MPI_COMM_TYPE_RESOURCE_GUIDED, & 
       ! Window Lock Types
       MPI_LOCK_EXCLUSIVE, & 
       MPI_LOCK_SHARED, & 
       ! Window Create Flavors
       MPI_WIN_FLAVOR_CREATE, & 
       MPI_WIN_FLAVOR_ALLOCATE, & 
       MPI_WIN_FLAVOR_DYNAMIC, & 
       MPI_WIN_FLAVOR_SHARED, & 
       ! Window Memory Models
       MPI_WIN_UNIFIED, & 
       MPI_WIN_SEPARATE, & 
       ! File Positioning
       MPI_SEEK_SET, & 
       MPI_SEEK_CUR, & 
       MPI_SEEK_END, & 
       ! File Operation Constants
       MPI_DISPLACEMENT_CURRENT, & 
       ! Predefined Attribute Keys
       ! Invalid Attribute Key
       MPI_KEYVAL_INVALID, & 
       ! Communicator
       MPI_TAG_UB, & 
       MPI_IO, & 
       MPI_HOST, & 
       MPI_WTIME_IS_GLOBAL, & 
       MPI_UNIVERSE_SIZE, & 
       MPI_APPNUM, & 
       MPI_LASTUSEDCODE, & 
       ! Window
       MPI_WIN_BASE, & 
       MPI_WIN_DISP_UNIT, & 
       MPI_WIN_SIZE, & 
       MPI_WIN_CREATE_FLAVOR, & 
       MPI_WIN_MODEL

  implicit none
  public
  save
end module mpi_f08_constants
