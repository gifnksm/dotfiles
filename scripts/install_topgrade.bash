# shellcheck source-path=SCRIPTDIR/..

is_executed && return

install_package_by_spec <<END
    arch: topgrade@aur
    ubuntu-22.04: topgrade@cargo
    rocky-9: topgrade@cargo
END

assert_command topgrade
