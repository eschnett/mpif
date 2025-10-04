      integer MPI_VERSION
      parameter (MPI_VERSION = 5)
      integer MPI_SUBVERSION
      parameter (MPI_SUBVERSION = 0)

      integer MPI_ABI_VERSION
      parameter (MPI_ABI_VERSION = 1)
      integer MPI_ABI_SUBVERSION
      parameter (MPI_ABI_SUBVERSION = 0)

      integer MPIF_VERSION
      parameter (MPIF_VERSION = 1)
      integer MPIF_SUBVERSION
      parameter (MPIF_SUBVERSION = 0)
      integer MPIF_PATCH
      parameter (MPIF_PATCH = 0)

      integer MPI_ADDRESS_KIND
      parameter (MPI_ADDRESS_KIND = kind(loc(MPI_ADDRESS_KIND)))

      integer MPI_OFFSET_KIND
      parameter (MPI_OFFSET_KIND = MPI_ADDRESS_KIND)

      integer MPI_COUNT_KIND
      parameter (MPI_COUNT_KIND = MPI_ADDRESS_KIND)

      integer MPI_INTEGER_KIND
      parameter (MPI_INTEGER_KIND = kind(0))

      integer MPI_OP_NULL
      parameter (MPI_OP_NULL                    = int(z'00000020'))
      integer MPI_SUM
      parameter (MPI_SUM                        = int(z'00000021'))
      integer MPI_MIN
      parameter (MPI_MIN                        = int(z'00000022'))
      integer MPI_MAX
      parameter (MPI_MAX                        = int(z'00000023'))
      integer MPI_PROD
      parameter (MPI_PROD                       = int(z'00000024'))
      integer MPI_BAND
      parameter (MPI_BAND                       = int(z'00000028'))
      integer MPI_BOR
      parameter (MPI_BOR                        = int(z'00000029'))
      integer MPI_BXOR
      parameter (MPI_BXOR                       = int(z'0000002a'))
      integer MPI_LAND
      parameter (MPI_LAND                       = int(z'00000030'))
      integer MPI_LOR
      parameter (MPI_LOR                        = int(z'00000031'))
      integer MPI_LXOR
      parameter (MPI_LXOR                       = int(z'00000032'))
      integer MPI_MINLOC
      parameter (MPI_MINLOC                     = int(z'00000038'))
      integer MPI_MAXLOC
      parameter (MPI_MAXLOC                     = int(z'00000039'))
      integer MPI_REPLACE
      parameter (MPI_REPLACE                    = int(z'0000003c'))
      integer MPI_NO_OP
      parameter (MPI_NO_OP                      = int(z'0000003d'))

      integer MPI_COMM_NULL
      parameter (MPI_COMM_NULL                  = int(z'00000100'))
      integer MPI_COMM_WORLD
      parameter (MPI_COMM_WORLD                 = int(z'00000101'))
      integer MPI_COMM_SELF
      parameter (MPI_COMM_SELF                  = int(z'00000102'))

      integer MPI_GROUP_NULL
      parameter (MPI_GROUP_NULL                 = int(z'00000108'))
      integer MPI_GROUP_EMPTY
      parameter (MPI_GROUP_EMPTY                = int(z'00000109'))

      integer MPI_WIN_NULL
      parameter (MPI_WIN_NULL                   = int(z'00000110'))

      integer MPI_FILE_NULL
      parameter (MPI_FILE_NULL                  = int(z'00000118'))

      integer MPI_SESSION_NULL
      parameter (MPI_SESSION_NULL               = int(z'00000120'))

      integer MPI_MESSAGE_NULL
      parameter (MPI_MESSAGE_NULL               = int(z'00000128'))
      integer MPI_MESSAGE_NO_PROC
      parameter (MPI_MESSAGE_NO_PROC            = int(z'00000129'))

      integer MPI_INFO_NULL
      parameter (MPI_INFO_NULL                  = int(z'00000130'))
      integer MPI_INFO_ENV
      parameter (MPI_INFO_ENV                   = int(z'00000131'))

      integer MPI_ERRHANDLER_NULL
      parameter (MPI_ERRHANDLER_NULL            = int(z'00000140'))
      integer MPI_ERRORS_ARE_FATAL
      parameter (MPI_ERRORS_ARE_FATAL           = int(z'00000141'))
      integer MPI_ERRORS_RETURN
      parameter (MPI_ERRORS_RETURN              = int(z'00000142'))
      integer MPI_ERRORS_ABORT
      parameter (MPI_ERRORS_ABORT               = int(z'00000143'))

      integer MPI_REQUEST_NULL
      parameter (MPI_REQUEST_NULL               = int(z'00000180'))

      integer MPI_DATATYPE_NULL
      parameter (MPI_DATATYPE_NULL              = int(z'00000200'))
      integer MPI_AINT
      parameter (MPI_AINT                       = int(z'00000201'))
      integer MPI_COUNT
      parameter (MPI_COUNT                      = int(z'00000202'))
      integer MPI_OFFSET
      parameter (MPI_OFFSET                     = int(z'00000203'))
      integer MPI_PACKED
      parameter (MPI_PACKED                     = int(z'00000207'))
      integer MPI_SHORT
      parameter (MPI_SHORT                      = int(z'00000208'))
      integer MPI_INT
      parameter (MPI_INT                        = int(z'00000209'))
      integer MPI_LONG
      parameter (MPI_LONG                       = int(z'0000020a'))
      integer MPI_LONG_LONG
      parameter (MPI_LONG_LONG                  = int(z'0000020b'))
      integer MPI_LONG_LONG_INT
      parameter (MPI_LONG_LONG_INT              = MPI_LONG_LONG)
      integer MPI_UNSIGNED_SHORT
      parameter (MPI_UNSIGNED_SHORT             = int(z'0000020c'))
      integer MPI_UNSIGNED
      parameter (MPI_UNSIGNED                   = int(z'0000020d'))
      integer MPI_UNSIGNED_LONG
      parameter (MPI_UNSIGNED_LONG              = int(z'0000020e'))
      integer MPI_UNSIGNED_LONG_LONG
      parameter (MPI_UNSIGNED_LONG_LONG         = int(z'0000020f'))
      integer MPI_FLOAT
      parameter (MPI_FLOAT                      = int(z'00000210'))
      integer MPI_C_FLOAT_COMPLEX
      parameter (MPI_C_FLOAT_COMPLEX            = int(z'00000212'))
      integer MPI_C_COMPLEX
      parameter (MPI_C_COMPLEX                  = MPI_C_FLOAT_COMPLEX)
      integer MPI_CXX_FLOAT_COMPLEX
      parameter (MPI_CXX_FLOAT_COMPLEX          = int(z'00000213'))
      integer MPI_DOUBLE
      parameter (MPI_DOUBLE                     = int(z'00000214'))
      integer MPI_C_DOUBLE_COMPLEX
      parameter (MPI_C_DOUBLE_COMPLEX           = int(z'00000216'))
      integer MPI_CXX_DOUBLE_COMPLEX
      parameter (MPI_CXX_DOUBLE_COMPLEX         = int(z'00000217'))
      integer MPI_LOGICAL
      parameter (MPI_LOGICAL                    = int(z'00000218'))
      integer MPI_INTEGER
      parameter (MPI_INTEGER                    = int(z'00000219'))
      integer MPI_REAL
      parameter (MPI_REAL                       = int(z'0000021a'))
      integer MPI_COMPLEX
      parameter (MPI_COMPLEX                    = int(z'0000021b'))
      integer MPI_DOUBLE_PRECISION
      parameter (MPI_DOUBLE_PRECISION           = int(z'0000021c'))
      integer MPI_DOUBLE_COMPLEX
      parameter (MPI_DOUBLE_COMPLEX             = int(z'0000021d'))
      integer MPI_LONG_DOUBLE
      parameter (MPI_LONG_DOUBLE                = int(z'00000220'))
      integer MPI_C_LONG_DOUBLE_COMPLEX
      parameter (MPI_C_LONG_DOUBLE_COMPLEX      = int(z'00000224'))
      integer MPI_CXX_LONG_DOUBLE_COMPLEX
      parameter (MPI_CXX_LONG_DOUBLE_COMPLEX    = int(z'00000225'))
      integer MPI_FLOAT_INT
      parameter (MPI_FLOAT_INT                  = int(z'00000228'))
      integer MPI_LONG_INT
      parameter (MPI_LONG_INT                   = int(z'0000022a'))
      integer MPI_2INT
      parameter (MPI_2INT                       = int(z'0000022b'))
      integer MPI_SHORT_INT
      parameter (MPI_SHORT_INT                  = int(z'0000022c'))
      integer MPI_LONG_DOUBLE_INT
      parameter (MPI_LONG_DOUBLE_INT            = int(z'0000022d'))
      integer MPI_2REAL
      parameter (MPI_2REAL                      = int(z'00000230'))
      integer MPI_2DOUBLE_PRECISION
      parameter (MPI_2DOUBLE_PRECISION          = int(z'00000231'))
      integer MPI_2INTEGER
      parameter (MPI_2INTEGER                   = int(z'00000232'))
      integer MPI_C_BOOL
      parameter (MPI_C_BOOL                     = int(z'00000238'))
      integer MPI_CXX_BOOL
      parameter (MPI_CXX_BOOL                   = int(z'00000239'))
      integer MPI_WCHAR
      parameter (MPI_WCHAR                      = int(z'0000023c'))
      integer MPI_INT8_T
      parameter (MPI_INT8_T                     = int(z'00000240'))
      integer MPI_UINT8_T
      parameter (MPI_UINT8_T                    = int(z'00000241'))
      integer MPI_CHAR
      parameter (MPI_CHAR                       = int(z'00000243'))
      integer MPI_SIGNED_CHAR
      parameter (MPI_SIGNED_CHAR                = int(z'00000244'))
      integer MPI_UNSIGNED_CHAR
      parameter (MPI_UNSIGNED_CHAR              = int(z'00000245'))
      integer MPI_BYTE
      parameter (MPI_BYTE                       = int(z'00000247'))
      integer MPI_INT16_T
      parameter (MPI_INT16_T                    = int(z'00000248'))
      integer MPI_UINT16_T
      parameter (MPI_UINT16_T                   = int(z'00000249'))
      integer MPI_INT32_T
      parameter (MPI_INT32_T                    = int(z'00000250'))
      integer MPI_UINT32_T
      parameter (MPI_UINT32_T                   = int(z'00000251'))
      integer MPI_INT64_T
      parameter (MPI_INT64_T                    = int(z'00000258'))
      integer MPI_UINT64_T
      parameter (MPI_UINT64_T                   = int(z'00000259'))
      integer MPI_LOGICAL1
      parameter (MPI_LOGICAL1                   = int(z'000002c0'))
      integer MPI_INTEGER1
      parameter (MPI_INTEGER1                   = int(z'000002c1'))
      integer MPI_CHARACTER
      parameter (MPI_CHARACTER                  = int(z'000002c3'))
      integer MPI_LOGICAL2
      parameter (MPI_LOGICAL2                   = int(z'000002c8'))
      integer MPI_INTEGER2
      parameter (MPI_INTEGER2                   = int(z'000002c9'))
      integer MPI_REAL2
      parameter (MPI_REAL2                      = int(z'000002ca'))
      integer MPI_LOGICAL4
      parameter (MPI_LOGICAL4                   = int(z'000002d0'))
      integer MPI_INTEGER4
      parameter (MPI_INTEGER4                   = int(z'000002d1'))
      integer MPI_REAL4
      parameter (MPI_REAL4                      = int(z'000002d2'))
      integer MPI_COMPLEX4
      parameter (MPI_COMPLEX4                   = int(z'000002d3'))
      integer MPI_LOGICAL8
      parameter (MPI_LOGICAL8                   = int(z'000002d8'))
      integer MPI_INTEGER8
      parameter (MPI_INTEGER8                   = int(z'000002d9'))
      integer MPI_REAL8
      parameter (MPI_REAL8                      = int(z'000002da'))
      integer MPI_COMPLEX8
      parameter (MPI_COMPLEX8                   = int(z'000002db'))
      integer MPI_LOGICAL16
      parameter (MPI_LOGICAL16                  = int(z'000002e0'))
      integer MPI_INTEGER16
      parameter (MPI_INTEGER16                  = int(z'000002e1'))
      integer MPI_REAL16
      parameter (MPI_REAL16                     = int(z'000002e2'))
      integer MPI_COMPLEX16
      parameter (MPI_COMPLEX16                  = int(z'000002e3'))
      integer MPI_COMPLEX32
      parameter (MPI_COMPLEX32                  = int(z'000002eb'))

