#!/usr/bin/env bash

# Network setup

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

# shellcheck disable=SC1091
distribution=$(unset ID && . /etc/os-release 2>/dev/null && echo "$ID")
codename=$(lsb_release -sc)

# Prefer networkd over legacy ifupdown

if [[ $distribution = debian ]]; then
	case $codename in
	jessie|stretch|sid)
		prefer_networkd=true
		;;
	esac
elif [[ $distribution = ubuntu ]]; then
	# Nowadays Ubuntu uses netplan
	case $codename in
	xenial)
		prefer_networkd=true
		;;
	esac
fi

if [[ -n ${prefer_networkd:-} ]]; then
	systemctl enable systemd-networkd.service
	systemctl enable systemd-resolved.service

	rm -f /etc/resolv.conf
	ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

	cat >/etc/systemd/network/99-dhcp.network <<-EOF
		[Match]
		Name=e*

		[Network]
		DHCP=yes
	EOF
	chmod a+r /etc/systemd/network/99-dhcp.network

	rm -f /etc/network/interfaces
	systemctl disable networking.service
fi
