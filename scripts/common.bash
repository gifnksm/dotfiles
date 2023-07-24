# shellcheck source-path=SCRIPTDIR/..

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
            echo -e "    ${j} ${marker} $(sed -n "${j}p" "$file")\e[m"
        done
        ((i += 1))
    done
}

trap '_on_error' ERR

_on_error() {
    print_backtrace 1 | sed "s/^/    /" >&2
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

_print_os_name() {
    source /etc/os-release
    if [[ -v VERSION_ID ]]; then
        echo "${NAME} ${VERSION_ID}"
        return
    fi
    echo "${NAME}"
}

_init_check_repo_dir() {
    if ! [[ -v REPO_DIR ]]; then
        error "REPO_DIR is not set."
        return "${ERROR_EXIT_CODE}"
    fi
    if ! [[ -d "${REPO_DIR}" ]]; then
        error "REPO_DIR is not a directory: ${REPO_DIR}"
        return "${ERROR_EXIT_CODE}"
    fi
}

_init_check_os() {
    info "OS: ${OS_NAME}"
    case "${OS_NAME}" in
    "${OS_ARCH_LINUX}" | "${OS_UBUNTU_22_04}") ;;
    *)
        error "${OS_NAME} is not supported."
        return "${ERROR_EXIT_CODE}"
        ;;
    esac
}

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

pacman_install() {
    info "pacman install: $*"
    sudo pacman -S --needed --noconfirm --color always "$@"
}

paru_install() {
    info "paru install: $*"
    paru -S --needed --noconfirm --color always "$@"
}

cargo_install() {
    info "cargo binstall: $*"
    cargo binstall -y "$@"
}

apt_get_install() {
    info "apt-get install: $*"
    sudo apt-get install -y --no-install-recommends "$@"
}

# Usage: install_package_by_spec <<END
#     <os1>: <package1-1> <package1-2> ...
#     <os2>: <package2-1>@<source2-1> ...
#     ...
# END
install_package_by_spec() {
    local spec installed=false
    while read -r spec; do
        if [[ -z "${spec}" ]]; then
            continue
        fi

        local os package_and_sources
        os="$(cut -d: -f1 <<<"${spec}")"
        read -ra package_and_sources <<<"$(cut -d: -f2- <<<"${spec}")"
        if [[ -z "${os}" ]]; then
            error "invalid package spec: ${spec}"
            return "${ERROR_EXIT_CODE}"
        fi

        local package_and_source
        for package_and_source in "${package_and_sources[@]}"; do
            if [[ -z "${package_and_source}" ]]; then
                continue
            fi

            local package source
            package="$(cut -d@ -f1 <<<"${package_and_source}")"
            source="$(cut -d@ -f2- -s <<<"${package_and_source}")"
            if [[ -z "${package}" ]]; then
                error "invalid package spec: ${spec}"
                return "${ERROR_EXIT_CODE}"
            fi

            case "${os}" in
            arch)
                if [[ "${OS_NAME}" = "${OS_ARCH_LINUX}" ]]; then
                    installed=true
                    case "${source}" in
                    "" | "pacman")
                        pacman_install "${package}"
                        break
                        ;;
                    "aur")
                        source scripts/install_paru.bash
                        paru_install "${package}"
                        break
                        ;;
                    "cargo")
                        source scripts/install_rustup.bash
                        cargo_install "${package}"
                        break
                        ;;
                    *)
                        error "invalid source '${source}' for package '${package}' in spec: ${spec}"
                        return "${ERROR_EXIT_CODE}"
                        ;;
                    esac
                fi
                ;;
            ubuntu_22_04)
                if [[ "${OS_NAME}" = "${OS_UBUNTU_22_04}" ]]; then
                    installed=true
                    case "${source}" in
                    "" | "apt-get")
                        apt_get_install "${package}"
                        break
                        ;;
                    "cargo")
                        source scripts/install_rustup.bash
                        cargo_install "${package}"
                        break
                        ;;
                    *)
                        error "invalid source '${source}' for package '${package}' in spec: ${spec}"
                        return "${ERROR_EXIT_CODE}"
                        ;;
                    esac
                fi
                ;;
            *)
                error "invalid os '${os}' in package spec: ${spec}"
                return "${ERROR_EXIT_CODE}"
                ;;
            esac
        done
    done

    if ! "${installed}"; then
        error "no package is installed by spec for OS ${OS_NAME}."
        return "${ERROR_EXIT_CODE}"
    fi
}

readonly ERROR_EXIT_CODE=1
readonly WARN_EXIT_CODE=0

readonly OS_ARCH_LINUX="Arch Linux"
readonly OS_UBUNTU_22_04="Ubuntu 22.04"
OS_NAME="$(_print_os_name)"
readonly OS_NAME

_init_check_repo_dir
_init_check_os
