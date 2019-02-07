#!/usr/bin/env bash

# Provision a Dokku based PaaS environment

# shellcheck disable=1090
source <(curl -fsSL https://she.alaturka.io/source) -boot

export tmux_login_shell=true
export prune_aggresive=true
export dokku_plugins='postgres redis memcached letsencrypt http-auth redirect maintenance'

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

	enter ./server
		try common
		try dokku
		try firewall
	leave

	enter ./virtual
		! is virtualbox  || try virtualbox
		! is qemu        || try qemu
		! is vmware      || try vmware
		! is lxc         || try lxc
		! is vagrantable || try vagrant

		try final
		try clean
		is physical || try prune
		! is vm     || try minimize
	leave

	etc site vendor=omu medley=paas description=PaaS color=orange version="$(git fetch -q -t --unshallow && git describe)" build="${BUILD:-"$(date +'%y%m%d%H%M%S')"}"
leave
