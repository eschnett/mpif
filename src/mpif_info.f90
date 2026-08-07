! mpif_info: print what this MPI setup actually loaded, from inside it.
!
! The standard ABI moves the choice of MPI library -- and of mpif itself -- to
! run time, so what a program was built against and what it is running with
! can differ, and the place to ask is inside the launched processes. This tool
! is that question made runnable: `mpiexec -n 4 mpif_info` prints the loaded
! library's versions against the headers', the implementation string, the
! process and node layout, and the ABI info objects, and then runs
! mpif_check_version and mpif_check_environment (src/mpif_check.c). It also
! works without a launcher, as a singleton.
!
! The information prints before the checks run, deliberately: when the check
! aborts, the versions and layout above the diagnostic are the diagnosis. The
! MPIF_MPI_LIBRARY, MPIF_SIZE, MPIF_NUM_NODES and MPIF_NODE_SIZE environment
! variables are honored through the check, as documented there.
!
! It is also the one installed program built against mpif's own mpi_f08
! module, so a working `bin/mpif_info` is a standing demonstration that the
! bindings, the library and the loaded MPI agree.

program mpif_info
  use mpi_f08
  implicit none

  ! Which file the loader resolved libmpi_abi to; see src/mpif_info_dladdr.c.
  interface
     subroutine mpif_info_loaded_library(path, length) &
          bind(C, name="mpif_info_loaded_library")
       use, intrinsic :: iso_c_binding, only: c_char, c_int
       character(kind=c_char), intent(out) :: path(*)
       integer(c_int), value :: length
     end subroutine mpif_info_loaded_library
  end interface

  integer :: version, subversion
  integer :: abi_major, abi_minor

  character(MPI_MAX_LIBRARY_VERSION_STRING) :: library_version
  character(4096) :: library_path
  integer :: resultlen

  integer :: world_size, world_rank

  character(MPI_MAX_PROCESSOR_NAME) :: procname
  character(MPI_MAX_PROCESSOR_NAME), allocatable :: names(:)
  integer :: namelen, num_nodes, node_size
  logical :: seen

  type(MPI_Info) :: abi_info, abi_fortran_info
  integer :: nkeys, n
  character(MPI_MAX_INFO_KEY) :: key
  character(MPI_MAX_INFO_VAL) :: value
  logical :: flag

  logical :: logical_true, logical_false
  logical :: is_set

  integer :: i, j

  call MPI_Init()

  call MPI_Comm_size(MPI_COMM_WORLD, world_size)
  call MPI_Comm_rank(MPI_COMM_WORLD, world_rank)

  ! The node layout, gathered by everyone before rank 0 starts printing. The
  ! names come back blank-padded to their full length, so records compare
  ! with ==.
  call MPI_Get_processor_name(procname, namelen)
  allocate(names(world_size))
  call MPI_Gather(procname, MPI_MAX_PROCESSOR_NAME, MPI_CHARACTER, &
       names, MPI_MAX_PROCESSOR_NAME, MPI_CHARACTER, 0, MPI_COMM_WORLD)

  if (world_rank == 0) then

     print '("mpif ",i0,".",i0,".",i0)', &
          MPIF_VERSION, MPIF_SUBVERSION, MPIF_PATCH

     call MPI_Get_version(version, subversion)
     print '("MPI standard version ",i0,".",i0," (mpif built against ",i0,".",i0,")")', &
          version, subversion, MPI_VERSION, MPI_SUBVERSION

     call MPI_Abi_get_version(abi_major, abi_minor)
     print '("MPI ABI version ",i0,".",i0," (mpif built against ",i0,".",i0,")")', &
          abi_major, abi_minor, MPI_ABI_VERSION, MPI_ABI_SUBVERSION

     call MPI_Get_library_version(library_version, resultlen)
     print '("MPI implementation:")'
     print '("   ",a)', trim(library_version)

     call mpif_info_loaded_library(library_path, len(library_path))
     print '("MPI library loaded from:")'
     print '("   ",a)', trim(library_path)

     print '("Processes: ",i0)', world_size

     ! Count distinct names, then print each with its population. An O(n^2)
     ! scan over blank-padded fixed-width records: a diagnostic tool, so
     ! clarity beats asymptotics.
     num_nodes = 0
     do i = 1, world_size
        seen = .false.
        do j = 1, i - 1
           if (names(j) == names(i)) seen = .true.
        end do
        if (.not. seen) num_nodes = num_nodes + 1
     end do
     print '("Nodes: ",i0)', num_nodes
     do i = 1, world_size
        seen = .false.
        do j = 1, i - 1
           if (names(j) == names(i)) seen = .true.
        end do
        if (.not. seen) then
           node_size = 0
           do j = 1, world_size
              if (names(j) == names(i)) node_size = node_size + 1
           end do
           print '("   ",a,": ",i0," processes")', trim(names(i)), node_size
        end if
     end do

     print '("MPI ABI info:")'
     call MPI_Abi_get_info(abi_info)
     if (abi_info == MPI_INFO_NULL) then
        print '("   (not set)")'
     else
        call MPI_Info_get_nkeys(abi_info, nkeys)
        do n = 0, nkeys - 1
           call MPI_Info_get_nthkey(abi_info, n, key)
           call MPI_Info_get(abi_info, key, len(value), value, flag)
           if (flag) print '("   ",a,"=",a)', trim(key), trim(value)
        end do
     end if

     print '("MPI ABI Fortran booleans:")'
     call MPI_Abi_get_fortran_booleans(4, logical_true, logical_false, is_set)
     if (is_set) then
        print '("   logical: true=",l0,", false=",l0)', &
             logical_true, logical_false
     else
        print '("   logical: (not set)")'
     end if

     ! Requires MPI_Init, although it probably should not; see
     ! test/version_f08.f90. Unlike that test, this tool reports rather than
     ! asserts, so an unset info object is a line of output, not a failure.
     print '("MPI ABI Fortran info:")'
     call MPI_Abi_get_fortran_info(abi_fortran_info)
     if (abi_fortran_info == MPI_INFO_NULL) then
        print '("   (not set)")'
     else
        call MPI_Info_get_nkeys(abi_fortran_info, nkeys)
        do n = 0, nkeys - 1
           call MPI_Info_get_nthkey(abi_fortran_info, n, key)
           call MPI_Info_get(abi_fortran_info, key, len(value), value, flag)
           if (flag) print '("   ",a,"=",a)', trim(key), trim(value)
        end do
     end if

  end if

  ! The checks, on every rank: mpif_check_environment is collective over
  ! MPI_COMM_WORLD. A failure aborts with its own diagnostic, below the
  ! information already printed.
  call mpif_check_version(MPIF_VERSION, MPIF_SUBVERSION, MPIF_PATCH)
  call mpif_check_environment()

  if (world_rank == 0) print '("mpif_check_environment: passed")'

  call MPI_Finalize()

end program mpif_info
