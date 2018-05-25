#!/usr/bin/env bash

# Install basic TeX authoring environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

# Install basic TeX environment
apt-get -y install --no-install-recommends \
	lmodern \
	pandoc \
	pdfjam \
	texlive-fonts-recommended \
	texlive-lang-european \
	texlive-latex-extra \
	texlive-xetex \
	#
