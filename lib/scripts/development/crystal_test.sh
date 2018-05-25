#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

goss -g - validate --format documentation <<-EOF
	command:
	  crystal version:
	    exit-status: 0
	    stderr: []
	    timeout: 10000
EOF
