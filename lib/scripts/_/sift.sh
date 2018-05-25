#!/usr/bin/env bash

# Install Sift (a powerful alternative to Grep)

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

command -v curl >/dev/null || apt-get install -y --no-install-recommends curl

version=0.9.0

curl -fsSL https://sift-tool.org/downloads/sift/sift_${version}_linux_amd64.tar.gz |
tar -C /usr/local/bin --strip-components=1 -zxvf - sift_${version}_linux_amd64/sift &&
chmod +x /usr/local/bin/sift
