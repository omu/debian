#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

dokku version

goss -g - validate --format documentation <<-EOF
	service:
	  docker:
	    enabled: true
	    running: true
	group:
	  docker:
	    exists: true
	user:
	  dokku:
	    exists: true
	    groups:
	    - docker
	    home: /home/dokku
	group:
	  dokku:
	    exists: true
EOF
