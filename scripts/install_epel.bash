# shellcheck source-path=SCRIPTDIR/..

assert_eq "${OS_ID}" "${OS_ROCKY_9}"

dnf_install epel-release
