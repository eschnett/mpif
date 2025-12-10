      integer, parameter :: MPI_VERSION         = 5
      integer, parameter :: MPI_SUBVERSION      = 0

      integer, parameter :: MPI_ABI_VERSION     = 1
      integer, parameter :: MPI_ABI_SUBVERSION  = 0

      integer, parameter :: MPIF_VERSION        = 1
      integer, parameter :: MPIF_SUBVERSION     = 0
      integer, parameter :: MPIF_PATCH          = 0

      integer :: MPIF_DUMMY
      integer, parameter :: MPI_ADDRESS_KIND    = kind(loc(MPIF_DUMMY))
      integer, parameter :: MPI_OFFSET_KIND     = MPI_ADDRESS_KIND
      integer, parameter :: MPI_COUNT_KIND      = MPI_ADDRESS_KIND
      integer, parameter :: MPI_INTEGER_KIND    = kind(0)

      integer, parameter :: MPI_OP_NULL         = int(z'00000020')
      integer, parameter :: MPI_SUM             = int(z'00000021')
      integer, parameter :: MPI_MIN             = int(z'00000022')
      integer, parameter :: MPI_MAX             = int(z'00000023')
      integer, parameter :: MPI_PROD            = int(z'00000024')
      integer, parameter :: MPI_BAND            = int(z'00000028')
      integer, parameter :: MPI_BOR             = int(z'00000029')
      integer, parameter :: MPI_BXOR            = int(z'0000002a')
      integer, parameter :: MPI_LAND            = int(z'00000030')
      integer, parameter :: MPI_LOR             = int(z'00000031')
      integer, parameter :: MPI_LXOR            = int(z'00000032')
      integer, parameter :: MPI_MINLOC          = int(z'00000038')
      integer, parameter :: MPI_MAXLOC          = int(z'00000039')
      integer, parameter :: MPI_REPLACE         = int(z'0000003c')
      integer, parameter :: MPI_NO_OP           = int(z'0000003d')

      integer, parameter :: MPI_COMM_NULL       = int(z'00000100')
      integer, parameter :: MPI_COMM_WORLD      = int(z'00000101')
      integer, parameter :: MPI_COMM_SELF       = int(z'00000102')

      integer, parameter :: MPI_GROUP_NULL      = int(z'00000108')
      integer, parameter :: MPI_GROUP_EMPTY     = int(z'00000109')

      integer, parameter :: MPI_WIN_NULL        = int(z'00000110')

      integer, parameter :: MPI_FILE_NULL       = int(z'00000118')

      integer, parameter :: MPI_SESSION_NULL    = int(z'00000120')

      integer, parameter :: MPI_MESSAGE_NULL    = int(z'00000128')
      integer, parameter :: MPI_MESSAGE_NO_PROC = int(z'00000129')

      integer, parameter :: MPI_INFO_NULL       = int(z'00000130')
      integer, parameter :: MPI_INFO_ENV        = int(z'00000131')

      integer, parameter :: MPI_ERRHANDLER_NULL = int(z'00000140')
      integer, parameter :: MPI_ERRORS_ARE_FATAL = int(z'00000141')
      integer, parameter :: MPI_ERRORS_RETURN   = int(z'00000142')
      integer, parameter :: MPI_ERRORS_ABORT    = int(z'00000143')

      integer, parameter :: MPI_REQUEST_NULL    = int(z'00000180')

      integer, parameter :: MPI_DATATYPE_NULL   = int(z'00000200')
      integer, parameter :: MPI_AINT            = int(z'00000201')
      integer, parameter :: MPI_COUNT           = int(z'00000202')
      integer, parameter :: MPI_OFFSET          = int(z'00000203')
      integer, parameter :: MPI_PACKED          = int(z'00000207')
      integer, parameter :: MPI_SHORT           = int(z'00000208')
      integer, parameter :: MPI_INT             = int(z'00000209')
      integer, parameter :: MPI_LONG            = int(z'0000020a')
      integer, parameter :: MPI_LONG_LONG       = int(z'0000020b')
      integer, parameter :: MPI_LONG_LONG_INT   = MPI_LONG_LONG
      integer, parameter :: MPI_UNSIGNED_SHORT  = int(z'0000020c')
      integer, parameter :: MPI_UNSIGNED        = int(z'0000020d')
      integer, parameter :: MPI_UNSIGNED_LONG   = int(z'0000020e')
      integer, parameter :: MPI_UNSIGNED_LONG_LONG = int(z'0000020f')
      integer, parameter :: MPI_FLOAT           = int(z'00000210')
      integer, parameter :: MPI_C_FLOAT_COMPLEX = int(z'00000212')
      integer, parameter :: MPI_C_COMPLEX       = MPI_C_FLOAT_COMPLEX
      integer, parameter :: MPI_CXX_FLOAT_COMPLEX = int(z'00000213')
      integer, parameter :: MPI_DOUBLE          = int(z'00000214')
      integer, parameter :: MPI_C_DOUBLE_COMPLEX = int(z'00000216')
      integer, parameter :: MPI_CXX_DOUBLE_COMPLEX = int(z'00000217')
      integer, parameter :: MPI_LOGICAL         = int(z'00000218')
      integer, parameter :: MPI_INTEGER         = int(z'00000219')
      integer, parameter :: MPI_REAL            = int(z'0000021a')
      integer, parameter :: MPI_COMPLEX         = int(z'0000021b')
      integer, parameter :: MPI_DOUBLE_PRECISION = int(z'0000021c')
      integer, parameter :: MPI_DOUBLE_COMPLEX  = int(z'0000021d')
      integer, parameter :: MPI_LONG_DOUBLE     = int(z'00000220')
      integer, parameter :: MPI_C_LONG_DOUBLE_COMPLEX =                 &
     &     int(z'00000224')
      integer, parameter :: MPI_CXX_LONG_DOUBLE_COMPLEX =               &
     &     int(z'00000225')
      integer, parameter :: MPI_FLOAT_INT       = int(z'00000228')
      integer, parameter :: MPI_DOUBLE_INT      = int(z'00000229')
      integer, parameter :: MPI_LONG_INT        = int(z'0000022a')
      integer, parameter :: MPI_2INT            = int(z'0000022b')
      integer, parameter :: MPI_SHORT_INT       = int(z'0000022c')
      integer, parameter :: MPI_LONG_DOUBLE_INT = int(z'0000022d')
      integer, parameter :: MPI_2REAL           = int(z'00000230')
      integer, parameter :: MPI_2DOUBLE_PRECISION = int(z'00000231')
      integer, parameter :: MPI_2INTEGER        = int(z'00000232')
      integer, parameter :: MPI_C_BOOL          = int(z'00000238')
      integer, parameter :: MPI_CXX_BOOL        = int(z'00000239')
      integer, parameter :: MPI_WCHAR           = int(z'0000023c')
      integer, parameter :: MPI_INT8_T          = int(z'00000240')
      integer, parameter :: MPI_UINT8_T         = int(z'00000241')
      integer, parameter :: MPI_CHAR            = int(z'00000243')
      integer, parameter :: MPI_SIGNED_CHAR     = int(z'00000244')
      integer, parameter :: MPI_UNSIGNED_CHAR   = int(z'00000245')
      integer, parameter :: MPI_BYTE            = int(z'00000247')
      integer, parameter :: MPI_INT16_T         = int(z'00000248')
      integer, parameter :: MPI_UINT16_T        = int(z'00000249')
      integer, parameter :: MPI_INT32_T         = int(z'00000250')
      integer, parameter :: MPI_UINT32_T        = int(z'00000251')
      integer, parameter :: MPI_INT64_T         = int(z'00000258')
      integer, parameter :: MPI_UINT64_T        = int(z'00000259')
      integer, parameter :: MPI_LOGICAL1        = int(z'000002c0')
      integer, parameter :: MPI_INTEGER1        = int(z'000002c1')
      integer, parameter :: MPI_CHARACTER       = int(z'000002c3')
      integer, parameter :: MPI_LOGICAL2        = int(z'000002c8')
      integer, parameter :: MPI_INTEGER2        = int(z'000002c9')
      integer, parameter :: MPI_REAL2           = int(z'000002ca')
      integer, parameter :: MPI_LOGICAL4        = int(z'000002d0')
      integer, parameter :: MPI_INTEGER4        = int(z'000002d1')
      integer, parameter :: MPI_REAL4           = int(z'000002d2')
      integer, parameter :: MPI_COMPLEX4        = int(z'000002d3')
      integer, parameter :: MPI_LOGICAL8        = int(z'000002d8')
      integer, parameter :: MPI_INTEGER8        = int(z'000002d9')
      integer, parameter :: MPI_REAL8           = int(z'000002da')
      integer, parameter :: MPI_COMPLEX8        = int(z'000002db')
      integer, parameter :: MPI_LOGICAL16       = int(z'000002e0')
      integer, parameter :: MPI_INTEGER16       = int(z'000002e1')
      integer, parameter :: MPI_REAL16          = int(z'000002e2')
      integer, parameter :: MPI_COMPLEX16       = int(z'000002e3')
      integer, parameter :: MPI_COMPLEX32       = int(z'000002eb')

