# shellcheck source-path=SCRIPTDIR/..
group_start_file
{
    if [[ "${OS_ID}" == "${OS_ROCKY_9}" ]]; then
        dnf_install epel-release
    fi
}
group_end
