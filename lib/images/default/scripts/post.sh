<%# vim: set ft=eruby: -%>
#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive LC_ALL=C LANG=C

<%= meta.post -%>
<%= meta.post_virtual -%>
