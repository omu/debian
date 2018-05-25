# Print a banner
if [[ -o interactive ]]; then
	if type welcome &>/dev/null; then
		welcome
	fi
	[[ -z ${TMUX:-} ]] || printf '\033khoşgeldin\033\\'
fi
