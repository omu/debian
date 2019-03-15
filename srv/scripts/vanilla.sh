#!/usr/bin/env bash

# Provision a vanilla environment

# shellcheck disable=1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

export tmux_login_shell=true
export prune_aggresive=true

enter github.com/omu/debian/lib/scripts
	paths ../../bin

	enter ./base
		try common
		try operator
		! is lxc || try locale
		try font
		try keyboard
		try timezone
		try tweak
	leave

	enter ./operator
		try bin
		try zsh
		try vim
		try mc
		try tmux
		try direnv
	leave

	enter ./virtual
		! is virtualbox  || try virtualbox
		! is kvm         || try kvm
		! is vmware      || try vmware
		! is lxc         || try lxc
		! is vagrantable || try vagrant

		try final
		try clean
		is physical || try prune
		! is vm     || try minimize
	leave

	etc site vendor=omu medley=vanilla description=Vanilya color=white version="$(git fetch -q -t --unshallow && git describe)" build="${BUILD:-"$(date +'%y%m%d%H%M%S')"}"
leave
