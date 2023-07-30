is_executed && return

is_supported_os() {
    local os_id="${1}"
    case "${os_id}" in
    "${OS_ARCH}" | "${OS_UBUNTU_22_04}" | "${OS_ROCKY_9}") return 0 ;;
    *) return 1 ;;
    esac
}

_print_os_id() {
    (
        # Run in a subshell to avoid polluting the current shell
        # shellcheck source=/dev/null
        source /etc/os-release

        case "${ID}" in
        arch)
            # Ignore $VERSION_ID
            #
            # $VERSION_ID is specified for Arch docker images, but not for non-docker environments.
            # https://gitlab.archlinux.org/archlinux/archlinux-docker/-/blob/56bb99f5ad26f03ab6ea2984f83b4383bb68a2d2/Dockerfile.base
            echo "${ID}"
            ;;
        *)
            if [[ -v ID_LIKE ]] && (grep -qw "rhel" <<<"${ID_LIKE}"); then
                # For RHEL family OS, ignore minor version
                echo "${ID}-$(cut -d. -f1 <<<"${VERSION_ID}")"
                return
            fi
            echo "${ID}-${VERSION_ID}"
            ;;
        esac
    )
}

_init_check_os_id() {
    is_supported_os "${OS_ID}" || abort "${OS_ID} is not supported."
}

_init_os() {
    _init_check_os_id
}

readonly OS_ARCH="arch"
readonly OS_UBUNTU_22_04="ubuntu-22.04"
readonly OS_ROCKY_9="rocky-9"
OS_ID="$(_print_os_id)"
readonly OS_ID
