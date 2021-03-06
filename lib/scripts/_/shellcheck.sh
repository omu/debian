#!/usr/bin/env bash

# Install Shellcheck for shell script linting

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

pushd "${TMPDIR:-/tmp}"

wget -qO- 'https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz' | tar -xJv
cp shellcheck-latest/shellcheck /usr/local/bin/
rm -rf shellcheck-latest*
