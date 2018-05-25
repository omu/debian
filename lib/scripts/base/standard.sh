#!/usr/bin/env bash

# Standard (albeit not essential) installation for base environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	dnsutils \
	dosfstools \
	ed \
	file \
	htop \
	iputils-tracepath \
	moreutils \
	ncdu \
	net-tools \
	pass \
	psmisc \
	rake \
	recode \
	ruby \
	socat \
	syslinux \
	telnet \
	tree \
	wcalc \
	xz-utils \
	#
