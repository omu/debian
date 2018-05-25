#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

package=php

IFS=$'.' read -r major minor _ < <(php -r 'echo PHP_VERSION . "\n";')
if [[ $major -lt 7 ]]; then
	service="php${major}-fpm"
	package="php${major}"
else
	service="php${major}.${minor}-fpm"
fi

systemctl is-enabled "$service" && false

systemctl enable "$service"
systemctl start "$service"

goss -g - validate --format documentation <<-EOF
	command:
	  php --version:
	    exit-status: 0
	    timeout: 10000
EOF

goss -g - validate --format documentation <<-EOF
	package:
	  $package:
	    installed: true
	  $service:
	    installed: true
	service:
	  $service:
	    enabled: true
	    running: true
EOF

systemctl stop "$service"
systemctl disable "$service"

goss -g - validate --format documentation <<-EOF
	service:
	  $service:
	    enabled: false
	    running: false
EOF
