# env DOCKER_BUILDKIT=1 docker build --file docker/mpich-llvm-arm64v8.dockerfile --platform linux/arm64 --progress plain --tag mpich-mpiabi-llvm-arm64v8 .

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
ADD https://apt.llvm.org/llvm.sh /cactus/llvm.sh
RUN <<EOF
    set -e
    apt-get update
    apt-get --yes --no-install-recommends install gnupg lsb-release software-properties-common wget
    chmod +x llvm.sh
    ./llvm.sh 21
    apt-get update
    packages=(
        ca-certificates
        clang-21
        cmake
        flang-21
        curl
        git
        language-pack-en
        libhwloc-dev
        libtool
        locales
        make
        patch
        # perl is for MPICH's test suite at the end: `runtests` is a Perl script
        # that uses more than perl-base ships. curl above already fetches the
        # suite's tarball, and clang++ covers libtool's C++ tag
        perl
        python3
    )
    apt-get --yes --no-install-recommends install "${packages[@]}"
EOF

ENV CC=clang-21
ENV CXX=clang++-21
ENV FC=flang-21



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

ENV mpi_prefix=/mpich-mpiabi-llvm
RUN ci-scripts/install-mpich.sh ${mpi_prefix}



################################################################################
# mpif

COPY --parents bin cmake CMakeLists.txt gen include src .

# Configure
ENV mpif_prefix=/cactus/mpif-mpich-llvm
RUN <<EOF
    flags=(
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_BUILD_TYPE=Debug
        -DCMAKE_INSTALL_PREFIX=${mpif_prefix}
        -DMPI_HOME=${mpi_prefix}
    )
    cmake -Bbuild-mpich-llvm "${flags[@]}"
EOF

# Build
RUN cmake --build build-mpich-llvm

# Install
RUN cmake --install build-mpich-llvm

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
    cmake -Bbuild-mpich-llvm-tests "${test_flags[@]}"
EOF

# Build tests
RUN cmake --build build-mpich-llvm-tests

# Run tests
RUN ctest --test-dir build-mpich-llvm-tests --output-on-failure



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
