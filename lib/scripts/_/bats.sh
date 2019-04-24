#!/usr/bin/env bash

# Install Bats (Bash Automated Testing System)

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

command -v git >/dev/null || apt-get install -y --no-install-recommends git

pushd "${TMPDIR:-/tmp}"

git clone https://github.com/alaturka/bats.git
sudo bats/install.sh /usr/local
rm -rf bats
