# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: skim
END

assert_command sk
