#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

for i in zprofile zshrc zlogin; do
	[[ -f /etc/zsh/$i.d/dist.sh ]] || continue
	# shellcheck disable=2012
	if [[ $(ls -1 /etc/zsh/$i.d/*.sh | head -n 1) != /etc/zsh/$i.d/dist.sh ]]; then
		echo >&2 "Script order wrong"
		exit 1
	fi
done
