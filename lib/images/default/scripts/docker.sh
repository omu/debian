<%# vim: set ft=eruby: -%>
<%- skip unless meta.virtual == 'docker' -%>
#!/usr/bin/env bash

# Setup Docker

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

<%= meta.docker -%>
