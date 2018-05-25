#!/usr/bin/env bash

# Install and setup Wordpress

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

wordpress_install_cli=${wordpress_install_cli:-}

apt-get -y install --no-install-recommends \
	wordpress \
	wordpress-l10n \
	#

case $(lsb_release -sc) in
jessie)
	apt-get -y install --no-install-recommends \
		php5-ssh2 \
		#
	;;
*)
	apt-get -y install --no-install-recommends \
		php-ssh2 \
		#
	;;
esac

if [[ -n $wordpress_install_cli ]]; then
	curl -fsSL -o /usr/local/bin/wp \
		https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
fi
