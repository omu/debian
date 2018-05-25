# Adapted from: https://github.com/myfreeweb/zshuery

autoload colors; colors

setopt auto_name_dirs
setopt pushd_ignore_dups
setopt prompt_subst
setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS
setopt transient_rprompt
setopt extended_glob
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
autoload -U zmv
bindkey '^[m' copy-prev-shell-word
bindkey '^R' history-incremental-pattern-search-backward
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt share_history
setopt append_history
setopt hist_verify
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space

[[ -x /etc/zsh_command_not_found ]] && /etc/zsh_command_not_found

autoload -U compinit
fpath=($* $fpath)
fignore=(.DS_Store $fignore)
compinit -i
compdef mcd=cd
zmodload -i zsh/complist
setopt complete_in_word
setopt auto_remove_slash
unsetopt always_to_end
[[ -f ~/.ssh/known_hosts ]] && hosts=(`awk '{print $1}' ~/.ssh/known_hosts | tr ',' '\n' `)
[[ -f ~/.ssh/config ]] && hosts=($hosts `grep '^Host' ~/.ssh/config | sed s/Host\ // | egrep -v '^\*$'`)
[[ -f /var/lib/misc/ssh_known_hosts ]] && hosts=($hosts `awk -F "[, ]" '{print $1}' /var/lib/misc/ssh_known_hosts | sort -u`)
zstyle ':completion:*' insert-tab pending
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
highlights='${PREFIX:+=(#bi)($PREFIX:t)(?)*==31=1;32}':${(s.:.)LS_COLORS}}
highlights2='=(#bi) #([0-9]#) #([^ ]#) #([^ ]#) ##*($PREFIX)*==1;31=1;35=1;33=1;32=}'
zstyle -e ':completion:*' list-colors 'if [[ $words[1] != kill && $words[1] != strace ]]; then reply=( "'$highlights'" ); else reply=( "'$highlights2'" ); fi'
unset highlights
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:hosts' hosts $hosts
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ./cache/
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:ogg123:*' file-patterns '*.(ogg|OGG):ogg\ files *(-/):directories'
zstyle ':completion:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*' rehash true

setopt correct
alias man='nocorrect man'
alias mv='nocorrect mv'
alias mkdir='nocorrect mkdir'
alias curl='nocorrect curl'
alias rake='nocorrect rake'
alias make='nocorrect make'

case $OSTYPE in
linux*)
	[ -x /usr/bin/dircolors ] && [ -r ~/.dircolors ] &&
		eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	;;
*)
	alias ls='ls -G'
	alias readlink=greadlink
	;;
esac

autoload -U promptinit && promptinit && prompt minimal

autoload -Uz run-help
alias help=run-help

GOPATH=/usr/local
CDPATH=/usr/local/src/github.com
if [[ -d /vagrant/src ]]; then
	GOPATH=$GOPATH:/vagrant
	CDPATH=$CDPATH:/vagrant/src/github.com:/vagrant
elif [[ -d /vagrant ]]; then
	CDPATH=$CDPATH:/vagrant
fi
export GOPATH CDPATH

export SHELL=$(which zsh)

case "$TERM" in
	# Workaround for broken TERM announcements
	xterm) export TERM="xterm-256color" ;;
esac

alias a=apt
alias A='sudo apt'

alias e=editor
alias E='sudo editor'

alias g=git
alias G='sudo git'

alias j=journalctl
alias J='sudo journalctl'

alias l=less
alias L='sudo less'

alias s=systemctl
alias S='sudo systemctl'
