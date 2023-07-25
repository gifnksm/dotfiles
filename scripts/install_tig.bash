# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: tig
    ubuntu_22_04: tig
    rocky_9: tig
END

assert_command tig
