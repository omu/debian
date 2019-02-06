#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

shopt -s nullglob

apt-get -y install --no-install-recommends direnv

# Zsh hook
mkdir -p /etc/zsh/zshrc.d
cat >/etc/zsh/zshrc.d/direnv.sh <<-'EOF'
	command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
EOF
