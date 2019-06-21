#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

shopt -s nullglob

cd "$(dirname "$0")/../../.."

[[ -z $(echo bin/*)  ]] || cp bin/*  /usr/local/bin

# Install selected zoo animals
for prog in scripts banner app chost; do
	curl -fsSL -o /usr/local/bin/"$prog" \
		https://raw.githubusercontent.com/omu/zoo/master/"$prog"/"$prog"
	chmod +x /usr/local/bin/"$prog"
done

# Install ttyd to share terminal over the web
curl -fsSL -o /usr/local/bin/ttyd \
	https://github.com/tsl0922/ttyd/releases/download/1.4.2/ttyd_linux.x86_64
chmod +x /usr/local/bin/ttyd

# Install forego, a minimalist Procfile manager
curl -fsSL https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz |
	tar zxv -C /usr/local/bin
