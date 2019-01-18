#!/usr/bin/env bash

# Install Rubian

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

curl -fsSL https://raw.githubusercontent.com/omu/rubian/master/rubian >/usr/local/bin/rubian
chmod +x /usr/local/bin/rubian
