#!/usr/bin/env bash

# Network setup

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

# Prefer networkd over legacy ifupdown

# XXX: Overly simplistic script to migrate network configuration.
#      Note that the migrated configuration has some bold assumptions,
#      i.e. interface names matches "e*", and using DHCP.

case "$(lsb_release -sc)" in
xenial|jessie|stretch|sid)
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

	if [[ -n ${network_activate_new:-} ]]; then
		systemctl stop networking.service
		systemctl start systemd-networkd.service
		systemctl start systemd-resolved.service

		systemctl --no-reload disable networking.service
	else
		systemctl disable networking.service
	fi
	;;
esac
