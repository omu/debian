#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

if [[ -n ${kvm_allow_nested:-} ]]; then
	for module in kvm_intel kvm_amd; do
		if [[ -f "/sys/module/$module/parameters/nested" ]]; then
			grep -E -qi '(y|1)' "/sys/module/$module/parameters/nested"
		fi
	done
fi
