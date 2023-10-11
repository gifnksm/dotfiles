# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: emacs
    ubuntu-22.04: emacs
    debian-12: emacs
    rocky-9: emacs
END

assert_command emacs

ensure_symlink_to_config_exists .config/emacs

# remove old symlinks
ensure_symlink_to_config_not_exists .emacs.d
