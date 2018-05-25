#!/usr/bin/env bash

# Install PHP runtime environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

case $(lsb_release -sc) in
jessie)
	apt-get -y install --no-install-recommends \
		php5-cli \
		#

	apt-get -y install --no-install-recommends \
		php5-gd \
		php5-mcrypt \
		php5-sqlite \
		#
	;;
*)
	apt-get -y install --no-install-recommends \
		php-cli \
		#

	apt-get -y install --no-install-recommends \
		php-gd \
		php-sqlite3 \
		#
	;;
esac

# TODO: composer
