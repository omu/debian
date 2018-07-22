#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

dokku version
dokku domains:report | grep -Eq "vhosts:\s+$(hostname)[.]local"
dokku plugin:list | grep -Eq '^\s+(postgres|redis|letsencrypt)\b'

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
