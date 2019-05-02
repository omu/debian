<%# vim: set ft=eruby: -%>
<%- skip unless options.comprehensive && param.provision_test -%>
#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive LC_ALL=C LANG=C

<%= param.provision_test -%>
