#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y update

apt-get -y install --no-install-recommends \
	jq \
	rake \
	ruby \
	#
