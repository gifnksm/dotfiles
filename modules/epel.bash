# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    if [[ "${OS_ID}" == "${OS_ROCKY_9}" ]]; then
        dnf_install epel-release
    fi
}
group_end
