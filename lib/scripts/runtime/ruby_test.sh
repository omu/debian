#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

ruby --version

if [[ -n ${ruby_use_suites:-} ]]; then
	goss -g - validate --format documentation <<-EOF
		command:
		which ruby:
		exit-status: 0
		stdout:
		- /usr/local/bin/ruby
		which rake:
		exit-status: 0
		stdout:
		- /usr/local/bin/rake
		which gem:
		exit-status: 0
		stdout:
		- /usr/local/bin/gem
		which bundler:
		exit-status: 0
		stdout:
		- /usr/local/bin/bundler
	EOF

	# Confirm jemalloc support
	ruby -r rbconfig -e "puts RbConfig::CONFIG['LIBS']" | grep -q jemalloc
fi