!     Fortran 77 Status Size and Indices
      integer, parameter :: MPI_STATUS_SIZE     = 8
      integer, parameter :: MPI_SOURCE          = 1
      integer, parameter :: MPI_TAG             = 2
      integer, parameter :: MPI_ERROR           = 3

!     Error Classes
      integer, parameter :: MPI_SUCCESS                 =  0

      integer, parameter :: MPI_ERR_BUFFER              =  1 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_COUNT               =  2 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_TYPE                =  3 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_TAG                 =  4 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_COMM                =  5 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_RANK                =  6 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_REQUEST             =  7 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_ROOT                =  8 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_GROUP               =  9 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_OP                  = 10 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_TOPOLOGY            = 11 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_DIMS                = 12 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_ARG                 = 13 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_UNKNOWN             = 14 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_TRUNCATE            = 15 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_OTHER               = 16 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_INTERN              = 17 ! added: MPI-1.0
      integer, parameter :: MPI_ERR_PENDING             = 18 ! added: MPI-1.1
      integer, parameter :: MPI_ERR_IN_STATUS           = 19 ! added: MPI-1.1
      integer, parameter :: MPI_ERR_ACCESS              = 20 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_AMODE               = 21 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_ASSERT              = 22 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_BAD_FILE            = 23 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_BASE                = 24 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_CONVERSION          = 25 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_DISP                = 26 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_DUP_DATAREP         = 27 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_FILE_EXISTS         = 28 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_FILE_IN_USE         = 29 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_FILE                = 30 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_INFO_KEY            = 31 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_INFO_NOKEY          = 32 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_INFO_VALUE          = 33 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_INFO                = 34 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_IO                  = 35 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_KEYVAL              = 36 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_LOCKTYPE            = 37 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_NAME                = 38 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_NO_MEM              = 39 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_NOT_SAME            = 40 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_NO_SPACE            = 41 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_NO_SUCH_FILE        = 42 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_PORT                = 43 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_QUOTA               = 44 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_READ_ONLY           = 45 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_RMA_ATTACH          = 46 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_RMA_CONFLICT        = 47 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_RMA_RANGE           = 48 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_RMA_SHARED          = 49 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_RMA_SYNC            = 50 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_SERVICE             = 51 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_SIZE                = 52 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_SPAWN               = 53 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_UNSUPPORTED_DATAREP = 54 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_UNSUPPORTED_OPERATION = 55 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_WIN                 = 56 ! added: MPI-2.0
      integer, parameter :: MPI_ERR_RMA_FLAVOR          = 57 ! added: MPI-3.0
      integer, parameter :: MPI_ERR_PROC_ABORTED        = 58 ! added: MPI-4.0
      integer, parameter :: MPI_ERR_VALUE_TOO_LARGE     = 59 ! added: MPI-4.0
      integer, parameter :: MPI_ERR_SESSION             = 60 ! added: MPI-4.0
      integer, parameter :: MPI_ERR_ERRHANDLER          = 61 ! added: MPI-4.1
      integer, parameter :: MPI_ERR_ABI                 = 62 ! added: MPI-5.0

      integer, parameter :: MPI_T_ERR_CANNOT_INIT       = 1001
      integer, parameter :: MPI_T_ERR_NOT_ACCESSIBLE    = 1002
      integer, parameter :: MPI_T_ERR_NOT_INITIALIZED   = 1003
      integer, parameter :: MPI_T_ERR_NOT_SUPPORTED     = 1004
      integer, parameter :: MPI_T_ERR_MEMORY            = 1005
      integer, parameter :: MPI_T_ERR_INVALID           = 1006
      integer, parameter :: MPI_T_ERR_INVALID_INDEX     = 1007
      integer, parameter :: MPI_T_ERR_INVALID_ITEM      = 1008 ! deprecated: MPI-4.0
      integer, parameter :: MPI_T_ERR_INVALID_SESSION   = 1009
      integer, parameter :: MPI_T_ERR_INVALID_HANDLE    = 1010
      integer, parameter :: MPI_T_ERR_INVALID_NAME      = 1011
      integer, parameter :: MPI_T_ERR_OUT_OF_HANDLES    = 1012
      integer, parameter :: MPI_T_ERR_OUT_OF_SESSIONS   = 1013
      integer, parameter :: MPI_T_ERR_CVAR_SET_NOT_NOW  = 1014
      integer, parameter :: MPI_T_ERR_CVAR_SET_NEVER    = 1015
      integer, parameter :: MPI_T_ERR_PVAR_NO_WRITE     = 1016
      integer, parameter :: MPI_T_ERR_PVAR_NO_STARTSTOP = 1017
      integer, parameter :: MPI_T_ERR_PVAR_NO_ATOMIC    = 1018

      integer, parameter :: MPI_ERR_LASTCODE            = int(z'3fff') ! half of the minimum required value of INT_MAX

