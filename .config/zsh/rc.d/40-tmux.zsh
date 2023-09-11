function _update_tmux_env() {
    unset $(tmux show-env | sed -n 's/^-//p')
    eval export $(tmux show-env | sed -n 's/$/"/; s/=/="/p') >/dev/null
}

if [ -n "${TMUX}" ]; then
    autoload -Uz add-zsh-hook
    add-zsh-hook preexec _update_tmux_env
fi
