#!/usr/bin/env bash

# Custom provision

# shellcheck disable=1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

enter github.com/omu/debian/lib/scripts
	paths ../../bin

	while [[ $# -gt 0 ]]; do
		case $1 in
		*/*) try "$1"   ;;
		*)   try "_/$1" ;;
		esac
		shift
	done
leave
