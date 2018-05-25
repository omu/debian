#!/usr/bin/env bash

# Setup staff group policy

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

# Primary user should be a member of staff group
adduser "$operator" staff

shopt -s nullglob

# Setup staff writable directories
chown -R root:staff /usr/local
chmod 2775 /usr/local /usr/local/*
