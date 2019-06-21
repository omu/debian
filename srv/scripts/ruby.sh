#!/usr/bin/env bash

# Provision a base Docker container for Ruby applications

# shellcheck disable=1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

is docker || die 'Only for docker'

enter github.com/omu/debian/lib/scripts
	enter ./base
		try common
		try locale
		try timezone
	leave

	enter ./runtime
		try common
		try ruby
		try javascript
		try chrome
	leave

	enter ./operator
		try bin
	leave

	enter ./virtual
		try clean
		try prune
	leave

	etc site vendor=omu medley=ruby description=Ruby color=red version="$(git fetch -q -t --unshallow && git describe)" build="${BUILD:-"$(date +'%y%m%d%H%M%S')"}"
leave