!     Fortran 77 Status Size and Indices
      integer MPI_STATUS_SIZE
      parameter (MPI_STATUS_SIZE                = 8)
      integer MPI_SOURCE
      parameter (MPI_SOURCE                     = 1)
      integer MPI_TAG
      parameter (MPI_TAG                        = 2)
      integer MPI_ERROR
      parameter (MPI_ERROR                      = 3)

!     Error Classes
      integer MPI_SUCCESS
      parameter (MPI_SUCCESS                    =  0)

      integer MPI_ERR_BUFFER
      parameter (MPI_ERR_BUFFER                 =  1) ! added: MPI-1.0
      integer MPI_ERR_COUNT
      parameter (MPI_ERR_COUNT                  =  2) ! added: MPI-1.0
      integer MPI_ERR_TYPE
      parameter (MPI_ERR_TYPE                   =  3) ! added: MPI-1.0
      integer MPI_ERR_TAG
      parameter (MPI_ERR_TAG                    =  4) ! added: MPI-1.0
      integer MPI_ERR_COMM
      parameter (MPI_ERR_COMM                   =  5) ! added: MPI-1.0
      integer MPI_ERR_RANK
      parameter (MPI_ERR_RANK                   =  6) ! added: MPI-1.0
      integer MPI_ERR_REQUEST
      parameter (MPI_ERR_REQUEST                =  7) ! added: MPI-1.0
      integer MPI_ERR_ROOT
      parameter (MPI_ERR_ROOT                   =  8) ! added: MPI-1.0
      integer MPI_ERR_GROUP
      parameter (MPI_ERR_GROUP                  =  9) ! added: MPI-1.0
      integer MPI_ERR_OP
      parameter (MPI_ERR_OP                     = 10) ! added: MPI-1.0
      integer MPI_ERR_TOPOLOGY
      parameter (MPI_ERR_TOPOLOGY               = 11) ! added: MPI-1.0
      integer MPI_ERR_DIMS
      parameter (MPI_ERR_DIMS                   = 12) ! added: MPI-1.0
      integer MPI_ERR_ARG
      parameter (MPI_ERR_ARG                    = 13) ! added: MPI-1.0
      integer MPI_ERR_UNKNOWN
      parameter (MPI_ERR_UNKNOWN                = 14) ! added: MPI-1.0
      integer MPI_ERR_TRUNCATE
      parameter (MPI_ERR_TRUNCATE               = 15) ! added: MPI-1.0
      integer MPI_ERR_OTHER
      parameter (MPI_ERR_OTHER                  = 16) ! added: MPI-1.0
      integer MPI_ERR_INTERN
      parameter (MPI_ERR_INTERN                 = 17) ! added: MPI-1.0
      integer MPI_ERR_PENDING
      parameter (MPI_ERR_PENDING                = 18) ! added: MPI-1.1
      integer MPI_ERR_IN_STATUS
      parameter (MPI_ERR_IN_STATUS              = 19) ! added: MPI-1.1
      integer MPI_ERR_ACCESS
      parameter (MPI_ERR_ACCESS                 = 20) ! added: MPI-2.0
      integer MPI_ERR_AMODE
      parameter (MPI_ERR_AMODE                  = 21) ! added: MPI-2.0
      integer MPI_ERR_ASSERT
      parameter (MPI_ERR_ASSERT                 = 22) ! added: MPI-2.0
      integer MPI_ERR_BAD_FILE
      parameter (MPI_ERR_BAD_FILE               = 23) ! added: MPI-2.0
      integer MPI_ERR_BASE
      parameter (MPI_ERR_BASE                   = 24) ! added: MPI-2.0
      integer MPI_ERR_CONVERSION
      parameter (MPI_ERR_CONVERSION             = 25) ! added: MPI-2.0
      integer MPI_ERR_DISP
      parameter (MPI_ERR_DISP                   = 26) ! added: MPI-2.0
      integer MPI_ERR_DUP_DATAREP
      parameter (MPI_ERR_DUP_DATAREP            = 27) ! added: MPI-2.0
      integer MPI_ERR_FILE_EXISTS
      parameter (MPI_ERR_FILE_EXISTS            = 28) ! added: MPI-2.0
      integer MPI_ERR_FILE_IN_USE
      parameter (MPI_ERR_FILE_IN_USE            = 29) ! added: MPI-2.0
      integer MPI_ERR_FILE
      parameter (MPI_ERR_FILE                   = 30) ! added: MPI-2.0
      integer MPI_ERR_INFO_KEY
      parameter (MPI_ERR_INFO_KEY               = 31) ! added: MPI-2.0
      integer MPI_ERR_INFO_NOKEY
      parameter (MPI_ERR_INFO_NOKEY             = 32) ! added: MPI-2.0
      integer MPI_ERR_INFO_VALUE
      parameter (MPI_ERR_INFO_VALUE             = 33) ! added: MPI-2.0
      integer MPI_ERR_INFO
      parameter (MPI_ERR_INFO                   = 34) ! added: MPI-2.0
      integer MPI_ERR_IO
      parameter (MPI_ERR_IO                     = 35) ! added: MPI-2.0
      integer MPI_ERR_KEYVAL
      parameter (MPI_ERR_KEYVAL                 = 36) ! added: MPI-2.0
      integer MPI_ERR_LOCKTYPE
      parameter (MPI_ERR_LOCKTYPE               = 37) ! added: MPI-2.0
      integer MPI_ERR_NAME
      parameter (MPI_ERR_NAME                   = 38) ! added: MPI-2.0
      integer MPI_ERR_NO_MEM
      parameter (MPI_ERR_NO_MEM                 = 39) ! added: MPI-2.0
      integer MPI_ERR_NOT_SAME
      parameter (MPI_ERR_NOT_SAME               = 40) ! added: MPI-2.0
      integer MPI_ERR_NO_SPACE
      parameter (MPI_ERR_NO_SPACE               = 41) ! added: MPI-2.0
      integer MPI_ERR_NO_SUCH_FILE
      parameter (MPI_ERR_NO_SUCH_FILE           = 42) ! added: MPI-2.0
      integer MPI_ERR_PORT
      parameter (MPI_ERR_PORT                   = 43) ! added: MPI-2.0
      integer MPI_ERR_QUOTA
      parameter (MPI_ERR_QUOTA                  = 44) ! added: MPI-2.0
      integer MPI_ERR_READ_ONLY
      parameter (MPI_ERR_READ_ONLY              = 45) ! added: MPI-2.0
      integer MPI_ERR_RMA_ATTACH
      parameter (MPI_ERR_RMA_ATTACH             = 46) ! added: MPI-2.0
      integer MPI_ERR_RMA_CONFLICT
      parameter (MPI_ERR_RMA_CONFLICT           = 47) ! added: MPI-2.0
      integer MPI_ERR_RMA_RANGE
      parameter (MPI_ERR_RMA_RANGE              = 48) ! added: MPI-2.0
      integer MPI_ERR_RMA_SHARED
      parameter (MPI_ERR_RMA_SHARED             = 49) ! added: MPI-2.0
      integer MPI_ERR_RMA_SYNC
      parameter (MPI_ERR_RMA_SYNC               = 50) ! added: MPI-2.0
      integer MPI_ERR_SERVICE
      parameter (MPI_ERR_SERVICE                = 51) ! added: MPI-2.0
      integer MPI_ERR_SIZE
      parameter (MPI_ERR_SIZE                   = 52) ! added: MPI-2.0
      integer MPI_ERR_SPAWN
      parameter (MPI_ERR_SPAWN                  = 53) ! added: MPI-2.0
      integer MPI_ERR_UNSUPPORTED_DATAREP
      parameter (MPI_ERR_UNSUPPORTED_DATAREP    = 54) ! added: MPI-2.0
      integer MPI_ERR_UNSUPPORTED_OPERATION
      parameter (MPI_ERR_UNSUPPORTED_OPERATION  = 55) ! added: MPI-2.0
      integer MPI_ERR_WIN
      parameter (MPI_ERR_WIN                    = 56) ! added: MPI-2.0
      integer MPI_ERR_RMA_FLAVOR
      parameter (MPI_ERR_RMA_FLAVOR             = 57) ! added: MPI-3.0
      integer MPI_ERR_PROC_ABORTED
      parameter (MPI_ERR_PROC_ABORTED           = 58) ! added: MPI-4.0
      integer MPI_ERR_VALUE_TOO_LARGE
      parameter (MPI_ERR_VALUE_TOO_LARGE        = 59) ! added: MPI-4.0
      integer MPI_ERR_SESSION
      parameter (MPI_ERR_SESSION                = 60) ! added: MPI-4.0
      integer MPI_ERR_ERRHANDLER
      parameter (MPI_ERR_ERRHANDLER             = 61) ! added: MPI-4.1
      integer MPI_ERR_ABI
      parameter (MPI_ERR_ABI                    = 62) ! added: MPI-5.0

      integer MPI_T_ERR_CANNOT_INIT
      parameter (MPI_T_ERR_CANNOT_INIT          = 1001)
      integer MPI_T_ERR_NOT_ACCESSIBLE
      parameter (MPI_T_ERR_NOT_ACCESSIBLE       = 1002)
      integer MPI_T_ERR_NOT_INITIALIZED
      parameter (MPI_T_ERR_NOT_INITIALIZED      = 1003)
      integer MPI_T_ERR_NOT_SUPPORTED
      parameter (MPI_T_ERR_NOT_SUPPORTED        = 1004)
      integer MPI_T_ERR_MEMORY
      parameter (MPI_T_ERR_MEMORY               = 1005)
      integer MPI_T_ERR_INVALID
      parameter (MPI_T_ERR_INVALID              = 1006)
      integer MPI_T_ERR_INVALID_INDEX
      parameter (MPI_T_ERR_INVALID_INDEX        = 1007)
      integer MPI_T_ERR_INVALID_ITEM
      parameter (MPI_T_ERR_INVALID_ITEM         = 1008) ! deprecated: MPI-4.0
      integer MPI_T_ERR_INVALID_SESSION
      parameter (MPI_T_ERR_INVALID_SESSION      = 1009)
      integer MPI_T_ERR_INVALID_HANDLE
      parameter (MPI_T_ERR_INVALID_HANDLE       = 1010)
      integer MPI_T_ERR_INVALID_NAME
      parameter (MPI_T_ERR_INVALID_NAME         = 1011)
      integer MPI_T_ERR_OUT_OF_HANDLES
      parameter (MPI_T_ERR_OUT_OF_HANDLES       = 1012)
      integer MPI_T_ERR_OUT_OF_SESSIONS
      parameter (MPI_T_ERR_OUT_OF_SESSIONS      = 1013)
      integer MPI_T_ERR_CVAR_SET_NOT_NOW
      parameter (MPI_T_ERR_CVAR_SET_NOT_NOW     = 1014)
      integer MPI_T_ERR_CVAR_SET_NEVER
      parameter (MPI_T_ERR_CVAR_SET_NEVER       = 1015)
      integer MPI_T_ERR_PVAR_NO_WRITE
      parameter (MPI_T_ERR_PVAR_NO_WRITE        = 1016)
      integer MPI_T_ERR_PVAR_NO_STARTSTOP
      parameter (MPI_T_ERR_PVAR_NO_STARTSTOP    = 1017)
      integer MPI_T_ERR_PVAR_NO_ATOMIC
      parameter (MPI_T_ERR_PVAR_NO_ATOMIC       = 1018)

      integer MPI_ERR_LASTCODE
      parameter (MPI_ERR_LASTCODE               = int(z'3fff')) ! half of the minimum required value of INT_MAX

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
      integer MPI_MAX_DATAREP_STRING
      parameter (MPI_MAX_DATAREP_STRING         =  128) ! MPICH:  128 - OMPI:  128
      integer MPI_MAX_ERROR_STRING
      parameter (MPI_MAX_ERROR_STRING           =  512) ! MPICH:  512 - OMPI:  256
      integer MPI_MAX_INFO_KEY
      parameter (MPI_MAX_INFO_KEY               =  256) ! MPICH:  255 - OMPI:   36
      integer MPI_MAX_INFO_VAL
      parameter (MPI_MAX_INFO_VAL               = 1024) ! MPICH: 1024 - OMPI:  256
      integer MPI_MAX_LIBRARY_VERSION_STRING
      parameter (MPI_MAX_LIBRARY_VERSION_STRING = 8192) ! MPICH: 8192 - OMPI:  256
      integer MPI_MAX_OBJECT_NAME
      parameter (MPI_MAX_OBJECT_NAME            =  128) ! MPICH:  128 - OMPI:   64
      integer MPI_MAX_PORT_NAME
      parameter (MPI_MAX_PORT_NAME              = 1024) ! MPICH:  256 - OMPI: 1024
      integer MPI_MAX_PROCESSOR_NAME
      parameter (MPI_MAX_PROCESSOR_NAME         =  256) ! MPICH:  128 - OMPI:  256
      integer MPI_MAX_STRINGTAG_LEN
      parameter (MPI_MAX_STRINGTAG_LEN          = 1024) ! MPICH:  256 - OMPI: 1024
      integer MPI_MAX_PSET_NAME_LEN
      parameter (MPI_MAX_PSET_NAME_LEN          = 1024) ! MPICH:  256 - OMPI:  512
