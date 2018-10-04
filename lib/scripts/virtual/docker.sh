#!/usr/bin/env bash

# Prepare Docker base

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y update

# Install "should have been standard" packages
apt-get -y install --no-install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
	git \
	gnupg \
	jq \
	lsb-release \
	openssh-client \
	postgresql-client \
	procps \
	rsync \
	software-properties-common \
	wget \
	#

# Avoid problematic package for containers
apt-get -t purge ntp 2>/dev/null || true

# shellcheck disable=1091
distribution=$(unset ID && . /etc/os-release 2>/dev/null && echo "$ID")
codename=$(lsb_release -sc)

if [[ $distribution = debian ]]; then
	case $codename in
	jessie|stretch)
		cat >/etc/apt/sources.list.d/backports.list <<-EOF
			deb http://ftp.debian.org/debian $codename-backports main contrib non-free
		EOF
		;;
	*)
		if [[ -n ${base_use_experimental:-} ]]; then
			cat >/etc/apt/sources.list.d/experimental.list <<-EOF
				deb http://ftp.debian.org/debian experimental main contrib non-free
			EOF
		fi
		;;
	esac
elif [[ $distribution = ubuntu ]]; then
	:
fi

apt-get -y update

if [[ $distribution = debian ]]; then
	case $codename in
	stretch|sid)
		apt-get -y install --no-install-recommends \
			libarchive-tools \
			#
		;;
	esac
elif [[ $distribution = ubuntu ]]; then
	:
fi

apt-get -y upgrade
