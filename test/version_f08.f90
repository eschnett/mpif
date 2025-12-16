program version_f08
  use mpi_f08
  implicit none

  integer :: version, subversion
  integer :: abi_major, abi_minor

  character*(MPI_MAX_LIBRARY_VERSION_STRING) :: library_version
  integer :: resultlen

  type(MPI_Info) :: abi_info
  integer :: nkeys, n
  character*(MPI_MAX_INFO_KEY) :: key
  character*(MPI_MAX_INFO_VAL) :: value
  integer :: valuelen
  logical :: flag

  logical :: logical_true, logical_false
  logical :: is_set

  call MPI_Init()

  call MPI_Get_version(version, subversion)
  print '("MPI standard version ",i0,".",i0)', version, subversion

  call MPI_Abi_get_version(abi_major, abi_minor)
  print '("MPI ABI version ",i0,".",i0)', abi_major, abi_minor

  call MPI_Get_library_version(library_version, resultlen)
  print '("MPI implementation:")'
  print '(a)', trim(library_version)

  print '("MPI ABI info:")'
  call MPI_Abi_get_info(abi_info)
  if (abi_info == MPI_INFO_NULL) stop 1
  call MPI_Info_get_nkeys(abi_info, nkeys)
  do n = 0, nkeys-1
     call MPI_Info_get_nthkey(abi_info, n, key)
     call MPI_Info_get(abi_info, key, len(value), value, flag)
     if (.not.flag) stop 1
     print '("   ",i0,": ",a,"=",a)', n, trim(key), trim(value)
  end do

  print '("MPI ABI Fortran booleans:")'
  call MPI_Abi_get_fortran_booleans(4, logical_true, logical_false, is_set)
  if (.not.is_set) stop 1
  if (is_set) then
     print '("   logical: true=",l0,", false=",l0)', logical_true, logical_false
  else
     print '("   logical: (not set)")'
  end if

  ! This requires MPI_Init, although it probably shouldn't
  print '("MPI ABI Fortran info:")'
  call MPI_Abi_get_fortran_info(abi_info)
  if (abi_info == MPI_INFO_NULL) stop 1
  call MPI_Info_get_nkeys(abi_info, nkeys)
  do n = 0, nkeys-1
     call MPI_Info_get_nthkey(abi_info, n, key)
     call MPI_Info_get(abi_info, key, len(value), value, flag)
     if (.not.flag) stop 1
     print '("   ",i0,": ",a,"=",a)', n, trim(key), trim(value)
  end do
     
  call MPI_Finalize()

end program version_f08
