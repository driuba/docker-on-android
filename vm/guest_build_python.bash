#!/usr/bin/env bash

set -e

sudo su root

tar --extract --file /mnt/source/assets/Python-2.7.18.tar.xz --directory /tmp/

cd /tmp/Python-2.7.18

./configure --enable-optimizations CFLAGS="-std=c11"
make
make install

cd

rm --force --recursive /tmp/Python-2.7.18
