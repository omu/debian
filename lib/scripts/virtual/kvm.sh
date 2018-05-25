#!/usr/bin/env bash

# Setup optional KVM settings

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

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
