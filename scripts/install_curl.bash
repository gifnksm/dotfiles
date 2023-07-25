# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: curl
    ubuntu_22_04: curl ca-certificates
    rocky_9: curl-minimal
END

assert_command curl
