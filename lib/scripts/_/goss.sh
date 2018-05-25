#!/usr/bin/env bash

# Install Goss

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

curl -fsSL https://goss.rocks/install | GOSS_DST=/usr/local/bin sh
