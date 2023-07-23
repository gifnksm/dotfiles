# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: starship
END

assert_command starship

ensure_symlink_to_config_exists .config/starship.toml