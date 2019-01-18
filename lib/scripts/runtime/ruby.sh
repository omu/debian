#!/usr/bin/env bash

# Install Ruby development environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

ruby_use_suites=${ruby_use_suites:-stable}
ruby_use_experimental=${ruby_use_experimental:-}
ruby_keep_system_ruby=${ruby_keep_system_ruby:-}

fix() {
	[[ ! -f "$1" ]] || sed -i '/BEGIN FIX/,/END FIX/d' "$1"
	{ echo "# BEGIN FIX"; cat; echo "# END FIX"; } >>"$1"
}

system_ruby_packages=(
	ruby
	ruby-dev
	rake
)

if [[ -n ${ruby_use_suites:-} ]]; then
	if ! command -v rubian &>/dev/null; then
		curl -fsSL "https://raw.githubusercontent.com/omu/rubian/master/rubian" >/usr/local/bin/rubian
		chmod +x /usr/local/bin/rubian
	fi

	# shellcheck disable=2086
	rubian install $ruby_use_suites

	# Purge system Ruby
	if [[ -z ${ruby_keep_system_ruby:-} ]] && [[ -x /usr/bin/ruby ]]; then
		apt-get -y --auto-remove purge "${system_ruby_packages[@]}" ruby-bundler
		rubian relink
	fi
else
	if [[ -n ${ruby_use_experimental:-} ]] && apt-cache policy ruby | grep -q experimental/main; then
		apt-get -t experimental -y install --no-install-recommends "${system_ruby_packages[@]}"
	else
		apt-get -y install --no-install-recommends "${system_ruby_packages[@]}"
	fi

	# No documents while installing Ruby gems
	fix /etc/gemrc <<-EOF
		gem: --no-document
	EOF

	gem install bundler
fi
