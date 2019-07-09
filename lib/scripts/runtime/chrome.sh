#!/usr/bin/env bash

# Install Chrome driver

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

if [[ -n ${chrome_install_upstream:-} ]]; then
	latest_driver_release=$(
		curl -fsSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE
	)

	if [[ -z $latest_driver_release ]]; then
		echo >&2 "Couldn't determine latest Google Chrome Driver release"
		exit 1
	fi

	curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
	echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >>/etc/apt/sources.list.d/chrome.list
	apt-get -y update

	apt-get -y install --no-install-recommends google-chrome-stable

	# Remove duplicate source lists
	rm -f /etc/apt/sources.list.d/google-chrome*.list

	# shellcheck disable=2016
	sed -i 's+"$HERE/chrome"+"$HERE/chrome" --no-sandbox+g' /opt/google/chrome/google-chrome

	apt-get -y install --no-install-recommends libarchive-tools # for bsdtar

	curl -fsSL https://chromedriver.storage.googleapis.com/"$latest_driver_release"/chromedriver_linux64.zip |
	bsdtar -C /usr/local/bin -o -xvf- - && chmod +x /usr/local/bin/*chrome*
else
	apt-get -y update && apt-get -y install --no-install-recommends chromedriver
fi
