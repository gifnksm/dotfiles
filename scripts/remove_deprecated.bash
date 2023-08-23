# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    ensure_symlink_to_config_not_exists .colordiffrc
}
group_end
