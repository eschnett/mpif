# env DOCKER_BUILDKIT=1 docker build --file docker/mpich-gcc-arm32v7.dockerfile --platform linux/arm/v7 --progress plain --tag mpich-mpiabi-gcc-arm32v7 .

# FROM arm32v7/ubuntu:noble-20260410
FROM arm32v7/ubuntu:resolute-20260627

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
        gfortran
        curl
        git
        language-pack-en
        libhwloc-dev
        libtool
        locales
        make
        patch
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
COPY ci-scripts ./ci-scripts

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
