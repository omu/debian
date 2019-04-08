#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

apt-get -y install --no-install-recommends git git-secrets

shopt -s nullglob
[[ -z $(echo etc/git/*) ]] || cp -a etc/git/* /etc/
