#!/usr/bin/env bash

# Install and setup Docker

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

codename=${codename:-$(lsb_release -cs)}
operator=${operator:-$(id -rnu 1000 2>/dev/null)}

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
cat >/etc/apt/sources.list.d/docker.list <<-EOF
	deb https://download.docker.com/linux/debian $codename stable
EOF

apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io

# Package already add docker group
adduser "$operator" docker

if [[ -z ${docker_skip_hello:-} ]]; then
	su - "$operator" -c "docker run hello-world"
	su - "$operator" -c "docker rmi -f hello-world"
fi

systemctl stop docker && systemctl disable docker
