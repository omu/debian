# Print a banner
if [[ -o interactive ]]; then
	if type banner &>/dev/null; then
		banner
	fi
	# shellcheck disable=1003
	[[ -z ${TMUX:-} ]] || printf '\033khoşgeldin\033\\'
fi
