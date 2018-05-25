#!/usr/bin/env bash

# Install Virtualbox and extensions

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

thirdparty oracle virtualbox virtualbox-extensions
