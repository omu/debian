# Attach main tmux session (default 0)
if tmux has-session -t 0 2>/dev/null && [[ -z $LC_TMUX_ALONE ]]; then
	current=$(tmux display-message -p '#S')
	tmux switch -t 0
	! [[ -x /etc/tmux/hook/client-attached ]] || /etc/tmux/hook/client-attached
	[[ $current == "0" ]] || tmux kill-session -t "$current"
fi
unset current
