#!/usr/bin/env bash

# Setup console font

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

font=${font:-Terminus}

apt-get -y install --no-install-recommends \
	console-setup \
	console-terminus \
	#

debconf-set-selections <<-EOF
	console-setup console-setup/fontface select $font
EOF

conffile=/etc/default/console-setup

touch "$conffile" && {
	grep -E -v '^\s*(#|FONTFACE=|CHARMAP=|$)'
	cat <<-EOF
		CHARMAP='UTF-8'
		FONTFACE='$font'
	EOF
} <"$conffile" >"$conffile.new" && mv "$conffile.new" "$conffile"

dpkg-reconfigure -f noninteractive console-setup

setupcon --font-only --force --save || echo >&2 "setupcon exit code $? is suppressed"

# Debian BTS #759657
[[ ! -d /etc/udev/rules.d ]] || cat >/etc/udev/rules.d/90-setupcon.rules <<-'EOF'
	ACTION=="add", SUBSYSTEM=="vtconsole", KERNEL=="vtcon*", RUN+="/bin/setupcon"
EOF
