# syntax=docker/dockerfile:1

FROM debian:trixie AS base

ENV USE_CCACHE="1"

RUN useradd --create-home --shell /bin/bash --uid 1000 --user-group build

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
		tk-dev \
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

FROM base AS dependencies

ADD --link --unpack=true https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz /tmp/

WORKDIR /tmp/Python-2.7.18

RUN ./configure --enable-optimizations CFLAGS="-std=c11"
RUN make
RUN make install

WORKDIR /

RUN rm -fr /tmp/Python-2.7.18

FROM dependencies AS tooling

ARG NAME="Andrius Andrikonis"
ARG EMAIL="andrikonis.andrius@gmail.com"

USER build:build

WORKDIR /home/build

RUN git config --global user.email "$EMAIL"
RUN git config --global user.name "$NAME"

RUN mkdir --parents ./out ./src/workdir/downloads/kernel-xiaomi-davinci

WORKDIR /home/build/src

COPY --chown=build:build --link ./build/ ./build/

RUN --mount=type=bind,source=./device/deviceinfo,target=deviceinfo \
	./build/build.sh -c

FROM tooling AS source

COPY --chown=build:build --link ./device/ ./
COPY --chown=build:build --link ./kernel/ ./workdir/downloads/kernel-xiaomi-davinci/

VOLUME /home/build/out
