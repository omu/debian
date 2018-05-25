#!/usr/bin/env bash

# Provision a minimal environment

# shellcheck disable=SC1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

enter github.com/omu/debian/lib/scripts
	paths ../../bin

	try _/runtime

	enter ./virtual
		! is vagrantable || try vagrant
		! is virtualbox  || try virtualbox
		! is qemu        || try qemu
		! is vmware      || try vmware
	leave

	try base/clean

	! is vm || try virtual/minimize
leave

etc site vendor=omu medley=minimal description=Minimal color=white version="$(date +'%Y.%m.%d.%H.%M')"
