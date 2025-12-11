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

  integer*1 :: logical1_true, logical1_false
  integer*2 :: logical2_true, logical2_false
  integer*4 :: logical4_true, logical4_false
  integer*8 :: logical8_true, logical8_false
  ! integer*16 :: logical16_true, logical16_false
  logical :: is_set

  call MPI_Init()

  call MPI_Get_version(version, subversion)
  print '("MPI standard version ",i0,".",i0)', version, subversion

  call MPI_Abi_get_version(abi_major, abi_minor)
  print '("MPI ABI version ",i0,".",i0)', abi_major, abi_minor

  call MPI_Get_library_version(library_version, resultlen)
  print '("MPI implementation:")'
  print '(a)', trim(library_version)

  call MPI_Abi_get_info(abi_info)
  print '("MPI ABI info:")'
  call MPI_Info_get_nkeys(abi_info, nkeys)
  do n = 0, nkeys-1
     call MPI_Info_get_nthkey(abi_info, n, key)
     call MPI_Info_get(abi_info, key, len(value), value, flag)
     if (.not.flag) stop 1
     print '("   ",i0,": ",a,"=",a)', n, trim(key), trim(value)
  end do

  ! This requires MPI_Init, although it probably shouldn't
  call MPI_Abi_get_fortran_info(abi_info)
  print '("MPI ABI Fortran info:")'
  if (abi_info /= MPI_INFO_NULL) then
     call MPI_Info_get_nkeys(abi_info, nkeys)
     do n = 0, nkeys-1
        call MPI_Info_get_nthkey(abi_info, n, key)
        call MPI_Info_get(abi_info, key, len(value), value, flag)
        if (.not.flag) stop 1
        print '("   ",i0,": ",a,"=",a)', n, trim(key), trim(value)
     end do
  else
     print '("   (unavailable)")'
  end if

  print '("MPI ABI Fortran booleans:")'
  ! call MPI_Abi_get_fortran_booleans(1, logical1_true, logical1_false, is_set)
  ! if (is_set) then
  !    print '("   logical*1: true=",i0,", false=",i0)', logical1_true, logical1_false
  ! else
  !    print '("   logical*1: (not set)")'
  ! end if
  ! call MPI_Abi_get_fortran_booleans(2, logical2_true, logical2_false, is_set)
  ! if (is_set) then
  !    print '("   logical*2: true=",i0,", false=",i0)', logical2_true, logical2_false
  ! else
  !    print '("   logical*2: (not set)")'
  ! end if
  call MPI_Abi_get_fortran_booleans(4, logical4_true, logical4_false, is_set)
  if (is_set) then
     print '("   logical*4: true=",i0,", false=",i0)', logical4_true, logical4_false
  else
     print '("   logical*4: (not set)")'
  end if
  ! call MPI_Abi_get_fortran_booleans(8, logical8_true, logical8_false, is_set)
  ! if (is_set) then
  !    print '("   logical*8: true=",i0,", false=",i0)', logical8_true, logical8_false
  ! else
  !    print '("   logical*8: (not set)")'
  ! end if
  ! call MPI_Abi_get_fortran_booleans(16, logical16_true, logical16_false, is_set)
  ! if (is_set) then
  !    print '("   logical*16: true=",i0,", false=",i0)', logical16_true, logical16_false
  ! else
  !    print '("   logical*16: (not set)")'
  ! end if
     
  call MPI_Finalize()

end program version_f08
