# shellcheck source-path=SCRIPTDIR/..

if ! command -v curl >/dev/null; then
    install_package_by_spec <<END
        arch: curl
        ubuntu-22.04: curl ca-certificates
        debian-11: curl ca-certificates
        rocky-9: curl-minimal
END
fi

assert_command curl
