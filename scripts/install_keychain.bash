# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: keychain
    ubuntu_22_04: keychain
    rocky_9: keychain
END

assert_command keychain
