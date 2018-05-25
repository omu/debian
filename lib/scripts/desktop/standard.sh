#!/usr/bin/env bash

# Standard (albeit not essential) installation for desktop environment

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

# Install Dropbox
apt-get -y install nautilus-dropbox # install recommends
