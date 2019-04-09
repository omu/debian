#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

apt-get -y install --no-install-recommends git

curl -fsSL -o /usr/local/bin/git-secrets \
	https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets
chmod +x /usr/local/bin/git-secrets

mkdir -p /usr/local/share/man/man1
curl -fsSL -o /usr/local/share/man/man1/git-secrets.1 \
	https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets.1

shopt -s nullglob
[[ -z $(echo etc/git/*) ]] || cp -a etc/git/* /etc/
