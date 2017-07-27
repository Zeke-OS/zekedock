FROM ubuntu:18.04

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y --allow-unauthenticated \
        bsdmainutils git wget vim screen sudo telnet \
        build-essential libexpat1 libexpat1-dev python3.6-dev \
        binutils-arm-none-eabi libncurses5-dev \
        mtools dosfstools \
        libtool pkg-config zlib1g-dev zlib1g libglib2.0-dev \
        libfdt-dev libpixman-1-dev texinfo && \
    apt-get install -y --allow-unauthenticated llvm-8 clang-8 && \
    rm -rf /var/lib/apt/lists/*

ENV HOME /root
WORKDIR /root

# Compile and install QEMU
#COPY scripts/install_qemu.sh /root/scripts/install_qemu.sh
#RUN cd /root && \
#    #git clone 'https://github.com/Zeke-OS/qemu.git' && \
#    #cd qemu && git checkout 'zeke' && \
#    git clone 'https://github.com/qemu/qemu' && \
#    cd qemu && git checkout 'v4.1.0' && \
#    cp /root/scripts/install_qemu.sh /root/qemu/ && \
#    cd /root/qemu && ./install_qemu.sh && \
#    rm -rf /root/qemu

# Compile and install GDB
COPY scripts/install_gdb.sh /root/scripts/install_gdb.sh
RUN cd /root && wget http://ftp.gnu.org/gnu/gdb/gdb-7.10.tar.xz && \
    tar xvf gdb-7.10.tar.xz && rm gdb-7.10.tar.xz && \
    cp /root/scripts/install_gdb.sh /root/gdb-7.10/ && \
    cd /root/gdb-7.10 && ./install_gdb.sh && \
    rm -rf /root/gdb-7.10

ADD root /root

CMD ["bash"]