!     Assorted Constants
      integer MPI_BSEND_OVERHEAD
      parameter(MPI_BSEND_OVERHEAD              = 512) ! MPICH:   96 - OMPI:  128

!     Mode Constants - must be powers-of-2 to support OR-ing

!     File Open Modes
      integer MPI_MODE_APPEND
      parameter (MPI_MODE_APPEND                = 1)
      integer MPI_MODE_CREATE
      parameter (MPI_MODE_CREATE                = 2)
      integer MPI_MODE_DELETE_ON_CLOSE
      parameter (MPI_MODE_DELETE_ON_CLOSE       = 4)
      integer MPI_MODE_EXCL
      parameter (MPI_MODE_EXCL                  = 8)
      integer MPI_MODE_RDONLY
      parameter (MPI_MODE_RDONLY                = 16)
      integer MPI_MODE_RDWR
      parameter (MPI_MODE_RDWR                  = 32)
      integer MPI_MODE_SEQUENTIAL
      parameter (MPI_MODE_SEQUENTIAL            = 64)
      integer MPI_MODE_UNIQUE_OPEN
      parameter (MPI_MODE_UNIQUE_OPEN           = 128)
      integer MPI_MODE_WRONLY
      parameter (MPI_MODE_WRONLY                = 256)

!     Window Assertion Modes
      integer MPI_MODE_NOCHECK
      parameter (MPI_MODE_NOCHECK               = 1024)
      integer MPI_MODE_NOPRECEDE
      parameter (MPI_MODE_NOPRECEDE             = 2048)
      integer MPI_MODE_NOPUT
      parameter (MPI_MODE_NOPUT                 = 4096)
      integer MPI_MODE_NOSTORE
      parameter (MPI_MODE_NOSTORE               = 8192)
      integer MPI_MODE_NOSUCCEED
      parameter (MPI_MODE_NOSUCCEED             = 16384)

