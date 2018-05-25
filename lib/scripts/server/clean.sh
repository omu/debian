#!/usr/bin/env bash

# Extra cleanup for server installations

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

# Remove documentation
rm -rf /usr/share/man/*
rm -rf /usr/share/info/*
rm -rf /usr/share/doc/*
