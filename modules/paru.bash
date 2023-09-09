# shellcheck source-path=SCRIPTDIR/..

if [[ "${OS_ID}" == "${OS_ARCH}" ]] && ! command -v paru >/dev/null; then
    pacman_install base-devel git

    ensure_directory_exists ~/.cache/paru/clone

    ACTION="fetching paru-bin" execute git clone https://aur.archlinux.org/paru-bin.git ~/.cache/paru/clone/paru-bin
    ACTION="installing paru-bin" execute bash -c "cd ~/.cache/paru/clone/paru-bin && makepkg -si --noconfirm"

    assert_command paru
fi
