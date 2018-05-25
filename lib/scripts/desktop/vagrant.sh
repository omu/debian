#!/usr/bin/env bash

# Install Vagrant

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

thirdparty hashicorp vagrant
