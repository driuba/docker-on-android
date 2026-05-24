# syntax=docker/dockerfile:1

FROM debian:trixie AS base

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
		bc \
		bison \
		build-essential \
		bzr \
		ca-certificates \
		ccache \
		cpio \
		curl \
		flex \
		gcc-multilib \
		git \
		git-lfs \
		g++-multilib \
		gnupg \
		gperf \
		imagemagick \
		img2simg \
		jq \
		kmod \
		less \
		libc6-dev \
		libgl1-mesa-dev \
		libgl1-mesa-glx:i386 \
		liblz4-tool \
		libncurses5 \
		libncurses5-dev:i386 \
		libreadline6-dev:i386 \
		libssl-dev \
		libtinfo5 \
		libx11-dev:i386 \
		libxml2-utils \
		lzop \
		mingw-w64-i686-dev \
		python2 \
		python-markdown \
		repo \
		rsync \
		schedtool \
		sudo \
		tofrodos \
		unzip \
		wget \
		x11proto-core-dev \
		xsltproc \
		xz-utils \
		zip \
		zlib1g-dev:i386

RUN --mount=type=bind,from=configs,source=debian.sources,target=/etc/apt/sources.list.d/debian.sources \
	--mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt,sharing=locked \
	apt --assume-yes upgrade

RUN git lfs install --system

FROM base AS source

ARG NAME="Andrius Andrikonis"
ARG EMAIL="andrikonis.andrius@gmail.com"

ENV USE_CCACHE="1"

USER build:build

WORKDIR /home/build

RUN git config --global user.email "$EMAIL"
RUN git config --global user.name "$NAME"

RUN mkdir ./out ./src

RUN chown --recursive build:build ./out ./src

WORKDIR /home/build/src

RUN repo init --git-lfs --manifest-branch lineage-23.2 --no-clone-bundle https://github.com/LineageOS/android.git

VOLUME /home/build/out
VOLUME /home/build/src
