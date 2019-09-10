#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

if [[ -z ${firewall_enable:-} ]]; then
	systemctl is-enabled ufw && false

	systemctl enable ufw && systemctl start ufw

	goss -g - validate --format documentation <<-EOF
		package:
		  ufw:
		    installed: true
		service:
		  ufw:
		    enabled: true
		    running: true
	EOF

	systemctl stop ufw && systemctl disable ufw

	goss -g - validate --format documentation <<-EOF
		service:
		  ufw:
		    enabled: false
		    running: false
	EOF
else
	goss -g - validate --format documentation <<-EOF
		package:
		  ufw:
		    installed: true
		service:
		  ufw:
		    enabled: true
		    running: true
	EOF
fi
