#!/usr/bin/env bash

# Network setup

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

# Install rinetd for port forwarding needs.  We prefer rinetd over redir, since
# it can be controlled via systemctl.
apt-get -y install --no-install-recommends rinetd

# Make it passive, as it presents an optional facility.
systemctl stop rinetd && systemctl disable rinetd

skip() {
	[[ $# -ne 0 ]] || echo >&2 "$@"
	exit 0
}

[[ -n "$(dpkg-query -W -f='${Installed-Size}' systemd 2>/dev/null ||:)" ]] ||
	skip 'No systemd detected; skipping network setup'

[[ -z "$(dpkg-query -W -f='${Installed-Size}' network-manager 2>/dev/null ||:)" ]] ||
	skip 'Network Manager detected; skipping network setup'

# shellcheck disable=1091
distribution=$(unset ID && . /etc/os-release 2>/dev/null && echo "$ID")

if [[ $distribution = debian ]]; then
	# Prefer networkd over legacy ifupdown for simple cases

	# DHCP configured ethernet interface through ifupdown?
	[[ -f /etc/network/interfaces ]] ||
		skip 'No ifupdown detected; skipping network setup'

	grep -Eq '^\s*iface\s+e\w+\s+inet\s+dhcp\b' /etc/network/interfaces ||
		skip 'Network interface is not suitable for migration; skipping network setup'

	systemctl enable systemd-networkd.service
	systemctl enable systemd-resolved.service

	rm -f /etc/resolv.conf
	ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

	# Ensure we have a DHCP configured interface regardless of the interface name
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

	sleep 3
elif [[ $distribution = ubuntu ]]; then
	[[ -d /etc/netplan ]] || skip 'No netplan detected; skipping network setup'

	# Ensure we have a DHCP configured interface regardless of the interface name
	cat >/etc/netplan/99-dhcp.yaml <<-EOF
		network:
		  version: 2
		  renderer: networkd
		  ethernets:
		    eth0:
		      match:
		        name: e*
		      dhcp4: yes
	EOF
	netplan apply

	sleep 3
fi
