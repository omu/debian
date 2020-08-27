#!/usr/bin/env bash

# Prune disk in order to minimize disk size

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

prune_aggresive=${prune_aggresive:-}

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

find /var/log -type f | while read -r f; do
	# first fast code path
	{ :> "$f"; } 2>/dev/null || {
		# if failed slow code path
		read -r user group < <(stat -c '%U %G' "$f")
		cd "$(dirname "$f")" && su -g "$group" "$user" -c "truncate -s0 $(basename "$f")"
	}
done || echo >&2 "truncating log files command exit code $? is suppressed"

# Remove leftover leases and persistent rules
rm -f /var/lib/dhcp/*

# Delete APT save cruft
find /etc/apt -type f -name '*.list.save' -exec rm -f {} +

# Copyright 2012-2014, Chef Software, Inc. (<legal@chef.io>)
# Copyright 2011-2012, Tim Dysinger (<tim@dysinger.net>)

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Remove specific Linux kernels, such as linux-image-3.11.0-15 but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-amd64', etc.
dpkg --list \
    | awk '/linux-image-[234].*/ { print $2 }' \
    | { grep -v "$(uname -r)" || true; } \
    | xargs apt-get -y purge

# Delete Linux source
dpkg --list \
    | awk '/linux-source/ { print $2 }' \
    | xargs apt-get -y purge


homes=(/root)

# Prune operator
if operator=${operator:-$(id -rnu 1000 2>/dev/null)}; then
	home=$(eval echo ~"$operator")

	if [[ -d $home ]]; then
		# Fix ownerships for some files
		[[ ! -d .config ]] || chown "$operator":"$operator" .config

		# Remove files at home directory not owned by the operator
		find "$home" -not -user "$operator" -exec rm -rf {} +

		[[ $home = /root ]] || homes+=("$home")
	fi
fi

# Prune home directories
for dir in "${homes[@]}"; do
	pushd "$dir"

	rm -rf .gnupg
	rm -rf .ssh/known_hosts
	rm -rf .npm
	rm -rf .config/configstore
	rm -rf .cache
	rm -rf .wget*
	rm -rf .rnd
	rm -rf .bash_history .bash_logout
	rm -rf .zsh_history .zcompdump .zlogout

	popd
done

if [[ -n $prune_aggresive ]]; then
	# Remove documentation
	rm -rf /usr/share/man/*
	rm -rf /usr/share/info/*
	rm -rf /usr/share/doc/*

	# Keep man directory tree to avoid bugs
	mkdir -p /usr/share/man/man[1-9]
fi
