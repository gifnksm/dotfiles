# shellcheck source-path=SCRIPTDIR/..

is_executed && return

ensure_symlink_to_config_not_exists .colordiffrc
