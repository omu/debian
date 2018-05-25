#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

systemctl is-enabled redis-server && false

systemctl enable redis-server && systemctl start redis-server

goss -g - validate --format documentation <<-EOF
	service:
	  redis-server:
	    enabled: true
	    running: true
	user:
	  redis:
	    exists: true
	    groups:
	    - redis
	    home: /var/lib/redis
	group:
	  redis:
	    exists: true
	process:
	  redis-server:
	    running: true
EOF

if [[ -n ${redis_use_socket:-} ]]; then
	goss -g - validate --format documentation <<-EOF
		file:
		  /var/run/redis/redis.sock:
		    exists: true
		    owner: redis
		    group: redis
		    mode: "0770"
		user:
		  www-data:
		    exists: true
		    groups:
		    - redis
	EOF
else
	goss -g - validate --format documentation <<-EOF
		port:
		  tcp:6379:
		    listening: true
	EOF
fi

systemctl stop redis-server && systemctl disable redis-server

goss -g - validate --format documentation <<-EOF
	service:
	  redis-server:
	    enabled: false
	    running: false
	process:
	  redis-server:
	    running: false
EOF
