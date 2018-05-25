#!/usr/bin/env bash

# Install prefered desktop fonts

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

apt-get -y install --no-install-recommends \
	fonts-inconsolata \
	xfonts-terminus \
	#
