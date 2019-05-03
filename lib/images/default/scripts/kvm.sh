<%# vim: set ft=eruby: -%>
<%- skip unless meta.virtual == 'kvm' -%>
#!/usr/bin/env bash

# Setup QEMU guest

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends qemu-guest-agent spice-vdagent nfs-common
<%= meta.kvm -%>
