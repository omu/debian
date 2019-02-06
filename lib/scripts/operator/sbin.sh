#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

shopt -s nullglob

[[ -z $(echo sbin/*) ]] || cp sbin/* /usr/local/sbin
