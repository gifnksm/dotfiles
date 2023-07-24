# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: vim
    ubuntu_22_04: vim
END

assert_command vim

ensure_symlink_to_config_exists .vim

# remove old symlinks
ensure_symlink_to_config_not_exists .vimrc
