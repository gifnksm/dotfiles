# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: rhq@cargo
        ubuntu-22.04: rhq@cargo
        rocky-9: rhq@cargo
END

    assert_command rhq

    ensure_file_exists ~/.config/rhq/config.toml
}
group_end
