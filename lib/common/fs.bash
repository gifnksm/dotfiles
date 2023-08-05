is_executed && return

ensure_directory_exists() {
    local dir="${1}"

    if [[ -d "${dir}" ]]; then
        trace "directory already exists: ${dir}"
        return
    fi

    mkdir -p "${dir}" | sed 's/^/  /'
    info "directory created: ${dir}"
}

ensure_file_exists() {
    local file="${1}"

    if [[ -f "${file}" ]]; then
        trace "file already exists: ${file}"
        return
    fi

    ensure_directory_exists "$(dirname "${file}")"
    touch "${file}"
    info "file created: ${file}"
}

ensure_symlink_exists() {
    local target="${1}"
    local source="${2}"

    if [[ -L "${source}" ]]; then
        local cur_target
        cur_target="$(readlink "${source}")"
        if [[ "${cur_target}" != "${target}" ]]; then
            warn "symbolic link already exists, which has different target: ${source} -> ${cur_target}"
            return "${WARN_EXIT_CODE}"
        fi
        trace "symbolic link already exists, skip: ${source} -> ${cur_target}"
        return
    fi

    if [[ -e "${source}" ]]; then
        warn "file already exists: ${source}"
        return "${WARN_EXIT_CODE}"
    fi

    ensure_directory_exists "$(dirname "${source}")"
    if [[ -v SUDO ]]; then
        sudo ln -s "${target}" "${source}"
    else
        ln -s "${target}" "${source}"
    fi
    info "symbolic link created: ${source} -> ${target}"
}

ensure_symlink_to_config_exists() {
    local rel_target="${1}"
    local source_dir="${2:-${HOME}}"

    local target="${REPO_DIR}/${rel_target}"
    local source="${source_dir}/${rel_target}"

    if [[ -L "${source}" ]]; then
        local cur_target
        cur_target="$(readlink "${source}")"
        if [[ "${cur_target}" != "${target}" ]]; then
            warn "symbolic link already exists, which has different target: ${source} -> ${cur_target}"
            return "${WARN_EXIT_CODE}"
        fi
        trace "symbolic link already exists, skip: ${source} -> ${cur_target}"
        return
    fi

    if [[ -e "${source}" ]]; then
        warn "file already exists: ${source}"
        return "${WARN_EXIT_CODE}"
    fi

    ensure_directory_exists "$(dirname "${source}")"
    ln -s "${target}" "${source}"
    info "symbolic link created: ${source} -> ${target}"
}

ensure_symlink_to_config_not_exists() {
    local rel_target="${1}"
    local source_dir="${2:-${HOME}}"

    local target="${REPO_DIR}/${rel_target}"
    local source="${source_dir}/${rel_target}"

    if [[ -L "${source}" ]]; then
        local cur_target
        cur_target="$(readlink "${source}")"
        if [[ "${cur_target}" != "${target}" ]]; then
            warn "symbolic link already exists, which has different target: ${source} -> ${cur_target}"
            return "${WARN_EXIT_CODE}"
        fi
        rm "${source}"
        info "symbolic link removed: ${source} -> ${cur_target}"
        return
    fi

    if [[ -e "${source}" ]]; then
        warn "file already exists: ${source}"
        return
    fi

    trace "symbolik link already removed: ${source}"
}

ensure_line_in_file() {
    local line="${1}"
    local file="${2}"

    if [[ -f "${file}" ]] && grep -qFx "${line}" "${file}"; then
        trace "line already exists: ${line} in ${file}"
        return
    fi

    ensure_file_exists "${file}"
    echo "${line}" >>"${file}"
    info "line added: ${line} in ${file}"
}
