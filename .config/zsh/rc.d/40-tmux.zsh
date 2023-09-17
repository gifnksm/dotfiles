if [[ -n "${TMUX}" ]]; then
    function _update_tmux_env() {
        local -a lines=("${(@f)$(tmux show-env)}")
        local line
        for line in "${lines[@]}"; do
            if [[ "${line}" =~ ^- ]]; then
                unset "${line:1}"
            else
                local name="${line%%=*}"
                local value="${line#*=}"
                export "${name}"="${value}"
            fi
        done
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook preexec _update_tmux_env
fi
