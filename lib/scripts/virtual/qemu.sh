#!/usr/bin/env bash

# Setup QEMU guest

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

apt-get -y install --no-install-recommends qemu-guest-agent spice-vdagent nfs-common

# Install guest agent for Huawei FusionCompute
sha256=507181f2cb720d1b8626dbcacd78cd45465f963eba29c2fdd6cf7ce847bc4458

curl -fL --retry 3 -o vmtools.tar.xz https://file.omu.sh/huawei-vmtools.tar.xz
echo "$sha256 vmtools.tar.xz" | sha256sum -c -
tar -xJf vmtools.tar.xz -C .
rm -f vmtools.tar.xz

pushd vmtools
./install || echo >&2 "vmtools installer exit code $? is suppressed"
popd

rm -rf vmtools

systemctl stop vm-agent && systemctl disable vm-agent
