#!/usr/bin/env bash

# Install packages to work with printers

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install \
	cups \
	cups-bsd \
	cups-client \
	foomatic-db-engine \
	hplip \
	hp-ppd \
	openprinting-ppds \
	printer-driver-all \
	#
