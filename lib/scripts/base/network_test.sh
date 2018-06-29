#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

case "$(lsb_release -sc)" in
xenial|jessie|stretch|sid)
	goss -g - validate --format documentation <<-EOF
		service:
		  systemd-networkd:
		    enabled: true
		    running: true
		  systemd-resolved:
		    enabled: true
		    running: true
		  networking:
		    enabled: false
		    running: false
		command:
		  networkctl --no-legend --no-pager:
		    exit-status: 0
		    stdout:
		      - /e.+\\s+ether\\s+routable\\s+configured/
		dns:
		  A:example.com:
		    resolvable: true
	EOF
	;;
esac
