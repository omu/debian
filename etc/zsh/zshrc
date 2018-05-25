# /etc/zsh/zshrc: system-wide .zshrc file for zsh(1).
#
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

for f in {/etc,/usr/local/etc}/zsh/zshrc.d/*.sh(.N); do
	source "$f"
done
unset f
