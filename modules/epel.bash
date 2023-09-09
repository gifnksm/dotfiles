# shellcheck source-path=SCRIPTDIR/..

if [[ "${OS_ID}" == "${OS_ROCKY_9}" ]]; then
    dnf_install epel-release
fi
