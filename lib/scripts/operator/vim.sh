#!/bin/bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x

export DEBIAN_FRONTEND=noninteractive

cd "$(dirname "$0")/../../.."

operator=${operator:-$(id -rnu 1000 2>/dev/null)}

shopt -s nullglob

apt-get -y install --no-install-recommends vim
[[ -z $(echo etc/vim/*) ]] || cp -a etc/vim/* /etc/vim

update-alternatives --set editor /usr/bin/vim.basic
su - "$operator" -c 'echo "SELECTED_EDITOR=/usr/bin/vim.basic" >~/.selected_editor'

# Support user wide plugin installation
mkdir -p /etc/vim/autoload
curl -Lo /etc/vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create a sample vimrc
su - "$operator" -c 'mkdir -p ~/.vim/plugged'
su - "$operator" -c 'cat >~/.vimrc'<<-'EOF'
	" Uncomment and run :PlugInstall to install plugins
	call plug#begin('~/.vim/plugged')
	" Plug 'fatih/vim-go'
	" Plug 'scrooloose/syntastic'
	call plug#end()
EOF

# Minimal system-wide Vim configuration
! [[ -d /etc/vim/pack/dist/start/vim-sensible ]] || rm -rf /etc/vim/pack/dist/start/vim-sensible
git clone --depth 1 https://github.com/tpope/vim-sensible.git /etc/vim/pack/dist/start/vim-sensible
! [[ -d /etc/vim/pack/dist/start/tcomment_vim ]] || rm -rf /etc/vim/pack/dist/start/tcomment_vim
git clone --depth 1 https://github.com/tomtom/tcomment_vim.git /etc/vim/pack/dist/start/tcomment_vim

if ! vim --version | grep -q -w '+packages'; then
	cat >/etc/vim/vimrc.local <<-'EOF'
		set runtimepath+=/etc/vim/pack/dist/start/alaturka
		set runtimepath+=/etc/vim/pack/dist/start/vim-sensible
		set runtimepath+=/etc/vim/pack/dist/start/tcomment_vim
	EOF
fi
