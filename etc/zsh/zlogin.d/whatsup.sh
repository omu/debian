# Print a banner
if [[ -o interactive ]]; then
	if type whatsup &>/dev/null; then
		whatsup
	fi
	[[ -z ${TMUX:-} ]] || printf '\033khoşgeldin\033\\'
fi
