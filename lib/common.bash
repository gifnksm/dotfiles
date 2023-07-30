# shellcheck source-path=SCRIPTDIR/..

[[ "$(type -t is_executed)" = "function" ]] && return

set -eu -o pipefail

readonly ERROR_EXIT_CODE=1
readonly WARN_EXIT_CODE=0

_timestamp() { date '+%Y-%m-%d %H:%M:%S.%3N'; }
error() { echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[31;1mERROR\e[m]" "$@" >&2; }
warn() { echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[33;1mWARN\e[m]" "$@" >&2; }
info() { echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[32;1mINFO\e[m]" "$@" >&2; }
debug() { echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[36;1mDEBUG\e[m]" "$@" >&2; }
trace() { echo -e "\e[30;1m$(_timestamp)\e[m" "[\e[30;1mTRACE\e[m]" "$@" >&2; }

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

trap '_on_error' ERR
_on_error() {
    print_backtrace 1 | sed "s/^/    /" >&2
}

declare -A _executed_files=()
is_executed() {
    local source key source_rel
    source="$(realpath "${BASH_SOURCE[1]}")"
    key="$(md5sum <<<"${source}" | cut -d ' ' -f 1)"
    source_rel="${source#"${REPO_DIR}/"}"
    if [[ -v '_executed_files[${key}]' ]]; then
        trace "already executed: ${source_rel}"
        return 0
    fi
    debug "executing: ${source_rel}"
    _executed_files["${key}"]="${source}"
    return 1
}

REPO_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"
readonly REPO_DIR

_init_check_pwd() {
    [[ "$(pwd)" = "${REPO_DIR}" ]] || abort "current directory is not REPO_DIR: $(pwd) != ${REPO_DIR}"
}

source lib/common/assert.bash
source lib/common/os.bash
source lib/common/fs.bash
source lib/common/package.bash

_init_check_pwd
_init_os
