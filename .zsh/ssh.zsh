function ssh_add_key() {
  ssh-add -l > /dev/null || ssh-add -t 1800 $@
}

function ssh_screen() {
    local cmd="${argv}"
    ssh_add_key
    screen -t "$cmd" /usr/bin/ssh "$cmd"
}

function ssh_tmux() {
    local cmd="${argv}"
    ssh_add_key
    tmux -q \
        set set-remain-on-exit on \; \
        new-window -n "${cmd}" "TERM=xterm-256color /usr/bin/ssh $cmd" \; \
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
