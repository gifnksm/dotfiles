# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: cargo-update
    ubuntu_22_04: cargo-update@cargo
END

assert_command cargo-install-update
