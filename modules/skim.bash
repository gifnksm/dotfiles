# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: skim
    ubuntu-22.04: skim@cargo
    debian-11: skim@cargo
    rocky-9: skim@cargo
END

assert_command sk
