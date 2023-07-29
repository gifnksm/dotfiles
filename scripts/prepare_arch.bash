# shellcheck source-path=SCRIPTDIR/..

is_executed && return

assert_eq "${OS_ID}" "${OS_ARCH}"

sudo pacman -Sqyu --noconfirm
