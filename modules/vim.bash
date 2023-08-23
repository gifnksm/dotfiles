# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: vim
        ubuntu-22.04: vim
        rocky-9: vim
END

    assert_command vim

    ensure_symlink_to_config_exists .vim

    # remove old symlinks
    ensure_symlink_to_config_not_exists .vimrc
}
group_end
