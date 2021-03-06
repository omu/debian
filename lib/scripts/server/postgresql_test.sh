#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

service=postgresql

systemctl is-enabled "$service" && false

systemctl enable "$service" && systemctl start "$service" && sleep 1s

goss -g - validate --format documentation <<-EOF
	service:
	  $service:
	    enabled: true
	    running: true
EOF

goss -g - validate --format documentation <<-EOF
	user:
	  postgres:
	    exists: true
	    groups:
	    - postgres
	group:
	  postgres:
	    exists: true
	port:
	  tcp:5432:
	    listening: true
	process:
	  postgres:
	    running: true
EOF

goss -g - validate --format documentation <<-EOF
	package:
	  autopostgresqlbackup:
	    installed: true
EOF

systemctl stop "$service" &&  sleep 1s && systemctl disable "$service"

goss -g - validate --format documentation <<-EOF
	service:
	  $service:
	    enabled: false
	    running: false
	port:
	  tcp:5432:
	    listening: false
	process:
	  postgres:
	    running: false
EOF
