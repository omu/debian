#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

shopt -s nullglob

[[ -z $(echo bin/*)  ]] || cp bin/*  /usr/local/bin

# Install ttyd to share terminal over the web
curl -fsSL -o /usr/local/bin/ttyd \
	https://github.com/tsl0922/ttyd/releases/download/1.4.2/ttyd_linux.x86_64
chmod +x /usr/local/bin/ttyd

# Install forego, a minimalist Procfile manager
curl -fsSL https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz |
	tar zxv -C /usr/local/bin
