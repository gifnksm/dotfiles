# shellcheck source-path=SCRIPTDIR/../..

is_executed && return

list_available_modules() {
    local module
    for module in modules/*.bash; do
        basename "${module%.bash}"
    done | sort -u
}

list_installed_modules() {
    local module
    if ! [[ -e "${INSTALLED_MODULES_FILE}" ]]; then
        return 0
    fi
    sort -u "${INSTALLED_MODULES_FILE}"
}

add_to_installed_modules() {
    local module="$1"
    if [[ -e "${INSTALLED_MODULES_FILE}" ]]; then
        if grep -q "^${module}$" "${INSTALLED_MODULES_FILE}"; then
            return 0
        fi
    fi
    echo "${module}" >>"${INSTALLED_MODULES_FILE}"
    readarray -t INSTALLED_MODULES < <(list_installed_modules)
}

install_module() {
    local module
    for module in "$@"; do
        local module_file="modules/${module}.bash"

        if ! [[ -e "${module_file}" ]]; then
            error "Module not found: ${module}"
            return 1
        fi

        # shellcheck source=/dev/null
        source "${module_file}"
        add_to_installed_modules "${module}"
    done
}

sort_uniq_args() {
    if [[ $# -eq 0 ]]; then
        return 0
    fi
    printf '%s\n' "$@" | sort -u
}

typeset -r INSTALLED_MODULES_FILE=".installed_modules"
typeset -a AVAILABLE_MODULES
readarray -t AVAILABLE_MODULES < <(list_available_modules)
export AVAILABLE_MODULES
typeset -a INSTALLED_MODULES
readarray -t INSTALLED_MODULES < <(list_installed_modules)
export INSTALLED_MODULES
