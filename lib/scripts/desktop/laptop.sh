#!/usr/bin/env bash

# Install packages for a laptop

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install \
	avahi-autoipd \
	bluetooth \
	powertop \
	iw \
	wireless-tools \
	wpasupplicant \
	#
