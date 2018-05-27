#!/usr/bin/env bash

# Provision a minimal environment

# shellcheck disable=SC1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

export tmux_login_shell=true
export ruby_install_latest=true
export ruby_use_jemalloc=true

enter github.com/omu/debian/lib/scripts
	paths ../../bin

	enter ./base
		try common
		try operator
		! is lxc || try locale
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
		! is virtualbox  || try virtualbox
		! is qemu        || try qemu
		! is vmware      || try vmware
		! is lxc         || try lxc
		! is vagrantable || try vagrant
	leave

	enter ./operator
		try bin
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
