module mpif_f08_types
  use mpif_f08_constants

  use mpi, only: &
       !
       MPIF_OP_NULL                 => MPI_OP_NULL                , &
       MPIF_SUM                     => MPI_SUM                    , &
       MPIF_MIN                     => MPI_MIN                    , &
       MPIF_MAX                     => MPI_MAX                    , &
       MPIF_PROD                    => MPI_PROD                   , &
       MPIF_BAND                    => MPI_BAND                   , &
       MPIF_BOR                     => MPI_BOR                    , &
       MPIF_BXOR                    => MPI_BXOR                   , &
       MPIF_LAND                    => MPI_LAND                   , &
       MPIF_LOR                     => MPI_LOR                    , &
       MPIF_LXOR                    => MPI_LXOR                   , &
       MPIF_MINLOC                  => MPI_MINLOC                 , &
       MPIF_MAXLOC                  => MPI_MAXLOC                 , &
       MPIF_REPLACE                 => MPI_REPLACE                , &
       MPIF_NO_OP                   => MPI_NO_OP                  , &
       !
       MPIF_COMM_NULL               => MPI_COMM_NULL              , &
       MPIF_COMM_WORLD              => MPI_COMM_WORLD             , &
       MPIF_COMM_SELF               => MPI_COMM_SELF              , &
       !
       MPIF_GROUP_NULL              => MPI_GROUP_NULL             , &
       MPIF_GROUP_EMPTY             => MPI_GROUP_EMPTY            , &
       !
       MPIF_WIN_NULL                => MPI_WIN_NULL               , &
       !
       MPIF_FILE_NULL               => MPI_FILE_NULL              , &
       !
       MPIF_SESSION_NULL            => MPI_SESSION_NULL           , &
       !
       MPIF_MESSAGE_NULL            => MPI_MESSAGE_NULL           , &
       MPIF_MESSAGE_NO_PROC         => MPI_MESSAGE_NO_PROC        , &
       !
       MPIF_INFO_NULL               => MPI_INFO_NULL              , &
       MPIF_INFO_ENV                => MPI_INFO_ENV               , &
       !
       MPIF_ERRHANDLER_NULL         => MPI_ERRHANDLER_NULL        , &
       MPIF_ERRORS_ARE_FATAL        => MPI_ERRORS_ARE_FATAL       , &
       MPIF_ERRORS_ABORT            => MPI_ERRORS_ABORT           , &
       MPIF_ERRORS_RETURN           => MPI_ERRORS_RETURN          , &
       !
       MPIF_REQUEST_NULL            => MPI_REQUEST_NULL           , &
       !
       MPIF_DATATYPE_NULL           => MPI_DATATYPE_NULL          , &
       MPIF_AINT                    => MPI_AINT                   , &
       MPIF_COUNT                   => MPI_COUNT                  , &
       MPIF_OFFSET                  => MPI_OFFSET                 , &
       MPIF_PACKED                  => MPI_PACKED                 , &
       MPIF_SHORT                   => MPI_SHORT                  , &
       MPIF_INT                     => MPI_INT                    , &
       MPIF_LONG                    => MPI_LONG                   , &
       MPIF_LONG_LONG               => MPI_LONG_LONG              , &
       MPIF_LONG_LONG_INT           => MPI_LONG_LONG_INT          , &
       MPIF_UNSIGNED_SHORT          => MPI_UNSIGNED_SHORT         , &
       MPIF_UNSIGNED                => MPI_UNSIGNED               , &
       MPIF_UNSIGNED_LONG           => MPI_UNSIGNED_LONG          , &
       MPIF_UNSIGNED_LONG_LONG      => MPI_UNSIGNED_LONG_LONG     , &
       MPIF_FLOAT                   => MPI_FLOAT                  , &
       MPIF_C_FLOAT_COMPLEX         => MPI_C_FLOAT_COMPLEX        , &
       MPIF_C_COMPLEX               => MPI_C_COMPLEX              , &
       MPIF_CXX_FLOAT_COMPLEX       => MPI_CXX_FLOAT_COMPLEX      , &
       MPIF_DOUBLE                  => MPI_DOUBLE                 , &
       MPIF_C_DOUBLE_COMPLEX        => MPI_C_DOUBLE_COMPLEX       , &
       MPIF_CXX_DOUBLE_COMPLEX      => MPI_CXX_DOUBLE_COMPLEX     , &
       MPIF_LOGICAL                 => MPI_LOGICAL                , &
       MPIF_INTEGER                 => MPI_INTEGER                , &
       MPIF_REAL                    => MPI_REAL                   , &
       MPIF_COMPLEX                 => MPI_COMPLEX                , &
       MPIF_DOUBLE_PRECISION        => MPI_DOUBLE_PRECISION       , &
       MPIF_DOUBLE_COMPLEX          => MPI_DOUBLE_COMPLEX         , &
       MPIF_CHARACTER               => MPI_CHARACTER              , &
       MPIF_LONG_DOUBLE             => MPI_LONG_DOUBLE            , &
       MPIF_C_LONG_DOUBLE_COMPLEX   => MPI_C_LONG_DOUBLE_COMPLEX  , &
       MPIF_CXX_LONG_DOUBLE_COMPLEX => MPI_CXX_LONG_DOUBLE_COMPLEX, &
       MPIF_FLOAT_INT               => MPI_FLOAT_INT              , &
       MPIF_DOUBLE_INT              => MPI_DOUBLE_INT             , &
       MPIF_LONG_INT                => MPI_LONG_INT               , &
       MPIF_2INT                    => MPI_2INT                   , &
       MPIF_SHORT_INT               => MPI_SHORT_INT              , &
       MPIF_LONG_DOUBLE_INT         => MPI_LONG_DOUBLE_INT        , &
       MPIF_2REAL                   => MPI_2REAL                  , &
       MPIF_2DOUBLE_PRECISION       => MPI_2DOUBLE_PRECISION      , &
       MPIF_2INTEGER                => MPI_2INTEGER               , &
       MPIF_C_BOOL                  => MPI_C_BOOL                 , &
       MPIF_CXX_BOOL                => MPI_CXX_BOOL               , &
       MPIF_WCHAR                   => MPI_WCHAR                  , &
       MPIF_INT8_T                  => MPI_INT8_T                 , &
       MPIF_UINT8_T                 => MPI_UINT8_T                , &
       MPIF_CHAR                    => MPI_CHAR                   , &
       MPIF_SIGNED_CHAR             => MPI_SIGNED_CHAR            , &
       MPIF_UNSIGNED_CHAR           => MPI_UNSIGNED_CHAR          , &
       MPIF_BYTE                    => MPI_BYTE                   , &
       MPIF_INT16_T                 => MPI_INT16_T                , &
       MPIF_UINT16_T                => MPI_UINT16_T               , &
       MPIF_INT32_T                 => MPI_INT32_T                , &
       MPIF_UINT32_T                => MPI_UINT32_T               , &
       MPIF_INT64_T                 => MPI_INT64_T                , &
       MPIF_UINT64_T                => MPI_UINT64_T               , &
       MPIF_LOGICAL1                => MPI_LOGICAL1               , &
       MPIF_INTEGER1                => MPI_INTEGER1               , &
       MPIF_LOGICAL2                => MPI_LOGICAL2               , &
       MPIF_INTEGER2                => MPI_INTEGER2               , &
       MPIF_REAL2                   => MPI_REAL2                  , &
       MPIF_LOGICAL4                => MPI_LOGICAL4               , &
       MPIF_INTEGER4                => MPI_INTEGER4               , &
       MPIF_REAL4                   => MPI_REAL4                  , &
       MPIF_COMPLEX4                => MPI_COMPLEX4               , &
       MPIF_LOGICAL8                => MPI_LOGICAL8               , &
       MPIF_INTEGER8                => MPI_INTEGER8               , &
       MPIF_REAL8                   => MPI_REAL8                  , &
       MPIF_COMPLEX8                => MPI_COMPLEX8               , &
       MPIF_LOGICAL16               => MPI_LOGICAL16              , &
       MPIF_INTEGER16               => MPI_INTEGER16              , &
       MPIF_REAL16                  => MPI_REAL16                 , &
       MPIF_COMPLEX16               => MPI_COMPLEX16              , &
       MPIF_COMPLEX32               => MPI_COMPLEX32

  implicit none
  private
  save

  public :: MPI_Status_f2f08
  public :: MPI_Status_f082f

  ! Handles

  type, bind(C), public :: MPI_Comm
     integer :: MPI_VAL
  end type MPI_Comm

  type, bind(C), public :: MPI_Datatype
     integer :: MPI_VAL
  end type MPI_Datatype

  type, bind(C), public :: MPI_Errhandler
     integer :: MPI_VAL
  end type MPI_Errhandler

  type, bind(C), public :: MPI_File
     integer :: MPI_VAL
  end type MPI_File

  type, bind(C), public :: MPI_Group
     integer :: MPI_VAL
  end type MPI_Group

  type, bind(C), public :: MPI_Info
     integer :: MPI_VAL
  end type MPI_Info

  type, bind(C), public :: MPI_Message
     integer :: MPI_VAL
  end type MPI_Message

  type, bind(C), public :: MPI_Op
     integer :: MPI_VAL
  end type MPI_Op

  type, bind(C), public :: MPI_Request
     integer :: MPI_VAL
  end type MPI_Request

  type, bind(C), public :: MPI_Session
     integer :: MPI_VAL
  end type MPI_Session

  type, bind(C), public :: MPI_Win
     integer :: MPI_VAL
  end type MPI_Win

  public :: operator(==), operator(/=)

  interface operator(==)
     module procedure mpif_comm_equal
     module procedure mpif_datatype_equal
     module procedure mpif_errhandler_equal
     module procedure mpif_file_equal
     module procedure mpif_group_equal
     module procedure mpif_info_equal
     module procedure mpif_message_equal
     module procedure mpif_op_equal
     module procedure mpif_request_equal
     module procedure mpif_session_equal
     module procedure mpif_win_equal
  end interface operator(==)

  interface operator(/=)
     module procedure mpif_comm_not_equal
     module procedure mpif_datatype_not_equal
     module procedure mpif_errhandler_not_equal
     module procedure mpif_file_not_equal
     module procedure mpif_group_not_equal
     module procedure mpif_info_not_equal
     module procedure mpif_message_not_equal
     module procedure mpif_op_not_equal
     module procedure mpif_request_not_equal
     module procedure mpif_session_not_equal
     module procedure mpif_win_not_equal
  end interface operator(/=)

  ! Status

  type, bind(C), public :: MPI_Status
     integer :: MPI_SOURCE
     integer :: MPI_TAG
     integer :: MPI_ERROR
     integer :: MPI_INTERNAL(5)
  end type MPI_Status

  ! MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE are TYPE(MPI_Status) here, where
  ! mpif.h and the mpi module declare them as INTEGER arrays. They therefore
  ! cannot just be re-exported from mpif_f08_constants the way the other sentinels
  ! are, and are declared here instead, this being where MPI_Status exists. An
  ! INTEGER one cannot be passed to a TYPE(MPI_Status) dummy argument at all,
  ! which is what stopped MPICH's f08 spawn tests from compiling.
  !
  ! Cray pointers into common blocks of their own, /MPIF_F08_STATUS_IGNORE_PTR/
  ! and /MPIF_F08_STATUSES_IGNORE_PTR/, which src/mpif_constants.c initialises
  ! from the same two C constants that mpif.h's sentinels get their addresses
  ! from. All three interfaces still put these names at one address; only the
  ! cell holding it is private to mpi_f08. The generated wrappers compare
  ! loc(status) against these and never read the contents.
  !
  ! Sharing mpif_constants' blocks -- the obvious arrangement, and what this used
  ! to do -- makes gfortran 15 emit a reference that no object defines, so every
  ! *user* of the sentinel fails to link:
  !
  !     Undefined symbols:
  !       "___mpif_f08_types_MOD_mpif_f08_statuses_ignore_ptr", referenced from:
  !           _MAIN__ in ...
  !
  ! Naming a sentinel is enough to trigger it -- `print *,
  ! loc(MPI_STATUSES_IGNORE)` after `use mpi_f08` does -- so it is not specific
  ! to passing one to MPI_Waitall. Three things have to come together, which is
  ! why it went unnoticed until a test passed one: the pointer sits in a common
  ! block that another module (mpif_constants, through mpif_f08_constants) also
  ! contributes a variable to; the reference is made through a module that
  ! re-exports this one, as mpi_f08 does, `use mpif_f08_types` directly being
  ! fine; and the pointee is an array. That last one is why MPI_STATUS_IGNORE
  ! seemed healthy -- but only ever one of the two resolved, and giving just the
  ! array its own block moved the failure onto the scalar rather than fixing it.
  ! Hence both.
  !
  ! The .mod file is not what is wrong: it records both pointers as IN_COMMON
  ! CRAY_POINTER and lists both blocks. This is a code-generation bug, not
  ! something to fix by declaring them differently.

  public :: MPI_STATUS_IGNORE
  type(MPI_Status) :: MPI_STATUS_IGNORE
  integer(MPI_ADDRESS_KIND) :: MPIF_F08_STATUS_IGNORE_PTR
  pointer (MPIF_F08_STATUS_IGNORE_PTR, MPI_STATUS_IGNORE)
  common /MPIF_F08_STATUS_IGNORE_PTR/ MPIF_F08_STATUS_IGNORE_PTR

  public :: MPI_STATUSES_IGNORE
  type(MPI_Status) :: MPI_STATUSES_IGNORE(1)
  integer(MPI_ADDRESS_KIND) :: MPIF_F08_STATUSES_IGNORE_PTR
  pointer (MPIF_F08_STATUSES_IGNORE_PTR, MPI_STATUSES_IGNORE)
  common /MPIF_F08_STATUSES_IGNORE_PTR/ MPIF_F08_STATUSES_IGNORE_PTR

  ! Constants

  type(MPI_Op), parameter, public :: MPI_OP_NULL = MPI_Op(MPIF_OP_NULL)
  type(MPI_Op), parameter, public :: MPI_SUM     = MPI_Op(MPIF_SUM    )
  type(MPI_Op), parameter, public :: MPI_MIN     = MPI_Op(MPIF_MIN    )
  type(MPI_Op), parameter, public :: MPI_MAX     = MPI_Op(MPIF_MAX    )
  type(MPI_Op), parameter, public :: MPI_PROD    = MPI_Op(MPIF_PROD   )
  type(MPI_Op), parameter, public :: MPI_BAND    = MPI_Op(MPIF_BAND   )
  type(MPI_Op), parameter, public :: MPI_BOR     = MPI_Op(MPIF_BOR    )
  type(MPI_Op), parameter, public :: MPI_BXOR    = MPI_Op(MPIF_BXOR   )
  type(MPI_Op), parameter, public :: MPI_LAND    = MPI_Op(MPIF_LAND   )
  type(MPI_Op), parameter, public :: MPI_LOR     = MPI_Op(MPIF_LOR    )
  type(MPI_Op), parameter, public :: MPI_LXOR    = MPI_Op(MPIF_LXOR   )
  type(MPI_Op), parameter, public :: MPI_MINLOC  = MPI_Op(MPIF_MINLOC )
  type(MPI_Op), parameter, public :: MPI_MAXLOC  = MPI_Op(MPIF_MAXLOC )
  type(MPI_Op), parameter, public :: MPI_REPLACE = MPI_Op(MPIF_REPLACE)
  type(MPI_Op), parameter, public :: MPI_NO_OP   = MPI_Op(MPIF_NO_OP  )

  type(MPI_Comm), parameter, public :: MPI_COMM_NULL  = MPI_Comm(MPIF_COMM_NULL )
  type(MPI_Comm), parameter, public :: MPI_COMM_WORLD = MPI_Comm(MPIF_COMM_WORLD)
  type(MPI_Comm), parameter, public :: MPI_COMM_SELF  = MPI_Comm(MPIF_COMM_SELF )

  type(MPI_Group), parameter, public :: MPI_GROUP_NULL  = MPI_Group(MPIF_GROUP_NULL )
  type(MPI_Group), parameter, public :: MPI_GROUP_EMPTY = MPI_Group(MPIF_GROUP_EMPTY)

  type(MPI_Win), parameter, public :: MPI_WIN_NULL = MPI_Win(MPIF_WIN_NULL)

  type(MPI_File), parameter, public :: MPI_FILE_NULL = MPI_File(MPIF_FILE_NULL)

  type(MPI_Session), parameter, public :: MPI_SESSION_NULL = MPI_Session(MPIF_SESSION_NULL)

  type(MPI_Message), parameter, public :: MPI_MESSAGE_NULL    = MPI_Message(MPIF_MESSAGE_NULL   )
  type(MPI_Message), parameter, public :: MPI_MESSAGE_NO_PROC = MPI_Message(MPIF_MESSAGE_NO_PROC)

  type(MPI_Info), parameter, public :: MPI_INFO_NULL = MPI_Info(MPIF_INFO_NULL)
  type(MPI_Info), parameter, public :: MPI_INFO_ENV  = MPI_Info(MPIF_INFO_ENV )

  type(MPI_Errhandler), parameter, public :: MPI_ERRHANDLER_NULL = MPI_Errhandler(MPIF_ERRHANDLER_NULL )
  type(MPI_Errhandler), parameter, public :: MPI_ERRORS_ARE_FATAL =MPI_Errhandler(MPIF_ERRORS_ARE_FATAL)
  type(MPI_Errhandler), parameter, public :: MPI_ERRORS_ABORT    = MPI_Errhandler(MPIF_ERRORS_ABORT    )
  type(MPI_Errhandler), parameter, public :: MPI_ERRORS_RETURN   = MPI_Errhandler(MPIF_ERRORS_RETURN   )

  type(MPI_Request), parameter, public :: MPI_REQUEST_NULL = MPI_Request(MPIF_REQUEST_NULL)

  type(MPI_Datatype), parameter, public :: MPI_DATATYPE_NULL           = MPI_Datatype(MPIF_DATATYPE_NULL          )
  type(MPI_Datatype), parameter, public :: MPI_AINT                    = MPI_Datatype(MPIF_AINT                   )
  type(MPI_Datatype), parameter, public :: MPI_COUNT                   = MPI_Datatype(MPIF_COUNT                  )
  type(MPI_Datatype), parameter, public :: MPI_OFFSET                  = MPI_Datatype(MPIF_OFFSET                 )
  type(MPI_Datatype), parameter, public :: MPI_PACKED                  = MPI_Datatype(MPIF_PACKED                 )
  type(MPI_Datatype), parameter, public :: MPI_SHORT                   = MPI_Datatype(MPIF_SHORT                  )
  type(MPI_Datatype), parameter, public :: MPI_INT                     = MPI_Datatype(MPIF_INT                    )
  type(MPI_Datatype), parameter, public :: MPI_LONG                    = MPI_Datatype(MPIF_LONG                   )
  type(MPI_Datatype), parameter, public :: MPI_LONG_LONG               = MPI_Datatype(MPIF_LONG_LONG              )
  type(MPI_Datatype), parameter, public :: MPI_LONG_LONG_INT           = MPI_Datatype(MPIF_LONG_LONG_INT          )
  type(MPI_Datatype), parameter, public :: MPI_UNSIGNED_SHORT          = MPI_Datatype(MPIF_UNSIGNED_SHORT         )
  type(MPI_Datatype), parameter, public :: MPI_UNSIGNED                = MPI_Datatype(MPIF_UNSIGNED               )
  type(MPI_Datatype), parameter, public :: MPI_UNSIGNED_LONG           = MPI_Datatype(MPIF_UNSIGNED_LONG          )
  type(MPI_Datatype), parameter, public :: MPI_UNSIGNED_LONG_LONG      = MPI_Datatype(MPIF_UNSIGNED_LONG_LONG     )
  type(MPI_Datatype), parameter, public :: MPI_FLOAT                   = MPI_Datatype(MPIF_FLOAT                  )
  type(MPI_Datatype), parameter, public :: MPI_C_FLOAT_COMPLEX         = MPI_Datatype(MPIF_C_FLOAT_COMPLEX        )
  type(MPI_Datatype), parameter, public :: MPI_C_COMPLEX               = MPI_Datatype(MPIF_C_COMPLEX              )
  type(MPI_Datatype), parameter, public :: MPI_CXX_FLOAT_COMPLEX       = MPI_Datatype(MPIF_CXX_FLOAT_COMPLEX      )
  type(MPI_Datatype), parameter, public :: MPI_DOUBLE                  = MPI_Datatype(MPIF_DOUBLE                 )
  type(MPI_Datatype), parameter, public :: MPI_C_DOUBLE_COMPLEX        = MPI_Datatype(MPIF_C_DOUBLE_COMPLEX       )
  type(MPI_Datatype), parameter, public :: MPI_CXX_DOUBLE_COMPLEX      = MPI_Datatype(MPIF_CXX_DOUBLE_COMPLEX     )
  type(MPI_Datatype), parameter, public :: MPI_LOGICAL                 = MPI_Datatype(MPIF_LOGICAL                )
  type(MPI_Datatype), parameter, public :: MPI_INTEGER                 = MPI_Datatype(MPIF_INTEGER                )
  type(MPI_Datatype), parameter, public :: MPI_REAL                    = MPI_Datatype(MPIF_REAL                   )
  type(MPI_Datatype), parameter, public :: MPI_COMPLEX                 = MPI_Datatype(MPIF_COMPLEX                )
  type(MPI_Datatype), parameter, public :: MPI_DOUBLE_PRECISION        = MPI_Datatype(MPIF_DOUBLE_PRECISION       )
  type(MPI_Datatype), parameter, public :: MPI_DOUBLE_COMPLEX          = MPI_Datatype(MPIF_DOUBLE_COMPLEX         )
  type(MPI_Datatype), parameter, public :: MPI_CHARACTER               = MPI_Datatype(MPIF_CHARACTER              )
  type(MPI_Datatype), parameter, public :: MPI_LONG_DOUBLE             = MPI_Datatype(MPIF_LONG_DOUBLE            )
  type(MPI_Datatype), parameter, public :: MPI_C_LONG_DOUBLE_COMPLEX   = MPI_Datatype(MPIF_C_LONG_DOUBLE_COMPLEX  )
  type(MPI_Datatype), parameter, public :: MPI_CXX_LONG_DOUBLE_COMPLEX = MPI_Datatype(MPIF_CXX_LONG_DOUBLE_COMPLEX)
  type(MPI_Datatype), parameter, public :: MPI_FLOAT_INT               = MPI_Datatype(MPIF_FLOAT_INT              )
  type(MPI_Datatype), parameter, public :: MPI_DOUBLE_INT              = MPI_Datatype(MPIF_DOUBLE_INT             )
  type(MPI_Datatype), parameter, public :: MPI_LONG_INT                = MPI_Datatype(MPIF_LONG_INT               )
  type(MPI_Datatype), parameter, public :: MPI_2INT                    = MPI_Datatype(MPIF_2INT                   )
  type(MPI_Datatype), parameter, public :: MPI_SHORT_INT               = MPI_Datatype(MPIF_SHORT_INT              )
  type(MPI_Datatype), parameter, public :: MPI_LONG_DOUBLE_INT         = MPI_Datatype(MPIF_LONG_DOUBLE_INT        )
  type(MPI_Datatype), parameter, public :: MPI_2REAL                   = MPI_Datatype(MPIF_2REAL                  )
  type(MPI_Datatype), parameter, public :: MPI_2DOUBLE_PRECISION       = MPI_Datatype(MPIF_2DOUBLE_PRECISION      )
  type(MPI_Datatype), parameter, public :: MPI_2INTEGER                = MPI_Datatype(MPIF_2INTEGER               )
  type(MPI_Datatype), parameter, public :: MPI_C_BOOL                  = MPI_Datatype(MPIF_C_BOOL                 )
  type(MPI_Datatype), parameter, public :: MPI_CXX_BOOL                = MPI_Datatype(MPIF_CXX_BOOL               )
  type(MPI_Datatype), parameter, public :: MPI_WCHAR                   = MPI_Datatype(MPIF_WCHAR                  )
  type(MPI_Datatype), parameter, public :: MPI_INT8_T                  = MPI_Datatype(MPIF_INT8_T                 )
  type(MPI_Datatype), parameter, public :: MPI_UINT8_T                 = MPI_Datatype(MPIF_UINT8_T                )
  type(MPI_Datatype), parameter, public :: MPI_CHAR                    = MPI_Datatype(MPIF_CHAR                   )
  type(MPI_Datatype), parameter, public :: MPI_SIGNED_CHAR             = MPI_Datatype(MPIF_SIGNED_CHAR            )
  type(MPI_Datatype), parameter, public :: MPI_UNSIGNED_CHAR           = MPI_Datatype(MPIF_UNSIGNED_CHAR          )
  type(MPI_Datatype), parameter, public :: MPI_BYTE                    = MPI_Datatype(MPIF_BYTE                   )
  type(MPI_Datatype), parameter, public :: MPI_INT16_T                 = MPI_Datatype(MPIF_INT16_T                )
  type(MPI_Datatype), parameter, public :: MPI_UINT16_T                = MPI_Datatype(MPIF_UINT16_T               )
  type(MPI_Datatype), parameter, public :: MPI_INT32_T                 = MPI_Datatype(MPIF_INT32_T                )
  type(MPI_Datatype), parameter, public :: MPI_UINT32_T                = MPI_Datatype(MPIF_UINT32_T               )
  type(MPI_Datatype), parameter, public :: MPI_INT64_T                 = MPI_Datatype(MPIF_INT64_T                )
  type(MPI_Datatype), parameter, public :: MPI_UINT64_T                = MPI_Datatype(MPIF_UINT64_T               )
  type(MPI_Datatype), parameter, public :: MPI_LOGICAL1                = MPI_Datatype(MPIF_LOGICAL1               )
  type(MPI_Datatype), parameter, public :: MPI_INTEGER1                = MPI_Datatype(MPIF_INTEGER1               )
  type(MPI_Datatype), parameter, public :: MPI_LOGICAL2                = MPI_Datatype(MPIF_LOGICAL2               )
  type(MPI_Datatype), parameter, public :: MPI_INTEGER2                = MPI_Datatype(MPIF_INTEGER2               )
  type(MPI_Datatype), parameter, public :: MPI_REAL2                   = MPI_Datatype(MPIF_REAL2                  )
  type(MPI_Datatype), parameter, public :: MPI_LOGICAL4                = MPI_Datatype(MPIF_LOGICAL4               )
  type(MPI_Datatype), parameter, public :: MPI_INTEGER4                = MPI_Datatype(MPIF_INTEGER4               )
  type(MPI_Datatype), parameter, public :: MPI_REAL4                   = MPI_Datatype(MPIF_REAL4                  )
  type(MPI_Datatype), parameter, public :: MPI_COMPLEX4                = MPI_Datatype(MPIF_COMPLEX4               )
  type(MPI_Datatype), parameter, public :: MPI_LOGICAL8                = MPI_Datatype(MPIF_LOGICAL8               )
  type(MPI_Datatype), parameter, public :: MPI_INTEGER8                = MPI_Datatype(MPIF_INTEGER8               )
  type(MPI_Datatype), parameter, public :: MPI_REAL8                   = MPI_Datatype(MPIF_REAL8                  )
  type(MPI_Datatype), parameter, public :: MPI_COMPLEX8                = MPI_Datatype(MPIF_COMPLEX8               )
  type(MPI_Datatype), parameter, public :: MPI_LOGICAL16               = MPI_Datatype(MPIF_LOGICAL16              )
  type(MPI_Datatype), parameter, public :: MPI_INTEGER16               = MPI_Datatype(MPIF_INTEGER16              )
  type(MPI_Datatype), parameter, public :: MPI_REAL16                  = MPI_Datatype(MPIF_REAL16                 )
  type(MPI_Datatype), parameter, public :: MPI_COMPLEX16               = MPI_Datatype(MPIF_COMPLEX16              )
  type(MPI_Datatype), parameter, public :: MPI_COMPLEX32               = MPI_Datatype(MPIF_COMPLEX32              )

  ! Procedures
  !
  ! No INTENT on any argument of any callback, which is how MPI-5.0 declares
  ! every one of them: the ABSTRACT INTERFACEs it gives in section 7.7.2 and
  ! elsewhere, and collects in Appendix A.1.3, are plain
  ! "TYPE(MPI_Comm) :: oldcomm", "INTEGER :: comm_keyval, ierror". The one
  ! exception in the whole standard is MPI_TYPE_NULL_DELETE_FN in A.4.13, whose
  ! `ierror` is INTENT(OUT) where its own abstract interface
  ! MPI_Type_delete_attr_function gives none; that is an inconsistency in the
  ! standard rather than a rule, and it is not followed here.
  !
  ! The omission is not cosmetic. INTENT is part of a dummy argument's
  ! characteristics, so a user callback whose interface is explicit -- a module
  ! procedure, which is the normal way to write one -- has to match the abstract
  ! interface exactly to be passed as a PROCEDURE(...) dummy. A callback written
  ! the way the standard writes it, with no intents, then fails to compile with
  ! "INTENT mismatch in argument 'extra_state'" against an interface that
  ! declares them. That is what the generalized request callbacks did until the
  ! intents came off, and it was equally true of every other callback here.
  !
  ! Where the direction genuinely matters the standard says so in prose, and for
  ! `extra_state` it deliberately does not: a callback may update it -- MPICH's
  ! greqf test requires a `free_fn` that decrements it to be seen by the caller.
  !
  ! The buffers of MPI_User_function and of the datarep conversion functions are
  ! TYPE(C_PTR), VALUE, which is what the standard gives them and also what makes
  ! them work; see the comment on MPI_User_function below.

  public :: MPI_Copy_function
  abstract interface
     subroutine MPI_Copy_function(oldcomm, keyval, extra_state, attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm) :: oldcomm
       integer :: keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: attribute_val_in
       integer :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine MPI_Copy_function
  end interface

  public :: MPI_Delete_function
  abstract interface
     subroutine MPI_Delete_function(comm, keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm) :: comm
       integer :: keyval
       integer :: attribute_val
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine MPI_Delete_function
  end interface

  public :: MPI_User_function
  public :: MPI_User_function_c
  ! TYPE(C_PTR), VALUE for the two buffers, exactly as for the datarep conversion
  ! functions below and for the same two reasons. MPI-5.0 gives them
  ! "TYPE(C_PTR), VALUE :: invec, inoutvec" -- in section 6.9.5, where the
  ! reduction callbacks are declared, and again in section 19.1.6 -- and that is
  ! also the only declaration a callback can be written against: the trampoline
  ! in src/mpif_callbacks.c passes the buffer address itself, because mpif.h and
  ! the mpi module want the address of `<type> INVEC(LEN)` and there is one C
  ! entry point behind all three interfaces. An INTEGER(KIND=MPI_ADDRESS_KIND)
  ! dummy, which is what these two used to be, asks instead for the address of a
  ! variable holding the buffer address, so an f08 reduction callback read the
  ! first bytes of the data as a pointer. test/op_create.f90 is the assertion.
  abstract interface
     subroutine MPI_User_function(invec, inoutvec, len, datatype)
       use mpif_f08_constants
       use, intrinsic :: iso_c_binding, only: C_PTR
       import :: MPI_Datatype
       implicit none
       type(C_PTR), value :: invec
       type(C_PTR), value :: inoutvec
       integer :: len
       type(MPI_Datatype) :: datatype
     end subroutine MPI_User_function

     subroutine MPI_User_function_c(invec, inoutvec, len, datatype)
       use mpif_f08_constants
       use, intrinsic :: iso_c_binding, only: C_PTR
       import :: MPI_Datatype
       implicit none
       type(C_PTR), value :: invec
       type(C_PTR), value :: inoutvec
       integer(MPI_COUNT_KIND) :: len
       type(MPI_Datatype) :: datatype
     end subroutine MPI_User_function_c
  end interface

  public :: MPI_Comm_copy_attr_function
  abstract interface
     subroutine MPI_Comm_copy_attr_function(oldcomm, comm_keyval, extra_state, attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm) :: oldcomm
       integer :: comm_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine MPI_Comm_copy_attr_function
  end interface

  public :: MPI_Comm_delete_attr_function
  abstract interface
     subroutine MPI_Comm_delete_attr_function(comm, comm_keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm) :: comm
       integer :: comm_keyval
       integer(MPI_ADDRESS_KIND) :: attribute_val
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine MPI_Comm_delete_attr_function
  end interface

  public :: MPI_Comm_errhandler_function
  abstract interface
     subroutine MPI_Comm_errhandler_function(comm, error_code)
       import :: MPI_Comm
       implicit none
       type(MPI_Comm) :: comm
       integer :: error_code
     end subroutine MPI_Comm_errhandler_function
  end interface

  public :: MPI_Datarep_conversion_function
  public :: MPI_Datarep_conversion_function_c
  ! TYPE(C_PTR), VALUE for the two buffers, which is what MPI-5.0 A.4 gives them
  ! and, unusually, is also what makes them work. They used to be
  ! INTEGER(KIND=MPI_ADDRESS_KIND) by reference, which asks for the address of a
  ! variable holding the buffer address; the trampoline in src/mpif_callbacks.c
  ! passes the buffer address itself, because that is what mpif.h's and the mpi
  ! module's `<TYPE> USERBUF(*)` wants and there is only one C entry point behind
  ! all three interfaces. A pointer passed by value and an assumed-size array's
  ! address are the same thing in the same register, so C_PTR is what reconciles
  ! them.
  abstract interface
     subroutine MPI_Datarep_conversion_function(userbuf, datatype, count, filebuf, position, extra_state, ierror)
       use mpif_f08_constants
       use, intrinsic :: iso_c_binding, only: C_PTR
       import :: MPI_Datatype
       implicit none
       type(C_PTR), value :: userbuf
       type(MPI_Datatype) :: datatype
       integer :: count
       type(C_PTR), value :: filebuf
       integer(MPI_OFFSET_KIND) :: position
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine MPI_Datarep_conversion_function

     subroutine MPI_Datarep_conversion_function_c(userbuf, datatype, count, filebuf, position, extra_state, ierror)
       use mpif_f08_constants
       use, intrinsic :: iso_c_binding, only: C_PTR
       import :: MPI_Datatype
       implicit none
       type(C_PTR), value :: userbuf
       type(MPI_Datatype) :: datatype
       integer(MPI_COUNT_KIND) :: count
       type(C_PTR), value :: filebuf
       integer(MPI_OFFSET_KIND) :: position
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine MPI_Datarep_conversion_function_c
  end interface

  public :: MPI_Datarep_extent_function
  abstract interface
     subroutine MPI_Datarep_extent_function(datatype, extent, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype) :: datatype
       integer(MPI_ADDRESS_KIND) :: extent
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine MPI_Datarep_extent_function
  end interface

  public :: MPI_File_errhandler_function
  abstract interface
     subroutine MPI_File_errhandler_function(file, error_code)
       import :: MPI_File
       implicit none
       type(MPI_File) :: file
       integer :: error_code
     end subroutine MPI_File_errhandler_function
  end interface

  public :: MPI_Grequest_query_function
  abstract interface
     subroutine MPI_Grequest_query_function(extra_state, status, ierror)
       use mpif_f08_constants
       import :: MPI_Status
       implicit none
       integer(MPI_ADDRESS_KIND) :: extra_state
       type(MPI_Status) :: status
       integer :: ierror
     end subroutine MPI_Grequest_query_function
  end interface

  public :: MPI_Grequest_cancel_function
  abstract interface
     subroutine MPI_Grequest_cancel_function(extra_state, complete, ierror)
       use mpif_f08_constants
       implicit none
       integer(MPI_ADDRESS_KIND) :: extra_state
       logical :: complete
       integer :: ierror
     end subroutine MPI_Grequest_cancel_function
  end interface

  public :: MPI_Grequest_free_function
  abstract interface
     subroutine MPI_Grequest_free_function(extra_state, ierror)
       use mpif_f08_constants
       implicit none
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine MPI_Grequest_free_function
  end interface

  public :: MPI_Session_errhandler_function
  abstract interface
     subroutine MPI_Session_errhandler_function(session, error_code)
       import :: MPI_Session
       implicit none
       type(MPI_Session) :: session
       integer :: error_code
     end subroutine MPI_Session_errhandler_function
  end interface

  public :: MPI_Type_copy_attr_function
  abstract interface
     subroutine MPI_Type_copy_attr_function(oldtype, type_keyval, extra_state, attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype) :: oldtype
       integer :: type_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine MPI_Type_copy_attr_function
  end interface

  public :: MPI_Type_delete_attr_function
  abstract interface
     subroutine MPI_Type_delete_attr_function(type, type_keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype) :: type
       integer :: type_keyval
       integer(MPI_ADDRESS_KIND) :: attribute_val
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine MPI_Type_delete_attr_function
  end interface

  public :: MPI_Win_errhandler_function
  abstract interface
     subroutine MPI_Win_errhandler_function(win, error_code)
       import :: MPI_Win
       implicit none
       type(MPI_Win) :: win
       integer :: error_code
     end subroutine MPI_Win_errhandler_function
  end interface

  public :: MPI_Win_copy_attr_function
  abstract interface
     subroutine MPI_Win_copy_attr_function(oldwin, win_keyval, extra_state, attribute_val_in, attribute_val_out, flag, ierror)
       use mpif_f08_constants
       import :: MPI_Win
       implicit none
       type(MPI_Win) :: oldwin
       integer :: win_keyval
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer(MPI_ADDRESS_KIND) :: attribute_val_in
       integer(MPI_ADDRESS_KIND) :: attribute_val_out
       logical :: flag
       integer :: ierror
     end subroutine MPI_Win_copy_attr_function
  end interface

  public :: MPI_Win_delete_attr_function
  abstract interface
     subroutine MPI_Win_delete_attr_function(win, win_keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Win
       implicit none
       type(MPI_Win) :: win
       integer :: win_keyval
       integer(MPI_ADDRESS_KIND) :: attribute_val
       integer(MPI_ADDRESS_KIND) :: extra_state
       integer :: ierror
     end subroutine MPI_Win_delete_attr_function
  end interface

contains

  logical function mpif_comm_equal(comm1, comm2) result(result)
    type(MPI_Comm), intent(in) :: comm1, comm2
    result = comm1%MPI_VAL == comm2%MPI_VAL
  end function mpif_comm_equal

  logical function mpif_comm_not_equal(comm1, comm2) result(result)
    type(MPI_Comm), intent(in) :: comm1, comm2
    result = .not.(comm1 == comm2)
  end function mpif_comm_not_equal

  logical function mpif_datatype_equal(type1, type2) result(result)
    type(MPI_Datatype), intent(in) :: type1, type2
    result = type1%MPI_VAL == type2%MPI_VAL
  end function mpif_datatype_equal

  logical function mpif_datatype_not_equal(type1, type2) result(result)
    type(MPI_Datatype), intent(in) :: type1, type2
    result = .not.(type1 == type2)
  end function mpif_datatype_not_equal

  logical function mpif_errhandler_equal(errhandler1, errhandler2) result(result)
    type(MPI_Errhandler), intent(in) :: errhandler1, errhandler2
    result = errhandler1%MPI_VAL == errhandler2%MPI_VAL
  end function mpif_errhandler_equal

  logical function mpif_errhandler_not_equal(errhandler1, errhandler2) result(result)
    type(MPI_Errhandler), intent(in) :: errhandler1, errhandler2
    result = .not.(errhandler1 == errhandler2)
  end function mpif_errhandler_not_equal

  logical function mpif_file_equal(file1, file2) result(result)
    type(MPI_File), intent(in) :: file1, file2
    result = file1%MPI_VAL == file2%MPI_VAL
  end function mpif_file_equal

  logical function mpif_file_not_equal(file1, file2) result(result)
    type(MPI_File), intent(in) :: file1, file2
    result = .not.(file1 == file2)
  end function mpif_file_not_equal

  logical function mpif_group_equal(group1, group2) result(result)
    type(MPI_Group), intent(in) :: group1, group2
    result = group1%MPI_VAL == group2%MPI_VAL
  end function mpif_group_equal

  logical function mpif_group_not_equal(group1, group2) result(result)
    type(MPI_Group), intent(in) :: group1, group2
    result = .not.(group1 == group2)
  end function mpif_group_not_equal

  logical function mpif_info_equal(info1, info2) result(result)
    type(MPI_Info), intent(in) :: info1, info2
    result = info1%MPI_VAL == info2%MPI_VAL
  end function mpif_info_equal

  logical function mpif_info_not_equal(info1, info2) result(result)
    type(MPI_Info), intent(in) :: info1, info2
    result = .not.(info1 == info2)
  end function mpif_info_not_equal

  logical function mpif_message_equal(message1, message2) result(result)
    type(MPI_Message), intent(in) :: message1, message2
    result = message1%MPI_VAL == message2%MPI_VAL
  end function mpif_message_equal

  logical function mpif_message_not_equal(message1, message2) result(result)
    type(MPI_Message), intent(in) :: message1, message2
    result = .not.(message1 == message2)
  end function mpif_message_not_equal

  logical function mpif_op_equal(op1, op2) result(result)
    type(MPI_Op), intent(in) :: op1, op2
    result = op1%MPI_VAL == op2%MPI_VAL
  end function mpif_op_equal

  logical function mpif_op_not_equal(op1, op2) result(result)
    type(MPI_Op), intent(in) :: op1, op2
    result = .not.(op1 == op2)
  end function mpif_op_not_equal

  logical function mpif_request_equal(request1, request2) result(result)
    type(MPI_Request), intent(in) :: request1, request2
    result = request1%MPI_VAL == request2%MPI_VAL
  end function mpif_request_equal

  logical function mpif_request_not_equal(request1, request2) result(result)
    type(MPI_Request), intent(in) :: request1, request2
    result = .not.(request1 == request2)
  end function mpif_request_not_equal

  logical function mpif_session_equal(session1, session2) result(result)
    type(MPI_Session), intent(in) :: session1, session2
    result = session1%MPI_VAL == session2%MPI_VAL
  end function mpif_session_equal

  logical function mpif_session_not_equal(session1, session2) result(result)
    type(MPI_Session), intent(in) :: session1, session2
    result = .not.(session1 == session2)
  end function mpif_session_not_equal

  logical function mpif_win_equal(win1, win2) result(result)
    type(MPI_Win), intent(in) :: win1, win2
    result = win1%MPI_VAL == win2%MPI_VAL
  end function mpif_win_equal

  logical function mpif_win_not_equal(win1, win2) result(result)
    type(MPI_Win), intent(in) :: win1, win2
    result = .not.(win1 == win2)
  end function mpif_win_not_equal

  subroutine MPI_Status_f2f08(f_status, f08_status, ierror)
    integer, intent(in) :: f_status(MPI_STATUS_SIZE)
    type(MPI_Status), intent(out) :: f08_status
    integer, optional, intent(out) :: ierror
    f08_status%MPI_SOURCE = f_status(MPI_SOURCE)
    f08_status%MPI_TAG = f_status(MPI_TAG)
    f08_status%MPI_ERROR = f_status(MPI_ERROR)
    f08_status%MPI_internal(1:5) = f_status(4:8)
    if (present(ierror)) ierror = MPI_SUCCESS
  end subroutine MPI_Status_f2f08

  subroutine MPI_Status_f082f(f08_status, f_status, ierror)
    type(MPI_Status), intent(in) :: f08_status
    integer, intent(out) :: f_status(MPI_STATUS_SIZE)
    integer, optional, intent(out) :: ierror
    f_status(MPI_SOURCE) = f08_status%MPI_SOURCE
    f_status(MPI_TAG) = f08_status%MPI_TAG
    f_status(MPI_ERROR) = f08_status%MPI_ERROR
    f_status(4:8) = f08_status%MPI_internal(1:5)
    if (present(ierror)) ierror = MPI_SUCCESS
  end subroutine MPI_Status_f082f

end module mpif_f08_types
