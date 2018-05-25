#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

ruby --version

goss -g - validate --format documentation <<-EOF
	package:
	  ruby:
	    installed: true
	  ruby-dev:
	    installed: true
	  rake:
	    installed: true
	command:
	  ruby --version:
	    exit-status: 0
	    stdout:
	    - "/2.[1-9].[0-9]/"
	    timeout: 10000
	  which bundler:
	    exit-status: 0
	    stdout:
	    - /usr/local/bin/bundler
EOF

# Confirm jemalloc support
[[ -z ${ruby_use_jemalloc:-} ]] || ruby -r rbconfig -e "puts RbConfig::CONFIG['LIBS']" | grep -q jemalloc
