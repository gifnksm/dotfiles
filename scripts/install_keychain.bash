# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: keychain
END

assert_command keychain
