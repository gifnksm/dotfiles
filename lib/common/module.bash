# shellcheck source-path=SCRIPTDIR/../..

show_profile_file() {
    local profile="$1"
    echo "profiles/${profile}.txt"
}

show_module_file() {
    local module="$1"
    echo "modules/${module}.bash"
}

list_available_profiles() {
    local profile
    for profile in profiles/*.txt; do
        basename "${profile%.txt}"
    done | LC_ALL=C sort -u
}

list_available_modules() {
    local module
    for module in modules/*.bash; do
        basename "${module%.bash}"
    done | LC_ALL=C sort -u
}

list_installed_profiles_or_modules() {
    local module
    if ! [[ -e "${_installed_modules_file}" ]]; then
        return 0
    fi
    LC_ALL=C sort -u "${_installed_modules_file}" | grep -v '^\s*$'
}

_is_marked_as_installed() {
    local module="$1"
    [[ -e "${_installed_modules_file}" ]] && grep -q "^${module}$" "${_installed_modules_file}"
}

_mark_as_installed() {
    local module="$1"
    if _is_marked_as_installed "${module}"; then
        trace "Already marked as installed: ${module}"
        return 0
    fi

    if is_dry_run; then
        trace "Would mark as installed: ${module}"
    else
        trace "Mark as installed: ${module}"
        echo "${module}" >>"${_installed_modules_file}"
    fi
}

_unmark_as_installed() {
    local module="$1"
    if ! _is_marked_as_installed "${module}"; then
        trace "Already unmarked as installed: ${module}"
        return 0
    fi

    if is_dry_run; then
        trace "Would unmark as installed: ${module}"
    else
        trace "Unmark as installed: ${module}"
        sed -i "/^${module}$/d" "${_installed_modules_file}"
    fi
}

list_modules_in_profile() {
    local profile="$1" profile_file
    profile_file="$(show_profile_file "${profile}")"

    if ! [[ -e "${profile_file}" ]]; then
        error "Profile not found: ${profile}"
        return 1
    fi

    local -a members=()
    readarray -t members <"${profile_file}"

    local member
    for member in "${members[@]}"; do
        if [[ "${member}" =~ ^% ]]; then
            list_modules_in_profile "${member:1}"
        else
            echo "${member}"
        fi
    done
}

install_profile_or_module() {
    local profile_or_module
    for profile_or_module in "$@"; do
        if [[ "${profile_or_module}" =~ ^% ]]; then
            install_profile "${profile_or_module:1}"
        else
            install_module "${profile_or_module}"
        fi
    done
}

update_profile_or_module() {
    local profile_or_module
    for profile_or_module in "$@"; do
        if [[ "${profile_or_module}" =~ ^% ]]; then
            update_profile "${profile_or_module:1}"
        else
            update_module "${profile_or_module}"
        fi
    done
}

install_profile() {
    local profile profile_file
    for profile in "$@"; do
        if [[ -v '_handled_profiles["${profile}"]' ]]; then
            trace "Profile already handled: ${profile}"
            continue
        fi
        _handled_profiles["${profile}"]=1

        profile_file="$(show_profile_file "${profile}")"

        if ! [[ -e "${profile_file}" ]]; then
            error "Profile not found: ${profile}"
            return 1
        fi

        if is_dry_run; then
            debug "Would install profile: ${profile}"
        else
            debug "Install profile: ${profile}"
        fi

        local -a members=()
        readarray -t members < <(list_modules_in_profile "${profile}")

        for member in "${members[@]}"; do
            install_module "${member}"
        done

        _mark_as_installed "%${profile}"
    done
}

update_profile() {
    local profile profile_file
    for profile in "$@"; do
        if [[ -v '_handled_profiles["${profile}"]' ]]; then
            trace "Profile already handled: ${profile}"
            continue
        fi
        _handled_profiles["${profile}"]=1

        profile_file="$(show_profile_file "${profile}")"

        if ! [[ -e "${profile_file}" ]]; then
            warn "Profile not found: ${profile}"
            _unmark_as_installed "%${profile}"
            continue
        fi

        if is_dry_run; then
            debug "Would update profile: ${profile}"
        else
            debug "Update profile: ${profile}"
        fi

        local -a members=()
        readarray -t members < <(list_modules_in_profile "${profile}")

        for member in "${members[@]}"; do
            update_module "${member}"
        done

        _mark_as_installed "%${profile}"
    done
}

install_module() {
    local module module_file
    for module in "$@"; do
        if [[ -v '_handled_modules["${module}"]' ]]; then
            trace "Module already handled: ${module}"
            continue
        fi
        _handled_modules["${module}"]=1

        module_file="$(show_module_file "${module}")"

        if ! [[ -e "${module_file}" ]]; then
            error "Module not found: ${module}"
            return 1
        fi

        if is_dry_run; then
            debug "Would install module: ${module}"
        else
            debug "Install module: ${module}"
        fi

        # shellcheck source=/dev/null
        source "${module_file}"
        _mark_as_installed "${module}"
    done
}

update_module() {
    local module module_file
    for module in "$@"; do
        if [[ -v '_handled_modules["${module}"]' ]]; then
            trace "Module already handled: ${module}"
            continue
        fi
        _handled_modules["${module}"]=1

        module_file="$(show_module_file "${module}")"

        if ! [[ -e "${module_file}" ]]; then
            warn "Module not found: ${module}"
            _unmark_as_installed "${module}"
            continue
        fi

        if is_dry_run; then
            debug "Would update module: ${module}"
        else
            debug "Update module: ${module}"
        fi

        # shellcheck source=/dev/null
        source "${module_file}"
        _mark_as_installed "${module}"
    done
}

sort_uniq_args() {
    if [[ $# -eq 0 ]]; then
        return 0
    fi
    printf '%s\n' "$@" | LC_ALL=C sort -u
}

typeset -r _installed_modules_file=".installed_modules"
typeset -A _handled_profiles
typeset -A _handled_modules
