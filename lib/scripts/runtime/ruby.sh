#!/usr/bin/env bash

# Install Ruby development environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

ruby_use_suites=${ruby_use_suites:-stable}
ruby_use_experimental=${ruby_use_experimental:-}

fix() {
	[[ ! -f "$1" ]] || sed -i '/BEGIN FIX/,/END FIX/d' "$1"
	{ echo "# BEGIN FIX"; cat; echo "# END FIX"; } >>"$1"
}

if [[ -n ${ruby_use_suites:-} ]]; then
	if ! command -v rubian &>/dev/null; then
		curl -fsSL "https://raw.githubusercontent.com/alaturka/rubian/master/rubian" >/usr/local/bin/rubian
		chmod +x /usr/local/bin/rubian
	fi

	# shellcheck disable=2086
	rubian install $ruby_use_suites
else
	if [[ -n ${ruby_use_experimental:-} ]] && apt-cache policy ruby | grep -q experimental/main; then
		apt-get -t experimental -y install --no-install-recommends ruby ruby-dev rake
	else
		apt-get -y install --no-install-recommends ruby ruby-dev rake
	fi

	# No documents while installing Ruby gems
	fix /etc/gemrc <<-EOF
		gem: --no-document
	EOF

	gem install bundler
fi
