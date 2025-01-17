# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: tig
    ubuntu-24.04: tig
    debian-12: tig
    rocky-9: tig@epel
END

assert_command tig