!     Wildcard values - must be negative
      integer MPI_ANY_SOURCE
      parameter (MPI_ANY_SOURCE                 = -1)
      integer MPI_ANY_TAG
      parameter (MPI_ANY_TAG                    = -2)

!     Rank sentinels - must be negative
      integer MPI_PROC_NULL
      parameter (MPI_PROC_NULL                  = -3)
      integer MPI_ROOT
      parameter (MPI_ROOT                       = -4)


!     Multi-purpose sentinel - must be negative
      integer MPI_UNDEFINED
      parameter (MPI_UNDEFINED                  = -32766)

!     Thread Support - monotonic values, SINGLE < FUNNELED < SERIALIZED < MULTIPLE.
      integer MPI_THREAD_SINGLE
      parameter (MPI_THREAD_SINGLE              = 0)
      integer MPI_THREAD_FUNNELED
      parameter (MPI_THREAD_FUNNELED            = 1024)
      integer MPI_THREAD_SERIALIZED
      parameter (MPI_THREAD_SERIALIZED          = 2048)
      integer MPI_THREAD_MULTIPLE
      parameter (MPI_THREAD_MULTIPLE            = 4096)

!     Array Datatype Order
      integer MPI_ORDER_C
      parameter (MPI_ORDER_C                    = int(z'C')) ! 12
      integer MPI_ORDER_FORTRAN
      parameter (MPI_ORDER_FORTRAN              = int(z'F')) ! 15

