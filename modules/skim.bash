# shellcheck source-path=SCRIPTDIR/..
group_start_file
{
    install_package_by_spec <<END
        arch: skim
        ubuntu-22.04: skim@cargo
        rocky-9: skim@cargo
END

    assert_command sk
}
group_end
