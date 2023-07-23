# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: tig
END

assert_command tig
