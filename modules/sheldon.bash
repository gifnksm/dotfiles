# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: sheldon
    ubuntu-22.04: sheldon@cargo
    debian-11: sheldon@cargo
    rocky-9: sheldon@cargo
END

assert_command sheldon

ensure_symlink_to_config_exists .config/sheldon
