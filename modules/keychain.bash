# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: keychain
    ubuntu-22.04: keychain
    debian-11: keychain
    rocky-9: keychain@epel
END

assert_command keychain
