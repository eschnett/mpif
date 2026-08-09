# mpif: MPI Fortran bindings

[![CI](https://github.com/eschnett/mpif/actions/workflows/ci.yaml/badge.svg)](https://github.com/eschnett/mpif/actions/workflows/ci.yaml)

This package provides [Fortran](https://en.wikipedia.org/wiki/Fortran)
bindings for [MPI](https://www.mpi-forum.org), given any C
implementation of MPI. A major use case is the new MPI ABI which is
only specified for C.

mpif provides the MPI standard version 5.0.

## Status

mpif implements the Fortran bindings for `mpif.h`, `use mpi` and `use
mpi_f08`, each with the `PMPI_` forms the profiling interface requires.
Callbacks work -- user-defined reduction operators, error handlers,
generalized requests, attribute copy and delete functions, and the
datarep conversion functions -- through trampolines that give the C
library a C function and call the Fortran one behind it.

Beyond the standard's API, mpif provides two runtime consistency
checks of its own, `mpif_check_version` and `mpif_check_environment`.
The ABI moves the choice of MPI library -- and of mpif itself -- to
run time, where the build can no longer vouch that the launcher, the
library and the caller belong together; these two verify it at
startup, cheaply enough to call in every run, and abort with a
diagnostic when something disagrees. The installed `mpif_info` binary
is the same thing as a command: `mpiexec -n 4 mpif_info` prints what
that setup actually loaded -- versions, implementation, process and
node layout -- and then runs the checks. The section "Runtime
consistency checks" in `CODE.md` has the details.

One known defect remains, and MPICH's Fortran test suite reports it: an
attribute set from Fortran is not visible to C as a pointer, where
MPI-5.0 section 19.3.7 requires that it is. `mpi_f08`'s choice buffers
are assumed rank (`TYPE(*), DIMENSION(..)`) wherever the toolchain's
TS 29113 support passes a build-time probe, and `MPI_SUBARRAYS_SUPPORTED`
is `.TRUE.` there -- noncontiguous array sections are then valid buffers
in nonblocking calls; on toolchains without that support, and always in
`mpif.h` and the `mpi` module, the buffers stay `ignore_tkr` with
`.FALSE.`, the conforming option both other implementations offer for
those two. `MISSING.md` has both, with everything else outstanding and
the reasons.

## Running with a different MPI library

mpif is built against the C MPI ABI, so one mpif build works with any MPI
implementation that provides the ABI. The library `libmpifort_abi` names no
MPI library at all; an application links `-lmpi_abi` (through mpif's
`mpifort` wrapper) and records only the ABI library's conventional versioned
name, `libmpi_abi.so.1`, which every conforming implementation shares. Which
implementation actually loads is decided by the dynamic loader:

- By default, the MPI that mpif was built against (the wrapper bakes an
  rpath to it; `mpifort -showme:mpiprefix` prints which one that is).
- At run time, put another implementation first on the loader's search
  path -- the same binary runs unchanged:

      LD_LIBRARY_PATH=<other-prefix>/lib <other-prefix>/bin/mpiexec -n 2 ./app

  (`DYLD_LIBRARY_PATH` on macOS.)
- At link time, choose a different default with
  `MPIF_MPI_PREFIX=<other-prefix> mpifort ...`.

The installed `mpif_info` binary verifies a setup: it prints the pathname of
the `libmpi_abi` file the loader actually resolved, the implementation's own
version string, and then runs mpif's runtime consistency checks, which abort
if the launcher and the loaded library do not belong together:

    DYLD_LIBRARY_PATH=<other-prefix>/lib <other-prefix>/bin/mpiexec -n 2 mpif_info

The one thing that cannot be mixed is Fortran compilers: mpif's modules and
library serve applications built with the same Fortran compiler family that
built mpif (gcc and llvm Fortran are not ABI-compatible).

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

The tests are an indepdendent cmake project. They require the mpif
package to be properly installed. This allows testing not just the
mpif implementation but also whether its installation procedure is
working. Given that autotools and cmake use an outdated and awkward
method to find MPI (instead of, say, just using pkgconfig), this
installation procedure needs testing as well.
