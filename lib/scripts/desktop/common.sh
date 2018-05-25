#!/usr/bin/env bash

# Common installation for desktop environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install \
	alsa-utils \
	anacron \
	avahi-daemon \
	chromium \
	chromium-l10n \
	desktop-base \
	eject \
	gimp \
	gnome \
	gnome-core \
	hunspell-en-us \
	hyphen-en-us \
	inkscape \
	iw \
	libnss-mdns \
	libreoffice \
	libreoffice-gnome \
	libreoffice-l10n-tr \
	locales \
	mythes-en-us \
	network-manager-gnome \
	tango-icon-theme \
	transmission-gtk \
	util-linux-locales \
	vim-gnome \
	xdg-utils \
	xorg \
	xserver-xorg-input-all \
	xserver-xorg-video-all \
	#
