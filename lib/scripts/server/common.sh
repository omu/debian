#!/usr/bin/env bash

# Common setup for server environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

if [[ -z ${base_no_deployer:-} ]]; then
	user=${deployer_user:-srv}
	home=${deployer_home:-/srv}
	uid=${deployer_uid:-10000}

	id -u "$user" 2>/dev/null && exit 0

	adduser --home "$home" --shell /bin/false --no-create-home --uid "$uid" --disabled-login --gecos 'Deploy User,,,' "$user"
	chown "$user":"$user" "$home"
fi
