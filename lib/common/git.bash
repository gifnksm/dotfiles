is_executed && return

ensure_git_config() {
    local key="${1}"
    local value="${2}"

    if ! command -v git >/dev/null; then
        warn "git is not installed. skip git config (${key}=${value})"
        return "${WARN_EXIT_CODE}"
    fi

    ensure_file_exists ~/.config/git/config

    if git config --global "${key}" >/dev/null; then
        local cur_value
        cur_value="$(git config --global "${key}")"
        if [[ "${cur_value}" != "${value}" ]]; then
            warn "git config already exists, which has different value: ${key} = ${cur_value}, expected ${value}"
            return "${WARN_EXIT_CODE}"
        fi

        trace "git config already exists: ${key} = ${cur_value}"
        return
    fi

    git config --global "${key}" "${value}"
    info "git congit set: ${key} = ${value}"
}

check_git_config() {
    local key="${1}"
    if ! git config "${key}" >/dev/null; then
        warn "git config ${key} is not set"
        return
    fi

    trace "git config ${key} is set: $(git config "${key}")"
}
