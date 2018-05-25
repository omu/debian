#!/usr/bin/env bash

# Install Memcached

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	memcached \
	#

systemctl stop memcached && systemctl disable memcached
