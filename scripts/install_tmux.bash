# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: tmux
    ubuntu_22_04: tmux
END

assert_command tmux

ensure_symlink_to_config_exists .config/tmux

# remove old symlinks
ensure_symlink_to_config_not_exists .tmux.conf
