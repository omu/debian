#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

# shellcheck disable=2120
skip() {
	[[ $# -ne 0 ]] || echo >&2 "$@"
	exit 0
}

# shellcheck disable=2119
[[ -n "$(dpkg-query -W -f='${Installed-Size}' systemd 2>/dev/null ||:)" ]] || skip

# shellcheck disable=2119
[[ -z "$(dpkg-query -W -f='${Installed-Size}' network-manager 2>/dev/null ||:)" ]] || skip

# shellcheck disable=SC1091
distribution=$(unset ID && . /etc/os-release 2>/dev/null && echo "$ID")

if [[ $distribution = debian ]]; then
	# shellcheck disable=2119
	[[ -f /etc/network/interfaces ]] || skip
	# shellcheck disable=2119
	! grep -Eq '^\s*iface\s+e\w+\s+inet\s+dhcp\b' /etc/network/interfaces || skip

	goss -g - validate --format documentation <<-EOF
		service:
		  systemd-networkd:
		    enabled: true
		    running: true
		  systemd-resolved:
		    enabled: true
		    running: true
		  networking:
		    enabled: false
		    running: false
		command:
		  networkctl --no-legend --no-pager:
		    exit-status: 0
		    stdout:
		      - /e.+\\s+ether\\s+routable\\s+configured/
		dns:
		  A:example.com:
		    resolvable: true
	EOF
elif [[ $distribution = ubuntu ]]; then
	# shellcheck disable=2119
	[[ -d /etc/netplan ]] || skip

	goss -g - validate --format documentation <<-EOF
		service:
		  systemd-networkd:
		    enabled: true
		    running: true
		command:
		  networkctl --no-legend --no-pager:
		    exit-status: 0
		    stdout:
		      - /e.+\\s+ether\\s+routable\\s+configured/
		dns:
		  A:example.com:
		    resolvable: true
	EOF
fi
