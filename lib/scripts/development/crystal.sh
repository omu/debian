#!/usr/bin/env bash

# Install Crystal development environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 09617FD37CC06B54
echo "deb https://dist.crystal-lang.org/apt crystal main" >/etc/apt/sources.list.d/crystal.list
apt-get -y update
apt-get -y install --no-install-recommends crystal
apt-get -y install --no-install-recommends libgmp-dev libxml2-dev
