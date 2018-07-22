#!/usr/bin/env bash

# Install Avahi

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get install -y --no-install-recommends avahi-daemon libnss-mdns avahi-utils

systemctl stop avahi-daemon && systemctl disable avahi-daemon
