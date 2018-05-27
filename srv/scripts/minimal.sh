#!/usr/bin/env bash

# Provision a minimal environment

# shellcheck disable=SC1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

enter github.com/omu/debian/lib/scripts
	paths ../../bin

	enter ./base
		try common
		try operator
		try font
		try keyboard
		try timezone
		try standard
		try tweak
	leave

	enter ./runtime
		try common
		try ruby
	leave

	enter ./virtual
		! is vagrantable || try vagrant
		! is virtualbox  || try virtualbox
		! is qemu        || try qemu
		! is vmware      || try vmware
	leave

	enter ./operator
		try dist
		try zsh
		try vim
		try mc
		try tmux
	leave

	try server/common
	try base/clean
	try server/clean

	! is vm || try virtual/minimize
leave

etc site vendor=omu medley=minimal description=Minimal color=white version="$(date +'%Y.%m.%d.%H.%M')"
