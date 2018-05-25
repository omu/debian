#!/usr/bin/env bash

# Install Bats (Bash Automated Testing System)

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

command -v git >/dev/null || apt-get install -y --no-install-recommends git

pushd "${TMPDIR:-/tmp}"
git clone https://github.com/sstephenson/bats.git
pushd bats
sudo ./install.sh /usr/local
popd
rm -rf bats
