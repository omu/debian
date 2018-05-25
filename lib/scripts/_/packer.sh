#!/usr/bin/env bash

# Install Packer

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

version=1.1.3

apt-get install -y --no-install-recommends curl libarchive-tools

curl -fsSL https://releases.hashicorp.com/packer/${version}/packer_${version}_linux_amd64.zip |
bsdtar -C /usr/local/bin -o -xvf- - && chmod +x /usr/local/bin/packer
