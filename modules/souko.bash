# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: souko-bin@aur
    ubuntu-22.04: souko@cargo
    debian-12: souko@cargo
    rocky-9: souko@cargo
END

assert_command souko
