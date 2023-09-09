typeset -A _created_directories=(
    ["/"]=1
)
ensure_directory_exists() {
    local dir="${1}"

    if [[ -d "${dir}" ]]; then
        trace "directory already exists: ${dir}"
        return
    fi

    if is_dry_run; then
        # cache created directories to avoid outputting too many logs
        if [[ -v '_created_directories["${dir}"]' ]]; then
            trace "directory already created: ${dir}"
            return
        fi

        local parent_dir="${dir}"
        while ! [[ -v '_created_directories["${parent_dir}"]' ]]; do
            _created_directories["${parent_dir}"]=1
            parent_dir="$(dirname "${parent_dir}")"
        done
    fi

    ACTION="creating directory: ${dir}" execute mkdir -p "${dir}"
}

ensure_file_exists() {
    local file="${1}"

    if [[ -f "${file}" ]]; then
        trace "file already exists: ${file}"
        return
    fi

    ensure_directory_exists "$(dirname "${file}")"
    ACTION="creating file: ${file}" execute touch "${file}"
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
    local action="creating symbolic link: ${source} -> ${target}"
    if [[ -v SUDO ]]; then
        ACTION="${action}" execute sudo ln -s "${target}" "${source}"
    else
        ACTION="${action}" execute ln -s "${target}" "${source}"
    fi
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
    ACTION="creating symbolic link: ${source} -> ${target}" execute ln -s "${target}" "${source}"
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
        ACTION="removing symbolic link: ${source} -> ${cur_target} " execute rm "${source}"
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

    ACTION="adding '${line}' to ${file}" execute bash -c "echo '${line}' >>'${file}'"
}

ensure_login_shell() {
    local shell="${1}"
    local user_name current_shell
    user_name="$(id -un)"
    current_shell="$(getent passwd "${user_name}" | cut -d: -f7)"

    if [[ "${current_shell}" == "${shell}" ]]; then
        trace "login shell is already ${shell}"
        return
    fi

    ACTION="changing ${user_name}'s login shell: ${current_shell} -> ${shell}" execute sudo chsh -s "${shell}" "${user_name}"
}
