#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

systemctl is-enabled docker && false

systemctl enable docker && systemctl start docker

goss -g - validate --format documentation <<-EOF
	service:
	  docker:
	    enabled: true
	    running: true
	group:
	  docker:
	    exists: true
	user:
	  ${operator}:
	    exists: true
	    groups:
	    - docker
EOF

systemctl stop docker && systemctl disable docker

goss -g - validate --format documentation <<-EOF
	service:
	  docker:
	    enabled: false
	    running: false
EOF
