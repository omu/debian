#!/usr/bin/env bash

# Common installation for base environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y update

virtualization=none
if command -v systemd-detect-virt &>/dev/null; then
	virtualization=$(systemd-detect-virt 2>/dev/null || echo none)
elif [[ $(grep -c docker </proc/1/cgroup 2>/dev/null) -gt 0 ]] || [[ -f /.dockerenv ]]; then
	virtualization=docker
elif grep -qa container=lxc /proc/1/environ; then
	virtualization=lxc
fi

container=
case $virtualization in
lxc|docker)
	container=true
	;;
esac

# shellcheck disable=1091
distribution=$(unset ID && . /etc/os-release 2>/dev/null && echo "$ID")
codename=$(lsb_release -sc)

case $virtualization in
docker)
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
		procps \
		rsync \
		software-properties-common \
		wget \
		#

	if [[ ! -f /etc/apt/sources.list.d/postgresql.list ]]; then
		cat >/etc/apt/sources.list.d/postgresql.list <<-EOF
			deb http://apt.postgresql.org/pub/repos/apt/ ${codename}-pgdg main
		EOF
		curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

		cat >/etc/apt/preferences.d/postgresql.pref <<-EOF
			Package: *
			Pin: release o=apt.postgresql.org
			Pin-Priority: 1000
		EOF

		apt-get -y update
	fi

	apt-get -y install --no-install-recommends \
		postgresql-client \
		#
	;;
*)
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
	;;
esac

if [[ -n $container ]]; then
	# Avoid problematic package for containers
	apt-get -t purge \
		ntp \
		2>/dev/null || true
else
	apt-get -y install --no-install-recommends \
		ntp \
		#
fi

case $distribution in
debian)
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

	apt-get -y update

	case $codename in
	jessie|stretch)
		[[ $virtualization = docker ]] || apt-get -y install --install-recommends -t "$codename-backports" systemd
		;;
	esac

	case $codename in
	stretch|sid)
		apt-get -y install --no-install-recommends \
			libarchive-tools \
			#
		;;
	esac
	;;
ubuntu)
	apt-get -y update
	;;
esac

apt-get -y upgrade
