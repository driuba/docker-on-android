# syntax=docker/dockerfile:1

FROM debian:trixie AS base

RUN useradd --create-home --shell /bin/bash --uid 1000 --user-group build

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
		repo \
		rsync \
		schedtool \
		squashfs-tools \
		xsltproc \
		xxd \
		zip \
		zlib1g-dev

RUN --mount=type=bind,from=configs,source=debian.sources,target=/etc/apt/sources.list.d/debian.sources \
	--mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt,sharing=locked \
	apt --assume-yes upgrade

RUN git lfs install --system

FROM base AS source

ARG NAME="Andrius Andrikonis"
ARG EMAIL="andrikonis.andrius@gmail.com"

ENV OUT="/home/build/out"
ENV USE_CCACHE="1"

USER build:build

WORKDIR /home/build

RUN git config --global user.email "$EMAIL"
RUN git config --global user.name "$NAME"

RUN mkdir ./src

RUN chown --recursive build:build ./src

WORKDIR /home/build/src

RUN repo init --git-lfs --manifest-branch lineage-23.2 --no-clone-bundle https://github.com/LineageOS/android.git

VOLUME /home/build/src/out
VOLUME /home/build/src