!     Array Datatype Distribution
      integer MPI_DISTRIBUTE_NONE
      parameter (MPI_DISTRIBUTE_NONE            = 16)
      integer MPI_DISTRIBUTE_BLOCK
      parameter (MPI_DISTRIBUTE_BLOCK           = 17)
      integer MPI_DISTRIBUTE_CYCLIC
      parameter (MPI_DISTRIBUTE_CYCLIC          = 18)
      integer MPI_DISTRIBUTE_DFLT_DARG
      parameter (MPI_DISTRIBUTE_DFLT_DARG       = 19)

!     Datatype Decoding Combiners
      integer MPI_COMBINER_NAMED
      parameter (MPI_COMBINER_NAMED             = 101)
      integer MPI_COMBINER_DUP
      parameter (MPI_COMBINER_DUP               = 102)
      integer MPI_COMBINER_CONTIGUOUS
      parameter (MPI_COMBINER_CONTIGUOUS        = 103)
      integer MPI_COMBINER_VECTOR
      parameter (MPI_COMBINER_VECTOR            = 104)
      integer MPI_COMBINER_HVECTOR
      parameter (MPI_COMBINER_HVECTOR           = 105)
      integer MPI_COMBINER_INDEXED
      parameter (MPI_COMBINER_INDEXED           = 106)
      integer MPI_COMBINER_HINDEXED
      parameter (MPI_COMBINER_HINDEXED          = 107)
      integer MPI_COMBINER_INDEXED_BLOCK
      parameter (MPI_COMBINER_INDEXED_BLOCK     = 108)
      integer MPI_COMBINER_HINDEXED_BLOCK
      parameter (MPI_COMBINER_HINDEXED_BLOCK    = 109)
      integer MPI_COMBINER_STRUCT
      parameter (MPI_COMBINER_STRUCT            = 110)
      integer MPI_COMBINER_SUBARRAY
      parameter (MPI_COMBINER_SUBARRAY          = 111)
      integer MPI_COMBINER_DARRAY
      parameter (MPI_COMBINER_DARRAY            = 112)
      integer MPI_COMBINER_F90_INTEGER
      parameter (MPI_COMBINER_F90_INTEGER       = 113)
      integer MPI_COMBINER_F90_REAL
      parameter (MPI_COMBINER_F90_REAL          = 114)
      integer MPI_COMBINER_F90_COMPLEX
      parameter (MPI_COMBINER_F90_COMPLEX       = 115)
      integer MPI_COMBINER_RESIZED
      parameter (MPI_COMBINER_RESIZED           = 116)
      integer MPI_COMBINER_VALUE_INDEX
      parameter (MPI_COMBINER_VALUE_INDEX       = 117)

