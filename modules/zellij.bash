# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: zellij
    ubuntu-24.04: zellij@cargo
    debian-12: zellij@cargo
    rocky-9: zellij@cargo
END

assert_command zellij

ensure_symlink_to_config_exists .config/zellij
