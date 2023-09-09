# shellcheck source-path=SCRIPTDIR/..

set -eu -o pipefail

readonly ERROR_EXIT_CODE=1
readonly WARN_EXIT_CODE=0

is_github_actions() {
    [[ "${GITHUB_ACTIONS:-}" = "true" ]]
}
is_gha_debug_mode() {
    is_github_actions && [[ "${RUNNER_DEBUG:-}" = 1 ]]
}

readonly LOG_LEVEL_ERROR=0
readonly LOG_LEVEL_WARN=1
readonly LOG_LEVEL_INFO=2
readonly LOG_LEVEL_DEBUG=3
readonly LOG_LEVEL_TRACE=4

_timestamp() { date '+%Y-%m-%d %H:%M:%S.%3N'; }
error() {
    if is_github_actions; then
        _update_group
        echo "::error::$*" >&2
    fi
    if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_ERROR}" ]]; then
        _update_group
        echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[31;1mERROR\e[m]" "$@" >&2
    fi
}
warn() {
    if is_github_actions; then
        _update_group
        echo "::warning::$*" >&2
    fi
    if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_WARN}" ]]; then
        _update_group
        echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[33;1mWARN\e[m]" "$@" >&2
    fi
}
info() {
    if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_INFO}" ]]; then
        _update_group
        echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[32;1mINFO\e[m]" "$@" >&2
    fi
}
debug() {
    if is_gha_debug_mode; then
        _update_group
        echo "::debug::$*" >&2
    fi
    if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_DEBUG}" ]]; then
        _update_group
        echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[36;1mDEBUG\e[m]" "$@" >&2
    fi
}
trace() {
    if is_gha_debug_mode; then
        _update_group
        echo "::debug::$*" >&2
    fi
    if [[ "${LOG_LEVEL}" -ge "${LOG_LEVEL_TRACE}" ]]; then
        _update_group
        echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[30;1mTRACE\e[m]" "$@" >&2
    fi
}

typeset -a _groups=()
if [[ -n "${GROUP_PREFIX:-}" ]]; then
    _groups=("${GROUP_PREFIX}")
fi
typeset _last_group_str="${GROUP_PREFIX:-}"
reset_last_group() {
    _last_group_str="${GROUP_PREFIX:-}"
}
show_current_group() {
    local IFS='/'
    echo "${_groups[*]}"
}
_update_group() {
    if ! is_github_actions; then
        return
    fi

    local group_str
    group_str="$(show_current_group)"

    # GitHub Actions does not support nested group, so close previous group before start new group
    if [[ "${group_str}" != "${_last_group_str}" ]]; then
        echo "::endgroup::" >&2
        if [[ -n "${group_str}" ]]; then
            echo "::group::${group_str}" >&2
        fi
        _last_group_str="${group_str}"
    fi
}

group_start() {
    local -r name="${1}"
    _groups+=("${name}")
}
group_end() {
    _groups=("${_groups[@]:0:${#_groups[@]}-1}")
}

print_backtrace() {
    local start="${1:-0}"
    local i="${start}" line file func
    while read -r line func file < <(caller "${i}"); do
        local number="$((i - start))"
        echo -e "[${number}] \e[32;1m$func()\e[m"
        echo "  at $file:$line"
        for ((j = line - 2; j <= line + 2; j++)); do
            if ((j <= 0)); then
                continue
            fi
            local marker
            if ((j == line)); then
                marker=">\e[1m"
            else
                marker="|"
            fi
            echo -en "    ${j} ${marker} "
            echo -n "$(sed -n "${j}p" "${file}")"
            echo -e "\e[m"
        done
        ((i += 1))
    done
}

abort() {
    local -r message="${1:-}"
    if [[ -n "${message}" ]]; then
        error "program aborted: ${message}"
    else
        error "program aborted"
    fi
    print_backtrace 1 | sed 's/^/    /' >&2
    exit "${ERROR_EXIT_CODE}"
}

set_log_level() {
    local level="${1}"
    case "${level}" in
    0 | error) LOG_LEVEL="${LOG_LEVEL_ERROR}" ;;
    1 | warn) LOG_LEVEL="${LOG_LEVEL_WARN}" ;;
    2 | info) LOG_LEVEL="${LOG_LEVEL_INFO}" ;;
    3 | debug) LOG_LEVEL="${LOG_LEVEL_DEBUG}" ;;
    4 | trace) LOG_LEVEL="${LOG_LEVEL_TRACE}" ;;
    *)
        LOG_LEVEL="${LOG_LEVEL_INFO}"
        abort "invalid log level: ${level}"
        ;;
    esac
}

set_log_level "${LOG_LEVEL:-info}" # You can set log-level by environment variable

DRY_RUN=0

set_dry_run() {
    case "${1}" in
    "" | 0 | false) DRY_RUN=0 ;;
    1 | true) DRY_RUN=1 ;;
    *)
        abort "invalid dry-run: ${1}"
        ;;
    esac
}

is_dry_run() {
    [[ "${DRY_RUN}" -eq 1 ]]
}

execute() {
    if [[ -v ACTION ]]; then
        if [[ -n "${ACTION}" ]]; then
            info "${ACTION}"
        fi
    else
        info "executing: $*"
    fi

    if ! is_dry_run; then
        "$@"
    fi
}

trap '_on_error $?' ERR
_on_error() {
    local exitcode="${1:-}"
    error "program aborted by error: exitcode=${exitcode}"
    print_backtrace 1 | sed "s/^/    /" >&2
}

REPO_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"
readonly REPO_DIR

_init_check_pwd() {
    [[ "$(pwd)" = "${REPO_DIR}" ]] || abort "current directory is not REPO_DIR: $(pwd) != ${REPO_DIR}"
}

source lib/common/assert.bash
source lib/common/os.bash
source lib/common/fs.bash
source lib/common/git.bash
source lib/common/package.bash
source lib/common/module.bash

_init_check_pwd
_init_os
