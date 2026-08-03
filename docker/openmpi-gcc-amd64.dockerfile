# env DOCKER_BUILDKIT=1 docker build --file docker/openmpi-gcc-amd64.dockerfile --platform linux/amd64 --progress plain --tag openmpi-mpiabi-gcc-amd64 .

# FROM amd64/ubuntu:noble-20260410
FROM amd64/ubuntu:resolute-20260627

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
        # curl, g++ and perl are for MPICH's test suite at the end: it is
        # downloaded as a tarball, its configure runs libtool's C++ checks even
        # with --disable-cxx, and `runtests` is a Perl script that uses more
        # than perl-base ships
        curl
        g++
        gfortran
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
        # PMIx, which Open MPI bundles, warns on every launch when it cannot
        # find a compression library -- and `runtests` counts anything the
        # launcher says as test output, so without this every suite test fails
        # with "Unexpected output". ci-scripts/suite/mpiexec-filter.sh drops only
        # Open MPI's own unavoidable banner, deliberately, so the fix belongs
        # here. The CI runners have zlib already, which is why this shows up in
        # the images alone.
        zlib1g-dev
    )
    apt-get --yes --no-install-recommends install "${packages[@]}"
EOF



################################################################################
# Install OpenMPI

# The build recipe is shared with CI and with the local build scripts; see
# ci-scripts/install-openmpi.sh. It builds OpenMPI with the MPI standard ABI, adds
# mpif's Fortran/C handle conversion functions, removes everything that is not
# part of the standard ABI, and installs the official ABI `mpi.h`.

WORKDIR /cactus/mpif
COPY fortran ./fortran
# Only what this build recipe reads: the install scripts, the prune lists and the
# patches. The MPICH suite's three files live in ci-scripts/suite and arrive at the
# end, so that editing the expected-failures list does not rebuild the MPI. See
# ci-scripts/README.md.
COPY ci-scripts/*.sh ci-scripts/*.txt ci-scripts/*.patch ./ci-scripts/

ENV mpi_prefix=/openmpi-mpiabi-gcc
RUN ci-scripts/install-openmpi.sh ${mpi_prefix}



################################################################################
# mpif

COPY --parents bin cmake CMakeLists.txt gen include src .

# Configure
ENV mpif_prefix=/cactus/mpif-openmpi-gcc
RUN <<EOF
    flags=(
        -DBUILD_SHARED_LIBS=ON
        -DCMAKE_BUILD_TYPE=Debug
        -DCMAKE_INSTALL_PREFIX=${mpif_prefix}
        -DMPI_HOME=${mpi_prefix}
    )
    cmake -Bbuild-openmpi-gcc "${flags[@]}"
EOF

# Build
RUN cmake --build build-openmpi-gcc

# Install
RUN cmake --install build-openmpi-gcc

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
    cmake -Bbuild-openmpi-gcc-tests "${test_flags[@]}"
EOF

# Build tests
RUN cmake --build build-openmpi-gcc-tests

# Run tests
RUN ctest --test-dir build-openmpi-gcc-tests --output-on-failure



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
    # Open MPI refuses to oversubscribe by default, and refuses to run as root
    # at all -- and a docker build is root, on however many cores the daemon
    # happens to give it
    export MPIEXEC_ARGS="--oversubscribe --allow-run-as-root"
    ci-scripts/suite/test-mpich-suite.sh ${mpi_prefix} ${mpif_prefix}
EOF
