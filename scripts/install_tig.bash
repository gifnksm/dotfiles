# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: tig
    ubuntu-22.04: tig
    rocky-9: tig
END

assert_command tig
