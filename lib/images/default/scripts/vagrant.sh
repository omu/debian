<%# vim: set ft=eruby: -%>
#!/usr/bin/env bash

# Setup Vagrant environment inside guest

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

# Set up passwordless sudo
echo "$operator ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Install vagrant keys
home=$(eval echo ~"$operator")
mkdir -p "$home"/.ssh
chmod 700 "$home"/.ssh
curl -fsSkL -o "$home"/.ssh/authorized_keys \
  'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub'
chown -R "$operator:$operator" "$home"/.ssh
chmod -R go-rwsx "$home"/.ssh

# Fix stdin not being a tty
if grep -q -E "^mesg n$" /root/.profile && sed -i "s/^mesg n$/tty -s \\&\\& mesg n/g" /root/.profile; then
	echo "Fixed stdin not being a tty."
fi
<%= meta.vagrant -%>
<%= meta.vagrant_virtual -%>
