#!/usr/bin/env bash

# Install Avahi

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

if ! apt-get install -y --no-install-recommends avahi-daemon libnss-mdns avahi-utils; then
	case $(systemd-detect-virt) in
	lxc)
		# Workaround for https://github.com/lxc/lxd/issues/2948
		if [[ -f /etc/avahi/avahi-daemon.conf ]]; then
			sed -e '/^rlimit-nproc=/ s/^/#/' -i /etc/avahi/avahi-daemon.conf
			echo >&2 'Workaround for LXC applied'
		fi
		systemctl restart avahi-daemon
		;;
	*)
		exit 1
	esac
fi

systemctl stop avahi-daemon && systemctl disable avahi-daemon
