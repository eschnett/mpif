subroutine sub
  implicit none
  public

  interface mpi_sizeof

     subroutine mpif_sizeof_logical1(x, size, ierror)
       logical(1)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_logical1

     subroutine mpif_sizeof_logical2(x, size, ierror)
       logical(2)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_logical2

     subroutine mpif_sizeof_logical4(x, size, ierror)
       logical(4)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_logical4

     subroutine mpif_sizeof_logical8(x, size, ierror)
       logical(8)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_logical8

     subroutine mpif_sizeof_logical16(x, size, ierror)
       logical(16)                    :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_logical16

     subroutine mpif_sizeof_integer1(x, size, ierror)
       integer(1)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_integer1

     subroutine mpif_sizeof_integer2(x, size, ierror)
       integer(2)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_integer2

     subroutine mpif_sizeof_integer4(x, size, ierror)
       integer(4)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_integer4

     subroutine mpif_sizeof_integer8(x, size, ierror)
       integer(8)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_integer8

     subroutine mpif_sizeof_integer16(x, size, ierror)
       integer(16)                    :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_integer16

     subroutine mpif_sizeof_real2(x, size, ierror)
       real(2)                        :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_real2

     subroutine mpif_sizeof_real4(x, size, ierror)
       real(4)                        :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_real4

     subroutine mpif_sizeof_real8(x, size, ierror)
       real(8)                       :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_real8

     subroutine mpif_sizeof_real16(x, size, ierror)
       real(16)                       :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_real16

     subroutine mpif_sizeof_complex4(x, size, ierror)
       complex(4)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_complex4

     subroutine mpif_sizeof_complex8(x, size, ierror)
       complex(8)                     :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_complex8

     subroutine mpif_sizeof_complex16(x, size, ierror)
       complex(16)                    :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_complex16

     subroutine mpif_sizeof_complex32(x, size, ierror)
       complex(32)                    :: x(*)
       integer, intent(out)           :: size
       integer, intent(out), optional :: ierror
     end subroutine mpif_sizeof_complex32

  end interface mpi_sizeof

end subroutine sub
