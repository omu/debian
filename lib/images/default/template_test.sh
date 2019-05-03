<%# vim: set ft=eruby: -%>
<%- skip unless options.comprehensive && meta.provision_test -%>
#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive LC_ALL=C LANG=C

<%= meta.provision_test -%>
