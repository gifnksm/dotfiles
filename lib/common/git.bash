is_executed && return

ensure_git_config_added() {
    local key="${1}"
    local value="${2}"

    if ! command -v git >/dev/null; then
        if is_dry_run; then
            info "may set git config ${key}[] = ${value}"
            return
        fi

        warn "git is not installed. skip git config: ${key}[] = ${value}"
        return "${WARN_EXIT_CODE}"
    fi

    ensure_file_exists ~/.config/git/config

    if git config --get --global --fixed-value "${key}" "${value}" >/dev/null; then
        trace "git config already exists: ${key}[] = ${value}"
        return
    fi

    ACTION="setting git config ${key}[] = ${value}" execute git config --global --add "${key}" "${value}"
}

ensure_git_config_unset() {
    local key="${1}"
    local value="${2}"

    if ! command -v git >/dev/null; then
        if is_dry_run; then
            info "may unset git config ${key} = ${value}"
            return
        fi
        info "git is not installed. skip git config removal: ${key}=${value}"
        return "${WARN_EXIT_CODE}"
    fi

    if ! git config --get --global --fixed-value "${key}" "${value}" >/dev/null; then
        trace "git config is not set: ${key} = ${value}"
        return
    fi

    ACTION="unsetting git config ${key} = ${value}" execute git config --unset --global --fixed-value "${key}" "${value}"
}

ensure_git_config_included() {
    local filename="${1}"

    ensure_symlink_to_config_exists .config/git/config.d/"${filename}"
    if ! [[ -e ~/.config/git/config.d/index ]]; then
        ensure_line_in_file "[include]" ~/.config/git/config.d/index
        local path
        for path in ~/.config/git/config.d/*.conf; do
            ensure_line_in_file "path = ${path}" ~/.config/git/config.d/index
        done
    fi
    ensure_line_in_file "path = ${filename}" ~/.config/git/config.d/index
}
