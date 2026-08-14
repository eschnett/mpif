# mpif: MPI Fortran bindings

[![CI](https://github.com/eschnett/mpif/actions/workflows/ci.yaml/badge.svg)](https://github.com/eschnett/mpif/actions/workflows/ci.yaml)

This package provides [Fortran](https://en.wikipedia.org/wiki/Fortran)
bindings for [MPI](https://www.mpi-forum.org), given any C
implementation of MPI. A major use case is the new MPI ABI which is
only specified for C.

mpif provides the MPI standard version 5.0.

## Status

mpif implements the Fortran bindings for `mpif.h`, `use mpi` and `use
mpi_f08`. There currently are no known deficiencies or missing
features.

The new MPI ABI makes it possible to choose the MPI library
implementation at run time, without recompiling any code. While this
is extremely convenient, it also makes it easier to accidentally
mis-match the MPI implementation (`libmpi_abi.so`) and its associated
launcher (`mpiexec`). mpif provides an executable `mpif_info` that can
be launched via `mpiexec` to output the configuration that is visible
at run time, checking e.g. the number of processes or the way
processes are laid out over the compute nodes. mpif also provides two
runtime consistency checking functions, `mpif_check_version` and
`mpif_check_environment` that can be called from an application. The
section "Runtime consistency checks" in `CODE.md` has details.

## Running with a different MPI library

mpif is built against the C MPI ABI, so one mpif build works with any
MPI implementation that provides this ABI. mpif installs a library
`libmpif`, and needs to be linked against an `mpi_abi` which is
provided by every MPI implementation that provides the MPI ABI. Which
MPI implementation is actually loaded at run time is decided by the
dynamic loader:

- By default, the MPI that mpif was built against (the wrapper stores
  an rpath to it; `mpifort -showme:mpiprefix` prints which one that
  is).
- At run time, you can put another implementation first on the
  loader's search path, and the same binary runs unchanged:

      LD_LIBRARY_PATH=<other-prefix>/lib <other-prefix>/bin/mpiexec -n 2 ./app

  (`DYLD_LIBRARY_PATH` on macOS.)
- At link time, you can choose a different default with
  `MPIF_MPI_PREFIX=<other-prefix> mpifort ...`. (That assumes the
  other MPI's libraries sit in the same place under its prefix as the
  build-time MPI's do; `MPIF_MPI_LIBDIR=<other-libdir>` names the
  directory outright when they do not.)

The installed `mpif_info` binary verifies the setup. It prints the pathname of
the `libmpi_abi` file the loader actually resolved, the implementation's own
version string, and then runs mpif's runtime consistency checks, which abort
if the launcher and the loaded library do not belong together:

    DYLD_LIBRARY_PATH=<other-prefix>/lib <other-prefix>/bin/mpiexec -n 2 mpif_info

It is *not* possible to mix different Fortran compilers, because they
are not compatible. The installation records which compiler was used,
and the cmake function `find_package(mpif)` warns when the consuming
project uses another one, or another major version of the same one.
(Set `MPIF_SKIP_COMPILER_CHECK` to silence it.)

## Compilers

gfortran and LLVM flang are the two mpif is built and tested with, on Linux,
macOS and FreeBSD; those are what the CI matrix runs end to end.

**gfortran 8 is the floor.** Nothing here is declared `bind(C)`: the generated
entry points rely on the compiler lowercasing names, appending one underscore,
and passing hidden character lengths as `size_t`, which gfortran did as `int`
before 8. Earlier versions compile mpif without complaint and are wrong at run
time, so the floor cannot be checked by compiling.

Other compilers -- Intel `ifx`, NVIDIA `nvfortran` (which is also what became
of PGI), AMD `amdflang` -- are compiled and not run, by CI's `compile` job. It
says whether mpif's configure stage reads a compiler correctly and whether the
code builds; it says nothing about behaviour. Cray CCE is not tested at all,
being unobtainable outside HPE Cray systems.

## MPI implementations

Both [MPICH](https://www.mpich.org) and [Open
MPI](https://www.open-mpi.org) implement the MPI ABI. Their
implementation is rather new, and mpif builds and tests off their main
branches.

## Documentation

Four working notes:

- `CODE.md`: what the code is made of, how the pieces fit, and why the
  arrangements that look odd are the ones they are.
- `MISSING.md`: what mpif gets wrong, does not do, or cannot do because
  something outside it is broken -- plus the decisions not to do something.
- `CLAUDE.md`: how to build, test and verify it, and the traps that have cost
  the most time. Written for an AI agent working in the repository, and useful
  to anyone else for the same reason.
- `HISTORY.md`: condensed record of past failures and withdrawn diagnoses;
  the other three describe the current state only.

## Directory structure

- `bin`: scripts (`mpifort`); the `mpif_info` diagnostic is built from
  `src/mpif_info.f90` and installed here too
- `data`: the machine-readable MPI standard
- `dev`: development scripts; the code generator lives here
- `gen`: generated code
- `include`: include files
- `src`: source files
- `test`: tests

The tests are an independent cmake project. They require the mpif
package to be properly installed. This allows testing not just the
mpif implementation but also whether its installation procedure is
working. Given that autotools and cmake use an outdated and awkward
method to find MPI (instead of, say, just using pkgconfig), this
installation procedure needs testing as well.
