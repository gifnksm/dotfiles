if command -v keychain >/dev/null; then
    eval "$(keychain --nogui --eval --agents ssh --timeout 30 -q)"
fi

if [ -n "$TMUX" ]; then
    function ssh_tmux() {
        local cmd="${argv}"
        tmux -q \
            set-hook window-linked 'set remain-on-exit on' \; \
            new-window -n "${cmd}" "TERM=xterm-256color /usr/bin/ssh $cmd"
        tmux -q \
            set-hook -u window-linked
    }

    alias ssh=ssh_tmux
fi
