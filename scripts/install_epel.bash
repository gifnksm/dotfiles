# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    assert_eq "${OS_ID}" "${OS_ROCKY_9}"

    dnf_install epel-release
}
group_end
