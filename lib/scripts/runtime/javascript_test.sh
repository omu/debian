#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

goss -g - validate --format documentation <<-EOF
	package:
	  nodejs:
	    installed: true
	command:
	  node --version:
	    exit-status: 0
	    timeout: 10000
	  npm version:
	    exit-status: 0
	    timeout: 10000
	  npm -g config get prefix:
	    exit-status: 0
	    stdout:
	    - "/usr/local"
	    timeout: 10000
EOF
