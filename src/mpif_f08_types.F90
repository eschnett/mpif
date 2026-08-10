module mpif_f08_types
  use mpif_f08_constants

  ! The handle types, TYPE(MPI_Status), the comparison operators and the two
  ! status converters come from mpif_handle_types, which the mpi module also
  ! uses: MPI-5.0 section 19.1.3 requires them from both modules, and "all named
  ! handle types that are used in the mpi_f08 module" means one set of types, not
  ! two. They cannot be defined here and re-exported downwards, because the
  ! PARAMETER handle constants below need `use mpi` and mpi would then need this.
  ! Re-exported publicly, this module being `private` by default.
  use mpif_handle_types

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

  ! Handles, status, the comparison operators and the two status converters, all
  ! use-associated from mpif_handle_types and re-exported unchanged.

  public :: MPI_Comm
  public :: MPI_Datatype
  public :: MPI_Errhandler
  public :: MPI_File
  public :: MPI_Group
  public :: MPI_Info
  public :: MPI_Message
  public :: MPI_Op
  public :: MPI_Request
  public :: MPI_Session
  public :: MPI_Win

  public :: operator(==), operator(/=)

  public :: MPI_Status

  public :: MPI_Status_f2f08
  public :: MPI_Status_f082f
  public :: PMPI_Status_f2f08
  public :: PMPI_Status_f082f

  ! MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE are TYPE(MPI_Status) here, where
  ! mpif.h and the mpi module declare them as INTEGER arrays. They therefore
  ! cannot just be re-exported from mpif_f08_constants the way the other sentinels
  ! are, and are declared here instead, this being where MPI_Status exists. An
  ! INTEGER one cannot be passed to a TYPE(MPI_Status) dummy argument at all,
  ! which is what stopped MPICH's f08 spawn tests from compiling.
  !
  ! COMMON blocks of their own, /MPIF_F08_STATUS_IGNORE/ and
  ! /MPIF_F08_STATUSES_IGNORE/, merged onto the storage src/mpif_constants.c
  ! defines. Two things follow from their being separate objects rather than
  ! separate views of one:
  !
  ! - mpi_f08's two sentinels have addresses of their own, distinct from the mpi
  !   module's. MPI-5.0 section 3.2.6 permits it -- "MPI_STATUS_IGNORE and
  !   MPI_STATUSES_IGNORE are not required to have the same values in C and
  !   Fortran" -- and it is an improvement over the four sharing one value: a C
  !   layer can now tell an mpi_f08 sentinel from an mpif.h one.
  ! - the C side has four addresses to recognise, not two. The f08 wrappers reach
  !   the same C entry points as mpif.h does, through mpif_f08_raw, so
  !   mpi_recv_'s `status` may be either object; see include/mpif_sentinels.h.
  !
  ! TYPE(MPI_Status) is legal in a COMMON block: F2023 C8124 asks a derived-type
  ! common-block object's type to have BIND or SEQUENCE and no default
  ! initialization, and MPI_Status is `type, bind(C)` with four uninitialized
  ! INTEGER components. TARGET, as in include/mpif_constants.h, for uniformity.
  !
  ! Two blocks rather than one because the objects have different types, so they
  ! could not share a block in any case. There was also a gfortran 15 defect
  ! behind the split when these were Cray pointers -- sharing mpif_constants'
  ! block made gfortran emit `___mpif_f08_types_MOD_mpif_f08_statuses_ignore_ptr`
  ! as a reference no object defined, so every *user* of the sentinel failed to
  ! link. Its preconditions included the Cray pointer, which is gone, so it is
  ! probably gone with it; nothing here depends on the answer.

  public :: MPI_STATUS_IGNORE
  type(MPI_Status), target :: MPI_STATUS_IGNORE
  common /MPIF_F08_STATUS_IGNORE/ MPI_STATUS_IGNORE

  public :: MPI_STATUSES_IGNORE
  type(MPI_Status), target :: MPI_STATUSES_IGNORE(1)
  common /MPIF_F08_STATUSES_IGNORE/ MPI_STATUSES_IGNORE

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
  ! Where the direction genuinely matters the standard says so in prose; these
  ! abstract interfaces simply carry no INTENTs at all, `extra_state` included.
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
       integer :: extra_state
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
       integer :: extra_state
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
     subroutine MPI_Type_delete_attr_function(datatype, type_keyval, attribute_val, extra_state, ierror)
       use mpif_f08_constants
       import :: MPI_Datatype
       implicit none
       type(MPI_Datatype) :: datatype
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

end module mpif_f08_types
