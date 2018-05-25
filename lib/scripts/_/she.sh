#!/usr/bin/env bash

# Install She (Shell extensions)

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

curl -fsSL https://raw.githubusercontent.com/alaturka/she/master/she >/usr/local/bin/she
chmod +x /usr/local/bin/she
