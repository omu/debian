#!/usr/bin/env bash

# Setup QEMU/KVM guest

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

kvm_huawei_support=${kvm_huawei_support:-true}

apt-get -y install --no-install-recommends qemu-guest-agent spice-vdagent nfs-common
systemctl stop spice-vdagent && systemctl disable spice-vdagent # optional

if [[ -n ${kvm_huawei_support:-} ]]; then
	codename=$(lsb_release -sc)

	# Install guest agent for Huawei FusionCompute
	sha256=SHA256SUMS
	blob=vendor.tar.xz

	curl -fL --retry 3 -o "$blob" https://file.omu.sh/drv/"$codename"/"$blob"
	curl -fL --retry 3 -o "$sha256" https://file.omu.sh/drv/"$codename"/"$sha256"
	sha256sum -c --quiet "$sha256" && tar -xJf "$blob" -C .
	rm -f "$blob" "$sha256"

	pushd vmtools
	./install || echo >&2 "vmtools installer exit code $? is suppressed"
	popd

	rm -rf vmtools

	systemctl stop vm-agent && systemctl disable vm-agent
fi

if [[ -n ${kvm_allow_nested:-} ]]; then
	cat >/etc/modprobe.d/kvm.conf <<-EOF
		options kvm ignore_msrs=1
	EOF
	cat >/etc/modprobe.d/kvm-intel.conf <<-EOF
		options kvm-intel nested=y ept=n
	EOF
	cat >/etc/modprobe.d/kvm-amd.conf <<-EOF
		options kvm-amd nested=y
	EOF

	for module in kvm_intel kvm_amd; do
		if modinfo "$module" >/dev/null 2>&1; then
			modprobe -r "$module"
			modprobe    "$module"
		fi 2>/dev/null || true
	done
fi
