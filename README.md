# mpif: MPI Fortran bindings

[![CI](https://github.com/eschnett/mpif/actions/workflows/ci.yaml/badge.svg)](https://github.com/eschnett/mpif/actions/workflows/ci.yaml)

This package provides [Fortran](https://en.wikipedia.org/wiki/Fortran)
bindings for [MPI](https://www.mpi-forum.org), given any C
implementation of MPI. A major use case is the new MPI ABI which is
only specified for C.

mpif provides the MPI standard version 5.0.

## Status

mpif currently implements almost all Fortran bindings for the
`mpif.h`, `use mpi`, and `use mpi_f08` parts. Notable exceptions are
callbacks (e.g. user-defined operators) which are not yet supported.
Adding this support is planned.

## Directory structure

- `bin`: scripts (`mpifort`)
- `data`: the machine-readable MPI standard
- `dev`: development scripts; the code generator lives here
- `gen`: generated code
- `include`: include files
- `src`: source files
- `test`: tests

The tests are an indepdendent cmake project. They require the mpif
package to be properly installed. This allows testing not just the
mpif implementation but also whether its installation procedure is
working. Given that autotools and cmake use an outdated and awkward
method to find MPI (instead of, say, just using pkgconfig), this
installation procedure needs testing as well.
