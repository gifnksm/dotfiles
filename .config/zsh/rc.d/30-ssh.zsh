function ssh_add_key() {
  ssh-add -l > /dev/null || ssh-add -t 1800 $@
}

function ssh_tmux() {
    local cmd="${argv}"
    ssh_add_key
    tmux -q \
        set-hook window-linked 'set remain-on-exit on' \; \
        new-window -n "${cmd}" "TERM=xterm-256color /usr/bin/ssh $cmd"
    tmux -q \
        set-hook -u window-linked
}
function pssh_tmux() {
    local cmd="${argv}"
    tmux -q \
        set-hook window-linked 'set remain-on-exit on' \; \
        new-window -n "${cmd}" "TERM=xterm-256color pssh $cmd"
    tmux -q \
        set-hook -u window-linked
}

function ssh_with_key() {
    ssh_add_key
    /usr/bin/ssh $@
}

which keychain > /dev/null 2>&1 && eval $(keychain --nogui --eval --agents ssh --timeout 30 -q)

if [ -n "$TMUX" ]; then
    alias ssh=ssh_tmux
    alias pssh=pssh_tmux
else
    alias ssh=ssh_with_key
fi
