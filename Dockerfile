# syntax=docker/dockerfile:1

FROM debian:trixie AS base

RUN useradd --create-home --shell /bin/bash --uid 1000 --user-group build

RUN --mount=type=bind,from=configs,source=debian.sources,target=/etc/apt/sources.list.d/debian.sources \
	--mount=type=cache,target=/var/cache/apt,sharing=private \
	--mount=type=cache,target=/var/lib/apt,sharing=private \
	apt update

RUN --mount=type=bind,from=configs,source=debian.sources,target=/etc/apt/sources.list.d/debian.sources \
	--mount=type=cache,target=/var/cache/apt,sharing=private \
	--mount=type=cache,target=/var/lib/apt,sharing=private \
	apt --assume-yes install --no-install-recommends \
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
		repo \
		rsync \
		schedtool \
		squashfs-tools \
		xsltproc \
		xxd \
		zip \
		zlib1g-dev

RUN --mount=type=bind,from=configs,source=debian.sources,target=/etc/apt/sources.list.d/debian.sources \
	--mount=type=cache,target=/var/cache/apt,sharing=private \
	--mount=type=cache,target=/var/lib/apt,sharing=private \
	apt --assume-yes upgrade

FROM base AS source

RUN chown --recursive build:build /home/build

USER build:build

WORKDIR /home/build

RUN mkdir ./out

VOLUME /home/build/out
