<%# vim: set ft=eruby: -%>
<%- skip unless param.virtual == 'kvm' -%>
#!/usr/bin/env bash

# Setup QEMU guest

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends qemu-guest-agent spice-vdagent nfs-common
<%= param.kvm -%>
