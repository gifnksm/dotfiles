# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: topgrade@aur
END

assert_command topgrade
