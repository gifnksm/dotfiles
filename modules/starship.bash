# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    install_package_by_spec <<END
        arch: starship
        ubuntu-22.04: starship@cargo
        rocky-9: starship@cargo
END

    assert_command starship

    ensure_symlink_to_config_exists .config/starship.toml
}
group_end
