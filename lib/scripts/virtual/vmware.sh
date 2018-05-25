#!/usr/bin/env bash

# Install VMWare tools inside guest

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

packages=(fuse open-vm-tools)
if [[ -n "$(dpkg-query -W -f='${Installed-Size}' xserver-xorg-core 2>/dev/null || true)" ]]; then
	packages+=(open-vm-tools-desktop)
fi

# Install required packages with recommends
if [[ $(lsb_release -sc) == jessie ]]; then
	if ! grep -E -qR '^deb\s.+\sjessie-backports\s.+' /etc/apt; then
		cat >/etc/apt/sources.list.d/backports.list <<-EOF
			deb http://ftp.debian.org/debian jessie-backports main contrib non-free
		EOF
		apt-get -y update
	fi
	apt-get -y install -t jessie-backports "${packages[@]}"
else
	apt-get -y install "${packages[@]}"
fi

if [[ -z ${vmware_hgfs_options:-} ]]; then
	options=(-o allow_other -o auto_unmount)
	if [[ -n ${operator:-} ]] &&  id=$(id -u "$operator" 2>/dev/null); then
		options+=(
			"-o"
			"uid=$id"
			"-o"
			"gid=$id"
		)
	fi
else
	# shellcheck disable=SC2206
	options=($vmware_hgfs_options)
fi

cat >/etc/systemd/system/hgfs.service <<-EOF
[Unit]
Description=Load VMware shared folders
Requires=open-vm-tools.service
After=open-vm-tools.service
ConditionVirtualization=vmware
ConditionPathIsDirectory=/mnt/hgfs
ConditionFileIsExecutable=/usr/local/bin/hgfs

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=
ExecStart=/usr/local/bin/hgfs ${options[@]} .host:/ /mnt/hgfs

[Install]
WantedBy=multi-user.target
EOF

cat >/usr/local/bin/hgfs <<'EOF'
#!/bin/sh

set -e

if [ -x /usr/bin/vmware-hgfsclient ]; then
	if ! shared=$(/usr/bin/vmware-hgfsclient 2>/dev/null); then
		echo >&2 "$0: folder sharing disabled"
		exit 0
	fi

	if [ -z "$shared" ]; then
		echo >&2 "$0: nothing shared"
		exit 0
	fi
fi

/usr/bin/vmhgfs-fuse "$@"
EOF
chmod +x /usr/local/bin/hgfs

mkdir -p /mnt/hgfs

systemctl enable hgfs.service
systemctl start hgfs.service
