#!/usr/bin/env bash

# Install and setup PostgreSQL

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

codename=$(lsb_release -sc)

case $codename in
jessie|stretch|xenial|bionic|cosmic)
	cat >/etc/apt/sources.list.d/postgresql.list <<-EOF
		deb http://apt.postgresql.org/pub/repos/apt/ ${codename}-pgdg main
	EOF
	curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

	cat >/etc/apt/preferences.d/postgresql.pref <<-EOF
		Package: *
		Pin: release o=apt.postgresql.org
		Pin-Priority: 200
	EOF

	apt-get -y update
	;;
*)
	;;
esac

apt-get -y install --no-install-recommends \
	postgresql \
	postgresql-contrib \
	#

cat >/etc/postgresql-common/psqlrc <<-'EOF'
	\set QUIET 1
	\set ON_ERROR_ROLLBACK interactive
	\set VERBOSITY verbose
	\x auto
	\set PROMPT1 '%[%033[38;5;27m%]%`hostname -s`%[%033[38;5;102m%]/%/ %[%033[31;5;27m%]%[%033[0m%]%# '
	\set PROMPT2 ''
	\set HISTFILE ~/.psql_history- :DBNAME
	\set HISTCONTROL ignoredups
	\pset null [null]
	\pset pager always
	\timing
	\unset QUIET
EOF

apt-get -y install --no-install-recommends \
	autopostgresqlbackup
	#

service=postgresql

# Extra check for configuration changes
systemctl restart "$service"
systemctl is-active "$service"

systemctl stop "$service" && systemctl disable "$service"
