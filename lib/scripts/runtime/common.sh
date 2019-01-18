#!/usr/bin/env bash

# Install essential development libraries and tools

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

apt-get -y install --no-install-recommends \
	default-mysql-client \
	openssh-client \
	postgresql-client \
	sqlite3 \
	#

curl -fsLO https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb
dpkg -i wkhtmlto* 2>/dev/null || true
rm -f wkhtmlto*
apt-get -y install --no-install-recommends --fix-broken
