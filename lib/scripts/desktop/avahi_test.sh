#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

systemctl is-enabled avahi-daemon && false

systemctl enable avahi-daemon && systemctl start avahi-daemon

goss -g - validate --format documentation <<-EOF
	port:
	  udp:5353:
	    listening: true
	    ip:
	    - 0.0.0.0
	  tcp6:5353:
	    listening: true
	    ip:
	    - '::'
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

goss -g - validate --format documentation <<-EOF
	port:
	  tcp:5353:
	    listening: false
	    ip:
	    - 0.0.0.0
	  tcp6:5353:
	    listening: false
	    ip:
	    - '::'
	service:
	  avahi-daemon:
	    enabled: false
	    running: false
	process:
	  avahi-daemon:
	    running: false
EOF