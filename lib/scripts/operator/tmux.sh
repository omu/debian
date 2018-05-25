#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

tmux_login_shell=${tmux_login_shell:-}

# Install required packages
packages=(tmux)
if [[ $(lsb_release -sc) == jessie ]]; then
	if ! grep -E -qR '^deb\s.+\sjessie-backports\s.+' /etc/apt; then
		cat >/etc/apt/sources.list.d/backports.list <<-EOF
			deb http://ftp.debian.org/debian jessie-backports main contrib non-free
		EOF
		apt-get -y update
	fi
	apt-get -y install -t jessie-backports --no-install-recommends "${packages[@]}"
else
	apt-get -y install --no-install-recommends "${packages[@]}"
fi

shopt -s nullglob
[[ -z $(echo etc/tmux/*) ]] || cp -a etc/tmux/* /etc/

if [[ -n $tmux_login_shell ]]; then
	chsh -s "$(which tmux)" "$operator"

	# Avoid motd noise if Tmux is the login shell
	shopt -s nullglob
	if [[ -n $(echo /etc/update-motd.d/*) ]]; then
		chmod -x /etc/update-motd.d/*
	fi
fi
