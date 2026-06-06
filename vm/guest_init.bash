#!/usr/bin/env bash

set -e

mkdir --parents /mnt/source

echo "source /mnt/source virtiofs ro 0 2" >> /etc/fstab

mount --all

cp /mnt/source/configs/debian.sources /etc/apt/sources.list.d/
cp /mnt/source/configs/ccache.conf /etc/

useradd --create-home --groups "sudo" --shell "/bin/bash" --uid "1000" --user-group "build"
sed --expression "s/^%sudo\tALL=(ALL:ALL) ALL$/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/g" --in-place /etc/sudoers

passwd --delete root
passwd --delete build

dpkg --add-architecture i386

apt update

apt --assume-yes install --no-install-recommends \
	adb \
	android-sdk \
	bc \
	bison \
	build-essential \
	ccache \
	curl \
	fakeroot \
	fastboot \
	flex \
	gcc-multilib \
	git \
	git-lfs \
	g++-multilib \
	gnupg \
	gperf \
	imagemagick \
	less \
	lib32readline-dev \
	lib32z1-dev \
	libbz2-dev \
	libdw-dev \
	libelf-dev \
	libffi-dev \
	libgnutls28-dev \
	liblzma-dev \
	libncursesw5-dev \
	libreadline-dev \
	libsdl1.2-dev \
	libsqlite3-dev \
	libssl-dev \
	libxml2 \
	libxml2-utils \
	lz4 \
	lzop \
	pngcrush \
	protobuf-compiler \
	python3-protobuf \
	repo \
	rsync \
	schedtool \
	squashfs-tools \
	sudo \
	tk-dev \
	wget \
	xsltproc \
	xxd \
	xz-utils \
	zip \
	zlib1g-dev

apt --assume-yes upgrade

git lfs install --system

reboot
