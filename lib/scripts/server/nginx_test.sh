#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

systemctl is-enabled nginx && false

systemctl enable nginx && systemctl start nginx

goss -g - validate --format documentation <<-EOF
	port:
	  tcp:80:
	    listening: true
	    ip:
	    - 0.0.0.0
	  tcp6:80:
	    listening: true
	    ip:
	    - '::'
	service:
	  nginx:
	    enabled: true
	    running: true
	process:
	  nginx:
	    running: true
EOF

systemctl stop nginx && systemctl disable nginx

goss -g - validate --format documentation <<-EOF
	port:
	  tcp:80:
	    listening: false
	    ip:
	    - 0.0.0.0
	  tcp6:80:
	    listening: false
	    ip:
	    - '::'
	service:
	  nginx:
	    enabled: false
	    running: false
	process:
	  nginx:
	    running: false
EOF
