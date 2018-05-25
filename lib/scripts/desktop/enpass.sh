#!/usr/bin/env bash

# Install Enpass

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

thirdparty enpass enpass
