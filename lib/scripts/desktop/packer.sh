#!/usr/bin/env bash

# Install Packer

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

thirdparty hashicorp packer