!     Buffer Address Constants
!     We use Cray pointers to handle sentinel values. Unfortunately
!     these might not be supported everywhere, and if they are, they
!     require special compiler options.

      integer MPI_BOTTOM(1)
      integer(MPI_ADDRESS_KIND) MPI_BOTTOM_PTR
      pointer (MPI_BOTTOM_PTR, MPI_BOTTOM)
      common /MPI_BOTTOM_PTR/ MPI_BOTTOM_PTR

      integer MPI_IN_PLACE(1)
      integer(MPI_ADDRESS_KIND) MPI_IN_PLACE_PTR
      pointer (MPI_IN_PLACE_PTR, MPI_IN_PLACE)
      common /MPI_IN_PLACE_PTR/ MPI_IN_PLACE_PTR

      integer MPI_BUFFER_AUTOMATIC(1)
      integer(MPI_ADDRESS_KIND) MPI_BUFFER_AUTOMATIC_PTR
      pointer (MPI_BUFFER_AUTOMATIC_PTR, MPI_BUFFER_AUTOMATIC)
      common /MPI_BUFFER_AUTOMATIC_PTR/ MPI_BUFFER_AUTOMATIC_PTR

!     Empty/Ignored Constants

      integer MPI_ARGVS_NULL(1)
      integer(MPI_ADDRESS_KIND) MPI_ARGVS_NULL_PTR
      pointer (MPI_ARGVS_NULL_PTR, MPI_ARGVS_NULL)
      common /MPI_ARGVS_NULL_PTR/ MPI_ARGVS_NULL_PTR

      integer MPI_ARGV_NULL(1)
      integer(MPI_ADDRESS_KIND) MPI_ARGV_NULL_PTR
      pointer (MPI_ARGV_NULL_PTR, MPI_ARGV_NULL)
      common /MPI_ARGV_NULL_PTR/ MPI_ARGV_NULL_PTR

      integer MPI_ERRCODES_IGNORE(1)
      integer(MPI_ADDRESS_KIND) MPI_ERRCODES_IGNORE_PTR
      pointer (MPI_ERRCODES_IGNORE_PTR, MPI_ERRCODES_IGNORE)
      common /MPI_ERRCODES_IGNORE_PTR/ MPI_ERRCODES_IGNORE_PTR

      integer MPI_STATUS_IGNORE(MPI_STATUS_SIZE)
      integer(MPI_ADDRESS_KIND) MPI_STATUS_IGNORE_PTR
      pointer (MPI_STATUS_IGNORE_PTR, MPI_STATUS_IGNORE)
      common /MPI_STATUS_IGNORE_PTR/ MPI_STATUS_IGNORE_PTR

      integer MPI_STATUSES_IGNORE(MPI_STATUS_SIZE)
      integer(MPI_ADDRESS_KIND) MPI_STATUSES_IGNORE_PTR
      pointer (MPI_STATUSES_IGNORE_PTR, MPI_STATUSES_IGNORE)
      common /MPI_STATUSES_IGNORE_PTR/ MPI_STATUSES_IGNORE_PTR

      integer MPI_UNWEIGHTED(1)
      integer(MPI_ADDRESS_KIND) MPI_UNWEIGHTED_PTR
      pointer (MPI_UNWEIGHTED_PTR, MPI_UNWEIGHTED)
      common /MPI_UNWEIGHTED_PTR/ MPI_UNWEIGHTED_PTR

      integer MPI_WEIGHTS_EMPTY(1)
      integer(MPI_ADDRESS_KIND) MPI_WEIGHTS_EMPTY_PTR
      pointer (MPI_WEIGHTS_EMPTY_PTR, MPI_WEIGHTS_EMPTY)
      common /MPI_WEIGHTS_EMPTY_PTR/ MPI_WEIGHTS_EMPTY_PTR

