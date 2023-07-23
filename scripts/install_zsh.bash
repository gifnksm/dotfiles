# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: zsh
END

assert_command zsh

sudo chsh -s /bin/zsh "$(id -un)"

ensure_symlink_to_config_exists .zshrc
ensure_symlink_to_config_exists .zsh