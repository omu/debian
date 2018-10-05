#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

if operator=${operator:-$(id -rnu 1000 2>/dev/null)}; then
	home=$(eval echo ~"$operator")

	if [[ -d $home ]]; then
		if [[ -n $(find "$home" -not -user "$operator" | tee /dev/stderr) ]]; then
			echo >&2 "Found file(s) which do not belong to user $operator"
			exit 1
		fi

		if [[ -n $(find "$home" -not -group "$operator" | tee /dev/stderr) ]]; then
			echo >&2 "Found file(s) which do not belong to group $operator"
			exit 1
		fi
	fi
fi
