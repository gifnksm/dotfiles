# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: topgrade-bin@aur
    ubuntu-24.04: topgrade@cargo
    debian-12: topgrade@cargo
    rocky-9: topgrade@cargo
END

assert_command topgrade

ensure_symlink_to_config_exists .config/topgrade.d/disable_self_update.toml