!     Maximum Sizes for Strings
!     (Their lengths in Fortran are one less than their lengths in C)
      integer, parameter :: MPI_MAX_DATAREP_STRING      =  128 - 1 ! MPICH:  128 - OMPI:  128
      integer, parameter :: MPI_MAX_ERROR_STRING        =  512 - 1 ! MPICH:  512 - OMPI:  256
      integer, parameter :: MPI_MAX_INFO_KEY            =  256 - 1 ! MPICH:  255 - OMPI:   36
      integer, parameter :: MPI_MAX_INFO_VAL            = 1024 - 1 ! MPICH: 1024 - OMPI:  256
      integer, parameter :: MPI_MAX_LIBRARY_VERSION_STRING = 8192 - 1 ! MPICH: 8192 - OMPI:  256
      integer, parameter :: MPI_MAX_OBJECT_NAME         =  128 - 1 ! MPICH:  128 - OMPI:   64
      integer, parameter :: MPI_MAX_PORT_NAME           = 1024 - 1 ! MPICH:  256 - OMPI: 1024
      integer, parameter :: MPI_MAX_PROCESSOR_NAME      =  256 - 1 ! MPICH:  128 - OMPI:  256
      integer, parameter :: MPI_MAX_STRINGTAG_LEN       = 1024 - 1 ! MPICH:  256 - OMPI: 1024
      integer, parameter :: MPI_MAX_PSET_NAME_LEN       = 1024 - 1 ! MPICH:  256 - OMPI:  512
