#!/usr/bin/env bash

# Provision a server environment

# shellcheck disable=SC1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

export tmux_login_shell=true
export ruby_install_latest=true
export ruby_use_jemalloc=true
export clean_aggresive=true

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
		try javascript
		try php
	leave

	enter ./operator
		try bin
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

	enter ./virtual
		! is virtualbox  || try virtualbox
		! is qemu        || try qemu
		! is vmware      || try vmware
		! is lxc         || try lxc
		! is vagrantable || try vagrant

		try clean
		! is vm || try minimize
	leave

	etc site vendor=omu medley=server description=Kararlı color=red version="$(<../../VERSION)" build="$(date +'%Y.%m.%d.%H.%M')"
leave