!     Fortran Datatype Matching
      integer MPIX_TYPECLASS_LOGICAL
      parameter (MPIX_TYPECLASS_LOGICAL         = 191)
      integer MPI_TYPECLASS_INTEGER
      parameter (MPI_TYPECLASS_INTEGER          = 192)
      integer MPI_TYPECLASS_REAL
      parameter (MPI_TYPECLASS_REAL             = 193)
      integer MPI_TYPECLASS_COMPLEX
      parameter (MPI_TYPECLASS_COMPLEX          = 194)

!     Communicator and Group Comparisons
      integer MPI_IDENT
      parameter (MPI_IDENT                      = 201)
      integer MPI_CONGRUENT
      parameter (MPI_CONGRUENT                  = 202)
      integer MPI_SIMILAR
      parameter (MPI_SIMILAR                    = 203)
      integer MPI_UNEQUAL
      parameter (MPI_UNEQUAL                    = 204)

!     Communicator Virtual Topology Types
      integer MPI_CART
      parameter (MPI_CART                       = 211)
      integer MPI_GRAPH
      parameter (MPI_GRAPH                      = 212)
      integer MPI_DIST_GRAPH
      parameter (MPI_DIST_GRAPH                 = 213)

!     Communicator Split Types
      integer MPI_COMM_TYPE_SHARED
      parameter (MPI_COMM_TYPE_SHARED           = 221)
      integer MPI_COMM_TYPE_HW_UNGUIDED
      parameter (MPI_COMM_TYPE_HW_UNGUIDED      = 222)
      integer MPI_COMM_TYPE_HW_GUIDED
      parameter (MPI_COMM_TYPE_HW_GUIDED        = 223)
      integer MPI_COMM_TYPE_RESOURCE_GUIDED
      parameter (MPI_COMM_TYPE_RESOURCE_GUIDED  = 224)

