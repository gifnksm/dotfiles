# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: keychain
        ubuntu-22.04: keychain
        rocky-9: keychain@epel
END

    assert_command keychain
}
group_end
