# shellcheck source-path=SCRIPTDIR/..
is_executed && return

group_start_file
{
    # requires rust toolchain
    install_module rustup

    install_package_by_spec <<END
        arch: cargo-update
        ubuntu-22.04: cargo-update@cargo
        rocky-9: cargo-update@cargo
END

    assert_command cargo-install-update
}
group_end
