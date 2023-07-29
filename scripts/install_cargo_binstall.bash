# shellcheck source-path=SCRIPTDIR/..

# requires rust toolchain
source scripts/install_rustup.bash

if ! command -v cargo-binstall >/dev/null; then
    case "${OS_ID}" in
    "${OS_ARCH}")
        pacman_install cargo-binstall
        ;;
    "${OS_UBUNTU_22_04}" | "${OS_ROCKY_9}")
        source scripts/install_curl.bash
        curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
        ;;
    *)
        abort "${OS_ID} is not supported."
        ;;
    esac
fi

assert_command cargo-binstall
