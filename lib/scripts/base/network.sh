#!/usr/bin/env bash

# Network setup

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

# Prefer networkd over legacy ifupdown for simple cases

# DHCP configured ethernet interface through ifupdown?
if [[ ! -f /etc/network/interfaces ]]; then
	echo >&2 'No ifupdown detected; skipping'
	exit 0
fi
if ! grep -Eq '^\s*iface\s+e\w+\s+inet\s+dhcp\b' /etc/network/interfaces; then
	echo >&2 'Network interface is not suitable for migration; skipping'
	exit 0
fi

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

systemctl stop networking.service

systemctl start systemd-networkd.service
systemctl start systemd-resolved.service

rm -f /etc/network/interfaces
systemctl disable networking.service
