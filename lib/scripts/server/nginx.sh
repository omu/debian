#!/usr/bin/env bash

# Install Nginx

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

nginx_install_variant=${nginx_install_variant:-extras}

case $nginx_install_variant in
light|full|extras)
	apt-get -y install --no-install-recommends "nginx-$nginx_install_variant"
	;;
"")
	apt-get -y install --no-install-recommends nginx
	;;
*)
	echo >&2 "unknown nginx variant: $nginx_install_variant"
	exit 1
	;;
esac

systemctl stop nginx && systemctl disable nginx
