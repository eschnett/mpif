! The Fortran half of the TS 29113 probe; see CMakeLists.txt here. Passes the
! argument shapes mpi_f08's choice buffers must accept -- a scalar, contiguous
! arrays, noncontiguous sections, characters -- to a bind(C) assumed-rank
! dummy carrying the attributes the generated interfaces use, and exits
! nonzero if any descriptor is wrong.

program probe
  use, intrinsic :: iso_c_binding
  implicit none

  interface
     function probe_c(buf, expected_base, expected_elem_len, expected_rank, &
          expected_contiguous) result(res) bind(c, name="probe_c")
       use, intrinsic :: iso_c_binding
       implicit none
       type(*), dimension(..), intent(in), asynchronous :: buf
       type(c_ptr), value :: expected_base
       integer(c_size_t), value :: expected_elem_len
       integer(c_int), value :: expected_rank
       integer(c_int), value :: expected_contiguous
       integer(c_int) :: res
     end function probe_c
  end interface

  integer(c_int32_t), target :: scalar
  integer(c_int32_t), target :: a(10)
  integer(c_int32_t), target :: m(7, 6)
  character(len=8, kind=c_char), target :: s(5)
  integer :: failures

  scalar = 42
  a = 0
  m = 0
  s = ''
  failures = 0

  ! A scalar actual: rank 0, contiguous.
  failures = failures + probe_c(scalar, c_loc(scalar), 4_c_size_t, &
       0_c_int, 1_c_int)
  ! A whole array: rank 1, contiguous.
  failures = failures + probe_c(a, c_loc(a(1)), 4_c_size_t, 1_c_int, 1_c_int)
  ! A strided section: noncontiguous, and its base address must be the
  ! original array's element, not a copy's.
  failures = failures + probe_c(a(1:7:2), c_loc(a(1)), 4_c_size_t, &
       1_c_int, 0_c_int)
  ! A two-dimensional section, noncontiguous in the outer dimension only.
  failures = failures + probe_c(m(:, 2:6:2), c_loc(m(1, 2)), 4_c_size_t, &
       2_c_int, 0_c_int)
  ! Characters: the element length is the string length.
  failures = failures + probe_c(s, c_loc(s(1)), 8_c_size_t, 1_c_int, 1_c_int)
  failures = failures + probe_c(s(1:5:2), c_loc(s(1)), 8_c_size_t, &
       1_c_int, 0_c_int)

  if (failures /= 0) stop 1
end program probe