!     Assorted Constants
      integer, parameter :: MPI_BSEND_OVERHEAD          =  512 ! MPICH:   96 - OMPI:  128

!     Mode Constants - must be powers-of-2 to support OR-ing

!     File Open Modes
      integer, parameter :: MPI_MODE_APPEND             = 1
      integer, parameter :: MPI_MODE_CREATE             = 2
      integer, parameter :: MPI_MODE_DELETE_ON_CLOSE    = 4
      integer, parameter :: MPI_MODE_EXCL               = 8
      integer, parameter :: MPI_MODE_RDONLY             = 16
      integer, parameter :: MPI_MODE_RDWR               = 32
      integer, parameter :: MPI_MODE_SEQUENTIAL         = 64
      integer, parameter :: MPI_MODE_UNIQUE_OPEN        = 128
      integer, parameter :: MPI_MODE_WRONLY             = 256

!     Window Assertion Modes
      integer, parameter :: MPI_MODE_NOCHECK            = 1024
      integer, parameter :: MPI_MODE_NOPRECEDE          = 2048
      integer, parameter :: MPI_MODE_NOPUT              = 4096
      integer, parameter :: MPI_MODE_NOSTORE            = 8192
      integer, parameter :: MPI_MODE_NOSUCCEED          = 16384

!     Wildcard values - must be negative
      integer, parameter :: MPI_ANY_SOURCE              = -1
      integer, parameter :: MPI_ANY_TAG                 = -2

!     Rank sentinels - must be negative
      integer, parameter :: MPI_PROC_NULL               = -3
      integer, parameter :: MPI_ROOT                    = -4


!     Multi-purpose sentinel - must be negative
      integer, parameter :: MPI_UNDEFINED               = -32766

!     Thread Support - monotonic values, SINGLE < FUNNELED < SERIALIZED < MULTIPLE.
      integer, parameter :: MPI_THREAD_SINGLE           = 0
      integer, parameter :: MPI_THREAD_FUNNELED         = 1024
      integer, parameter :: MPI_THREAD_SERIALIZED       = 2048
      integer, parameter :: MPI_THREAD_MULTIPLE         = 4096

!     Array Datatype Order
      integer, parameter :: MPI_ORDER_C                 = int(z'C') ! 12
      integer, parameter :: MPI_ORDER_FORTRAN           = int(z'F') ! 15

!     Array Datatype Distribution
      integer, parameter :: MPI_DISTRIBUTE_NONE         = 16
      integer, parameter :: MPI_DISTRIBUTE_BLOCK        = 17
      integer, parameter :: MPI_DISTRIBUTE_CYCLIC       = 18
      integer, parameter :: MPI_DISTRIBUTE_DFLT_DARG    = 19

