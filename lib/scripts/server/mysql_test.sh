#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

service=mysql; [[ -z ${mysql_use_mariadb:-} ]] || service=mariadb

systemctl is-enabled "$service" && false

systemctl enable "$service" && systemctl start "$service"

goss -g - validate --format documentation <<-EOF
	service:
	  $service:
	    enabled: true
	    running: true
EOF

goss -g - validate --format documentation <<-EOF
	user:
	  mysql:
	    exists: true
	    groups:
	    - mysql
	group:
	  mysql:
	    exists: true
	port:
	  tcp:3306:
	    listening: true
	process:
	  mysqld:
	    running: true
EOF

goss -g - validate --format documentation <<-EOF
	package:
	  automysqlbackup:
	    installed: true
EOF

systemctl stop "$service" &&  systemctl disable "$service"

goss -g - validate --format documentation <<-EOF
	service:
	  $service:
	    enabled: false
	    running: false
	port:
	  tcp:3306:
	    listening: false
	process:
	  mysqld:
	    running: false
EOF
