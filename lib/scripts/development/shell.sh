#!/usr/bin/env bash

# Install development packages for Shell scripting

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

pushd "${TMPDIR:-/tmp}"

wget -qO- 'https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz' | tar -xJv
cp shellcheck-latest/shellcheck /usr/local/bin/
rm -rf shellcheck-latest*

git clone https://github.com/alaturka/bats.git
bats/install.sh /usr/local
rm -rf bats
