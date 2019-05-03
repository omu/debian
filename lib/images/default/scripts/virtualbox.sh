<%# vim: set ft=eruby: -%>
<%- skip unless meta.virtual == 'virtualbox' -%>
#!/usr/bin/env bash

# Install VirtualBox guest additions inside guest

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

required=(
	bzip2
	dkms
	linux-headers-"$(uname -r)"
	make
)

missing=()
for package in "${required[@]}"; do
	# shellcheck disable=2016
	if [[ -z "$(dpkg-query -W -f='${Installed-Size}' "$package" 2>/dev/null ||:)" ]]; then
		missing+=("$package")
	fi
done

# Install virtualbox additions build dependancies
apt-get -y install --no-install-recommends "${missing[@]}"

mount /dev/sr1 /mnt
while [[ ! -f /mnt/VBoxLinuxAdditions.run ]]; do sleep 1; done

REMOVE_INSTALLATION_DIR=0 sh /mnt/VBoxLinuxAdditions.run --nox11 --target /tmp/VBoxGuestAdditions ||
echo >&2 "vbguest installer exit code $? is suppressed"

rm -rf /tmp/VBoxGuestAdditions
umount /mnt
eject /dev/sr1 ||
echo >&2 "eject exit code $? is suppressed"

# Workaround for periodic Virtualbox bugs
if [[ ! -f $(readlink -f /sbin/mount.vboxsf) ]]; then
	[[ -x /usr/lib/VBoxGuestAdditions/mount.vboxsf ]] || exit 1
	ln -sf /usr/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf
fi

# Start the newly build driver
systemctl start vboxadd

# Cleanup build stuff
apt-get -y purge --auto-remove "${missing[@]}"

# Hold kernel packages for safe upgrades
{ dpkg -l linux-headers-* 2>/dev/null || true; } | awk '/^ii/ { print $2 " "  "hold" }' | dpkg --set-selections
<%= meta.virtualbox -%>
