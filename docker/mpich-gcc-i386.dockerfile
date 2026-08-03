# env DOCKER_BUILDKIT=1 docker build --file docker/mpich-gcc-i386.dockerfile --platform linux/386 --progress plain --tag mpich-mpiabi-gcc-i386 .

# The 32-bit variant, and the cheap one: `linux/386` runs natively on an x86_64
# kernel, so this costs about what a 64-bit build costs and needs no qemu. The
# arm32v7 image is the other 32-bit ABI -- there a 64-bit type is eight-byte
# aligned where here it is four -- and it does need qemu, so it is the slow one.
#
# Debian rather than Ubuntu because Ubuntu dropped i386 as a full architecture
# after 18.04: `i386/ubuntu` has nothing newer than bionic, whose gfortran 7
# predates the hidden-character-length convention mpif assumes (see `bind(C)` in
# MISSING.md). Debian still ships i386 as a port, with a current gfortran and
# libhwloc.
FROM i386/debian:trixie-20260713-slim

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
# C.UTF-8 is built into glibc, so it needs neither `locales` nor a `locale-gen`
# the way the en_US.UTF-8 of the Ubuntu images does. Nothing here wants en_US in
# particular; what it wants is a UTF-8 locale that exists.
ENV LANGUAGE=C.UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

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
        libhwloc-dev
        # Pulls in autoconf and automake, which MPICH's autogen.sh needs
        libtool
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
ENV mpif_prefix=/cactus/mpif-mpich-gcc
RUN <<EOF
    flags=(
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_BUILD_TYPE=Debug
        -DCMAKE_INSTALL_PREFIX=${mpif_prefix}
        -DMPI_HOME=${mpi_prefix}
    )
    cmake -Bbuild-mpich-gcc "${flags[@]}"
EOF

# Build
RUN cmake --build build-mpich-gcc

# Install
RUN cmake --install build-mpich-gcc

RUN mkdir test
WORKDIR /cactus/mpif/test
COPY test/CMakeLists.txt test/*.c test/*.f test/*.f90 .

# Configure tests
RUN <<EOF
    test_flags=(
        -DMPI_C_COMPILER=${mpi_prefix}/bin/mpicc
        -DMPI_Fortran_COMPILER=${mpif_prefix}/bin/mpifort
        -DMPI_C_HEADER_DIR=${mpi_prefix}/include
        -DMPI_C_LIB_NAMES=mpi_abi
        -DMPI_mpi_abi_LIBRARY=${mpi_prefix}/lib/libmpi_abi.so
    )
    cmake -Bbuild-mpich-gcc-tests "${test_flags[@]}"
EOF

# Build tests
RUN cmake --build build-mpich-gcc-tests

# Run tests
RUN ctest --test-dir build-mpich-gcc-tests --output-on-failure



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
# cannot fail the build, which is what this variant is until someone measures it:
# the key is mpich/gcc/linux/13/i686, Debian's VERSION_ID being 13.

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
