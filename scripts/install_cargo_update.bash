# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: cargo-update
END

assert_command cargo-install-update
