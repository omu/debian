#!/usr/bin/env bash

# Install Inspeqtor for simple monitoring needs

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

url="https://packagecloud.io/install/repositories/contribsys/inspeqtor/config_file.list?os=ubuntu&dist=trusty&source=script"
curl -fsSL "$url" >/etc/apt/sources.list.d/inspeqtor.list

url="https://packagecloud.io/contribsys/inspeqtor/gpgkey"
curl -fsSL "$url" | apt-key add -

# FIXME This is a hack.  Under below conditions, can't install packages from
# packagecloud via APT, only cupt works.
if [[ "$(lsb_release -sc)" == jessie ]] && [[ "$(systemd-detect-virt 2>/dev/null || true)" == qemu ]]; then
	apt-get -y install cupt libcupt3-0-downloadmethod-wget
	# Cupt doesn't work with HTTPS
	sed -i -e 's/https:/http:/g' /etc/apt/sources.list.d/inspeqtor.list
	cupt update && cupt -y install inspeqtor
	# Disable inspeqtor repository to avoid APT failures at later stages
	sed -i -e 's/^/# /g' /etc/apt/sources.list.d/inspeqtor.list
	apt-get -y update
else
	apt-get -y update
	apt-get -y install inspeqtor
fi

cp /usr/share/inspeqtor/systemd/inspeqtor.service /etc/systemd/system/

systemctl reenable inspeqtor
systemctl stop inspeqtor && systemctl disable inspeqtor
