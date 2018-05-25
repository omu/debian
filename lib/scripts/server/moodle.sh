#!/usr/bin/env bash

# Install and setup moodle

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

moodle_use_db=${moodle_use_db:-mysql}

case $(lsb_release -sc) in
jessie)
	apt-get -y install --no-install-recommends \
		php5-curl \
		php5-gd \
		php5-intl \
		php5-ldap \
		php5-mbstring\
		php5-pspell \
		php5-soap \
		php5-xml \
		php5-xmlrpc \
		php5-zip \
		#
	;;
*)
	apt-get -y install --no-install-recommends \
		php-curl \
		php-gd \
		php-intl \
		php-ldap \
		php-mbstring\
		php-pspell \
		php-soap \
		php-xml \
		php-xmlrpc \
		php-zip \
		#
	;;
esac

case $moodle_use_db in
pg)
	case $(lsb_release -sc) in
	jessie)
		apt-get -y install --no-install-recommends \
			php5-pg \
			#
		;;
	*)
		apt-get -y install --no-install-recommends \
			php-pg \
			#
		;;
	esac
	# TODO performance tuning
	;;
mysql)
	case $(lsb_release -sc) in
	jessie)
		apt-get -y install --no-install-recommends \
			php5-mysql \
			#
		;;
	*)
		apt-get -y install --no-install-recommends \
			php-mysql \
			#
		;;
	esac
	# TODO performance tuning
	;;
esac

apt-get -y install --no-install-recommends \
	aspell \
	graphviz \
	#

