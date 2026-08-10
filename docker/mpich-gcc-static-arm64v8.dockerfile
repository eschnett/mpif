# env DOCKER_BUILDKIT=1 docker build --file docker/mpich-gcc-static-arm64v8.dockerfile --platform linux/arm64 --progress plain --tag mpich-mpiabi-gcc-static-arm64v8 .

# docker/mpich-gcc-arm64v8.dockerfile with mpif built as an archive instead of a
# shared library. Kept as close to it as possible, so that a difference between
# the two images is a difference static linking made.
#
# Two things it adds over CI's `static` job, which is x86_64.
#
# aarch64 with GNU ld: the sentinel cells' size and alignment are chosen against
# the Fortran COMMON blocks merged onto them, both quantities are target-dependent
# (`__BIGGEST_ALIGNMENT__` is 16 here, up to 64 on x86-64), and GNU ld is the only
# linker that reports a mismatch in either. See "Static linking" in CODE.md.
#
# And the MPICH suite against an archive, which nothing else runs. Its f77, f90
# and f08 `profile` directories each replace `mpi_send` and `mpi_recv` with the
# test's own, so all three depend on the separable members MPIF_SPLIT_WRAPPERS
# gives every MPI_ entry point -- the thing MPI-5.0 section 15.2.1 asks for, and
# the thing an archive did not have until each entry point got a member of its
# own. This variant is `triaged` in ci-scripts/suite/mpich-suite-xfail.txt, so the
# stage gates on a difference from that list rather than merely reporting one.

# FROM arm64v8/ubuntu:noble-20260410
FROM arm64v8/ubuntu:resolute-20260627

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV LANGUAGE=en_US.en
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN mkdir /cactus
WORKDIR /cactus

# Install system packages
RUN <<EOF
    set -e
    apt-get update
    packages=(
        ca-certificates
        cmake
        # g++ and perl are for MPICH's test suite at the end: its configure runs
        # libtool's C++ checks even with --disable-cxx, and `runtests` is a Perl
        # script that uses more than perl-base ships. curl below already fetches
        # the suite's tarball
        g++
        gfortran
        curl
        git
        language-pack-en
        libhwloc-dev
        libtool
        locales
        make
        patch
        perl
        python3
    )
    apt-get --yes --no-install-recommends install "${packages[@]}"
EOF



################################################################################
# Install MPICH

# The build recipe is shared with CI and with the local build scripts; see
# ci-scripts/install-mpich.sh. It builds MPICH with the MPI standard ABI, adds
# mpif's Fortran/C handle conversion functions, removes everything that is not
# part of the standard ABI, and installs the official ABI `mpi.h`.

WORKDIR /cactus/mpif
COPY fortran ./fortran
# Only what this build recipe reads: the install scripts, the prune lists and the
# patches. The MPICH suite's three files live in ci-scripts/suite and arrive at the
# end, so that editing the expected-failures list does not rebuild the MPI. See
# ci-scripts/README.md.
COPY ci-scripts/*.sh ci-scripts/*.txt ci-scripts/*.patch ./ci-scripts/

ENV mpi_prefix=/mpich-mpiabi-gcc
RUN ci-scripts/install-mpich.sh ${mpi_prefix}



################################################################################
# mpif

COPY --parents bin cmake CMakeLists.txt gen include src .

# Configure
ENV mpif_prefix=/cactus/mpif-mpich-gcc-static
RUN <<EOF
    flags=(
        -DBUILD_SHARED_LIBS=OFF
        -DCMAKE_BUILD_TYPE=Debug
        -DCMAKE_INSTALL_PREFIX=${mpif_prefix}
        -DMPI_HOME=${mpi_prefix}
    )
    cmake -Bbuild-mpich-gcc-static "${flags[@]}"
EOF

# Build
RUN cmake --build build-mpich-gcc-static

# Install
RUN cmake --install build-mpich-gcc-static

# Two silent failures, neither of which any test can see: a prefix that also
# holds a shared library, which every test below would link instead of the
# archive; and a sentinel cell that never came out of the archive, which leaves
# the program working while the read-only fault and the poison behind every
# sentinel translation quietly go away. See ci-scripts/check-static-build.sh.
RUN ci-scripts/check-static-build.sh ${mpif_prefix}

RUN mkdir test
WORKDIR /cactus/mpif/test
COPY test/CMakeLists.txt test/*.c test/*.f test/*.f90 test/*.F90 .

# Configure tests
RUN <<EOF
    test_flags=(
        -DCMAKE_BUILD_TYPE=Debug
        -DMPI_C_COMPILER=${mpi_prefix}/bin/mpicc
        -DMPI_Fortran_COMPILER=${mpif_prefix}/bin/mpifort
        -DMPI_C_HEADER_DIR=${mpi_prefix}/include
        -DMPI_C_LIB_NAMES=mpi_abi
        -DMPI_mpi_abi_LIBRARY=${mpi_prefix}/lib/libmpi_abi.so
        # The alltoallw tests need more than one rank. Pinned rather than
        # detected: test/CMakeLists.txt fails the configure without it.
        -DMPIEXEC_EXECUTABLE=${mpi_prefix}/bin/mpiexec
        -DMPIF_TEST_MPI_LIBRARY=MPICH
    )
    cmake -Bbuild-mpich-gcc-static-tests "${test_flags[@]}"
EOF

# Build tests
RUN cmake --build build-mpich-gcc-static-tests

# Run tests
RUN ctest --test-dir build-mpich-gcc-static-tests --output-on-failure



################################################################################
# MPICH's Fortran test suite

# MPICH ships around 300 Fortran tests covering all three interfaces mpif
# implements, and turns all of them off when its own build targets the standard
# ABI, because the ABI has no Fortran bindings -- which is precisely the gap
# mpif fills. Far broader coverage than test/; see ci-scripts/suite/test-mpich-suite.sh
# for the details. The suite is downloaded, built and run under a temporary
# directory that the script removes afterwards, so none of it stays in the image.
#
# The failures that are expected are listed in ci-scripts/suite/mpich-suite-xfail.txt
# with a reason apiece, and this fails on a difference from that list rather
# than on a failure. A variant with no `triaged` line there is reported and
# cannot fail the build.

WORKDIR /cactus/mpif
COPY --parents ci-scripts/suite .
RUN <<EOF
    set -e
    # The tests themselves find mpif and MPI through the rpath the wrapper
    # compilers add; mpiexec and the launcher's own helpers do not
    export LD_LIBRARY_PATH=${mpi_prefix}/lib:${mpif_prefix}/lib
    # MPICH's mpiexec needs no persuasion to run as root, and the suite asks
    # for at most MPIEXEC_MAXNP (4) processes
    ci-scripts/suite/test-mpich-suite.sh ${mpi_prefix} ${mpif_prefix}
EOF
