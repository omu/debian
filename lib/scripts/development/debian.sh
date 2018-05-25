#!/usr/bin/env bash

# Install development packages for Debian packaging

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	adequate \
	apt-utils \
	autopkgtest \
	build-essential \
	cowbuilder \
	debconf-i18n \
	debconf-utils \
	dput-ng \
	git-buildpackage \
	piuparts \
	#

apt-get -y install devscripts # with recommends
