set -eu -o pipefail

ARCHIVE_URL="${ARCHIVE_URL:-https://github.com/gifnksm/dotfiles/archive/refs/heads/main.tar.gz}"
REPOSITORY_URL=https://github.com/gifnksm/dotfiles.git
DOTFILES_PATH="${DOTFILES_PATH:-${HOME}/.local/share/dotfiles}"

main() {
    if [[ -d "${DOTFILES_PATH}" ]]; then
        echo "dotfiles is already installed: ${DOTFILES_PATH}"
        "${DOTFILES_PATH}/install" "$@"
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

    if [[ -z "${NO_GIT_CLONE:-}" ]] && command -v git >/dev/null; then
        git clone -q --depth=1 "${REPOSITORY_URL}" "${DOTFILES_PATH}"
    else
        local tmpdir
        tmpdir="$(mktemp -d)"

        local -a proto_options=()
        if [[ -z "${NO_PROTO_CHECK:-}" ]]; then
            proto_options+=("--proto" "=https")
        fi
        curl -L "${proto_options[@]}" --tlsv1.2 -sSf "${ARCHIVE_URL}" | tar -xz -C "${tmpdir}" --strip-components=1

        mkdir -p "$(dirname "${DOTFILES_PATH}")"
        mv "${tmpdir}" "${DOTFILES_PATH}"
    fi

    "${DOTFILES_PATH}/install" "$@"
}

main "$@"
