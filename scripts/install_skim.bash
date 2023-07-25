# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: skim
    ubuntu_22_04: skim@cargo
    rocky_9: skim@cargo
END

assert_command sk
