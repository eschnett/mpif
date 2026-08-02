! The mpi_f08 half of what test/attr_fns_f90.f90 asserts. MPI-5.0 Appendix A.4
! gives each predefined attribute callback a binding of its own, with
! TYPE(MPI_Comm) where A.5 has INTEGER, so mpi_f08 cannot re-export the
! procedures mpif.h uses -- it needs procedures of its own, which is what
! src/mpif_f08_attr_fns.F90 provides. Before that, none of these names existed in
! mpi_f08 and this file did not compile.
!
! Passing them is the other half of the assertion: each has to reach MPI and be
! accepted. What that does not prove is that src/mpif_callbacks.c recognises
! these addresses as the predefined ones. Deleting their entries from its table
! leaves this test passing, because an address it does not know is treated as
! user-defined and given a trampoline, and these bodies do what the sentinel
! does. The entries earn their place elsewhere -- see the comment on them there.
!
! MPI_NULL_COPY_FN, MPI_DUP_FN and MPI_NULL_DELETE_FN are deliberately absent:
! those are the MPI-1 forms, which A.4 does not list.
!
! Everything is done on MPI_COMM_SELF so that no launcher is needed.

program attr_fns_f08
  use mpi_f08
  implicit none

  integer :: keyval, type_keyval, win_keyval, disp_unit, buf(1)
  integer(MPI_ADDRESS_KIND) :: value, extra, winsize
  logical :: flag
  type(MPI_Win) :: win

  call MPI_Init()
  extra = 0

  ! Communicator attributes

  call MPI_Comm_create_keyval(MPI_COMM_NULL_COPY_FN, MPI_COMM_NULL_DELETE_FN, &
       keyval, extra)
  value = 42
  call MPI_Comm_set_attr(MPI_COMM_SELF, keyval, value)
  call MPI_Comm_get_attr(MPI_COMM_SELF, keyval, value, flag)
  if (.not. flag) stop 1
  if (value /= 42) stop 2
  call MPI_Comm_delete_attr(MPI_COMM_SELF, keyval)
  call MPI_Comm_free_keyval(keyval)
  print '("MPI_COMM_NULL_COPY_FN and MPI_COMM_NULL_DELETE_FN: ok")'

  call MPI_Comm_create_keyval(MPI_COMM_DUP_FN, MPI_COMM_NULL_DELETE_FN, &
       keyval, extra)
  call MPI_Comm_free_keyval(keyval)
  print '("MPI_COMM_DUP_FN: ok")'

  ! Datatype attributes. No predefined datatype is given one: MPICH aborts on
  ! those in ABI builds, which is an upstream bug rather than anything this test
  ! is about.

  call MPI_Type_create_keyval(MPI_TYPE_NULL_COPY_FN, MPI_TYPE_NULL_DELETE_FN, &
       type_keyval, extra)
  call MPI_Type_free_keyval(type_keyval)
  call MPI_Type_create_keyval(MPI_TYPE_DUP_FN, MPI_TYPE_NULL_DELETE_FN, &
       type_keyval, extra)
  call MPI_Type_free_keyval(type_keyval)
  print '("MPI_TYPE_NULL_COPY_FN, MPI_TYPE_DUP_FN, MPI_TYPE_NULL_DELETE_FN: ok")'

  ! Window attributes

  call MPI_Win_create_keyval(MPI_WIN_NULL_COPY_FN, MPI_WIN_NULL_DELETE_FN, &
       win_keyval, extra)
  call MPI_Type_size(MPI_INTEGER, disp_unit)
  winsize = int(1, MPI_ADDRESS_KIND) * disp_unit
  call MPI_Win_create(buf, winsize, disp_unit, MPI_INFO_NULL, MPI_COMM_SELF, win)
  value = 7
  call MPI_Win_set_attr(win, win_keyval, value)
  call MPI_Win_get_attr(win, win_keyval, value, flag)
  if (.not. flag) stop 3
  if (value /= 7) stop 4
  call MPI_Win_free(win)
  call MPI_Win_free_keyval(win_keyval)
  print '("MPI_WIN_NULL_COPY_FN, MPI_WIN_DUP_FN, MPI_WIN_NULL_DELETE_FN: ok")'

  ! The null datarep conversions. Named and passed as procedures rather than
  ! registered: MPI_Register_datarep does not forward user-defined callbacks yet.

  call name_only(MPI_CONVERSION_FN_NULL)
  call name_only_c(MPI_CONVERSION_FN_NULL_C)
  print '("MPI_CONVERSION_FN_NULL and MPI_CONVERSION_FN_NULL_C: ok")'

  print '("attr_fns_f08: all ok")'

  call MPI_Finalize()

contains

  ! Requiring the abstract interface is the point: it is what a generated wrapper
  ! declares its dummy as, so this fails to compile unless the predefined
  ! procedure really does match it, intents included.
  subroutine name_only(fn)
    procedure(MPI_Datarep_conversion_function) :: fn
  end subroutine name_only

  subroutine name_only_c(fn)
    procedure(MPI_Datarep_conversion_function_c) :: fn
  end subroutine name_only_c

end program attr_fns_f08
