#!/usr/bin/env bash

# Provision a server environment

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

	enter ./server
		try common
		try php
		try postgresql
		try redis
		try nginx; systemctl enable nginx
		try firewall
	leave

	try base/clean
	try server/clean

	! is vm || try virtual/minimize
leave

etc site vendor=omu medley=server description=Kararlı color=red version="$(date +'%Y.%m.%d.%H.%M')"
