# shellcheck source-path=SCRIPTDIR/../..

_pacman_executed=false
_pacman_sync_opt() {
    local sync_opt
    if "${_pacman_executed}"; then
        sync_opt="-S"
    else
        sync_opt="-Syu"
    fi
    printf "%s" "${sync_opt}"
}

pacman_install() {
    [[ "$#" -eq 0 ]] && return

    if pacman -Q "$@" >/dev/null 2>&1; then
        debug "pacman: $* (already installed)"
        return
    fi

    local sync_opt
    sync_opt="$(_pacman_sync_opt)"

    ACTION="pacman ${sync_opt} $*" execute sudo pacman "${sync_opt}" -q --needed --noconfirm --color always "$@" >/dev/null
    _pacman_executed=true
}

_paru_executed=false
_paru_sync_opt() {
    local sync_opt
    if "${_paru_executed}"; then
        sync_opt="-S"
    else
        sync_opt="-Syu"
    fi
    printf "%s" "${sync_opt}"
}

paru_install() {
    [[ "$#" -eq 0 ]] && return

    install_module paru

    if paru -Q "$@" >/dev/null 2>&1; then
        debug "paru: $* (already installed)"
        return
    fi

    local sync_opt
    sync_opt="$(_paru_sync_opt)"

    ACTION="paru ${sync_opt} $*" execute paru "${sync_opt}" -q --needed --noconfirm --color always "$@" >/dev/null
    _paru_executed=true
}

cargo_install() {
    [[ "$#" -eq 0 ]] && return

    install_module rustup
    install_module cargo_binstall

    local package not_installed=()
    for package in "$@"; do
        if command -v cargo >/dev/null && cargo install --list | grep -q "^${package} v.*\$"; then
            debug "cargo binstall: ${package} (already installed)"
        else
            not_installed+=("${package}")
        fi
    done

    if [[ "${#not_installed[@]}" -eq 0 ]]; then
        return
    fi

    ACTION="cargo binstall $*" execute cargo binstall -y --log-level warn "$@"
}

_apt_get_executed=false
apt_get_install() {
    [[ "$#" -eq 0 ]] && return

    if dpkg -s "$@" >/dev/null 2>&1; then
        debug "apt-get: $* (already installed)"
        return
    fi

    if ! "${_apt_get_executed}"; then
        ACTION="apt-get update" execute sudo DEBIAN_FRONTEND=noninteractive apt-get -qq update >/dev/null
        _apt_get_executed=true
    fi

    ACTION="apt-get install $*" execute sudo DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends "$@" >/dev/null
}

dnf_install() {
    [[ "$#" -eq 0 ]] && return

    local package not_installed=()
    for package in "$@"; do
        if dnf list --installed "${package}" >/dev/null 2>&1; then
            debug "dnf: ${package} (already installed)"
        else
            not_installed+=("${package}")
        fi
    done

    if [[ "${#not_installed[@]}" -eq 0 ]]; then
        return
    fi

    ACTION="dnf install $*" execute sudo dnf install -qy "$@" >/dev/null
}

epel_install() {
    [[ "$#" -eq 0 ]] && return

    local package not_installed=()
    for package in "$@"; do
        if dnf list --installed "${package}" >/dev/null 2>&1; then
            debug "dnf: ${package} (already installed)"
        else
            not_installed+=("${package}")
        fi
    done

    if [[ "${#not_installed[@]}" -eq 0 ]]; then
        return
    fi

    install_module epel

    ACTION="dnf install $*" execute sudo dnf install -qy "$@" >/dev/null
}

# Encode package name containing special characters with url-encoding-like format
pkg_encode() {
    sed -zE '
        s/%/%25/g;
        s/:/%3A/g
        s/@/%40/g;
        s/ /%20/g;
        s/\n/%0A/g;
        s/\t/%09/g;
    '
}

# Decode package name containing special characters with url-encoding-like format
pkg_decode() {
    sed -zE '
        s/%3A/:/g;
        s/%40/@/g;
        s/%20/ /g;
        s/%0A/\n/;
        s/%09/\t/;
        s/%25/%/g
    '
}

