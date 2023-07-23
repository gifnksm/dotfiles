# shellcheck source-path=SCRIPTDIR/..

assert_eq "${OS_NAME}" "${OS_ARCH_LINUX}"

if ! command -v paru >/dev/null; then
    pacman_install base-devel git

    ensure_directory_exists ~/.cache/paru/clone
    git clone https://aur.archlinux.org/paru-bin.git ~/.cache/paru/clone/paru-bin

    (cd ~/.cache/paru/clone/paru-bin && makepkg -si --noconfirm)
fi
