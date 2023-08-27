# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: zsh
        ubuntu-22.04: zsh
        rocky-9: zsh util-linux-user
END

    assert_command zsh

    sudo chsh -s /bin/zsh "$(id -un)"

    ensure_symlink_to_config_not_exists .zshrc # this line must be before the next line
    ensure_line_in_file "source ~/.config/zsh/zshrc" ~/.zshrc

    ensure_symlink_to_config_exists .config/zsh

    ensure_symlink_to_config_not_exists .zsh
}
group_end
