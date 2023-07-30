is_executed && return

assert_eq() {
    local -r expected="${1}"
    local -r actual="${2}"
    local -r message="${3:-}"

    if [[ "${expected}" != "${actual}" ]]; then
        if [[ -n "${message}" ]]; then
            abort "assertion failure: ${message} ('${expected}' == '${actual}')"
        else
            abort "assertion failure: '${expected}' == '${actual}'"
        fi
    fi
}

assert_command() {
    local -r command="${1}"
    local -r message="${2:-}"

    if ! command -v "${command}" >/dev/null; then
        if [[ -n "${message}" ]]; then
            abort "assertion failure: ${message} (command not found: ${command})"
        else
            abort "assertion failure: command not found: ${command}"
        fi
    fi
}
