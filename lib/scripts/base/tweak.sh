#!/usr/bin/env bash

# Tweak system for a better console experience

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

tweak_keep_motd=${tweak_keep_motd:-}
tweak_kernel_logs=${tweak_kernel_logs:-'3 4 1 4'}

fix() {
	[[ ! -f "$1" ]] || sed -i '/BEGIN FIX/,/END FIX/d' "$1"
	{ echo "# BEGIN FIX"; cat; echo "# END FIX"; } >>"$1"
}

# Tweak sshd:
#   - to prevent DNS resolution (speed up logins)
#   - to keep long SSH connections running, especially for assets precompilation
#   - to accept pass_* environment variables
#   - to disable last login messages (optionally)
{
	cat <<-EOF
		UseDNS no
		AllowAgentForwarding yes
		ClientAliveInterval 60
		ClientAliveCountMax 60
		AcceptEnv LANG LC_* pass_*
	EOF
	[[ -n $tweak_keep_motd ]] || echo PrintLastLog no
} | fix /etc/ssh/sshd_config
systemctl restart ssh

if [[ -z $tweak_keep_motd ]]; then
	for f in /etc/pam.d/login /etc/pam.d/sshd; do
		[[ -f $f ]] || continue
		sed -e '/session.*motd/ s/^#*/#/' -i "$f"
	done
	rm -f /etc/motd
fi

# Remove 5s grub timeout to speed up booting
cat >/etc/default/grub <<-EOF
	# If you change this file, run 'update-grub' afterwards to update
	# /boot/grub/grub.cfg.

	GRUB_DEFAULT=0
	GRUB_TIMEOUT=0
	GRUB_DISTRIBUTOR=$(lsb_release -i -s 2>/dev/null || echo Debian)
	GRUB_CMDLINE_LINUX_DEFAULT="quiet"
	GRUB_CMDLINE_LINUX="debian-installer=en_US.UTF-8"
EOF
! command -v update-grub 2>/dev/null || update-grub

# Setup kernel log levels
[[ -z $tweak_kernel_logs ]] || sysctl -w kernel.printk="$tweak_kernel_logs" ||
echo >&2 "sysctl exit code $? is suppressed"

# No speaker
[[ -d /etc/modprobe.d ]] && echo "blacklist pcspkr" >/etc/modprobe.d/nobeep.conf

# Disable downloading translations
echo 'Acquire::Languages "none";' >/etc/apt/apt.conf.d/99translations
