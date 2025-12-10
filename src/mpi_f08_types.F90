module mpi_f08_types
  use mpi_f08_constants

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

  ! Status

  type, bind(C), public :: MPI_Status
     integer :: MPI_VAL(MPI_STATUS_SIZE)
  end type MPI_Status

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

  public :: MPI_Copy_function
  abstract interface
     subroutine MPI_Copy_function(oldcomm, keyval, extra_state, attribute_val_in, attribute_val_out, flag, ierror)
       use mpi_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm), intent(in) :: oldcomm
       integer, intent(in) :: keyval
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(in) :: attribute_val_in
       integer, intent(out) :: attribute_val_out
       logical, intent(out) :: flag
       integer, intent(out) :: ierror
     end subroutine MPI_Copy_function
  end interface

  public :: MPI_Delete_function
  abstract interface
     subroutine MPI_Delete_function(comm, keyval, attribute_val, extra_state, ierror)
       use mpi_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm), intent(in) :: comm
       integer, intent(in) :: keyval
       integer, intent(in) :: attribute_val
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(out) :: ierror
     end subroutine MPI_Delete_function
  end interface

  public :: MPI_User_function
  public :: MPI_User_function_c
  abstract interface
     subroutine MPI_User_function(invec, inoutvec, len, datatype)
       use mpi_f08_constants
       import :: MPI_Datatype
       implicit none
       integer(MPI_ADDRESS_KIND), intent(in) :: invec
       integer(MPI_ADDRESS_KIND), intent(in) :: inoutvec
       integer, intent(in) :: len
       type(MPI_Datatype), intent(in) :: datatype
     end subroutine MPI_User_function

     subroutine MPI_User_function_c(invec, inoutvec, len, datatype)
       use mpi_f08_constants
       import :: MPI_Datatype
       implicit none
       integer(MPI_ADDRESS_KIND), intent(in) :: invec
       integer(MPI_ADDRESS_KIND), intent(in) :: inoutvec
       integer(MPI_COUNT_KIND), intent(in) :: len
       type(MPI_Datatype), intent(in) :: datatype
     end subroutine MPI_User_function_c
  end interface

  public :: MPI_Comm_copy_attr_function
  abstract interface
     subroutine MPI_Comm_copy_attr_function(oldcomm, comm_keyval, extra_state, attribute_val_in, attribute_val_out, flag, ierror)
       use mpi_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm), intent(in) :: oldcomm
       integer, intent(in) :: comm_keyval
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(in) :: attribute_val_in
       integer, intent(out) :: attribute_val_out
       logical, intent(out) :: flag
       integer, intent(out) :: ierror
     end subroutine MPI_Comm_copy_attr_function
  end interface

  public :: MPI_Comm_delete_attr_function
  abstract interface
     subroutine MPI_Comm_delete_attr_function(comm, comm_keyval, attribute_val, extra_state, ierror)
       use mpi_f08_constants
       import :: MPI_Comm
       implicit none
       type(MPI_Comm), intent(in) :: comm
       integer, intent(in) :: comm_keyval
       integer, intent(in) :: attribute_val
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(out) :: ierror
     end subroutine MPI_Comm_delete_attr_function
  end interface

  public :: MPI_Comm_errhandler_function
  abstract interface
     subroutine MPI_Comm_errhandler_function(comm, error_code)
       import :: MPI_Comm
       implicit none
       type(MPI_Comm), intent(in) :: comm
       integer, intent(in) :: error_code
     end subroutine MPI_Comm_errhandler_function
  end interface

  public :: MPI_Datarep_conversion_function
  public :: MPI_Datarep_conversion_function_c
  abstract interface
     subroutine MPI_Datarep_conversion_function(userbuf, datatype, count, filebuf, position, extra_state, ierror)
       use mpi_f08_constants
       import :: MPI_Datatype
       implicit none
       integer(MPI_ADDRESS_KIND), intent(in) :: userbuf
       type(MPI_Datatype), intent(in) :: datatype
       integer, intent(in) :: count
       integer(MPI_ADDRESS_KIND), intent(in) :: filebuf
       integer(MPI_OFFSET_KIND), intent(in) :: position
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(in) :: ierror
     end subroutine MPI_Datarep_conversion_function

     subroutine MPI_Datarep_conversion_function_c(userbuf, datatype, count, filebuf, position, extra_state, ierror)
       use mpi_f08_constants
       import :: MPI_Datatype
       implicit none
       integer(MPI_ADDRESS_KIND), intent(in) :: userbuf
       type(MPI_Datatype), intent(in) :: datatype
       integer(MPI_COUNT_KIND), intent(in) :: count
       integer(MPI_ADDRESS_KIND), intent(in) :: filebuf
       integer(MPI_OFFSET_KIND), intent(in) :: position
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(in) :: ierror
     end subroutine MPI_Datarep_conversion_function_c
  end interface

  public :: MPI_Datarep_extent_function
  abstract interface
     subroutine MPI_Datarep_extent_function(datatype, extent, extra_state, ierror)
       use mpi_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype), intent(in) :: datatype
       integer(MPI_ADDRESS_KIND), intent(out) :: extent
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(in) :: ierror
     end subroutine MPI_Datarep_extent_function
  end interface

  public :: MPI_File_errhandler_function
  abstract interface
     subroutine MPI_File_errhandler_function(file, error_code)
       import :: MPI_File
       implicit none
       type(MPI_File), intent(in) :: file
       integer, intent(in) :: error_code
     end subroutine MPI_File_errhandler_function
  end interface

  public :: MPI_Grequest_query_function
  abstract interface
     subroutine MPI_Grequest_query_function(extra_state, status, ierror)
       use mpi_f08_constants
       import :: MPI_Status
       implicit none
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       type(MPI_Status), intent(out) :: status
       integer, intent(out) :: ierror
     end subroutine MPI_Grequest_query_function
  end interface

  public :: MPI_Grequest_cancel_function
  abstract interface
     subroutine MPI_Grequest_cancel_function(extra_state, complete, ierror)
       use mpi_f08_constants
       implicit none
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       logical, intent(in) :: complete
       integer, intent(out) :: ierror
     end subroutine MPI_Grequest_cancel_function
  end interface

  public :: MPI_Grequest_free_function
  abstract interface
     subroutine MPI_Grequest_free_function(extra_state, ierror)
       use mpi_f08_constants
       implicit none
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(out) :: ierror
     end subroutine MPI_Grequest_free_function
  end interface

  public :: MPI_Session_errhandler_function
  abstract interface
     subroutine MPI_Session_errhandler_function(session, error_code)
       import :: MPI_Session
       implicit none
       type(MPI_Session), intent(in) :: session
       integer, intent(in) :: error_code
     end subroutine MPI_Session_errhandler_function
  end interface

  public :: MPI_Type_copy_attr_function
  abstract interface
     subroutine MPI_Type_copy_attr_function(oldtype, type_keyval, extra_state, attribute_val_in, attribute_val_out, flag, ierror)
       use mpi_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype), intent(in) :: oldtype
       integer, intent(in) :: type_keyval
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(in) :: attribute_val_in
       integer, intent(out) :: attribute_val_out
       logical, intent(out) :: flag
       integer, intent(out) :: ierror
     end subroutine MPI_Type_copy_attr_function
  end interface

  public :: MPI_Type_delete_attr_function
  abstract interface
     subroutine MPI_Type_delete_attr_function(type, type_keyval, attribute_val, extra_state, ierror)
       use mpi_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype), intent(in) :: type
       integer, intent(in) :: type_keyval
       integer, intent(in) :: attribute_val
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(out) :: ierror
     end subroutine MPI_Type_delete_attr_function
  end interface

  public :: MPI_Win_errhandler_function
  abstract interface
     subroutine MPI_Win_errhandler_function(win, error_code)
       import :: MPI_Win
       implicit none
       type(MPI_Win), intent(in) :: win
       integer, intent(in) :: error_code
     end subroutine MPI_Win_errhandler_function
  end interface

  public :: MPI_Win_copy_attr_function
  abstract interface
     subroutine MPI_Win_copy_attr_function(oldwin, win_keyval, extra_state, attribute_val_in, attribute_val_out, flag, ierror)
       use mpi_f08_constants
       import :: MPI_Win
       implicit none
       type(MPI_Win), intent(in) :: oldwin
       integer, intent(in) :: win_keyval
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(in) :: attribute_val_in
       integer, intent(out) :: attribute_val_out
       logical, intent(out) :: flag
       integer, intent(out) :: ierror
     end subroutine MPI_Win_copy_attr_function
  end interface

  public :: MPI_Win_delete_attr_function
  abstract interface
     subroutine MPI_Win_delete_attr_function(win, win_keyval, attribute_val, extra_state, ierror)
       use mpi_f08_constants
       import :: MPI_Win
       implicit none
       type(MPI_Win), intent(in) :: win
       integer, intent(in) :: win_keyval
       integer, intent(in) :: attribute_val
       integer(MPI_ADDRESS_KIND), intent(in) :: extra_state
       integer, intent(out) :: ierror
     end subroutine MPI_Win_delete_attr_function
  end interface

contains

  subroutine MPI_Status_f2f08(f_status, f08_status, ierror)
    integer, intent(in) :: f_status(MPI_STATUS_SIZE)
    type(MPI_Status), intent(out) :: f08_status
    integer, optional, intent(out) :: ierror
    f08_status%MPI_VAL = f_status
    if (present(ierror)) ierror = MPI_SUCCESS
  end subroutine MPI_Status_f2f08

  subroutine MPI_Status_f082f(f08_status, f_status, ierror)
    type(MPI_Status), intent(in) :: f08_status
    integer, intent(out) :: f_status(MPI_STATUS_SIZE)
    integer, optional, intent(out) :: ierror
    f_status = f08_status%MPI_VAL
    if (present(ierror)) ierror = MPI_SUCCESS
  end subroutine MPI_Status_f082f

end module mpi_f08_types
