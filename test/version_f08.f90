program version_f08
  use mpi_f08
  implicit none

  integer :: version, subversion
  integer :: abi_major, abi_minor
  character*(MPI_MAX_LIBRARY_VERSION_STRING) :: library_version
  integer :: resultlen

  call MPI_Get_version(version, subversion)
  print '("MPI standard version ",i0,".",i0)', version, subversion

  call MPI_Abi_get_version(abi_major, abi_minor)
  print '("MPI ABI version ",i0,".",i0)', abi_major, abi_minor

  call MPI_Get_library_version(library_version, resultlen)
  print '("MPI implementation:")'
  print '(a)', trim(library_version)

end program version_f08
