# shellcheck source-path=SCRIPTDIR/..

install_module starship

install_package_by_spec <<END
    arch: nushell
    ubuntu-22.04: nu@cargo
    debian-12: nu@cargo
    rocky-9: nu@epel
END

assert_command nu

# nushell config files
ensure_symlink_to_config_exists .config/nushell
