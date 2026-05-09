# TODO


* [isdn4k-utils](ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/isdn4k-utils.v3.2p1.tar.bz2)
* [isdn4k-utils](https://www.isdn4linux.de): `ftp -o ./assets/isdn4k-utils.tar.bz2 ftp://ftp.isdn4linux.de/pub/isdn4linux/utils/isdn4k-utils.v3.2p1.tar.bz2`

---

# NOTES TO REMOVE

```
make \
O=$OUT \
ARCH=arm64 \
SUBARCH=arm64 \
LLVM=1 \
PATH=$PATH \
LD_LIBRARY_PATH=/home/build/src/clang/lib:/home/build/src/gcc/aarch64/lib:/home/build/src/gcc/arm/lib \
CROSS_COMPILE=aarch64-linux-android- \
CROSS_COMPILE_ARM32=arm-linux-androideabi- \
CLANG_TRIPLE=aarch64-linux-gnu- \
-j$(nproc)

apt --assume-yes install --no-install-recommends \
bc \
binutils \
build-essential \
btrfs-progs \
e2fsprogs \
gcc \
grub2-common \
iptables \
jfsutils \
kmod \
make \
nfs-common \
openssl \
pcmciautils \
ppp \
procps \
python3-sphinx \
quota \
reiserfsprogs \
squashfs-tools \
udev \
util-linux \
xfsprogs

# isdn4k-utils \
# mcelog \
# oprofile \



android-sdk \
bc \
bison \
build-essential \
ccache \
curl \
flex \
g++-multilib \
gcc-multilib \
git \
git-lfs \
gnupg \
gperf \
imagemagick \
protobuf-compiler \
python3-protobuf \
lib32readline-dev \
lib32z1-dev \
libdw-dev \
libelf-dev \
libgnutls28-dev \
lz4 \
libsdl1.2-dev \
libssl-dev \
libxml2 \
libxml2-utils \
lzop \
pngcrush \
rsync \
schedtool \
squashfs-tools \
xsltproc \
xxd \
zip \
zlib1g-dev
```

---

```
sed -i 's/-maxdepth 1/-maxdepth 2/g' ./scripts/lxdialog/Makefile
sed -i 's|#! /bin/sh|#!/bin/bash|g' ./scripts/Menuconfig

export CFLAGS="-Wno-error=implicit-int"
export VBOX_TCL="tcl8.6"
sed -i 's/tcl8.3/tcl8.6/g' ./vbox/configure
```
