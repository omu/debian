#!/usr/bin/env bash

# Install Chrome driver

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

if [[ -n ${chrome_install_upstream:-} ]]; then
	curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
	echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >>/etc/apt/sources.list.d/chrome.list
	apt-get -y update

	apt-get -y install --no-install-recommends google-chrome-stable
	# shellcheck disable=2016
	sed -i 's+"$HERE/chrome"+"$HERE/chrome" --no-sandbox+g' /opt/google/chrome/google-chrome
fi

apt-get -y update && apt-get -y install --no-install-recommends chromedriver
