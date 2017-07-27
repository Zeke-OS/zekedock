FROM ubuntu:16.04

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --allow-unauthenticated \
        build-essential libexpat1 libexpat1-dev python3.5-dev \
        binutils-arm-none-eabi libncurses5-dev \
        git wget vim screen sudo telnet \
        mtools dosfstools \
        libtool pkg-config zlib1g-dev zlib1g libglib2.0-dev \
        libfdt-dev libpixman-1-dev texinfo && \
    apt-get install -y --allow-unauthenticated -t llvm-toolchain-xenial llvm-5.0 clang-5.0

ENV HOME /root
WORKDIR /root

# Compile and install QEMU
COPY scripts/install_qemu.sh /root/scripts/install_qemu.sh
#RUN cd /root && \
#    git clone 'https://github.com/Torlus/qemu.git' && \
#    cd qemu && git checkout 'bf4eb7c8e705e997233415926fae83d31240e3b1' && \
#    git clone 'https://github.com/qemu/qemu' && \
#    cd qemu && git checkout 'v2.9.0' && \
#    cp /root/scripts/install_qemu.sh /root/qemu/ && \
#    cd /root/qemu && ./install_qemu.sh && \
#    rm -rf /root/qemu

# Compile and install GDB
#COPY scripts/install_gdb.sh /root/scripts/install_gdb.sh
#RUN cd /root && wget http://ftp.gnu.org/gnu/gdb/gdb-7.10.tar.xz && \
#    tar xvf gdb-7.10.tar.xz && rm gdb-7.10.tar.xz && \
#    cp /root/scripts/install_gdb.sh /root/gdb-7.10/ && \
#    cd /root/gdb-7.10 && ./install_gdb.sh && \
#    rm -rf /root/gdb-7.10
#
RUN rm -rf /var/lib/apt/lists/*

ADD root /root

CMD ["bash"]
