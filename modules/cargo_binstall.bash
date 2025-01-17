# shellcheck source-path=SCRIPTDIR/..

install_module rustup

if ! command -v cargo-binstall >/dev/null; then
    case "${OS_ID}" in
    "${OS_ARCH}")
        pacman_install cargo-binstall
        ;;
    "${OS_UBUNTU_24_04}" | "${OS_DEBIAN_12}" | "${OS_ROCKY_9}")
        install_module curl
        ACTION="installing cargo-binstall" execute bash -c "curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash"
        ;;
    *)
        abort "${OS_ID} is not supported."
        ;;
    esac
fi

assert_command cargo-binstall
