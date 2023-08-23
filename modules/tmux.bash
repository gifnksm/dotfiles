# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: tmux
        ubuntu-22.04: tmux
        rocky-9: tmux
END

    assert_command tmux

    ensure_symlink_to_config_exists .config/tmux

    # remove old symlinks
    ensure_symlink_to_config_not_exists .tmux.conf
}
group_end