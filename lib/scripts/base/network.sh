#!/usr/bin/env bash

# Network setup

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

# Prefer networkd over legacy ifupdown

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

	systemctl start systemd-networkd.service
	systemctl start systemd-resolved.service

	systemctl stop networking.service
	systemctl disable networking.service
	;;
esac
