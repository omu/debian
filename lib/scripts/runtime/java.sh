#!/usr/bin/env bash

# Install Java headless runtime environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends \
	# install an old version for legacy applications
	openjdk-8-jre-headless \
	default-jre-headless \
	#
