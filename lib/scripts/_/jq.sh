#!/usr/bin/env bash

# Install Jq (a JSON processor)

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

command -v curl >/dev/null || apt-get install -y --no-install-recommends curl

sudo curl -fsSL -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod +x /usr/local/bin/jq
