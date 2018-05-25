#!/usr/bin/env bash

# Install Ruby development environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

ruby_use_experimental=${ruby_use_experimental:-}
ruby_use_jemalloc=${ruby_use_jemalloc:-}
ruby_install_latest=${ruby_install_latest:-}

fix() {
	[[ ! -f "$1" ]] || sed -i '/BEGIN FIX/,/END FIX/d' "$1"
	{ echo "# BEGIN FIX"; cat; echo "# END FIX"; } >>"$1"
}

# Install basic Ruby runtime
if [[ -n ${ruby_use_experimental:-} ]] && apt-cache policy ruby | grep -q experimental/main; then
	apt-get -t experimental -y install --no-install-recommends ruby ruby-dev rake
else
	apt-get -y install --no-install-recommends ruby ruby-dev rake
fi

# No documents while installing Ruby gems
fix /etc/gemrc <<-EOF
	gem: --no-document
EOF

if [[ -n $ruby_install_latest ]] || [[ -n $ruby_use_jemalloc ]]; then
	if ! command -v upgrade-ruby &>/dev/null; then
		curl -fsSL "https://raw.githubusercontent.com/omu/debian/master/bin/upgrade-ruby" >/usr/local/bin/upgrade-ruby
		chmod +x /usr/local/bin/upgrade-ruby
	fi

	apt-get -y install --no-install-recommends libjemalloc-dev
	[[ -z $ruby_use_jemalloc ]] || export RUBY_CONFIGURE_OPTS="--with-jemalloc"

	upgrade-ruby
fi

gem install \
	bundler \
	tty \
	#
