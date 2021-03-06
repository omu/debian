#!/usr/bin/env bash

# Provision a server environment

# shellcheck disable=1090
source <(she src) -boot

export tmux_login_shell=true
export firewall_enable=true
export ruby_install_latest=true
export prune_aggresive=true
export chrome_install_upstream=true

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
		try chrome
		try php
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
		! is kvm         || try kvm
		! is vmware      || try vmware
		! is lxc         || try lxc
		! is vagrantable || try vagrant

		try final
		try clean
		is physical || try prune
		! is vm     || try minimize
	leave

	etc site vendor=omu medley=server description=Kararlı color=red version="$(git fetch -q -t --unshallow && git describe)" build="${BUILD:-"$(date +'%y%m%d%H%M%S')"}"
leave
