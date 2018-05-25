#!/usr/bin/env bash

# Setup locale

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

locale=${locale:-en_US.UTF-8}

apt-get -y --no-install-recommends install locales

debconf-set-selections <<-EOF
	locales locales/locales_to_be_generated multiselect tr_TR.UTF-8 UTF-8, en_US.UTF-8 UTF-8
	locales locales/default_environment_locale select $locale
EOF

if [[ -f /etc/locale.gen ]]; then
	rm -f /etc/locale.gen
	dpkg-reconfigure -f noninteractive locales
else
	locale-gen tr_TR.UTF-8 en_US.UTF-8
fi

update-locale LANG="$locale"
