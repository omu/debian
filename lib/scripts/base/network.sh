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

	rm -f /etc/network/interfaces

	if [[ -z $container ]]; then
		systemctl stop networking.service
		systemctl disable networking.service
		sleep 1
		systemctl start systemd-networkd.service
		systemctl start systemd-resolved.service
		sleep 1
	else
		# On containers, just disable legacy service; let it runs
		systemctl disable networking.service
	fi
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

	sleep 1
fi
