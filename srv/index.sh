#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

readonly baseurl="https://raw.githubusercontent.com/omu/debian/${SCRIPTS_BRANCH:-master}"

die() {
	echo >&2 "$@"
	exit 1
}

main() {
	[[ $# -gt 0 ]] || die "Script name required."

	[[ -x /usr/bin/apt-cache ]] \
		|| die "Distribution must be Debian or Ubuntu: apt-cache not found"
	[[ -f /etc/os-release ]] \
		|| die "Distribution must be Debian or Ubuntu: /etc/os-release not found"

	[[ ${EUID:-} -eq 0 ]] || die "Must be run with root privileges"

	local script=${1%.sh}
	shift

	local url="${baseurl}/srv/scripts/${script}.sh"

	exec bash <(curl -fsSL "$url") "$@"
}

main "$@"

# vim: ft=sh
