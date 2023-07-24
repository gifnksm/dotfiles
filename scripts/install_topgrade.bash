# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: topgrade@aur
    ubuntu_22_04: topgrade@cargo
END

assert_command topgrade
