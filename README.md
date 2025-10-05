# mpif: MPI Fortran bindings

This package provides [Fortran](https://en.wikipedia.org/wiki/Fortran)
bindings for [MPI](https://www.mpi-forum.org), given any C
implementation of MPI.

mpif provides the MPI standard version 5.0.

## Status

mpif currently implements almost all Fortran bindings for the `mpif.h`
and `use mpi` parts. (Many Fortran codes use only these parts of the
MPI bindings.) Notable exceptions are callbacks (e.g. user-defined
operators) which are not yet supported. Almost nothing of the `use
mpi_f08` parts are supported. Adding this support is planned.
