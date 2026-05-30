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
		android-sdk-libsparse-utils \
		bc \
		bison \
		build-essential \
		bzr \
		ca-certificates \
		ccache \
		cpio \
		curl \
		flex \
		g++-multilib \
		gcc-multilib \
		git \
		git-lfs \
		gnupg \
		gperf \
		imagemagick \
		jq \
		kmod \
		less \
		libc6-dev \
		libgl1-mesa-dev \
		libgl1:i386 \
		libncurses-dev:i386 \
		libncurses6 \
		libreadline6-dev:i386 \
		libssl-dev \
		libtinfo6 \
		libx11-dev:i386 \
		libxml2-utils \
		lz4 \
		lzop \
		mingw-w64-i686-dev \
		python-markdown-doc \
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

COPY --chown=build:build --link ./ ./src/

WORKDIR /home/build/src/device

RUN ../build/build.sh -c

VOLUME /home/build/out
VOLUME /home/build/src
