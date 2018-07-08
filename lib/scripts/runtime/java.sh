#!/usr/bin/env bash

# Install Java headless runtime environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

# Install an old version for legacy applications
apt-get -y install --no-install-recommends \
	openjdk-8-jre-headless \
	default-jre-headless \
	#
