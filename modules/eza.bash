# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: eza
    ubuntu-24.04: eza@cargo
    debian-12: eza@cargo
    rocky-9: eza@cargo
END

assert_command eza
