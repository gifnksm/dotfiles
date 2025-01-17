# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: vim
    ubuntu-24.04: vim
    debian-12: vim
    rocky-9: vim
END

assert_command vim

ensure_symlink_to_config_exists .vim

# remove old symlinks
ensure_symlink_to_config_not_exists .vimrc
