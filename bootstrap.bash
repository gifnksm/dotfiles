set -eux -o pipefail

ARCHIVE_URL="${ARCHIVE_URL:-https://github.com/gifnksm/dotfiles/archive/refs/heads/master.tar.gz}"
DOTFILES_PATH="${DOTFILES_PATH:-${HOME}/.local/share/dotfiles}"

main() {
    if [[ -d "${DOTFILES_PATH}" ]]; then
        echo "dotfiles is already installed: ${DOTFILES_PATH}"
        exit 0
    fi

    if ! command -v curl >/dev/null; then
        echo "curl is not installed"
        exit 1
    fi

    if ! command -v tar >/dev/null; then
        echo "tar is not installed"
        exit 1
    fi

    local tmpdir
    tmpdir="$(mktemp -d)"

    local -a proto_options=()
    if ! [[ -v NO_PROTO_CHECK ]]; then
        proto_options+=("--proto" "=https")
    fi
    curl -L "${proto_options[@]}" --tlsv1.2 -sSf "${ARCHIVE_URL}" | tar -xvz -C "${tmpdir}" --strip-components=1

    mkdir -pv "$(dirname "${DOTFILES_PATH}")"
    mv -v "${tmpdir}" "${DOTFILES_PATH}"

    "${DOTFILES_PATH}/install" "$@"
}

main "$@"