#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

systemctl is-enabled inspeqtor && false

systemctl enable inspeqtor && systemctl start inspeqtor

goss -g - validate --format documentation <<-EOF
	service:
	  inspeqtor:
	    enabled: true
	    running: true
	process:
	  inspeqtor:
	    running: true
EOF

systemctl stop inspeqtor && systemctl disable inspeqtor

goss -g - validate --format documentation <<-EOF
	service:
	  inspeqtor:
	    enabled: false
	    running: false
	process:
	  inspeqtor:
	    running: false
EOF
