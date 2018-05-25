#!/usr/bin/env bash

# Install essential development libraries

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	autoconf \
	bison \
	build-essential \
	libbsd-dev \
	libcurl4-openssl-dev \
	libevent-dev \
	libglib2.0-dev \
	libjpeg-dev \
	libpng-dev \
	libpq-dev \
	libsecret-tools \
	libsqlite3-dev \
	libssl-dev \
	libxml2 \
	libxml2-dev \
	libxslt1-dev \
	libxslt-dev \
	python-dev \
	sqlite3 \
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
