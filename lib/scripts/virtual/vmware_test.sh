#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

goss -g - validate --format documentation <<-EOF
	package:
	  open-vm-tools:
	    installed: true
	  fuse:
	    installed: true
	command:
	  vmhgfs-fuse --version:
	    exit-status: 0
	    timeout: 10000
	service:
	  open-vm-tools:
	    enabled: true
	    running: true
	  hgfs:
	    enabled: true
	    running: true
EOF
