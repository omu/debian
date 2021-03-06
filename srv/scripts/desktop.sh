#!/usr/bin/env bash

# Provision a desktop environment

# shellcheck disable=1090
source <(she src) -boot

export locale=tr_TR.UTF-8
export base_use_experimental=true
export chrome_install_upstream=true
export golang_use_experimental=true
export tmux_login_shell=true

enter github.com/omu/debian/lib/scripts
	paths ../../bin

	enter ./base
		try common
		try operator
		try staff
		try locale
		try font
		try keyboard
		try timezone
		try standard
		try tweak
	leave

	enter ./runtime
		try common
		try ruby
		try javascript
		try chrome
		try php
		try tex
	leave

	enter ./operator
		try bin
		try zsh
		try vim
		try mc
		try tmux
		try git
		try direnv
	leave

	enter ./desktop
		try common
		try tweak
		try font
		try standard
		try printer
		! is physical || try laptop
	leave

	enter ./development
		try common
		try golang
		try crystal
	leave

	enter ./virtual
		! is virtualbox  || try virtualbox
		! is kvm         || try kvm
		! is vmware      || try vmware
		! is lxc         || try lxc
		! is vagrantable || try vagrant

		try clean
		is physical || try prune
		! is vm     || try minimize
	leave

	etc site vendor=omu medley=desktop description=Masaüstü color=cyan version="$(git fetch -q -t --unshallow && git describe)" build="${BUILD:-"$(date +'%y%m%d%H%M%S')"}"
leave
