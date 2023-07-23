# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: rhq@cargo
END

assert_command rhq

ensure_file_exists ~/.config/rhq/config.toml
