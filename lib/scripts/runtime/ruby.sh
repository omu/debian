#!/usr/bin/env bash

# Install Ruby development environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

ruby_install_versions=${ruby_install_versions:-2.6.3}
ruby_keep_system_ruby=${ruby_keep_system_ruby:-}

system_ruby_packages=(
	ruby
	ruby-dev
	rake
)

if ! command -v rubian &>/dev/null; then
	curl -fsSL "https://raw.githubusercontent.com/omu/rubian/master/rubian" >/usr/local/bin/rubian
	chmod +x /usr/local/bin/rubian
fi

# Remove previously installed bundler gem to minimize problem surface
if command -v gem &>/dev/null && gem list -i bundler &>/dev/null; then
	gem uninstall bundler
fi

# Purge system Ruby
if [[ -z ${ruby_keep_system_ruby:-} ]] && [[ -x /usr/bin/ruby ]]; then
	apt-get -y --auto-remove purge "${system_ruby_packages[@]}" ruby-bundler
	rubian relink
fi

# shellcheck disable=2086
rubian install $ruby_install_versions
