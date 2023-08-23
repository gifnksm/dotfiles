# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: emacs
        ubuntu-22.04: emacs
        rocky-9: emacs
END

    assert_command emacs

    ensure_symlink_to_config_exists .config/emacs

    # remove old symlinks
    ensure_symlink_to_config_not_exists .emacs.d
}
group_end
