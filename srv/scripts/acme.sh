#!/usr/bin/env bash

# Acme medley

# shellcheck disable=1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

enter github.com/omu/debian/lib/scripts
	enter ./_
		try hello
	leave

	enter ./virtual
		! is virtualbox  || try virtualbox
		! is qemu        || try qemu
		! is vmware      || try vmware
		! is lxc         || try lxc
		! is docker      || try docker
		! is vagrantable || try vagrant

		try clean
		! is vm || try prune
		! is vm || try minimize
	leave

	etc site vendor=omu medley=acme description=Acme color=white version="$(git fetch -q -t --unshallow && git describe)" build="${BUILD:-"$(date +'%y%m%d%H%M%S')"}"
leave
