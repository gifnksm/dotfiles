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
        cur_value="$(git config --get --global "${key}")"
        if [[ "${cur_value}" != "${value}" ]]; then
            warn "git config already exists, which has different value: ${key} = ${cur_value}, expected ${value}"
            return "${WARN_EXIT_CODE}"
        fi

        trace "git config already exists: ${key} = ${cur_value}"
        return
    fi

    git config --global "${key}" "${value}"
    info "git config set: ${key} = ${value}"
}

ensure_git_config_added() {
    local key="${1}"
    local value="${2}"

    if ! command -v git >/dev/null; then
        warn "git is not installed. skip git config (${key}=${value})"
        return "${WARN_EXIT_CODE}"
    fi

    ensure_file_exists ~/.config/git/config

    if git config --get --global --fixed-value "${key}" "${value}" >/dev/null; then
        trace "git config already exists: ${key} = ${value}"
        return
    fi

    git config --global --add "${key}" "${value}"
    info "git config added: ${key} = ${value}"
}

ensure_git_config_unset() {
    local key="${1}"
    local value="${2}"

    if ! command -v git >/dev/null; then
        info "git is not installed. skip git config removal (${key}=${value})"
        return "${WARN_EXIT_CODE}"
    fi

    if ! git config --get --global --fixed-value "${key}" "${value}" >/dev/null; then
        trace "git config is not set: ${key} = ${value}"
        return
    fi

    git config --unset --global --fixed-value "${key}" "${value}"
    info "git config unset: ${key} = ${value}"

}

check_git_config() {
    local key="${1}"
    if ! git config "${key}" >/dev/null; then
        warn "git config ${key} is not set"
        return
    fi

    trace "git config ${key} is set: $(git config "${key}")"
}

ensure_git_config_included() {
    local filename="${1}"

    ensure_symlink_to_config_exists .config/git/config.d/"${filename}"
    if ! [[ -e ~/.config/git/config.d/index ]]; then
        echo "[include]" >>~/.config/git/config.d/index
        local path
        for path in ~/.config/git/config.d/*.conf; do
            ensure_line_in_file "path = ${path}" ~/.config/git/config.d/index
        done
    fi

    ensure_line_in_file "path = ${filename}" ~/.config/git/config.d/index
}