!     Datatype Decoding Combiners
      integer, parameter :: MPI_COMBINER_NAMED          = 101
      integer, parameter :: MPI_COMBINER_DUP            = 102
      integer, parameter :: MPI_COMBINER_CONTIGUOUS     = 103
      integer, parameter :: MPI_COMBINER_VECTOR         = 104
      integer, parameter :: MPI_COMBINER_HVECTOR        = 105
      integer, parameter :: MPI_COMBINER_INDEXED        = 106
      integer, parameter :: MPI_COMBINER_HINDEXED       = 107
      integer, parameter :: MPI_COMBINER_INDEXED_BLOCK  = 108
      integer, parameter :: MPI_COMBINER_HINDEXED_BLOCK = 109
      integer, parameter :: MPI_COMBINER_STRUCT         = 110
      integer, parameter :: MPI_COMBINER_SUBARRAY       = 111
      integer, parameter :: MPI_COMBINER_DARRAY         = 112
      integer, parameter :: MPI_COMBINER_F90_INTEGER    = 113
      integer, parameter :: MPI_COMBINER_F90_REAL       = 114
      integer, parameter :: MPI_COMBINER_F90_COMPLEX    = 115
      integer, parameter :: MPI_COMBINER_RESIZED        = 116
      integer, parameter :: MPI_COMBINER_VALUE_INDEX    = 117

!     Fortran Datatype Matching
      integer, parameter :: MPIX_TYPECLASS_LOGICAL      = 191
      integer, parameter :: MPI_TYPECLASS_INTEGER       = 192
      integer, parameter :: MPI_TYPECLASS_REAL          = 193
      integer, parameter :: MPI_TYPECLASS_COMPLEX       = 194

!     Communicator and Group Comparisons
      integer, parameter :: MPI_IDENT                   = 201
      integer, parameter :: MPI_CONGRUENT               = 202
      integer, parameter :: MPI_SIMILAR                 = 203
      integer, parameter :: MPI_UNEQUAL                 = 204

!     Communicator Virtual Topology Types
      integer, parameter :: MPI_CART                    = 211
      integer, parameter :: MPI_GRAPH                   = 212
      integer, parameter :: MPI_DIST_GRAPH              = 213

!     Communicator Split Types
      integer, parameter :: MPI_COMM_TYPE_SHARED        = 221
      integer, parameter :: MPI_COMM_TYPE_HW_UNGUIDED   = 222
      integer, parameter :: MPI_COMM_TYPE_HW_GUIDED     = 223
      integer, parameter :: MPI_COMM_TYPE_RESOURCE_GUIDED = 224

!     Window Lock Types
      integer, parameter ::  MPI_LOCK_EXCLUSIVE         = 301
      integer, parameter ::  MPI_LOCK_SHARED            = 302

!     Window Create Flavors
      integer, parameter :: MPI_WIN_FLAVOR_CREATE       = 311
      integer, parameter :: MPI_WIN_FLAVOR_ALLOCATE     = 312
      integer, parameter :: MPI_WIN_FLAVOR_DYNAMIC      = 313
      integer, parameter :: MPI_WIN_FLAVOR_SHARED       = 314

!     Window Memory Models
      integer, parameter :: MPI_WIN_UNIFIED             = 321
      integer, parameter :: MPI_WIN_SEPARATE            = 322

!     File Positioning
      integer, parameter :: MPI_SEEK_SET               = 401
      integer, parameter :: MPI_SEEK_CUR               = 402
      integer, parameter :: MPI_SEEK_END               = 403

!     File Operation Constants
      integer(MPI_OFFSET_KIND), parameter :: MPI_DISPLACEMENT_CURRENT = &
     &     -1

!     Predefined Attribute Keys

!     Invalid Attribute Key
      integer, parameter :: MPI_KEYVAL_INVALID          = 0

!     Communicator
      integer, parameter :: MPI_TAG_UB                  = 501
      integer, parameter :: MPI_IO                      = 502
      integer, parameter :: MPI_HOST                    = 503 ! deprecated: MPI-4.1
      integer, parameter :: MPI_WTIME_IS_GLOBAL         = 504
      integer, parameter :: MPI_UNIVERSE_SIZE           = 505
      integer, parameter :: MPI_APPNUM                  = 506
      integer, parameter :: MPI_LASTUSEDCODE            = 507

!     Window
      integer, parameter :: MPI_WIN_BASE                = 601
      integer, parameter :: MPI_WIN_DISP_UNIT           = 602
      integer, parameter :: MPI_WIN_SIZE                = 603
      integer, parameter :: MPI_WIN_CREATE_FLAVOR       = 604
      integer, parameter :: MPI_WIN_MODEL               = 605