_extract_package() {
    cut -d@ -f1 <<<"${1}" | pkg_decode
}
_extract_source() {
    cut -d@ -f2- -s <<<"${1}" | pkg_decode
}

install_package_arch() {
    local package_and_sources=("$@")
    local pacman_packages=()
    local aur_packages=()
    local cargo_packages=()
    local dotfiles_modules=()

    for package_and_source in "${package_and_sources[@]}"; do
        if [[ -z "${package_and_source}" ]]; then
            continue
        fi

        local package source
        package="$(_extract_package "${package_and_source}")"
        source="$(_extract_source "${package_and_source}")"

        case "${source}" in
        "" | pacman)
            pacman_packages+=("${package}")
            ;;
        aur)
            aur_packages+=("${package}")
            ;;
        cargo)
            cargo_packages+=("${package}")
            ;;
        dotfiles)
            dotfiles_modules+=("${packages}")
            ;;
        *)
            abort "invalid source '${source}' for package '${package}'"
            ;;
        esac
    done

    pacman_install "${pacman_packages[@]}"
    paru_install "${aur_packages[@]}"
    cargo_install "${cargo_packages[@]}"
    install_module "${dotfiles_modules[@]}"
}

install_package_debian() {
    local package_and_sources=("$@")
    local apt_get_packages=()
    local cargo_packages=()
    local dotfiles_modules=()

    for package_and_source in "${package_and_sources[@]}"; do
        if [[ -z "${package_and_source}" ]]; then
            continue
        fi

        local package source
        package="$(_extract_package "${package_and_source}")"
        source="$(_extract_source "${package_and_source}")"

        case "${source}" in
        "" | apt-get)
            apt_get_packages+=("${package}")
            ;;
        cargo)
            cargo_packages+=("${package}")
            ;;
        dotfiles)
            dotfiles_modules+=("${packages}")
            ;;
        *)
            abort "invalid source '${source}' for package '${package}'"
            ;;
        esac
    done

    apt_get_install "${apt_get_packages[@]}"
    cargo_install "${cargo_packages[@]}"
    install_module "${dotfiles_modules[@]}"
}

install_package_rhel() {
    local package_and_sources=("$@")
    local dnf_packages=()
    local epel_packages=()
    local cargo_packages=()
    local dotfiles_modules=()

    for package_and_source in "${package_and_sources[@]}"; do
        if [[ -z "${package_and_source}" ]]; then
            continue
        fi

        local package source
        package="$(_extract_package "${package_and_source}")"
        source="$(_extract_source "${package_and_source}")"

        case "${source}" in
        "" | dnf)
            dnf_packages+=("${package}")
            ;;
        epel)
            epel_packages+=("${package}")
            ;;
        cargo)
            cargo_packages+=("${package}")
            ;;
        dotfiles)
            dotfiles_modules+=("${packages}")
            ;;
        *)
            abort "invalid source '${source}' for package '${package}'"
            ;;
        esac
    done

    dnf_install "${dnf_packages[@]}"
    epel_install "${epel_packages[@]}"
    cargo_install "${cargo_packages[@]}"
    install_module "${dotfiles_modules[@]}"
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
            abort "invalid package spec: ${spec}"
        fi

        if ! is_supported_os "${os}"; then
            abort "invalid os '${os}' in package spec: ${spec}"
        fi

        if [[ "${os}" != "${OS_ID}" ]]; then
            continue
        fi

        case "${os}" in
        "${OS_ARCH}")
            install_package_arch "${package_and_sources[@]}"
            ;;
        "${OS_UBUNTU_24_04}" | "${OS_DEBIAN_12}")
            install_package_debian "${package_and_sources[@]}"
            ;;
        "${OS_ROCKY_9}")
            install_package_rhel "${package_and_sources[@]}"
            ;;
        *)
            abort "unexpected error: os=${os}, spec=${spec}"
            ;;
        esac

        installed=true
    done

    "${installed}" || abort "no package is installed by spec for OS ${OS_ID}."
}
