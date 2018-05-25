#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

operator=${operator:-$(id -rnu 1000 2>/dev/null)}
home=$(eval echo ~"$operator")

goss -g - validate --format documentation <<-EOF
	file:
	  $home/.ssh/authorized_keys:
	    exists: true
	    contains:
	    - vagrant
EOF
