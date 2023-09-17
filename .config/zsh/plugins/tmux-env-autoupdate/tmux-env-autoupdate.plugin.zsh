→tmux-env-autoupdate:hook:preexec() {
    if [[ -z "${TMUX}" ]]; then
        return
    fi

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
add-zsh-hook preexec →tmux-env-autoupdate:hook:preexec
