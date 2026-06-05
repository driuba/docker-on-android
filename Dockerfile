# syntax=docker/dockerfile:1

FROM debian:trixie AS base

ENV USE_CCACHE="1"

RUN dpkg --add-architecture i386

RUN --mount=type=bind,from=configs,source=debian.sources,target=/etc/apt/sources.list.d/debian.sources \
	--mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt,sharing=locked \
	apt update

RUN --mount=type=bind,from=configs,source=debian.sources,target=/etc/apt/sources.list.d/debian.sources \
	--mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt,sharing=locked \
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

RUN --mount=type=bind,from=configs,source=debian.sources,target=/etc/apt/sources.list.d/debian.sources \
	--mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt,sharing=locked \
	apt --assume-yes upgrade

RUN git lfs install --system

RUN useradd --create-home --groups sudo --shell /bin/bash --uid 1000 --user-group build
RUN sed --expression 's/^%sudo\tALL=(ALL:ALL) ALL$/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/g' --in-place /etc/sudoers

FROM base AS dependencies

ADD --link --unpack=true https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz /tmp/

WORKDIR /tmp/Python-2.7.18

RUN ./configure --enable-optimizations CFLAGS="-std=c11"
RUN make
RUN make install

WORKDIR /

RUN rm -fr /tmp/Python-2.7.18

FROM dependencies AS source

ARG NAME="Andrius Andrikonis"
ARG EMAIL="andrikonis.andrius@gmail.com"

USER build

RUN git config --global user.email "$EMAIL"
RUN git config --global user.name "$NAME"

WORKDIR /home/build/src

COPY --chown=build:build --link ./build/ ./build/
COPY --chown=build:build --link ./device/ ./
COPY --chown=build:build --link ./kernel/ ./workdir/downloads/kernel-xiaomi-davinci/

VOLUME /home/build/out
VOLUME /home/build/src/workdir
