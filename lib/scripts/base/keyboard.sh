#!/usr/bin/env bash

# Setup console keyboard

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

keyboard=${keyboard:-tr}

conffile=/etc/default/keyboard

apt-get -y --no-install-recommends install keyboard-configuration console-setup

debconf-set-selections <<-EOF
keyboard-configuration keyboard-configuration/layoutcode select $keyboard
keyboard-configuration keyboard-configuration/xkb-keymap select $keyboard
keyboard-configuration keyboard-configuration/modelcode select pc105
EOF

touch "$conffile" && {
	grep -E -v '^\s*(#|XKBMODEL=|XKBLAYOUT=|$)'
	cat <<-EOF
	XKBMODEL='pc105'
	XKBLAYOUT='$keyboard'
	EOF
} <"$conffile" >"$conffile.new" && mv "$conffile.new" "$conffile"

dpkg-reconfigure -f noninteractive keyboard-configuration

setupcon --force --save
