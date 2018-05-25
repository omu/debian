#!/usr/bin/env bash

# Install PHP FPM for server deployments

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

case $(lsb_release -sc) in
jessie)
	apt-get -y install --no-install-recommends \
		php5-fpm \
		#
	apt-get -y install --no-install-recommends \
		php5 \
		#

	apt-get -y install --no-install-recommends \
		php5-mysql \
		#
	;;
*)
	apt-get -y install --no-install-recommends \
		php-fpm \
		#

	apt-get -y install --no-install-recommends \
		php \
		#

	apt-get -y install --no-install-recommends \
		php-mysql \
		#
	;;
esac

IFS=$'.' read -r major minor _ < <(php -r 'echo PHP_VERSION . "\n";')
if [[ $major -lt 7 ]]; then
	service="php${major}-fpm"
else
	service="php${major}.${minor}-fpm"
fi
systemctl stop "$service" && systemctl disable "$service"
