# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: starship
    ubuntu-24.04: starship@cargo
    debian-12: starship@cargo
    rocky-9: starship@cargo
END

assert_command starship

ensure_symlink_to_config_exists .config/starship.toml
