#!/usr/bin/env bash

# Install and setup Redis

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

redis_use_socket=${redis_use_socket:-}

fix() {
	[[ ! -f "$1" ]] || sed -i '/BEGIN FIX/,/END FIX/d' "$1"
	{ echo "# BEGIN FIX"; cat; echo "# END FIX"; } >>"$1"
}

apt-get -y install --no-install-recommends redis-server

if [[ -n $redis_use_socket ]]; then
	adduser www-data redis

	fix /etc/redis/redis.conf <<-EOF
		port 0
		unixsocket /var/run/redis/redis.sock
		unixsocketperm 770
	EOF
	systemctl restart redis-server
fi

systemctl stop redis-server && systemctl disable redis-server
