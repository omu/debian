<%# vim: set ft=eruby: -%>
#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive LC_ALL=C LANG=C

while ! ip route get 1.1.1.1 &>/dev/null; do
	sleep 0.1
done

declare -ag packages=()

<%- if meta.packages -%>
packages+=(<%= meta.packages %>)
<%- end -%>
<%- case meta.virtual; when 'lxc' -%>
packages+=(curl ca-certificates sudo gnupg ssh)
<%- when 'docker' -%>
packages+=(curl ca-certificates sudo gnupg)
<%- end -%>

apt-get -y update
apt-get -y install --no-install-recommends "${packages[@]}"
<%= meta.pre -%>
<%= meta.pre_virtual -%>
