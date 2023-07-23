# shellcheck source-path=SCRIPTDIR/..

assert_eq "${OS_NAME}" "${OS_ARCH_LINUX}"

sudo pacman -Syu --noconfirm
