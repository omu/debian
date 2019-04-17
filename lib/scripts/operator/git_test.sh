#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

die() {
	echo >&2 "$@"
	exit 1
}

hooks_path=$(git config --system core.hooksPath) || die "git config command failed"
[[ $hooks_path = /etc/git/hooks ]] || die "Unexpected hooks path: $hooks_path"

# TODO: extra tests
