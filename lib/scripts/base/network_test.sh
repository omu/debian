#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

# DHCP configured ethernet interface through ifupdown?
if [[ -f /etc/network/interfaces ]] && grep -Eq '^\s*iface\s+e\w+\s+inet\s+dhcp\b' /etc/network/interfaces; then
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
fi
