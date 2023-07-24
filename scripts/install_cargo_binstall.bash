# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: cargo-binstall
END

assert_command cargo-binstall
