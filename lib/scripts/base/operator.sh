#!/usr/bin/env bash

# Add a  pre-known operator user

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-op}

! id -rnu 1000 2>/dev/null || exit 0

adduser --uid 1000 --disabled-password --gecos 'Operator,,,' "$operator"
echo "$operator":"$operator" | chpasswd

apt-get -y install --no-install-recommends sudo
adduser "$operator" sudo
