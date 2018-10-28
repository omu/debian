#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

apt-get -y install --no-install-recommends zsh

for i in zprofile zshrc zlogin; do
	mkdir -p "/etc/zsh/$i.d"
	if [[ -d "./etc/zsh/$i.d" ]]; then
		cp -a "./etc/zsh/$i.d"/* "/etc/zsh/$i.d"
	fi
	if [[ -f "/etc/zsh/$i" ]] && [[ ! -f /etc/zsh/$i.d/dist.sh ]]; then
		mv "/etc/zsh/$i" "/etc/zsh/$i.d/dist.sh"
	fi
	cp "./etc/zsh/$i" /etc/zsh/
done

cp -a etc/zsh/functions/* /usr/local/share/zsh/site-functions/

chsh -s "$(command -v zsh)" "$operator"

# Tmux extension
mkdir -p /etc/tmux/conf.d
cat >/etc/tmux/conf.d/zsh.conf <<-'EOF'
	set -g default-shell /usr/bin/zsh
EOF

# Mute Zsh for new users
su - "$operator" -c 'touch ~/.zshrc'
