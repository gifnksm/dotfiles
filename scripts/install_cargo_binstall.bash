# shellcheck source-path=SCRIPTDIR/..

if ! command -v cargo-binstall >/dev/null; then
    case "${OS_NAME}" in
    "${OS_ARCH_LINUX}")
        pacman_install cargo-binstall
        ;;
    "${OS_UBUNTU_22_04}" | "${OS_ROCKY_LINUX_9}")
        curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
        ;;
    *)
        error "${OS_NAME} is not supported."
        return "${ERROR_EXIT_CODE}"
        ;;
    esac
fi

assert_command cargo-binstall