!     Window Lock Types
      integer MPI_LOCK_EXCLUSIVE
      parameter ( MPI_LOCK_EXCLUSIVE            = 301)
      integer MPI_LOCK_SHARED
      parameter ( MPI_LOCK_SHARED               = 302)

!     Window Create Flavors
      integer MPI_WIN_FLAVOR_CREATE
      parameter (MPI_WIN_FLAVOR_CREATE          = 311)
      integer MPI_WIN_FLAVOR_ALLOCATE
      parameter (MPI_WIN_FLAVOR_ALLOCATE        = 312)
      integer MPI_WIN_FLAVOR_DYNAMIC
      parameter (MPI_WIN_FLAVOR_DYNAMIC         = 313)
      integer MPI_WIN_FLAVOR_SHARED
      parameter (MPI_WIN_FLAVOR_SHARED          = 314)

!     Window Memory Models
      integer MPI_WIN_UNIFIED
      parameter (MPI_WIN_UNIFIED                = 321)
      integer MPI_WIN_SEPARATE
      parameter (MPI_WIN_SEPARATE               = 322)

!     File Positioning
      integer MPI_SEEK_SET
      parameter ( MPI_SEEK_SET                  = 401)
      integer MPI_SEEK_CUR
      parameter ( MPI_SEEK_CUR                  = 402)
      integer MPI_SEEK_END
      parameter ( MPI_SEEK_END                  = 403)

