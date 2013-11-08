function ssh_screen() {
    eval local server=\${$#}
    screen -t $server /usr/bin/ssh "$@"
}

function ssh_tmux() {
    eval local server=\${$#}
    tmux -q \
        set set-remain-on-exit on\; \
        new-window -n "${server}" "/usr/bin/ssh $@" \; \
        set set-remain-on-exit off
}

if [ -n "$STY" ]; then
    alias ssh=ssh_screen
elif [ -n "$TMUX" ]; then
    alias ssh=ssh_tmux
fi
