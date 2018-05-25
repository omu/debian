#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

shopt -s nullglob

apt-get -y install --no-install-recommends mc
[[ -z $(echo etc/mc/*) ]] || cp -a etc/mc/* /usr/share/mc/

# Tmux extension
mkdir -p /etc/tmux/conf.d
cat >/etc/tmux/conf.d/mc.conf <<-'EOF'
	unbind C
	bind C new-window -c "#{pane_current_path}" "exec mc"
EOF
