#!/usr/bin/env bash

# Provision a desktop environment

# shellcheck disable=SC1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

export base_use_experimental=true
export golang_use_experimental=true
export tmux_login_shell=true

enter github.com/omu/debian/lib/scripts
	paths ../../bin

	enter ./base
		try common
		try operator
		try staff
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
		try php
		try tex
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

	try base/clean
	try desktop/clean

	! is vm || try virtual/minimize
leave

etc site vendor=omu medley=desktop description=Masaüstü color=cyan version="$(date +'%Y.%m.%d.%H.%M')"
