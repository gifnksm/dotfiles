# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: zoxide
    ubuntu-22.04: zoxide
    debian-12: zoxide
    rocky-9: zoxide@cargo
END

assert_command zoxide
