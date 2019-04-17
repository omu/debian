#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

die() {
	echo >&2 "$@"
	exit 1
}

for i in zprofile zshrc zlogin; do
	[[ -f /etc/zsh/$i.d/dist.sh ]] || continue
	# shellcheck disable=2012
	[[ $(ls -1 /etc/zsh/$i.d/*.sh | head -n 1) = /etc/zsh/$i.d/dist.sh ]] || die 'Script order wrong'
done
