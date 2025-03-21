# shellcheck source-path=SCRIPTDIR/..

install_module rustup

install_package_by_spec <<END
    arch: cargo-update
    ubuntu-24.04: cargo-update@cargo
    debian-12: cargo-update@cargo
    rocky-9: cargo-update@cargo
END

assert_command cargo-install-update
