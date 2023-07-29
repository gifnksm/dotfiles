# shellcheck source-path=SCRIPTDIR/..

is_executed && return

assert_eq "${OS_ID}" "${OS_ROCKY_9}"

sudo dnf update -qy
