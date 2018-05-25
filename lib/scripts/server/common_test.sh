#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

user=${deployer_user:-srv}
home=${deployer_home:-/srv}
uid=${deployer_uid:-10000}

goss -g - validate --format documentation <<-EOF
	user:
	  $user:
	    exists: true
	    home: $home
	    uid:  $uid
	    groups:
	    - $user
EOF
