#!/usr/bin/env bash

# Install Shellcheck for shell script linting

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

sudo apt-get install -y --no-install-recommends lsb-release

case $(lsb_release -sc) in
trusty)
	sudo apt-get install -y --no-install-recommends software-properties-common
	sudo apt-add-repository "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe"
	sudo apt-get update
	sudo apt-get install -y --no-install-recommends -t trusty-backports shellcheck
	;;
*)
	sudo apt-get install -y --no-install-recommends shellcheck
	;;
esac
