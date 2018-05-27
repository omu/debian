#!/usr/bin/env bash

# Cleanup in order to minimize disk size

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

clean_aggresive=${clean_aggresive:-}
operator=${operator:-$(id -rnu 1000 2>/dev/null)}

# Remove caches
find /var/cache -type f -exec rm -rf {} \;

# Clean up log files
find /var/log -type f | while read -r f; do :>"$f"; done

# Remove leftover leases and persistent rules
rm -f /var/lib/dhcp/*

# Delete APT save cruft
find /etc/apt -type f -name '*.list.save' -exec rm -f {} +

# Clean HOME directories
for home in "$(eval echo ~"$operator")" /root; do
	pushd "$home"
	rm -rf .gnupg
	rm -rf .ssh/known_hosts
	rm -rf .npm
	rm -rf .config/configstore
	[[ ! -d .config ]] || chown "$operator":"$operator" .config
	rm -rf .cache
	rm -rf .wget*
	rm -rf .rnd
	rm -rf .bash_history .bash_logout
	rm -rf .zsh_history .zcompdump .zlogout
	popd
done

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

# Delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf

# Delete oddities
apt-get -y purge popularity-contest

# Remove APT files
apt-get -y autoremove --purge || echo >&2 "apt-get autoremove exit code $? is suppressed"
apt-get -y autoclean || echo >&2 "apt-get autoclean exit code $? is suppressed"
apt-get -y clean || echo >&2 "apt-get clean exit code $? is suppressed"

if [[ -n $clean_aggresive ]]; then
	# Remove documentation
	rm -rf /usr/share/man/*
	rm -rf /usr/share/info/*
	rm -rf /usr/share/doc/*
fi
