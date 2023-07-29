# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: curl
    ubuntu-22.04: curl ca-certificates
    rocky-9: curl-minimal
END

assert_command curl
