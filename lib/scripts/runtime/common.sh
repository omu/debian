#!/usr/bin/env bash

# Install essential development libraries

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	autoconf \
	automake \
	bison \
	build-essential \
	bzip2 \
	file \
	libvips \
	imagemagick \
	libbsd-dev \
	libbz2-dev \
	libcurl4-openssl-dev \
	libdb-dev \
	libevent-dev \
	libffi-dev \
	libgdbm-dev \
	libgeoip-dev \
	libglib2.0-dev \
	libjpeg-dev \
	libkrb5-dev \
	liblzma-dev \
	libmagickcore-dev \
	libmagickwand-dev \
	libncurses5-dev \
	libncursesw5-dev \
	libpng-dev \
	libpq-dev \
	libreadline-dev \
	libsecret-tools \
	libsqlite3-dev \
	libssl-dev \
	libtool \
	libwebp-dev \
	libxml2 \
	libxml2-dev \
	libxslt1-dev \
	libxslt-dev \
	libyaml-dev \
	patch \
	python-dev \
	sqlite3 \
	xz-utils \
	zlib1g-dev \
	#

case $(lsb_release -sc) in
jessie)
	apt-get -y install --no-install-recommends \
		libpng12-0 \
		#
	;;
*)
	apt-get -y install --no-install-recommends \
		libpng16-16 \
		#
	;;
esac
