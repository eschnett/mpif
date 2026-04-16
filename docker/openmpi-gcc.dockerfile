# env DOCKER_BUILDKIT=1 docker build --file openmpi-gcc.dockerfile --platform linux/arm64 --progress plain --tag openmpi-mpiabi-gcc .

FROM arm64v8/ubuntu:noble-20260324

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
# Install OpenMPI

# Download OpenMPI
RUN git clone --depth 1 https://github.com/open-mpi/ompi.git
WORKDIR /cactus/ompi
RUN git fetch --depth 1 origin ed5193c3d101e5ef8f6fda19fa89e694c88ada18
RUN git checkout ed5193c3d101e5ef8f6fda19fa89e694c88ada18
RUN git submodule update --init --recursive

# Add Fortran bindings
ADD f2c_abi.c ompi/mpi/c/f2c_abi.c
RUN perl -pi -e 's!comm_fromint_abi.c!f2c_abi.c comm_fromint_abi.c!' ompi/mpi/c/Makefile_abi.include
ADD openmpi-disable-type.patch openmpi-disable-type.patch
RUN patch -p1 <openmpi-disable-type.patch
RUN ./autogen.pl

# Configure
ENV mpi_prefix=/openmpi-mpiabi-gcc
RUN apt-get --yes --no-install-recommends install flex
RUN <<EOF
    set -e
    configure_flags=(
        --enable-mpi-fortran=yes
        --enable-mpi1-compatibility=yes
        --enable-script-wrapper-compilers
        --enable-shared=yes
        --enable-standard-abi=yes
        --enable-static=no
        --prefix=${mpi_prefix}
        --with-hwloc
        --with-libevent=internal
    )
    ./configure "${configure_flags[@]}"
EOF

# Build
RUN make -j$(nproc)

# Install
RUN make install

# Fixup
RUN <<EOF
    sed -i -e 's/-lmpi/-lmpi_abi/' ${mpi_prefix}/bin/ompi_wrapper_script
    
    rm     ${mpi_prefix}/include/evdns.h
    rm     ${mpi_prefix}/include/event.h
    rm -rf ${mpi_prefix}/include/event2
    rm     ${mpi_prefix}/include/evhttp.h
    rm     ${mpi_prefix}/include/evrpc.h
    rm     ${mpi_prefix}/include/evutil.h
    rm     ${mpi_prefix}/include/mpi_portable_platform.h
    rm     ${mpi_prefix}/include/mpi-ext.h
    rm     ${mpi_prefix}/include/mpi.h
    rm     ${mpi_prefix}/include/mpif-c-constants-decl.h
    rm     ${mpi_prefix}/include/mpif-config.h
    rm     ${mpi_prefix}/include/mpif-constants.h
    rm     ${mpi_prefix}/include/mpif-ext.h
    rm     ${mpi_prefix}/include/mpif-externals.h
    rm     ${mpi_prefix}/include/mpif-handles.h
    rm     ${mpi_prefix}/include/mpif-io-constants.h
    rm     ${mpi_prefix}/include/mpif-io-handles.h
    rm     ${mpi_prefix}/include/mpif-sentinels.h
    rm     ${mpi_prefix}/include/mpif-sizeof.h
    rm     ${mpi_prefix}/include/mpif.h
    rm -rf ${mpi_prefix}/include/openmpi
    rm -rf ${mpi_prefix}/include/pmix
    rm     ${mpi_prefix}/include/pmix_common.h
    rm     ${mpi_prefix}/include/pmix_deprecated.h
    rm     ${mpi_prefix}/include/pmix_server.h
    rm     ${mpi_prefix}/include/pmix_tool.h
    rm     ${mpi_prefix}/include/pmix_version.h
    rm     ${mpi_prefix}/include/pmix.h
    rm -rf ${mpi_prefix}/include/prte
    rm     ${mpi_prefix}/include/prte_version.h
    rm     ${mpi_prefix}/include/prte.h
    rm -rf ${mpi_prefix}/include/standard_abi
    
    rm ${mpi_prefix}/lib/libmpi.*
    rm ${mpi_prefix}/lib/libmpi_mpifh.*
    rm ${mpi_prefix}/lib/libmpi_usempi_ignore_tkr.*
    rm ${mpi_prefix}/lib/libmpi_usempif08.*
    rm ${mpi_prefix}/lib/mpi.mod
    rm ${mpi_prefix}/lib/mpi_ext.mod
    rm ${mpi_prefix}/lib/mpi_f08.mod
    rm ${mpi_prefix}/lib/mpi_f08_callbacks.mod
    rm ${mpi_prefix}/lib/mpi_f08_ext.mod
    rm ${mpi_prefix}/lib/mpi_f08_interfaces.mod
    rm ${mpi_prefix}/lib/mpi_f08_interfaces_callbacks.mod
    rm ${mpi_prefix}/lib/mpi_f08_types.mod
    rm ${mpi_prefix}/lib/mpi_types.mod
    rm ${mpi_prefix}/lib/pkgconfig/libevent*.pc
    rm ${mpi_prefix}/lib/pkgconfig/ompi*pc
    rm ${mpi_prefix}/lib/pkgconfig/pmix*pc
    rm ${mpi_prefix}/lib/pmpi_f08_interfaces.mod
EOF

# Install official mpi.h header file
ADD https://raw.githubusercontent.com/mpi-forum/mpi-abi-stubs/refs/heads/main/mpi.h ${mpi_prefix}/include/mpi.h
ADD mpi.h.patch mpi.h.patch
RUN (cd ${mpi_prefix}/include && patch -p1 </cactus/ompi/mpi.h.patch)



################################################################################
# mpif

WORKDIR /cactus
RUN git clone https://github.com/eschnett/mpif
WORKDIR /cactus/mpif

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

WORKDIR /cactus/mpif/test

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
RUN ./build-openmpi-gcc-tests/version_f08
RUN ctest --test-dir build-openmpi-gcc-tests
