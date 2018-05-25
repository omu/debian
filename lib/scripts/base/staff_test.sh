#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

goss -g - validate --format documentation <<-EOF
	user:
	  ${operator}:
	    exists: true
	    uid: 1000
	    groups:
	    - staff
EOF
