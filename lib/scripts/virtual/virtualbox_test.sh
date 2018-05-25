#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

goss -g - validate --format documentation <<-EOF
	service:
	  vboxadd:
	    enabled: true
	    running: true
EOF

if ! modinfo vboxguest >/dev/null 2>&1; then
	echo >&2 "no vboxguest module found"
	exit 1
fi
