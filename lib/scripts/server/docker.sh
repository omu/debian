#!/usr/bin/env bash

# Install and setup Docker

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/debian \
	$(lsb_release -cs) \
	stable"

apt-get update
apt-get -y install docker-ce

# Package already add docker group
adduser "$operator" docker

if [[ -z ${docker_skip_hello:-} ]]; then
	su - "$operator" -c "docker run hello-world"
	su - "$operator" -c "docker rmi -f hello-world"
fi

systemctl stop docker && systemctl disable docker
