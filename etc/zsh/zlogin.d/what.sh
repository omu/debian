# Print a banner
if [[ -o interactive ]]; then
	if type what &>/dev/null; then
		what
	fi
	# shellcheck disable=1003
	[[ -z ${TMUX:-} ]] || printf '\033khoşgeldin\033\\'
fi
