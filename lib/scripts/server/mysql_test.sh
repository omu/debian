#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

default_mysql=mariadb
if [[ -n "$(dpkg-query -W -f='${Installed-Size}' 'mysql-server-*' 2>/dev/null || true)" ]]; then
	default_mysql=mysql
fi

systemctl is-enabled "$default_mysql" && false

systemctl enable "$default_mysql" && systemctl start "$default_mysql"

goss -g - validate --format documentation <<-EOF
	service:
	  $default_mysql:
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

systemctl stop "$default_mysql" &&  systemctl disable "$default_mysql"

goss -g - validate --format documentation <<-EOF
	service:
	  $default_mysql:
	    enabled: false
	    running: false
	port:
	  tcp:3306:
	    listening: false
	process:
	  mysqld:
	    running: false
EOF
