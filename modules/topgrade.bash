# shellcheck source-path=SCRIPTDIR/..
group_start_file
{
    install_package_by_spec <<END
        arch: topgrade-bin@aur
        ubuntu-22.04: topgrade@cargo
        rocky-9: topgrade@cargo
END

    assert_command topgrade

    ensure_symlink_to_config_exists .config/topgrade.d/disable_self_update.toml
}
group_end
