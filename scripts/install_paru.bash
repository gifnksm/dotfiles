# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    if [[ "${OS_ID}" == "${OS_ARCH}" ]] && ! command -v paru >/dev/null; then
        pacman_install base-devel git

        ensure_directory_exists ~/.cache/paru/clone
        git clone https://aur.archlinux.org/paru-bin.git ~/.cache/paru/clone/paru-bin

        (cd ~/.cache/paru/clone/paru-bin && makepkg -si --noconfirm)
    fi
}
group_end