#!/usr/bin/env bash

# Setup LXC container

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-op}

if current=$(id -rnu 1000 2>/dev/null); then
	if [[ ! $current = "$operator" ]]; then
		usermod -l "$operator" -d /home/"$operator" -m "$current" -c 'Operator'
		groupmod -n "$operator" "$current"

		for f in /etc/subuid{,-} /etc/subgid{,-}; do
			[[ -f $f ]] || continue
			sed -e "s/^$current:/$operator:/" -i "$f"
		done
	fi
else
	adduser --uid 1000 --disabled-password --gecos 'Operator,,,' "$operator"
fi

echo "$operator":"$operator" | chpasswd
apt-get -y install --no-install-recommends sudo
adduser "$operator" sudo
