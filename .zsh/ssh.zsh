function ssh_add_key() {
  ssh-add -l > /dev/null || ssh-add -t 1800 $@
}

function ssh_screen() {
    eval local server=\${$#}
    ssh_add_key
    screen -t $server /usr/bin/ssh "$@"
}

function ssh_tmux() {
    eval local server=\${$#}
    ssh_add_key
    tmux -q \
        set set-remain-on-exit on \; \
        new-window -n "${server}" "TERM=xterm-256color /usr/bin/ssh $@" \; \
        set set-remain-on-exit off
}

function ssh_with_key() {
    ssh_add_key
    /usr/bin/ssh $@
}

eval $(keychain --nogui --eval --agents ssh --timeout 30 -q)

if [ -n "$STY" ]; then
    alias ssh=ssh_screen
elif [ -n "$TMUX" ]; then
    alias ssh=ssh_tmux
else
    alias ssh=ssh_with_key
fi
