<%# vim: set ft=eruby: -%>
#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive LC_ALL=C LANG=C

<%= param.post -%>
<%= param.post_virtual -%>
