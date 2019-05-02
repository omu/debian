<%# vim: set ft=eruby: -%>
<%- skip unless param.virtual == 'lxc' -%>
#!/usr/bin/env bash

# Setup LXC container

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-<%= param.username %>}
password=${password:-<%= param.password %>}

if current=$(id -rnu 1000 2>/dev/null); then
	if [[ ! $current = "$operator" ]]; then
		ps -o pid= -u "$current" 2>/dev/null | xargs kill -9 || true
		sleep 1

		usermod -l "$operator" -d /home/"$operator" -m "$current" -c 'Operator'
		groupmod -n "$operator" "$current"

		for f in /etc/subuid{,-} /etc/subgid{,-}; do
			[[ -f $f ]] || continue
			sed -e "s/^$current:/$operator:/" -i "$f"
		done
	fi
else
	adduser --uid 1000 --disabled-password --gecos 'Operator,,,' "$operator"
fi

echo "$password":"$password" | chpasswd
apt-get -y install --no-install-recommends sudo
adduser "$operator" sudo
<%= param.lxc -%>
