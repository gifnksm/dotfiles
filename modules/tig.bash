# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: tig
        ubuntu-22.04: tig
        rocky-9: tig@epel
END

    assert_command tig
}
group_end
