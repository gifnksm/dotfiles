function ssh_screen() {
    eval local server=\${$#}
    ssh-add -l >/dev/null || ssh-add
    screen -t $server /usr/bin/ssh "$@"
}

function ssh_tmux() {
    eval local server=\${$#}
    ssh-add -l >/dev/null || ssh-add
    tmux -q \
        set set-remain-on-exit on\; \
        new-window -n "${server}" "/usr/bin/ssh $@" \; \
        set set-remain-on-exit off
}

function ssh_with_key() {
    ssh-add -l >/dev/null || ssh-add
    /usr/bin/ssh $@
}

eval $(keychain --nogui --eval --agents ssh -q)

if [ -n "$STY" ]; then
    alias ssh=ssh_screen
elif [ -n "$TMUX" ]; then
    alias ssh=ssh_tmux
else
    alias ssh=ssh_with_key
fi
