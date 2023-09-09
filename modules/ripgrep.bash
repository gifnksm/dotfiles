# shellcheck source-path=SCRIPTDIR/..
group_start_file
{
    install_package_by_spec <<END
        arch: ripgrep
        ubuntu-22.04: ripgrep
        rocky-9: ripgrep@epel
END

    assert_command rg
}
group_end
