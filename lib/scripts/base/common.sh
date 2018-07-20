#!/usr/bin/env bash

# Common installation for base environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y update

# Install all important and standard packages
# - avoid gnupg-agent pulling pinentry-gtk2 on jessie
# - avoid reportbug-gtk having bogus standard priority
apt-get -y install --no-install-recommends dctrl-tools
grep-aptavail --no-field-names --show-field Package \
	      --field Priority --regex 'important\|standard' \
	      --and --not \
	      --field Package --regex 'reportbug-gtk' |
	xargs apt-get -y install --no-install-recommends pinentry-curses
apt-get purge -y dctrl-tools

# Install "should have been standard" packages
apt-get -y install --no-install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
	daemontools \
	dirmngr \
	ethtool \
	git \
	gnupg \
	jq \
	lsb-release \
	nfs-common \
	psmisc \
	rsync \
	ruby \
	software-properties-common \
	ssh \
	sudo \
	vim \
	#

update-alternatives --set editor /usr/bin/vim.basic

# Avoid problematic package for containers
if systemd-detect-virt -qc; then
	apt-get -t purge \
		ntp \
		2>/dev/null || true
else
	apt-get -y install --no-install-recommends \
		ntp \
		#
fi

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
	jessie|stretch)
		apt-get -y install --install-recommends -t "$codename-backports" systemd
		;;
	esac

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
