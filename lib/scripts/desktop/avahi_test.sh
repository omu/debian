#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

systemctl is-enabled avahi-daemon && false

systemctl enable avahi-daemon && systemctl start avahi-daemon

goss -g - validate --format documentation <<-EOF
	port:
	  udp:5353:
	    listening: true
	service:
	  avahi-daemon:
	    enabled: true
	    running: true
	process:
	  avahi-daemon:
	    running: true
EOF

hostname=$(hostname)
for host in "$hostname.local" "$hostname-{1,3}.local"; do
	if [[ -n $(avahi-resolve-host-name -4 "$host" 2>/dev/null) ]]; then
		found=$host
		break
	fi
done

if [[ -n ${found:-} ]]; then
	echo >&2 "Avahi hostname: $found"
else
	echo >&2 "Avahi hostname not detected"
	exit 1
fi

systemctl stop avahi-daemon && systemctl disable avahi-daemon
