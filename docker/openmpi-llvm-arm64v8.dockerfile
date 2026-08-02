# env DOCKER_BUILDKIT=1 docker build --file docker/openmpi-llvm-arm64v8.dockerfile --platform linux/arm64 --progress plain --tag openmpi-mpiabi-llvm-arm64v8 .

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
        # curl and perl are for MPICH's test suite at the end: it is downloaded
        # as a tarball, and `runtests` is a Perl script that uses more than
        # perl-base ships. clang++ already covers libtool's C++ tag
        curl
        flang-21
        flex
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

ENV CC=clang-21
ENV CXX=clang++-21
ENV FC=flang-21



################################################################################
# Install OpenMPI

# The build recipe is shared with CI and with the local build scripts; see
# ci-scripts/install-openmpi.sh. It builds OpenMPI with the MPI standard ABI, adds
# mpif's Fortran/C handle conversion functions, removes everything that is not
# part of the standard ABI, and installs the official ABI `mpi.h`.

WORKDIR /cactus/mpif
COPY fortran ./fortran
COPY ci-scripts ./ci-scripts

ENV mpi_prefix=/openmpi-mpiabi-llvm
RUN ci-scripts/install-openmpi.sh ${mpi_prefix}



################################################################################
# mpif

COPY --parents bin cmake CMakeLists.txt gen include src .

# Configure
ENV mpif_prefix=/cactus/mpif-openmpi-llvm
RUN <<EOF
    flags=(
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_BUILD_TYPE=Debug
        -DCMAKE_INSTALL_PREFIX=${mpif_prefix}
        -DMPI_HOME=${mpi_prefix}
    )
    cmake -Bbuild-openmpi-llvm "${flags[@]}"
EOF

# Build
RUN cmake --build build-openmpi-llvm

# Install
RUN cmake --install build-openmpi-llvm

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
    cmake -Bbuild-openmpi-llvm-tests "${test_flags[@]}"
EOF

# Build tests
RUN cmake --build build-openmpi-llvm-tests

# Run tests
RUN ctest --test-dir build-openmpi-llvm-tests --output-on-failure



################################################################################
# MPICH's Fortran test suite

# MPICH ships around 300 Fortran tests covering all three interfaces mpif
# implements, and turns all of them off when its own build targets the standard
# ABI, because the ABI has no Fortran bindings -- which is precisely the gap
# mpif fills. Far broader coverage than test/; see ci-scripts/test-mpich-suite.sh
# for the details. The suite is downloaded, built and run under a temporary
# directory that the script removes afterwards, so none of it stays in the image.
#
# The failures that are expected are listed in ci-scripts/mpich-suite-xfail.txt
# with a reason apiece, and this fails on a difference from that list rather
# than on a failure. A variant with no `triaged` line there is reported and
# cannot fail the build.

WORKDIR /cactus/mpif
RUN <<EOF
    set -e
    # The tests themselves find mpif and MPI through the rpath the wrapper
    # compilers add; mpiexec and the launcher's own helpers do not
    export LD_LIBRARY_PATH=${mpi_prefix}/lib:${mpif_prefix}/lib
    # Open MPI refuses to oversubscribe by default, and refuses to run as root
    # at all -- and a docker build is root, on however many cores the daemon
    # happens to give it
    export MPIEXEC_ARGS="--oversubscribe --allow-run-as-root"
    ci-scripts/test-mpich-suite.sh ${mpi_prefix} ${mpif_prefix}
EOF