!     File Operation Constants
      integer(MPI_OFFSET_KIND) MPI_DISPLACEMENT_CURRENT
      parameter (MPI_DISPLACEMENT_CURRENT = -1)

!     Predefined Attribute Keys

!     Invalid Attribute Key
      integer MPI_KEYVAL_INVALID
      parameter (MPI_KEYVAL_INVALID             = 0)

!     Communicator
      integer MPI_TAG_UB
      parameter (MPI_TAG_UB                     = 501)
      integer MPI_IO
      parameter (MPI_IO                         = 502)
      integer MPI_HOST
      parameter (MPI_HOST                       = 503) ! deprecated: MPI-4.1
      integer MPI_WTIME_IS_GLOBAL
      parameter (MPI_WTIME_IS_GLOBAL            = 504)
      integer MPI_UNIVERSE_SIZE
      parameter (MPI_UNIVERSE_SIZE              = 505)
      integer MPI_APPNUM
      parameter (MPI_APPNUM                     = 506)
      integer MPI_LASTUSEDCODE
      parameter (MPI_LASTUSEDCODE               = 507)

!     Window
      integer MPI_WIN_BASE
      parameter (MPI_WIN_BASE                   = 601)
      integer MPI_WIN_DISP_UNIT
      parameter (MPI_WIN_DISP_UNIT              = 602)
      integer MPI_WIN_SIZE
      parameter (MPI_WIN_SIZE                   = 603)
      integer MPI_WIN_CREATE_FLAVOR
      parameter (MPI_WIN_CREATE_FLAVOR          = 604)
      integer MPI_WIN_MODEL
      parameter (MPI_WIN_MODEL                  = 605)
