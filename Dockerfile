FROM ubuntu:14.04

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential libexpat1 libexpat1-dev python3.4-dev && \
  apt-get install -y software-properties-common && \
  apt-get install -y git man vim wget screen && \
  add-apt-repository "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty main" && \
  apt-get update && \
  apt-get install -y llvm-3.4 clang-3.4 binutils-arm-none-eabi libncurses5-dev  && \
  apt-get install -y mtools dosfstools

ADD root /root
ENV HOME /root
WORKDIR /root

# Compile and install QEMU
RUN apt-get install -y libtool pkg-config zlib1g-dev zlib1g libglib2.0-dev libfdt-dev libpixman-1-dev
RUN cd /root && git clone https://github.com/Torlus/qemu.git && cd qemu && git checkout rpi
COPY scripts/install_qemu.sh /root/qemu/
RUN cd /root/qemu && ./install_qemu.sh
RUN rm -rf /root/qemu

# Compile and install GDB
RUN apt-get install -y texinfo
RUN cd /root && wget http://ftp.gnu.org/gnu/gdb/gdb-7.10.tar.xz && tar xvf gdb-7.10.tar.xz && rm gdb-7.10.tar.xz
COPY scripts/install_gdb.sh /root/gdb-7.10/
RUN cd /root/gdb-7.10 && ./install_gdb.sh
RUN rm -rf /root/gdb-7.10

RUN sudo rm -rf /var/lib/apt/lists/*

CMD ["bash"]
