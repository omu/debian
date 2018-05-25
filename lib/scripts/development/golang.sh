#!/usr/bin/env bash

# Install Go development environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

if [[ -n ${base_use_experimental:-} ]] || [[ -n ${golang_use_experimental:-} ]]; then
	cat >/etc/apt/preferences.d/golang <<-EOF
		Package: golang
		Pin: release a=experimental
		Pin-Priority: 800
	EOF
	apt-get -y install -t experimental --no-install-recommends golang
else
	apt-get -y install --no-install-recommends golang
fi
