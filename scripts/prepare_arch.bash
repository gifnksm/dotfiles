# shellcheck source-path=SCRIPTDIR/..

assert_eq "${OS_ID}" "${OS_ARCH}"

sudo pacman -Syu --noconfirm
