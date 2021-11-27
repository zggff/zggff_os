FROM ubuntu:latest

# Set APT_GET_UPDATE to make consistent images
# ENV APT_GET_UPDATE 2016-03-01
ENV code /src
ENV toolchain /toolchain

RUN apt-get --quiet --yes update \
    && apt-get --quiet --yes install \
        build-essential \
        wget     \
        binutils
         
# && apt-get clean \
# && rm -rf /var/lib/apt/lists

RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz \
    && tar xvJf binutils-2.37.tar.xz \
    && cd binutils-2.37 \
    && ./configure --prefix=${toolchain} --target=i686-elf --disable-nls --disable-werror --with-sysroot\
    && make \
    && make install \
    && cd .. \
    && rm -rf binutils-2.37 \
    && rm binutils-2.37.tar.xz

RUN wget https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz \
    && tar xvJf gcc-11.2.0.tar.xz \
    && cd gcc-11.2.0 \
    && ./contrib/download_prerequisites \
    && cd .. \
    && mkdir build-gcc \
    && cd build-gcc \
    && ../gcc-11.2.0/configure --prefix=${toolchain} --target=i686-elf --disable-nls --enable-languages=c,c++ --without-headers --disable-werror\
    && make all-gcc\
    && make all-target-libgcc\
    && make install-gcc\
    && make install-target-libgcc \
    && cd .. \
    && rm -rf build-gcc \
    && rm -rf gcc-11.2.0 \
    && rm gcc-11.2.0.tar.xz

# RUN DEBIAN_FRONTEND=noninteractive apt-get --quiet --yes remove \
#     g++ \
#     wget \
#     libmpc-dev

# COPY . ${code}
ENV PATH="${toolchain}/bin:${PATH}"
WORKDIR ${code}
# ENTRYPOINT ["/bin/bash"]