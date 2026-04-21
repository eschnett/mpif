# env DOCKER_BUILDKIT=1 docker build --file docker/mpich-llvm.dockerfile --platform linux/arm64 --progress plain --tag mpich-mpiabi-llvm .

FROM arm64v8/ubuntu:noble-20260324
# FROM arm64v8/ubuntu:resolute-20260404

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

ENV CC=clang-21
ENV CXX=clang++-21
ENV FC=flang-new-21



################################################################################
# Install MPICH

# Download MPICH
ADD https://www.mpich.org/static/downloads/5.0.1/mpich-5.0.1.tar.gz /cactus/mpich-5.0.1.tar.gz
RUN tar xzf mpich-5.0.1.tar.gz
WORKDIR /cactus/mpich-5.0.1

ADD https://github.com/pmodels/mpich/commit/689a0869c8f58167e3b0b5db13f8ce8db5f24009.patch 689a0869c8f58167e3b0b5db13f8ce8db5f24009.patch
RUN patch -p1 <689a0869c8f58167e3b0b5db13f8ce8db5f24009.patch

# Add Fortran bindings
ADD fortran/fortran_binding_abi.c src/binding/abi/fortran_binding_abi.c
RUN perl -pi -e 's!src/binding/abi/c_binding_abi.c!src/binding/abi/c_binding_abi.c src/binding/abi/fortran_binding_abi.c!' src/binding/abi/Makefile.mk
RUN ./autogen.sh

# Configure
ENV mpi_prefix=/mpich-mpiabi-llvm
RUN <<EOF
    set -e
    configure_flags=(
        --disable-dependency-tracking
        --disable-doc
        --enable-cxx=no
        --enable-fortran
        --enable-mpi-abi
        --enable-static=no
        --prefix=${mpi_prefix}
        --with-device=ch3
        --with-hwloc
    )
    ./configure "${configure_flags[@]}"
EOF

# Disable MPI_File_{c2f,f2c} that shouldn't be there
ADD fortran/mpich-disable-file.patch /cactus/mpich-disable-file.patch
RUN patch -p1 </cactus/mpich-disable-file.patch

# Build
RUN make -j$(nproc)

# Install
RUN make install

# Fixup
RUN <<EOF
    rm ${mpi_prefix}/bin/mpicc_abi
    rm ${mpi_prefix}/bin/mpichversion       # needs libmpi.so
    rm ${mpi_prefix}/bin/mpicxx_abi
    rm ${mpi_prefix}/bin/mpif77
    rm ${mpi_prefix}/bin/mpif90
    rm ${mpi_prefix}/bin/mpifort
    rm ${mpi_prefix}/bin/mpivars            # needs libmpi.so
    sed -i -e 's/mpi_abi=no/mpi_abi=yes/' ${mpi_prefix}/bin/mpicc
    sed -i -e 's/mpi_abi=no/mpi_abi=yes/' ${mpi_prefix}/bin/mpicxx
    
    rm ${mpi_prefix}/include/mpi.h
    rm ${mpi_prefix}/include/mpi.mod
    rm ${mpi_prefix}/include/mpi_abi.h
    rm ${mpi_prefix}/include/mpi_base.mod
    rm ${mpi_prefix}/include/mpi_c_interface.mod
    rm ${mpi_prefix}/include/mpi_c_interface_cdesc.mod
    rm ${mpi_prefix}/include/mpi_c_interface_glue.mod
    rm ${mpi_prefix}/include/mpi_c_interface_nobuf.mod
    rm ${mpi_prefix}/include/mpi_c_interface_types.mod
    rm ${mpi_prefix}/include/mpi_constants.mod
    rm ${mpi_prefix}/include/mpi_f08.mod
    rm ${mpi_prefix}/include/mpi_f08_callbacks.mod
    rm ${mpi_prefix}/include/mpi_f08_compile_constants.mod
    rm ${mpi_prefix}/include/mpi_f08_link_constants.mod
    rm ${mpi_prefix}/include/mpi_f08_types.mod
    rm ${mpi_prefix}/include/mpi_proto.h
    rm ${mpi_prefix}/include/mpi_sizeofs.mod
    rm ${mpi_prefix}/include/mpif.h
    rm ${mpi_prefix}/include/pmpi_base.mod
    rm ${mpi_prefix}/include/pmpi_f08.mod
    
    rm ${mpi_prefix}/lib/libfmpich.*
    rm ${mpi_prefix}/lib/libmpi.*
    rm ${mpi_prefix}/lib/libmpich.*
    rm ${mpi_prefix}/lib/libmpichcxx.*
    rm ${mpi_prefix}/lib/libmpichf90.*
    rm ${mpi_prefix}/lib/libmpifort.*
    rm ${mpi_prefix}/lib/libmpl.*
    rm ${mpi_prefix}/lib/libopa.*
    rm ${mpi_prefix}/lib/libpmpi.*
    rm ${mpi_prefix}/lib/pkgconfig/mpich.pc
EOF

# Install official mpi.h header file
ADD https://raw.githubusercontent.com/mpi-forum/mpi-abi-stubs/refs/heads/main/mpi.h ${mpi_prefix}/include/mpi.h
ADD fortran/mpi.h.patch mpi.h.patch
RUN (cd ${mpi_prefix}/include && patch -p1 </cactus/mpich-5.0.1/mpi.h.patch)



################################################################################
# mpif

WORKDIR /cactus
RUN : d40209744cb0452c79ef11b847dc1282cdd07221
RUN git clone https://github.com/eschnett/mpif
WORKDIR /cactus/mpif
ADD test/type_create_struct_f08.f90 test/type_create_struct_f08.f90

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
    cmake -Bbuild-mpich-llvm-tests "${test_flags[@]}"
EOF

# Build tests
RUN cmake --build build-mpich-llvm-tests

# Run tests
RUN ctest --test-dir build-mpich-llvm-tests
