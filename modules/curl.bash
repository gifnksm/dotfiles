# shellcheck source-path=SCRIPTDIR/..
group_start_file
{
    if ! command -v curl >/dev/null; then
        install_package_by_spec <<END
            arch: curl
            ubuntu-22.04: curl ca-certificates
            rocky-9: curl-minimal
END
    fi

    assert_command curl
}
group_end
