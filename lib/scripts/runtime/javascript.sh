#!/usr/bin/env bash

# Install Javascript runtime environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

codename=$(lsb_release -sc)

curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
cat >/etc/apt/sources.list.d/nodesource.list <<-EOF
	deb https://deb.nodesource.com/node_10.x $codename main
EOF
apt-get update -y && apt-get install -y --no-install-recommends nodejs

npm config set prefix /usr/local
npm install npm@latest -g

(shopt -s nullglob; rm -rf -- /tmp/npm-*)

curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
cat >/etc/apt/sources.list.d/yarn.list <<-EOF
	deb https://dl.yarnpkg.com/debian/ stable main
EOF
apt-get update -y && apt-get install -y --no-install-recommends yarn
