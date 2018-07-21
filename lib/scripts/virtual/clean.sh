#!/usr/bin/env bash

# Safe clean

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

# Delete APT save cruft
find /etc/apt -type f -name '*.list.save' -exec rm -f {} +

# Delete obsolete networking
apt-get -y purge ppp pppconfig pppoeconf

# Delete oddities
apt-get -y purge popularity-contest

# Remove APT files
apt-get -y autoremove --purge || echo >&2 "apt-get autoremove exit code $? is suppressed"
apt-get -y autoclean || echo >&2 "apt-get autoclean exit code $? is suppressed"
apt-get -y clean || echo >&2 "apt-get clean exit code $? is suppressed"
