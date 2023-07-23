# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: bat
END

assert_command bat
